#
# flagnews.tcl - v1.2.0 - released by MHT & Islandic - MHT <mht@multimania.com>
#                       - a bind apart script from #scripting
#                       - for eggdrop 1.1.5 and 1.3.x with TCL7.5+
#
# Many Thanks to Islandic for his advices, coding and debugging !
#
#
### news add <[+]flag|all> <message>
#  Add your <message> for <flag> or all users to NewsSystem.
#  <flag> syntax is <globalflag>{&/|}<chanflag>:<#channel|all>
#  ex: news add n& Only global owners see this news.
#      news add o|o:all Global +o and any channel +o see this one.
#      news add o Shorter syntax for global +o and any channel +o.
#
### news cancel #
#  Erase news indexed # from NewsSystem. Users may only
#  cancel news written by themselves.
#
### news index [all]
#  Give a listing of unchecked or all news stored up.
#
### news last [#]
#  Show you the 'news_last' or # last stored news,
#  eventually more if unread news are available.
#
### news read [#|all]
#  Show you unchecked news, news indexed # or all stored news.
#
### news status
#  Show bot's NewsSystem status (client or server), also
#  check if NewsServer is connected in NewsClient mode.
#
### news store #
#  Store news indexed # in your personal notes.
#
####
#
# history:
# --------
#   v0.9.0 - first release.
#   v0.9.x - corrected lots of bug, renamed DELETE in CANCEL.
#   v1.0.0 - added client/server modes,
#            added LAST function.
#            corrected unreadable own news to unowned flag,
#            (bug found by KilingZoe).
#   v1.0.1 - added STATUS function.
#   v1.0.2 - corrected local/global flag bug,
#            corrected no such user error.
#   v1.0.3 - added news reminding every hours & news incoming notices.
#   v1.0.4 - added news notice on back away.
#            provided default news_file if not set before loading,
#            (bug found by Islandic, crash due to me ?).
#   v1.1.0 - added news services by /msg, news index on channel joining,
#            and news reminding every hours.
#   v1.1.1 - added HELP function.
#            corrected news notices sent to bots.
#   v1.1.2 - corrected /msg log showing password :-(
#            added STORE function.
#   v1.1.3 - corrected extra {} in some news (bug corrected for KilingZoe),
#            corrected invalid idx away bug.
#   v1.2.0 - changed flag syntax, now use (almost) 1.3.x flag matching syntax.
#            almost is for backward compatibility :-\
#
# todo:
# -----
#   news match <[+]flag> (read all news with flag filtering ?)
#   control that notes module is loaded for STORE function.
#
####

set news_version "1.2.0"

########
# NewsServer mode: set news_server to $nick, or unset it.
# NewsClient mode: set news_server to news-server's nick in botnet.
#
# NewsFile : news_file gets default value if not set in server mode,
#            and is useless in client mode.

#set news_server $nick
#set news_file "$botdir/$username.news"

set news_last 4
set news_max 50
set news_minlife 1
set news_maxlife 8
set news-time 06

########
bind dcc  - news *dcc:news
bind msg  - news *msg:news

bind chon - * *chon:news
bind join - * *join:news

bind away - * *away:news
bind time - "00 ${news-time} * * *" *time:news_expire
bind time - "00 * * * *" *time:news_remind

bind bot  - news:      *bot:news
bind bot  - newsreply: *bot:newsreply

########
set globalflags "a c d f h j k m n o p q t u v x -"
set chanflags   "a d f k m n o q s u v -"
set botflags    "b"

set customflags "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"

########
# implements 'getuser' and 'setuser' for 1.1.5 series
#
if {(([lindex $version 1]) < 01030000)} {
    proc getuser {handle xtra type} {
	user-get $handle $type
    }
    proc setuser {handle xtra type setting} {
	user-set $handle $type $setting
    }
}

########
#  return flag: if flag is valid,
#         -1    invalid global flag,
#         -2    invalid operator,
#         -3    invalid channel flag,
#         -4    invalid channel.
#
proc news_validflag {flag} {
    global globalflags chanflags customflags
    if {[string index $flag 0] == "+"} {
	set flag [string index $flag 1]
    }
    if {([string length $flag] > 1) && (([string index $flag 0] == "&") || ([string index $flag 0] == "|"))} {
        set flag "-$flag"
    }
    if {([string tolower $flag] == "all") || ($flag == "-")} {
	set flag "-"
    } else {
        set globflag [string range $flag 0 0]
        set operflag [string range $flag 1 1]
        set chanflag [string range $flag 2 2]
        set channel  [string tolower [lindex [split $flag :] 1]]
        if {([lsearch -exact [concat $globalflags $customflags] $globflag] < 0)} { return -1 }
        if {(($operflag != "") && ($operflag != "&") && ($operflag != "|")) || (($operflag == "|") && ($chanflag == ""))} { return -2 }
        if {([string length $flag] > 2)} {
            if {([lsearch -exact [concat $chanflags $customflags] $chanflag] < 0)} { return -3 }
            if {([lsearch -exact [string tolower "all [channels]"] $channel] < 0)} { return -4 }
        }
    }
    return $flag
}

