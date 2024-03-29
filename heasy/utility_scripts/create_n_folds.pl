#!/usr/bin/perl
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

use warnings;
use strict;
use List::Util 'shuffle';
use open IO => ':encoding(utf8)';
binmode STDOUT, ":utf8";

if (scalar(@ARGV) != 4) {
  print "Usage: ./create_n_folds.pl <in:mfccs.lst> <in:trans.lst> <par:num_folds> <out:out_dir>\n\n";
  print "	Info:	* splits speakers randomly (%%%_Female*.xxx)\n";
  print "		* expects an mfccs and trans list'\n";
  print "		* males and females will be balanced across folds'\n";
  print "		* Assumes all basenames are unique'\n\n";

  print "	<mfccs.lst>	- list of mfccs\n";
  print "	<trans.lst>	- list of transcriptions\n";
  print "	<num_folds>	- number of folds to divide data into\n";
  print "	<out_dir>	- directory into which lists will be saved\n\n";
  exit 1;
}

my $fn_mfccs  = $ARGV[0];
my $fn_trans  = $ARGV[1];
my $num_folds = $ARGV[2];
my $dir_out   = $ARGV[3];

my %mfccs;
my %trans;
my %gender;
my %basenames;

# -----------------------------------------------------------------------------
# Read the info from the files
# -----------------------------------------------------------------------------

my $line;
open MFCCS, "$fn_mfccs" or die "Can't open '$fn_mfccs' for reading!\n";
open TRANS, "$fn_trans" or die "Can't open '$fn_trans' for reading!\n";
while(<MFCCS>) {
  chomp($line = $_);
  my @tokens = split(/\//,$line);
  my $basename = pop @tokens;
  $basename =~ s/\.[[:alnum:]]*$//g;
  @tokens = split(/\_/,$basename);
  my $spk = $tokens[0];
  my $gnd = $tokens[1];
  $mfccs{$spk}{$basename} = $line;
  $gender{$gnd}{$spk} = 1;
  $basenames{$basename} = 1;
}
close(MFCCS);

while(<TRANS>) {
  chomp($line = $_);
  my @tokens = split(/\//,$line);
  my $basename = pop @tokens;
  $basename =~ s/\.[[:alnum:]]*$//g;
  @tokens = split(/\_/,$basename);
  my $spk = $tokens[0];
  my $gnd = $tokens[1];
  $trans{$spk}{$basename} = $line;
  $gender{$gnd}{$spk} = 1;
  $basenames{$basename} = 1;
}
close(TRANS);

# -----------------------------------------------------------------------------
# Remove all files/speakers not common in all lists
# -----------------------------------------------------------------------------
foreach my $basename (sort keys %basenames) {
  my @tokens = split(/\_/,$basename);
  my $spk = $tokens[0];
  if (!exists($mfccs{$spk}{$basename})) {
    print "Warning: '$basename' not found in audio!\n";
    delete $trans{$spk}{$basename};
    delete $basenames{$basename};
  }

  if (!exists($trans{$spk}{$basename})) {
    print "Warning: '$basename' not found in transcriptions!\n";
    delete $mfccs{$spk}{$basename};
    delete $basenames{$basename};
  }
}

# -----------------------------------------------------------------------------
# Divide speakers into folds
# -----------------------------------------------------------------------------
my %folds;
my $cnt = 1;
foreach my $gender (sort keys %gender) {
  my @speakers = keys %{ $gender{$gender} };
  my @rand_speakers = shuffle @speakers;
  foreach my $spk (@rand_speakers) {
    push @{ $folds{$cnt} }, $spk;
    $cnt += 1;
    if ($cnt > $num_folds) { $cnt = 1; }
  }
}

print "Number of speakers per test fold...\n";
print "<fold>:<num spks>\n";
foreach my $fold (sort keys %folds) {
  printf "$fold: %d\n", scalar(@{ $folds{$fold} });
}

# -----------------------------------------------------------------------------
# Create output lists
# -----------------------------------------------------------------------------
foreach my $tst_fold (sort keys %folds) {
  open AUDIO_TRN, ">$dir_out/audio_trn.$tst_fold.lst" or die "Can't open '$dir_out/audio_trn.$tst_fold.lst' for writing!\n";
  open AUDIO_TST, ">$dir_out/audio_tst.$tst_fold.lst" or die "Can't open '$dir_out/audio_tst.$tst_fold.lst' for writing!\n";
  open TRANS_TRN, ">$dir_out/trans_trn.$tst_fold.lst" or die "Can't open '$dir_out/trans_trn.$tst_fold.lst' for writing!\n";
  open TRANS_TST, ">$dir_out/trans_tst.$tst_fold.lst" or die "Can't open '$dir_out/trans_tst.$tst_fold.lst' for writing!\n";
  foreach my $all_folds (sort keys %folds) {
    foreach my $spk (@{ $folds{$all_folds} }) {
      # Final (probably redundant) test
      my @basenames = sort keys %{ $mfccs{$spk} };
      foreach my $basename (@basenames) {
        if (!exists($trans{$spk}{$basename})) { print "ERROR: '$basename' missing from transcriptions!\n"; exit 1; }
	if ($all_folds == $tst_fold) {
          print AUDIO_TST "$mfccs{$spk}{$basename}\n";
          print TRANS_TST "$trans{$spk}{$basename}\n";
        } else {
          print AUDIO_TRN "$mfccs{$spk}{$basename}\n";
          print TRANS_TRN "$trans{$spk}{$basename}\n";
	}
      }
    }
  }
  close(AUDIO_TRN);
  close(AUDIO_TST);
  close(TRANS_TRN);
  close(TRANS_TST);
}
