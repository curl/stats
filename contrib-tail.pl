#!/usr/bin/perl

my @all=`git shortlog -s`;

for $e (@all) {
    if($e =~ /^ *(\d+)[ \t]+(.*)/) {
        $commits{$2} = $1;
    }
}

my $index = 1;
for $a (sort {$commits{$b} <=> $commits{$a}} keys %commits) {
    printf "%s;%u;%u\n", $a, $commits{$a}, $index++;
}