########
proc news_match {handle sender whichflag} {
    set flag    [lindex [split $whichflag :] 0]
    set channel [lindex [split $whichflag :] 1]
    if {($handle == $sender)} {
        return 1
    } elseif {($channel == "")} {
        if {([string index $flag 1] == "&")} {
            return [matchattr $handle $flag]
        } else {
            #shorter syntax
            foreach channel [channels] {
                if {([matchattr $handle -|$flag $channel]) && (![matchattr $handle d|d $channel])} {
                    return 1
                }
            }
            return [matchattr $handle $flag]
        }
    } else {
        #standard syntax
        if {($channel == "all")} {
            set chanlist [channels]
        } else {
            set chanlist $channel
        }
        foreach channel $chanlist {
            if {([matchattr $handle $flag $channel]) && (![matchattr $handle d|d $channel])} {
                return 1
            }
        }
        return 0
    }
}

########
proc news_putbot {bot idx msg} { putbot $bot "newsreply: $idx $msg" }
proc news_putdcc {bot idx msg} { putdcc $idx "$msg" }

########
proc news_notice {bot nick msg} {
    global botnick
    if {([string range $msg 0 3] == "### ")} {
        set msg [string range $msg 4 end]
    }
    if {([string range $msg 0 10] == "Usage: news")} {
        set end [string range $msg 12 end]
        set msg "Usage: /MSG $botnick NEWS <pass> [string toupper [lindex $end 0]] [string range $end [string length [lindex $end 0]] end]"
    }
    if {([string first "waiting" $msg] >= 0)} {
        set idx [string first "waiting" $msg]
        set beg [string range $msg 0 [expr $idx-1]]
        set end [string range $msg [expr $idx+7] end]
        set msg "${beg}waiting on $botnick${end}"
    }
    if {([string first ".news" $msg] >= 0)} {
        set idx [string first ".news" $msg]
        set beg [string range $msg 0 [expr $idx-1]]
        set end [string range $msg [expr $idx+6] end]
        set msg "${beg}/MSG $botnick NEWS <password> [string toupper [lindex $end 0]] [string range $end [string length [lindex $end 0]] end]"
    }
    puthelp "NOTICE $nick :$msg"
}

