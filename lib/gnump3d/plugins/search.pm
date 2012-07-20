#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  search.pm - Allow uses to search the music archive for songs.
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
#  $Id: search.pm,v 1.16 2006/04/25 17:31:44 skx Exp $
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
package plugins::search;


#
#  Register the plugin.
#
::register_plugin("plugins::search");


#
#  Minimal constructor.
#
sub new 
{ 
    my ( $self ) = ( @_ );

    return bless {}; 
}




use gnump3d::url;


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
    my $REVISION      = '$Id: search.pm,v 1.16 2006/04/25 17:31:44 skx Exp $';
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

    if ( $path =~ /^\/search/i )
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
    # Make sure that the song tag cache exists before anything else.
    #
    my $tagCache = &getConfig( "tag_cache", "" );
    if ( ( ! defined( $tagCache ) ) ||
         ( ! -e $tagCache ) )
    {
	#
	# Serve error.
	#
	#
	delete( $ARGUMENTS{ "q" } );
	delete( $ARGUMENTS{ "play" } );
	my $header   = &getHTTPHeader( 200, "text/html" );
	&sendData($data, $header );

	my $text=<<E_O_E;
<p>&nbsp;GNUMP3d now uses a simple tag 'database' for storing all the song tag details from your audio collection.</p>
<P>&nbsp;You have either not defined such a cache file within your configuration file, (via the 'tag_cache = /path/to/file' directive), or it doesnt exist.</p>
<p>&nbsp;If you wish to build the index please run the installed script 'gnump3d-index' and retry your search request.</p>
<p>&nbsp;<i>Please</i> do not report this as a bug.</p>
E_O_E

	my $err = &getErrorPage( $ARGUMENTS{"theme"},
				 $text );
	&sendData( $data, $err );

	close( $data );
	exit;
    }

    #
    #  Is there a form submission?  If so do the search,
    # if not show the search template form to the user.
    #
    if ( ( defined $ARGUMENTS{ "q" } ) && ( length $ARGUMENTS{ "q" } ) )
    {
	my $playlist = "";
	my $results  = "";

	print "Running search for ". $ARGUMENTS{'q'} ."\n";
	#
	# Open up the song tag database so that we can perform the search
	#
	open( CACHE, "<$tagCache" )
	  or die "Error opening the cache file '$tagCache' for searching - $!";
	my @LINES = <CACHE>;
	close( CACHE );

        #
        # description of our search terms
        #
        my $searchsummary = '';

        foreach my $st (qw(q artist title album song year genre))
        {
            if ( defined( $ARGUMENTS{$st} ) && length( $ARGUMENTS{$st} ) )
            {
                # Remove XSS attacks
                $ARGUMENTS{$st} =~ s/</&lt;/g;
                $ARGUMENTS{$st} =~ s/>/&gt;/g;
                if ( $st eq 'q' )
                {
                    $searchsummary .= $ARGUMENTS{$st} . ', ';
                }
                else 
                {
                    $searchsummary .= $st . ' ' . $ARGUMENTS{$st} . ', ';
                }
            }
	}
        $searchsummary =~ s/ $//g;
        $searchsummary =~ s/,$//;

        if ( length( $searchsummary ) < 1 )
        {
            #
            # we don't seem to be searching anything
            #
            delete( $ARGUMENTS{ "q" } );
            delete( $ARGUMENTS{ "play" } );
            my $header   = &getHTTPHeader( 200, "text/html" );
            &sendData($data, $header );
            my $err = &getErrorPage( $ARGUMENTS{"theme"},
                                     "<p>&nbsp;You must search for <em>something</em>.</p>" .
                                     "<p>&nbsp;<a href='/search'>Search again</a>.</p>" );
            &sendData( $data, $err );
            close( $data );
            exit;
        }

        #
        # search term across all fields
        #
	my $terms = $ARGUMENTS{ "q" };

	#
	#  The mode will be either 'any' or 'all'
	#
	#  For matching on any term, or all terms respectively.
	#
	my $mode  = $ARGUMENTS{ "type" };
	if ( not defined( $mode ) ||
	     not length( $mode ) )
	{
	    $mode = "any";
	}


	#
	# Now do the searching for real.
	#
      SEARCHALINE:
	foreach my $line ( @LINES )
	{
	    chomp( $line );

	    my $match = 0;

            #
            # searches limited by one of the specific fields;
            # these operate as AND searches in all cases
            #
            foreach my $f ( qw(artist title album song year) ) {
                if ( defined($ARGUMENTS{$f} ) && length($ARGUMENTS{$f}) )
                {
                    my $F = uc($f);
                    # either match now or jump out
                    if ( $line !~ /$F=[^\t]*(?i)\Q$ARGUMENTS{$f}\E/ )
                    {
                        # warn("didn't match term $f == '$ARGUMENTS{$f}'\n");
                        next SEARCHALINE;
                    }
                }
            }

            # genre searches must match exactly
            if ( defined($ARGUMENTS{'genre'} ) && length($ARGUMENTS{'genre'} ) )
            {
                if ( $line !~ /GENRE=\Q$ARGUMENTS{'genre'}\E/ )
                {
                    next SEARCHALINE;
                }
            }

	    #
	    # Search for entered term(s).
	    #
	    if ( $mode eq "all" )
	    {
		# Searching for any term.
		# Assume the match succeeded unless a term isn't found.
		$match = 1;
		foreach my $term ( split( ' ', $terms ) )
		{
		    # If the line doesn't contain a match for this term
		    # we've failed
		    if ( ! ( $line =~ /$term/i ) )
		    {
			$match = 0;
		    }
		}
	    }
	    else
	    {
		# Searching for any term.
		foreach my $term ( split( ' ', $terms ) )
		{
		    if ( $line =~ /$term/i )
		    {
			$match ++;
		    }
		}
	    }

	    if ( $match )
	    {
		# Pull out the filename of the match - shouldn't ever fail.
		if ( $line =~ /^([^\t]+)\t(.*)/ )
		{
		    $results .= $1 . "\n";
		}
	    }
	}

	#
	#   Remove the search terms from the cookies we send back
	# in our header.
	#
	#  If we don't do this subsequent requests to the /search/
	# URL will just show the results again.
	#
	delete( $ARGUMENTS{ "q" } );


	#
	# Display the files we've found to the user.
	#
	if ( ( ! defined( $ARGUMENTS{ "play" } ) or
	       ( $ARGUMENTS{ "play" } ne 1 ) ) )
	{
	    delete( $ARGUMENTS{ "q" } );
	    delete( $ARGUMENTS{ "play" } );
	    my $header   = &getHTTPHeader( 200, "text/html" );
	    &sendData($data, $header );

	    #
	    # Process the template file.
	    #
	    if ( length( $results ) )
	    {
		my $total = "";
		my @lines = &getThemeFile( $ARGUMENTS{ "theme"},
					   "results.html" );
		foreach my $line ( @lines )
		{
		    #
		    # Make global substitutions.
		    #
		    $line =~ s/\$HOSTNAME/$host/g;
		    $line =~ s/\$HEADER//g;
		    $line =~ s/\$VERSION/$VERSION/g;
		    $line =~ s/\$RELEASE/$RELEASE/g;
		    $line =~ s/\$DIRECTORY/\//g;
		    $line =~ s/\$TITLE/Search Results/g;
		    $line =~ s/\$TERMS/$searchsummary/g;
		    $line =~ s/\$META/$meta_tags/g;

		    if ( $line =~ /(.*)\$BANNER(.*)/ )
		    {
			# Insert banner;
			my $pre  = $1;
			my $post = $2;
			$total .= $pre;
			$total .= &getBanner( "/" );
			$total .= $post;
		    }
		    elsif ( $line =~ /\$RESULTS/ )
		    {
			#
			# If the server is setup with always stream
			# then add on .m3u to each result.
			#
			my $extension = "";
			if ( getConfig( "always_stream", 1 ) )
			{
			    $extension = ".m3u";
			}

			#
			# Get ready to add on any bitrate settings to the file
			# within the playlist.
			#
			my $bitrate = "";
			if ( defined( $ARGUMENTS{"quality"} ) and
			     length(  $ARGUMENTS{"quality"} ) )
			{
			    $bitrate = "?quality=" . $ARGUMENTS{"quality"};
			}

			# Display format for the results.
			my $format = &getConfig( "plugin_search_song_format",
						 '$ARTIST - $SONGNAME' );

			#
			# Display the results.
			#
			foreach my $entry (split(/\n/,$results) )
			{
			    my $display = &getSongDisplay( $entry, $format );

			    # Strip the root from the filename
			    if ( $entry =~ /$ROOT(.*)/ )
			    {
				$entry = $1;
			    }

			    #
			    # Get the directory the entry was found in.
			    #
			    my $directory = $entry;
			    my $encodedDir= $directory;
			    if ( $directory =~ /(.*)\/([^\/]+)$/ )
			    {
				$directory = $1;
			    }
			    $encodedDir = &urlEncode( $directory . "/" );

			    #
			    # Prepare the name for display - remove leading
			    # '/' and seperate out the path components.
			    #
			    if ( $directory =~ /^\/(.*)/ )
			    {
				$directory = $1;
			    }
			    $directory =~ s/\// &middot; /g;


			    #
			    # Highlight the search terms - both the song
			    # terms, and within the directory section.
			    #
			    foreach my $t ( split( / /, $terms ) )
			    {
				$display   =~ s/$t/<b>$t<\/b>/ig;
				$directory =~ s/$t/<b>$t<\/b>/ig;
			    }


			    # Now build up the display line.	
			    $entry = "<tr><td align='left'><a href=\"http://$host$entry$extension$bitrate\">$display</a></td><td align='left'><a href=\"$encodedDir\">$directory</a></td></tr>\n";

			    # Add it to the output..
			    $total .= $entry;
			}
		    }
		    else
		    {
			$total .= $line ;
		    }
		}

		my @parms = ();
		foreach my $key ( sort keys %ARGUMENTS )
		{
		    push @parms, $key . "=" . $ARGUMENTS{ $key };
		}
		my $playAll = "?" . join( '&', @parms );
		$playAll   .= "&play=1";
		$playAll   .= "&q=$terms";
		$playAll    = "/search" . $playAll ;
                $playAll = gnump3d::url::encodeEntities( $playAll );

		$total =~ s/\$PLAY_RESULTS/$playAll/g;

		&sendData( $data, $total );
	    }
	    else
	    {
		my $err = &getErrorPage( $ARGUMENTS{"theme"},
					 "<p>&nbsp;No results found.</p>" .
					 "<p>&nbsp;<a href='/search'>Search again</a>.</p>"
					  );
		&sendData( $data, $err );
	    }
	}
	else
	{

	    #
	    # Make sure that subsequent requests don't cause the
            # results to be played immediately.
	    #
	    delete( $ARGUMENTS{ "play" } );

	    #
	    # Get ready to add on any bitrate settings to the file
	    # within the playlist.
	    #
	    my $bitrate = "";
	    if ( defined( $ARGUMENTS{"quality"} ) and
		 length(  $ARGUMENTS{"quality"} ) )
	    {
		$bitrate = "?quality=" . $ARGUMENTS{"quality"};
	    }


	    #
	    # Play the results of the search.
	    #
	    if ( length( $results ) )
	    {
		delete( $ARGUMENTS{ "q" } );
		delete( $ARGUMENTS{ "play" } );
		my $header   = &getHTTPHeader( 200, "audio/x-mpegurl" );
		&sendData($data, $header );

		foreach my $entry (split(/\n/,$results) )
		{
		    if ( $entry =~ /$ROOT(.*)/ )
		    {
			$entry = $1;
		    }
		    $entry = "http://$host$entry$bitrate\n";
		    &sendData($data, $entry );
		}
	    }
	    else
	    {
		delete( $ARGUMENTS{ "q" } );
		delete( $ARGUMENTS{ "play" } );
		
		my $header   = &getHTTPHeader( 200, "text/html" );
		&sendData($data, $header );

		my $err = &getErrorPage( $ARGUMENTS{"theme"},
					 "No results found" );
		&sendData( $data, $err );

	    }
	}
	close($data);
	exit;
    }

    print "\nJust showing search form\n";
    delete( $ARGUMENTS{ "q" } );
    delete( $ARGUMENTS{ "play" } );

    my $header   = &getHTTPHeader( 200, "text/html" );
    &sendData( $data, $header );
    my $text = $class->_getSearchForm($ARGUMENTS{"theme"});
    &sendData( $data, $text );
    close( $data );
    exit;
}



