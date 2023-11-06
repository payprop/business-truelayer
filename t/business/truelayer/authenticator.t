#!perl

use strict;
use warnings;

use Test::Most;
use Test::MockObject;
use JSON qw/ encode_json /;

use_ok( 'Business::TrueLayer::Authenticator' );

isa_ok(
    my $Authenticator = Business::TrueLayer::Authenticator->new(
        _ua => my $mo = Test::MockObject->new,
        client_id => 'TL-CLIENT-ID',
        client_secret => 'super-secret-client-secret',
        host => '/dev/null',
    ),
    'Business::TrueLayer::Authenticator',
);

$mo->mock( post => sub { shift } );
$mo->mock( result  => sub { shift } );

$mo->mock(
    body => sub {
        return encode_json({
            access_token  => "AAABBBCCCDDD",
            expires_in    => 3600,
            token_type    => "Bearer",
        });
    }
);

isa_ok(
    $Authenticator->_authenticate,
    'Business::TrueLayer::Authenticator',
);

is( $Authenticator->access_token,'AAABBBCCCDDD','->access_token' );
is( $Authenticator->_auth_token,'AAABBBCCCDDD','->_auth_token' );
ok( ! $Authenticator->_refresh_token,'! ->_refresh_token' );
is( $Authenticator->_token_type,'Bearer','->_token_type' );
ok( $Authenticator->_expires_at > time + 3595,'->_expires_at' );
ok( ! $Authenticator->_token_is_expired,'! ->_token_is_expired' );

done_testing();