########
proc *dcc:news {handle idx arg} {
    global news_server nick news_last
    if {$arg==""} {
	putdcc $idx "Usage: news add <\[+\]flag|all> <message>"
	putdcc $idx "       news cancel #"
	putdcc $idx "       news index \[all\]"
	putdcc $idx "       news last  \[#\]"
	putdcc $idx "       news read  \[#|all\]"
	putdcc $idx "       news status"
	putdcc $idx "       news store #"
	putdcc $idx "       news help"
	putdcc $idx "       <flag> syntax is <globalflag>{&/|}<chanflag>:<#channel|all>"
	putdcc $idx "       ex: news add n& Only global owners see this news."
	putdcc $idx "           news add o|o:all Global +o and any channel +o see this one."
	putdcc $idx "           news add o Shorter syntax for global +o and any channel +o."
	return 0
    } else {
	set cmd [string tolower [lindex $arg 0]]
	if {($cmd == "status")} {
	    news_status $handle $idx
	    return 1
	}
	if {($cmd == "help")} {
	    putdcc $idx "###  news add <\[+\]flag|all> <message>"
	    putdcc $idx "   Add your <message> for <flag> or all users to NewsSystem."
	    putdcc $idx "   <flag> syntax is <globalflag>{&/|}<chanflag>:<#channel|all>"
	    putdcc $idx "   ex: news add n& Only global owners see this news."
	    putdcc $idx "       news add o|o:all Global +o and any channel +o see this one."
	    putdcc $idx "       news add o Shorter syntax for global +o and any channel +o."
	    putdcc $idx "###  news cancel #"
	    putdcc $idx "   Erase news indexed # from NewsSystem. Users may only"
	    putdcc $idx "   cancel news written by themselves."
	    putdcc $idx "###  news index \[all\]"
	    putdcc $idx "   Give a listing of unchecked or all news stored up."
	    putdcc $idx "###  news last \[#\]"
	    putdcc $idx "   Show you the $news_last or # last stored news,"
	    putdcc $idx "   eventually more if unread news are available."
	    putdcc $idx "###  news read \[#|all\]"
	    putdcc $idx "   Show you unchecked news, news indexed # or all stored news."
	    putdcc $idx "###  news status"
	    putdcc $idx "   Show ${nick}'s NewsSystem status (client or server), also"
	    putdcc $idx "   check if NewsServer is connected in NewsClient mode."
	    putdcc $idx "###  news store #"
	    putdcc $idx "   Store news indexed # in your personal notes."
	    putdcc $idx " "
	    putdcc $idx "see also: note, notes"
	    return 1
	}
        # server side
	if {$news_server == $nick} {
	    switch $cmd {
		"add"    { news_add    $handle $idx [string range [string trim $arg] 4 end] news_putdcc }
		"cancel" { news_cancel $handle $idx [lrange $arg 1 end] news_putdcc }
		"index"  { news_index  $handle $idx [lrange $arg 1 end] news_putdcc }
		"last"   { news_last   $handle $idx [lrange $arg 1 end] news_putdcc }
		"read"   { news_read   $handle $idx [lrange $arg 1 end] news_putdcc }
		"store"  { news_store  $handle $idx [lrange $arg 1 end] news_putdcc }
		default  {
		    putdcc $idx "Function must be one of ADD, CANCEL, INDEX, LAST, READ, STATUS or STORE."
		}
	    }
        # client side
	} elseif {($cmd != "add") && ($cmd != "cancel") && ($cmd != "index") && ($cmd != "last") && ($cmd != "read") && ($cmd != "status") && ($cmd != "store")} {
	    putdcc $idx "Function must be one of ADD, CANCEL, INDEX, LAST, READ, STATUS or STORE."
	} elseif {([lsearch [string tolower [bots]] [string tolower $news_server]] < 0)} {
	    putdcc $idx "NewsServer Bot '$news_server' is not linked !"
	} elseif {($cmd != "add")} {
	    putbot $news_server "news: $handle $idx $cmd [lrange $arg 1 end]"
	    putcmdlog "#$handle# news@$news_server $cmd [lindex $arg 1]"
	} else {
	    set whichflag [lindex $arg 1]
	    set message [string range $arg [expr [string first " $whichflag " $arg]+[string length " $whichflag "]] end]
            set flag [news_validflag $whichflag]
            switch -- $flag {
                -1 { putdcc $idx "Invalid global flag in \[$whichflag\], please try again.";   return 0 }
                -2 { putdcc $idx "Invalid operator flag in \[$whichflag\], please try again."; return 0 }
                -3 { putdcc $idx "Invalid channel flag in \[$whichflag\], please try again.";  return 0 }
                -4 { putdcc $idx "Invalid channel in \[$whichflag\], please try again.";       return 0 }
            }
	    putbot $news_server "news: $handle $idx $cmd $flag $message"
	    putcmdlog "#$handle# news@$news_server $cmd \[$flag\] ..."
	}
    }
}

