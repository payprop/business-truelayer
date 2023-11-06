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

done_testing();
