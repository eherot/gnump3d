#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  recent.pm  - Display the most recent tracks which have been served.
#
#  GNU MP3D - A portable(ish) MP3 server.
#
# Homepage:
#   http://www.gnump3d.org/
#
# Author:
#  Steve Kemp <steve@steve.org.uk>
#
# Version:
#  $Id: recent.pm,v 1.9 2005/12/03 18:17:44 skx Exp $
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#
#  Steve Kemp
#  ---
#  http://www.steve.org.uk/
#
#




#
#  The package this module is implementing.
#
package plugins::recent;


#
#  Register the plugin.
#
::register_plugin("plugins::recent");


#
#  Minimal constructor.
#
sub new { return bless {}; }



#
#  Return the author of this plugin.
#
sub getAuthor
{
    return( 'Steve Kemp <steve@steve.org.uk>' );
}


#
#  Return the version of this plugin.
#
sub getVersion
{
    my $REVISION      = '$Id: recent.pm,v 1.9 2005/12/03 18:17:44 skx Exp $';
    $VERSION = join (' ', (split (' ', $REVISION))[1..2]);
    $VERSION =~ s/,v\b//;
    $VERSION =~ s/(\S+)$/($1)/;

    return( $VERSION );
}




#
# Will this plugin handle the given URI path?
#
sub wantsPath
{
    my ( $class, $path ) = ( @_ );

    if ( $path =~ /^\/recent\/*/i )
    {
	return 1;
    }

    return 0;
}


#
#  Handle requests to this plugin.
#
sub handlePath
{
    my ( $class, $uri ) = ( @_ );

package main;

    my $header   = &getHTTPHeader( 200, "text/html" );
    &sendData( $data, $header );

    my $text = $class->_handleLast( $ARGUMENTS{"theme"});
    &sendData( $data, $text );

    close( $data );
    exit;
}



#
#  Display a list of the most recent songs played.
#
sub _handleLast
{
    my ($class,$theme) = (@_);

package main;

    my $text  ="";

    my $config = &configFile();

    my @template = &getThemeFile( $theme, "recent.html" );
    foreach my $line (@template )
    {
	#
	# Make global substitutions.
	#
        $line =~ s/\$HEADER/<META HTTP-EQUIV=\"refresh\" content=\"30;\">/g;
	$line =~ s/\$HOSTNAME/$host/g;
	$line =~ s/\$VERSION/$VERSION/g;
	$line =~ s/\$RELEASE/$RELEASE/g;
	$line =~ s/\$DIRECTORY/\/last\//g;
	$line =~ s/\$TITLE/Most Recent Tracks/g;
	$line =~ s/\$META/$meta_tags/g;

	#
	# Now handle the special sections.
	#
	if ( $line =~ /(.*)\$BANNER(.*)/ )
	{
	    # Insert banner;
	    my $pre  = $1;
	    my $post = $2;

	    $text .= $pre;
	    $text .= &getBanner( "/recent/" );
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$TEXT(.*)/ )
	{
	    my $pre  = $1;
	    my $post = $2;
	    $SIG{CHLD} = "DEFAULT";
	    $text .= $pre;

	    #
	    # Should we tack on a .m3u?
	    #
	    my $suffix = "";
	    if ( getConfig( "always_stream", 1 ) )
	    {
		$suffix = ".m3u";
	    }

	    # Use our own song format
	    my $format = &getConfig( "plugin_recent_song_format",
				     '$ARTIST - $SONGNAME' );

	    my $popularsongs = `$STATSPROG --config=$config $STATSARGS  --last`;

	    my @songs = split( /\n/, $popularsongs );
	    foreach my $line ( @songs )
	    {
		if ( $line =~ /(.*)\t\t\/(.*)/ )
		{
		    my $host     = $1;
		    my $filename = "/" . $2;

		    $filename = $ROOT . $filename;

		    my $disp  = &getSongDisplay( $filename, $format );

		    $text .= "<tr><td>$host</td><td><a href=\"/$2$suffix\">$disp</a></td></tr>\n";
		}
		else
		{
		    $text .= $line;
		}
	    }

	    $text .= $post;
	    $SIG{CHLD} = "IGNORE";
	}
	else
	{
	    $text .= $line;
	}
    }

    return( $text );
}



1;
