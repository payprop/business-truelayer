package Business::TrueLayer::Signer;

=head1 NAME

Business::TrueLayer::Signer - Class to handle request signing

=head1 SYNOPSIS



=head1 DESCRIPTION

To use the TrueLayer Payments API v3, you need a public and private key
pair. You can generate these however you want, but we recommend OpenSSL
on Windows or LibreSSL on macOS or Linux. These methods are usually
available on these operating systems by default.

To generate your private key, run the following command in your terminal.
The keys you generate will save to your current directory.

    openssl ecparam -genkey -name secp521r1 -noout -out ec512-private-key.pem

Then, to generate your public key, run this command in your terminal.

    openssl ec -in ec512-private-key.pem -pubout -out ec512-public-key.pem

You then need to upload the public key to the TrueLayer console

=cut

use strict;
use warnings;
use feature qw/ signatures /;

use Moose;
no warnings qw/ experimental::signatures /;

1;

# vim: ts=4:sw=4:et
