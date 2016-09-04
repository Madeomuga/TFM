#!/usr/bin/perl -w
$|=1;
use warnings;
use strict;

#Script that takes a gff format file as input and orders it by genes,
#so it will create an output with all the information grouped by genes. Motifs will be mixed.

my $line;
my @cols;
my %hash1;
my %hash2;
my @list1;
my @list2;
my $gene;
my $pos1;
my $n;
my $index;
my $position;
my $scalar;
my $TF;
$ARGV[0]="c:/Users/sstuff/Desktop/motif_search.gff";
$ARGV[1]="c:/Users/sstuff/Desktop/motif_search-position-sorted.gff";

if(@ARGV < 2){
print "\nUsage: step1.pl fimo.gff motif_search-position-sorted.gff e\n\n";
exit(0);
}

my $counter=0;
open(FIMO, "$ARGV[0]") ||
    die "File '$ARGV[0]' not found\n";
open(OUTPUT, ">$ARGV[1]") ||
    die "File '>$ARGV[1]' not found\n";
    
while (<FIMO>) {
    $line=$_;
    chomp $line;
    @cols=split;
    
    if ($line=~/^ /){
        printf OUTPUT "%s\n", $line;
        $counter++;
    }
    else {
        $gene=substr $cols[0],0,21;
        $pos1 = $cols[3];
        $TF= substr $cols[8],5,8;
        if (not exists $hash1{$gene}{$TF}{$pos1}) {
           $hash1{$gene}{$TF}{$pos1}=1;
           push @list1, $gene;
           push @list2, $line;       
        }
    
    }
  
}

$n= scalar @list1;
my @list_gen_sorted= sort { $list1[$a] cmp $list1[$b] } 0..($n - 1);
            for (my $i=0; $i <(scalar @list_gen_sorted); $i++){
                $index=$list_gen_sorted[$i];
                $position = $list1[$index];
                #print $hash2{$position};
                printf OUTPUT "%s\n", $list2[$index];
                $counter++;
            }
print $counter;
