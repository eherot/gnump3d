#!/usr/bin/perl -w  # -*- cperl -*- #
#
#  files.pm - Some simple files and directories utility functions.
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


package gnump3d::files;  # must live in files.pm
require Exporter;
use strict;
use vars       qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

# set the version for version checking
my $VERSION = '$Revision: 1.26 $';


@ISA         = qw(Exporter);
@EXPORT      = qw( &filesInDir &filesInDirRecursively
		   &filesInDirsOnlyRecursively 
		   &dirsInDir &getSuffix
                   &readFile &readFileWithExpansion
                   &getModifiedDate &getModifiedTime );

%EXPORT_TAGS = ( );

# your exported package globals go here,
# as well as any optionally exported functions
@EXPORT_OK   = ( ) ;



use gnump3d::config;


#
#  Suffixes of files which are considered audio filetypes
#
my $FILE_TYPES;






#
#  Return all the files in the given directory.
# Ignore hidden files, and return the list in sorted order.
#
sub filesInDir( $ )
{
    my ($dir) = (@_);
    opendir(DIR, $dir) or warn "Cannot open directory : $dir :$!";
    my @entries = readdir( DIR );
    closedir(DIR);

    my @FOUND = ();

    foreach my $entry ( @entries )
    {
    	# Skip "dotfiles".
	next if ( $entry =~ /^\./ );

	if ( -f $dir . $entry )
	{
	    push @FOUND, $dir . $entry;
	}
    }

    return(sort @FOUND );
}


#
#  Read all non . files in the given directory recursively.
#
#  The returned list will be sorted.
#
sub filesInDirRecursively( $ )
{
    my ($dir) = (@_);
    opendir(DIR, $dir) or warn "Cannot open directory : $dir :$!";
    my @entries = readdir( DIR );
    closedir(DIR);

    my @FOUND = ();

    foreach my $entry ( @entries )
    {
    	# Skip directories beginning with a leading .
	next if ( $entry =~ /^\./ );

	if ( -f $dir . "/" . $entry )
	{
	    push @FOUND, $dir . "/" . $entry;
	}
	elsif ( -d $dir . "/" . $entry )
	{
	    push @FOUND, &filesInDirRecursively( $dir . "/" . $entry );
	}
    }

    return( sort(@FOUND ) );
}


#
#  Read all non . files within directories in the given directory recursively.
#
#  The returned list will be sorted.
#
sub filesInDirsOnlyRecursively( $ )
{
    my ($dir) = (@_);
    opendir(DIR, $dir) or warn "Cannot open directory : $dir :$!";
    my @entries = readdir( DIR );
    closedir(DIR);

    my @FOUND = ();

    foreach my $entry ( @entries )
    {
        # Skip "dotfiles"
        next if ( $entry =~ /^\./ );

        if ( -d $dir . "/" . $entry )
        {
            push @FOUND, &filesInDirRecursively( $dir . $entry );
        }
    }

    return( sort(@FOUND ) );
}


#
#  Return all the directories in the given directory
#
#  The returned list will be sorted.
#
sub dirsInDir( $ )
{
    my ($dir) = (@_);
    opendir(DIR, $dir) or warn "Cannot open directory : $dir :$!";
    my @entries = readdir( DIR );
    closedir(DIR);

    my @FOUND = ();

    foreach my $entry ( @entries )
    {
    	# Skip "dotfiles"
	next if ( $entry =~ /^\./ );
	# Skip mount points
	next if ( $entry =~ /^lost\+found$/ );

	if ( -d $dir . "/" . $entry )
	{
	    push @FOUND, $entry;
	}
    }

    return( sort(@FOUND) );
}


#
#  Return the suffix of a given file, 'undef' if the file has
# no suffix.
#
sub getSuffix( $ )
{
    my ( $file ) = (@_);

    if ( $file =~ /(.*)\.(.*)$/ )
    {
	return $2;
    }
    return undef;
}



#
#  Read and return the contents of a text file.
# (Used for theme files).
#
sub readFile( $ )
{
    my ( $file ) = (@_);
    open( FILE, "<" . $file ) or warn "Cannot open '$file' : $!\n" ;
    my @lines = <FILE>;
    close(FILE);
    return(@lines);
}


#
#  Return the date the given file was last modified.
#
#  Returns in the form eg:  "Saturday 27 September 2003"
#
sub getModifiedDate( $ )
{
  my ( $file ) = ( @_ );

   my @MONTHS = (       "Dummy",
                        "January",
                        "February",
                        "March",
                        "April",
                        "May",
                        "June",
                        "July",
                        "August",
                        "September",
                        "October",
                        "November",
                        "December" );
   my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blks);

   ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blks)= stat($file);

  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
  ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst)= localtime($mtime);
  $year= 1900 + $year;

  return( $mday . " " . $MONTHS[$mon+1] . " " . $year);

}



#
#  Return the modification time of the given file.
#
#
sub getModifiedTime( $ )
{
  my ( $file ) = ( @_ );

  my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blks);

  ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blks)= stat($file);

  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
  ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst)= localtime($mtime);

  my $time = sprintf( "%02d:%02d:%02d", $hour, $min, $sec );
  return( $time );
}


#
#  Process one of our "magic" comments.
#
sub processComment
{
    my ( $line, $file ) = ( @_ );

    my $result = '';

    #
    # Look for lines of the form <!-- foo="bar" -->
    # Where foo is 'exec', 'echo', or 'include' and bar contains
    # the parameters to the command.
    #
    if ( $line =~ /(.*)="(.*)"/ )
    {
        my $action = $1;
        my $params = $2;

        if ( $action eq "echo" )
        {
            if ( $params eq "LAST_MODIFIED" )
            {
                my $timestamp = &getModifiedDate( $file );
                $result = $timestamp;
            }
            else
            {
                $result = "unknown variable $params";
            }
        }
        if ( $action eq "exec" )
        {
            my $output = `$params`;
            $result = $output;
        }
        if ( $action eq "include" )
        {

            #
            # If the include file isn't specified as an absolute
            # path patch it up to be in the same location as the
            # current file.
            #
            if ( ! ( $params =~ /^\/(.*)/ ) )
            {
                if ( $file =~ /(.*)\/(.*)/ )
                {
                    $params = $1 . "/" . $params;
                }
            }

            # If we're including a file make sure we expand that
            # too ..
            my @out = ();
            push @out, &readFileWithExpansion( $params );
            $result = ( join( "\n", @out ) );
        }
    }

    return( $result );
}

#
#  Read a file whilst processing Server Side Include (SSI) features we
# support for including other files, or the output of commands.
#
sub readFileWithExpansion( $ )
{
    my ( $file ) = ( @_ );

    # Read in the file.
    open( TMPL, "<$file" )
	or warn "Cannot read file '$file' - $!";
    my @LINES = <TMPL>;
    close( TMPL );

    #
    # The contents of the file after the macro magic.
    #
    my @CONTENTS = ();

    # Check for magic comments.
    foreach my $line ( @LINES )
    {
	 # If we've got a comment .. 
	 while ( $line =~ /(.*)<!-- (.*) -->(.*)/ )
	 {
	      my $pre = $1;
	      my $com = $2;
	      my $post = $3;

	      $line =  $pre . processComment( $com, $file ) . $post;
	 }

	 push( @CONTENTS, $line );
      }

    return( @CONTENTS );
}



#
# End of module
#
1;
