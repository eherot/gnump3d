#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  playlist.pm - Allow users to create their own custom playlists.
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
#  $Id: playlist.pm,v 1.16 2007/10/16 19:17:04 skx Exp $
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


###
##
#
#  How this plugin works
#  ---------------------
#
#  As a change from previous versions of this code we do not touch the
# filesystem at all for displaying the directory choices or the handling
# the submissions.
#
#  INSTEAD all operations work with the tag cache file.  We will
# read this in to list the directories which are present on the disk.
#
#  When it comes to building up the form then we will simply contain
# a list of hidden values which refer to the sorted directory  number
# as it's been processed from the tag cache file.
#
##
###




#
#  The package this module is implementing.
#
package plugins::playlist;


#
#  Register the plugin.
#
::register_plugin("plugins::playlist");


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
    my $REVISION      = '$Id: playlist.pm,v 1.16 2007/10/16 19:17:04 skx Exp $';
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

    if ( $path =~ /^\/playlist\/*/i )
    {
	return 1;
    }

    return 0;
}



#
#  Handle requests to this plugin - either display a form or process
# the submission.
#
sub handlePath
{
    my ( $class ) = ( @_ );

package main;


    #
    # Should we play the results of the form?
    #
    # Added aditional check that the play argument eq "true"
    # This was to fix an issue in FireFox that would result in
    # a blank playlist being sent when the custom playlist feature was
    # first clicked on.
    #
    # Harry Nelson
    # 
    if ( ( defined $ARGUMENTS{ "play" } ) and
	 ( length $ARGUMENTS{ "play" } ) and
	 ( "true" eq $ARGUMENTS{ "play" } ) )
    {
        #
        # Get the users playlist.
        #
        my $playlist = $class->_getUsersPlaylist();

	#
	#  Remove the play argument from the cookies we send back
	# in our header.
	#
	#  If we don't do this subsequent requests to the /play/
	# URL will not view the form.
	#
	#  Also delete any of the submitted values.
	#
	delete( $ARGUMENTS{ "play" } );

	foreach my $key ( keys %ARGUMENTS )
	{
	    if ( ( $key =~ /^line/i ) ||
		 ( $key =~ /^dir/i ) ||
		 ( $key =~ /^song/i ) )
	    {
	        delete( $ARGUMENTS{ $key } );
	    }
	}

	#
	#  Send the header with our removed values.
	#
	my $header   = &getHTTPHeader( 200, "audio/x-mpegurl" );
	&sendData($data, $header );

	#
	# Send the playlist of goodness.
	#
	&sendData($data, $playlist );
	close($data);
	exit;
    }
    else
    {
    
       #
       #  The user is just browsing, so we need to give them
       # the playlist browsing form.
       #
       my $header   = &getHTTPHeader( 200, "text/html" );
       &sendData( $data, $header );

       my $text = $class->_showCustomPlaylistForm( $ARGUMENTS{"theme"} );
       &sendData( $data, $text );
       close( $data );
       exit;
    }
}


#
#  Return a sorted hierarchy of all directory names beneath the root
#
sub _getDirectories
{
    my ( $class ) = ( @_ );


package main;


    # All the directories we find.
    my %DIRS = ();

    # The previous one.
    my $prev = "";
 
    open( CACHE, $tag_cache );
    foreach my $line ( <CACHE> )
    {
        # Get just the filename
        my @NAMES    = split( /\t/, $line);
	my $fileName = shift(@NAMES);
	# Get the directory name.
	if ( $fileName =~ /$ROOT\/(.*)\/(.*)$/ )
        {
	    my $dir = $1;
	    if ( $dir ne $prev )
	    {
                $DIRS{$dir} = 1;
                $prev = $dir;
		while ( $dir =~ /(.*)\/(.*)/ )
		{
		    $DIRS{ $1 } = 1;
                    $dir = $1
		}
	    } 
	}
    }
  
    close( CACHE );

    sub directories 
    {
	my $aa = $a;
	my $bb = $b;
	$aa =~ s/ /z/g; #Use 'z' or any other char gt '/'
	$bb =~ s/ /z/g;                                  
	lc($aa) cmp lc($bb);
    }
    
    return( sort directories ( keys %DIRS ) );
}



#
#  Show the list of all the top level directories within the music
# archive and allow people to choose between them.
#
sub _showCustomPlaylistForm
{
    my ($class, $theme, $files ) = (@_);


package main;


    my $text  ="";

    my @template = &getThemeFile( $theme, "playlist.html" );
    foreach my $line (@template )
    {
	#
	# Make global substitutions.
	#
        $line =~ s/\$HEADER//g;
	$line =~ s/\$HOSTNAME/$host/g;
	$line =~ s/\$VERSION/$VERSION/g;
	$line =~ s/\$RELEASE/$RELEASE/g;
	$line =~ s/\$DIRECTORY/\/playlist\//g;
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
	    $text .= &getBanner( "/playlist/" );
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$TEXT(.*)/ )
	{
	    my $pre  = $1;
	    my $post = $2;

	    $text .= "<form action=\"/playlist/\">\n";
	    $text .= "<input type=\"hidden\" name=\"play\" value=\"true\">\n";

	    $text .= $pre;
	    $text .= "<ul>\n";

	    #
	    # Just display the directories.
	    #
	    my $prev  = 1;
	    my $count = 0;
	    my $slashCount = 0;
	    my @DIRS = $class->_getDirectories();
	    foreach my $dir ( @DIRS )
	    {
                my @tmp = split( /\//, $dir );
	        $slashCount = scalar( @tmp );

		if ( $slashCount gt $prev )
		{
		    substr($text,rindex($text,"</li>"),5) = "<ul>\n";

		}
		if ( $slashCount lt $prev )
		{
            
            #
            # Added for loop to address a directory display issue.
            # The code use to make the asumption that when it had less 
            # slashes then before it only left one directory.
            # 
            # Harry Nelson
            # 
		     for ( my $dir_down = $prev - $slashCount;$dir_down gt 0; $dir_down-- )

			{
			    $text .= "</ul>\n";
			}
		}
		$prev =$slashCount;
		my $name = $dir ;
		
		if ( $name =~ /(.*)\/(.*)/ )
		{
		  $name = $2;
		}

		#
		# Make sure the directory name is safe for use in the
		# link and the hidden value
		#
		$dir = &urlEncode( $dir );

		$text .= "<li><input type=\"checkbox\" name=\"dir$count\" value=\"$dir\"> <a href=\"/$dir/\">$name</a> </li>\n";
		$count ++;
	    }
            for ( my $dir_down = $slashCount;$dir_down gt 0; $dir_down-- )
                {
                     $text .= "</ul>\n";
                }
	    $text .= "<input type=\"reset\" value=\"Clear All\"> <input type=\"submit\" value=\"Play\">\n";
	    $text .= "</form>\n";
	    $text .= $post;
	}
	else
	{
	    $text .= $line;
	}
    }

    return( $text );
}



#
#  Return the playlist the user has selected.
#
sub _getUsersPlaylist
{
    my ($class) = ( @_ );

package main;

    
    #
    # See which directories and lines need playing.
    #
    my @DIRS     = ();
    my $playlist = "";


    #
    #  Build up the list of requested line numbers and directory numbers.
    #
    foreach my $key ( keys %ARGUMENTS )
    {
	if ( $key =~ /^dir([0-9]+)/ )
	{
	    push @DIRS, &urlDecode( $1 );
	} 
    }
    
    if ( $DEBUG )
    {
	print "Playlist Argument Debugging\n";
	print "---------------------------\n";
	print "Playing directories: " . join("\n", @DIRS ) . "\n\n";
    }
    
    #
    #  If there are directories then get them
    #
    if ( $#DIRS + 1 )
    {
	my @dirs = $class->_getDirectories();
	
	foreach my $desired ( @DIRS )
	{
	    $playlist .= playlistForDirectory( $ROOT . "/" . $dirs[ $desired ], 1,  0 );
	    $DEBUG && print "Dir: " . $dirs[ $desired ] . "\n";
	}
    }


   return( $playlist );
}



1;
