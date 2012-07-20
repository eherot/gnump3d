#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  config.pm - A simple `name=value` configuration file reader.
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


package gnump3d::config;  # must live in config.pm
require Exporter;
use strict;
use vars       qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

# set the version for version checking
$VERSION     = "0.01";

@ISA         = qw(Exporter);
@EXPORT      = qw( read_config_file readConfig getConfig configFile getHash isWindows );
%EXPORT_TAGS = ( );

# your exported package globals go here,
# as well as any optionally exported functions
@EXPORT_OK   = ( ) ;


#
#  The hash storing the name and values we read from the
# configuration file.
#
my $hash;


#
#  The file that we, last, read our configuration values from.
#
my $CONFIG_FILE = "";



#
#
#  Read the configuration file.
#
#
sub readConfig
{
    my ($file) = (@_);

    $hash  = read_config_file( $file );

    $CONFIG_FILE = $file;
}


sub getHash
{
    my %HASH= %$hash;
    return( %HASH );
}

sub configFile
{
    return( $CONFIG_FILE );
}

#
#
#  Return a configuration setting from the config file.
#
#
sub getConfig
{
    my ( $key, $default ) = ( @_ );
    my $value = undef;

    my %HASH= %$hash;


    if ( !defined( $value ) )
    {
	if( defined( $HASH{ $key } ) )
	{
	    $value = $HASH{ $key };
	}
	else
	{
	    return( $default );
	}
    }
    return( $value );
}

#
#  Return '1' if the system is running under Windows.
#
sub isWindows
{
  if ( $^O =~ /win/i )
  {
    return 1;
  }
  else
  {
    return 0;
  }
}



#
#  Copied literally from ConfigFile;
#
sub read_config_file($) 
{
    my ($line, $Conf, $file);
    $file = shift;
    open(CONF, "< " . $file) ||
        die "Can't read configuration in $file: $!\n";
    while(<CONF>) {
        my ($conf_ele, $conf_data);
        chomp;
        next if m/^\s*#/;
        $line = $_;
        $line =~ s/(?<!\\)#.*$//;
        $line =~ s/\\#/#/g;
        next if $line =~ m/^\s*$/;
        $line =~ s{\$(\w+)}{
            exists($Conf->{$1}) ? $Conf->{$1} : "\$$1"
            }gsex;
        $line =~ m/\s*([^\s=]+)\s*=\s*(.*?)\s*$/;

        ($conf_ele, $conf_data) = ($1, $2);
        unless ($conf_ele =~ /^[\]\[A-Za-z0-9_-]+$/) {
            warn "Invalid characters in key $conf_ele - Ignoring";
            next;
        }
        $conf_ele = '$Conf->{' . join("}->{", split /[][]+/, $conf_ele) . "}";
        $conf_data =~ s!([\\\'])!\\$1!g;
        eval "$conf_ele = '$conf_data'";
    }
    close CONF;
    return $Conf;
}


#
# End of module
#
1;



=head1 NAME

gnump3d::config - A simple module for reading configuration variables.

=head1 SYNOPSIS

    use gnump3d::config;
    &readConfig( "/some/config.ini" );

    my $val = &getConfig( "key1", "default-value" );

=head1 DESCRIPTION

This module is a simple means of reading in configuration
variables from a standard .ini type configuration file.

The file is assumed to contain lines of the form:

   key = value

Lines beginning with '#' are comments which are ignored.

=head2 Methods

=over 12

=item C<readConfig>

Read in the configuration file specified, and initialize
state.

=item C<getConfig>

Return the value of a given key, if the key isn't present in
the configuration file then return the supplied default.


=item C<isWindows>

A utility method for detecting whether the module is running
under the Microsoft Windows operating system.

=back

=head1 AUTHOR

  Part of GNUMP3d, the MP3/OGG/Audio streaming server.

Steve - http://www.gnump3d.org/

=head1 SEE ALSO

L<gnump3d>

=cut
