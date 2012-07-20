#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  info.pm - Show information about a song file.
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
#  $Id: info.pm,v 1.15 2007/10/16 19:10:22 skx Exp $
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
package plugins::info;


#
#  Register the plugin.
#
::register_plugin("plugins::info");



#
#  Minimal constructor.
#
sub new { return bless {}; }





require gnump3d::readtags;


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
    my $REVISION      = '$Id: info.pm,v 1.15 2007/10/16 19:10:22 skx Exp $';
    my $VERSION       = "";
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

    if ( $path =~ /^\/info\/*/i )
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
    my ( $class, $uri ) = (@_);

package main;

    my $header   = &getHTTPHeader( 200, "text/html" );
    &sendData($data, $header );

    my $track = undef;

    #
    # Get the filename of the song to display information of.
    #
    if ( $uri =~ /\/info(.*)/ )
    {
	$track = $1;
    }

    #
    #  Make sure we got something.
    #
    if ( ( ! defined( $track ) ) ||
	 ( length( $track ) < 1 ) )
    {
	my $error = &getErrorPage( $ARGUMENTS{'theme'},
				   "No track specified." );
	&sendData( $data, $error );
	close( $data );
	exit 1;
    }

    # Preserve the song.
    my $play = $track;

    #
    # Get the local page.
    #
    $track = $ROOT . "/" . $track;


    # Remove duplicate slashes
    while ( $track =~ /(.*)\/\/(.*)/ )
    {
	$track = $1 . "/" . $2;
    }

    # Remove ..'s
    while( $track =~ /(.*)\/\.\.(.*)/ )
    {
	$track = $1 . $2;
    }

    if ( -d $track )
    {
        my $file = substr( $track, length( $ROOT ) );
        my $error = &getErrorPage( $ARGUMENTS{'theme'},
				 "Error '$file' is a directory." );
	&sendData( $data, $error );
	close( $data );
	exit 1;
    }

    if ( ! -e $track )
    {
	my $file = substr( $track, length( $ROOT ) );
	my $error = &getErrorPage( $ARGUMENTS{'theme'},
				   "The specified file ($file) does not exist." );
	&sendData( $data, $error );
	close( $data );
	exit 1;
    }


    # Link to the parent directory.
    my $dir = "/";
    if ( $play =~ /(.*)\/(.*)/ )
    {
	$dir = $1 . "/";
    }

    my %TAGS = &main::getTags($track);

    my $output = "";
    $output .= '<table width="100%">';

    #
    #  If we're asking for information on a playlist then
    # dump text contained in it.
    #
    #
    if ( $FILE_TYPES->isPlaylist( $track ) )
    {
        open( FILY, "<$track" );
        while (defined(my $line = <FILY>) )
        {
            chomp $line;
            if ($line =~ s/^#EXTINF:(-1|\d+),([^:]+)(:(.+)?)?$//)
            {
                my $time = $1;
                my $name = $2;
                my $site = $4 if defined ($4);

                my $streamtext = "more info";
                if ($time eq "-1")
                {
                    $time="$streamtext";
                }
		else
                {
                    my $s = $time % 60;
                    my $m = ($time - $s) / 60;
                    $time = sprintf("%d:%02d", $m, $s);
                }

                my $tune = <FILY>;
                chomp $tune;

                $output .= "<tr><td width='10%'>&nbsp;</td>";
                $output .= "<td>$name</td><td align='right'>";
                
		if (defined( $site ) && $time eq "$streamtext")
                {
                    $output .= "<a href='$site' target='_blank'>[$time]</a>";
                }
		elsif ($time eq "$streamtext")
                {
                    $output .= "&nbsp;";
                } 
		else
                {
                    $output .= "[$time]";
                }
                $output .= "</td></tr>\n";
            }
        }
        close( FILY );
    }
    else
    {
	# 
	# Trim leading root path
	#
	$TAGS{'FILENAME'} =~ s/^$ROOT//;
    
	foreach my $key ( sort keys( %TAGS ) )
	{
	    $output .= "<tr><td><b>$key</b></td><td>" . $TAGS{$key} ."</td></tr>\n";
	}
    }

    $output .= "</table>\n";

    # Link to the song.
    if ( getConfig( "always_stream", 1 ) )
    {
      $play .= ".m3u";
    }

    # Escape the filename and directory names correctly.
    $play = &urlEncode( $play );
    $dir  = &urlEncode( $dir );

    #
    # Now add some links to the bottom of the info.
    #
    $output .= "<p align='center'>[ <a href='$dir'>Visit Directory</a> | <a href='$play'>Play Track</a> ]</p>";

    my $text = "";


    my @template = &getThemeFile( $ARGUMENTS{'theme'}, "info.html" );
    foreach my $line (@template )
    {
	#
	# Make global substitutions.
	#
        $line =~ s/\$HEADER//g;
	$line =~ s/\$HOSTNAME/$host/g;
	$line =~ s/\$VERSION/$VERSION/g;
	$line =~ s/\$RELEASE/$RELEASE/g;
	$line =~ s/\$DIRECTORY/\/info\//g;
	$line =~ s/\$HEADING/File Information/g;
	$line =~ s/\$TITLE/File Information/g;
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
	    $text .= &getBanner( "/info/" );
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$TEXT(.*)/ )
	{
	    $text .= $1 . $output . $2;
	}
	else
	{
	    $text .= $line;
	}
    }

    &sendData($data, $text );
    close( $data );
    return 1;
}


1;
