#!/usr/bin/perl

require "./stats/tag2date.pm";

sub num {
    my ($t)=@_;
    if($t =~ /^curl-(\d)_(\d+)_(\d+)/) {
        return 10000*$1 + 100*$2 + $3;
    }
    elsif($t =~ /^curl-(\d)_(\d+)/) {
        return 10000*$1 + 100*$2;
    }
}


sub sortthem {
    return num($a) <=> num($b);
}

@alltags= `git tag -l`;

sub count {
    my ($file) = @_;
    my @num = `git show $file 2>/dev/null| wc -l`;
    return 0 + $num[0];
}

foreach my $t (@alltags) {
    chomp $t;
    if($t =~ /^curl-([0-9_]*[0-9])\z/) {
        push @releases, $t;
    }
}

print <<CACHE
curl 5.9;1999-05-22;317
curl 6.1;1999-10-17;335
curl 6.3.1;1999-11-23;398
curl 6.5;2000-03-14;596
curl 6.5.1;2000-03-21;598
curl 6.5.2;2000-03-21;598
CACHE
    ;
foreach my $t (sort sortthem @releases) {
    my $d = tag2date($t);
    my $v = $t;
    $v =~ s/_/./g;
    $v =~ s/-/ /g;
    my $lines = count("$t:docs/curl.1");
    if($lines) {
        printf "$v;$d;%u\n", $lines;
    }
    if(num($t) == 75201) {
        # 7.52.1 was the last to have it like this
        last;
    }
}

print <<CACHE
curl 7.55.0;2017-08-09;2781
curl 7.60.0;2018-05-15;2955
curl 7.65.0;2019-05-22;3056
curl 7.70.0;2020-04-29;3193
curl 7.75.0;2021-02-03;3445
curl 7.77.0;2021-05-26;3472
curl 7.78.0;2021-07-21;3463
curl 7.79.0;2021-09-14;4723
curl 7.80.0;2021-11-10;4658
curl 7.81.0;2022-01-05;4964
curl 7.82.0;2022-03-05;4974
curl 7.83.0;2022-04-27;5009
curl 7.84.0;2022-06-27;5207
curl 7.85.0;2022-08-31;5206
curl 7.86.0;2022-10-26;5666
curl 7.87.0;2022-12-21;5697
curl 7.88.0;2023-02-15;5763
curl 7.88.1;2023-02-20;5766
curl 8.0.0;2023-03-20;5769
curl 8.1.0;2023-05-17;5855
curl 8.4.0;2023-10-11;6188
curl 8.6.0;2024-01-31;6076
curl 8.8.0;2024-05-22;6148
curl 8.10.0;2024-09-11;6517
curl 8.11.0;2024-11-06;6567
curl 8.12.1;2025-02-05;6448
curl 8.13.0;2025-04-02;6777
curl 8.14.0;2025-05-28;6808
curl 8.15.0;2025-06-16;6809
curl 8.16.0;2025-09-10;7008
CACHE
    ;
