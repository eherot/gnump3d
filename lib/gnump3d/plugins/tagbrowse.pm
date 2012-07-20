#!/usr/bin/perl -w

#
#  The package this module is implementing.
#
package plugins::tagbrowse;


#
#  Register the plugin.
#
::register_plugin("plugins::tagbrowse");


#
#  Minimal constructor.
#
sub new { return bless {}; }




use gnump3d::tagcache;


#
#  The path we handle.
#
my $plugin = '/tagbrowse/';



#
#  Return the author of this plugin.
#
sub getAuthor
{
    return( 'Adam Di Carlo <aph@debian.org>' );
}


#
#  Return the version of this plugin.
#
sub getVersion
{
    my $REVISION      = '$Id: tagbrowse.pm,v 1.6 2005/12/05 23:23:31 skx Exp $';
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

    if ( $path =~ /^\/tagbrowse\/*/i )
    {
	return 1;
    }

    return 0;
}



#
# fill in the template with a given title and content
#
sub _fillTagBrowseTemplate
{
    my ( $class, $title, $content ) = ( @_ );

package main;

    my @template = &getThemeFile( $ARGUMENTS{'theme'}, "tagbrowse.html" );

    my $text = "";
    foreach my $line ( @template )
    {
        #
        # Make global substitutions.
        #
        $line =~ s/\$HEADER//g;
        $line =~ s/\$HOSTNAME/$host/g;
        $line =~ s/\$VERSION/$VERSION/g;
        $line =~ s/\$RELEASE/$RELEASE/g;
        $line =~ s/\$DIRECTORY/\/random\//g;
	$line =~ s/\$META/$meta_tags/g;
        $line =~ s/\$TITLE/$title/g;

        #
        # Now handle the special sections.
        #
        if ( $line =~ /(.*)\$BANNER(.*)/ )
        {
            # Insert banner;
            my $pre  = $1;
            my $post = $2;

            $text .= $pre;
            $text .= &getBanner( "/tagbrowse/" );
            $text .= $post;
        }
        elsif ( $line =~ /\$RESULTS/ )
        {
            $text .= $content;
        }
        else
        {
            $text .= $line;
        }
    }
    &sendData( $data, $text );
    close( $data );
}

#
# top level options, how we can browse
#
sub _sendTagBrowseTop 
{
    my ( $class ) = ( @_ );

package main;

    $class->_fillTagBrowseTemplate("Browse Archive", 
      "<tr><td colspan=3 align='left'><a href='" . $plugin . "artist'>Browse by artist</a></td></tr>
       <tr><td colspan=3 align='left'><a href='" . $plugin . "album'>Browse by album</a></td></tr>
       <tr><td colspan=3 align='left'><a href='" . $plugin . "year'>Browse by year</a></td></tr>
       <tr><td colspan=3 align='left'><a href='" . $plugin . "genre'>Browse by genre</a></td></tr>");
}


#
# show the entire set of a given type of data, e.g., artist
#
sub _AllOfAType
{
    my ($class,$rectype) = (@_);

package main;

    my $rectag = uc $rectype;
    my $recurl = $plugin . $rectype;

    my %items;

    open( FILY, "<$tag_cache" );
    foreach (<FILY>) {
        if ( /\t$rectag=([^\t]*)/ and $1 )
        {
            #
            # we've seen this item before
            # (theoretically there should be only 1 match)
            #
            my @matches = grep(/^(The *)?\Q$1\E/i, keys %items);
            if ( @matches )
            {
                # increment the counter
                $items{ $matches[0] } ++;
            }
            else
            {
                $items{ $1 } = 1;
            }
        }
    }
    close( FILY );

    my $content;
    foreach my $item (sort{ uc($a) cmp uc($b) } keys %items) {
        my $itemurl = &urlEncode( $item );
        $content .= "<tr><td colspan=2 align='left'><a href='$recurl/$itemurl'>$item</a></td><td>$items{$item} songs</td></tr>\n";
    }
    
    $class->_fillTagBrowseTemplate("Browsing all " . $rectype . "s",
                          $content);

    1;
}

sub _FilesOfAType
{
    my ($class, $rectype, $one) = (@_);

package main;

    my $rectag = uc $rectype;
    my $files = [];

    open( FILY, "<$tag_cache" );
    foreach (<FILY>) {
        if ( /\t$rectag=(\Q$one\E)/ ) {
            my $file;
            ($file = $_) =~ s/\t.*$//;
            chomp($file);
            push(@$files, $file);
        }
    }
    return $files;
}

sub _OneOfAType
{
    my ($class,$rectype, $one) = (@_);

package main;

    my $typeurl = $plugin . $rectype;
    $one = urlDecode($one);
    
    my $files = $class->_FilesOfAType($rectype, $one);

    my $sort_order = &getConfig( "sort_order", '$FILENAME' );
    my $sorter = gnump3d::sorting->new( );
    $sorter->setTagCache( $tagCache );
    print "Set cache to : $tagCache\n";
    my @FULLNAMES = &sortFiles( $sort_order, @{$files} );

    my $filelist = formatFileListOutput( @FULLNAMES );

    $class->_fillTagBrowseTemplate("Browsing  $rectype '$one'",
                          $filelist);
}

#
#  Handle requests to this plugin.
#
sub handlePath
{
    my ( $class, $uri ) = (@_);

package main;

    my $header = &getHTTPHeader( 200, "text/html" );
    &sendData( $data, $header );
    if ( $uri eq $plugin or $uri eq substr($plugin, 0, -1) ) 
    {
        $class->_sendTagBrowseTop();
    } 
    elsif ( $uri =~ m@$plugin(year|artist|title|album|genre)/?$@ ) 
    {
        $class->_AllOfAType($1);
    } 
    elsif ( $uri =~ m@$plugin(year|artist|title|album|genre)/(.*)@ ) 
    {
        $class->_OneOfAType($1, $2);
    } 
    else 
    {
        my $output = "<i>We were called with the URL </i><code>$uri</code>";
        &sendData( $data, $output );
    }
    return 1;
}

# Perl modules must finish with this line...
1;

