#!/usr/bin/perl -w
$|=1;
use warnings;
use strict;

#Script that returns the lines of a gff file according to the ID motifs that we want.

$ARGV[0]="c:/Users/sstuff/Desktop/negative.gff";
$ARGV[1]="c:/Users/sstuff/Desktop/motif_search.gff";

my $motif=" ";
my @motifs;
my $line;
my @cols;
my $motif_fimo;

while ($motif ne "#") { #Introduce all the motifs that you want to consider. It will stop asking motifs as soon as you type #
    print "Introduce the motif: ";
    $motif=<STDIN>; 
    chomp $motif;
    push  @motifs, $motif;
}



open(FIMO, "$ARGV[0]") ||
    die "File '$ARGV[0]' not found\n";
open(OUTPUT, ">$ARGV[1]") ||
    die "File '>$ARGV[1]' not found\n";

while (<FIMO>) {
    foreach my $tf (@motifs){
    $line= $_;
    chomp $line;
    @cols=split;
    if ($line=~/^#/){
        printf OUTPUT "%s\n", " ";
    }
    elsif ($line!~/^##/ and $tf eq (substr $cols[8],5,8)) {
        
            printf OUTPUT "%s\n", $line;
        
        
        
    }
    }
    
    
}