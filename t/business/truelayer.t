#!perl

use strict;
use warnings;

use Test::Most;

use_ok( 'Business::TrueLayer' );
isa_ok(
    my $TrueLayer = Business::TrueLayer->new(
        client_id => 'TL-CLIENT-ID',
        client_secret => 'super-secret-client-secret',
        host => '/dev/null',
    ),
    'Business::TrueLayer'
);

isa_ok(
    $TrueLayer->authenticator,
    'Business::TrueLayer::Authenticator'
);

subtest '->merchant_accounts' => sub {

    no warnings qw/ once redefine /;
    *Business::TrueLayer::Request::api_get = sub {
        return {
            items => [ {
                'id' => '5b7adbf4-f289-48a7-b451-bc236443397c',
                'available_balance_in_minor' => 90000,
                'currency' => 'GBP',
                'current_balance_in_minor' => 100000,
                'account_holder_name' => 'btdt',
                'account_identifiers' => [
                    {
                        'account_number' => '00033171',
                        'sort_code' => '040668',
                        'type' => 'sort_code_account_number'
                    },
                    {
                        'iban' => 'GB05CLRB04066800033171',
                        'type' => 'iban'
                    },
                ],
            }
        ] };
    };

    isa_ok(
        ( $TrueLayer->merchant_accounts )[0],
        'Business::TrueLayer::MerchantAccount',
    );
};

done_testing();
