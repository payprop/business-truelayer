#!perl

use strict;
use warnings;

use Test::Most;

use_ok( 'Business::TrueLayer::MerchantAccount' );
use_ok( 'Business::TrueLayer::MerchantAccount::Identifier' );

my $MerchantAccount = Business::TrueLayer::MerchantAccount->new(
    'id' => '5b7adbf4-f289-48a7-b451-bc236443397c',
    'available_balance_in_minor' => 90000,
    'currency' => 'GBP',
    'current_balance_in_minor' => 100000,
    'account_holder_name' => 'btdt',
    'account_identifiers' => [

        # one an object, one a hashref to test coercion
        Business::TrueLayer::MerchantAccount::Identifier->new(
            'account_number' => '00033171',
            'sort_code' => '040668',
            'type' => 'sort_code_account_number'
        ),
        {
            'iban' => 'GB05CLRB04066800033171',
            'type' => 'iban'
        },
    ],
);

isa_ok(
    $MerchantAccount,
    'Business::TrueLayer::MerchantAccount',
);

is( $MerchantAccount->id,'5b7adbf4-f289-48a7-b451-bc236443397c','->id' );
is( $MerchantAccount->available_balance_in_minor,90000,'->available_balance_in_minor' );
is( $MerchantAccount->current_balance_in_minor,100000,'->current_balance_in_minor' );
is( $MerchantAccount->currency,'GBP','->currency' );
is( $MerchantAccount->account_holder_name,'btdt','->account_holder_name' );

done_testing();
