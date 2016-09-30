$|=1;
use warnings;
use strict;
use Algorithm::Permute;

$ARGV[0]="c:/Users/sstuff/Desktop/testrules_output.gff";


my $motif;
my $motif2;
my $motif3;
my $line;
my $position;
my $position2;
my @cols;
my $gene;
my @list_motifs;
my @motifs;
my $limit;
my $firstmotif;
my $secondmotif;
my $thirdmotif;
my $option;
$motif="";
while ($motif ne "#") { #Introduce all the motifs that you want to consider. It will stop asking motifs as soon as you type #
                        #order is important
    print "Introduce the motif: ";
    $motif=<STDIN>; 
    chomp $motif;
    if ($motif ne "#"){
        push  @list_motifs, $motif;
    }
    
}
$option= scalar @list_motifs;
#print $option;
my %hash;
my $n=0;
my $p_iterator = Algorithm::Permute->new ( \@list_motifs );
while (my @perm = $p_iterator->next) {
    $hash{$n}=\@perm;
        $n++;
}
my %solution;



open (RULES, "$ARGV[0]") ||
    die "File '$ARGV[0]' not found";

if ($option == 2){
    while (<RULES>) {
        for (my $x=0;$x<$n;$x++){
            @motifs=@{$hash{$x}};
            #print @motifs, "\n";
            $line=$_;
            @cols=split;
            if ($line=~/^P/){
                $firstmotif="";
                $gene= $cols[0]; #gene ID
                $limit= (scalar @cols)-1; #this gives me the number of motifs in a promoter
                for (my $i=2; $i<=$limit;$i++){
                    if (($cols[$i]=~/$motifs[0]/)){
                        $firstmotif=$cols[$i];
                        for (my $j=$i+1; $j<=$limit;$j++){
                            if (($cols[$j]=~/$motifs[1]/)){
                                $secondmotif=$cols[$j];
                                push @{$solution{$gene}{$x}}, $firstmotif;
                                push @{$solution{$gene}{$x}}, $secondmotif;
                            }                   
                        }       
                    }
                }   
            }


        }
    }
foreach my $key (keys %solution){
    foreach my $auxilary (keys %{$solution{$key}}){
      if ($auxilary==0){
        print $key,"\t","=>","\t", join "\t", @{$solution{$key}{$auxilary}}, "\n";
      }
        
    }
}
print "==================================================", "\n";
foreach my $key (keys %solution){
    foreach my $auxilary (keys %{$solution{$key}}){
      if ($auxilary==1){
        print $key,"\t","=>","\t",  join "\t", @{$solution{$key}{$auxilary}}, "\n";
      }
        
    }
}
}
close RULES;
open (RULES, "$ARGV[0]") ||
    die "File '$ARGV[0]' not found";
if ($option == 3){
    while (<RULES>) {
     for (my $x=0;$x<$n;$x++){
        
        @motifs=@{$hash{$x}};
        $line=$_;
        @cols=split;
        if ($line=~/^P/){   
            $firstmotif="";
            $gene= $cols[0]; #gene ID
            $limit= (scalar @cols)-1; #this gives me the number of motifs in a promoter
            for (my $i=2; $i<=$limit;$i++){
                if (($cols[$i]=~/$motifs[0]/)){
                    $firstmotif=$cols[$i];
                    for (my $j=$i+1; $j<=$limit;$j++){
                        if (($cols[$j]=~/$motifs[1]/)){
                            $secondmotif=$cols[$j];
                            for (my $h=$j+1; $h<=$limit;$h++){
                                if (($cols[$h]=~/$motifs[2]/)){
                                    $thirdmotif=$cols[$h];
                                    push @{$solution{$gene}{$x}}, $firstmotif;
                                    push @{$solution{$gene}{$x}}, $secondmotif;
                                    push @{$solution{$gene}{$x}}, $thirdmotif;
                                }
                            }
                        }
                    
                    }
                
                }
        
            
        
            }   
        }
     }
    }
foreach my $key (keys %solution){
  foreach my $auxilary (keys %{$solution{$key}}){
      if ($auxilary==0){
        print $key,"\t","=>","\t",  join "\t", @{$solution{$key}{$auxilary}}, "\n";
      }
        
    }
}
print "==================================================", "\n";
foreach my $key (keys %solution){
    foreach my $auxilary (keys %{$solution{$key}}){
      if ($auxilary==1){
        print $key,"\t","=>","\t",  join "\t", @{$solution{$key}{$auxilary}}, "\n";
      }
        
    }
}
print "==================================================", "\n";
foreach my $key (keys %solution){
    foreach my $auxilary (keys %{$solution{$key}}){
      if ($auxilary==2){
        print $key,"\t","=>","\t", join "\t", @{$solution{$key}{$auxilary}}, "\n";
      }
        
    }
}
print "==================================================", "\n";
foreach my $key (keys %solution){
    foreach my $auxilary (keys %{$solution{$key}}){
      if ($auxilary==3){
        print $key,"\t","=>","\t", join "\t", @{$solution{$key}{$auxilary}}, "\n";
      }
        
    }
}
print "==================================================", "\n";
foreach my $key (keys %solution){
    foreach my $auxilary (keys %{$solution{$key}}){
      if ($auxilary==4){
        print $key,"\t","=>","\t", join "\t", @{$solution{$key}{$auxilary}}, "\n";
      }
        
    }
}
print "==================================================", "\n";
foreach my $key (keys %solution){
    foreach my $auxilary (keys %{$solution{$key}}){
      if ($auxilary==5){
        print $key,"\t","=>","\t", join "\t", @{$solution{$key}{$auxilary}}, "\n";
      }
        
    }
}
}
close RULES;



