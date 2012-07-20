# -*- cperl -*- #

=head1 NAME

gnump3d::Request - An object for parsing an Incoming HTTP Reqest

=head1 SYNOPSIS

=for example begin

    #!/usr/bin/perl -w

    use gnump3d::Request;
    use strict;

    my $reqest= gnump3d::Request->new( request -> "GET / ..." );

    # Hash of CGI arguments + values
    my %args	= $request->getArgs();

    # Hash of cookie values
    my %cookies	= $request->getCookies();

=for example end


=head1 DESCRIPTION

This module allows a simplistic parsing of an incoming HTTP-Request.

The parsing allows the returning of various fields such as the
incoming request, the cookies sent, CGI-arguments, and more.

=cut


package gnump3d::Request;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
@EXPORT = qw();

($VERSION)       = '$Revision: 1.6 $' =~ m/Revision:\s*(\S+)/;


#
#  Standard modules which we require.
#
use strict;
use warnings;



=head2 new

  Create a new instance of this object.

  Allow the supplied hash to override any values we might have.

=cut

sub new
{
    my ( $proto, %supplied ) = (@_);
    my $class = ref($proto) || $proto;

    my $self  = {};

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



=head2 getRequest

  Find and return the requested path from the request.

=cut

sub getRequest
{
    my ( $class ) = ( @_ );

    #
    #  If we have a cached value, return it.
    #
    if ( defined( $class->{'uri'} ) )
    {
	return( $class->{'uri'} );
    }


    #
    # Get the text we were constructed with.
    #
    my $request = $class->{'request'};
    die "No request" unless( $request );


    my $uri = "";
    if ( $request =~ /GET (.*) HTTP\// )
    {
	$uri = $1;
    }

    #
    # Store in cache, and return result.
    #
    $class->{'uri'} = $uri;
    return( $uri );
}



=head2 getUserAgent

  Find and return the user-agent which made the request.

=cut

sub getUserAgent
{
    my ( $class ) = ( @_ );

    #
    #  If we have a cached value, return it.
    #
    if ( defined( $class->{'agent'} ) )
    {
	return( $class->{'agent'} );
    }


    #
    # Get the text we were constructed with.
    #
    my $request = $class->{'request'};
    die "No request" unless( $request );


    my $agent = "";
    if ( $request =~ /User-Agent: ([^\r\n]+)/ )
    {
	$agent = $1;
    }

    #
    # Store in cache, and return result.
    #
    $class->{'agent'} = $agent;
    return( $agent );
}



=head2 getReferer

  Find and return the HTTP-Referer string.

=cut

sub getReferer
{
    my ( $class ) = ( @_ );

    #
    #  If we have a cached value, return it.
    #
    if ( defined( $class->{'referer'} ) )
    {
	return( $class->{'referer'} );
    }


    #
    # Get the text we were constructed with.
    #
    my $request = $class->{'request'};
    die "No request" unless( $request );


    my $refer = "";
    if ( $request =~ /Referrer: ([^\r\n]+)/ )
    {
	$refer = $1;
    }

    #
    # Store in cache, and return result.
    #
    $class->{'referer'} = $refer;
    return( $refer );
}



=head2 getLanguage

  Get the requested language

=cut

sub getLanguage
{
    my ( $class ) = ( @_ );

    #
    #  If we have a cached value, return it.
    #
    if ( defined( $class->{'language'} ) )
    {
	return( $class->{'language'} );
    }


    #
    # Get the text we were constructed with.
    #
    my $request = $class->{'request'};
    die "No request" unless( $request );


    my @languages ;

    if ( $request =~ /Accept-Language: ([^\r\n]+)/ )
    {
	my $available = $1;

	my @langs = split( /,/, $available );
	foreach my $lang ( @langs )
	{
	    if ( $lang =~ /([^-]+)-(.*)/ )
	    {
		my $primary   = $1;
		my $secondary = $2;

		# Strip leading and trailing whitespace.
		$primary =~ s/^\s+//;
		$primary =~ s/\s+$//;
		
		if ( $primary =~ /([a-zA-Z])/ )
		{
		    push @languages, lc( $primary );
		}
	    }
	}
    }

    #
    # Store in cache, and return result.
    #
    $class->{'language'} = @languages;
    return( @languages );
}

1;


=head1 AUTHOR

Steve Kemp

http://www.steve.org.uk/



=head1 LICENSE

Copyright (c) 2005 by Steve Kemp.  All rights reserved.

This module is free software;
you can redistribute it and/or modify it under the terms of the GNU General
Public License.

=cut
