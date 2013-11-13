# Begin - Commands & Control, Authentication. (cmd_auth.tcl)
#	Designed & Written by TCP-IP (Vicky@Vic.ky), © April 1999
#	Developed by Ninja_baby (Jaysee@Jaysee.Tv), © March 2000

# This script was made by TCP-IP in middle of 1999, I develop this script since he passes this script-
# to me in middle of 2000. I made few changes, add some features, and fixed some bugs that were remain-
# here in this script package.

# This TCL purpose a major authentication system.. which will deal with "Q" flags.. "Q" flags needed-
# when you wish to command your bot by /msg or public (channel) commands.. this TCL will help you perform-
# authentication and can automaticly de-authenticate you when you're offline / parts a channel.
# NOTE that you must not forget to load this script when you're loading scripts related with /msg or public commands.
# NOTE: not much.. even almost has no DCC command stuffs here.. I will make the DCC commands very soon ;)
#       so please support ;)

# Set this as your Public (channel) command character. For example: you set this to "!".. means you must-
# type !mycommand in channel to activate public commands...
set ATHPRM "`"

# This is for your benefit hehe ;), you can either set your own LOGO here, your logo will appear-
# when the bot notice you, or when it makes msgs/notices/kicks or scripts loading. So keep smiling-
# and set this variable as you wish ;), you can either set this to "" to leave it blank.
set cmdathlg "\[J-C\]:"

######### Please do not edit anything below unless you know what you are doing ;) #########

proc msg_pass {nick uhost hand rest} {
	global botnick cmdathlg ; set rest [lindex $rest 0]
	if {$rest == ""} {putquick "NOTICE $nick :$cmdathlg Command: /msg $botnick pass <password>" ; return 0}
	if {![passwdok $hand ""]} {putquick "NOTICE $nick :$cmdathlg Your password has been set before, you don't need to set it again. Simpy type: \[/msg $botnick auth <password>\] to authenticate yourself." ; return 0}
	setuser $hand PASS $rest ; putquick "NOTICE $nick :$cmdathlg Your password now sets to: $rest, remember your password for future use."
	putcmdlog "$cmdathlg <<$nick>> !$hand! Set Password." ; return 0
}

proc msg_auth {nick uhost hand rest} {
	global botnick cmdathlg ; set pw [lindex $rest 0]
	if {$pw == ""} {putquick "NOTICE $nick :$cmdathlg Command: /msg $botnick auth <password>" ; return 0}
	if {[passwdok $hand ""]} {putquick "NOTICE $nick :$cmdathlg You haven't set your password. Type: \[/msg $botnick pass <password>\] to set-up Your password." ; return 0}
	if {[matchattr $hand Q]} {putquick "NOTICE $nick :$cmdathlg You have authenticate before, no need another authentication." ; return 0}
	if {![passwdok $hand $pw]} {putquick "NOTICE $nick :$cmdathlg Authentication rejected!!, check out Your password." ; return 0}
	chattr $hand +Q ; putquick "NOTICE $nick :$cmdathlg Authentication accepted!!, thank you for Your authentication."
	putcmdlog "$cmdathlg <<$nick>> !$hand! Authentication." ; return 0
}

proc msg_deauth {nick uhost hand rest} {
	global botnick cmdathlg ; if {$rest == ""} {putquick "NOTICE $nick :$cmdathlg Command: /msg $botnick auth <password>" ; return 0}
	if {[passwdok $hand ""]} {putquick "NOTICE $nick :$cmdathlg You haven't set your password. Type: \[/msg $botnick pass <password>\] to set-up Your password." ; return 0}
	if {![matchattr $hand Q]} {putquick "NOTICE $nick :$cmdathlg You haven't authenticate at all!!, Type: \[/msg $botnick auth <password>\] to do so." ; return 0}
	if {![passwdok $hand $rest]} {putquick "NOTICE $nick :$cmdathlg Deauthentication rejected!!, check out Your password." ; return 0}
	chattr $hand -Q ; putquick "NOTICE $nick :$cmdathlg Deauthentication finished!!, remember to authenticate again before You run another PUBLIC commands."
	putcmdlog "$cmdathlg <<$nick>> !$hand! Deauthenticate." ; return 0
}

proc pub_auth {nick uhost hand chan rest} {
	global ATHPRM botnick cmdathlg ; if {[matchattr $hand Q]} {putquick "NOTICE $nick :$cmdathlg You have authenticate before, no need another authentication." ; return 0}
	chattr $hand +Q ; putquick "NOTICE $nick :$cmdathlg Global Authentication completed!!, thank you for Your authentication."
	putcmdlog "$cmdathlg <<$nick>> !$hand! $chan: Global Authentication." ; return 0
}

proc pub_deauth {nick uhost hand chan rest} {
	global ATHPRM botnick cmdathlg ; if {![matchattr $hand Q]} {putquick "NOTICE $nick :$cmdathlg You haven't authenticate at all!!, Type: \[/msg $botnick auth <password>\] to do so." ; return 0}
	chattr $hand -Q ; putquick "NOTICE $nick :$cmdathlg Global Deauthentication finished!!, remember to authenticate again before You run another PUBLIC commands."
	putcmdlog "$cmdathlg <<$nick>> !$hand! $chan: Global Deauthentication." ; return 0
}

proc part_deauth {nick uhost hand chan} {
	global botnick cmdathlg ; if {![matchattr $hand Q]} {return 0}
	chattr $hand -Q ; putlog "$cmdathlg $hand no longer exist on $chan, performing Auto-deatentication." ; return 0
}

proc sign_deauth {nick uhost hand chan rest} {part_deauth $nick $uhost $hand $chan}

# Set this to "1" if you like the script to be loaded.. and set it to "0" to unload.
set cmdauthloaded 1

if {[info exist cmdauthloaded]} {
	if {${cmdauthloaded}} {
		unbind msg - pass *msg:pass
		bind msg p|p pass msg_pass
		bind msg p|p auth msg_auth
		bind msg p|p deauth msg_deauth
		bind pub n ${ATHPRM}authenticate pub_auth
		bind pub n ${ATHPRM}de-authenticate pub_deauth
		bind part p|p * part_deauth
		bind sign p|p * sign_deauth
	} else {
		bind msg - pass msg:pass
		unbind msg p|p pass msg_pass
		unbind msg p|p auth msg_auth
		unbind msg p|p deauth msg_deauth
		unbind pub n ${ATHPRM}authenticate pub_auth
		unbind pub n ${ATHPRM}de-authenticate pub_deauth
		unbind part p|p * part_deauth
		unbind sign p|p * sign_deauth
	}
	putlog "*** ${cmdathlg} Commands & Control, Authentication. Loaded."
}

# End of - Commands & Control, Authentication. (cmd_auth.tcl)
