#!/usr/bin/perl -w  # -*- cperl -*- # 
#
#  tagcache.pm - A simple object to interface with our tag cache
#
#  GNU MP3D - A portable(ish) MP3 server.
#
# Homepage:
#   http://www.gnump3d.org/
#
# Author:
#  Steve Kemp <steve@steve.org.uk>
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

package gnump3d::tagcache;  # must live in tagcache.pm

use 5.004;
use strict;

use IO::File;

use gnump3d::url;
use gnump3d::readtags;

# set the version for version checking
my $VERSION = '$Revision: 1.21 $';

#
# All the lines read from the tag cache object.
#
my $CACHE_FILE    = "";
my $FORMAT_STRING = "";
my $NEW_FORMAT_STRING = "";
my $HIDE_TAGS     = 0;
my $DISABLE_CACHE = 0;
my $CACHE_MOD     = 0;
my $UPDATE_MOD    = 0;
my $NEW_DAYS      = 0;
my %CACHE         = ( );

#
#  Create a new instance of this object.
#
sub new
{
    my $class = shift;
    my $self  = { };

    bless($self, $class);
    return $self;
}


#
#  Set the format string this object will use when formatting the
# audio files.
#
sub setFormatString( )
{
    my $self       = shift;
    $FORMAT_STRING = shift;
}

#
#  Set the format string this object will use when formatting "new" files.
#
sub setNewFormatString( )
{
    my $self       = shift;
    $NEW_FORMAT_STRING = shift;
}

#
#  Files less than N days older than now will be considered old.
#
sub setNewDays( )
{
    my $self       = shift;
    $NEW_DAYS = shift;
}

#
#  Retrieve the format string currently in use.
#
sub getFormatString( )
{
    my $self = shift;
    return( $FORMAT_STRING );
}

sub getCacheMod( )
{
  my $self = shift;
  return ($CACHE_MOD);
}

#
#  If called with a positive argument the tag details will be ignored,
# and only filenames will be displayed.
#
sub setHideTags( )
{
    my $self   = shift;
    $HIDE_TAGS = shift;
}

#
#  If called with a positive argument we will disable tag caching.
#
sub setDisableCache( )
{
    my $self	   = shift;
    $DISABLE_CACHE = shift;
}


#
#  Determine if we're hiding song tags.
#
sub getHideTags( )
{
    my $self = shift;
    return( $HIDE_TAGS );
}


#
#  Return the name of the cache file we're reading from.
#
sub getCacheFile
{
    my $self = shift;
    return( $CACHE_FILE );
}


#
#  Specify the name of the cache file to read from, if one has previously
# been read it's contents will be discarded.
#
sub setCacheFile
{
    my $self = shift;
    my $file = shift;
    my $count = 0;

    if ( ( $DISABLE_CACHE == 0 ) and
	 ( -e $file ) ) {
      my @finfo = stat($file);
      if (($finfo[9] > $CACHE_MOD) or ($file ne $CACHE_FILE)) {
	open( FILY, "<$file" )
	  or die "Cannot read cache file $file - $!";

	foreach (<FILY>) {
	  my %TAGS;
	  chomp;
	  $count++;
	  my @NAMES = split( /\t/, $_);
	  my $file = shift(@NAMES);
	  foreach my $pair ( @NAMES ) {
	    if ( ( $pair =~ /([A-Z]+)=(.*)/ ) &&
		 ( length( $2 ) ) ) {
	      $TAGS{ $1 } = $2;
	    }
	  }
	  $CACHE{$file} = \%TAGS;
	}
	close( FILY );
      }
      $CACHE_MOD = $finfo[9];
      $CACHE_FILE = $file;

      if (-e "$file.updates") {
	@finfo = stat("$file.updates");
	if (($finfo[9] > $UPDATE_MOD) and
	    ($finfo[9] >= $CACHE_MOD)) {
	  open( FILY, "<$file.updates" )
	    or die "Cannot read cache file $file.updates - $!";

	  foreach (<FILY>) {
	    my %TAGS;
	    chomp;
	    $count++;
	    my @NAMES = split( /\t/, $_);
	    my $file = shift(@NAMES);
	    foreach my $pair ( @NAMES ) {
	      if ( ( $pair =~ /([A-Z]+)=(.*)/ ) &&
		   ( length( $2 ) ) ) {
		$TAGS{ $1 } = $2;
	      }
	    }
	    $CACHE{$file} = \%TAGS;
	  }
	  close( FILY );
	}
	$UPDATE_MOD = $finfo[9];
      }
    }

    if ($count > 0) {
      #		print "Tag Cache initialized, $count entries\n";
    }
}

