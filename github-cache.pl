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
#use Data::Dumper;

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

# Figure out the highest number used currently

my @j=`curl -s $github`;
my $i = decode_json(join("", @j));
#print Dumper($i);
my $lastnum = $$i[0]{number};

if($lastnum < 6592) {
    print STDERR "Error, bail out!\n";
    exit;
}

my $top = $lastnum;

my @dl;
my $c;
for my $i (1 .. $top) {
    if(-f "$cache/$i.json") {
        # print "$i is cached\n";
    }
    else {
        $c .= "$github/$i -o $cache/$i.json ";
        push @dl, "$i";
    }
}

if(scalar(@dl)) {
    printf "Download %d issues\n", scalar(@dl);
    my $cmd = "curl -Z -sf -u $creds -A 'curl/curl-repo-stats-bot' $c";
    my $s = system($cmd);
}
print "Range download phase done. Now redownload the open issues\n";

opendir(my $dh, $cache) || die "Can't opendir $cache: $!";
my @json = grep { /\.json$/ && -f "$cache/$_" } readdir($dh);
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

$c = ""; # start over
undef @dl;
sub redownload {
    my ($i) = @_;
    $c .= "$github/$i -o $cache/$i.json -z $cache/$i.json ";
    push @dl, "$i";
}

printf "Interate over %d local JSON files\n", scalar(@json);

for my $j (@json) {
    my $i = single($j);
    if($i)  {
        redownload($i);
    }
    else {
        # randomly get 1% of the old issues
        if(rand(1000) < 10) {
            $j =~ s/\.json//;
            redownload($j);
        }
    }
}

printf "Redownload %d issues\n", scalar(@dl);
my $cmd = "curl -Z -u $creds -A 'curl/curl-repo-stats-bot' $c";
my $s = system($cmd);
