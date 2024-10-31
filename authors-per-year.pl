#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full | grep -E "^(Author|CommitDate):"`;

my $c=1;
my $auth="";
for(@a) {
    chomp;
    my $line = $_;
    if(/^Author: *([^\<]*) \</) {
        ($auth)=($1);
    }
    elsif($auth && /^CommitDate: (.*)/) {
        if($1 =~ /^(\d\d\d\d)-(\d\d)/) {
            $year = $1;
        }
        $commits{$year}++;
        $uniq{$auth}++;
        $yearcount{$auth.$year}++;

        # if this is the author's first commit this year, count it
        if($yearcount{$auth.$year} == 1) {
            $author{$year}++;
            # remember the author's first commit year
            if(!$authorfirstyear{$auth}) {
                $authorfirstyear{$auth}=$year;
            }
        }
        $auth="";
    }
}

# appends -01-01 just to make it a date format
for my $y (sort keys %commits) {
    my $i;
    for my $a (keys %uniq) {
        if($authorfirstyear{$a} == $y) {
            $i++;
        }
    }
    printf("%s-01-01;%d;%d\n", $y, $author{$y}, $i);
}
