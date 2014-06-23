#!/usr/bin/env perl

use strict;
use warnings;

# Includes
use JSON;
use Math::Round;

# My variables
my $AMIXER="/usr/bin/amixer";
my $CAPTURE_VOLUME="numid=1,iface=MIXER,name='Capture Switch'";
my $CAPTURE_MUTE="numid=2,iface=MIXER,name='Capture Switch'";
my $statusCapture = "\x{f130}";
my $statusMute = "\x{f131}";
my $muteColor = "#FFFF00";


# Find microphone status
my ($mmin, $mmax, $mute, $unused) = get_mixer_value($CAPTURE_MUTE);
my ($vmin, $vmax, $vleft, $vright) = get_mixer_value($CAPTURE_VOLUME);
my $volume = nearest(1, ((($vleft + $vright)/2)/$vmax*100));
my @micBlock;

# Build the microphone block
if($mute == 0) {
    @micBlock = ({
        color => "$muteColor",
        name => 'microphone',
        full_text => "$statusMute $volume%"
    });
} else {
    @micBlock = ({ 
        name => 'microphone',
        full_text => "$statusCapture $volume%"
    });
}  

print encode_json(\@micBlock) . "\n";


sub get_mixer_value
{
    my ($control)=@_;
    return undef unless defined($control);

    my $MIXER;
    open($MIXER, "$AMIXER cget $control|") or 
    do { warn "Cannot run $MIXER!\n";  return undef; }; 
    my ($min, $max, $left, $right);

    while(<$MIXER>)
    {
        # Boolean
        if (/^\s*:.*values=on/)            { $left=1; $min=0; $max=1; }
        if (/^\s*:.*values=off/)           { $left=0; $min=0; $max=1; }
                                     
        # Integer
        if (/^\s*;.*min=(\d+)/)            { $min=$1; }
        if (/^\s*;.*max=(\d+)/)            { $max=$1; }
        if (/^\s*:.*values=(\d+),(\d+)/)   { ($left,$right)=($1,$2); next; }
        if (/^\s*:.*values=(\d+)/)         { ($left)=($1); next; }
    }  
                                                                                                 
    close($MIXER);
    
    return ($min, $max, $left, $right);
}
