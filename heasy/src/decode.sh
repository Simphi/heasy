#!/bin/bash
#
#   Copyright 2013 CSIR Meraka HLT and Multilingual Speech Technologies (MuST) North-West University
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

# Author: Charl van Heerden (cvheerden@csir.co.za)
#
# Given a model list and grammar, uses the most recently created hmm set to
# do recognition (type of recognition determined by grammar)
set -eu

EXPECTED_NUM_ARGS=3
MAX_NUM_ARGS=4
E_BAD_ARGS=65

if [ $# -lt $EXPECTED_NUM_ARGS ]; then
  echo "Usage: ./decode.sh <model list> <grammar> <dict> [mlf]"
  printf "\n\t%s\n" "Performs decoding given a model list, grammar and dictionary."
  printf "\t%s\n\n" "Automatically finds the latest hmm and searches for transforms."
  printf "\t%-4s $bold_begin%-12s$bold_end\t%s\n" "" "model list  " "- List of physical hmms (usually tiedlist)"
  printf "\t%-4s $bold_begin%-12s$bold_end\t%s\n" "" "grammar     " "- Recognition network"
  printf "\t%-4s $bold_begin%-12s$bold_end\t%s\n" "" "dict        " "- Pronunciation dictionary relating tokens in grammar to hmms in model list"
  printf "\t%-4s $bold_begin%-12s$bold_end\t%s\n" "" "mlf         " "- Optional output label file."
  printf "\t%-4s $bold_begin%-12s$bold_end\t%s\n" "" "            " '  Otherwise default to $DIR_EXP/results/test_results.mlf'
  printf "\n"
  exit $E_BAD_ARGS
fi

LOCAL_LIST_MODELS=$1
LOCAL_GRAMMAR=$2
LOCAL_DICT=$3
LOCAL_MLF_RESULTS=$MLF_RESULTS  # Added for backward compatibility 

if [ $# -eq $MAX_NUM_ARGS ]; then
  LOCAL_MLF_RESULTS=$4
fi

#-----------------------------------------------------------------------------

#Check if input valid

if [ ! -s $LOCAL_GRAMMAR ]; then
  echo "ERROR: Grammar ($lOCAL_GRAMMAR) doesn't exist";
  exit 1;
fi

if [ ! -s $LOCAL_LIST_MODELS ]; then
  echo "ERROR: Model list doesn't exist ($LOCAL_LIST_MODELS)";
  exit 1;
fi

LOCAL_RESULTS_DIR=`dirname $LOCAL_MLF_RESULTS`
if [ ! -d $LOCAL_RESULTS_DIR ]; then
  echo "ERROR: Results directory doesn't exist ($LOCAL_RESULTS_DIR)";
  exit 1;
fi

#-----------------------------------------------------------------------------

# TODO: How should we handle transforms? Different script? Or autodetect?
# For now, try to autodetect

# (1) Find the latest hmm (will be stored in DIR_HMM_CURR)
source $DIR_SRC/inc_hmm_cnt.sh auto_update

# (2) See if this model uses transforms
XFORM=""
for i in $(cat $DIR_HMM_CURR/hmmDefs.mmf | grep "XFORM" | awk '{print $2}' | sed 's/\"//g' | xargs -I {} basename {})
do
  ADD=`find $DIR_EXP/models -iname "$i"`
  XFORM="$XFORM -J "`dirname $ADD`
done

if [ $NUM_HEREST_PROCS -eq 1 ]; then
  HVite -C $CFG_HVITE -A -D -T 1 -V -o N -H $DIR_HMM_CURR/hmmDefs.mmf -H $DIR_HMM_CURR/macros $XFORM -S $LIST_AUDIO_TST -t $MAINBEAM -s $GRAMMAR_SCALE -p $INS_PENALTY -w $LOCAL_GRAMMAR -i $LOCAL_MLF_RESULTS $LOCAL_DICT $LOCAL_LIST_MODELS
else
  cd $DIR_SCRATCH
  mkdir -p hvite_lists
  rm -f hvite_lists/*
  cd hvite_lists
  perl $DIR_SRC/split.pl $LIST_AUDIO_TST $NUM_HEREST_PROCS $DIR_SCRATCH/hvite_lists
  cnt=1
  for list in `ls *`
  do
  HVite -C $CFG_HVITE -A -D -T 1 -V -o N -H $DIR_HMM_CURR/hmmDefs.mmf -H $DIR_HMM_CURR/macros $XFORM -S $list -t $MAINBEAM -s $GRAMMAR_SCALE -p $INS_PENALTY -w $LOCAL_GRAMMAR -i $list.mlf $LOCAL_DICT $LOCAL_LIST_MODELS &
  done
  wait
  cat *.mlf > $LOCAL_MLF_RESULTS
  cat *.log
fi

#-----------------------------------------------------------------------------

