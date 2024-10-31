#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full | grep -E "^(Author|CommitDate):"`;

my $c=1;
my $yearmon;
my $auth;
for(@a) {
    chomp;
    my $line = $_;
    if(/^Author: *([^\<]*) \</) {
        ($auth)=($1);
    }
    elsif(/^CommitDate: (.*)/) {
        if($1 =~ /^(\d\d\d\d)-(\d\d)/) {
            $yearmon = "$1";
        }
        $who{$auth}++;
        $commits{$auth.$yearmon}++;
        $when{$yearmon}++;
        $c++;
    }
}

# Daniel's percentage share per year

for my $y(sort keys %when) {
    printf("%s-12-31;%.1f\n", $y, $commits{"Daniel Stenberg".$y}*100/$when{$y} );
}
