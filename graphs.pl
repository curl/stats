#!/usr/bin/perl

chdir "stats";

print <<CACHE
2020-03-20;20;23
2020-03-20;21;25
2020-03-20;22;26
2020-03-24;22;31
2020-03-24;23;33
2020-03-25;24;37
2020-03-27;24;38
2020-03-27;24;39
2020-04-22;25;40
2020-04-22;25;41
2020-04-22;25;42
2020-04-23;25;43
2020-04-26;27;48
2020-04-27;28;52
2020-05-15;29;55
2020-05-16;30;57
2020-06-05;32;60
2020-06-08;32;61
2020-09-08;33;62
2020-09-10;34;65
2020-09-11;34;66
2020-09-29;34;65
2020-09-29;35;68
2020-09-29;35;70
2020-10-06;35;71
2020-10-15;35;72
2020-11-11;36;77
2020-11-17;37;79
2020-12-01;37;81
2020-12-17;37;82
2020-12-18;38;85
2021-01-14;38;86
2021-02-12;39;88
2021-02-19;40;90
2021-03-09;40;91
2021-03-09;40;94
2021-03-09;40;95
2021-03-10;40;96
2021-03-10;40;97
2021-04-09;41;98
2021-04-09;41;100
2021-04-30;41;101
2021-05-04;41;100
2021-06-11;41;101
2021-06-14;41;102
2021-06-16;42;102
2021-06-16;42;103
2021-07-01;43;105
2021-07-01;43;106
2021-07-04;44;107
2021-07-05;45;108
2021-07-07;45;109
2021-09-16;45;111
2021-09-17;46;112
CACHE
    ;

open(L, "git log --reverse --pretty=fuller --date=short --stat --since=2021-09-18 |");
my $hash;
my $prev="0.0";
while(<L>) {
    chomp;
    my $line = $_;
    # store the date first
    if($line =~ /^commit (.*)/) {
        $hash = $1;
    }
    elsif($line =~ /^CommitDate:([ \t]*)(.*)/) {
        my $date = $2;

        if($date =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) {
            $day = "$1-$2-$3";
        }
        my @files = gnuplots($hash);
        my $gr = graphs($hash, @files);
        my $files = scalar(@files);
        if($prev ne "$gr.$files") {
            # only output new output
            printf "%s;%d;%d\n", $day, $files, $gr;
            $prev = "$gr.$files";
        }
    }
}


sub gnuplots {
    my ($tag)=@_;
    open(G, "git show $tag:mksvg.sh 2>/dev/null |");
    my @rl = <G>;
    close(G);
    my @plotfiles;
    for my $r (@rl) {
        if($r =~ /^gnuplot -c stats\/([^ ]*)/) {
            push @plotfiles, $1;
        }
    }

    return @plotfiles;
}

sub graphs {
    my ($tag, @files)=@_;

    my $c =0;
    for my $f (@files) {
        open(G, "git show $tag:$f 2>/dev/null |");
        my @rl = <G>;
        close(G);
        my $pre = $c;
        for my $r (@rl) {
            while($r =~ s/tmp\///) {
                $c++;
            }
        }
    }
    return $c;
}

sub today {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        localtime(time);
    return sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
}

# add current count

$t=`git log --oneline -1 | cut -d" " -f1`;
chomp $t;

my @files = gnuplots($t);
my $gr = graphs($t, @files);
my $files = scalar(@files);
printf "%s;%d;%d\n", today(), $files, $gr;
