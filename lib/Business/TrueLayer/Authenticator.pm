package Business::TrueLayer::Authenticator;

=head1 NAME

Business::TrueLayer::Authenticator - Class to handle request authentication

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

use Try::Tiny::SmartCatch;
use Mojo::UserAgent;
use Carp qw/ confess /;
use JSON qw/ decode_json /;

has '_ua' => (
    is        => 'ro',
    isa       => 'UserAgent',
    required  => 0,
    default   => sub {
        return Mojo::UserAgent->new
            ->max_redirects( 0 )
            ->connect_timeout( 5 )
            ->inactivity_timeout( 5 )
            ->request_timeout( 5 )
        ;
    },
);

has [ qw/ auth_host / ] => (
    is        => 'ro',
    isa       => 'Str',
    required  => 0,
    lazy      => 1,
    default   => sub { "auth." . shift->host },
);

has 'scope' => (
    is        => 'rw',
    isa       => 'ArrayRef',
    required  => 0,
    default   => sub { [ qw/ payments / ] },
);

has [ qw/ _auth_token _token_type _refresh_token / ] => (
    is        => 'rw',
    isa       => 'Str',
    required  => 0,
);

has [ qw/ _expires_at / ] => (
    is        => 'rw',
    isa       => 'Int',
    required  => 0,
    default   => sub { time },
);

sub access_token ( $self ) {

    return $self
        ->_authenticate
        ->_auth_token
    ;
}

sub _authenticate ( $self ) {

    if (
        $self->_auth_token
        && $self->_token_type
        && ! $self->_token_is_expired
    ) {
        return $self;
    }

    my $res = $self->_ua->post(
        "https://@{[ $self->auth_host ]}/connect/token"
        => {
            'Accept'       => 'application/json',
            'Content-Type' => 'application/json',
        },
        => json => {
            grant_type    => 'client_credentials',
            client_id     => $self->client_id,
            client_secret => $self->client_secret,
            scope         => join( " ",$self->scope->@* ),
        }
    )->result;

    my $res_content = try sub {
        decode_json( $res->body );
    },
    catch_default sub {
        confess( "TrueLayer response malformed: $res" );
    };

    # Check for errors
    if ( $res_content->{error} ) {
        confess(
            "TrueLayer error while authenticating: "
            . $res_content->{error} . ", description \""
            . $res_content->{error_description} . "\""
            . "Full error JSON: " . $res->body
        );
    }

    $self->_auth_token($res_content->{access_token});
    $self->_expires_at(time + $res_content->{expires_in});
    $self->_token_type($res_content->{token_type});

    $self->_refresh_token($res_content->{refresh_token})
        if $res_content->{refresh_token};

    return $self;
}

sub _token_is_expired ( $self ) {
	return time >= $self->_expires_at;
}

1;

# vim: ts=4:sw=4:et
