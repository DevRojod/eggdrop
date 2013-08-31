#####################################################################
#  chaninfo v1.3 © 1999, Per Johansson  -(dw@eggheads.org)-         # 
#####################################################################
# About:
# Coded for eggdrop1.3/1.4/1.5
#
# This is a multi channel info/rules tcl
# mainly for helpchans and similar where
# info/rules are repeaded often.
# It can store any information and give it at request
# or at join. The info/rules are easerly maintained in the chan.
#
#####################################################################
# Usage: !info [nick], !addinfo <text>, !delinfo <#>,
#        !wipeinfo, !undoinfo, !helpinfo [command]
#####################################################################
# Changes:
# ver1.0 (12/9-99)  <dw>  First release enjoy.
# ver1.1 (13/9-99)  <dw>
#                        Added !wipeinfo (remove all info)
#                        Added !undoinfo to undo the last thing done.
#                        +minor changes..
# ver1.2 (22/9-99)  <dw>
#                        Added feedback setting: verbose <0/1>
#                        Added !helpinfo [command]
# ver1.3 (25/11-99) <dw> 
#                        Fixed bug where it didnt work if you changed
#                        the caseing in the chan name (ie. #chaN != #chan)
#                        Added floot protection.
#
#####################################################################
##init##
if {[info exist info]} {unset info}
#################################################
#>   .          USER SETTINGS              .   <#
#################################################

# channels you will be using chaninfo.tcl in
set info(chans) "#botcentral #lamechan"

# <0/1/2> send info to ppl that join?
# 0 = no, 1 = all, 2 = all except +o/+v ppl.
set info(onjoin) 2

# userlevel for add/del info
# (.help whois in eggy for flags)
set info(level) m

# <0/1> show feedback in chan or private
set info(verbose) 1

#################################################
#>   .    do not edit below this point     .   <#
#################################################

putlog "Loading chaninfo.."
set info(chans) "[string tolower $info(chans)]"
set info(jflood) 0
set info(warning) 0

proc load_info {chan} {
  global info
  set chan [string tolower $chan]
  if {[file exist ./info.${chan}]} {
    set fid [open ./info.${chan} r]
    set info(${chan}) [split [read $fid] \n]
    close $fid
    set i 0
    foreach line $info($chan) {
      if {[string length $line] < 1} {
        set info($chan) [lreplace $info($chan) $i $i]
        incr i -1
      }
      incr i
    }
  }
}

proc save_info {chan} {
  global info
  set chan [string tolower $chan]
  if {[file exist ./info.${chan}]} {
    file copy -force -- ./info.${chan} ./info.${chan}.bkp
  }
  set fid [open ./info.${chan} w+]
  puts $fid [join $info($chan) \n]
  close $fid
}

proc info_show {ni uh ha ch text} {
  global info
  set ch [string tolower $ch]
  if {$info(verbose)} { set fb $ch } { set fb $ni }
  if {[info exist info($ch)]} {
    puthelp "NOTICE $fb :Info for $ch requested by $ni"
    set i 1
    foreach line $info($ch) {
      puthelp "NOTICE $ni :${i}) $line"
      incr i
    }
  } else {
    puthelp "NOTICE $fb :There is no info defined atm."
  }
}

proc info_target {ni uh ha ch target} {
  global info
  set ch [string tolower $ch]
  if {$info(verbose)} { set fb $ch } { set fb $ni }
  set target [lreplace $target 0 0]
  if {[info exist info($ch)]} {
    if {[onchan $target $ch]} {
      puthelp "NOTICE $target :Info for $ch"
      set i 1
      foreach line $info($ch) {
        puthelp "NOTICE $target :${i}) $line"
        incr i
      }
      puthelp "NOTICE $fb :Info sent to $target"
    } else {
      puthelp "NOTICE $fb :$target isnt in $ch"
    }
  } else {
    puthelp "NOTICE $fb :There is no info defined atm."
  }
}

proc info_add {ni uh ha ch line} {
  global info
  set ch [string tolower $ch]
  if {$info(verbose)} { set fb $ch } { set fb $ni }
  set line [lreplace $line 0 0]
  lappend info($ch) $line
  set new [llength $info($ch)]
  puthelp "NOTICE $fb :Info line #$new added ($line)"
  save_info $ch
}

