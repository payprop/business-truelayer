package Business::TrueLayer::Attributes;

use strict;
use warnings;

use Moose;

has [ qw/ client_id client_secret host / ] => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

has 'kid' => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);

has 'private_key' => (
    is       => 'ro',
    isa      => 'EC512:PrivateKey',
    coerce   => 1,
    required => 0,
);

1;

# vim: ts=4:sw=4:et
