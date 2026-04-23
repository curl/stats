#!/usr/bin/perl

my $ec = $ARGV[0] || "../everything-curl";

sub words {
    my ($tag, $path) = @_;
    my $num;

    # Get source files to count
    my @files;
    open(G, "(cd $ec && git ls-tree -r --name-only $tag -- $path 2>/dev/null)|");
    while(<G>) {
        chomp;
        if(($_ =~ /\.md\z/) && ($_ !~ /bookindex/)) {
            push @files, $_;
            $num++;
        }
    }
    close(G);

    if(!$num) {
        print STDERR "no files in $tag ?\n";
        return 0;
    }

    my $cmd;
    for(@files) {
        $cmd .= "$tag:$_ ";
    }

    my $w;
#    print STDERR "CMD: cd $ec && git show $cmd\n";
    open(G, "(cd $ec && git show $cmd 2>/dev/null)| wc -w|");
    while(<G>) {
        $w = 0 + $_;
    }
    close(G);

    return ($w);
}

sub show {
    my ($t, $d) = @_;
    my $words = words($t, ".");
    printf "$d;%u\n", $words;
}

open(L, "(cd $ec && git log --reverse --date=iso --pretty=fuller)|");
my $t;
my $prevd;
while(<L>) {
    if(/^commit (.*)/) {
        $t = $1;
    }
    elsif(/^CommitDate:[ \t]+((\d\d\d\d)-(\d\d)-(\d\d))/) {
        my $d = $1;
        # skip updates on the same date
        show($t, $d) if($d ne $prevd);
        $prevd = $d;
    }
}
close(L);
show($t, $prevd);
