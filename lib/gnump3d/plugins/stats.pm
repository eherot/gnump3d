#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  stats.pm - List the most popular songs, directorys, etc.
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
#  $Id: stats.pm,v 1.7 2005/12/03 18:15:35 skx Exp $
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
package plugins::stats;


#
#  Register the plugin.
#
::register_plugin("plugins::stats");


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
    my $REVISION      = '$Id: stats.pm,v 1.7 2005/12/03 18:15:35 skx Exp $';
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

    if ( $path =~ /^\/stats\/*/i )
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

    my $header   = &getHTTPHeader( 200, "text/html" );
    &sendData( $data, $header );

    my $text = $class->_handleStats( $ARGUMENTS{"theme"});
    &sendData( $data, $text );

    close( $data );
    exit;
}



#
#  Display the most popular songs, directories, useragents, and clients.
#
#  This is done by calling out to the `gnump3d-top` binary.
#
#
sub _handleStats
{
    my ($class,$theme) = (@_);

package main;

    my $text    = "";

    my $config = &configFile();

    my @template = &getThemeFile( $theme, "stats.html" );
    foreach my $line (@template )
    {
	#
	# Make global substitutions.
	#
	$line =~ s/\$HOSTNAME/$host/g;
	$line =~ s/\$VERSION/$VERSION/g;
	$line =~ s/\$RELEASE/$RELEASE/g;
	$line =~ s/\$DIRECTORY/\/stats\//g;
	$line =~ s/\$HEADING/Statistics/g;
	$line =~ s/\$TITLE/Statistics/g;
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
	    $text .= &getBanner( "/stats/" );
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$MOST_POPULAR_SONGS(.*)/ )
	{
	    my $popularsongs = `$STATSPROG --config=$config $STATSARGS --songs`;
	    my $pre  = $1;
	    my $post = $2;

	    $text .= $pre;
	    $text .= $popularsongs;
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$MOST_POPULAR_DIRS(.*)/ )
	{
	    my $populardirs  = `$STATSPROG --config=$config $STATSARGS --dirs`;
	    my $pre  = $1;
	    my $post = $2;

	    $text .= $pre;
	    $text .= $populardirs;
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$MOST_POPULAR_USER_AGENTS(.*)/ )
	{
	    my $useragents   = `$STATSPROG --config=$config $STATSARGS --agents`;
	    my $pre  = $1;
	    my $post = $2;

	    $text .= $pre;
	    $text .= $useragents;
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$MOST_ACTIVE_CLIENTS(.*)/ )
	{
	    my $popularusers = `$STATSPROG --config=$config $STATSARGS --users`;
	    my $pre  = $1;
	    my $post = $2;

	    $text .= $pre;
	    $text .= $popularusers;
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$MOST_ACTIVE_LOGINS(.*)/ )
	{
	    my $popularusers = `$STATSPROG --config=$config $STATSARGS --logins`;
	    my $pre  = $1;
	    my $post = $2;

	    $text .= $pre;
	    $text .= $popularusers;
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
