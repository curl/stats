#!/usr/bin/perl

#
# This script downloads the JSON of every issue and pull-request for the
# project. The initial run will take a while and will likely be stopped
# mid-work (one or more times) due to rate-limiting. Re-run later to top-fill.
#
# After filling up the cache, it will redownload all the issues that are
# (still) marked as open as they might have been closed since last check
#
# NOTE: needs credentials specified in the external file "github-creds" in
# order to avoid the worst rate-limiting.
#

# Open issues:
# https://api.github.com/repos/curl/curl/issues

# Single issue
# https://api.github.com/repos/curl/curl/issues/$num

use JSON;

my $github="https://api.github.com/repos/curl/curl/issues";
my $cache="gh-cache";

# Store github "userid:password" in this file to get better rate-limiting
# No quotes or whitespace but the colon must be there
open(CRED, "<github-creds");
my $creds = <CRED>;
close(CRED);
chomp $creds;

if(!$creds) {
    print "github-cache: Please provide credentials in github-creds!\n";
    exit;
}

# there's probably a proper way to figure out the highest issue number used in
# the project
my $top = 10000;

my $fail=3;
for my $i (1 .. $top) {
    if(-f "$cache/$i.json") {
        # print "$i is cached\n";
    }
    else {
        my $c = "curl -sf -u $creds -A 'curl/curl-repo-stats-bot' $github/$i -o $cache/$i.json";
        print "Downloads issue $i\n";
        my $s = system($c);
        $s >>= 8;
        if(!$s) {
            $fail = 3;
        }
        elsif($s &&!--$fail) {
            ## 22 means 404 basically, so end of the run
            last;
        }
    }
}

print "Range download phase done. Now redownload the open issues\n";

my @json;
opendir(my $dh, $cache) || die "Can't opendir $cache: $!";
@json = grep { /\.json$/ && -f "$cache/$_" } readdir($dh);
closedir $dh;

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
    my $t = $$i{'pull_request'}{'url'} ?"P":"I";
    return ($$i{state} ne "closed" ? $$i{number} : 0);
}

for(@json) {
    my $i = single($_);
    if($i)  {
        my $c = "curl -sf -u $creds -A 'curl/curl-repo-stats-bot' $github/$i -o $cache/$i.json -z $cache/$i.json";
        print "Redownloads issue $i\n";
        my $s = system($c);
    }
}
