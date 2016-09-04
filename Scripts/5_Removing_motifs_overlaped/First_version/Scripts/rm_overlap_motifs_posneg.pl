

$|=1;
use warnings;
use strict;


my $line;
my @cols;
my %hash;
my %hash_negative;
my $gene;
my $TF;
my @sequences;
my $seq_len;
my $OL;
my @output_pos;
my @output_neg;
my $actual_pvalue;
my $pvalue;
my $pvalue_neg;
$ARGV[0]="c:/Users/sstuff/Desktop/fimo-position-sorted.gff";
$ARGV[1]="c:/Users/sstuff/Desktop/positive.gff";
$ARGV[2]="c:/Users/sstuff/Desktop/negative.gff";
print "Please, introduce overlap value: ";
$ARGV[3]=<STDIN>;

if(@ARGV < 4){
print "\nUsage: rm_overlap_motifs_posneg.pl fimo-test-sue.gff fimo-nol-pos.gff fimo-nol-neg.gff overlap_percentage\n\n";
exit(0);
}



open(FIMO, "$ARGV[0]") ||
    die "File '$ARGV[0]' not found\n";
open(POSITIVE, ">$ARGV[1]") ||
    die "File '>$ARGV[1]' not found\n";
open(NEGATIVE, ">$ARGV[2]") ||
    die "File '>$ARGV[2]' not found\n";

# Getting overlap value form user and testing to see if its 0-100 and
# converting to 0-1 scale.
if ($ARGV[3] >0.0 && $ARGV[3] <=100){
   $OL=$ARGV[3]/100;
}
else{
  print" ERROR: overlap is a value 0-100\n";
    exit(0);
}
#print "OL is $OL\n";

