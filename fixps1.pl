#!/usr/bin/env perl
die 'Not yet finished!';

# Takes PS1 on stdin; provides PS1 on stdout.
use strict;
use warnings;
use List::Util 1.26 qw(first);  #sum0
#use List::UtilsBy qw(zip_by);

my $COLUMNS = shift or die 'Pass $COLUMNS as the first parameter';
my $PS1;

my $exitval = main();
print $PS1 if $exitval == 0;
exit $exitval;

sub main {
    $PS1 = do { local $/; <> };
    chomp $PS1;

    return -1 unless $COLUMNS>1 && length($PS1)>$COLUMNS;

    my $ps1_idx=0;  # index in PS1
    my $scr_col=0;  # screen column
    my @insertions;     # list of [ column start, char start, char length]

    my $OPEN = qr(\\(?:\[|001));
    my $CLOSE = qr(\\(?:\]|002));

    my $last_insertion_end = 0;
    my $real_length_so_far = 0;

    my $dbg = $PS1;
    $dbg =~ s{($OPEN.+?$CLOSE)}{}g;
    print STDERR "debug:\n$dbg\n";

    while($PS1 =~ m{($OPEN.+?$CLOSE)}gc) {
        print "Saw piece $1 at real length $real_length_so_far\n";
        push @insertions, [ $real_length_so_far, pos($PS1), length($1) ];
        $real_length_so_far += (pos($PS1) - $last_insertion_end);

        $last_insertion_end = pos($PS1)+length($1);

        # Done if we've wrapped around
        #last if $real_length_so_far > $COLUMNS;
    }

    return -1 unless $real_length_so_far > $COLUMNS;

    my $lrOneToModify = first { $_->[0] < $COLUMNS } reverse @insertions;
    print STDERR "Adding spaces: ", $lrOneToModify->[0];

    # Insert the spaces
    $PS1 = substr($PS1, 0, $lrOneToModify->[1]) .
        (' ' x ($COLUMNS - $lrOneToModify->[1])) .
        substr($PS1, $lrOneToModify->[1]);

    return 0;
} #main()

# vi: set ts=4 sts=4 sw=4 et ai: #
