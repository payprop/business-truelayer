#!/bin/bash

set -xeu

export TRUELAYER_CREDENTIALS=$1;
export TEST_JSON=$2;
export ENDPOINT=$3;
export MOJO_CLIENT_DEBUG=1;

perl -Ixt -Ilib \
    -MData::Printer \
    -MTest::Credentials \
    -MBusiness::TrueLayer \
    -MFile::Slurper=read_text \
    -MJSON \
    -E '
    my $TrueLayer = Business::TrueLayer->new( Test::Credentials->new->TO_JSON );

    my $response = $TrueLayer->api_post(
        $ENV{"ENDPOINT"},
        JSON->new->canonical->decode( read_text( $ENV{"TEST_JSON"} ) ),
    );

    p $response;
';
