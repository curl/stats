#!/usr/bin/perl

require "./stats/tag2date.pm";

my %authors;

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

foreach my $t (@alltags) {
    chomp $t;
    if($t =~ /^curl-([0-9_]*[0-9])\z/) {
        push @releases, $t;
    }
}


sub singlefile {
    my ($tag, $f) = @_;
    open(G, "git blame -CCC --line-porcelain $f $tag|");
    my $author;
    while(<G>) {
        if(/^author (.*)/) {
            $authors{$1}++;    # per this tag
        }
    }
    close(G);
}

sub numlines {
    my ($amount) = @_;
    my $num = 0;
    for my $a (keys %authors) {
        if($authors{$a} >= $amount) {
            $num++;
        }
    }
    return $num;
}

sub show {
    my ($tag, $date) = @_;
    my @f=`git ls-tree -r --name-only $tag -- src lib include 2>/dev/null`;

    for my $e (@f) {
        chomp $e;
        if(($e =~ /\.[ch]\z/) || ($e =~ /makefile/i)) {
            singlefile($tag, $e);
        }
    }

    # number of people with code left.
    # one line, ten lines, hundred lines, thousand lines etc
    printf "$date;%u;%u;%u;%u;%u;%u\n", scalar(%authors),
        numlines(10), numlines(100), numlines(1000), numlines(10000),
        numlines(100000);
    undef %authors;
}

