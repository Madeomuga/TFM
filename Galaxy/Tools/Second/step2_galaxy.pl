#!/usr/bin/perl -w
$|=1;
use warnings;
use strict;

#Script that takes a gff format file from step1.pl as input and orders
#each block of gene data by the start position of the motif.

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
my $counter=0; #it gives you the number of lines of the gff file. It is a good way to check that the information is not lost.

#Files that I am going to use

if(@ARGV < 2){
print "\nUsage: step2.pl fimo-gene-sorted.gff fimo-gene-&-position-sorted.gff e\n\n";
exit(0);
}

#I open both files, FIMO as the input and OUTPUT as the ouput.
open(FIMO, "$ARGV[0]") ||
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
        $pos1 = $cols[3]; #variable that returns the motif's first position on the gene
        $TF= substr $cols[8],5,8; #variable that returns the name of the motif
        $scalar= scalar @list1; #returns the size of the current list1
        
        #This script stores infromation in two arrays (list1 and list2). The first one will register the first position of the motif in the
        #gene and the list2 will store the corresponding line.
        
        if (not exists $hash1{$gene} and not $scalar == 0) { #Every time that a new gene is considered in the loop, it will print out
                                                            #all the information of the previous one
            
            #This section will print out each line of each block of genes sorted by the first position.
            $n= scalar @list1;
            my @list_pos_sorted= sort { $list1[$a] <=> $list1[$b] } 0..($n - 1); #This will sort the POSITION NUMBERS of the array
                                                                                    #list1 and store them in a new array name
              
            #This will print out the information of each gene sorted by the first position.                                                                      #list_pos_sorted
            for (my $i=0; $i <(scalar @list_pos_sorted); $i++){
                $index=$list_pos_sorted[$i]; 
                #$position = $list1[$index];
                #printf OUTPUT "%s\n",$hash2{$position};
                printf OUTPUT "%s\n", $list2[$index];
                $counter++;
            }
        }
        if (not exists $hash1{$gene}) {#Every time that a new gene is considered in the loop, it will reset the variables
                                                            #so a new gene can be registered
           %hash1=();
           %hash2=();
           @list1=();
           @list2=();
           $hash1{$gene}=1;
           $hash2{$pos1}=$line;
           push @list1, $pos1;
           push @list2, $line;       
        }
       
        elsif (exists $hash1{$gene}) { #if the next line has information of the same gene, it will
                                        #store the information in the arrays.
           $hash2{$pos1}=$line;
           push @list1, $pos1;
           push @list2, $line;
        }
        
        
    }
  
}

#Section that has the same structure of the previous one to print the LAST block of the file.
$n= scalar @list1;
my @list_pos_sorted= sort { $list1[$a] <=> $list1[$b] } 0..($n - 1);
            for (my $i=0; $i <(scalar @list_pos_sorted); $i++){
                $index=$list_pos_sorted[$i];
                $position = $list1[$index];
                printf OUTPUT "%s\n", $hash2{$position};
                #printf OUTPUT "%s\n", $list2[$index];
                $counter++;
            }
print $counter;
