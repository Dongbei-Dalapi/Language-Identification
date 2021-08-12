use strict;
use warnings;

use lib '/Users/chingfen/Perl_files';
use Profile;
use Math::Round;
use Text::Trim qw(trim);

sub distance {
    my ( $profileA, $profileB ) = @_;
    my $d = 0;
    my %ranksA = %{$profileA->getNgramRanks()};
    my %ranksB = %{$profileB->getNgramRanks()};
    for (keys %ranksA){
        if (exists $ranksB{$_}) {
           $d = $d + abs($ranksA{$_} - $ranksB{$_});
        }else{
           $d = $d + abs($ranksA{$_} - 300);
        }
    }
    return $d
}

sub guess {
   my $text = $_[0];
   my @profiles = @{$_[1]};
    
   my $target_profile = new Profile( "unknown", $text);
   $target_profile->countNGramsRanks($target_profile->{_text}, 1, 5);
   my $minimal_distance = -1;
   my $guess_language = "";

   for my $profile (@profiles) {
      $profile->countNGramsRanks($profile->{_text}, 1, 5);
      my $d = distance($target_profile, $profile);
      if ($d < $minimal_distance || $minimal_distance < 0) {
         $guess_language = $profile->getName();
         $minimal_distance = $d;
      }
   }
   return $guess_language
}

# Evaluation
open(FH, '<', "training.tsv") or die $!;
my @languages_list;
my @test_corpus;
while(<FH>){
   my @line = split( /\t/, $_ );
   my $name = trim($line[0]);
   my $text = trim($line[1]);
   my $text_length = length($text);
   my $index = round( $text_length * 0.8 ); # split training and testing data
   my $train_text = substr($text, 0, $index);
   my $test_text = substr($text, $index);
   my $current_profile = new Profile( $name, $train_text);
   push(@languages_list, $current_profile);
   push(@test_corpus, $test_text);
}

close(FH);

my $total = 0;
my $correct = 0;
while (my ($i, $v) = each @test_corpus) {
    $total++;
    #print "Real: ", $languages_list[$i]->getName(), " Guess: ", guess($v, \@languages_list), "\n";
    if ($languages_list[$i]->getName() eq guess($v, \@languages_list)) {
       $correct++;
    }
}

my $acc = $correct / $total;
print "Numbers of Languages : ", $total, "\n";
print "Correct Predictions : ", $correct, "\n";
print "Accuracy : ", $acc, "\n";