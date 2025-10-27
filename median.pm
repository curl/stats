sub median {
    my @a = @_;
    my @vals = sort {$a <=> $b} @a;
    my $len = @vals;
    if($len%2) { #odd?
        return $vals[int($len/2)];
    }
    else {
        #even
        return ($vals[int($len/2)-1] + $vals[int($len/2)])/2;
    }
}

1;
