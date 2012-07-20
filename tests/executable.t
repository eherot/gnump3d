#!/usr/bin/perl -w
#
# Test that the files in bin/ are executable, except for the .bat files.
#
# Steve
# --
# http://www.steve.org.uk/
#
# $Id: executable.t,v 1.1 2005/12/02 17:35:07 skx Exp $
#

use strict;

use Test::More qw( no_plan );


#
# Process all files.
#
foreach my $file ( sort( glob( "bin/*" ) ) )
{
    # Skip autosaved files and MS-DOS batch files.
    next if ( $file =~ /(.*)~$/ );
    next if ( $file =~ /(.*)\.bat$/i );

    # Make sure file is executable.
    ok( -x $file, "$file Executable" );
}
