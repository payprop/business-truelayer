#!perl

use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib $Bin;

use Test::Most;
use Test::Credentials;
use Business::TrueLayer;

plan skip_all => "set TRUELAYER_CREDENTIALS"
    if ! $ENV{TRUELAYER_CREDENTIALS};

my $TrueLayer = Business::TrueLayer->new(
    my $creds = Test::Credentials->new->TO_JSON,
);

my ( $jws ) = $TrueLayer->signer->sign_request(
    'post',
    '/payouts',
    '{}',
);

ok( $jws,'->sign_request' );

done_testing();
