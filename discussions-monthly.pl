#!/usr/bin/perl

# get the main CSV and output a new one
my $c = $ARGV[0];

if(!$c) {
    print "Usage: discussions-monthly.pl [gh-CSV]\n";
    exit;
}

# can't ignore leap years!
sub nextday {
    my ($date)=@_;
    if($date =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) {
        my ($y, $m, $d)=($1,$2,$3);
        my $dd = 31;
        $dd = 30 if (($m == 4) || ($m == 6) || ($m == 9) ||
                     ($m == 11));
        if($m == 2) {
            $dd = 29;
            if($y%4 == 0) {
                # leap year
                $dd = 29;
            }
        }
        if(++$d > $dd) {
            $d = 1;
            if(++$m > 12) {
                $m = 1;
                $y++;
            }
        }
        return sprintf("%04d-%02d-%02d", $y, $m, $d);
    }
}


my %day;
# bump each day where an issue was open
sub addperiod {
    my ($start, $close) = @_;

    my $days;
    my $open = $start;
    my $countdays = 1; # it was always open at least during part of one day
    while(1) {
        $day{$open}++; # was open this day
        if($open eq $close) {
            last; # no more days
        }
        $countdays++;
        $open = nextday($open);;
    }
    return $countdays;
}

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum / scalar(@p);
}

sub today {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        localtime(time);
    return sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
}

open(G, "<$c");
while(<G>) {
    chomp $_;
    my @f = split(";", $_);
    if($f[2] =~ /^((\d\d\d\d)-(\d\d)-(\d\d))/) {
        my $p = "$2-$3";
        my $start = $1;
        my $closed = 1;
        $count{$p}++;
        $comments{$p}+=$f[6];
        
        my $end = $f[3];
        $end =~ s/((\d\d\d\d)-(\d\d)-(\d\d)).*/$1/;
        if(!$end) {
            $end = today();
            $closed = 0;
        }
        my $age = addperiod($start, $end);
        if($closed) {
            # the issue is closed, store the age at the close date
            $closeage{$end} .= "$age ";
            #print "store: $end: $age\n";
        }
    }
}
close(G);

my @range = sort keys %day;
my $start = $range[0];
my $stop = today();
#print "Range: $start - $stop\n";

$d = $start;
my $open;
while(1) {
    my $p = $d;
    $p =~ s/^(\d\d\d\d-\d\d).*/$1/;

    my $c = $day{$d};
    if($c) {
        # otherwise remain at old count
        $open = $c;
    }
    $perm{$p} .= "$open ";

    my $cl = $closeage{$d};
    if($cl) {
        $closes{$p} .= "$cl ";
    }

    $d = nextday($d);
    if($d eq $stop) {
        last;
    }
}

# Store the median number of open issues per day during the month
# Store the median "issue age" per that day
for my $p (sort keys %perm) {
    push @d12, $count{$p};
    if(scalar(@d12) > 12) {
        shift @d12;
    }
    push @c12, $comments{$p};
    if(scalar(@c12) > 12) {
        shift @c12;
    }
    printf "%s-01;%d;%d;%d;%.1f;%.1f;\n",
        $p, $count{$p}, average(@d12), $comments{$p}, average(@c12);
}