proc info_del {ni uh ha ch nr} {
  global info
  set ch [string tolower $ch]
  if {$info(verbose)} { set fb $ch } { set fb $ni }
  set nr [lindex $nr 1]
  if {([regexp \[^0-9\] $nr]) || ($nr == "")} {
    puthelp "NOTICE $fb :Thats not a number"
  } elseif {$nr > [llength $info($ch)]} {
    puthelp "NOTICE $fb :There isnt as many info lines"
  } else {
    set lr [expr $nr -1]
    puthelp "NOTICE $fb :Removing info #$nr ([lindex $info($ch) $lr])"
    set info($ch) [lreplace $info($ch) $lr $lr]
    save_info $ch
  }
}

proc info_jflood {} {
  global info
  incr info(jflood) -1
}

proc info_join {ni uh ha ch} {
  global info
  set ch [string tolower $ch]
  if {$info(onjoin) == 0} { return 0 }
  if {($info(onjoin) == 2) && ([matchattr $ha vo|vo $ch])} {
    return 0
  }
  incr info(jflood); utimer 15 info_jflood
  if {$info(jflood) > 3} {
    if {!($info(warning))} {
      set info(warning) 1
      putlog "chaninfo onjoin temporarily disabled due to join flood"
    }
    return 0
  }
  if {$info(warning)} {
    putlog "chaninfo onjoin enabled again."
    set info(warning) 0
  }
  puthelp "NOTICE $ni :Info for $ch"
  set i 1
  foreach line $info($ch) {
    puthelp "NOTICE $ni :${i}) $line"
    incr i
  }
}

proc info_wipe {ni uh ha ch text} {
  global info
  set ch [string tolower $ch]
  if {$info(verbose)} { set fb $ch } { set fb $ni }
  if {[info exist info($ch)]} {
    set info($ch) ""
    save_info $ch
    unset info($ch)
    puthelp "NOTICE $fb :Channel info wiped"
  } else {
    puthelp "NOTICE $fb :There is no info to be removed"
  }
}
proc info_undo {ni uh ha ch text} {
  global info
  set ch [string tolower $ch]
  if {$info(verbose)} { set fb $ch } { set fb $ni }
  if {[file exist ./info.${ch}.bkp]} {
    file copy -force -- ./info.${ch}.bkp ./info.${ch}
    load_info $ch
    puthelp "NOTICE $fb :Last info command is reversed"
  } else {
    puthelp "NOTICE $fb :There is nothing to undo"
  }
}

proc info_help {ni uh ch ch text} {
  global info
  set ch [string tolower $ch]
  if {$info(verbose)} { set fb $ch } { set fb $ni }
  if {[lindex $text 1] == ""} {  
    puthelp "NOTICE $fb :!info \[nick\], !addinfo <text>, !delinfo\
	<#>, !wipeinfo, !undoinfo, !helpinfo \[command\]"
  } else {
    switch [lindex $text 1] {
      "info" {
	puthelp "NOTICE $fb :!info/!info <nick> to get/send the info"
      }
      "addinfo" {
	puthelp "NOTICE $fb :!addinfo <text> to add a new info line"
      }
      "delinfo" {
	puthelp "NOTICE $fb :!delinfo <#> to remove info line #"
      }
      "wipeinfo" {
	puthelp "NOTICE $fb :!wipeinfo removes all info lines"
      }
      "undoinfo" {
	puthelp "NOTICE $fb :!undoinfo reverse the last info command"
      }
      default { puthelp "NOTICE $fb :No help on that" }
    }
  }
}

proc info_list {ni uh ha ch text} {
  global info
  set ch [string tolower $ch]
  if {$info(verbose)} { set fb $ch } { set fb $ni }
  if {[info exist info($ch)]} {
    puthelp "NOTICE $fb :Info x to y for $ch requested by $ni"
    set i 1
    foreach line $info($ch) {
      puthelp "NOTICE $ni :${i}) $line"
      incr i
    }
  } else {
    puthelp "NOTICE $fb :There is no info defined atm."
  }
}

foreach chan $info(chans) {
  if {$info(onjoin) != 0} {
    bind join -|- "$chan *" info_join
  }
  set flg "$info(level)|$info(level)"
  bind pubm -|- "$chan !info" info_show
  bind pubm -|- "$chan !listinfo*" info_list
  bind pubm v|v "$chan !info %" info_target
  bind pubm $flg "$chan !addinfo *" info_add
  bind pubm $flg "$chan !delinfo %" info_del
  bind pubm $flg "$chan !wipeinfo" info_wipe
  bind pubm $flg "$chan !undoinfo" info_undo
  bind pubm $flg "$chan !helpinfo*" info_help
  load_info $chan
}

putlog "chaninfo 1.3 by dw loaded.."













README.md
