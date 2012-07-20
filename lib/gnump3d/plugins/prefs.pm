#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  prefs.pm - Allow users to make their own settings.
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
#  $Id: prefs.pm,v 1.14 2005/12/05 23:30:06 skx Exp $
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
package plugins::prefs;


#
#  Register the plugin.
#
::register_plugin("plugins::prefs");



#
#  Minimal constructor.
#
sub new { return bless {}; }



use gnump3d::files; 	   # My routines for working with files and dirs.


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
    my $REVISION      = '$Id: prefs.pm,v 1.14 2005/12/05 23:30:06 skx Exp $';
    my $VERSION       = "";
    $VERSION = join (' ', (split (' ', $REVISION))[1..2]);
    $VERSION =~ s/,v\b//;
    $VERSION =~ s/(\S+)$/($1)/;

    return( $VERSION );
}


#
#  Will this plugin handle the requested URI path?
#
sub wantsPath
{
    my ( $class, $path ) = ( @_ );

    if ( $path =~ /^\/prefs\/*/i )
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
package main;

    my ( $class, $uri ) = (@_);

    my $header   = &getHTTPHeader( 200, "text/html" );
    &sendData( $data, $header );

    my $text = $class->_getPrefsForm( $ARGUMENTS{"theme"});
    &sendData( $data, $text );

    close( $data );
    exit;
}



#
#  Read and return the preferences form to the caller.
sub _getPrefsForm
{
    my ($class,$theme) = ( @_ );
    my $text    = "";

package main;

    my @template = &getThemeFile( $theme, "prefs.html" );
    foreach my $line (@template )
    {
	#
	# Make global substitutions.
	#
        $line =~ s/\$HEADER//g;
	$line =~ s/\$HOSTNAME/$host/g;
	$line =~ s/\$VERSION/$VERSION/g;
	$line =~ s/\$RELEASE/$RELEASE/g;
	$line =~ s/\$DIRECTORY/\/prefs\//g;
	$line =~ s/\$HEADING/Preferences/g;
	$line =~ s/\$TITLE/Preferences/g;
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
	    $text .= &getBanner( "/prefs/" );
	    $text .= $post;
	}
	elsif ( $line =~ /(.*)\$TEXT(.*)/ )
	{
	    my $pre  = $1;
	    my $post = $2;
	    $text .= $pre;


	    $text .=<<E_O_BUG;
<p>&nbsp;This page allows you to customize your music streaming experience, by changing the type of information which is displayed or changing it's presentation.</p>
<form action='/' method='get'>
<table>
E_O_BUG


#
# Start of downsampling options
#
	    #
	    #  Don't show the downsampling option if it's turned
	    # of in the servers configuration file.
	    #
	    #
	    if ( &getConfig( "downsample_enabled", 0 ) )
	    {
		$text .=<<E_O_BITRATE_PREFIX;
<tr><td><b>Downsampling</b></td><td>
<select name="quality">
E_O_BITRATE_PREFIX

		my $sample = $ARGUMENTS{"quality" };
		if ( not defined( $sample ) )
		{
		    $sample = "";
		}
		my %BITRATES ;
		$BITRATES{'low'}    = "Low Quality";
		$BITRATES{'medium'} = "Medium Quality";
		$BITRATES{'high'}   = "High Quality";
		$BITRATES{''}       = "Disabled";
		foreach my $key (keys %BITRATES )
		{
		    my $val = $BITRATES{$key};
		    my $selected = "";
		    if ( $key eq $sample )
		    {
			$selected = " selected";
		    }
		    if ( defined( $val ) && length( $val ) )
		    {
			$text .= "<option value='$key'$selected>$val</option>\n";
		    }
		}

		$text .=<<E_O_BITRATE_SUFFIX;
</select>
</td></tr>
<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
E_O_BITRATE_SUFFIX
	    }
	    #
	    # End of downsampling options
	    #

	    my $current = $ARGUMENTS{"sort_order" };
	    if ( not defined( $current ) )
	    {
		$current = "";
	    }
	    my %OPTIONS ;
	    $OPTIONS{'$TITLE'}		      = "By Song Title";
	    $OPTIONS{'$ARTIST $ALBUM $TRACK'} = "By Artist, Album, Track";
	    $OPTIONS{'$ARTIST'}		      = "By Artist";
	    $OPTIONS{'$ALBUM'}		      = "By Album";
	    $OPTIONS{'$FILENAME'}	      = "By Filename";
	    $OPTIONS{'$ARTIST $ALBUM'}	      = "By Artist and Album";
	    $OPTIONS{'$TRACK'}		      = "By Track number" ;
	    $OPTIONS{'$LENGTH'}		      = "By Track length" ;
	    $OPTIONS{'$SIZE'}		      = "By File Size" ;
	    $OPTIONS{'$GENRE'}		      = "By Genre" ;
	    $OPTIONS{'$FILEDATE'}	      = "By File Modified Time" ;


	    #
	    # Find our language directory.
	    #
	    my $langdir = "";
	    foreach my $dir ( @INC )
	    {
		if ( -e $dir . "/gnump3d/lang/lookup.pm" )
		{
		    $langdir = $dir . "/gnump3d/lang";
		}
	    }

	    #
	    # And the language modules installed.
	    #
	    my $langs = "";

	    if ( length( $langdir ) )
	    {
		$langs = "<ul>\n";
		foreach my $file ( glob( $langdir . "/??.pm" ) )
		{
		    if ( $file =~ /(.*)\/(.*)\.pm$/ )
		    {
			$file = $2;
		    }
		    $langs .= "<li>$file</li>\n";
		}
		$langs .= "</ul>\n";
	    }
	    else
	    {
		$langs = "None detected.  Eww";
	    }

	    $text .=<<E_O_LANG;
<tr><td valign="top"><b>Available Languages</b></td>
    <td valign="top">$langs</td></tr>
E_O_LANG

	    $text .=<<E_O_SORT;
<tr><td><b>Sort Order</b></td><td>
<select name="sort_order">
E_O_SORT

        foreach my $key (keys %OPTIONS )
	{
	    my $val = $OPTIONS{$key};
	    my $selected = "";
	    if ( $key eq $current )
	    {
		$selected = " selected";
	    }
	    if ( defined( $val ) && length( $val ) )
	    {
		$text .= "<option value='$key'$selected>$val</option>\n";
	    }
	}

            $text .=<<E_O_BUG2;
</select>
</td></tr>
<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
E_O_BUG2

	    my @dirs = &dirsInDir( $theme_dir );

	    # Sort case-insensitively
	    @dirs = sort {uc($a) cmp uc($b)} @dirs;

	    $text .= "<tr><td valign=\"top\"><b>Theme</b></td><td>\n";
	    foreach my $name (@dirs )
	    {
                my $checked = "";
		my $author  = "";

		next if ( $name =~ /^CVS$/ );

		#
		# Read the Author of the theme if it's defined.
		#
		if ( -e $theme_dir . "/" . $name . "/" . "AUTHOR" )
		{
		    my @AUTHOR = &readFile( $theme_dir . "/" . $name . "/" . "AUTHOR" );
		    if ( ( defined( $AUTHOR[0] ) ) &&
			 ( length( $AUTHOR[0] ) ) )
		    {
			$author = $AUTHOR[0];
		    }
		}


                if ( $ARGUMENTS{"theme"} eq $name )
                {
                   $checked = "checked='checked'";
                }
                $text .= "<input type=\"radio\" name=\"theme\" value=\"$name\"  $checked /> $name $author<br/>";
	    }

            $text .= "</td></tr>\n";
            $text .=<<E_O_BUG3;

<tr><td>&nbsp;</td><td><input type='submit' value='Set Preferences' /></td></tr>
</table></form>\n
E_O_BUG3

	    $text .= $post;

	    if ( defined( $LOGGED_IN_USER ) and
		 length( $LOGGED_IN_USER ) )
	    {
	         $text .= "<p>&nbsp;You are currently logged in as <b>$LOGGED_IN_USER</b>.</p>\n";
	    }
	}
	else
	{
	    $text .= $line;
	}
    }

    return( $text );
}


1;
