package Business::TrueLayer::Authenticator;

=head1 NAME

Business::TrueLayer::Authenticator - Class to handle low level request
authentication, you probably don't need to use this and should use the
main L<Business::TrueLayer> module instead.

=cut

use strict;
use warnings;
use feature qw/ signatures postderef /;

use Moose;
extends 'Business::TrueLayer::Request';

no warnings qw/ experimental::signatures experimental::postderef /;

use Business::TrueLayer::Types;

use Try::Tiny::SmartCatch;
use Mojo::UserAgent;
use Carp qw/ croak /;
use JSON;

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

    my $url = "https://" . $self->auth_host . "/connect/token";
    my $res = $self->_ua->post(
        $url,
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

    my $type = $res->headers->content_type;
    my $code = $res->code;

    croak( "TrueLayer POST $url returned $code with no MIME type" )
        unless defined $type;
    croak( "TrueLayer POST $url returned $code $type not JSON, status line: "
               . $res->message)
        unless $type =~ m!\Aapplication/(?:problem\+)?JSON\b!i;

    my $body = $res->body;

    croak( "TrueLayer POST $url returned $code with an empty body" )
        unless length $body;

    my $res_content = try sub {
        JSON->new->canonical->decode( $body );
    },
    catch_default sub {
        croak( "TrueLayer POST $url returned $code with malformed JSON length @{[ length $body ]}: $_" );
    };
    croak( "TrueLayer POST $url returned $code JSON $res_content" )
                 unless ref $res_content eq 'HASH';

    unless( $res->is_success ) {
        my $title = $res_content->{title};
        if ( length $title ) {
            # This is looking like an error format we expect:
            # https://docs.truelayer.com/docs/payments-api-errors
            my $detail = $res_content->{detail};
            my $message = defined $detail ? "$title - $detail" : $title;

            croak( "TrueLayer POST $url returned $code: $message" );
        }

        my $error = $res_content->{error};
        if ( length $error ) {
            # This is looking like the error format for the Access tokens
            # and the Data API
            # https://docs.truelayer.com/reference/generateaccesstoken
            my $detail = $res_content->{error_description};
            my $message = defined $detail ? "'$error' - $detail" : "'$error'";
            # There's no : in this message so that we distinguish it from the
            # message generated for the croak above.
            # (ie we can tell which format the API is actually responding
            # with, whatever the docs might claim)
            croak( "TrueLayer POST $url returned $code $message" );
        }

        # This is not in spec:
        croak( "TrueLayer POST $url returned $code with JSON keys "
                   . join( ', ', map { "'$_'" } sort keys %$res_content )
                   . ' and status line: '  . $res->message);
    }

    # If any of these are missing, we get "interesting" errors from Moose
    # constraint violations.
    for my $key ( qw/ access_token expires_in token_type refresh_token / ) {
        my $val = $res_content->{ $key };
        if ( !length $val ) {
            # refresh_token is optional
            next
                if $key eq 'refresh_token';
            croak( "TrueLayer POST $url missing key $key - we have "
                       . join( ', ', map { "'$_'" } sort keys %$res_content ) );
        }
        if( $key eq 'expires_in' ) {
            $self->_expires_at(time + $val);
        } else {
            my $method = $key eq 'access_token' ? '_auth_token' : "_$key";
            $self->$method( $val );
        }
    }

    return $self;
}

sub _token_is_expired ( $self ) {
	return time >= $self->_expires_at;
}

1;

# vim: ts=4:sw=4:et
