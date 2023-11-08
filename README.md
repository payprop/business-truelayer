# NAME

Business::TrueLayer - Perl library for interacting with the TrueLayer v3 API
(https://docs.truelayer.com/)

# VERSION

v0.01

# SYNOPSIS

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

# DESCRIPTION

[Business::TrueLayer](https://metacpan.org/pod/Business%3A%3ATrueLayer) is a client library for interacting with the
TrueLayer v3 API. It implementes the necesary signing and transport logic
to allow you to just focus on just the endpoints you want to call.

The initial version of this distribution supports just those steps that
described at [https://docs.truelayer.com/docs/quickstart-make-a-payment](https://docs.truelayer.com/docs/quickstart-make-a-payment)
and others will be added as necessary (pull requests also welcome).

# DEBUGGING

Set `MOJO_CLIENT_DEBUG=1` for user agent and transport debug output.

# METHODS

## test\_signature

Tests if your signature and signing is valid.

    $TrueLayer->test_signature;

Returns 1 on success, throws an exception otherwise.

## access\_token

Get an access token.

    my $access_token = $TrueLayer->access_token;

Returns an access token on success, throws an exception otherwise.

## merchant\_accounts

Get a list of merchant accounts, `$id` is optional to specifiy just one.

    my @merchant_accounts = $TrueLayer->merchant_accounts( $id );

Returns a list of [Business::TrueLayer::MerchantAccount](https://metacpan.org/pod/Business%3A%3ATrueLayer%3A%3AMerchantAccount) objects.

# SEE ALSO

[Business::TrueLayer::MerchantAccount](https://metacpan.org/pod/Business%3A%3ATrueLayer%3A%3AMerchantAccount)
