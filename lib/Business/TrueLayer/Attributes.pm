package Business::TrueLayer::Attributes;

use strict;
use warnings;

use feature qw/ signatures postderef /;

use Moose;
no warnings qw/ experimental::signatures /;

has [ qw/ client_id client_secret / ] => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

has 'host' => (
    is        => 'ro',
    isa       => 'Str',
    required  => 0,
    default   => sub ( $self ) {
        'truelayer.com',
    }
);

has api_host => (
    is        => 'ro',
    isa       => 'Str',
    required  => 0,
    lazy      => 1,
    default   => sub ( $self ) {
        return join( '.','api',$self->host );
    }
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
