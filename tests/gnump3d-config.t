#!/usr/bin/perl -Ilib -w
#
#  Test that our configuration file parser works as expected.
#
# Steve
# --
# http://www.steve.org.uk/
#
# $Id: gnump3d-config.t,v 1.3 2006/01/30 08:41:19 skx Exp $
#



use Test::More qw( no_plan );

#
# Modules we use.
#
BEGIN{ use_ok( 'gnump3d::config' ); }
require_ok( 'gnump3d::config' );
BEGIN{ use_ok( 'File::Temp' ); }
require_ok( 'File::Temp' );


#
#  Read in the sample data we will test against.
#
my $SAMPLE = "";
while( <DATA> )
{
    $SAMPLE .= $_;
}

#
#  Create a temporary directory to work within.
#
my $dir = File::Temp::tempdir( CLEANUP => 1 );

ok( -d $dir, "We created a temporary directory to test within." );

#
#  The temporary configuration file we'll test against
#
my $file = $dir . "/foo.cfg";

#
#  Write out our sample data.  Make sure this works.
#
ok( ! -e $file, "Our temporary configuration file doesn't exist." );
open( OUTPUT, ">", $file ) or die "Cannot open file '$file' - $!";
print OUTPUT $SAMPLE;
close( OUTPUT );
ok( -e $file, " Our temporary configuration file exists now." );


#
#  Parse our file.
#
readConfig( $file );


is( getConfig( "foo" ), "bar", "Simple reading of configuration file was OK" );
is( getConfig( "none", "fail" ), "fail", "Fall-back of non-found entry was OK" );
is( configFile(), $file, "Configuration file was correctly saved" );


__DATA__

#
#  This is a comment.
#
#
foo = bar


