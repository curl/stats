#!/usr/bin/perl

my $c="LANG=C git shortlog -s";
my @all=`$c`;

for $e (@all) {
    if($e =~ /^ *(\d+)[ \t]+(.*)/) {
        $commits{$2} = $1;
    }
}

my $index = 1;
for $a (sort {$commits{$b} <=> $commits{$a}} keys %commits) {
    printf "%s;%u;%u\n", $a, $commits{$a}, $index++;
}
if($index == 1) {
    print "badness ensued: \n";
    print `pwd`;
    print `$c 2>&1`;
}
