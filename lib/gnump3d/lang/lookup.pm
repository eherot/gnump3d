#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  lookup.pm - A simplistic language lookup system.
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


package gnump3d::lang::lookup;

#
#  Create a new instance of this class.
#
sub new {
    my $classname  = shift;         # What class are we constructing?
    my $self      = {};             # Allocate new memory
    bless($self, $classname);       # Mark it of the right type

    return $self;
}


#
#  Load the language specific module.
#
sub loadLanguage( $ )
{
    my ( $class, $lang ) = ( @_ );

    my $module = "gnump3d::lang::$lang;";

    eval " use $module; ";

    die "FAILED To Load Language module '$lang.pm': $@\n" if  $@;
}


#
#  Get one of our keys.
#
sub get( $ )
{
    my ( $class, $key ) = ( @_ );

    return( &interpolateString( $class, $TEXT{ $key }  ) );
}

#
#  Return an interpolated string, using values from the global
# defined namespace.
#
sub interpolateString( $ )
{
    my ( $class, $text ) = ( @_ );

    {
	no strict 'refs';
	no warnings;

	while ( $text =~ s!(.*?)\$([a-zA-Z-_\!]+)(.*)!$1.${'main::'.$2}.$3!e )
	{
	    1 
	};

    }
    return( $text );
}






#
#  We've loaded successfully.
#
1;
