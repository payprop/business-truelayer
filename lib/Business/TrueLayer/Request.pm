package Business::TrueLayer::Request;

=head1 NAME

Business::TrueLayer::Request - abstract class to handle low level request
traffic to TrueLayer, you probably don't need to use this and should use
the main L<Business::TrueLayer> module instead.

=cut

use strict;
use warnings;
use feature qw/ signatures postderef state /;

use Moose;

no warnings qw/ experimental::signatures /;

use Business::TrueLayer::Types;
use Business::TrueLayer::Authenticator;
use Business::TrueLayer::Signer;

use Try::Tiny::SmartCatch;
use Mojo::UserAgent;
use Carp qw/ confess /;
use JSON;
use Data::GUID;

my $MAX_REDIRECTS = 5;

has [ qw/ client_id client_secret kid / ] => (
    is        => 'ro',
    isa       => 'Str',
    required  => 0,
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

has payment_host => (
    is        => 'ro',
    isa       => 'Str',
    required  => 0,
    lazy      => 1,
    default   => sub ( $self ) {
        return join( '.','payment',$self->host );
    }
);

has 'private_key' => (
    is       => 'ro',
    isa      => 'EC512:PrivateKey',
    coerce   => 1,
    required => 0,
);

has '_ua' => (
    is        => 'ro',
    isa       => 'UserAgent',
    required  => 0,
    default   => sub {
        return Mojo::UserAgent->new
            ->max_redirects( $MAX_REDIRECTS )
            ->connect_timeout( 5 )
            ->inactivity_timeout( 5 )
            ->request_timeout( 30 )
        ;
    },
);

has 'authenticator' => (
    is        => 'ro',
    isa       => 'Authenticator',
    lazy      => 1,
    default   => sub ( $self ) {

        Business::TrueLayer::Authenticator->new(
            client_id     => $self->client_id,
            client_secret => $self->client_secret,
            host          => $self->host,
            _ua           => $self->_ua,
        );
    },
);

has 'signer' => (
    is        => 'ro',
    isa       => 'Signer',
    lazy      => 1,
    default   => sub ( $self ) {

        Business::TrueLayer::Signer->new(
            kid         => $self->kid,
            private_key => $self->private_key,
        );
    },
);

sub idempotency_key ( $self ) {
    return Data::GUID->new->as_string;
}

sub api_post (
    $self,
    $absolute_path,
    $http_request_body = undef,
) {
    # sign the request
    my $idempotency_key = $self->idempotency_key;

    my $json = $http_request_body
        ? JSON->new->utf8->canonical->encode( $http_request_body )
        : undef;

    my ( $jws ) = $self->signer->sign_request(
        'POST',
        $absolute_path,
        $idempotency_key,
        $json,
    );

    # POST the request
    my $res = $self->_ua->post(
        "https://@{[ $self->api_host ]}$absolute_path",
        => {
            'Authorization' => "Bearer "
                . $self->authenticator->access_token,
            'Tl-Signature'    => $jws,
            'Idempotency-Key' => $idempotency_key,
            'Accept'        => 'application/json; charset=UTF-8',
            'Content-Type'  => 'application/json; charset=UTF-8',
        }
        => $json
    )->result;

    return $self->_process_response( $res );
}

sub _process_response (
    $self,
    $res
) {
    if ( $res->is_success ) {

        # we don't always have a response body
        if ( $res->body ) {
            return JSON->new->canonical->decode( $res->body );
        }

        return;

    } elsif ( $res->is_error ) {
        confess( "API POST failed: " . $res->message );
    } elsif ( $res->code == 301 ) {
        # possibly a redirect loop
        confess( "API POST failed > $MAX_REDIRECTS levels of redirect" );
    }

    confess( "API POST failed, unknown reason" );
}

sub api_get (
    $self,
    $absolute_path,
) {
    # GET requests don't need to be signed or require an Idempotency-Key
    my $res = $self->_ua->get(
        "https://@{[ $self->api_host ]}$absolute_path",
        => {
            'Authorization' => "Bearer "
                . $self->authenticator->access_token,
            'Accept'        => 'application/json',
            'Content-Type'  => 'application/json',
        }
    )->result;

    return $self->_process_response( $res );
}

1;

# vim: ts=4:sw=4:et