while (<FIMO>) {
    $line=$_;
    chomp $line;
    @cols=split;
    my $pos1;
    my $pos2;
    my $scalar;
    my $decimal;
    my $e;
    
    my @list=();
    if ($line=~/^#/){
        printf POSITIVE"%s\n", $line;
        printf NEGATIVE"%s\n", $line;
    }
    elsif ($line!~/^##/ and $cols[6]eq"+") {
        @cols=split;
        $TF= substr $cols[8],5,8; 
        $gene=substr $cols[0],0,21;
        $pos1 = $cols[3];
        $pos2=$cols[4];
        @list=();
        @list=($pos1,$pos2);
        @sequences= split( "=", $cols[9]);
        $seq_len = int(length (substr $sequences[1],0,-1));
        $decimal= substr $cols[8],-16,4;
        $e=substr $cols[8],-11,3;
        $decimal =~ s/[^.\d]//g; #This removes all nondigit characters from the string.
        $actual_pvalue=$decimal*(10**$e); #it will take the p value of the current line
        
        if (not exists $hash{$gene}{$TF}) { #Every time that a block of a GENE-MOTIF  starts, it will register
                                       #the GENE-MOTIF in a hash: GENE-MOTIF as a key and pos1 and pos2 as values.
            $hash{$gene}{$TF}=\@list;
            $pvalue=$actual_pvalue; #p value of the current line that it will be compared in the next loop
            push @output_pos, $line; #it saves the information of the gene motif in the array
            }
        
         elsif (not($pos1>=@{$hash{$gene}{$TF}}[0] and $pos1<=@{$hash{$gene}{$TF}}[1])
               and not($pos2>=@{$hash{$gene}{$TF}}[0] and $pos2<=@{$hash{$gene}{$TF}}[1])) {#if the gene exists and the motif is not overlaped
                                                                                    #with the previous one
                                                                                    #then it will take the line in the list and it will
                                                                                    #consider the p value in the next loop
               $hash{$gene}{$TF}=\@list;
               $pvalue=$actual_pvalue;
               push @output_pos, $line;
            }
        
        
         elsif (
            
               (not($pos1>=@{$hash{$gene}{$TF}}[0] and $pos1<=@{$hash{$gene}{$TF}}[1])and
               ($pos2>=@{$hash{$gene}{$TF}}[0] and $pos2<=@{$hash{$gene}{$TF}}[1]) and (int($pos2-(@{$hash{$gene}{$TF}}[0]))/$seq_len)<$OL) 
               
               ) {#If the actual motif overlaps with the previous motif and the overlaping sequence includes the second position
                  #position and not the first one of the actual motif AND it doesn't surpass the threshold $OL then it will consider the line.
                  #It will store it in the array and its p value it will consider in the next loop.
                  $hash{$gene}{$TF}=\@list;
                  $pvalue=$actual_pvalue;
                  push @output_pos, $line;
                  #print $pvalue , "\n";
            }
         elsif (
            
               (not($pos1>=@{$hash{$gene}{$TF}}[0] and $pos1<=@{$hash{$gene}{$TF}}[1])and
               ($pos2>=@{$hash{$gene}{$TF}}[0] and $pos2<=@{$hash{$gene}{$TF}}[1]) and (int($pos2-(@{$hash{$gene}{$TF}}[0]))/$seq_len)>$OL)
               and $actual_pvalue<$pvalue
               
               
               ) { #If the actual motif overlaps with the previous motif and the overlaping sequence includes the second
                  #position and not the first one of the actual motif AND it DOES surpass the threshold $OL but the actual motif has a lower p value
                  #than the last considered;then it will consider the line and it will remove the previous motif from the array; considering the motif
                  #with the lowest p value. This p value will consider in the next loop.
                  pop @output_pos;
                  $hash{$gene}{$TF}=\@list;
                  $pvalue=$actual_pvalue;
                  push @output_pos, $line;
                  #print $pvalue , "\n";
            }
         elsif (
            
               ((($pos1>=@{$hash{$gene}{$TF}}[0] and $pos1<=@{$hash{$gene}{$TF}}[1]) and (int((@{$hash{$gene}{$TF}}[1])-$pos1)/$seq_len)<$OL )
               and not($pos2>=@{$hash{$gene}{$TF}}[0] and $pos2<=@{$hash{$gene}{$TF}}[1])) 
               
               ) {#If the actual motif overlaps with the previous motif and the overlaping sequence includes the first position
                  #position and not the first one of the actual motif AND it doesn't surpass the threshold $OL then it will consider the line.
                  #It will store it in the array and its p value it will consider in the next loop.
            
                  $hash{$gene}{$TF}=\@list;
                  $pvalue=$actual_pvalue;
                  push @output_pos, $line;
            }
         elsif (
            
               ((($pos1>=@{$hash{$gene}{$TF}}[0] and $pos1<=@{$hash{$gene}{$TF}}[1]) and (int((@{$hash{$gene}{$TF}}[1])-$pos1)/$seq_len)>$OL )
               and not($pos2>=@{$hash{$gene}{$TF}}[0] and $pos2<=@{$hash{$gene}{$TF}}[1])) and $actual_pvalue<$pvalue
               #If the actual motif overlaps with the previous motif and the overlaping sequence includes the first
                  #position and not the second one of the actual motif AND it DOES surpass the threshold $OL but the actual motif has a lower p value
                  #than the last considered;then it will consider the line and it will remove the previous motif from the array; considering the motif
                  #with the lowest p value. This p value will consider in the next loop.
               ) {
                  $hash{$gene}{$TF}=\@list;
                  $pvalue=$actual_pvalue;
                  pop @output_pos;
                  push @output_pos, $line;
            }
         elsif (
            
               ((($pos1>=@{$hash{$gene}{$TF}}[0] and $pos1<=@{$hash{$gene}{$TF}}[1])  )
               and ($pos2>=@{$hash{$gene}{$TF}}[0] and $pos2<=@{$hash{$gene}{$TF}}[1])) and $actual_pvalue<$pvalue
       
               ) {
                  $hash{$gene}{$TF}=\@list;
                  $pvalue=$actual_pvalue;
                  pop @output_pos;
                  push @output_pos, $line;
            }
        
       
    }
    elsif ($line!~/^##/ and $cols[6]eq"-") { #same strategy for the motifs located in the minus strand
        @cols=split;
        #$TF= substr $cols[8],5,8;
        $gene=substr $cols[0],0,21;
        $pos1 = $cols[3];
        $pos2=$cols[4];
        @list=();
        @list=($pos1,$pos2);
        @sequences= split( "=", $cols[9]);
        $seq_len = int(length (substr $sequences[1],0,-1));
        $decimal= substr $cols[8],-16,4;
        $e=substr $cols[8],-11,3;
        $decimal =~ s/[^.\d]//g; #This removes all nondigit characters from the string.
        $actual_pvalue=$decimal*(10**$e);
        
        if (not exists $hash_negative{$gene}{$TF}) {
            $hash_negative{$gene}{$TF}=\@list;
            $pvalue_neg=$actual_pvalue;
            push @output_neg, $line;
        }
        
        elsif (not($pos1>=@{$hash_negative{$gene}{$TF}}[0] and $pos1<=@{$hash_negative{$gene}{$TF}}[1])
               and not($pos2>=@{$hash_negative{$gene}{$TF}}[0] and $pos2<=@{$hash_negative{$gene}{$TF}}[1])) {
                $pvalue_neg=$actual_pvalue;
                $hash_negative{$gene}{$TF}=\@list;
                push @output_neg, $line;
            }
        
        
        elsif (
            
               (not($pos1>=@{$hash_negative{$gene}{$TF}}[0] and $pos1<=@{$hash_negative{$gene}{$TF}}[1])and
               ($pos2>=@{$hash_negative{$gene}{$TF}}[0] and $pos2<=@{$hash_negative{$gene}{$TF}}[1]) and (int($pos2-(@{$hash_negative{$gene}{$TF}}[0]))/$seq_len)<$OL               ) 
               ) {
                  $pvalue_neg=$actual_pvalue;
                  $hash_negative{$gene}{$TF}=\@list;
                  push @output_neg, $line;
            }
         elsif (
            
               (not($pos1>=@{$hash_negative{$gene}{$TF}}[0] and $pos1<=@{$hash_negative{$gene}{$TF}}[1]) and
               ($pos2>=@{$hash_negative{$gene}{$TF}}[0] and $pos2<=@{$hash_negative{$gene}{$TF}}[1]) and (int($pos2-(@{$hash_negative{$gene}{$TF}}[0]))/$seq_len)>$OL and
               $actual_pvalue<$pvalue_neg) 
               ) {
                  $pvalue=$actual_pvalue;
                  $hash_negative{$gene}{$TF}=\@list;
                  pop @output_neg;
                  push @output_neg, $line;
            }
         elsif (
               ((($pos1>=@{$hash_negative{$gene}{$TF}}[0] and $pos1<=@{$hash_negative{$gene}{$TF}}[1]) and (int((@{$hash_negative{$gene}{$TF}}[1])-$pos1)/$seq_len)<$OL )
               and not($pos2>=@{$hash_negative{$gene}{$TF}}[0] and $pos2<=@{$hash_negative{$gene}{$TF}}[1] )) 
               ) {
                  $pvalue_neg=$actual_pvalue;
                  $hash_negative{$gene}{$TF}=\@list;
                  push @output_neg, $line;
            }
         elsif (
               ((($pos1>=@{$hash_negative{$gene}{$TF}}[0] and $pos1<=@{$hash_negative{$gene}{$TF}}[1]) and
                 (int((@{$hash_negative{$gene}{$TF}}[1])-$pos1)/$seq_len)>$OL )
                  and not($pos2>=@{$hash_negative{$gene}{$TF}}[0] and $pos2<=@{$hash_negative{$gene}{$TF}}[1] )and
                  $actual_pvalue<$pvalue_neg) 
               ) {
                  $pvalue_neg=$actual_pvalue;
                  $hash_negative{$gene}{$TF}=\@list;
                  pop @output_neg;
                  push @output_neg, $line;
            }
          elsif (
               ((($pos1>=@{$hash_negative{$gene}{$TF}}[0] and $pos1<=@{$hash_negative{$gene}{$TF}}[1]))
                  and ($pos2>=@{$hash_negative{$gene}{$TF}}[0] and $pos2<=@{$hash_negative{$gene}{$TF}}[1] )and
                  $actual_pvalue<$pvalue_neg) 
               ) {
                  $pvalue_neg=$actual_pvalue;
                  $hash_negative{$gene}{$TF}=\@list;
                  pop @output_neg;
                  push @output_neg, $line;
            }
        
       
    }
}
foreach my $lines_pos (@output_pos){
    printf POSITIVE"%s\n", $lines_pos;
    
}
foreach my $lines_neg (@output_neg){
    printf NEGATIVE"%s\n", $lines_neg;
}