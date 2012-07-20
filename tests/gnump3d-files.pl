#!/usr/bin/perl -w
#
#  A simple script to auto-generate our file type tests.
#

use strict;
use ConfigFile;

#
#  Read the configuration file.
#
my $config_hash	= ConfigFile::read_config_file("../etc/file.types");
my %hash	= %$config_hash;

#
#  Output the header.
#
print <<E_O_HEADER;
#!/usr/bin/perl -Ilib -w
#
#  Test that our file-type detection works as expected.
#
# Steve
# --
# http://www.steve.org.uk/
#
#



use Test::More qw( no_plan );

#
# Modules we use.
#
BEGIN{ use_ok( 'gnump3d::filetypes' ); }
require_ok( 'gnump3d::filetypess' );

my \$tester = gnump3d::filetypes->new();

# Is it created OK?
ok( defined( \$tester ), "Created OK" );

# Is it the correct type?
isa_ok( \$tester, "gnump3d::filetypes" );


E_O_HEADER

#
#  Output the tests.
#
foreach my $key ( keys ( %hash ) )
{
    if ( $config_hash->{$key} eq "audio" )
    {
	print "is( \$tester->isAudio( \"t.$key\" ), 1, \" .$key files are audio.\" );\n";
	print "is( \$tester->isMovie( \"t.$key\" ), 0, \" .$key files are not movies.\" );\n";
	print "is( \$tester->isPlaylist( \"t.$key\" ), 0, \" .$key files are not playlists.\" );\n";
    }
    elsif ( $config_hash->{$key} eq "movie" )
    {
	print "is( \$tester->isAudio( \"t.$key\" ), 0, \" .$key files are not audio.\" );\n";
	print "is( \$tester->isMovie( \"t.$key\" ), 1, \" .$key files are movies.\" );\n";
	print "is( \$tester->isPlaylist( \"t.$key\" ), 0, \" .$key files are not playlists.\" );\n";
    }
    elsif ( $config_hash->{$key} eq "playlist" )
    {
	print "is( \$tester->isAudio( \"t.$key\" ), 0, \" .$key files are not audio.\" );\n";
	print "is( \$tester->isMovie( \"t.$key\" ), 0, \" .$key files are not movies.\" );\n";
	print "is( \$tester->isPlaylist( \"t.$key\" ), 1, \" .$key files are playlists.\" );\n";
    }
    else
    {
	print "File type : '$key' - unknown type\n";
    }
}


#
#  All done
#
