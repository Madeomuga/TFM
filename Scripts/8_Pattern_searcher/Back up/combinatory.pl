$|=1;
use strict;
use warnings;
use Algorithm::Permute;
my @list_motifs = ("A","B","C");
my %hash;
my $n=0;
my $p_iterator = Algorithm::Permute->new ( \@list_motifs );
while (my @perm = $p_iterator->next) {
    $hash{$n}=\@perm;
        $n++;
}
my @motifs;
for (my $x=0;$x<$n;$x++){
    @motifs=@{$hash{$x}};
    print @motifs, "\n";
}
