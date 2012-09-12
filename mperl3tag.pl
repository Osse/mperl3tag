#!/usr/bin/env perl

use strict;
use warnings;

use File::Temp;
use Text::Table;
use MP3::Tag;

use feature 'say';

my @files = getMp3s();
unless (@files) { die "No files found" };

my @tagnames = qw(artist album track title genre year);
my @info;
my @newInfo;

my $pattern = "%a|%l|%n|%t|%g|%y";
my $mp3;

for (my $i = 0; $i < scalar(@files); $i++) {
    $mp3 = MP3::Tag->new($files[$i]);
    $info[$i] = $mp3->autoinfo();
}


my @duplicates = findDuplicates();

my $th = setupTable();
$th->load(@info);
# 
# my $tmpfh = File::Temp->new();
# printTable2();

# system($editor, $tmpfh->filename());

# open FILE, '<', $tmpfh->filename(); 
# while (<FILE>) {
#     push @newInfo, [ split(/\|/, $_) ] ;
# }
#     use Text::TabularDisplay;
#     my $tb2 = Text::TabularDisplay->new( @header );
#     $tb2->populate(\@newInfo);
#     print $tb2->render();

my $editor = $ENV{EDITOR} || $ENV{VISUAL} || "vi";

# --------------------------------------------------

sub getMp3s {
    opendir(my $dir, '.') or die "Could not open directoryn\n";
    my @files = readdir $dir;
    closedir $dir;
    return grep(/\.mp3$/, @files);
}

sub setupTable {
    my $artist = { title => "Artist"};
    my $album  = { title => "Album" };
    my $track  = { title => "Track" };
    my $title  = { title => "Title" };
    my $genre  = { title => "Genre" };
    my $year   = { title => "Year"  };
   return Text::Table->new($artist, \' | ',
                           $album,  \' | ',
                           $track,  \' | ',
                           $title,  \' | ',
                           $genre,  \' | ',
                           $year);
}

# sub printTable {
#     my $fh = shift;
#     print $fh $th->title();
#     print $fh $th->rule("-", "+");
#     print $fh $th->body();
# }
sub printTable2 {
    print $th->title();
    print $th->rule("-", "+");
    print $th->body();
}

sub findDuplicates {
    # @info is an array of hashrefs
    my @keys = keys $info[0];
    # grep { 
    #     for (my $i = 0; $i < scalar(@info) - 1; $i++) {
    #         # I want to remove any keys from @keys if two adjacent
    #         # values in $info are unequal for the same key
    #         $info[$i]{$_} neq $info[$i+1]{$_} 
    #     }
    # } @keys;
    for (@keys) {
        say;
    }
    return @keys;
}
