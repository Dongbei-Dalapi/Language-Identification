package Profile;

use strict;
use warnings;
require Text::Ngrams;


sub new {
   my $class = shift;
   my $self = {
      _name => shift,
      _text => shift,
      _ngramRanks => {}
    };
    bless $self, $class;
    return $self;
}

sub countNGramsRanks {
    my ($self,$text, $minNGramLength, $maxNGramLength) = @_;
    my %ngramFreqs;
    my $ng = Text::Ngrams->new( type => "utf8" );
    $ng->process_text($text);
    my @range = ($minNGramLength...$maxNGramLength);
    for(@range){
        my %target_ngrams = $ng->get_ngrams( n => $_, normalize => 1 );
        @ngramFreqs{keys %target_ngrams} = values %target_ngrams;
    } 
    delete $ngramFreqs{' '};

    
    my %ngramRanks;
    my $current_size = 0;

    for my $gram (sort { $ngramFreqs{$b} <=> $ngramFreqs{$a} } keys %ngramFreqs) {
        $current_size = $current_size + 1;
        print $gram, "\n";
        $ngramRanks{$gram} = $current_size;
        last if($current_size >= 300);
    }
    my $size = keys %ngramRanks;
    $self->{_ngramRanks} = \%ngramRanks; 
}


sub getNgramRanks {
    my( $self ) = @_;
    return $self->{_ngramRanks};
}


sub getName {
    my( $self ) = @_;
    return $self->{_name};
}


sub distance {
    my ( $self, $other ) = @_;
    my $d = 0;
    my %ranksA = %{$self->getNgramRanks()};
    my %ranksB = %{$other->getNgramRanks()};
    for (keys %ranksA){
        if (exists $ranksB{$_}) {
           $d = $d + abs($ranksA{$_} - $ranksB{$_});
        }else{
           $d = $d + abs($ranksA{$_} - 300);
        }
    }
    return $d
}

1;