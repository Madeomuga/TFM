#!/usr/bin/perl -w
$|=1;
use warnings;
use strict;

#Script that returns the lines of a gff file according to the ID motifs that we want.



my $motif=" ";
my @motifs;
my $line;
my @cols;
my $motif_fimo;

if ($ARGV[2] ne "#"){
    push  @motifs, $ARGV[2];
}
if ($ARGV[3] ne "#"){
    push  @motifs, $ARGV[3];
}
if ($ARGV[4] ne "#"){
    push  @motifs, $ARGV[4];
}
if ($ARGV[5] ne "#"){
    push  @motifs, $ARGV[5];
}





open(FIMO, "<$ARGV[0]") ||
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