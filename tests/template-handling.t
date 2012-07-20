#!/usr/bin/perl -Ilib -w
#
#  Test that our file inclusion, and command execution works as expected
# as used in the template handlers.
#
# Steve
# --
# http://www.steve.org.uk/
#
# $Id: template-handling.t,v 1.5 2006/08/23 21:00:57 skx Exp $
#



use Test::More qw( no_plan );

#
# Modules we use.
#
BEGIN{ use_ok( 'gnump3d::files' ); }
require_ok( 'gnump3d::files' );
BEGIN{ use_ok( 'File::Temp' ); }
require_ok( 'File::Temp' );


#
#  Basic tests.
#
testFileReading( "test", "test", "Simple text unchanged" );
testFileReading( "<html>blah</html>", "<html>blah</html>", "Simple html unchanged" );


#
#  Executable tests
#
my $hostname = `hostname`;
chomp($hostname);
testFileReading( '<!-- exec="hostname" -->', 
		 $hostname . "\n",
		 "Simple command executation works" );

testFileReading( '<!-- exec="hostname" --><!-- exec="hostname" -->', 
		 $hostname . "\n" . $hostname, 
		 "Double command executation works" );


#
#  File inclusion tests
#
#testFileReading( '<!-- include="/etc/passwd" -->',
#		 `cat /etc/passwd`,
#		 "Simple file inclusion works" );


=head2 testFileReading

  Test that reading a file, with expansion, returns what we expect.

=cut
sub testFileReading
{
    my ( $text, $expected, $detail ) = ( @_ );

    my $dir = File::Temp::tempdir( CLEANUP => 1 );
    ok( -d $dir, "We created a temporary directory to test within." );

    #
    #  Write the text to a temporary file, so that we can process it
    #
    open( OUTPUT, ">", $dir . "/tmp.txt" )
        or die "Failed to open $dir/tmp.txt - $!";
    print OUTPUT $text;
    close( OUTPUT );

    #
    #  Process the file.
    #
    my @result = readFileWithExpansion( $dir . "/tmp.txt" );

    #
    #  Join the result.
    #
    my $RESULT =  join( "\n", @result );

    #
    #  Is it what we expected?
    #
    is( $RESULT, $expected, $detail );
}
