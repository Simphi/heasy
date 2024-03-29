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
#         Neil Kleynhans (ntkleynhans@csir.co.za)
# 
# This script will generate all the necessary config files
#
# IMPORTANT:
#  - This script is not intended to be called manually
set -eu
EXPECTED_NUM_ARGS=2

if [ $# -lt $EXPECTED_NUM_ARGS ]; then
    echo "Usage: $0 <FLAG> <CONFIG_FILE>"
    echo "<FLAG> - flag name associated with a HTK config file"
    echo "<CONFIG_FILE> - output config file which contents will be written to"
    exit 1
fi

FLAG=$1
CFG=$2

if [ $FLAG = 'hcopy' ]; then
  echo "CEPLIFTER       =	$CEPLIFTER" > $CFG
  echo "ENORMALISE      =	$ENORMALISE" >> $CFG
  echo "NUMCEPS         =	$NUMCEPS" >> $CFG
  echo "NUMCHANS        =	$NUMCHANS" >> $CFG
  echo "PREEMCOEF       =	$PREEMCOEF" >> $CFG
  echo "SAVECOMPRESSED  =	$SAVECOMPRESSED" >> $CFG
  echo "SAVEWITHCRC     =	$SAVEWITHCRC" >> $CFG
  echo "SOURCEFORMAT    =	$SOURCEFORMAT" >> $CFG
  echo "TARGETKIND      =	$TARGETKIND" >> $CFG
  echo "TARGETRATE      =	$TARGETRATE" >> $CFG
  echo "USEHAMMING      =	$USEHAMMING" >> $CFG
  echo "WINDOWSIZE      =	$WINDOWSIZE" >> $CFG
  echo "ZMEANSOURCE     =	$ZMEANSOURCE" >> $CFG
  echo "LOFREQ          =       $LOFREQ" >> $CFG
  echo "HIFREQ          =       $HIFREQ" >> $CFG
fi

if [ $FLAG = 'hvite' ]; then
  echo "ALLOWXWRDEXP    =	T" > $CFG
  echo "FORCECXTEXP     =	T" >> $CFG
  echo "NONUMESCAPES    = T" >> $CFG
fi

if [ $FLAG = 'herest' ]; then
  echo "Creating herest.cfg: NOTHING DONE HERE"
  echo "" > $CFG
fi

if [ $FLAG = 'semit' ]; then
  echo "IN SEMIT"
  echo "HADAPT:TRACE                  = $HADAPT_TRACE" > $CFG
  echo "HADAPT:TRANSKIND              = $HADAPT_TRANSKIND" >> $CFG
  echo "HADAPT:USEBIAS                = $HADAPT_USEBIAS" >> $CFG
  echo "HADAPT:BASECLASS              = $HADAPT_BASECLASS" >> $CFG
  echo "HADAPT:ADAPTKIND              = $HADAPT_ADAPTKIND" >> $CFG
  echo "HADAPT:SPLITTHRESH            = $HADAPT_SPLITTHRESH" >> $CFG
  echo "HADAPT:SEMITIEDMACRO          = $HADAPT_SEMITIEDMACRO" >> $CFG
  echo "HADAPT:MAXXFORMITER           = $HADAPT_MAXXFORMITER" >> $CFG
  echo "HADAPT:MAXSEMITIEDITER        = $HADAPT_MAXSEMITIEDITER" >> $CFG
  echo "HMODEL:SAVEBINARY             = $HMODEL_SAVEBINARY" >> $CFG
  echo "HMODEL:TRACE                  = $HMODEL_TRACE" >> $CFG
fi

if [ $FLAG = 'hcompv' ]; then
  echo "CEPLIFTER       =	$CEPLIFTER" > $CFG
  echo "ENORMALISE      =	$ENORMALISE" >> $CFG
  echo "NUMCEPS         =	$NUMCEPS" >> $CFG
  echo "NUMCHANS        =	$NUMCHANS" >> $CFG
  echo "PREEMCOEF       =	$PREEMCOEF" >> $CFG
  echo "SAVECOMPRESSED  =	$SAVECOMPRESSED" >> $CFG
  echo "SAVEWITHCRC     =	$SAVEWITHCRC" >> $CFG
  echo "TARGETKIND      =	$TARGETKIND" >> $CFG
  echo "TARGETRATE      =	$TARGETRATE" >> $CFG
  echo "USEHAMMING      =	$USEHAMMING" >> $CFG
  echo "WINDOWSIZE      =	$WINDOWSIZE" >> $CFG
fi

if [ $FLAG = 'mllr_mean' ]; then
  echo "HADAPT:TRANSKIND = MLLRMEAN" >> $CFG
  echo "HADAPT:USEBIAS = TRUE" >> $CFG
  echo "HADAPT:REGTREE = $REG_TREE_FILE"  >> $CFG
  echo "HADAPT:ADAPTKIND = TREE" >> $CFG
  echo "HADAPT:SPLITTHRESH = 1000.0" >> $CFG
  echo "HADAPT:KEEPXFORMDISTINCT = TRUE" >> $CFG
  echo "HADAPT:TRACE = 61" >> $CFG
  echo "HMODEL:TRACE = 512" >> $CFG
fi

if [ $FLAG = 'mllr_cov' ]; then
  echo "HADAPT:TRANSKIND = MLLRCOV" >> $CFG
  echo "HADAPT:USEBIAS = FALSE" >> $CFG
  echo "HADAPT:REGTREE = $REG_TREE_FILE" >> $CFG
  echo "HADAPT:ADAPTKIND = TREE" >> $CFG
  echo "HADAPT:SPLITTHRESH = 1000.0" >> $CFG
  echo "HADAPT:KEEPXFORMDISTINCT = TRUE" >> $CFG
  echo "HADAPT:TRACE = 61" >> $CFG
  echo "HMODEL:TRACE = 512" >> $CFG
fi

if [ $FLAG = 'cmllr' ]; then
  echo "HADAPT:TRANSKIND = CMLLR" >> $CFG
  echo "HADAPT:USEBIAS = TRUE" >> $CFG
  echo "HADAPT:REGTREE = $REG_TREE_FILE"  >> $CFG
  echo "HADAPT:ADAPTKIND = TREE" >> $CFG
  echo "HADAPT:SPLITTHRESH = 1000.0" >> $CFG
  echo "HADAPT:KEEPXFORMDISTINCT = TRUE" >> $CFG
  echo "HADAPT:TRACE = 61" >> $CFG
  echo "HMODEL:TRACE = 512" >> $CFG
fi

if [ $FLAG = 'mkphns_led' ]; then
  echo "EX" > $CFG
  echo "IS sil sil" >> $CFG
  echo "DE sp" >> $CFG
fi

if [ $FLAG = 'mkphns_sp_led' ]; then
  echo "EX" > $CFG
  echo "IS sil sil" >> $CFG
fi

if [ $FLAG = 'mkwords_led' ]; then
  echo "EX" > $CFG
  echo "IS sil sil" >> $CFG
  echo "DE sp" >> $CFG
fi

if [ $FLAG = 'mkbi_led' ]; then
  echo "RC" > $CFG
  echo "WB sp" >> $CFG
  echo "WB sil" >> $CFG
fi

if [ $FLAG = 'mktri_led' ]; then
  echo "WB sp" > $CFG
  echo "WB sil" >> $CFG
  echo "TC" >> $CFG
fi

if [ $FLAG = 'mkbixword_led' ]; then
  echo "RC" > $CFG
  echo "WB sp" >> $CFG
  echo "NB sp" >> $CFG
fi

if [ $FLAG = 'mktrixword_led' ]; then
  echo "TC" > $CFG
  echo "WB sp" >> $CFG
  echo "NB sp" >> $CFG
fi

if [ $FLAG = 'sil_hed' ]; then
  echo "AT 2 4 0.2 {sil.transP}" > $CFG
  echo "AT 4 2 0.2 {sil.transP}" >> $CFG
  echo "AT 1 3 0.3 {sp.transP}" >> $CFG
  echo "TI silst {sil.state[3],sp.state[2]}" >> $CFG
fi

if [ $FLAG = 'mkbi_hed' ]; then
  echo "ERROR: TODO"
fi

if [ $FLAG = 'mktri_hed' ]; then
  echo "Creating $CFG"
  #perl $DIR_SRC/maketrihed.pl $LIST_MONOPHNS $LIST_TRI $CFG
    perl $DIR_SRC/clone_tie_tri_hed.pl $LIST_MONOPHNS $LIST_TRI $CFG
fi

if [ $FLAG = 'mix_inc_hed' ]; then
  echo "MU +$MIX_INCREMENT {*.state[2-4].mix}" > $CFG
fi

if [ $FLAG = 'regtree_hed' ]; then
  echo "LS \"$STATS\"" > $CFG
  echo "RC 40 \"regtree_2\" {(sil,sp).state[1-6].mix}" >> $CFG
fi

if [ $FLAG = 'globol_mono_ded' ]; then
  echo "IR"  > $CFG
  echo "AS sp" >> $CFG
  echo "RS cmu" >> $CFG
  echo "MP sil sil sp" >> $CFG
fi

if [ $FLAG = 'global_word_ded' ]; then
  echo "IR" > $CFG
  echo "AS sp" >> $CFG
  echo "RS cmu" >> $CFG
  echo "MP sil sil sp" >> $CFG
fi

if [ $FLAG = 'global_bi_ded' ]; then
  echo "AS sp" > $CFG
  echo "DP sp" >> $CFG
  echo "RC" >> $CFG
  echo "MP sil sil sp" >> $CFG
fi

if [ $FLAG = 'global_tri_ded' ]; then
  echo "RS cmu" > $CFG
  echo "AS sp" >> $CFG
  echo "DP sp" >> $CFG
  echo "TC" >> $CFG
  echo "MP sil sil sp" >> $CFG
fi

if [ $FLAG = 'realign_ded' ]; then
  echo "IR" > $CFG
  echo "AS sp" >> $CFG
  echo "RS cmu" >> $CFG
  echo "MP sil sil sp" >> $CFG
  echo "RP sil sp" >> $CFG
fi
if [ $FLAG = 'global_tst_ded' ]; then
  echo "AS sp" > $CFG
  echo "RS cmu" >> $CFG
  echo "MP sil sil sp" >> $CFG
  echo "DP sp" >> $CFG
fi

if [ $FLAG = 'pcf' ]; then

echo "proto" > $DIR_SCRATCH/proto.lst

cat << EOF > $CFG
<BEGINproto_config_file>

<COMMENT>
   This PCF produces a single mixture, single stream prototype system

<BEGINsys_setup>

hsKind: P
covKind: D
nStates: 3
nStreams: 1
sWidths: 39
mixes: 1
parmKind: $TARGETKIND
vecSize: 39
outDir: $DIR_EXP/models
hmmList: $DIR_SCRATCH/proto.lst

<ENDsys_setup>

<ENDproto_config_file>
EOF

fi

