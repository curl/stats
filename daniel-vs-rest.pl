#!/usr/bin/perl
#my @a = `git log --reverse --pretty=fuller --no-color --date=short --decorate=full  | grep ^Author:`;

print "Date;Commit;Daniel;Everyone else\n";

my $c=0;

open(G, "git log --reverse --pretty=fuller --no-color --date=short --decorate=full|");

my $after = 1990;

my $info;
my $o;
while(<G>) {
    chomp;
    my $line = $_;
    if($line =~ /^CommitDate: (.*)/) {
        my $date = $1;
        my $cmp = $date <=> $after;

        # if date is new enough...
        if($cmp > 0) {
            $o = sprintf("$date;$info");
            if(!($c%10)) {
                print "$o\n";
                $info="";
            }
        }
    }
    elsif($line =~ /^Author: *([^\<]*) \</) {
        my ($auth)=($1);
        if($auth ne "Daniel Stenberg") {
            $auth = "else";
        }
        $uniq{$auth}++;
        $c++;
        $info = sprintf("$c;%.2f;%.2f",
                        $uniq{"Daniel Stenberg"}*100/$c,
                        $uniq{"else"}*100/$c);
    }
}
close(G);

if($info) {
    # final commit
    print "$o\n";
}

