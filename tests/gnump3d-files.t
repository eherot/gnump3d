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

my $tester = gnump3d::filetypes->new();

# Is it created OK?
ok( defined( $tester ), "Created OK" );

# Is it the correct type?
isa_ok( $tester, "gnump3d::filetypes" );


is( $tester->isAudio( "t.ape" ), 1, " .ape files are audio." );
is( $tester->isMovie( "t.ape" ), 0, " .ape files are not movies." );
is( $tester->isPlaylist( "t.ape" ), 0, " .ape files are not playlists." );
is( $tester->isAudio( "t.m4a" ), 1, " .m4a files are audio." );
is( $tester->isMovie( "t.m4a" ), 0, " .m4a files are not movies." );
is( $tester->isPlaylist( "t.m4a" ), 0, " .m4a files are not playlists." );
is( $tester->isAudio( "t.wma" ), 1, " .wma files are audio." );
is( $tester->isMovie( "t.wma" ), 0, " .wma files are not movies." );
is( $tester->isPlaylist( "t.wma" ), 0, " .wma files are not playlists." );
is( $tester->isAudio( "t.far" ), 1, " .far files are audio." );
is( $tester->isMovie( "t.far" ), 0, " .far files are not movies." );
is( $tester->isPlaylist( "t.far" ), 0, " .far files are not playlists." );
is( $tester->isAudio( "t.m4p" ), 1, " .m4p files are audio." );
is( $tester->isMovie( "t.m4p" ), 0, " .m4p files are not movies." );
is( $tester->isPlaylist( "t.m4p" ), 0, " .m4p files are not playlists." );
is( $tester->isAudio( "t.ra" ), 1, " .ra files are audio." );
is( $tester->isMovie( "t.ra" ), 0, " .ra files are not movies." );
is( $tester->isPlaylist( "t.ra" ), 0, " .ra files are not playlists." );
is( $tester->isAudio( "t.stm" ), 1, " .stm files are audio." );
is( $tester->isMovie( "t.stm" ), 0, " .stm files are not movies." );
is( $tester->isPlaylist( "t.stm" ), 0, " .stm files are not playlists." );
is( $tester->isAudio( "t.aac" ), 1, " .aac files are audio." );
is( $tester->isMovie( "t.aac" ), 0, " .aac files are not movies." );
is( $tester->isPlaylist( "t.aac" ), 0, " .aac files are not playlists." );
is( $tester->isAudio( "t.wav" ), 1, " .wav files are audio." );
is( $tester->isMovie( "t.wav" ), 0, " .wav files are not movies." );
is( $tester->isPlaylist( "t.wav" ), 0, " .wav files are not playlists." );
is( $tester->isAudio( "t.mp3" ), 1, " .mp3 files are audio." );
is( $tester->isMovie( "t.mp3" ), 0, " .mp3 files are not movies." );
is( $tester->isPlaylist( "t.mp3" ), 0, " .mp3 files are not playlists." );
is( $tester->isAudio( "t.m3u" ), 0, " .m3u files are not audio." );
is( $tester->isMovie( "t.m3u" ), 0, " .m3u files are not movies." );
is( $tester->isPlaylist( "t.m3u" ), 1, " .m3u files are playlists." );
is( $tester->isAudio( "t.mov" ), 0, " .mov files are not audio." );
is( $tester->isMovie( "t.mov" ), 1, " .mov files are movies." );
is( $tester->isPlaylist( "t.mov" ), 0, " .mov files are not playlists." );
is( $tester->isAudio( "t.ogg" ), 1, " .ogg files are audio." );
is( $tester->isMovie( "t.ogg" ), 0, " .ogg files are not movies." );
is( $tester->isPlaylist( "t.ogg" ), 0, " .ogg files are not playlists." );
is( $tester->isAudio( "t.aif" ), 1, " .aif files are audio." );
is( $tester->isMovie( "t.aif" ), 0, " .aif files are not movies." );
is( $tester->isPlaylist( "t.aif" ), 0, " .aif files are not playlists." );
is( $tester->isAudio( "t.avi" ), 0, " .avi files are not audio." );
is( $tester->isMovie( "t.avi" ), 1, " .avi files are movies." );
is( $tester->isPlaylist( "t.avi" ), 0, " .avi files are not playlists." );
is( $tester->isAudio( "t.ram" ), 0, " .ram files are not audio." );
is( $tester->isMovie( "t.ram" ), 0, " .ram files are not movies." );
is( $tester->isPlaylist( "t.ram" ), 1, " .ram files are playlists." );
is( $tester->isAudio( "t.669" ), 1, " .669 files are audio." );
is( $tester->isMovie( "t.669" ), 0, " .669 files are not movies." );
is( $tester->isPlaylist( "t.669" ), 0, " .669 files are not playlists." );
is( $tester->isAudio( "t.flac" ), 1, " .flac files are audio." );
is( $tester->isMovie( "t.flac" ), 0, " .flac files are not movies." );
is( $tester->isPlaylist( "t.flac" ), 0, " .flac files are not playlists." );
is( $tester->isAudio( "t.mpeg" ), 0, " .mpeg files are not audio." );
is( $tester->isMovie( "t.mpeg" ), 1, " .mpeg files are movies." );
is( $tester->isPlaylist( "t.mpeg" ), 0, " .mpeg files are not playlists." );
is( $tester->isAudio( "t.mid" ), 1, " .mid files are audio." );
is( $tester->isMovie( "t.mid" ), 0, " .mid files are not movies." );
is( $tester->isPlaylist( "t.mid" ), 0, " .mid files are not playlists." );
is( $tester->isAudio( "t.shn" ), 1, " .shn files are audio." );
is( $tester->isMovie( "t.shn" ), 0, " .shn files are not movies." );
is( $tester->isPlaylist( "t.shn" ), 0, " .shn files are not playlists." );
is( $tester->isAudio( "t.wmv" ), 0, " .wmv files are not audio." );
is( $tester->isMovie( "t.wmv" ), 1, " .wmv files are movies." );
is( $tester->isPlaylist( "t.wmv" ), 0, " .wmv files are not playlists." );
is( $tester->isAudio( "t.aiff" ), 1, " .aiff files are audio." );
is( $tester->isMovie( "t.aiff" ), 0, " .aiff files are not movies." );
is( $tester->isPlaylist( "t.aiff" ), 0, " .aiff files are not playlists." );
is( $tester->isAudio( "t.dsm" ), 1, " .dsm files are audio." );
is( $tester->isMovie( "t.dsm" ), 0, " .dsm files are not movies." );
is( $tester->isPlaylist( "t.dsm" ), 0, " .dsm files are not playlists." );
is( $tester->isAudio( "t.xm" ), 1, " .xm files are audio." );
is( $tester->isMovie( "t.xm" ), 0, " .xm files are not movies." );
is( $tester->isPlaylist( "t.xm" ), 0, " .xm files are not playlists." );
is( $tester->isAudio( "t.rm" ), 1, " .rm files are audio." );
is( $tester->isMovie( "t.rm" ), 0, " .rm files are not movies." );
is( $tester->isPlaylist( "t.rm" ), 0, " .rm files are not playlists." );
is( $tester->isAudio( "t.it" ), 1, " .it files are audio." );
is( $tester->isMovie( "t.it" ), 0, " .it files are not movies." );
is( $tester->isPlaylist( "t.it" ), 0, " .it files are not playlists." );
is( $tester->isAudio( "t.mpg" ), 0, " .mpg files are not audio." );
is( $tester->isMovie( "t.mpg" ), 1, " .mpg files are movies." );
is( $tester->isPlaylist( "t.mpg" ), 0, " .mpg files are not playlists." );
is( $tester->isAudio( "t.pls" ), 0, " .pls files are not audio." );
is( $tester->isMovie( "t.pls" ), 0, " .pls files are not movies." );
is( $tester->isPlaylist( "t.pls" ), 1, " .pls files are playlists." );
is( $tester->isAudio( "t.mtm" ), 1, " .mtm files are audio." );
is( $tester->isMovie( "t.mtm" ), 0, " .mtm files are not movies." );
is( $tester->isPlaylist( "t.mtm" ), 0, " .mtm files are not playlists." );
is( $tester->isAudio( "t.mpc" ), 1, " .mpc files are audio." );
is( $tester->isMovie( "t.mpc" ), 0, " .mpc files are not movies." );
is( $tester->isPlaylist( "t.mpc" ), 0, " .mpc files are not playlists." );
is( $tester->isAudio( "t.s3m" ), 1, " .s3m files are audio." );
is( $tester->isMovie( "t.s3m" ), 0, " .s3m files are not movies." );
is( $tester->isPlaylist( "t.s3m" ), 0, " .s3m files are not playlists." );
is( $tester->isAudio( "t.ult" ), 1, " .ult files are audio." );
is( $tester->isMovie( "t.ult" ), 0, " .ult files are not movies." );
is( $tester->isPlaylist( "t.ult" ), 0, " .ult files are not playlists." );
is( $tester->isAudio( "t.mod" ), 1, " .mod files are audio." );
is( $tester->isMovie( "t.mod" ), 0, " .mod files are not movies." );
is( $tester->isPlaylist( "t.mod" ), 0, " .mod files are not playlists." );
