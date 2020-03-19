#!/usr/bin/perl

open(L, "git log --reverse --pretty=fuller --date=short --stat -- src lib include |");

my $date;
my $lines;
my $c;
my $hash;

# the inital amount is an estimate
# curl 4.8 is 1998-09-20
# curl 5.9 is 1999-05-22
# curl 6.0 is 1999-09-13
# curl 6.3.1 is 1999-11-23
print <<EARLY
1998-03-18;2200
1998-09-20;3379
1999-05-22;12289
1999-09-13;14060
1999-11-23;14826
EARLY
    ;

while(<L>) {
    chomp;
    my $line = $_;
    if($line =~ /^CommitDate:([ \t]*)(.*)/) {
        $date = $2;
    }
    elsif($line =~ /^commit ([0-9a-f]+)$/) {
        $hash = $1;
    }
    elsif($line =~ /^ (\d*) file(|s) changed, (.*)/) {
        my $d=$3;
        my $adds=0;
        my $dels=0;

        $d =~ s/, //; #remove comma
        if($d =~ s/(\d*) insertion(s|)\(\+\)//) {
            $adds = $1;
        }
        if($d =~ s/(\d*) deletion(s|)\(\-\)//) {
            $dels = $1;
        }
        $lines += $adds;
        $lines -= $dels;


        if($date =~ /^(\d\d\d\d)-(\d\d)/) {
            $month = "$1-$2";
            $sdate = "$date";
        }

        #if($month < "2010-01") {
        #    next;
        #}

        # new date
        if($sdate ne $ldate) {
            print "$date;$lines\n";
            $ldate = $sdate;
        }
        $c++;
        $date="";
    }
}
