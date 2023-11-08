package Business::TrueLayer;

=head1 NAME

Business::TrueLayer - Perl library for interacting with the TrueLayer v3 API
(https://docs.truelayer.com/)

=head1 VERSION

v0.01

=head1 SYNOPSIS

    my $TrueLayer = Business::TrueLayer->new(

        # required constructor arguments
        client_id     => $truelayer_client_id,
        client_secret => $truelauer_client_secret,
        kid           => $truelayer_kid,
        private_key   => '/path/to/private/key',

        # optional constructor arguments (with defaults)
        host          => 'truelayer.com',
        api_host      => 'api.truelayer.com',
        auth_host     => 'auth.truelayer.com',
    );

    # valid your setup (neither required in live usage):
    $TrueLayer->test_signature;
    my $access_token = $TrueLayer->access_token;

=head1 DESCRIPTION

L<Business::TrueLayer> is a client library for interacting with the
TrueLayer v3 API. It implementes the necesary signing and transport logic
to allow you to just focus on just the endpoints you want to call.

The initial version of this distribution supports just those steps that
described at L<https://docs.truelayer.com/docs/quickstart-make-a-payment>
and others will be added as necessary (pull requests also welcome).

=head1 DEBUGGING

Set C<MOJO_CLIENT_DEBUG=1> for user agent and transport debug output.

=cut

use strict;
use warnings;
use feature qw/ signatures postderef /;

use Moose;
extends 'Business::TrueLayer::Request';
no warnings qw/ experimental::signatures /;

use Business::TrueLayer::Types;
use Business::TrueLayer::Authenticator;
use Business::TrueLayer::Signer;
use Business::TrueLayer::MerchantAccount;

$Business::TrueLayer::VERSION = '0.01';

=head1 METHODS

=head2 test_signature

Tests if your signature and signing is valid.

    $TrueLayer->test_signature;

Returns 1 on success, throws an exception otherwise.

=cut

sub test_signature ( $self ) {

    $self->api_post(
        '/test-signature',
        { nonce => "9f952b2e-1675-4be8-bb39-6f4343803c2f" },
    );

    return 1;
}

=head2 access_token

Get an access token.

    my $access_token = $TrueLayer->access_token;

Returns an access token on success, throws an exception otherwise.

=cut

sub access_token ( $self ) {
    return $self->authenticator->access_token;
}

=head2 merchant_accounts

Get a list of merchant accounts, C<$id> is optional to specifiy just one.

    my @merchant_accounts = $TrueLayer->merchant_accounts( $id );

Returns a list of L<Business::TrueLayer::MerchantAccount> objects.

=cut

sub merchant_accounts (
    $self,
    $id = undef
) {
    my $data = $self->api_get(
        "/v3/merchant-accounts" . ( $id ? "/$id" : "" )
    );

    my @merchants_accounts;

    foreach my $item ( $data->{items}->@* ) {
        push(
            @merchants_accounts,
            Business::TrueLayer::MerchantAccount->new( $item->%* ),
        );
    }

    return @merchants_accounts;
}

1;

=head1 SEE ALSO

L<Business::TrueLayer::MerchantAccount>

=cut

# vim: ts=4:sw=4:et