########
proc *msg:news {unick uhost uhandle arg} {
    global news_server nick botnick news_last customflags globalflags chanflags botflags
    if {(![validuser $uhandle]) || ($news_server != $nick)} {
        return 0
    }
    if {$arg==""} {
	puthelp "NOTICE $unick :Usage: NEWS <pass> ADD <\[+\]flag|all> <message>"
	puthelp "NOTICE $unick :       NEWS <pass> CANCEL #"
	puthelp "NOTICE $unick :       NEWS <pass> INDEX \[all\]"
	puthelp "NOTICE $unick :       NEWS <pass> LAST  \[#\]"
	puthelp "NOTICE $unick :       NEWS <pass> READ  \[#|all\]"
	puthelp "NOTICE $unick :       NEWS <pass> STORE #"
	puthelp "NOTICE $unick :       NEWS HELP"
	puthelp "NOTICE $unick :       <flag> syntax is <globalflag>{&/|}<chanflag>:<#channel|all>"
	puthelp "NOTICE $unick :       ex: news add n& Only global owners see this news."
	puthelp "NOTICE $unick :           news add o|o:all Global +o and any channel +o see this one."
	puthelp "NOTICE $unick :           news add o Shorter syntax for global +o and any channel +o."
	return 0
    } elseif {([string tolower [lindex $arg 0]] == "help")} {
	puthelp "NOTICE $unick :You must use your password for any NEWS command."
	puthelp "NOTICE $unick :/MSG $botnick NEWS <pass> ADD <\[+\]flag|all> <message>"
	puthelp "NOTICE $unick :    Add your <message> for <flag> or all users to NewsSystem."
	puthelp "NOTICE $unick :    <flag> syntax is <globalflag>{&/|}<chanflag>:<#channel|all>"
	puthelp "NOTICE $unick :    ex: /MSG $botnick NEWS mypass ADD n& Only global owners see this news."
	puthelp "NOTICE $unick :        /MSG $botnick NEWS mypass ADD o|o:all Global +o and any channel +o see this one."
	puthelp "NOTICE $unick :        /MSG $botnick NEWS mypass ADD o Shorter syntax for global +o and any channel +o."
	puthelp "NOTICE $unick :/MSG $botnick NEWS <pass> CANCEL #"
	puthelp "NOTICE $unick :    Erase news indexed # from NewsSystem. Users may only"
	puthelp "NOTICE $unick :    cancel news written by themselves."
	puthelp "NOTICE $unick :/MSG $botnick NEWS <pass> INDEX \[all\]"
	puthelp "NOTICE $unick :    Give a listing of unchecked or all news stored up."
	puthelp "NOTICE $unick :/MSG $botnick NEWS <pass> LAST \[#\]"
	puthelp "NOTICE $unick :    Show you the $news_last or # last stored news,"
	puthelp "NOTICE $unick :    eventually more if unread news are available."
	puthelp "NOTICE $unick :/MSG $botnick NEWS <pass> READ \[#|all\]"
	puthelp "NOTICE $unick :    Show you unchecked news, news indexed # or all stored news."
	puthelp "NOTICE $unick :/MSG $botnick NEWS <pass> STORE #"
	puthelp "NOTICE $unick :    Store news indexed # in your personal notes."
	return 1
    } else {
        if {(![passwdok $uhandle [lindex $arg 0]])} {
            return 0
        }
	set cmd [string tolower [lindex $arg 1]]
	switch $cmd {
	    "add"    { news_add    $uhandle $unick [string range $arg [expr [string first " [lindex $arg 2] " $arg]+1] end] news_notice $uhost; return 0 }
	    "cancel" { news_cancel $uhandle $unick [lrange $arg 2 end] news_notice }
	    "index"  { news_index  $uhandle $unick [lrange $arg 2 end] news_notice }
	    "last"   { news_last   $uhandle $unick [lrange $arg 2 end] news_notice }
	    "read"   { news_read   $uhandle $unick [lrange $arg 2 end] news_notice }
	    "store"  { news_store  $uhandle $unick [lrange $arg 2 end] news_notice }
	    default  {
	        puthelp "NOTICE $unick :Function must be one of ADD, CANCEL, INDEX, LAST, READ or STORE."
		return 0
	    }
	}
	putcmdlog "<$unick!$uhost> !$uhandle! NEWS $cmd [lrange $arg 2 end]"

    }
}

########
proc *chon:news {handle idx} {
    global news_server nick
    # server side
    if {($news_server == $nick)} {
	news_index $handle $idx "" news_putdcc
    # client side
    } elseif {([lsearch [string tolower [bots]] [string tolower $news_server]] >= 0)} {
	putbot $news_server "news: $handle $idx silentindex"
    }
    return 0
}

########
proc *join:news {unick uhost uhandle channel} {
    global news_server nick
    if {([validuser $uhandle]) && (![matchattr $uhandle b]) && ($news_server == $nick)} {
        news_shortindex $uhandle $unick "" news_notice
    }
    return 0
}

########
proc *away:news {bot idx msg} {
    global news_server nick
    if {($bot == $nick) && ($msg == "")} {
        set handle [idx2hand $idx]
        # server side
        if {($news_server == $nick)} {
	    news_index $handle $idx "" news_putdcc
	# client side
        } elseif {([lsearch [string tolower [bots]] [string tolower $news_server]] >= 0)} {
	    putbot $news_server "news: $handle $idx silentindex"
        }
    }
    return 0
}

