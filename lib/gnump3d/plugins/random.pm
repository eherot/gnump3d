#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  random.pm - Choose random N music files from the archive.
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
#  $Id: random.pm,v 1.24 2006/08/12 22:04:10 skx Exp $
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
package plugins::random;


#
#  Register the plugin.
#
::register_plugin("plugins::random");


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
    my $REVISION      = '$Id: random.pm,v 1.24 2006/08/12 22:04:10 skx Exp $';
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

    #
    # Random playlist.
    #
    if ( ( $path =~ /^\/random\/playlist.m3u/i ) ||
	 ( $path =~ /^\/random\/play\/*/i )      ||
	 ( $path =~ /^\/random\/*/i ) )
    {
	return 1;
    }

    
    #
    # Random directory.
    #
    if ( $path =~ /^\/random\/directory\/*/i )
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

    #
    # See if we should just return a random directory...
    #
    if ( $uri =~ /^\/random\/playlist.m3u/ )
    {
	$class->_handleRandomDirectory( 1 );
	exit;
    } 
    if ( $uri =~ /^\/random\/directory/ )
    {
	$class->_handleRandomDirectory( 0 );
	exit;
    }


    #
    # See if we were called as a result of our form submission or not.
    #
    if ( $uri =~ /^\/random\/play/ )
    {
        #
        # We were - so use the submitted details to serve a
        # playlist to the client.
        #
	$class->_handlePlaylist();
    }
    else
    {
        #
        #  We weren't, so we must choose some random tracks and
        # present them to the user for inspection.
        #

        #
        # The HTML template we use for output.
        # And the text we build up to send.
        #
        my @template = &getThemeFile( $ARGUMENTS{'theme'}, "random.html" );
	my $output   = "";


        #
        # Send the HTTP header.
        #
	# Matt: nocache this
	my $header   = &getHTTPHeader( 200, "text/html", undef, {NoCache=>1} );
	&sendData($data, $header );


	#
	#  Default to 20 songs, or the number specified in our configuration
	# file.
	#
	my $count = &getConfig( "plugin_random_song_count", 20 );

	#
	#  However this may be overridden by the user.
	#
	if ( defined( $ARGUMENTS{ "count" } ) )
	{
	  $count = $ARGUMENTS{ "count" };
	}


	#
	#  Choose random songs
	#
	my %selections = $class->_getRandomFiles( $count );


	#
	#  Build up the output HTML
	#
	#  Display them - using 'plugin_random_song_format'
	#
	my $format = &getConfig( "plugin_random_song_format",
				  '$ARTIST - $SONGNAME' );
	my $suffix = &getConfig( "always_stream", 1 );
	if ( $suffix eq "1" )
	{
	    $suffix = ".m3u";
	}
	else
	{
	    $suffix = "";
	}

	$output = "<ul>\n";
	foreach my $number ( keys %selections )
	{

    	my $file = $selections{ $number };

	    #
	    # Display song tag information.
	    #
	    my $tag = &getSongDisplay( $file, $format );

	    # 
	    # Remove path (if there is one)
	    #
	    $tag =~ s/^$ROOT(.*\/)*//;

	    #
	    # Get the containing directory.
	    my $dir = $file;
	    if ( $dir =~ /$ROOT(.*)/ )
	    {
	        $dir = $1;
	    }

	    my $link = $dir;
	    $link    = &urlEncode( $link );
	    $link   .= $suffix;

	    if ($dir =~ /(.*)\/(.*)$/ )
	    {
	        $dir = $1;
			$dir = &urlEncode( $dir );
	    }

	    #
	    # Add in downsampling options if necessary.
	    #
	    if ( defined( $ARGUMENTS{"quality"} ) and
			 length(  $ARGUMENTS{"quality"} ) )
	    {
			$link .= "?quality=" . $ARGUMENTS{"quality"};
	    }

	    # Add the entry to the output.
	    $output .= "<li>[<a href=\"$dir/\" title=\"Visit the directory containing this track.\">+</a>] &middot; <a href=\"$link\">$tag</a></li>\n";

	}
	$output .= "</ul>\n";

	#
	#  Add a hidden form to contain the selections.
	#
	my $form = "<table><tr><td><form action=\"/random/play\" method=\"get\">\n";

	#
	#  Add in the line numbers of the random songs.
	#
	$count = 0;
	foreach my $number (keys %selections )
	{
	  $form .= "<input type=\"hidden\" name=\"track$count\" value=\"$number\" />\n";
	  $count ++;
	}
	$form .= "<input type=\"submit\" name=\"submit\" value=\"Play\" />\n";
	$form .= "</form></td>\n";


	#
	# Add in the form.
	#
	$output .= $form;

	#
	# Create a second form.
	#
	$form    = "<td><form action='/random' method='get'>\n";
	$form   .= "<select name=\"count\">\n";
	$form   .= "<option value=\"10\">10</option>\n";
	$form   .= "<option value=\"20\" selected>20</option>\n";
	$form   .= "<option value=\"40\">40</option>\n";
	$form   .= "<option value=\"50\">50</option>\n";
	$form   .= "</select>\n";
	$form   .= "<input type=\"submit\" name=\"submit\" value=\"Try Again\" />\n";
	$form   .= "[ <a href=\"/random/directory\">Random Directory</a> ]  </form> </td></tr></table>\n";
	$output .= $form;



	#
	# Now process the template and insert our output.
	#
	my $text = "";
	foreach my $line ( @template )
	{
	    #
	    # Make global substitutions.
	    #
	    $line =~ s/\$HEADER//g;
	    $line =~ s/\$HOSTNAME/$host/g;
	    $line =~ s/\$VERSION/$VERSION/g;
	    $line =~ s/\$RELEASE/$RELEASE/g;
	    $line =~ s/\$DIRECTORY/\/random\//g;
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
		$text .= &getBanner( "/random/" );
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

	&sendData( $data, $text );
        close( $data );
	exit 1;
    }

    #
    # Can't reach here.
    #
    &sendData($data, "Fatal Error - Can't Happen.  random.pm\n" );
    close($data);
    exit;
}


