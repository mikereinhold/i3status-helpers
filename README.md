# i3status-helpers
This is a collection of scripts which I use in my Funtoo Linux system for improving the utility of the i3status bar (http://i3wm.org/i3status/) for the i3 window manager (http://i3wm.org/).

Though these instructions are specific to Funtoo, the general process should work on any distro.

## Prerequisites
This assumes that you are using i3status to output your system information and already have it installed and working. Additionally this assumes that you have working unicode support in your system.

The microphone status script (status-mic.pl) uses amixer to retrieve the Capture mixer status from ALSA. So clearly, you need ALSA and amixer present on your system. This does not preclude the use of PulseAudio as your primary means of controlling your audio input and output, just that ALSA must be present and working. 

### FontAwesome
To really make i3status have a nice effect for volume and microphone control, you'll want to use FontAwesome (https://fortawesome.github.io/Font-Awesome/).

If FontAwesome is in your distro's package manager, then just go ahead and install it from there. Otherwise, download the font from the FontAwesome website and copy the fontawesome-webfont.ttf to a new folder in /usr/share/fonts. For example: /usr/share/fonts/fontawesome/fontawesome-webfont.ttf. If you can see the FontAwesome icons in the config file entries later on in this file, then you know you have FontAwesome installed correctly!

If you don't want to use FontAwesome, that's ok I guess - just be sure to change the icon codes to something else, otherwise you'll just get a nice little rectangle in your status bar.

### Perl Math::Round
You'll need the Perl Math::Round module. Retrieve it from your distro's package manager or via cpan.

## Configure i3 and i3status
You'll want to configure i3 and i3status to take full advantage of the helper scripts and FontAwesome. You can configure (or not configure) the FontAwesome pieces independently.

### Update i3status.conf
Make sure that your output_format is set to "i3bar" so that i3status output JSON instead of plain text. You need JSON output in order for the helper scripts to function properly. There is no harm in setting the i3bar output format, even if you're only going to use FontAwesome and you skip the other scripts.

You probably want color enabled as well:
```
general {
    output_format = "i3bar"
    colors = true
    interval = 5
}
```

Configure your volume master block as you desire:

```
volume master {
    format = " %volume"
    format_muted = " %volume"
    device = "default"
    mixer = "Master"
    mixer_idx = 0
}
```
### Retrieve the i3status-helpers from this repo
cd ~
mkdir -p scripts/status
git clone git@github.com:mikereinhold/i3status-helpers.git scripts/status

### Update ~/.i3/config
Make sure that you update your i3 config to use the new status script. Adjust as necessary to match your system or checkout directory.

```
bar {
    # Use i3status with the custom status helpers
    status_command i3status | ~/scripts/status/status.pl

    # Configure the tray to go on the primary monitor
    tray_output eDP1
}
```

### status.pl
Status.pl was an example wrapper for i3status written by Michael Stapelberg. This is a slight modification that also calls my other i3status helpers:

* status-mic.pl - Microphone status using the ALSA Capture mixer

One day I'll make this so you can pass options to enable or disable helpers, maybe even add a config file. For now, just uncommend any of the info blocks that you don't want

### status-mic.pl
Loosely based on Ewen McNeill's ALSA Volume script, but greatly simplified as it only reads the Capture mixer fields.

Adjust the output fields for the microphone display as you desire. Key variables to update are:
* statusCapture - the string displayed before the volume when the Capture mixer is enabled. The default is FontAwesome &xf130 - microphone ()
* statusMute - the string displayed before the volume when the Capture mixer is muted. The default is FontAwesome &xf131 - microphone slash ()
* muteColor - the color code to send to i3bar when the Capture mixer is muted. The default is #FFFF00 (same as the default i3status volume color)

## Reload i3
Reload your i3 config (default binding is $mod+Shift+R) or restart i3 to see the effect!
