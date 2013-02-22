package Crontab::Interval;
use utf8;
use strict;
use warnings;
use Exporter "import";
use List::Util qw( sum );

our $VERSION = "0.01";
our @EXPORT_OK = qw( trans );

my %COUNT = (
    minute => 60,
    hour   => 24,
    day    => 31,
    month  => 12,
    wday   => 7,
);
my %UNIT = (
    minute => 1,
    hour   => $COUNT{minute},
    day    => $COUNT{minute} * $COUNT{hour},
    month  => $COUNT{minute} * $COUNT{hour} * $COUNT{day},
    wday   => $COUNT{minute} * $COUNT{hour},
);
my @NAMES = qw( minute hour day month wday user command );

sub trans { s{\A }{ parse_interval( $_ ) . "\t" }emsx }

sub change_to_frequency { eval { 1 / shift } || "Inf" }

sub get_count {
    my( $str, $max ) = @_;

    return 0
        if $str eq q{*};

    my @ats = split m{,}, $str;
    return $max / @ats
        if @ats > 1;

    if ( $str =~ m{\A [*] / (\d+) \z}msx ) {
        my $unit = $1;
        return $unit != 1 ? $unit : 0;
    }

    if ( $str =~ m{\A \d+ \z}msx ) {
        return $max;
    }

    die "Could not parse; \$str: [$str], \$max: [$max]";
}

sub parse_interval {
    my $line = shift;
    $line =~ s{\A \s+ }{}msx;
    $line =~ s{ \s+ \z}{}msx;
    my %job;
    @job{ @NAMES } = split m{\s+}, $line, scalar @NAMES;
    my @intervals;

    for my $name ( keys %UNIT ) {
        push @intervals, get_count( $job{ $name }, $COUNT{ $name } ) * $UNIT{ $name };
    }

    return sum( @intervals );
}

1;

__END__
=head1 NAME

Crontab::Interval - parse interval of date field of cron entry

=head1 SYNOPSIS

  $ grep -v \# /etc/crontab | grep \* | perl -MCrontab::Interval=trans -lpe trans | sort -n

=head1 DESCRIPTION

This module parses interval of date field of cron entry.

When i start maintenance a project, there is a step exists that is understanding
what cron jobs exist in the project.

It is easy to understanding when all cron jobs can see by one file, and
it is more easily the job is sorted.

=head1 EXPORT

None by default.

=head1 FUNCTIONS

=over

=item trans

=item change_to_frequency( $interval )

=item get_count( $one_date_field_of_cron_entry, $unit_of_the_entry )

=item parse_interval( $cron_entry )

=back

=head1 SEE ALSO

=head1 AUTHOR

kuniyoshi E<lt>kuniyoshi@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
