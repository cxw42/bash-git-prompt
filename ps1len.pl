#!/usr/bin/env perl

# Takes PS1 on stdin; provides its length, minus invisible sequences, on stdout.
use strict;
use warnings;

print main();
exit 0;

sub main {
    my $PS1 = do { local $/; <> };
    chomp $PS1;

    my $OPEN = qr(\\(?:\[|001));
    my $CLOSE = qr(\\(?:\]|002));

    my $dbg = $PS1;
    $dbg =~ s{($OPEN.+?$CLOSE)}{}g;
    return length($dbg);
} #main()

# vi: set ts=4 sts=4 sw=4 et ai: #
