#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  base64.pm - A simplistic base64 decoding utility package.
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


package gnump3d::base64;  # Must live in base64.pm


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
#  Decode the given base64 encoded string.
#
sub decode($)
{
    my($self, $str ) = (@_);

    local($^W) = 0; # unpack("u",...) gives bogus warning in 5.00[123]

    $str =~ tr|A-Za-z0-9+=/||cd;            # remove non-base64 chars
    if (length($str) % 4) {
	require Carp;
	Carp::carp("Length of base64 data not a multiple of 4")
    }
    $str =~ s/=+$//;                        # remove padding
    $str =~ tr|A-Za-z0-9+/| -_|;            # convert to uuencoded format

    return join'', map( unpack("u", chr(32 + length($_)*3/4) . $_),
	                $str =~ /(.{1,60})/gs);

}



#
# End of module
#
1;


=head1 NAME

gnump3d::base64 - A simple decoder for Base64 encoded strings.

=head1 SYNOPSIS


    use gnump3d::base64;

    my $decoder = gnump3d::base64->new( );

    my $decoded = $decoder->decode( $encoded_string );


=head1 DESCRIPTION

This module is a simple portable example of a base 64
decoder.


=head2 Methods

=over 12

=item C<new>

Return a new base 64 decoding object.

=item C<decode>

Return the decoded representation of the given string.

=back

=head1 AUTHOR

  Part of GNUMP3d, the MP3/OGG/Audio streaming server.

Steve - http://www.gnump3d.org/

=head1 SEE ALSO

L<gnump3d>

=cut
