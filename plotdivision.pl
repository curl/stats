#!/usr/bin/perl

# the plots are CSV files
#
# the first column must be dates YYYY-MM-DD

my $plot1 = $ARGV[0]; # file name
my $plot2 = $ARGV[1]; # file name

my $col1 = $ARGV[2]; # [date column]:[data column]
my $col2 = $ARGV[3]; # [date column]:[data column]

my $scaler = $ARGV[4]; # scale the values by this number

if(!$col2) {
    print <<USAGE
plotdivision <csv> <csv> <date:data> <date:data>
USAGE
        ;

    exit;
}

my ($coldate1, $coldata1)=split(/:/, $col1);
my ($coldate2, $coldata2)=split(/:/, $col2);

if(!$scaler) {
    $scaler = 1;
}

sub readall {
    my ($f) = @_;
    open(F, "<$f");
    my @all = <F>;
    close(F);
    return @all;
}

my @p1 = readall($plot1);
my @p2 = readall($plot2);

print STDERR <<WILLDO
Date column $coldate1 data $coldata1 from $plot1
 divided by
Date column $coldate2 data $coldata2 from $plot2
WILLDO
    ;

for(@p1) {
    my $e = $_;
    my @s = split(/;/);
    my $date = $s[$coldate1];
    if($date =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) {
        my($year, $mon, $day) = ($1, $2, $3);
        $date=sprintf("%04d-%02d-%02d", $year, $mon, $day);
    }
    else {
        print STDERR "date column in $plot1 is wrong!\n";
        last;
    }
    $day1{$date}=$s[$coldata1];
    $anyday{$date} |= 1;
}

for(@p2) {
    my $e = $_;
    my @s = split(/;/);
    my $date = $s[$coldate2];
    if($date =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) {
        my($year, $mon, $day) = ($1, $2, $3);
        $date=sprintf("%04d-%02d-%02d", $year, $mon, $day);
    }
    else {
        print STDERR "date column in $plot2 is wrong!\n";
        last;
    }
    $day2{$date}=$s[$coldata2];

    $anyday{$date} |= 2;
}

my $d1, $d2;
my $start;

for my $d (sort keys %anyday) {
    if($anyday{$d} & 1) {
        $d1 = $day1{$d};
        $start |= 1;
    }
    if($anyday{$d} & 2) {
        $d2 = $day2{$d};
        $start |= 2;
    }
    my $by = $d2;
    if(($by == 0) || ($start != 3)) {
        next;
    }
    printf "$d;%.6f\n", $d1 / ($by / $scaler);
}