#
#  Handle the result of a form submission by retrieving the
# passed files - and serving a playlist containing them.
#
sub _handlePlaylist
{
    my ( $class ) = ( @_ );

package main;

    my @songs = ( );

    foreach my $key ( keys %ARGUMENTS )
    {
	if ( $key =~ /^track/ )
	{
	    push @songs, $ARGUMENTS{ $key };
	    delete( $ARGUMENTS{ $key } );
	}
    }

    #
    # If we have songs
    #
    if ( ($#songs+1) > 0 )
    {
	# Send playlist header.
	my $header   = &getHTTPHeader( 200, "audio/x-mpegurl", undef, {NoCache=>1} );
	&sendData( $data, $header );


	#
	#  Open the song tags database, and read in the relevent
	# lines.
	open( FILY, "<$tag_cache" );
	my @lines = <FILY>;
	close( FILY );

	foreach my $number ( @songs )
	{
	  # The entry for the selected track.
	  my $line = $lines[ $number ];

	  my $track = "";
	  if ( $line =~ /([^\t]+)\t(.*)/ )
	  {
	    $track = $1;
	  }

	  #
	  # Strip song root off - if present.
	  #
	  if ( $track =~ /$ROOT(.*)/ )
	    {
	      $track = $1;
	    }
	  if ( substr( $track, 0, 1 ) ne "/" )
	    {
	      $track = "/$track";
	    }

	  &sendData($data, "http://" . $host .  &urlEncode($track) . "\n" );
	}
	close( $data );
	exit;
    }

    # Send error
    my $header   = &getHTTPHeader( 200, "text/html", undef, {NoCache=>1} );
    &sendData( $data, $header );
    my $text = &getErrorPage( $ARGUMENTS{'theme'},
			      "Error - No tracks sent." );
    &sendData( $data, $text );
    close( $data );
    exit;
}


#
#  Choose a random line from the cache file, and work out the 
# directory the given track lives in.
#
#  Issue a redirect to force the user to view that.
#
#
sub _handleRandomDirectory
{
    my ( $class, $playlist ) = ( @_ );

package main;

    open( FILY, "<$tag_cache" );
    my @lines = <FILY>;
    close( FILY );

    #
    # List of directories excluded from the random selection, deliminated
    # by '|' characters.
    #
    my $ignore   = getConfig( "plugin_random_exclude", "" );
    my @EXCLUDED = split( /\|/, $ignore );


    #
    # Pick a random line from the database.
    #
    my $random = "";

    #
    #  maximum attempts to read detilas - avoid infinite loops.
    #
    my $count  = 5;

    #
    #  Find a directory.
    #
    while( ( ! length( $random ) ) &&
	   ( $count > 0 ) )
    {
	$random = $lines[ rand @lines ];
	if ( $random =~ /([^\t]+)\t(.*)/ )
	{
	  $random = $1;
	}

	#
	# We only care about the directory name.
	#
	if ( $random =~ /(\/?.+\/)(.+)$/g )
	{
	  $random = $1;
	}

	#
	#  Make sure the random directory hasn't been explicitly
	# disallowed.
	#
	foreach my $excluded ( @EXCLUDED ) 
	{
	    if ( $random =~ /\Q$excluded\E/i )
	    {
	        $random = "";
	    }
        }

	$count --;
    }
  

    #
    #  Should we return a random directories playlist?
    #
    if ( $playlist )
    {
      #
      #  Get it.
      #
      my $p = playlistForDirectory( $random, 0, 0 );

      my $header   = &getHTTPHeader( 200, "audio/x-mpegurl" );
      &sendData( $data, $header );
      &sendData( $data, $p );
      close( $data );
      exit;

      
    }
    else
    {
      #
      #  Strip off the root
      #
      if ( $random =~ /$ROOT[\\\/](.*)/i )
      {
	$random= $1;
      }

      &sendData($data, "HTTP/1.0 300 OK\nPragma: no-cache\nCache-control: no-cache\nLocation: /$random\n\n" );

      exit;
    }

}



#
#  Return a hash containing some random files, the hash will be of
# the form:
#
#  $result{ 'number' } = 'song'
#
#  Where number is the line number of the entry in the cache file.
#
sub _getRandomFiles
{
  # Count of random tracks to return
  my ( $class, $count ) = ( @_ );

package main;

  # Results we return.
  my %RESULTS;

  #
  #  Open the music "database" file.
  #
  open( FILY, "<$tag_cache" );
  my @lines = <FILY>;
  close( FILY );


  #
  # Loop till we have enough.
  # (Use @lines to make sure that the file was not empty
  #   -- Fixes infinite loop when the DB is empty.)
  #
  while( $count > 0  && @lines )
  {
    my $num  = int rand @lines;
    my $line = $lines[ $num ];

    if ( $line =~ /([^\t]+)\t(.*)/ )
      {
        # Save the filename.
        $RESULTS{ $num } = $1 ;

	$count -= 1;
      }
  }

  return( %RESULTS );
}


1;
