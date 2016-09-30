#!/usr/bin/perl -w

# The lines that start with # are comment lines that are not executed


$|=1;
use strict; 
use warnings;


#Script to take output from AME (part of memesuite-org) and extract a
#list of the overrepresented motifs and print them to a new file
#called ame-motif-id.list


#Checking to see if the user has provided 1 argument - which is the
#name of the AME results file

if(@ARGV < 2){
print "\nUsage: Extract_motif_codes.pl ame.txt ame-shorted.txt\n\n";
exit(0);
}

#Declaring variables
my @cols; #an array variable
my $line; # a scalar varaible

#Using a FIELHANDLE to open the input file
open (INPUT, "<$ARGV[0]") || 
   die "File '$ARGV[0]' not found\n" ;
   
open (OUTPUT, ">$ARGV[1]") || 
  die "File '>$ARGV[1]' not found\n" ;

#looping through each line of the file
 while (<INPUT>){
   #assigning line to variable $line 
   #$_ is a special default variable that here holds the line contents
   $line = $_;
   #match lines that have Ranksum 
   if ($line =~ /Ranksum/){
    printf OUTPUT "%s\n", $line; 
    #split the lines on white space, so each part of the line gets
    #stored as an array element
    @cols=split;
    #Testing to see what line elements are stored in the array
    #print "cols [0] is $cols[0] \n";
    #print "cols [2] is $cols[2] \n\n";
    
    #Now see if you can print out the array elemnent that stores the
    #motif ID to a new file called ame-motif-id.list.
  }
 }

