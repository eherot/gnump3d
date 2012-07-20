#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  now.pm - Show songs currently playing
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
#  $Id: now.pm,v 1.11 2007/10/16 19:10:22 skx Exp $
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
package plugins::now;


#
#  Register the plugin.
#
::register_plugin("plugins::now");


#
#  Minimal constructor.
#
sub new { return bless {}; }




use gnump3d::files;


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
    my $REVISION      = '$Id: now.pm,v 1.11 2007/10/16 19:10:22 skx Exp $';
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

    if ( $path =~ /^\/now\/*/i )
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

    my $output = "";
    $output .= "<table>\n";

    my $count = 0;
    my @serving = ( );

    # Read existing.
    if ( defined( $NOW_PLAYING_PATH ) && ( -d $NOW_PLAYING_PATH ) )
    {
	$DEBUG && print "Reading directory '$NOW_PLAYING_PATH'\n";

	opendir( NOW_PLAYING, $NOW_PLAYING_PATH );
	@serving = grep(/\.txt$/, readdir NOW_PLAYING);
	closedir( NOW_PLAYING );
    }


    #
    # The display format we use.
    #
    my $format = &getConfig( "plugin_now_song_format",
			     '$ARTIST - $SONGNAME' );
    my $extension = "";
    if ( getConfig( "always_stream", 1 ) )
    {
	$extension = ".m3u";
    }

    foreach my $ip ( @serving )
    {
        my @files    = &readFile( $NOW_PLAYING_PATH . "/" . $ip );
	my $time     = &getModifiedTime( $NOW_PLAYING_PATH . "/" . $ip );
	my $file     = $files[0];
	my $display = "";   # Tag info to display.
	my $link    = "";   # Link to the file.
	my $dir     = "";   # Link to the containing directory.

	# We have one more track being played.
	$count += 1;

	# Get the tag info.
	if ( ( -e $file ) && ( -f $file ) )
	{
	    $display = &getSongDisplay( $file, $format );
	}
	else
	{
	    $display   = $file;
	    if ( $display =~ /(.*)\.(.*)/ )
	    {
		# Strip suffix
	        $display = $1;
	    }
	    if ( $display =~ /(.*)\/(.*)/ )
	    {
		# Strip directory name
	        $display = $2;
	    }
	}
	$link   = substr( $file, length( $ROOT ) );

	if ( -d $file )
	{
	  $dir = $link;
	}
	else
	{
	  if ( $link =~ /(.*)\/(.*)/ )
	    {
	      $dir = $1;
	    }
	  else
	    {
	      $dir = "/";
	    }
	}

	#
	# Make the directory name pretty, and url encode the links.
	#
	my $dirDisplay = $dir;
	if ( substr($dirDisplay,0,1 ) eq "/" )
	  {
	      $dirDisplay = substr( $dirDisplay, 1 );
	  }
	$dirDisplay =~ s/\// \&middot; /g;
	$dir .= "/";
	$dir = &urlEncode( $dir );
	$link = &urlEncode( $link );

	#
	# Lookup the hostname if we can.
	#
	if ( $ip =~ /(.*)\.(\d+)\.txt$/ )
	{
	    $ip = $1;
	}
	my $host = $class->_ipToName( $ip );

	if ( $count eq "1" )
	  {
	$output .= "<tr><td><b>Client</b></td><td><b>Time</b></td><td><b>Track</b></td><td><b>Directory</b></td></td>\n";
	  }
	$output .= "<tr><td>$host</td><td>$time</td><td><a href='$link$extension'>$display</a></td><td><a href='$dir'>$dirDisplay</a></td></td>\n";
    }

    if ( $count eq 0 )
    {
        $output .= "<tr><td>There are no songs currently being served.</td></tr>\n";
    }
    $output .= "</table>\n";



    my $text = $class->_createNowOutput( $output );
    &sendData($data, $text );
    close( $data );
    return 1;
}


#
# Create the output HTML to send to the client.
# 
sub _createNowOutput
{
  my ( $class, $output ) = ( @_ );

package main;

  my @template = &getThemeFile( $ARGUMENTS{'theme'}, "now.html" );
  my $text = "";

  foreach my $line (@template )
  {
      #
      # Make global substitutions.
      #
      $line =~ s/\$HEADER/<META HTTP-EQUIV=\"refresh\" content=\"30;\">/g;
      $line =~ s/\$HOSTNAME/$host/g;
      $line =~ s/\$VERSION/$VERSION/g;
      $line =~ s/\$RELEASE/$RELEASE/g;
      $line =~ s/\$DIRECTORY/\/now\//g;
      $line =~ s/\$HEADING/Now Playing/g;
      $line =~ s/\$TITLE/Now Playing/g;
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
	  $text .= &getBanner( "/now/" );
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

   return( $text );
}



#
#  Convert a given IP address to a hostname.
#
sub _ipToName($)
{
    my( $class, $ip ) = ( @_ );

    my @address = gethostbyaddr( pack( 'C4', split(/\./, $ip)), 2 );
    return(  @address > 0 ? $address[0] : $ip );
}


1;
