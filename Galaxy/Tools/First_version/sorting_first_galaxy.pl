#!/usr/bin/perl -w

$|=1;
use warnings;
use strict;

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

if(@ARGV < 2){
print "\nUsage: sorting_promoters_by_first_position.pl fimo.gff fimo-position-sorted.gff e\n\n";
exit(0);
}

my $counter=0;
open(FIMO, "<$ARGV[0]") ||
    die "File '$ARGV[0]' not found\n";
open(OUTPUT, ">$ARGV[1]") ||
    die "File '>$ARGV[1]' not found\n";
    
while (<FIMO>) {
    $line=$_;
    chomp $line;
    @cols=split;
    
    if ($line=~/^#/){
        printf OUTPUT "%s\n", $line;
        $counter++;
    }
    else {
        $gene=substr $cols[0],0,21;
        $pos1 = $cols[3];
        $TF= substr $cols[8],5,8;
        $scalar= scalar @list1;
        if (not exists $hash1{$gene}{$TF} and not $scalar == 0) {
            $n= scalar @list1;
            my @list_pos_sorted= sort { $list1[$a] <=> $list1[$b] } 0..($n - 1);
            for (my $i=0; $i <(scalar @list_pos_sorted); $i++){
                $index=$list_pos_sorted[$i];
                $position = $list1[$index];
                printf OUTPUT "%s\n", $hash2{$position};
                #print $list2[$index], "\n";
                $counter++;
            }
        }
        if (not exists $hash1{$gene}{$TF}) {
           %hash1=();
           %hash2=();
           @list1=();
           @list2=();
           $hash1{$gene}{$TF}=1;
           $hash2{$pos1}=$line;
           push @list1, $pos1;
           push @list2, $line;       
        }
       
        elsif (exists $hash1{$gene}{$TF}) {
           $hash2{$pos1}=$line;
           push @list1, $pos1;
           push @list2, $line;
        }
        
        
    }
  
}

$n= scalar @list1;
my @list_pos_sorted= sort { $list1[$a] <=> $list1[$b] } 0..($n - 1);
            for (my $i=0; $i <(scalar @list_pos_sorted); $i++){
                $index=$list_pos_sorted[$i];
                $position = $list1[$index];
                printf OUTPUT "%s\n", $hash2{$position};
                #print $list2[$index], "\n";
                $counter++;
            }
#print $counter;