#
#  Read and return the search page to the caller.
#
sub _getSearchForm
{
    my ($class,$theme) = (@_);

package main;

    my $text  ="";

    my @template = &getThemeFile( $theme, "search.html" );
    foreach my $line (@template )
    {
	#
	# Make global substitutions.
	#
	$line =~ s/\$HOSTNAME/$host/g;
	$line =~ s/\$VERSION/$VERSION/g;
	$line =~ s/\$RELEASE/$RELEASE/g;
	$line =~ s/\$DIRECTORY/\/search\//g;
	$line =~ s/\$HEADING/Custom Playlist Generation/g;
	$line =~ s/\$TITLE/Custom Playlist Generation/g;
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
	    $text .= &getBanner( "/search/" );
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$SELECT_COMBO(.*)/ )
	{
	    # Insert banner;
	    my $pre  = $1;
	    my $post = $2;

	    $text .= $pre;

	    #
	    #  Show's only the top level directories.
	    #
	    my @dirs = &dirsInDir( $ROOT );

	    $text .= "<select name=\"dir\">\n";
	    $text .= "<option value=\"\" selected>All Directories</option>\n";

	    my $count = 0;
	    foreach my $name ( @dirs )
	    {
		$text .= "<option value=\"/$name\">$name</option>\n";
	    }
	    $text .= "</select>\n";
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$GENRE_COMBO(.*)/ )
	{
	    # Insert banner;
	    my $pre  = $1;
	    my $post = $2;

	    $text .= $pre;

	    #
	    # The genres from the MP3::Info module..
	    #
	    my @dirs = sort( @gnump3d::mp3info::mp3_genres );

	    $text .= "<select name=\"genre\">\n";
	    $text .= "<option value=\"\" selected>All Genres</option>\n";

	    my $count = 0;
	    foreach my $name ( @dirs )
	    {
                $name = gnump3d::url::encodeEntities($name);
		$text .= "<option value=\"$name\">$name</option>\n";
	    }
	    $text .= "</select>\n";
	    $text .= $post;
	}
	else
	{
	    $text .= $line;
	}
    }

    return( $text );
}


1;
