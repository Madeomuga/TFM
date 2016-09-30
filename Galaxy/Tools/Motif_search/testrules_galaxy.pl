#!/usr/bin/perl -w

$|=1;
use warnings;
use strict;
#Script that looks for genes that have motifs from a certain rule.

#Declaration of variables
my %hash;
my $line;
my @cols;
my @pos;
my @motif;
my @genes;
my $pos1;
my $gene;
my $TF;
my $current_gene;
my $size;

if(@ARGV < 2){
print "\nUsage: testrules_galaxy.pl fimo.gff testrules.gff \n\n";
exit(0);
}

open(FIMO, "<$ARGV[0]") ||
    die "File '$ARGV[0]' not found\n";
open(OUTPUT, ">$ARGV[1]") ||
    die "File '$ARGV[1]' not found\n";

$current_gene="";
        
while (<FIMO>) {
    $line=$_;
    @cols=split;
    $TF= substr $cols[8],5,8; 
    $gene=substr $cols[0],0,21;
    $pos1 = $cols[3];
    $size=scalar @motif;
    if (not exists $hash{$gene} ) {
        
        if ($current_gene ne "") {
            printf OUTPUT $current_gene;
            printf OUTPUT " ";
            printf OUTPUT "=>";
            printf OUTPUT "\t"; 
        }
        for (my $i=0;$i<$size;$i++){
            printf OUTPUT $motif[$i];
            printf OUTPUT "($pos[$i])";
            printf OUTPUT "\t";
        }
        printf OUTPUT "\n";
        @motif=();
        @pos=();
        $current_gene=$gene;
        push @motif,$TF;
        push @pos, $pos1;
        
        $hash{$gene}=1;
           
        
    }
   
    else {
        push @motif,$TF;
        push @pos, $pos1;
    }
        
    }

$size=scalar @motif;
printf OUTPUT $current_gene;
printf OUTPUT " ";
printf OUTPUT "=>";
printf OUTPUT "\t";   
for (my $i=0;$i<$size;$i++){
            printf OUTPUT $motif[$i];
            printf OUTPUT"($pos[$i])";
            printf OUTPUT "\t";
        }   


