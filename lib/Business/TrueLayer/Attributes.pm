package Business::TrueLayer::Attributes;

use strict;
use warnings;

use Moose;

has [ qw/ client_id client_secret host / ] => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

1;
