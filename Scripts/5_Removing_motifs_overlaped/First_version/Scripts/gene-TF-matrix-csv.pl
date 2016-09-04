#!/usr/bin/perl -w
use strict;
use warnings;



# Script to create csv formatted gene vs TF matrix from a filtered gff
# file. GFF file can contain just Positive or Just neagtive strand
# TFBS. Has two types of matrix produced: (0) resence/Abscence with only
# 1 and 0s. With option=0. (1) counts of TFs with numbers 1,3,5 etc. 


#Created: 16/05/2016: Amadeo
#Updated: 31/05/2016: Sue: to create 2 input options and csv formatted
#matrix file.

my $line;
my $line3;
my @cols;
my @TF_array;
my @gene_array;
my %matrix_1= ();
my %matrix_2= ();
my $TF;
my $gene;
my %matrix;
my $matrixType;

$ARGV[0]='C:\Users\sstuff\Desktop\positive.gff';
$ARGV[1]='C:\Users\sstuff\Desktop\matrix+.csv';
$ARGV[2]=<STDIN>;
if(@ARGV < 3){
print "\nUsage: gene-TF-matrix.pl fimo-nol-P.gff/fimo-nol-N.gff gene-matrix-P.csv/gene-matrix-N.csv 
\n Options: Presence/Abscence=0 counts=1\n\n";
exit(0);
}
open (FIMO, "$ARGV[0]") || 
    die "File '$ARGV[0]' not found\n" ;
open(MATRIX, ">$ARGV[1]") ||
    die "File '>$ARGV[1]' not found\n";

$matrixType = $ARGV[2];
print "MatrixTYpe is $matrixType\n";
   
#Put all the motifs and genes in two separate arrays: each appears
#only once in each array.
while (<FIMO>) {
    $line=$_;   
     if ($line!~/^##/) {#ignore header line
       @cols=split;
       $TF= substr $cols[8],5,8;
       if (not exists $matrix_1{$TF}) {
	 $matrix_1{$TF}="";
	 push @TF_array, $TF;
       }
       $gene=substr $cols[0],0,21;
        if (not exists $matrix_2{$gene}) { 
	  $matrix_2{$gene}="";
	  push @gene_array, $gene
	}
     }
  }

my $n_motifs=scalar @TF_array;
my $n_genes=scalar@gene_array;
#printf "Scalar motifs is %d\n", scalar@TF_array;
#printf "Scalar genes is %d\n", scalar@gene_array;

close(FIMO);
#I want to create a hash on which each gene has a list of 0s. Then I want to "read" the .gff file
#and if a gene has a certain TF it will add "+1" to the possition of the TF, and it will look like this.


open (FIMO, "$ARGV[0]") || 
   die "File '$ARGV[0]' not found\n" ;
   
#$matrix{"PGSC0003DMG400006788"}=(0,0,1,0,2,0,3,0,0,...,0)

#Filling 2d gene/motif array with zeros to start
foreach my $element (@gene_array){
  my @auxilary_list = ();
  for (my $i=1; $i <= $n_motifs; $i++){
   $auxilary_list[$i-1] =0;
  }
  $matrix{$element}=\@auxilary_list;
}

#This is how I want to read the .gff file and check if a gene has a certain TF. I dont consider the positions yet. I just
# want to see if this first step works.

while (<FIMO>){
  $line3 = $_;
  if ($line3!~/^##/) {
    for (my $j=0; $j < scalar@gene_array; $j++){  
      for (my $h=0; $h < scalar@TF_array; $h++){
	#printf "Genes[%d] -%s-  Motifs[%d] -%s- \n",$j, $gene_array[$j], $h, $TF_array[$h]; 
	if (($line3 =~/$gene_array[$j]/) and ($line3 =~/$TF_array[$h]/)) {      
            if ($matrixType ==0){${$matrix{$gene_array[$j]}}[$h]=1;}
	    if ($matrixType ==1){${$matrix{$gene_array[$j]}}[$h]++;}
	} 
      }
    }
  }
}

printf MATRIX "Gene,";
for (my $h=0; $h < scalar@TF_array; $h++){
    if ($h!=scalar@TF_array-1) {
    printf MATRIX  "$TF_array[$h],";
    }
    else{printf MATRIX  "$TF_array[$h]"}
}   
printf MATRIX "\n";
foreach my $element(sort keys %matrix){
    printf MATRIX  "$element,";
    for (my $r=0; $r<scalar@{$matrix{$element}};$r++){
        if ($r!=scalar@{$matrix{$element}}-1) {
            printf MATRIX "$matrix{$element}[$r],"
        }
        else{printf MATRIX "$matrix{$element}[$r]"}
        
    }
    printf MATRIX "\n"
}