########
proc *time:news_expire {min hour day month year} {
    global news_file news_max news_minlife news_maxlife news_server nick
    # client side
    if {($news_server != $nick)} {
        return 0
    }
    # server side
    set fdo [open $news_file "r"]
    set news [gets $fdo]
    if {(([lindex $news 2]) > ([unixtime]-(86400*$news_maxlife)))} {
	close $fdo
	putcmdlog "FlagNews: no news to expire."
	return 0
    } else {
	set fdn [open "$news_file~new" "w"]
	set count 0
	while {(![eof $fdo])} {
	    set news [gets $fdo]
	    if {(![eof $fdo]) && (([lindex $news 2]) > ([unixtime]-(86400*$news_maxlife)))} {
		puts $fdn $news
	    } else {
		incr count
	    }
	}
	close $fdo
	close $fdn
	if {[info tclversion]>=7.6} {
	    file rename -force "$news_file~new" $news_file
	} else {
	    news_rename "$news_file~new" $news_file
	}
	putcmdlog "FlagNews: expired $count news."
	return 1
    }
}

########
proc *time:news_remind {min hour day month year} {
    global news_server nick
    # server side
    if {($news_server == $nick)} {
        foreach dcc [dcclist] {
            if {([lindex $dcc 3] == "CHAT") && ([validuser [lindex $dcc 1]])} {
	        news_shortindex [lindex $dcc 1] [lindex $dcc 0] "" news_putdcc
	    }
	}
	set userlist ""
        foreach channel [channels] {
            foreach user [chanlist $channel] {
                set handle [nick2hand $user $channel]
                if {([validuser $handle]) && (![matchattr $handle b]) && ([lsearch -exact $userlist [list $handle $user]] < 0)} {
                  lappend userlist [list $handle $user]
                }
            }
        }
        foreach user $userlist {
	    news_shortindex [lindex $user 0] [lindex $user 1] "" news_notice
        }
    # client side
    } elseif {([lsearch [string tolower [bots]] [string tolower $news_server]] >= 0)} {
        foreach dcc [dcclist] {
            if {([lindex $dcc 3] == "CHAT") && ([validuser [lindex $dcc 1]])} {
	        putbot $news_server "news: [lindex $dcc 1] [lindex $dcc 0] shortindex"
	    }
	}
    }
    return 0
}

########
proc news_add {handle idx arg Xput {bot ""}} {
    global nick news_file customflags globalflags chanflags botflags
    if {(![file exists $news_file])} { close [open $news_file "a+"]  }
    if {([lindex $arg 1] == "")} {
	$Xput $bot $idx "Usage: news add <\[+\]flag|all> <message>"
	$Xput $bot $idx "       <flag> syntax is <globalflag>{&/|}<chanflag>:<#channel|all>"
	$Xput $bot $idx "       ex: news add n& Only global owners see this news."
	$Xput $bot $idx "           news add o|o:all Global +o and any channel +o see this one."
	$Xput $bot $idx "           news add o Shorter syntax for global +o and any channel +o."
	return 0
    }
    if {[news_rollover] == 0} {
	$Xput $bot $idx "Sorry, NewsSystem has too many news already."
	return 0
    }
    set whichflag [lindex $arg 0]
    set message [string range [string trim $arg] [string length "$whichflag "] end]
    set flag [news_validflag $whichflag]
    switch -- $flag {
        -1 { putdcc $idx "Invalid global flag in \[$whichflag\], please try again.";   return 0 }
        -2 { putdcc $idx "Invalid operator flag in \[$whichflag\], please try again."; return 0 }
        -3 { putdcc $idx "Invalid channel flag in \[$whichflag\], please try again.";  return 0 }
        -4 { putdcc $idx "Invalid channel in \[$whichflag\], please try again.";       return 0 }
    }
    set fd [open $news_file "a+"]
    puts $fd [format "%s %s %s %s" $flag $handle [unixtime] $message]
    close $fd
    $Xput $bot $idx "Stored news for \[$flag\] users."
    $Xput $bot $idx "Use '.news cancel [news_count_user $handle]' to erase this news."
    switch $Xput {
        "news_notice" { putcmdlog "<$idx!$bot> !$handle! NEWS add \[$flag\] ..." }
        "putdcc"      { putcmdlog "#$handle# news add \[$flag\] ..." }
        "putbot"      { putcmdlog "#$handle@$idx# news add \[$flag\] ..." }
    }
    news_incoming $handle $flag $nick
    putallbots "news: $handle $idx incoming $flag"
    return 0
}

