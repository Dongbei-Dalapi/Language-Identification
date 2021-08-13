use Test::More  tests => 5;


use lib '/Users/chingfen/Perl_files/Language-Identification';
use Profile;


can_ok ( 'Profile', 'countNGramsRanks');
can_ok ( 'Profile', 'getNgramRanks');
can_ok ( 'Profile', 'getName');


# test countNGramsRanks
my $profile = new Profile("en-1", "banana");
$profile->countNGramsRanks($profile->{_text}, 1, 3);
my $got_ranks = $profile->getNgramRanks();

my %expected_ranks= ( a => 1, ana => 2, an => 3, na=>4, n => 5, ban => 6, nan => 7, ba =>8, b => 9);

is (%$got_ranks{a}, %expected_ranks{a}, 'countNGramsRanks test1');
is (%$got_ranks{b}, %expected_ranks{b}, 'countNGramsRanks test2');

