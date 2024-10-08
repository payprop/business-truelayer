package Business::TrueLayer::Mandate;

=head1 NAME

Business::TrueLayer::Mandate - class representing a mandate
as used in the TrueLayer v3 API.

Business::TrueLayer::Mandate uses the Status role.

=head1 SYNOPSIS

    my $Mandate = Business::TrueLayer::Mandate->new(
        type => ...
    );

=cut

use strict;
use warnings;
use feature qw/ signatures postderef /;

use Moose;
extends 'Business::TrueLayer::Request';
with 'Business::TrueLayer::Role::Status';
use Moose::Util::TypeConstraints;
no warnings qw/ experimental::signatures experimental::postderef /;

with 'Business::TrueLayer::Types::Beneficiary';
with 'Business::TrueLayer::Types::Remitter';
with 'Business::TrueLayer::Types::User';

use namespace::autoclean;

=head1 ATTRIBUTES

=over

=item id (Str)

=item type (Str)

=item beneficiary

A L<Business::TrueLayer::Beneficiary> object. Hash refs will be coerced.

=item user

A L<Business::TrueLayer::User> object. Hash refs will be coerced.

=back

=cut

# the mandate JSON, as per the TrueLayer docs, contains a key
# "mandate" that has all the stuff in it, rather than the stuff
# being at the top level - this is annoying, so pull it out and
# handle it at the top level
sub BUILDARGS {
    my ( $self,$args ) = @_;

    my %mandate = $args->{mandate}
        ? ( $args->{mandate}->%* )
        : ( $args->%* )
    ;

    return { %mandate,%{ $args } };
}

enum MandateType => [ qw( sweeping commercial direct_debit ) ];

has [ qw/ type / ] => (
    is       => 'ro',
    isa      => 'MandateType',
    required => 1,
);

has [ qw/ status id / ] => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);

has [ qw/ currency / ] => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has remitter => (
    is       => 'ro',
    isa      => 'Business::TrueLayer::Remitter',
    coerce   => 1,
    required => 1,
);

=head1 SEE ALSO

L<Business::TrueLayer::User>

L<Business::TrueLayer::Role::Status>

=cut

1;
