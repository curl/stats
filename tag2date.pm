# default ones not present in git
my %tags=('curl-4_0' => '1998-03-20',
          'curl-4_5' => '1998-05-30',
          'curl-4_7' => '1998-07-20',
          'curl-4_9' => '1998-10-07',
          'curl-5_0' => '1998-12-01',
          'curl-5_4' => '1999-01-07',
          'curl-5_11' => '1998-08-25',
          'curl-6_0' => '1999-09-13',
          'curl-7_1' => '2000-08-07',
          'curl-7_4' => '2000-10-16',
    );
sub tag2date {
    my ($t)=@_;

    if($tags{$t}) {
        return $tags{$t};
    }

    open(G, "git show $t --pretty=\"Date: %ci\" -s 2>/dev/null|");
    my $d;
    while(<G>) {
        if($_ =~ /^Date: (\d+-\d+-\d+) (\d+:\d+:\d+)/) {
            # strip off the time zone and time
            $d = "$1";
            last;
        }
    }
    close(G);
    $tags{$t} = $d;
    return $d;
}

1;