########
proc news_cancel {handle idx arg Xput {bot ""}} {
    global news_file
    if {([lindex $arg 0] == "")} {
	$Xput $bot $idx "Usage: news cancel #"
	return 0
    }
    set fdo [open $news_file r]
    set fdn [open "$news_file~new" w]
    set count 0
    set cancelled 0
    while {![eof $fdo]} {
	set news [gets $fdo]
	if {($news != "")} {
	    if {([news_match $handle [lindex $news 1] [lindex $news 0]])} {
		incr count
		if {($count == $arg) && ($handle == [lindex $news 1])} {
		    set cancelled 1
		} else {
		    puts $fdn $news
		}
	    } else {
		puts $fdn $news
	    }
	}
    }
    if {($cancelled == 1)} {
	if {($count == 1)} {
	    $Xput $bot $idx "Cancelled all news."
	} else {
	    $Xput $bot $idx "Cancelled #$arg, [expr $count-1] left."
	}
    } elseif {($arg > 0) && ($arg <= $count)} {
	$Xput $bot $idx "Can't cancel other user news!"
    } else {
	$Xput $bot $idx "You don't have that many news."
    }
    close $fdo
    close $fdn
    if {[info tclversion]>=7.6} {
	file rename -force "$news_file~new" $news_file
    } else {
	news_rename "$news_file~new" $news_file
    }
    return 1
}

########
proc news_index {handle idx arg Xput {bot ""}} {
    global news_file
    if {(![file exists $news_file])} { close [open $news_file "a+"]  }
    set fd [open $news_file "r"]
    set userstamp [getuser $handle XTRA "newstime"]
    if {($userstamp == "")} { set userstamp 0 }
    set count 0
    set read 0
    while {(![eof $fd])} {
	set news [gets $fd]
	if {($news != "") && ([news_match $handle [lindex $news 1] [lindex $news 0]])} {
	    incr count
	    set newstamp [lindex $news 2]
	    if {($arg == "all") || ($arg == $count) || (($arg == "") && ($newstamp >= $userstamp))} {
		incr read
		if ($read==1) {
		    $Xput $bot $idx "### You have the following news waiting:"
		}
		set flag   [lindex $news 0]
		set sender [lindex $news 1]
		set date   [strftime "%b %d %H:%M" $newstamp]
		set msg    [string range $news [string length "$flag $newstamp $sender "] end]
		$Xput $bot $idx [format "%3d. \[%s\] %s (%s)" $count $flag $sender $date]
	    }
	}
    }
    if {($count == 0)} {
	$Xput $bot $idx "You have no news waiting."
    } else {
	if {$read == 0} {
	    $Xput $bot $idx "You have [expr $count-$read] old-news waiting, use '.news read all' to read them."
	} elseif {(($count-$read) > 0)} {
	    $Xput $bot $idx " ([expr $count-$read] old-news waiting.)"
	    $Xput $bot $idx "### Use '.news read \[all\]' to read them."
	} else {
	    $Xput $bot $idx "### Use '.news read' to read them."
	}
    }
    close $fd
    return 1
}

########
proc news_shortindex {handle idx arg Xput {bot ""}} {
    global news_file
    if {(![file exists $news_file])} { close [open $news_file "a+"]  }
    set fd [open $news_file "r"]
    set userstamp [getuser $handle XTRA "newstime"]
    if {($userstamp == "")} { set userstamp 0 }
    set count 0
    set read 0
    while {(![eof $fd])} {
	set news [gets $fd]
	if {($news != "") && ([news_match $handle [lindex $news 1] [lindex $news 0]])} {
	    incr count
	    set newstamp [lindex $news 2]
	    if {($arg == "all") || ($arg == $count) || (($arg == "") && ($newstamp >= $userstamp))} {
		incr read
	    }
	}
    }
    if {($read > 0)} {
        $Xput $bot $idx "### You have $read unread news waiting."
        $Xput $bot $idx "### Use '.news read' to read them."
    }
    close $fd
    return 1
}

