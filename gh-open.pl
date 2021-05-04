#!/usr/bin/perl

# get the main CSV and output a new one
my $c = $ARGV[0];

if(!$c) {
    print "Usage: gh-monthly.pl [gh-CSV]\n";
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
        if($open eq $close) {
            last; # no more days
        }
        $day{$open}++; # was open this day
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

sub minimum {
    my @p = @_;
    my @s = sort { $a <=> $b} @p;
    return $s[0];
}

sub maximum {
    my @p = @_;
    my @s = sort { $b <=> $a} @p;
    return $s[0];
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
        my $p = $1;
        my $start = $1;
        my $closed = 1;
        $count{$p}++;
        $counti{$p}++ if($f[1]) eq "I";
        $countp{$p}++ if($f[1]) eq "P";

        my $end = $f[3];
        $end =~ s/((\d\d\d\d)-(\d\d)-(\d\d)).*/$1/;
        if(!$end) {
            $end = today();
            $closed = 0;
        }
        else {
            $closed{$end}++;
        }
        my $age = addperiod($start, $end);
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

    my $c = $day{$d};
    if($c) {
        # otherwise remain at old count
        $open = $c;
    }
    $perm{$p} = $open;

    $d = nextday($d);
    if($d eq $stop) {
        last;
    }
}

# date, number of open issues end of today, created today, closed today,
# 90 day minimum, 90 day maximum
for my $p (sort keys %perm) {
    push @pp, $perm{$p};
    if(scalar(@pp) > 90) {
        shift @pp;
    }
    printf "%s;%d;%.1f;%d;%d;%d;%d\n", $p, $perm{$p}, average(@pp),
        $count{$p}, $closed{$p}, minimum(@pp), maximum(@pp);
}
