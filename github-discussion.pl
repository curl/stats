#!/usr/bin/perl

#
# This script downloads the JSON of every Discussion thread for the
# project. The initial run will take a while and will likely be stopped
# mid-work (one or more times) due to rate-limiting. Re-run later to top-fill.
#
# After filling up the cache, it will redownload all the issues that are
# (still) marked as open as they might have been closed since last check
#
# NOTE: needs credentials specified in the external file "github-creds" in
# order to avoid the worst rate-limiting.
#

# GraphQL API for Discussions
# https://docs.github.com/en/graphql/guides/using-the-graphql-api-for-discussions

# Pagination for the GraphQL API
# https://docs.github.com/en/graphql/guides/using-pagination-in-the-graphql-api

use JSON;
use Data::Dumper;

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

my $graphql="https://api.github.com/graphql";

my $count_query="
query {
  repository(owner: \\\"$owner\\\", name: \\\"$repo\\\") {
    discussions {
      totalCount
    }
  }
}";
$count_query =~ tr/\n//d;
#print $count_query;

my $page = 100;
my $discussion_query="
query {
  repository(owner: \\\"$owner\\\", name: \\\"$repo\\\") {
    discussions(first: $page, after: %s) {
      edges {
        node {
          databaseId
          number
        }
      }
      pageInfo {
        endCursor
        startCursor
        hasNextPage
        hasPreviousPage
      }
    }
  }
}";
$discussion_query =~ tr/\n//d;
#print $discussion_query;

my $discussion_json="https://api.github.com/repos/$owner/$repo/discussions";


my $cache="discussion-cache";

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

my @j=`curl -s -u $creds -A '$agent' $graphql -d '{ \"query\": \"$count_query\"}'`;
my $i = decode_json(join("", @j));
#print Dumper($$i{data}{repository}{discussions}{totalCount});

my $lastnum = $$i{data}{repository}{discussions}{totalCount};

unless($lastnum =~ /^\d+\z/) {
    die "Error fetching last issue. Got: $lastnum";
    exit;
}

my $top = $lastnum;

my $cursor = "null";
my $nextpage = true;

while ($nextpage) {
    my $query = sprintf($discussion_query, $cursor);
    print "$query\n";

    my @j=`curl -s -u $creds -A '$agent' $graphql -d '{ \"query\": \"$query\"}'`;

    print "curl -s -u $creds -A '$agent' $graphql -d '{ \"query\": \"$query\"}'";
    my $i = decode_json(join("", @j));
    #print Dumper($$i{data}{repository}{discussions}{edges}[0]);

    $cursor="\\\"$$i{data}{repository}{discussions}{pageInfo}{endCursor}\\\"";
    print "$cursor\n";

    $nextpage = $$i{data}{repository}{discussions}{pageInfo}{hasNextPage};
    print Dumper($$i{data}{repository}{discussions}{pageInfo});

    #print encode_json $$i{data}{repository}{discussions}{edges};


    @threads=@{$$i{data}{repository}{discussions}{edges}};


    foreach (@threads){
        my $i=${$_}{node}{number};
        my $c = "curl -sf -u $creds -A '$agent' $discussion_json/$i > $cache/$i.json";
        print "Download discussion $i\n";
        my $s = system($c);
        $s >>= 8;
        if(!$s) {
            $fail = 3;
        }
        else {
            print "... $i failed\n";
        }
    };
};

=pod

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
=cut
__END__

=head1 NAME

github-discussion.pl - Cache GitHub discussion data

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

B<github-discussion.pl> saves data about GitHub Discussions for a particular
repository.

=cut