########
proc news_read {handle idx arg Xput {bot ""}} {
    global news_file
    if {(![file exists $news_file])} { close [open $news_file "a+"]  }
    set fd [open $news_file "r"]
    set userstamp [getuser $handle XTRA "newstime"]
    if {($userstamp == "")} { set userstamp 0 }
    set count 0
    set read 0
    while {(![eof $fd])} {
	set news [gets $fd]
	if {($news != "") && ([news_match $handle [lindex $news 1] [lindex $news 0]])} {
	    incr count
	    set newstamp [lindex $news 2]
	    if {($arg == "all") || ($arg == $count) || (($arg == "") && ($newstamp >= $userstamp))} {
		incr read
		set flag   [lindex $news 0]
		set sender [lindex $news 1]
		set date   [strftime "%b %d %H:%M" $newstamp]
		set msg    [string range $news [string length "$flag $newstamp $sender "] end]
		$Xput $bot $idx [format "%2d. \[%s\] %s (%s): %s" $count $flag $sender $date $msg]
	    }
	}
    }
    if {($count == 0)} {
	$Xput $bot $idx "You have no news waiting."
    } elseif {(($count-$read) > 0) && ($arg == "")} {
	$Xput $bot $idx " ([expr $count-$read] old-news waiting, use '.news read all' to read them.)"
    } elseif {($read == 0) && ($arg != "")} {
	$Xput $bot $idx "There is no that many news."
    }
    setuser $handle XTRA "newstime" [unixtime]
    close $fd
    return 1
}

########
proc news_last {handle idx arg Xput {bot ""}} {
    global news_file news_last
    if {(![file exists $news_file])} { close [open $news_file "a+"]  }
    set fd [open $news_file "r"]
    set userstamp [getuser $handle XTRA "newstime"]
    if {($userstamp == "")} { set userstamp 0 }
    set count 0
    set read 0
    set last [news_count_user $handle]
    if {($arg > 0)} { incr last -$arg
                  } { incr last -$news_last
    }
    while {(![eof $fd])} {
	set news [gets $fd]
	if {($news != "") && ([news_match $handle [lindex $news 1] [lindex $news 0]])} {
	    incr count
	    set newstamp [lindex $news 2]
	    if {($count > $last) || ($newstamp >= $userstamp)} {
		incr read
		set flag   [lindex $news 0]
		set sender [lindex $news 1]
		set date   [strftime "%b %d %H:%M" $newstamp]
		set msg    [string range $news [string length "$flag $newstamp $sender "] end]
		if {($newstamp >= $userstamp)} {
		    $Xput $bot $idx [format ">%2d. \[%s\] %s (%s): %s" $count $flag $sender $date $msg]
		} {
		    $Xput $bot $idx [format " %2d. \[%s\] %s (%s): %s" $count $flag $sender $date $msg]
		}
	    }
	}
    }
    if {($count == 0)} {
	$Xput $bot $idx "You have no news waiting."
    } elseif {(($count-$read) > 0) && ($arg == "")} {
	$Xput $bot $idx " ([expr $count-$read] old-news waiting, use '.news read all' to read them.)"
    } elseif {($read == 0) && ($arg != "")} {
	$Xput $bot $idx "There is no that many news."
    }
    setuser $handle XTRA "newstime" [unixtime]
    close $fd
    return 1
}

########
proc news_status {handle idx} {
    global news_file news_server news_version nick
    if {($news_server ==  $nick)} {
        putdcc $idx "*** FlagNews $news_version - NewsServer mode, NewsFile is '$news_file'."
    } {
        if {([lsearch [string tolower [bots]] [string tolower $news_server]] < 0)} {
            set cx "not linked"
        } {
            set cx "linked"
        }
        putdcc $idx "*** FlagNews $news_version - NewsClient mode, NewsServer is '$news_server' ($cx)."
    }
}

########
proc news_store {handle idx arg Xput {bot ""}} {
    global news_file
    if {([lindex $arg 0] == "")} {
	$Xput $bot $idx "Usage: news store #"
	return 0
    }
    set fd [open $news_file r]
    set count 0
    set stored 0
    while {![eof $fd]} {
	set news [gets $fd]
	if {($news != "") && ([news_match $handle [lindex $news 1] [lindex $news 0]])} {
	    incr count
	    if {($count == $arg)} {
		set flag   [lindex $news 0]
		set sender [lindex $news 1]
		set date   [strftime "%b %d %H:%M" [lindex $news 2]]
		set msg    [string range $news [string length "$flag [lindex $news 2] $sender "] end]
		set news   [format "\[%s\] %s (%s): %s" $flag $sender $date $msg]
	        storenote "NEWS" $handle "$news" -1])
	        $Xput $bot $idx "Stored news $count in note system: '$news'."
	        set stored 1
	    }
	}
    }
    if {($stored == 0)} {
	$Xput $bot $idx "You don't have that many news."
    }
    close $fd
    return 1
}

