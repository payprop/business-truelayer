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

note explain $creds;

ok(
    my $access_token = $TrueLayer->authenticator->access_token,
    'got an acces token'
);

done_testing();
