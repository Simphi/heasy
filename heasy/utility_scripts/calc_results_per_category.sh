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

set -eu

#--------------------------------------------------------------------------
# Author: Marelie Davel (mdavel@csir.co.za)
#--------------------------------------------------------------------------

#Calculate separate results based on the different noise categories of the 
#test files, based on transcription markings.

#LOCAL VARIABLES 
DIR_EXP=~/current/zulu/exp02
DIR_SCRIPTS=$DIR_EXP/../heasy/utility_scripts
DIR_ORIG_TRANSCRIPTS=/home/asrdata/corpora/lwazi_isizulu_1_0/transcriptions

LIST_TRANS_TST=$DIR_EXP/lists/trans_tst.lst
DECODED_MLF=$DIR_EXP/results/test_result_ip_-14.5.mlf
REFERENCE_MLF=$DIR_EXP/mlfs/monophones_tst.mlf
LIST_MONOPHONES=$DIR_EXP/lists/monophones.lst

LIST_NOISE_PREFIX=$DIR_EXP/lists/noise_lists
MLF_DECODED_PREFIX=$DIR_EXP/mlfs/noise_dec
MLF_REF_PREFIX=$DIR_EXP/mlfs/noise_ref
RESULT_PREFIX=$DIR_EXP/results/noise_result

#--------------------------------------------------------------------------

#ID transcriptions containing noise markers"
$DIR_SCRIPTS/id_noise.pl $LIST_TRANS_TST $DIR_ORIG_TRANSCRIPTS $LIST_NOISE_PREFIX 

for noise_cat in n s clean um; do

  #Select appropriate subsets from the reference and decoded MLFs
  $DIR_SCRIPTS/select_sub_mlf.pl $LIST_NOISE_PREFIX.$noise_cat $DECODED_MLF rec ${MLF_DECODED_PREFIX}_${noise_cat}.mlf
  $DIR_SCRIPTS/select_sub_mlf.pl $LIST_NOISE_PREFIX.$noise_cat $REFERENCE_MLF lab ${MLF_REF_PREFIX}_${noise_cat}.mlf

  #Score each category separately
  HResults -A -D -T 1 -V -s -z sil -I ${MLF_REF_PREFIX}_${noise_cat}.mlf $LIST_MONOPHONES ${MLF_DECODED_PREFIX}_${noise_cat}.mlf > ${RESULT_PREFIX}_$noise_cat.scores

done 

grep WORD ${RESULT_PREFIX}_*.scores

#--------------------------------------------------------------------------

