# this really isn't a perl module so much as shared subroutines.
# These read in the file tags and perform unmentionables.

package main;

use strict;

use gnump3d::ogginfo;              # Pure Perl OGG Vorbis tag parsing.
use gnump3d::mp3info;	           # Local copy of MP3::Info.
use gnump3d::mp4info;              # Local copy of MP4::Info.
use gnump3d::WMA;                  # Local copy of Audio::WMA

use vars qw(@ISA @EXPORT);

@ISA = 'Exporter';
@EXPORT = qw(getMP3Display getMP4Display getWMADisplay getOggDisplay getTags);


#
#  Get the meta tags from an MP3 file.
#
sub getMP3Display
{
    my ( $file ) = (@_);

    my %TAGS;

    #
    # MPEG file information - get this regardless
    # of the presence of an ID3 tag or not.
    #
    my $inf         = &get_mp3info( $file );
    $TAGS{'LENGTH'} = $inf->{TIME}     || "";
    $TAGS{'BITRATE'}= $inf->{BITRATE}  || "";
    $TAGS{'SIZE'}   = $inf->{SIZE}     || "";


    #
    # Now look for tag information.
    #
    my $tag = &get_mp3tag( $file );

    # Early termination.
    if ( not defined $tag )
    {
        return( %TAGS );
    }


    #
    #  We have some tags .. so store them
    #
    $TAGS{'ARTIST'} = $tag->{ARTIST}   || "";
    $TAGS{'TITLE'}  = $tag->{TITLE}    || "";
    $TAGS{'ALBUM'}  = $tag->{ALBUM}    || "";
    $TAGS{'YEAR'}   = $tag->{YEAR}     || "";
    $TAGS{'COMMENT'}= $tag->{COMMENT}  || "";
    $TAGS{'TRACK'}  = $tag->{TRACKNUM} || "";
    $TAGS{'GENRE'}  = $tag->{GENRE}    || "";


    return( %TAGS );
}


#
#  Get the meta tags from an MP4 file.
#
sub getMP4Display
{
    my ( $file ) = (@_);

    my %TAGS;

    #
    # MPEG file information - get this regardless
    # of the presence of an ID3 tag or not.
    #
    my $inf         = &get_mp4info( $file );
    $TAGS{'LENGTH'} = $inf->{TIME}     || "";
    $TAGS{'BITRATE'}= $inf->{BITRATE}  || "";
    $TAGS{'SIZE'}   = $inf->{SIZE}     || "";


    #
    # Now look for tag information.
    #
    my $tag = &get_mp4tag( $file );

    # Early termination.
    return( %TAGS ) if ( not defined $tag );


    #
    #  We have some tags .. so store them
    #
    $TAGS{'ARTIST'} = $tag->{ART}     || "";
    $TAGS{'TITLE'}  = $tag->{NAM}     || "";
    $TAGS{'ALBUM'}  = $tag->{ALB}     || "";
    $TAGS{'YEAR'}   = $tag->{DAY}     || "";
    $TAGS{'COMMENT'}= $tag->{CMT}     || "";
    $TAGS{'TRACK'}  = $tag->{TRKN}[0] || "";
    $TAGS{'GENRE'}  = $tag->{GENRE}   || "";

    return( %TAGS );
}



#
#  Get the meta tags from an WMA file.
#
sub getWMADisplay
{
    my ( $file ) = (@_);

    # Convert all WMA tags to UTF8
    gnump3d::WMA->setConvertTagsToUTF8( 1 );

    my $wma = gnump3d::WMA->new( $file );

    my %TAGS;

    #
    # Get the WMA file information
    #
    my $inf         = $wma->info();
    $TAGS{'LENGTH'} = $inf->{playtime_seconds} || "";
    $TAGS{'BITRATE'}= $inf->{bitrate}          || "";
    $TAGS{'SIZE'}   = $inf->{filesize}         || "";

    #
    # Now look for tag information.
    #
    my $tag = $wma->tags();

    # Early termination.
    return( %TAGS ) if ( not defined $tag );

    #
    #  We have some tags .. so store them
    #
    $TAGS{'ARTIST'} = $tag->{AUTHOR}      || "";
    $TAGS{'TITLE'}  = $tag->{TITLE}       || "";
    $TAGS{'ALBUM'}  = $tag->{ALBUMTITLE}  || "";
    $TAGS{'YEAR'}   = $tag->{YEAR}        || "";
    $TAGS{'COMMENT'}= $tag->{DESCRIPTION} || "";
    $TAGS{'TRACK'}  = $tag->{TRACKNUMBER} || "";
    $TAGS{'GENRE'}  = $tag->{GENRE}       || "";


    return( %TAGS );
}


#
#  Get the display text for an OGG Vorbis file.
#
sub getOGGDisplay
{
    my ($file) = (@_);

    my $reader = gnump3d::ogginfo->new($file);
    my %TAGS;

    # info
    while (my ($key, $v) = each %{$reader->info})
    {
      $TAGS{uc($key)} = $v;
    }

    my %tags;
    foreach my $ckey ( $reader->comment_tags() )
    {
      $tags{lc($ckey)} = ($reader->comment( $ckey ))[0];
    }

    if ( keys( %tags ) )
    {
        $TAGS{'ARTIST'}  = $tags{'artist'}      || "";
        $TAGS{'COMMENT'} = $tags{'comment'}     || "";
        $TAGS{'GENRE'}   = $tags{'genre'}       || "";
        $TAGS{'TRACK'}   = $tags{'tracknumber'} || "";
        $TAGS{'ALBUM'}   = $tags{'album'}       || "";
        $TAGS{'TITLE'}   = $tags{'title'}       || "";
        $TAGS{'YEAR'}    = $tags{'date'}        || "";
        $TAGS{'SIZE'}    = $tags{'size'}        || "";
        if ($TAGS{'LENGTH'}) # Ogg returns in sss format vice mm:ss
        {
            my $s = $TAGS{'LENGTH'} % 60;
            my $m = ($TAGS{'LENGTH'} - $s) / 60;
            $TAGS{'LENGTH'} = sprintf("%d:%02d", $m, $s);
        }

     }

    return( %TAGS );
}


#
#  Get the tags of a file.
#
sub getTags
{
    my ($file) = (@_);
    my %TAGS;

    my $filename = $file;

    # Just store the filename.
    if ( $filename =~ /(.*)[\/\\](.*)/ )
    {
        $filename = $2;
    }

    # strip suffix.
    if ( $filename =~ /(.*)\.([^\.]+)$/ )
    {
        $filename = $1;
    }

    # Figure out the mtime if possible.
    my @fstat;
    if( -l $file ) 
    {  # $file is a link
        @fstat = lstat( $file )
    } else
    {
        @fstat = stat( $file );
    }

    if ( ( $file =~ /\.mp3$/i ) || ( $file =~ /\.aiff?$/i ) )
    {
        %TAGS = &getMP3Display($file);
    }
    elsif( $file =~ /\.(mp4|m4a|aac)$/i )
    {
        %TAGS = &getMP4Display($file);
    }
    elsif( $file =~ /\.wma$/i )
    {
        %TAGS = &getWMADisplay($file);
    }
    elsif( $file =~ /ogg$/i )
    {
        %TAGS = &getOGGDisplay($file);
        $TAGS{'SIZE'} = $fstat[7] unless $TAGS{'SIZE'};
    }

    $TAGS{'MTIME'}    = $fstat[9];
    $TAGS{'FILENAME'} = $filename;

    return (%TAGS);
}

#
# End of module
#
1;