#
#  check for (and load) updated cache files.
#
sub checkForUpdates
{
    my $self = shift;
    $self->setCacheFile( $CACHE_FILE );
}


#
#   Obtain and format the song tags for a collection of files, this is
# massively faster than doing the same operation on a single file.
#
sub formatMultipleSongTags
{
    my ( $self, @files ) = ( @_ );

    #
    # We return a hash of results - each key is the name of a file,
    # and each value is the formatted result.
    #
    my %RESULTS;

    #
    #  Now find the tags for each file, and format them
    #
    foreach my $file ( @files )
    {
	#  Remove double slashes.
	while( $file =~ /\/\// )
	{
	    $file =~ s/\/\//\//g;
	}

	# The formatted tags.
	my $formatted = "";

	if ( $HIDE_TAGS )
	{
	    # Store filename
	    $formatted = $file;
	}
	else
	{
	    #
	    # Find and format the tags, if present.
	    #
	    $formatted = $self->_formatSingleFile( $file );
	}

	$RESULTS{ $file } = $formatted;
    }

    return( %RESULTS );
}


#
#  Read the tags and format them for the given single file.
#
sub _formatSingleFile ( )
{
    my $self = shift;
    my $file = shift;

    # Holder for the tag values.
    my %TAGS;

    if (exists($CACHE{$file})) 
    {
	%TAGS = %{$CACHE{$file}};
    }
    else
    {
	%TAGS = &main::getTags($file);

	# Store the entry in our cache file, if enabled
	goto skipped if ( ( -z $CACHE_FILE ) or
			  ( $DISABLE_CACHE != 0) );

	my $fh;
	if (-e "$CACHE_FILE.updates") {
	  $fh = new IO::File "$CACHE_FILE.updates", O_WRONLY|O_APPEND|O_EXCL;
	} else {
	  $fh = new IO::File "$CACHE_FILE.updates", O_WRONLY|O_APPEND|O_EXCL|O_CREAT;
	}

	goto skipped if (!defined($fh));

	print $fh "$file";
	foreach my $k ( keys(%TAGS) ) {
	  my $value = $TAGS{ $k };

	  # Replace tabs in tag values with spaces so that the reading
	  # code doesn't get confused by excessive deliminators.  (Curious,
	  # why 5 spaces?  GH)
	  $value =~ s/\t/     /g;

	  print $fh "\t" . $k . "=" . $value;
	}
	print $fh "\n";
	undef($fh); # Automatically closes the file;

      skipped:
	# And now, store the results in the cache so we don't have
	# to look it up again.
	$CACHE{$file} = \%TAGS;
    }

    #
    # Work with a copy - we destroy the original
    #
    my $format = $FORMAT_STRING;

    while( $format =~ /(.*)\$([A-Z]+)(.*)/ )
    {
	my $pre  = $1;
	my $key  = $2;
	my $post = $3;

	#
	# Why, oh why did I not use '$TITLE' for the song title?
	#
	if( $key eq "SONGNAME" )
	{
	    $key = 'TITLE';
	}

	#
	# Allow the song length in seconds to be used
	# this is used in the advanced playlists.
	#
	if ( $key eq "SECONDS" )
	{
            my $length = $TAGS{'LENGTH'} || "";

	    my $hours  = 0;
	    my $mins   = 0;
	    my $secs   = 0;

	    if ( $length =~ /^([0-9]+):([0-9]+):([0-9]+)$/ )
	    {
	        $hours = $1;
		$mins  = $2;
		$secs  = $3;
	    }
	    else
	    {
	        if ( $length =~ /^([0-9]+):([0-9]+)$/ )
	        {
		    $hours= 0;
		    $mins = $1;
		    $secs = $2;
	        }
	    }

	    $length = ( ( $secs ) +
			( $mins  * 60 ) +
			( $hours * 3600 ) );

	    $format = $pre . $length . $post;
	    next;
	}

	if ( $key eq "SIZE" ) {
	  if ( defined( $TAGS{ 'SIZE' } ) ) {
	      my $sizeTotal = $TAGS{'SIZE'};
	      
	      $sizeTotal = $sizeTotal < (1024)      ?
		$sizeTotal . " bytes" : (
                      $sizeTotal < (1024 ** 2) ? 
                      (int (10 * $sizeTotal/1024)/10) . "K" : (
                      $sizeTotal < (1024 ** 3) ? 
                      (int (10 * $sizeTotal/(1024 ** 2) )/10) . "Mb" :
                      ((int (10 * $sizeTotal/(1024 ** 3) )/10) . "Gb")));

	      $format = $pre . $sizeTotal . $post;
	    } else {
	      $format = $pre . $post;
	    }
	  next;
	} 

	if ( $key eq "NEW" ) {
#	  print "tag_mtime $TAGS{MTIME} cache_mod $CACHE_MOD update_mod $UPDATE_MOD\n";
	  if (exists($TAGS{"MTIME"}) && (($TAGS{"MTIME"} > $CACHE_MOD) ||
					 ($TAGS{"MTIME"} > (time() - ($NEW_DAYS * 86400))))) {
	    $format = $pre . $NEW_FORMAT_STRING . $post;
	  } else {
	    $format = $pre . $post;
	  }
	  next;
	}

	if (defined($TAGS{$key})) {
	    # Do the insertion.
	    $format = $pre . gnump3d::url::encodeEntities( $TAGS{$key} ) . $post;
	} else {
	    $format = $pre . $post;
	}
    }

    #
    #  Make sure we have 'real' tags found.
    #

    my $valid = 0;
    foreach my $key ( keys %TAGS )
    {
	next if ( $key eq 'BITRATE' );
	next if ( $key eq 'CHANNELS' );
	next if ( $key eq 'FILENAME' );
	next if ( $key eq 'FLAG' );
	next if ( $key eq 'LENGTH' );
	next if ( $key eq 'LOWER' );
	next if ( $key eq 'NOMINAL' );
	next if ( $key eq 'RATE' );
	next if ( $key eq 'SIZE' );
	next if ( $key eq 'UPPER' );
	next if ( $key eq 'VERSION' );
	next if ( $key eq 'WINDOW' );
	next if ( $key eq 'MTIME' );
	next if ( $TAGS{"$key"} eq '' ); # tag cache can have "empty" tags.

	$valid++;
      }

    #
    #  No real tags found - This is necessary as some tags such as file
    # length, and filesize are independent of real tags.
    #
    if ( $valid < 1 )
    {
      $format = $TAGS{"FILENAME"};
    }

    return($format);

}


#
# End of module
#
1;



=head1 NAME

gnump3d::tagcache  - A simple object to interface with our tag cache

=head1 SYNOPSIS


    use gnump3d::tagcache;

    my @files;

    my $tagCache = gnump3d::tagcache->new( );
    $tagCache->setCacheFile( 'tags.cache' );
    $tagCache->setFormatString( '$ARTIST - SONGNAME' );
    $tagCache->setHideTags( 0 );

    my %TAGS     = $tagCache->formatMultipleSongTags( @files );



=head1 DESCRIPTION

This module implements a simple means of reading and formating the tags
of a group of files en masse from the tag cache created by the gnump3d-index
script


=head2 Methods

=over 8

=item C<new>

Return a new instance of this object.

=item C<setFormatString>

Set the format string this object will use when formatting the audio
files

=item C<getFormatString>

Get the format string currently in use.

=item C<setNewFormatString>

Set the format string this object will use when displaying "new" files.

=item C<setNewDays>

Set the maximum age, in days, after which a file is considered old.

=item C<setHideTags>

Specify whether we should just display the filenames for files, not their tag details.

=item C<getHideTags>

Determine if we're hiding song tags.

=item C<setCacheFile>

Specify the name of the cache file to read when formatting tags.  If a cache file has previously been specified this will be used instead.  If the same file is specified, this will check for updates, and if so, load them.

=item C<getCacheFile>

Return the name of the cache file we're going to read the tags from.

=item C<checkForUpdates>

Check for updated cache/updatecache files, and if updated, load 'em up.

=item C<formatMultipleSongTags>

Obtain and format the song tags for a collection of files, this is
massively faster than doing the same operation on a single file.

=back

=head1 AUTHOR

  Part of GNUMP3d, the MP3/OGG/Audio streaming server.

Steve - http://www.gnump3d.org/

=head1 SEE ALSO

L<gnump3d>

=cut
