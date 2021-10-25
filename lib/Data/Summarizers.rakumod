=begin pod

=head1 Data::Summarizers

C<Data::Summarizers> package has data reshaping functions for
different data structures (full arrays, Red tables, Text::CSV tables.)

=head1 Synopsis

    use Data::Summarizers;

    my @tbl = get-titanic-dataset(headers => "auto");

    my $xtab1 = cross-tabulate(@tbl, 'passengerClass', 'passengerSex');
    my $xtab2 = cross-tabulate(@tbl, 'passengerClass', 'passengerSex', 'passengerAge');

    my @tbl2 = get-titanic-dataset(headers => "none");
    my $xtab3 = cross-tabulate(@tbl, 1, 3);
    my $xtab4 = cross-tabulate(@tbl, 1, 3, 2);

=end pod

use Data::Summarizers::RecordsSummary;
use Data::Reshapers;

unit module Data::Summarizers;

#===========================================================
sub records-summary( $data, UInt :$max-tallies = 7 ) is export {

    my %summary = Data::Summarizers::RecordsSummary::RecordsSummary($data, :$max-tallies);

    my $maxSize = %summary.map({ $_.value.elems }).max;

    my %summary2 =
            do for %summary.kv -> $k, $v {
                my $maxKeySize = $v.map({ $_.key.chars }).max;
                my $res = $v.map({ $_.key ~ (' ' x ($maxKeySize - $_.key.chars)) ~ ' => ' ~ $_.value });
                if $maxSize - $v.elems > 0 {
                    $res = $res.Array.append( "".roll($maxSize - $v.elems) )
                }
                my $i = 0;
                $k => $res.map({ ($i++).Str => $_ }).Hash
            }

    say to-pretty-table(transpose(%summary2), align => 'l');
}