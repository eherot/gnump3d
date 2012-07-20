#!/usr/bin/perl -Ilib -w
#
#  Test that our MD5 library works as expected.
#
#  This will fail if there is no Digest::MD5 installed.  *shrug*
#
# Steve
# --
# http://www.steve.org.uk/
#
# $Id: gnump3d-md5.t,v 1.2 2005/12/02 17:40:39 skx Exp $
#



use Test::More qw( no_plan );

#
# Our copy of the MD5 implementation.
#
BEGIN{ use_ok( 'gnump3d::MD5' ); }
require_ok( 'gnump3d::MD5' );

#
# The reference copy.
#
BEGIN{ use_ok( 'Digest::MD5' ); }
require_ok( 'Digest::MD5' );


my $count = 0;


while( $count < 50 )
{
    my $text = getRandomString();

    
    # Get the hash using Digest::MD5
    my $dmd5 = Digest::MD5->new;
    $dmd5->add($text);
    my $dmd5out = $dmd5->b64digest;

    
    # Get the hash using gnump3d::MD5
    my $gmd5 = gnump3d::MD5->new;
    $gmd5->add($text);
    my $gmd5out = $gmd5->b64digest;
    

    is( $dmd5out, $gmd5out, "gnump3d-md5" );

    $count ++;
}




# Generate a `random` string for hashing purposes.
sub getRandomString
{
        my @chars = ( "A" .. "Z", "a" .. "z", 0 .. 9, qw(! @ $ % ^ & *) );
        return( join("", @chars[ map { rand @chars } ( 1 .. 100 ) ]) );
}
