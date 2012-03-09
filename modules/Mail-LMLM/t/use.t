#!/usr/bin/perl -w

use strict;

use Test::More tests => 2;

BEGIN
{
    use_ok ('Mail::LMLM');
    use_ok ('Mail::LMLM::Render::HTML');
}

