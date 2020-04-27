#!/usr/bin/perl

# USe the remotely generated CSV

open(D, "curl -s https://curl.haxx.se/mail/mail.csv|");

sub libaverage {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $libmails{$y};
    }
    return $sum / scalar(@p);
}

sub useraverage {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $usermails{$y};
    }
    return $sum / scalar(@p);
}

while(<D>) {
    if($_ =~ /(\d\d\d\d-\d\d-\d\d);(\d+);(\d+)/) {
        my ($d, $l, $u)=($1, $2, $3);
        $libmails{$d} = $l;
        $usermails{$d} = $u;
        push @pp, $d;
        if(scalar(@pp) > 12) {
            shift @pp;
        }
        printf "%s;%d;%d;%.1f;%.1f\n",
            $d, $l, $u, libaverage(@pp), useraverage(@pp);
    }
}
close(D);
