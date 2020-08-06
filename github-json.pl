#!/usr/bin/perl

#
# This script iterates over all JSON issues and outputs a more condensed
# single CSV file with select info per issue.
#

use JSON;
#use Data::Dumper;
my $cache="stats/gh-cache";

my @json;
if($ARGV[0] ne "") {
    push @json, @ARGV;
}
else {
    opendir(my $dh, $cache) || die "Can't opendir $cache: $!";
    @json = grep { /^(\d+)\.json$/ && -f "$cache/$_" } readdir($dh);
    closedir $dh;
}

# the file is JSON
sub single {
    my ($f)= @_;
    open(F, "<$cache/$f");
    my @j = <F>;
    close(F);
    if(length($j[0]) < 2) {
        # bad file, skip it
        return "";
    }
    my $i = decode_json(join("", @j));
#    print Dumper($i);

    # P = pull-request, I = issue
    my $t = $$i{pull_request}{url} ?"P":"I";
    return ($$i{number},
            $t,
            $$i{created_at},
            $$i{closed_at},
            $$i{user}{login},
            $$i{closed_by}{login},
            $$i{comments});
}

# iterate over the JSON files, sorted numerically
for my $f (sort {$a <=> $b } @json) {
    my ($num, $type, $cr, $cl, $user, $closed, $comments) = single($f);
    if($num) {
        print "$num;$type;$cr;$cl;$user;$closed;$comments\n";
    }
}
