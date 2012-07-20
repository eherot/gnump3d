#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  filetypes.pm - Some simple routines to lookup the type of a file.
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


package gnump3d::filetypes;  # must live in filetypes.pm

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);


require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
@EXPORT = qw();

($VERSION)       = '$Revision: 1.3 $' =~ m/Revision:\s*(\S+)/;


#
#  Standard modules
#
use strict;
use warnings;
use gnump3d::config;



=head2 new

  Create a new instance of this object.

=cut

sub new
{
    my ( $proto, %supplied ) = (@_);
    my $class = ref($proto) || $proto;

    my $self  = {};

    $self->{file} = "/etc/gnump3d/file.types" 
      if ( -e "/etc/gnump3d/file.types"  );

    $self->{file} = "C:/gnump3d2/etc/file.types" 
      if ( -e "C:/gnump3d2/etc/file.types"  );

    #
    #  Allow user supplied values to override our defaults
    #
    foreach my $key ( keys %supplied )
    {
	$self->{ lc $key } = $supplied{ $key };
    }

    bless ($self, $class);
    return $self;

}




=head2 _getSuffix

  Return the suffix, if any, of the given file.

=cut

sub _getSuffix
{
    my ( $class, $file ) = ( @_ );

    if ( $file =~ /(.*)\.(.*)$/ )
    {
	return $2;
    }
    else
    {
	return undef;
    }
}



#
#  Return 1 if the named file is an audio file
# return 0 otherwise
#
sub isAudio
{
    my ($class, $file) = (@_);

    my ($suffix) = $class->_getSuffix( $file );

    if ( not defined $suffix )
    {
	return 0;
    }

    #
    #  If we haven't read the file types, do so now.
    #
    if ( !$class->{cache} )
    {
	$class->{cache} = gnump3d::config::read_config_file( $class->{file} );
    }


    $suffix = lc( $suffix );

    if ( ( $class->{cache}->{ $suffix }  ) &&
	 ( $class->{cache}->{ $suffix } eq "audio" ) )
    {
	return 1;
    }
    else
    {
	return 0;
    }
}




#
#  Return 1 if the named file is an playlist file
# return 0 otherwise
#
sub isPlaylist( $ )
{
    my ($class, $file ) = (@_);
    my ($suffix) = $class->_getSuffix( $file );

    if ( not defined $suffix )
    {
	return 0;
    }

    $suffix = lc( $suffix );

    #
    #  If we haven't read the file types, do so now.
    #
    if ( !$class->{cache} )
    {
	$class->{cache} = read_config_file( $class->{file} );
    }


    $suffix = lc( $suffix );

    if ( ( $class->{cache}->{ $suffix }  ) &&
	 ( $class->{cache}->{ $suffix } eq "playlist" ) )
    {
	return 1;
    }
    else
    {
	return 0;
    }
}



#
#  Return 1 if the named file is a movie file
# return 0 otherwise
#
sub isMovie( $ )
{
    my ($class, $file ) = (@_);
    my ($suffix) = $class->_getSuffix( $file );

    if ( not defined $suffix )
    {
	return 0;
    }

    $suffix = lc( $suffix );

    #
    #  If we haven't read the file types, do so now.
    #
    if ( !$class->{cache} )
    {
	$class->{cache} = read_config_file( $class->{file} );
    }


    $suffix = lc( $suffix );

    if ( ( $class->{cache}->{ $suffix }  ) &&
	 ( $class->{cache}->{ $suffix } eq "movie" ) )
    {
	return 1;
    }
    else
    {
	return 0;
    }
}

#
# End of module
#
1;
