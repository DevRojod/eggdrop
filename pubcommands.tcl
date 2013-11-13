
##############################################################################################################
######################### IRCguard Channel Settings Public Commands Version 2.0 By B0gdaN ####################
# Eggdrop TCL Script: [IRCguard Tools] Copyright (C) 2003-2004 IRCguard Productions.
# This software is free under the terms of GNU GPL 2.
# HomePage: http://www.IRCguard.tk/
# E-MAIL: B0gdaN@Undernet.ro 
# A complete channel settings public commands for Eggdrop v1.6.x or higher.
# Short descriptions of commands is available before each procedure.
# To change the setting for your channel just tipe in channel <<.seen on>> to set +seen and <<.seen off>> to 
# set -seen for channel.
# Now you can add more channel settings!!!Example:if you are using the Next script just add <<next>> in mods list
# and you can set +next or -next for your channel like with a public command->.next on or .next off
# To install it just place the tcl file in your bot scripts director and creat this line in your bot config file 
#" source scripts/pubsettings.tcl " 
# Rstart your bot and enjoy!
# 
###################################################SETTINGS###################################################

#
##Here You can add more channel settings:
#
set mods "autoop autohalfop autovoice protectops protecthalfops protectfriends dontkickops revenge revengebot statuslog seen shared greet nodesynch userbans dynamicbans enforcebans inactive bitch secret cycle bitch"

#
##Here you can add more channel modes:
#
set modss "flood-chan flood-nick flood-ctcp flood-deop flood-kick flood-join aop-delay ban-time"

#
#Here you can change the prefix of your command
#
set cmdpfix "."

#
## Don't edit past here unless you know TCL! 
#

####################################################BINDS######################################################

foreach modd [string tolower $modss] { bind pub n|n ${cmdpfix}$modd pub_fst }
foreach mod [string tolower $mods] { bind pub n|n ${cmdpfix}$mod pub_cst }

proc pub_fst {nick host hand chan args} {
	global botnick lastbind cmdpfix
	if {[llength [split $args]] < 1} {
	notice $nick "Usage: $lastbind < \002number\002 / \002seconds\002 >"
	return 0 }
	set args [lindex $args 0]
	set args [split $args]
	set mode [string tolower [lindex $args 0]]
        set stat [string tolower [lindex [split $lastbind "$cmdpfix"] 1]]
        channel set $chan $stat $mode
	notice $nick "$stat mode $chan is now \002$mode\002."  
	putcmdlog "<<$nick>> !$hand! set $stat for $chan $mode" }

proc pub_cst {nick host hand chan args} {
	global botnick lastbind cmdpfix
	if {[llength [split $args]] < 1} {
	notice $nick "Usage: $lastbind < \002on\002 / \002off\002 >"
	return 0 }
	set args [lindex $args 0]
	set args [split $args]
	set mode [string tolower [lindex $args 0]]
	set chan_mode ""
        set stat [string tolower [lindex [split $lastbind "$cmdpfix"] 1]]
	if { $mode == "on" } { set chan_mode "+$stat" }
	if { $mode == "off" } { set chan_mode "-$stat" }
	if { $chan_mode == ""} {
	notice $nick "Invalid argument \002$mode\002"
	notice $nick "Usage: ${cmdpfix}$stat < \002on\002 / \002off\002 >"
	return 0 }
	channel set $chan $chan_mode
	notice $nick "$stat mode for $chan is now \002$mode\002."  
	putcmdlog "<<$nick>> !$hand! $stat $chan $mode" }

	putlog "Channel Settings Commands v 2.0 By B0gdaN LOADED"
