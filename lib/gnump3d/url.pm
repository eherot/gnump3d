#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  url.pm   - Simple URL decoding, and encoding library.
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


package gnump3d::url;  # Must live in url.pm

require Exporter;
use strict;
use vars       qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

# set the version for version checking
$VERSION     = "0.01";

@ISA         = qw(Exporter);
@EXPORT      = qw( &urlEncode &urlDecode );
%EXPORT_TAGS = ( );



=head2 urlEncode

  Encode a string into a format suitable for use as an URL.

=cut

sub urlEncode 
{
    my ( $text ) = ( @_ );

    my $MetaChars = quotemeta( ' ;,?\|=+)(*&^%$#@!~`');
    $text =~ s/([$MetaChars\"\'\x80-\xFF])/"%" . uc(sprintf("%2.2x",ord($1)))/eg;

    # Deal with special characters.
    $text = &encodeEntities( $text );

    return( $text );
}



=head2 urlDecode

  Decode an URL encoded string.

=cut

sub urlDecode
{
    my ( $text ) = ( @_ );

    # Deal with special characters.
    $text = &decodeEntities( $text );

    # This '+' -> ' ' conversion shouldn't be necessary ..
    # It's here to correct possibly buggy calls.
    $text =~ s/\+/ /g;

    #
    #  Unpack %XX characters into their intended character.
    #
    $text =~ s/%([0-9A-H]{2})/pack('C',hex($1))/ge;

    return( $text );
}



=head2 encodeEntities

  Encode special HTML entities.

  TODO: Implement fully

=cut 

sub encodeEntities
{
    my ( $text ) = ( @_ );
    $text =~ s/&/&amp;/g;
    return( $text );
}



=head2 decodeEntities

  Decode special HTML entities.

  TODO: Implement.

=cut

sub decodeEntities
{
    my ( $text ) = ( @_ );

    return( $text );
}


#
# End of module
#
1;


=head1 NAME

gnump3d::url - A simple URL encoding and decoding class

=head1 SYNOPSIS

    use gnump3d::url;

    my $decoded = urlDecode( "some%20url%20encoded%20string" );


=head1 DESCRIPTION

This module is a contains a pair of functions for performing URL
encoding, and decoding.  This allows conversion of '%20' to and
from ' ' for example.


=head2 Methods

=over 8

=item C<urlEncode>

Encode and return the given string.

=item C<urlDecode>

Decode and return the given string.

=back

=cut


=head1 AUTHOR

  Part of GNUMP3d, the MP3/OGG/Audio streaming server.

Steve - http://www.gnump3d.org/

=head1 SEE ALSO

L<gnump3d>

=cut
