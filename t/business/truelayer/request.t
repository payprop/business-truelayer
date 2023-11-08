#!perl

use strict;
use warnings;

use FindBin qw/ $Bin /;
use Test::MockObject;
use Test::Most;
use Test::Exception;

use_ok( 'Business::TrueLayer::Request' );
isa_ok(
    my $Request = Business::TrueLayer::Request->new(
        _ua           => my $ua     = Test::MockObject->new,
        signer        => my $signer = Test::MockObject->new,
        authenticator => my $auth   = Test::MockObject->new,

        client_id => 'TL-CLIENT-ID',
        client_secret => 'super-secret-client-secret',
        host => '/dev/null',
    ),
    'Business::TrueLayer::Request'
);

subtest '->idempotency_key' => sub {
    my %unique_keys;
    for ( 1 .. 10 ) {

        ok( 
            ++$unique_keys{ $Request->idempotency_key } == 1,
            '->idempotency_key is unique'
        );
    }
};

$ua->mock( post => sub { shift } );
$ua->mock( result  => sub { shift } );
$ua->mock( body => sub { } );

$signer->mock( sign_request => sub { 'A..B' } );

$auth->mock( 'access_token' => sub { 'XYZ' } );

subtest 'is_success' => sub {
    $ua->mock( is_success => sub { 1 } );

    lives_ok(
        sub { $Request->api_post( '/foo',{} ) },
        '->api_post',
    );
};

subtest 'failures' => sub {
    $ua->mock( is_success => sub { 0 } );
    $ua->mock( is_error => sub { 1 } );
    $ua->mock( message => sub { "error message" } );

    throws_ok(
        sub { $Request->api_post( '/foo',{} ) },
        qr/API POST failed: error message/,
    );

    $ua->mock( is_success => sub { 0 } );
    $ua->mock( is_error => sub { 0 } );
    $ua->mock( code => sub { 301 } );

    throws_ok(
        sub { $Request->api_post( '/foo',{} ) },
        qr/API POST failed > 5 levels of redirect/,
    );

    $ua->mock( is_success => sub { 0 } );
    $ua->mock( is_error => sub { 0 } );
    $ua->mock( code => sub { 0 } );

    throws_ok(
        sub { $Request->api_post( '/foo',{} ) },
        qr/API POST failed, unknown reason/,
    );
};

done_testing();
