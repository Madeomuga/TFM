#!/usr/bin/perl -w

$|=1;
use strict; #using this makes debugging your code much easier
use warnings;

#Script to take a multiple fasta file and truncate the header lines to
#GeneIDs so the fasta file can be used as input to AME

#Checking to see if the user has provided 2 arguments - which is the
#name of the promoter sequence file and an output file name

if(@ARGV < 2){
print "\nUsage:shorten-headers.pl promoters.fasta  promoters-sh.fasta\n\n";
exit(0);
}

#Declaring variables
my $line; # a scalar varaible

#Using a FIELHANDLE to open the input file
open (INPUT, "<$ARGV[0]") || 
   die "File '$ARGV[0]' not found\n" ;

#Using a FIELHANDLE to open the input file
open (OUTPUT, ">$ARGV[1]") || 
   die "File '>$ARGV[1]' not found\n" ;

#looping through each line of the file
 while (<INPUT>){
   #assigning line to variable $line 
   #$_ is a special default variable that here holds the line contents
   $line = $_;
   #match lines header lines 
   if ($line =~ /^>/){
     #printing header lines to file as a substring of x charaters
     printf OUTPUT "%s\n", substr($line,0,21); #the third number is the x characters of the name of the header
  }
   else{
     #printing out sequence lines just as they are in the orginal file.
     printf OUTPUT "$line";
   }
 }

close (INPUT);
close(OUTPUT);
