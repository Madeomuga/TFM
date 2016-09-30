#!/usr/bin/perl -w
$|=1;
use warnings;
use strict;

#Script that takes a gff format file from MEME suite as input and orders it by genes,
#so it will create an output with all the information grouped by genes. Motifs will be mixed.

#Declaration of variables
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
my $counter=0;#it gives you the number of lines of the gff file. It is a good way to check that the information is not lost.

#Files that I am going to use

if(@ARGV < 2){
print "\nUsage: step1.pl fimo.gff fimo-position-sorted.gff e\n\n"; 
exit(0);
}

#I open both files, FIMO as the input and OUTPUT as the ouput.
open(FIMO, "<$ARGV[0]") ||
    die "File '$ARGV[0]' not found\n";
open(OUTPUT, ">$ARGV[1]") ||
    die "File '>$ARGV[1]' not found\n";


while (<FIMO>) {
    $line=$_; #assigning line to variable $line | $_ is a special default variable that here holds the line contents
    chomp $line;  #avoid \n on last field
    @cols=split; #Splits the string EXPR into a list of strings and returns the list in list context, or the size of the list in scalar context.
                #This is very useful because the data of the gff file can be called using this variable.
    
    if ($line=~/^#/){ #prints the first line of the gff file that is different from the rest
        printf OUTPUT "%s\n", $line;
        $counter++;
    }
    else { #considers the other lines of the file
        $gene=substr $cols[0],0,21; #variable that returns the name of the gene of the line
        $pos1 = $cols[3]; #variable that returns the motif's start position on the gene
        $TF= substr $cols[8],5,8; #variable that returns the name of the motif
        
        #I use two arrays (list1 and list2) list1 returns the name of the genes and list2 the lines with all the information.
        #Notice that the gene and its line will have the same position in both list.
        if (not exists $hash1{$gene}{$TF}{$pos1}) {
           $hash1{$gene}{$TF}{$pos1}=1;
           push @list1, $gene;
           push @list2, $line;       
        }
    
    }
  
}

#In this section I sort the list1 (genes) by the name of the genes, so I will take the position of every gene sorted
#and I will use the position to print out the lines in the order that I want. The main function of this script
#is to write the gff file but having the genes sorted by blocks.
$n= scalar @list1;
my @list_pos_sorted= sort { $list1[$a] cmp $list1[$b] } 0..($n - 1);
            for (my $i=0; $i <(scalar @list_pos_sorted); $i++){
                $index=$list_pos_sorted[$i];
                $position = $list1[$index];
                #print $hash2{$position};
                printf OUTPUT "%s\n", $list2[$index];
                $counter++;
            }
print $counter;
