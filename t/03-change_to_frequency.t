use strict;
use warnings;
use Test::More;
use Crontab::Interval;

my @cases = (
    # query, wish
    [  1,   1 ],
    [  2, 0.5 ],
    [ 10, 0.1 ],
);

plan tests => scalar @cases;

for my $case_ref ( @cases ) {
    my( $query, $wish ) = @{ $case_ref };
    is( Crontab::Interval::change_to_frequency( $query ), $wish );
}

