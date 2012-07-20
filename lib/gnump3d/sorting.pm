#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  sorting.pm   - Centralised sorting module, used for all displaying.
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


package gnump3d::sorting;  # Must live in sorting.pm

use gnump3d::tagcache;

require Exporter;
use strict;
use vars       qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

# set the version for version checking
$VERSION     = "0.01";

@ISA         = qw(Exporter);
@EXPORT      = qw( &new 
                   &sortFiles &sortDirectories
                   &setTagCache &getTagCache 
                 );
%EXPORT_TAGS = ( );

#
#  The tag cache that we use.
#
my $TAG_CACHE = "";


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



sub getTagCache( )
{
  my ( $class ) = ( @_ );
  return( $TAG_CACHE );
}

sub setTagCache( $ )
{
  my ( $class, $cache ) = ( @_ );
  $TAG_CACHE = $cache;
}

sub getSongDisplay( $ $ )
{
  my ( $file, $format ) = ( @_ );

  my @ARRAY = ( );
  push @ARRAY, $file;

  my %TAGS     = $TAG_CACHE->formatMultipleSongTags( @ARRAY );
  return( $TAGS{ $file } );
}

#
#  Sort a list of files by the display format specified.
#
#  There's nothing magic going on here, but we should sort _numerically_
# when track numbers are involved.
#
sub sortFiles( $ @ )
{
    my ( $format, @files ) = ( @_ );

    # Get the current song format.
    my $oldFormat = $TAG_CACHE->getFormatString( );

    # Set the global format string to be our sorting format.
    $TAG_CACHE->setFormatString( $format ) ;

    my @SORTED = ( );

    if ( $format =~ /\$TRACK/ ) 
    {
      @SORTED = sort{ my $one = getSongDisplay( $a, $format );
		      my $two = getSongDisplay( $b, $format );

		      #
		      #  If the song format includes the numbers then
		      # only sort on those.
		      #
		      #
		      if ( $one =~ /(\d+)/ ) {
			  $one = $1; 
		      } else {
			  $one = '0'; 
		      }

		      if ( $two =~ /(\d+)/ ) {
			  $two = $1;
		      } else {
			  $two = '0'; 
		      }

		      return( $one <=> $two ); } @files;
    }
    elsif ( $format =~ /\$FILEDATE/ )
    {
      @SORTED = sort{ return (stat($b))[9] <=> ( stat($a))[9]; } @files;
    }
    elsif ( $format =~ /\$FULLPATH/ )
    {
      @SORTED = sort{ print "One: $a\n";
                      print "Two: $b\n";
                      return( uc($a) cmp uc($b) ); } @files;
    }
    else
    {
      @SORTED = sort{ my $one = getSongDisplay( $a, $format );
		      my $two = getSongDisplay( $b, $format );
		      print "One: $one\n";
			print "Two: $two\n";
		      return( uc($one) cmp uc($two) ); } @files;
    }

    # Restore the previous format string.
    $TAG_CACHE->setFormatString( $oldFormat );

    # Return the results.
    return( @SORTED );
}


sub sortDirectories( @ )
{
  my ( @dirs ) = ( @_ );

  @dirs = sort{ uc($a) cmp uc($b) } @dirs ;

  return( @dirs );
}

#
# End of module
#
1;


=head1 NAME

gnump3d::sorting - A centralised module for sorting files.

=head1 SYNOPSIS

    use gnump3d::sorting;

    my @displaying = &sortFiles( @files );


=head1 DESCRIPTION

This module contains code for sorting a collection of files
by a given format.

=head2 Methods

=over 8

=item C<sortFiles>

Sort an array of files by the sort parameters given.

=back

=cut

=head1 AUTHOR

  Part of GNUMP3d, the MP3/OGG/Audio streaming server.

Steve - http://www.gnump3d.org/

=head1 SEE ALSO

L<gnump3d>

=cut
