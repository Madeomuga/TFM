#!/usr/bin/perl -w


$|=1;
use strict; #using this makes debugging your code much easier
use warnings;


#Script to take a list of JASPAR ids and extract a subset of matrix information for each of them from the JASPAR_CORE_2016.meme file

#Checking to see if the user has provided 3 arguments 



if(@ARGV < 3){
print "\nUsage: Extract_matrix_subset.pl list-motifs.txt JAPSAR_CORE_2016.meme JASPAR_AME_subset.meme\n\n";
exit(0);
}

my $motif_id; 
my $line; 
my @lines;
my %matrix=();
my $header;
my $data;
my @header_list_motif;
my $line2;



open (MOTIF, "<$ARGV[0]") || 
   die "File '$ARGV[0]' not found\n" ;

open (JASPAR, "<$ARGV[1]") || 
   die "File '$ARGV[1]' not found\n" ;

open (OUTPUT, ">$ARGV[2]") || 
   die "File '$ARGV[2]' not found\n" ;


@lines=<JASPAR>;


#In this loop I "delete" the 9 first lines of the JASPAR-database from @lines and store them in a new array called @header_list_motif,
#that will be the header of the output file (I am doing this because I had errors on my hash because of the header lines).
for (my $i = 0; $i < 9; $i++) {
    $line2 = shift @lines;
    push (@header_list_motif, $line2);
}

#Once I delete the first 9 lines, I create a hash with the motifs
#as keys and the data as values.
foreach $line(@lines){
    if ($line =~ /^MO/) { 
      $header = $line;
    }        
    else {
      push( @{$matrix{$header}}, $line);
}
} 
    
#I use this to test if the number of motifs of my motif list are the same of the motifs
#of my output file.
#my $counter =0; 

#Print the header.
foreach my $line3(@header_list_motif){
    printf OUTPUT $line3;
}

#Print the motifs with the data
while (<MOTIF>){
   chomp;
   $motif_id = $_;
   foreach my $motif_hash(keys %matrix){
      if ($motif_hash=~/$motif_id/) {
       printf OUTPUT "$motif_hash @{$matrix{$motif_hash}}\n";
       #$counter = $counter +1;
      }
      
   }
}
#print $counter;
