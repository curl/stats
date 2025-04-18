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
# https://api.github.com/repos/$owner/$repo/issues

# Single issue
# https://api.github.com/repos/$owner/$repo/issues/$num

use JSON;
#use Data::Dumper;

use Getopt::Long;
use Pod::Usage;

my $man = 0;
my $help = 0;

my $owner = 'curl';
my $repo = 'curl';
GetOptions ('owner=s' => \$owner,
            'repo=s' => \$repo,
            'help|?' => \$help,
            man => \$man) or pod2usage(2);

pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;


my $agent = "$owner/$repo-repo-stats-bot";

my $github="https://api.github.com/repos/$owner/$repo/issues";
my $cache="gh-cache";

if( not -d $cache) {
    die "directory $cache does not exist.\n";
}

if( not -w $cache) {
    die "directory $cache not writeable.\n";
}

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

unless($lastnum =~ /^\d+\z/) {
    die "Error fetching last issue. Got: $lastnum";
    exit;
}

my $top = $lastnum;

for my $i (1 .. $top) {
    if(-f "$cache/$i.json") {
        # print "$i is cached\n";
    }
    else {
        my $c = "curl -sf -u $creds -A '$agent' $github/$i > $cache/$i.json";
        print "Downloads issue $i\n";
        my $s = system($c);
        $s >>= 8;
        if(!$s) {
            $fail = 3;
        }
        else {
            print "... $i failed\n";
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

sub redownload {
    my ($i) = @_;
    my $c = "curl -sf -u $creds -A '$agent' $github/$i -o $cache/$i.json -z $cache/$i.json";
    print "Redownloads issue $i\n";
    my $s = system($c);
}

for my $j (@json) {
    my $i = single($j);
    if($i)  {
        redownload($i);
    }
    else {
        # randomly get 1% of the old issues
        if(rand(1000) < 10) {
            $j =~ s/\.json//;
            print "Randomly... ";
            redownload($j);
        }
    }
}

__END__

=head1 NAME

github-cache.pl - Cache GitHub issue data

=head1 SYNOPSIS

github-cache.pl [options]

 Options:
   -owner           repository owner
   -repo            repository name
   -help            brief help message
   -man             full documentation

=head1 OPTIONS

=over 8

=item B<-owner>

Owner of the repository to be cached

=over 8

=item B<-repo>

Name of the repository to be cached

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<github-cache.pl> saves data about GitHub issues for a particular
repository.

=cut
