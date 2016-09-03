#!/usr/bin/perl -w


use strict;

my $line;
my @cols;
my @ARG = ();

$ARGV[0]='C:\Users\sstuff\Desktop\ame-shorted.txt';
$ARGV[1]='C:\Users\sstuff\Desktop\list-motifs.txt';

if(@ARGV < 2){
print "\nUsage: list_motifs.pl ame-shorted.txt list-motifs.txt\n\n";
exit(0);
}
open (INPUT, "$ARGV[0]") || 
   die "File '$ARGV[0]' not found\n" ;

open (OUTPUT, ">$ARGV[1]") || 
  die "File '>$ARGV[1]' not found\n" ;

 while (<INPUT>){
  
   $line = $_;
   @cols=split;
   if ($line =~ /MA/){
    printf OUTPUT "%s\n", $cols[5];
   }
 }