package Business::TrueLayer;

=head1 NAME

Business::TrueLayer - Perl libray for interacting with the TrueLayer v3 API
(https://docs.truelayer.com/)

=head1 SYNOPSIS



=head1 DESCRIPTION



=cut

use strict;
use warnings;
use feature qw/ signatures /;

use Moose;
extends 'Business::TrueLayer::Attributes';
no warnings qw/ experimental::signatures /;

use Business::TrueLayer::Types;
use Business::TrueLayer::Authenticator;

$Business::TrueLayer::VERSION = '0.01';

has 'authenticator' => (
    is        => 'ro',
    isa       => 'Authenticator',
	lazy      => 1,
    default   => sub ( $self ) {

		Business::TrueLayer::Authenticator->new(
			client_id     => $self->client_id,
			client_secret => $self->client_secret,
			host          => $self->host,
		);
	},
);

1;

# vim: ts=4:sw=4:et
