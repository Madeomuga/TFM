$|=1;
use warnings;
use strict;




my @solution;
my $motif;
my $motif2;
my $motif3;
my $line;
my $position;
my $position2;
my @cols;
my $gene;
my @motifs;
my $limit;
my $firstmotif;
my $secondmotif;
my $thirdmotif;
my $option;


if ($ARGV[2] ne "#"){
    push  @motifs, $ARGV[2];
}
if ($ARGV[3] ne "#"){
    push  @motifs, $ARGV[3];
}
if ($ARGV[4] ne "#"){
    push  @motifs, $ARGV[4];
}

#$option = 2;
my %solution;
$option= scalar @motifs;
print $option;

open (RULES, "<$ARGV[0]") ||
    die "File '$ARGV[0]' not found";
open(OUTPUT, ">$ARGV[1]") ||
    die "File '>$ARGV[1]' not found\n";

if ($option == 2){
    while (<RULES>) {
        $line=$_;
        @cols=split;
        if ($line=~/^P/){
        
            #if (scalar @solution != 0){$solution{$gene}=\@solution;}
            @solution =();
       
            $firstmotif="";
            $gene= $cols[0]; #gene ID
            $limit= (scalar @cols)-1; #this gives me the number of motifs in a promoter
            for (my $i=2; $i<=$limit;$i++){
                @solution=();
                if (($cols[$i]=~/$motifs[0]/)){
                    $firstmotif=$cols[$i];
                    for (my $j=$i+1; $j<=$limit;$j++){
                        if (($cols[$j]=~/$motifs[1]/)){
                            $secondmotif=$cols[$j];
                            push @{$solution{$gene}}, $firstmotif;
                            push @{$solution{$gene}}, $secondmotif;
                        }
                    
                    }
                
                }
        
            
        
            }   
        }
    
    }
}
close RULES;
open (RULES, "$ARGV[0]") ||
    die "File '$ARGV[0]' not found";
if ($option == 3){
    while (<RULES>) {
        $line=$_;
        @cols=split;
        if ($line=~/^P/){
        
            #if (scalar @solution != 0){$solution{$gene}=\@solution;}
            @solution =();
       
            $firstmotif="";
            $gene= $cols[0]; #gene ID
            $limit= (scalar @cols)-1; #this gives me the number of motifs in a promoter
            for (my $i=2; $i<=$limit;$i++){
                @solution=();
                if (($cols[$i]=~/$motifs[0]/)){
                    $firstmotif=$cols[$i];
                    for (my $j=$i+1; $j<=$limit;$j++){
                        if (($cols[$j]=~/$motifs[1]/)){
                            $secondmotif=$cols[$j];
                            for (my $h=$j+1; $h<=$limit;$h++){
                                if (($cols[$h]=~/$motifs[2]/)){
                                    $thirdmotif=$cols[$h];
                                    push @{$solution{$gene}}, $firstmotif;
                                    push @{$solution{$gene}}, $secondmotif;
                                    push @{$solution{$gene}}, $thirdmotif;
                                }
                            }
                        }
                    
                    }
                
                }
        
            
        
            }   
        }
    
    }
}
close RULES;



foreach my $key (keys %solution){
     printf OUTPUT $key;
     printf OUTPUT "\t";
     printf OUTPUT "=>";
     printf OUTPUT join "\t", @{$solution{$key}};
     printf OUTPUT "\n";
}