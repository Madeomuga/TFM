#!/usr/bin/perl -w

$|=1;
use warnings;
use strict;
#Script that looks for genes that have motifs from a certain rule.
if(@ARGV < 3){
print "\nUsage: rules_galaxy.pl ouput.gff value \n\n";
exit(0);
}
#Declaration of variables
my $line;
my $line2;
my @cols;
my @cols2;
my %hash;
my %hash1;
my %hash3;

my $gene;
my $gene2;
my $TF;
my $TF2;
my $num_motifs;
my @genes_rules;


$num_motifs=$ARGV[2];


open(FIMO, "<$ARGV[0]") ||
    die "File '$ARGV[0]' not found\n";
        
open(OUTPUT, ">$ARGV[1]") ||
    die "File '$ARGV[1]' not found\n";
    

while (<FIMO>) {
    $line=$_;
    chomp $line;
    @cols=split;
    if (not $line=~/^ /){
       $TF= substr $cols[8],5,8; 
       $gene=substr $cols[0],0,21;
       
       if (not exists $hash{$gene}) {
            $hash1{$gene}=0;
            
        }
       if (not exists $hash{$gene}{$TF}) {
                $hash1{$gene}++;
                $hash{$gene}{$TF}=1;
                #print  $hash1{$gene};
            }

       
       if ($hash1{$gene}==$num_motifs and not exists $hash3{$gene}) {
        $hash3{$gene}=1;
        #print $line, "\n";
       }
       
       
       
    }
    
}

close FIMO;
open(FIMO, "<$ARGV[0]") ||
    die "File '$ARGV[0]' not found\n";
    
while (<FIMO>) {
    $line2=$_;
    chomp $line2;
    @cols2=split;
 
        if (not $line2=~/^ /){
            $TF2= substr $cols2[8],5,8; 
            $gene2=substr $cols2[0],0,21;
            foreach my $gene_listed (keys %hash3){
                
                if ($gene_listed eq $gene2) {
                    printf OUTPUT"%s\n", $line2;
                    
            }
            

        }
        
    }   
}


print "Genes that have this rule:", "\n";
foreach my $gene_listed (keys %hash3){
                print $gene_listed,"\n";
            }


