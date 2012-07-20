#!/usr/bin/perl -Ilib -w
#
#  Test that our HTTP Request Parsing library works as expected.
#
# Steve
# --
# http://www.steve.org.uk/
#
# $Id: gnump3d-request.t,v 1.4 2006/01/24 10:40:36 skx Exp $
#



use Test::More qw( no_plan );

#
# Our copy of the MD5 implementation.
#
BEGIN{ use_ok( 'gnump3d::Request' ); }
require_ok( 'gnump3d::Request' );


#
#  Read in the sample data we will test against.
#
my $SAMPLE = "";
while( <DATA> )
{
    $SAMPLE .= $_;
}


#
#  Create the request parser.
#
my $request = gnump3d::Request->new( request => $SAMPLE );

# Is it created OK?
ok( defined( $request ), "Created OK" );

# Is it the correct type?
isa_ok( $request, "gnump3d::Request" );

#
# Now test the values
#

# Request path
is( $request->getRequest(), "/", " The incoming request was correct" );

# User-Agent
is( $request->getUserAgent(), "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)", " The incoming user-agent was correct" );

# Referer
is( $request->getReferer(), "", " The incoming HTTP-Referer was correct" );

# Languages
my @langs = $request->getLanguage();

is( $#langs, 1, " We got the correct number of languages" );
is( $langs[0], "en", " Primary language is English." );
is( $langs[1], "de", " Secondary language is German." );

__DATA__
GET /?foo=bar HTTP/1.1
Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/msword, application/vnd.ms-powerpoint, */*
Accept-Language: en-gb, de-us
Accept-Encoding: gzip, deflate
User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)
Connection: Keep-Alive


