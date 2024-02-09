#!/usr/bin/perl

# shortlog does not work like we want, make our own
my $c="git log";

open(G, "$c|");

while(<G>) {
    my $e = $_;
    chomp $e;
    if($e =~ /^Author: (.*) </) {
        $commits{$1}++;
    }
}
close(G);

my $index = 1;
for $a (sort {$commits{$b} <=> $commits{$a}} keys %commits) {
    printf "%s;%u;%u\n", $a, $commits{$a}, $index++;
}