########
proc news_incoming {sender flag bot} {
    global news_server
    if {$bot == $news_server} {
        foreach dcc [dcclist] {
            set handle [lindex $dcc 1]
            if {([lindex $dcc 3] == "CHAT") && ([validuser $handle]) && ([news_match $handle $sender $flag])} {
                putdcc [lindex $dcc 0] "*** News arrived from $sender for you \[$flag\]."
	    }
	}
    }
    return 0
}

########
proc news_count {} {
    global news_file
    set fd [open $news_file "r"]
    set count 0
    while {(![eof $fd])} {
	set news [gets $fd]
	if {(![eof $fd])} {
	    incr count
	}
    }
    close $fd
    return $count
}

########
proc news_count_user {handle} {
    global news_file
    set fd [open $news_file "r"]
    set count 0
    while {(![eof $fd])} {
	set news [gets $fd]
	if {($news != "") && ([news_match $handle [lindex $news 1] [lindex $news 0]])} {
	    incr count
	}
    }
    close $fd
    return $count
}

########
proc news_rollover {} {
    global news_file news_max news_minlife news_maxlife
    if {([news_count] < $news_max)} {
	return 1
    } else {
	set fd [open $news_file "r"]
	set news [gets $fd]
	if {(([lindex $news 2]) > ([unixtime]-(86400*$news_minlife)))} {
	    close $fd
	    return 0
	} else {
	    set fdn [open "$news_file~new" "w"]
	    while {(![eof $fd])} {
		set news [gets $fd]
		if {(![eof $fd])} {
		    puts $fdn $news
		}
	    }
	    close $fd
	    close $fdn
	    if {[info tclversion]>=7.6} {
		file rename -force "$news_file~new" $news_file
	    } else {
		news_rename "$news_file~new" $news_file
	    }
	    return 1
	}
    }
}

########
# TCL error: can't rename "news_file": command doesn't exist (in 7.5)
# mail me if you know how to deal with it....
proc news_rename {src dest} {
    set fds [open $src r]
    set fdd [open $dest w]
    while {![eof $fds]} {
	set line [gets $fds]
	if {$line != ""} { puts $fdd $line }
    }
    close $fds
    close $fdd
    set fds [open $src w]
    close $fds
}

########
proc *bot:news {handle idx arg} {
    global nick
    set uhnd [lindex $arg 0]
    set uidx [lindex $arg 1]
    set cmd  [lindex $arg 2]
    set val  [string range $arg [string length "$uhnd $uidx $cmd "] end]
    if {(![validuser $uhnd])} {
      putbot $handle "newsreply: $uidx *** NewsSystem: You are not registred on NewsServer '$nick'."
      putlog "*** NewsSystem error: unregistred user '$uhnd' from '$handle'."
      return 0
    }
    switch [string tolower $cmd] {
	"add"      { set ret [news_add    $uhnd $uidx $val news_putbot $handle] }
	"cancel"   { set ret [news_cancel $uhnd $uidx $val news_putbot $handle] }
	"index"    { set ret [news_index  $uhnd $uidx $val news_putbot $handle] }
	"last"     { set ret [news_last   $uhnd $uidx $val news_putbot $handle] }
	"read"     { set ret [news_read   $uhnd $uidx $val news_putbot $handle] }
	"store"    { set ret [news_store  $uhnd $uidx $val news_putbot $handle] }
	"incoming" { set ret [news_incoming $uhnd $val $handle ] }
	"shortindex"  { set ret 0; news_shortindex $uhnd $uidx $val news_putbot $handle }
	"silentindex" { set ret 0; news_index      $uhnd $uidx $val news_putbot $handle }
	default       { set ret 0 }
    }
    if {($ret == 1)} { putcmdlog "#$uhnd@$handle# news $cmd $val" }
}

########
proc *bot:newsreply {handle idx arg} {
    set idx [lindex $arg 0]
    if {($idx == -1)} { return }
    set reply [string range $arg [string len "$idx "] end]
    putidx $idx "$reply"
}

########
if {(![info exists botdir])}      { set botdir "." }
if {(![info exists news_file])}   { set news_file "$botdir/$username.news" }
if {(![info exists news_server])} { set news_server $nick}

########
putlog "FlagNews $news_version - Released by MHT & Islandic."
if {($news_server ==  $nick)} {
    putlog "               - NewsServer mode, NewsFile is '$news_file'."
} elseif {([lsearch [string tolower [bots]] [string tolower $news_server]] < 0)} {
    putlog "               - NewsClient mode, NewsServer is '$news_server' (not linked)."
} {
    putlog "               - NewsClient mode, NewsServer is '$news_server' (linked)."
}

####
