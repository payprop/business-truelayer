#!perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Business::TrueLayer',
    VERSION_FROM     => 'lib/Business/TrueLayer.pm',
    AUTHOR           => 'Lee Johnson <leejo@cpan.org>',
    LICENSE          => 'perl',
    MIN_PERL_VERSION => '5.20.0',
    PREREQ_PM => {
        'Moose'                 => "2.2012",
        'Mojo::UserAgent'       => "8.52",
        'Try::Tiny::SmartCatch' => "0.5",
        'IO::Socket::SSL'       => "2.009",
        'Crypt::JWT'            => '0.035',
        'Crypt::PK::ECC'        => '0.080',
        'Data::GUID'            => '0.051',
        'Carp'                  => 0,
        'JSON'                  => 0,
    },
    BUILD_REQUIRES => {
        'Test::Most'       => '0.38',
        'Test::MockObject' => '1.20200122',
        'Test::Exception'  => '0.43',
    },
    META_MERGE => {
        resources => {
            license    => 'http://dev.perl.org/licenses/',
            homepage   => 'https://metacpan.org/module/Business::TrueLayer',
            bugtracker => 'https://github.com/Humanstate/business-truelayer/issues',
            repository => 'https://github.com/Humanstate/business-truelayer'
        },
    },
    test => {
        RECURSIVE_TEST_FILES => 1,
    },
);

# vim: ts=4:sw=4:et