print <<CACHE
2000-03-14;1;1;1;1;1;0
2000-03-21;1;1;1;1;1;0
2000-03-21;1;1;1;1;1;0
2000-08-21;1;1;1;1;1;0
2000-08-30;1;1;1;1;1;0
2000-09-28;1;1;1;1;1;0
2000-10-16;1;1;1;1;1;0
2000-12-04;1;1;1;1;1;0
2001-01-05;1;1;1;1;1;0
2001-01-27;1;1;1;1;1;0
2001-02-13;1;1;1;1;1;0
2001-03-22;1;1;1;1;1;0
2001-04-04;1;1;1;1;1;0
2001-04-23;1;1;1;1;1;0
2001-05-07;1;1;1;1;1;0
2001-06-07;2;2;1;1;1;0
2001-08-20;3;2;2;1;1;0
2001-09-25;3;2;2;1;1;0
2001-11-04;3;3;2;1;1;0
2001-12-05;3;2;2;1;1;0
2002-01-23;3;3;2;1;1;0
2002-02-05;3;3;2;1;1;0
2002-03-07;3;3;2;1;1;0
2002-04-15;3;3;2;1;1;0
2002-05-13;3;3;2;1;1;0
2002-06-13;3;3;2;1;1;0
2002-10-01;4;4;2;1;1;0
2002-10-11;4;4;2;1;1;0
2002-11-18;4;4;2;1;1;0
2003-01-14;5;5;2;1;1;0
2003-04-02;5;5;3;1;1;0
2003-05-19;5;5;3;1;1;0
2003-07-28;5;5;3;1;1;0
2003-08-15;5;5;3;1;1;0
2003-11-01;5;5;3;1;1;0
2004-01-22;5;5;3;1;1;0
2004-03-18;5;5;3;1;1;0
2004-04-26;5;5;3;1;1;0
2004-06-02;5;5;3;1;1;0
2004-08-10;6;6;3;1;1;0
2004-10-18;7;7;4;1;1;0
2004-12-20;8;8;4;1;1;0
2005-02-01;8;8;4;2;1;0
2005-03-04;8;8;4;2;1;0
2005-04-05;8;8;5;2;1;0
2005-05-16;9;8;5;2;1;0
2005-09-01;9;8;5;2;1;0
2005-10-13;9;8;5;2;1;0
2005-12-06;9;8;5;2;1;0
2006-02-27;10;9;6;2;1;0
2006-03-20;10;9;6;2;1;0
2006-06-12;10;9;6;2;1;0
2006-08-07;10;9;6;2;1;0
2006-10-29;10;9;6;3;1;0
2007-01-29;11;10;6;4;1;0
2007-04-11;11;10;6;4;1;0
2007-06-25;12;11;7;5;1;0
2007-07-10;12;11;7;5;1;0
2007-09-13;13;12;8;6;1;0
2007-10-29;13;12;8;7;1;0
2008-01-28;13;12;8;6;1;0
2008-03-30;14;13;9;6;1;0
2008-06-04;14;14;9;6;1;0
2008-09-01;14;14;9;6;1;0
2008-11-05;14;14;9;6;1;0
2008-11-13;14;14;9;6;1;0
2009-01-19;14;14;9;6;1;0
2009-03-02;14;14;9;6;1;0
2009-05-18;14;14;9;6;1;0
2009-08-12;15;15;10;6;1;0
2009-11-04;15;15;10;6;1;0
2010-02-09;17;17;11;6;1;0
2010-04-14;23;21;12;6;1;0
2010-06-16;34;30;17;8;1;0
2010-08-11;39;33;17;8;1;0
2010-10-12;42;35;19;8;1;0
2010-12-15;48;37;20;9;2;0
2011-02-17;59;44;24;9;2;0
2011-04-17;68;48;25;9;2;0
2011-04-22;69;49;25;9;2;0
2011-06-23;73;50;26;8;2;0
2011-09-13;80;55;28;7;2;0
2011-11-14;83;57;26;7;2;0
2011-11-17;83;57;26;7;2;0
2012-01-24;94;64;29;7;2;0
2012-03-22;97;66;31;7;2;0
2012-05-24;101;70;33;7;2;0
2012-07-27;104;74;37;8;2;0
2012-10-10;107;78;38;10;2;0
2012-11-20;113;81;39;10;2;0
2013-02-06;118;82;41;10;2;0
2013-04-12;128;87;44;11;2;0
2013-06-22;132;89;45;11;2;0
2013-08-11;132;89;44;11;2;0
2013-10-13;138;94;47;11;2;0
2013-12-16;144;97;49;11;2;0
2014-01-29;150;99;49;11;2;0
2014-03-26;159;103;52;12;2;0
2014-05-20;162;106;52;12;2;0
2014-07-16;170;110;53;12;2;0
2014-09-10;180;116;57;12;2;0
2014-11-05;187;121;58;12;2;0
2015-01-07;191;125;59;13;3;0
2015-02-25;196;126;59;13;2;0
2015-04-22;201;130;59;13;2;0
2015-04-28;201;130;59;13;2;0
2015-06-17;208;135;58;13;2;0
2015-08-11;210;137;59;13;2;0
2015-10-07;217;143;58;13;2;0
2015-12-01;225;146;60;13;3;0
2016-01-27;228;149;61;13;3;0
2016-02-08;228;149;60;14;3;0
2016-03-23;236;154;61;14;3;0
2016-05-17;245;159;63;14;3;0
2016-05-30;245;159;63;14;3;0
2016-07-21;251;164;62;14;3;0
2016-08-03;252;164;62;14;3;0
2016-09-07;259;168;63;14;3;0
2016-09-14;260;168;63;14;3;0
2016-11-02;264;167;63;14;3;0
2016-12-20;267;169;65;15;3;0
2016-12-22;267;169;65;15;3;0
2017-02-22;276;174;65;15;3;0
2017-02-24;277;174;65;15;3;0
2017-04-19;286;180;67;15;3;0
2017-06-14;289;180;67;15;3;0
2017-08-09;293;182;68;15;3;0
2017-08-13;298;183;68;15;3;0
2017-10-04;299;180;66;16;3;0
2017-10-23;302;182;66;16;3;0
2017-11-29;304;184;66;15;3;0
2018-01-23;315;187;66;16;3;0
2018-03-13;321;191;66;16;3;0
2018-05-15;339;202;70;16;3;0
2018-07-11;350;207;72;16;3;0
2018-09-04;359;211;72;16;3;0
2018-10-30;367;213;74;16;3;0
2018-12-12;374;217;72;16;3;0
2019-02-06;382;221;74;16;3;0
2019-03-27;384;223;76;16;3;0
2019-05-22;392;224;76;16;3;0
2019-06-04;395;224;76;16;3;0
2019-07-17;398;226;75;16;3;0
2019-07-19;398;226;75;16;3;0
2019-09-10;407;231;77;16;3;0
2019-11-05;422;240;78;16;3;0
2020-01-08;428;244;82;16;3;0
2020-03-04;432;246;81;16;3;0
2020-03-11;433;247;81;16;3;0
2020-04-29;435;247;85;16;3;0
2020-06-23;441;251;86;16;3;0
2020-06-30;441;250;85;16;3;0
2020-08-19;449;255;85;18;3;0
2020-10-14;459;257;85;17;3;0
2020-12-09;461;256;84;17;3;0
2021-02-03;469;256;86;14;3;0
2021-03-31;476;258;88;14;3;0
2021-04-14;478;259;88;14;3;0
2021-05-26;484;267;87;15;3;0
2021-07-21;502;276;89;15;2;0
2021-09-14;512;284;88;15;2;0
2021-09-22;511;284;88;15;2;0
2021-11-10;527;291;90;16;2;0
2022-01-05;533;292;92;16;3;0
2022-03-05;542;297;92;14;3;0
2022-04-27;548;299;94;15;3;0
2022-05-11;551;301;94;14;3;0
2022-06-27;562;307;97;14;3;0
2022-08-31;576;312;98;14;3;0
2022-10-26;581;312;97;13;3;0
2022-12-21;590;318;97;15;3;0
2023-02-15;588;311;96;15;4;0
2023-02-20;587;311;96;15;4;0
2023-03-20;585;311;95;15;4;0
2023-03-20;585;311;95;15;4;0
2023-05-17;589;311;95;14;4;0
2023-05-23;593;311;96;14;4;0
2023-05-30;593;311;96;14;4;0
2023-07-19;601;315;96;14;4;0
2023-07-26;602;316;96;14;4;0
2023-09-13;607;315;95;13;3;0
2023-10-11;610;316;96;12;3;0
2023-12-06;618;319;97;12;3;0
2024-01-31;619;318;97;12;3;0
2024-03-27;623;312;97;12;3;0
2024-03-27;623;312;97;12;3;0
CACHE
    ;

foreach my $t (sort sortthem @releases) {
    if(num($t) <= 0) {
        next;
    }
    my $d = tag2date($t);
    show($t, $d);
}
