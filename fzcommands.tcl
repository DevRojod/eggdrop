#############################[ FZ COMMANDS 3.1 ]#############################
#                                                                           #
# Author  : Opposing (Fz@nexushells.net) - #nexushells @ DALnet             #
# Version : 3.1                                                             #
# Released: September 25, 2005                                              #
# Source  : http://hub.nexushells.net/~Fz/index.htm                         #
##                                                                          #
# Description: Allows masters/owners to control the bot via public/msg      #
#              commands. Includes several usefull                           #
#              commands.                                                    #
#                                                                           #
# Available Commands:                                                       #
# - Pub: (trigger)cmdhelp: for public commands.                             #
# - msg: cmdhelp: for private (msg) commands.                               #
#                                                                           #
# To authenticate: /msg bot auth <pass>                                     #
#                                                                           #
# Credits:                                                                  #
#         Used auth procs from cmd_auth.tcl by TCP-IP (furtherly developed  #
#         by Ninja_Baby and then again managed by me (Opposing) for some    #
#         minor (but important) bug fixes and enhancements.                 #
#                                                                           #
#         Also used wordwrap and maskhost procs by user from the egghelp    #
#         forum in order to optimze the notice output and maskhost types.   #
#                                                                           #
# History:                                                                  #
#         - 3.1: Enhancement to the scripts' code and eye-candy.            #
#         - 3.0: Added the ability to choose a custom maskhost instead of   #
#           only banning *!*@host and made an improvement to the master and #
#           owner commands. Also, Fixed a few bugs and changed the name of  #
#           the script to "Fz Commands" in order to differentiate it from   #
#           other scripts.                                                  #
#         - 2.9: Improved dealing with strings and lists.                   #
#         - 2.8: Some improvement on the bot's user interface + a little    #
#           tweak on the bankick command. (requested by Linux from the      #
#           egghelp.org forum)                                              #
#         - 2.7: Missing bracket bug fixed. Reported by Linux from the      #
#           egghelp.org forum.                                              #
#         - 2.6: Added the ability to bankick masks (i.e bankick            #
#           nick!ident@host will bankick all the nicks that match in the    #
#           channel.                                                        #
#         - 2.5: Some functionality improvements which were                 #
#           important for the bot's queue, and some decorations.            #
#         - 2.4: Added the capability of setting the command trigger (was   #
#           only !) and fixed a redundant command.                          #
#         - 2.3: Some functionality improvements and added the !invite      #
#           command.                                                        #
#         - 2.2: Some functionality imporvements and added the !up command. #
#         - 2.1: Added the !cycle command.                                  #
#         - 2.0: First official release with structure and bug fixes.       #
#         - 1.9 beta: Last test release with extra commands.                #
#         - 1.8 beta: Test release with extra commands and bug fixes.       #
#         - 1.7 beta: Test release with extra commands and bug fixes.       #
#         - 1.6 beta: Test release with extra commands.                     #
#         - 1.5 beta: Test release with extra commands and bug fixes.       #
#         - 1.4 beta: Test release with major bug and functionality fixes.  #
#         - 1.3 beta: Test release with extra commands.                     #
#         - 1.2 beta: Test release with major bug fixes.                    #
#         - 1.1 beta: Test release with extra commands and major bug fixes. #
#         - 1.0 beta: First test release.                                   #
#                                                                           #
# Report bugs/suggestions to Fz@nexushells.net.                             #
#                                                                           #
# Copyright © 2005 Opposing (aka Sir_Fz)                                    #
#                                                                           #
# This program is free software; you can redistribute it and/or modify      #
# it under the terms of the GNU General Public License as published by      #
# the Free Software Foundation; either version 2 of the License, or         #
# (at your option) any later version.                                       #
#                                                                           #
# This program is distributed in the hope that it will be useful,           #
# but WITHOUT ANY WARRANTY; without even the implied warranty of            #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             #
# GNU General Public License for more details.                              #
#                                                                           #
# You should have received a copy of the GNU General Public License         #
# along with this program; if not, write to the Free Software               #
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA #
#                                                                           #
#############################################################################
#
##############################
# Configurations start here: #
# __________________________ #

## Set Commands script logo:
set fzcom(logo) "\[\002Shrider\002\]"

## Set default bantime for ban commands if no bantime was specified (in minutes, 0 means unlimited):
set fzcom(btime) "30"

## Set the command trigger.
## example: if you use "!" then commands are tiggerd like this: !command.
set fzcom(trigger) "!"

## Set Chanserv's nick.
## example: "CHANSERV" or "PRIVMSG chanserv@services.dal.net":
set fzcom(chanserv) "CHANSERV"

## Set Chanserv's op command.
## example: "op %chan %botnick" where %chan is #channel and %botnick is the bot's nick.
set fzcom(chanservop) "op %chan %botnick"

## Set what hostmask type you want to use in the script's bans:
### Available types:
# 0: *!user@full.host.tld 
# 1: *!*user@full.host.tld 
# 2: *!*@full.host.tld 
# 3: *!*user@*.host.tld 
# 4: *!*@*.host.tld 
# 5: nick!user@full.host.tld 
# 6: nick!*user@full.host.tld 
# 7: nick!*@full.host.tld 
# 8: nick!*user@*.host.tld 
# 9: nick!*@*.host.tld
set fzcom(btype) 2

# Configurations end here. #
############################
#
######################################################################
# Code starts here, please do not edit anything unless you know TCL: #
# __________________________________________________________________ #

set fzcmdlist {op deop voice devoice kick bankick +ban -ban +gban -gban ban unban part
 master owner host access banlist gbanlist chattr user join cmode cycle up invite cmdhelp}

unbind msg - pass *msg:pass
foreach fzcmd $fzcmdlist {
 bind msg mo|mo $fzcmd fz:$fzcmd
}
bind pubm mo|mo * fz:pubcom
bind msg p|p pass fz:mpass
bind msg p|p auth fz:mauth
bind msg p|p deauth fz:mdeauth
bind part p|p * fz:pdeauth
bind sign p|p * fz:pdeauth

proc fz:pubcom {nick uhost hand chan arg} {
 global fzcom botnick botname
 if {[string first $fzcom(trigger) $arg] != 0} {return 0}
 switch -- [string tolower [lindex [lindex [split $arg $fzcom(trigger)] 1] 0]] {
  "op" {
   if {![check:auth $nick $hand]} {return 0}
   if {![botisop $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): I'm not oped on $chan."
    return 0
   }
   if {[lindex [split $arg] 1] == ""} {
    if {![isop $nick $chan]} {
     putquick "MODE $chan +o $nick"
     puthelp "NOTICE $nick :$fzcom(logo): Oped you on $chan."
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): You are already oped on $chan."
    }
   } elseif {[lindex [split $arg] 1] == "*"} {
    foreach onick [chanlist $chan] {
     pushmode $chan +o $onick
    }
    puthelp "NOTICE $nick :$fzcom(logo): Mass oped $chan."
    flushmode $chan
   } else {
    foreach onick [lrange [split $arg] 1 end] {
     if {[onchan $onick $chan]} {
      if {![isop $onick $chan]} {
       if {![isbotnick $onick]} {
        pushmode $chan +o $onick
        lappend opped $onick
       } else {
        puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me."
       }
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $onick is already oped on $chan or not on $chan."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $onick is not on $chan."
     }
    }
    if {[info exists opped]} {
     foreach wropped [wordwrap [join $opped ,] 70 ,] {
      puthelp "NOTICE $nick :$fzcom(logo): Oped $wropped on $chan."
     }
     flushmode $chan
    }
   }
   return 0
  }
  "deop" {
   if {![check:auth $nick $hand]} {return 0}
   if {![botisop $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): I'm not oped on $chan."
    return 0
   }
   if {[lindex [split $arg] 1] == ""} {
    if {[isop $nick $chan]} {
     putquick "MODE $chan -o $nick"
     puthelp "NOTICE $nick :$fzcom(logo): Deoped you on $chan."
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): You are already deoped on $chan."
    }
   } elseif {[lindex [split $arg] 1] == "*"} {
    foreach onick [chanlist $chan] {
     if {[isbotnick $onick]} { continue }
     pushmode $chan -o $onick
    }
    puthelp "NOTICE $nick :$fzcom(logo): Mass deoped $chan."
    flushmode $chan
   } else {
    foreach onick [lrange [split $arg] 1 end] {
     if {[onchan $onick $chan]} {
      if {[isop $onick $chan]} {
       if {![isbotnick $onick]} {
        pushmode $chan -o $onick
        lappend deopped $onick
       } else {
        puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me."
       }
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $onick is already deoped on $chan or not on $chan."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $onick is not on $chan."
     }
    }
    if {[info exists deopped]} {
     foreach wrdeopped [wordwrap [join $deopped ,] 70 ,] {
      puthelp "NOTICE $nick :$fzcom(logo): Deoped $wrdeopped on $chan."
     }
     flushmode $chan
    }
   }
   return 0
  }
  "voice" {
   if {![check:auth $nick $hand]} {return 0}
   if {![botisop $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): I'm not oped on $chan."
    return 0
   }
   if {[lindex [split $arg] 1] == ""} {
    if {![isvoice $nick $chan]} {
     putquick "MODE $chan +v $nick"
     puthelp "NOTICE $nick :$fzcom(logo): Voiced you on $chan."
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): You are already voiced on $chan."
    }
   } elseif {[lindex [split $arg] 1] == "*"} {
    foreach vnick [chanlist $chan] {
     pushmode $chan +v $vnick
    }
    puthelp "NOTICE $nick :$fzcom(logo): Mass voiced $chan."
    flushmode $chan
   } else {
    foreach vnick [lrange [split $arg] 1 end] {
     if {[onchan $vnick $chan]} {
      if {![isvoice $vnick $chan]} {
       if {![isbotnick $vnick]} {
        pushmode $chan +v $vnick
        lappend voiced $vnick
       } else {
        puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me."
       }
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $vnick is already voiced on $chan or not on $chan."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $vnick is not on $chan."
     } 
    }
    if {[info exists voiced]} {
     foreach wrvoiced [wordwrap [join $voiced ,] 70 ,] {
      puthelp "NOTICE $nick :$fzcom(logo): Voiced $wrvoiced on $chan."
     }
     flushmode $chan
    }
   }
   return 0
  }
  "devoice" {
   if {![check:auth $nick $hand]} {return 0}
   if {![botisop $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): I'm not oped on $chan."
    return 0
   }
   if {([lindex [split $arg] 1] == "")} {
    if {[isvoice $nick $chan]} {
     putquick "MODE $chan -v $nick"
     puthelp "NOTICE $nick :$fzcom(logo): Devoiced you on $chan."
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): You are already devoiced on $chan."
    }
   } elseif {[lindex [split $arg] 1] == "*"} {
    foreach vnick [chanlist $chan] {
     pushmode $chan -v $vnick
    }
    puthelp "NOTICE $nick :$fzcom(logo): Mass devoiced $chan."
    flushmode $chan
   } else {
    foreach vnick [lrange [split $arg] 1 end] {
     if {[onchan $vnick $chan]} {
      if {[isvoice $vnick $chan]} {
       if {![isbotnick $vnick]} {
        pushmode $chan -v $vnick
        lappend devoiced $vnick
       } else {
        puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me."
       }
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $vnick is already devoiced on $chan or not on $chan."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $vnick is not on $chan."
     }
    }
    if {[info exists devoiced]} {
     foreach wrdevoiced [wordwrap [join $devoiced ,] 70 ,] {
      puthelp "NOTICE $nick :$fzcom(logo): Devoiced $wrdevoiced on $chan."
     }
     flushmode $chan
    }
   }
   return 0
  }
  "kick" {
   if {![check:auth $nick $hand]} {return 0}
   if {![botisop $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): I'm not oped on $chan."
    return 0
   }
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)kick <nick1,nick2,..> \[reason\]."
    return 0
   }
   set knicks [split [lindex [split $arg] 1] ,]
   if {[join [lrange [split $arg] 2 end]] == ""} {
    set kreason "$fzcom(logo): Requested by $nick."
   } else {
    set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end]]"
   }
   foreach knick $knicks {
    if {[onchan $knick $chan]} {
     if {![isbotnick $knick] && ![matchattr [nick2hand $knick] mo|mo $chan]} {
      putquick "KICK $chan $knick :$kreason"
      lappend kicked $knick
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me, no kicking of a master." 
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $knick is not on $chan."
    }
   }
   if {[info exists kicked]} {
    foreach wrkicked [wordwrap [join $kicked ,] 70 ,] {
     puthelp "NOTICE $nick :$fzcom(logo): Kicked $wrkicked from $chan."
    }
   }
   return 0
  }
  "bankick" {
   if {![check:auth $nick $hand]} {return 0}
   if {![botisop $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): I'm not oped on $chan."
    return 0
   }
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)bankick <nick1/ban1,nick2/ban1,..> \[reason\] \[bantime\]."
    return 0
   }
   set knicks [split [lindex [split $arg] 1] ,]
   if {[llength [lrange [split $arg] 2 end]] == 1} {
    if {[string is integer [lindex [split $arg] end]]} {
     set kreason "$fzcom(logo): Requested by $nick."
     set btime "[lindex [split $arg] end]"
    } else {
     set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end]]"
     set btime "$fzcom(btime)"
    }
   } elseif {[llength [lrange [split $arg] 2 end]] > 1} {
    if {[string is integer [lindex [split $arg] end]]} {
     set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end-1]]"
     set btime "[lindex [split $arg] end]"
    } else {
     set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end]]"
     set btime "$fzcom(btime)"
    }
   } else {
    set kreason "$fzcom(logo): Requested by $nick."
    set btime "$fzcom(btime)"
   }
   foreach knick $knicks {
    if {[string match -nocase *!*@* $knick]} {
     if {![string match -nocase $knick $botname]} {
      foreach kuser [chanlist $chan] {
       if {[string match -nocase $knick $kuser![getchanhost $kuser $chan]]} {
        if {![matchattr [nick2hand $kuser] mo|mo $chan]} {
         pushmode $chan +b $knick
         putquick "KICK $chan $kuser :$kreason"
         lappend thebanked($knick) $kuser
        } {
         puthelp "NOTICE $nick :$fzcom(logo): I will not bankick a master/owner ($kuser matching $knick)"
        }
       }
      }
      if {![info exists thebanked]} {
       puthelp "NOTICE $nick :$fzcom(logo): There are no nicks matching $knick on $chan."
      } {
       if {[lsearch -exact [array names thebanked] $knick] == -1} {
        puthelp "NOTICE $nick :$fzcom(logo): There are no nicks matching $knick on $chan."
       }
      }
      flushmode $chan
     } {
      puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me, I will not bankick myself"
     }
    } {
     if {[onchan $knick $chan]} {
      if {![isbotnick $knick] && ![matchattr [nick2hand $knick] mo|mo $chan]} {
       pushmode $chan +b [set bmask [cmdbtype $knick![getchanhost $knick $chan] $fzcom(btype)]]
       putquick "KICK $chan $knick :$kreason"
       timer $btime [list pushmode $chan -b $bmask]
       lappend bankicked $knick
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me, no bankicking a master."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $knick is not on $chan."
     }
    }
   }
   if {[info exists bankicked]} {
    foreach wrbankicked [wordwrap [join $bankicked ,] 70 ,] {
     puthelp "NOTICE $nick :$fzcom(logo): Bankicked $wrbankicked from $chan."
    }
   }
   if {[array exists thebanked]} {
    foreach banked [array names thebanked] {
     foreach wrbanked [wordwrap [join $thebanked($banked) ,] 70 ,] {
      puthelp "NOTICE $nick :$fzcom(logo): Bankicked $wrbanked matching $banked on $chan."
     }
    }
   }
   flushmode $chan
   return 0
  }
  "+ban" {
   if {![check:auth $nick $hand]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)+ban <nick1/ban1,nick2/ban2,..> \[reason\] \[bantime\]."
    return 0
   }
   set knicks [split [lindex [split $arg] 1] ,]
   if {[llength [lrange [split $arg] 2 end]] == 1} {
    if {[string is integer [lindex [split $arg] end]]} {
     set kreason "$fzcom(logo): Requested by $nick."
     set btime "[lindex [split $arg] end]"
    } else {
     set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end]]"
     set btime "$fzcom(btime)"
    }
   } elseif {[llength [lrange [split $arg] 2 end]] > 1} {
    if {[string is integer [lindex [split $arg] end]]} {
     set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end-1]]"
     set btime "[lindex [split $arg] end]"
    } else {
     set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end]]"
     set btime "$fzcom(btime)"
    }
   } else {
    set kreason "$fzcom(logo): Requested by $nick."
    set btime "$fzcom(btime)"
   }
   foreach knick $knicks {
    if {[string match -nocase *!*@* $knick]} {
     if {![string match -nocase $knick $botname]} {
      newchanban $chan $knick $nick "$kreason" $btime
      lappend ibanned $knick
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me, I won't ban myself."
     }
    } else {
     if {![isbotnick $knick] && ![matchattr [nick2hand $knick] mo|mo $chan]} {
      if {[onchan $knick $chan]} {
       newchanban $chan [set bmask [cmdbtype $knick![getchanhost $knick $chan] $fzcom(btype)]] $nick "$kreason" $btime
       lappend ibanned "$knick ($bmask)"
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $knick is not on $chan."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me, no banning a master."
     }
    }
   }
   if {[info exists ibanned]} {
    foreach wribanned [wordwrap [join $ibanned ,] 70 ,] {
     puthelp "NOTICE $nick :$fzcom(logo): Added $wribanned to my $chan banlist."
    }
    flushmode $chan
   }
   return 0
  }
  "-ban" {
   if {![check:auth $nick $hand]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)-ban <nick1/ban1> <nick2/ban2>..."
    return 0
   }
   foreach kban [lrange [split $arg] 1 end] {
    if {[string match -nocase *!*@* $kban]} {
     if {[isban $kban $chan]} {
      killchanban $chan $kban
      lappend ibanned $kban
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $kban is not on my $chan banlist."
     }
    } else {
     if {[onchan $kban $chan]} {
      foreach chanban [banlist $chan] {
       if {[string match -nocase "[lindex [split $chanban] 0]" "$kban![getchanhost $kban $chan]"]} {
        killchanban $chan $chanban
        lappend ibanned "$kban ([lindex [split $chanban] 0])"
        break
       }
      }
      if {[info exists ibanned]} {
       if {[lsearch -exact $ibanned "$kban ([lindex [split $chanban] 0])"] == -1} {
        puthelp "NOTICE $nick :$fzcom(logo): $kban is not in my $chan banlist."
       }
      } {
       puthelp "NOTICE $nick :$fzcom(logo): $kban is not in my $chan banlist."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $kban is not on $chan."
     }
    }
   }
   if {[info exists ibanned]} {
    foreach wribanned [wordwrap [join $ibanned ,] 70 ,] {
     puthelp "NOTICE $nick :$fzcom(logo): Removed $wribanned from my $chan banlist."
    }
   }
   return 0
  }
  "+gban" {
   if {![check:auth $nick $hand]} {return 0}
   if {![matchattr $hand n]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)+gban <nick1/ban1,nick2/ban2,..> \[reason\] \[bantime\]."
    return 0
   }    
   set knicks [split [lindex [split $arg] 1] ,]
   if {[llength [lrange [split $arg] 2 end]] == 1} {
    if {[string is integer [lindex [split $arg] end]]} {
     set kreason "$fzcom(logo): Requested by $nick."
     set btime "[lindex [split $arg] end]"
    } else {
     set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end]]"
     set btime "$fzcom(btime)"
    }
   } elseif {[llength [lrange [split $arg] 2 end]] > 1} {
    if {[string is integer [lindex [split $arg] end]]} {
     set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end-1]]"
     set btime "[lindex [split $arg] end]"
    } else {
     set kreason "$fzcom(logo): ($nick) [join [lrange [split $arg] 2 end]]"
     set btime "$fzcom(btime)"
    }
   } else {
    set kreason "$fzcom(logo): Requested by $nick."
    set btime "$fzcom(btime)"
   }
   foreach knick $knicks {
    if {[string match -nocase *!*@* $knick]} {
     if {![string match -nocase $knick $botname]} {
      newban $knick $nick "$kreason" $btime
      lappend gbanned $knick
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me, I won't gban myslef."
     }
    } else {
     if {![isbotnick $knick] && ![matchattr [nick2hand $knick] mo|mo $chan]} {
      if {[onchan $knick $chan]} {
       newban [set bmask [cmdbtype $knick![getchanhost $knick $chan] $fzcom(btype)]] "$kreason" $btime
       lappend gbanned "$knick ($bmask)"
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $knick is not on $chan."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me, no gbanning a master."
     }
    }
   }
   if {[info exists gbanned]} {
    foreach wrgbanned [wordwrap [join $gbanned ,] 70 ,] {
     puthelp "NOTICE $nick :$fzcom(logo): Added $wrgbanned to my global banlist."
    }
    flushmode $chan
   }
   return 0
  }
  "-gban" {
   if {![check:auth $nick $hand]} {return 0}
   if {![matchattr $hand n]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)-gban <nick1/ban1> <nick2/ban2>..."
    return 0
   }
   foreach kban [lrange [split $arg] 1 end] {
    if {[string match -nocase *!*@* $kban]} {
     if {[isban $kban]} {
      killban $kban
      lappend gbanned $kban
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $kban does not exists in my global banlist."
     }
    } else {
     if {[onchan $kban $chan]} {
      foreach chanban [banlist] {
       if {[string match -nocase "[lindex [split $chanban] 0]" "$kban![getchanhost $kban $chan]"]} {
        killban $chanban
        lappend gbanned "$kban ([lindex [split $chanban] 0])"
        break
       }
      }
      if {[info exists gbanned]} {
       if {[lsearch -exact $gbanned "$kban ([lindex [split $chanban] 0])"] == -1} {
        puthelp "NOTICE $nick :$fzcom(logo): $kban does not exist in my global banlist."
       }
      } {
       puthelp "NOTICE $nick :$fzcom(logo): $kban does not exist in my global banlist."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $kban is not on $chan."
     }
    }
   }
   if {[info exists gbanned]} {
    foreach wrgbanned [wordwrap [join $gbanned ,] 70 ,] {
     puthelp "NOTICE $nick :$fzcom(logo): Removed $wrgbanned from my global banlist."
    }
   }
   return 0
  }
  "ban" {
   if {![check:auth $nick $hand]} {return 0}
   if {![botisop $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): I'm not oped on $chan."
    return 0
   }
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)ban <nick1/ban1> <nick2/ban2>..."
    return 0
   }
   foreach ban [lrange [split $arg] 1 end] {
    if {[string match -nocase *!*@* $ban]} {
     if {![string match -nocase $ban $botname]} {
      if {![ischanban $ban $chan]} {
       pushmode $chan +b $ban
       lappend banned $ban
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $ban is already banned on $chan."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me, I will not ban myself."
     }
    } else {
     if {![isbotnick $ban] && ![matchattr [nick2hand $ban] mo|mo $chan]} {
      if {[onchan $ban $chan]} {
       pushmode $chan +b [set bmask [cmdbtype $ban![getchanhost $ban $chan] $fzcom(btype)]]
       lappend banned "$ban ($bmask)"
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $ban is not on $chan."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): can't outsmart me, no banning of masters."
     }
    }
   }
   if {[info exists banned]} {
    foreach wrbanned [wordwrap [join $banned ,] 70 ,] {
     puthelp "NOTICE $nick :$fzcom(logo): Banned $wrbanned on $chan."
    }
    flushmode $chan
   }
   return 0
  }
  "unban" {
   if {![check:auth $nick $hand]} {return 0}
   if {![botisop $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): I'm not oped on $chan."
    return 0
   }
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)unban <nick1/ban1/*> <nick2/ban2>..."
    return 0
   }
   if {[lindex [split $arg] 1] == "*"} {
    if {[chanbans $chan] == ""} {
     puthelp "NOTICE $nick :$fzcom(logo): there are no channel bans in $chan."
    } else {
     foreach ban [chanbans $chan] {
      pushmode $chan -b "[lindex [split $ban] 0]"
     }
     flushmode $chan
     puthelp "NOTICE $nick :$fzcom(logo): Cleared channel bans on $chan."
    }
   } else {
    foreach ban [lrange [split $arg] 1 end] {
     if {[string match -nocase *!*@* $ban]} {
      if {[ischanban $ban $chan]} {
       pushmode $chan -b $ban
       lappend unbanned $ban
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $ban is not banned on $chan."
      }
     } else {
      if {[onchan $ban $chan]} {
       foreach chanban [chanbans $chan] {
        if {[string match -nocase "[lindex [split $chanban] 0]" "$ban![getchanhost $ban $chan]"]} {
         pushmode $chan -b [lindex [split $chanban] 0]
         lappend unbanned "$ban ([lindex [split $chanban] 0])"
         break
        }
       }
       if {[info exists unbanned]} {
        if {[lsearch -exact $unbanned "$ban ([lindex [split $chanban] 0])"] == -1} {
         puthelp "NOTICE $nick :$fzcom(logo): $ban is not banned on $chan."
        }
       } {
        puthelp "NOTICE $nick :$fzcom(logo): $ban is not banned on $chan."
       }
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $ban is not on $chan."
      }
     }
    }
    if {[info exists unbanned]} {
     foreach wrunbanned [wordwrap [join $unbanned ,] 70 ,] {
      puthelp "NOTICE $nick :$fzcom(logo): Removed $wrunbanned on $chan."
     }
     flushmode $chan
    }
   }
   return 0
  }
  "master" {
   if {![check:auth $nick $hand]} {return 0}
   if {![matchattr $hand n|n $chan]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)master <add/del> <nick>."
    return 0
   }
   if {[string equal -nocase "add" "[lindex [split $arg] 1]"]} {
    if {[lindex [split $arg] 2] == ""} {
     puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)master <add/del> <nick>."
     return 0
    }
    if {[isbotnick [lindex [split $arg] 2]]} {
     puthelp "NOTICE $nick :$fzcom(logo): You can't add/del me from masters."
     return 0
    }
    if {[onchan [set anick [lindex [split $arg] 2]] $chan]} {
     if {![validuser [nick2hand $anick]]} {
      if {![validuser $anick]} {
       adduser $anick [maskhost [getchanhost $anick $chan]]
      }
      chattr $anick |+mo $chan
      puthelp "NOTICE $nick :$fzcom(logo): added $anick ([maskhost [getchanhost $anick $chan]]) as master on $chan."
      puthelp "NOTICE $anick :$fzcom(logo): You've been added as master on $chan, '/msg $botnick pass <password>' to set your pass."
     } else {
      if {[matchattr [nick2hand $anick] |mo $chan]} {
       puthelp "NOTICE $nick :$fzcom(logo): $anick already is a master on $chan."
      } else {
       chattr [nick2hand $anick] |+mo $chan
       puthelp "NOTICE $nick :$fzcom(logo): Gave +mo to $anick ([nick2hand $anick]) on $chan."
       if {[passwdok [nick2hand $anick] ""]} {
        puthelp "NOTICE $anick :$fzcom(logo): you've been added as master on $chan, '/msg $botnick pass <password>' to set your pass."
       } else {
        puthelp "NOTICE $anick :$fzcom(logo): You've ([nick2hand $anick]) been added as master on $chan, use your current set pass or msg admin to change it."
       }
      }
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $anick is not on $chan."
    }
   } elseif {[string equal -nocase "del" "[lindex [split $arg] 1]"]} {
    if {[lindex [split $arg] 2] == ""} {
     puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)master <add/del> <nick>."
     return 0
    }
    if {[isbotnick [lindex [split $arg] 2]]} {
     puthelp "NOTICE $nick :$fzcom(logo): You can't add/del me from master."
     return 0
    }
    if {[onchan [set anick [lindex [split $arg] 2]] $chan]} {
     if {![validuser [nick2hand $anick]] || ![matchattr [nick2hand $anick] |mo $chan]} {
      puthelp "NOTICE $nick :$fzcom(logo): $anick is not a master on $chan."
     } else {
      chattr [nick2hand $anick] |-mo $chan
      puthelp "NOTICE $nick :$fzcom(logo): $anick ([nick2hand $anick]) has been removed from master on $chan."
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $anick is not on $chan."
    }
   } else {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)master <add/del> <nick>."
   }
   return 0
  }
  "owner" {
   if {![check:auth $nick $hand]} {return 0}
   if {![matchattr $hand n]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)owner <add/del> <nick>."
    return 0
   }
   if {[string equal -nocase "add" "[lindex [split $arg] 1]"]} {
    if {[lindex [split $arg] 2] == ""} {
     puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)owner <add/del> <nick>."
     return 0
    }
    if {[isbotnick [lindex [split $arg] 2]]} {
     puthelp "NOTICE $nick :$fzcom(logo): You can't add/del me from owners."
     return 0
    }
    if {[onchan [set anick [lindex [split $arg] 2]] $chan]} {
     if {![validuser [nick2hand $anick]]} {
      if {![validuser $anick]} {
       adduser $anick [maskhost [getchanhost $anick $chan]]
      }
      chattr $anick |+n $chan
      puthelp "NOTICE $nick :$fzcom(logo): added $anick ([maskhost [getchanhost $anick $chan]]) as owner on $chan."
      puthelp "NOTICE $anick :$fzcom(logo): You've been added as owner on $chan, '/msg $botnick pass <password>' to set your pass."
     } else {
      if {[matchattr [nick2hand $anick] |n $chan]} {
       puthelp "NOTICE $nick :$fzcom(logo): $anick already is an owner on $chan."
      } else {
       chattr [nick2hand $anick] |+n $chan
       puthelp "NOTICE $nick :$fzcom(logo): Gave +n to $anick ([nick2hand $anick]) on $chan."
       if {[passwdok [nick2hand $anick] ""]} {
        puthelp "NOTICE $anick :$fzcom(logo): you've been added as owner on $chan, '/msg $botnick pass <password>' to set your pass."
       } else {
        puthelp "NOTICE $anick :$fzcom(logo): You've ([nick2hand $anick]) been added as owner on $chan, use your current password or msg bot owner to change it."
       }
      }
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $anick is not on $chan."
    }
   } elseif {[string equal -nocase "del" "[lindex [split $arg] 1]"]} {
    if {[lindex [split $arg] 2] == ""} {
     puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)owner <add/del> <nick>."
     return 0
    }
    if {[isbotnick [lindex [split $arg ]2]]} {
     puthelp "NOTICE $nick :$fzcom(logo): You can't add/del me from owners."
     return 0
    }
    if {[onchan [set anick [lindex [split $arg] 2]] $chan]} {
     if {![validuser [nick2hand $anick]] || ![matchattr [nick2hand $anick] |n $chan]} {
      puthelp "NOTICE $nick :$fzcom(logo): $anick is not an owner on $chan."
     } else {
      chattr [nick2hand $anick] |-n $chan
      puthelp "NOTICE $nick :$fzcom(logo): $anick ([nick2hand $anick]) has been removed from owner on $chan."
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $anick is not on $chan."
    }
   } else {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)owner <add/del> <nick>."
   }
   return 0
  }
  "host" {
   if {![check:auth $nick $hand]} {return 0}
   if {![matchattr $hand n|n $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): You don't have access to manage hosts."
    return 0
   }
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)host nick/user:<nick/user> <add/del/list> <host> ."
    return 0
   }
   if {[isbotnick [lindex [split $arg] 1]]} {
    puthelp "NOTICE $nick :$fzcom(logo): You can't add/del/list hosts on me."
    return 0
   }
   if {[string equal -nocase "nick" "[lindex [split [lindex [split $arg] 1] :] 0]"]} {
    if {[onchan [set anick [lindex [split [lindex [split $arg] 1] :] 1]] $chan]} {
     if {[validuser [nick2hand $anick]]} {
      if {[matchattr [nick2hand $anick] m|m $chan] && ![matchattr $hand n|n $chan]} {
       puthelp "NOTICE $nick :$fzcom(logo): You can't manipulate a master/owners flags if you're not an owner."
       return 0
      }
      if {[string equal -nocase "add" "[lindex [split $arg] 2]"]} {
       if {[lindex [split $arg] 3] == ""} {
        puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)host nick/user:<nick/user> <add/del/list> <host>."
        return 0
       } elseif {[string match -nocase "*!*@*" "[lindex [split $arg] 3]"]} {
        setuser [nick2hand $anick] HOSTS [lindex [split $arg] 3]
        puthelp "NOTICE $nick :$fzcom(logo): Added [lindex [split $arg] 3] to [nick2hand $anick]'s hosts."
       } else {
        puthelp "NOTICE $nick :$fzcom(logo): [lindex [split $arg] 3] is not a valid host (i.e. nick!ident@host)."
       }
      } elseif {[string equal -nocase "del" "[lindex [split $arg] 2]"]} {
       if {[lindex [split $arg] 3] == ""} {
        puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)host nick/user:<nick/user> <add/del/list> <host>."
        return 0
       } elseif {[string match -nocase "*!*@*" "[lindex [split $arg] 3]"]} {
        delhost [nick2hand $anick] [lindex [split $arg] 3]
        puthelp "NOTICE $nick :$fzcom(logo): Deleted [lindex [split $arg] 3] from [nick2hand $anick]'s hosts."
       } else {
        puthelp "NOTICE $nick :$fzcom(logo): [lindex [split $arg] 3] is not a valid host (i.e. nick!ident@host)."
       }
      } elseif {[string equal -nocase "list" "[lindex [split $arg] 2]"]} {
       foreach host [getuser [nick2hand $anick] HOSTS] {
        lappend hosts "$host"
       }
       foreach hostwrap [wordwrap $hosts] {
        puthelp "NOTICE $nick :$fzcom(logo): Hosts for $anick ([nick2hand $anick]): $hostwrap"
       }
      } else {
       puthelp "NOTIE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)host nick:user:<nick/user> <add/del/list> <host>."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $anick doesn't exist in my userlist."
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $anick is not on $chan."
    }
   } elseif {[string equal -nocase "user" "[lindex [split [lindex [split $arg] 1] :] 0]"]} {
    if {[validuser [set anick [lindex [split [lindex [split $arg] 1] :] 1]]]} {
     if {[matchattr $anick m|m $chan] && ![matchattr $hand n|n $chan]} {
      puthelp "NOTICE $nick :$fzcom(logo): You can't manipulate a master/owner's hosts unless you're an owner."
      return 0
     }
     if {[string equal -nocase "add" "[lindex [split $arg] 2]"]} {
      if {[lindex [split $arg] 3] == ""} {
       puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)host nick/user:<nick/user> <add/del/list> <host>."
       return 0
      } elseif {[string match -nocase "*!*@*" "[lindex [split $arg] 3]"]} {
       setuser $anick HOSTS [lindex [split $arg] 3]
       puthelp "NOTICE $nick :$fzcom(logo): Added [lindex [split $arg] 3] to ${anick}'s hosts."
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): [lindex [split $arg] 3] is not a valid host (i.e. nick!ident@host)."
      }
     } elseif {[string equal -nocase "del" "[lindex [split $arg] 2]"]} {
      if {[lindex [split $arg] 3] == ""} {
       puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)host nick/user:<nick/user> <add/del/list> <host>."
       return 0
      } elseif {[string match -nocase "*!*@*" "[lindex [split $arg] 3]"]} {
       delhost $anick [lindex [split $arg] 3]
       puthelp "NOTICE $nick :$fzcom(logo): Deleted [lindex [split $arg] 3] from ${anick}'s hosts."
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): [lindex [split $arg] 3] is not a valid host (i.e. nick!ident@host)."
      }
     } elseif {[string equal -nocase "list" "[lindex [split $arg] 2]"]} {
      if {[getuser $anick HOSTS] == ""} {
       puthelp "NOTICE $nick :$fzcom(logo): User $anick has no hosts."
      } else {
       foreach host [getuser $anick HOSTS] {
        lappend hosts "$host"
       }
       foreach hostwrap [wordwrap $hosts] {
        puthelp "NOTICE $nick :$fzcom(logo): Hosts for user ${anick}: $hostwrap"
       }
      }
     } else {
      puthelp "NOTIE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)host nick/user:<nick/user> <add/del/list> <host>."
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): User $anick doesn't exist in my userlist."
    }
   } else {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)host nick/user:<nick/user> <add/del/list> <host>."
   }
   return 0
  }
  "part" {
   if {![check:auth $nick $hand]} {return 0}
   if {![matchattr $hand n|n $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): You do not have access to use this command."
    return 0
   }
   if {[validchan $chan]} {
    channel remove $chan
    puthelp "NOTICE $nick :$fzcom(logo): Removed $chan from my chanlist."
   } else {
    puthelp "NOTICE $nick :$fzcom(logo): $chan is an invalid channel."
   }
   return 0
  }
  "access" {
   if {![check:auth $nick $hand]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    if {[matchattr $hand n]} {
     puthelp "NOTICE $nick :$fzcom(logo): You have global owner access."
    } elseif {[matchattr $hand |n $chan]} {
     puthelp "NOTICE $nick :$fzcom(logo): You have owner access on $chan."
    } elseif {[matchattr $hand mo]} {
     puthelp "NOTICE $nick :$fzcom(logo): You have global master access."
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): You have master access on $chan."
    }
   } else {
    if {[onchan [set anick [lindex [split $arg] 1]] $chan]} {
     if {[matchattr [nick2hand $anick] n]} {
      puthelp "NOTICE $nick :$fzcom(logo): $anick has global owner access."
     } elseif {[matchattr [nick2hand $anick] |n $chan]} {
      puthelp "NOTICE $nick :$fzcom(logo): $anick has owner access on $chan."
     } elseif {[matchattr [nick2hand $anick] mo]} {
      puthelp "NOTICE $nick :$fzcom(logo): $anick has global master access."
     } elseif {[matchattr [nick2hand $anick] |mo $chan]} {
      puthelp "NOTICE $nick :$fzcom(logo): $anick has master access on $chan."
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $anick has no access on me."
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $anick is not on $chan."
    }
   }
   return 0
  }
  "banlist" {
   if {![check:auth $nick $hand]} {return 0}
   if {[banlist $chan] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): No $chan bans on me."
    return 0
   }
   foreach ban [banlist $chan] {
    lappend bans "[lindex [split $ban] 0]"
   }
   foreach banwrap [wordwrap $bans] {
    puthelp "NOTICE $nick :$fzcom(logo): $chan internal bans: $banwrap"
   }
   return 0
  }
  "gbanlist" {
   if {![check:auth $nick $hand]} {return 0}
   if {[banlist] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): No global bans on me."
    return 0
   }
   foreach ban [banlist] {
    lappend bans "[lindex [split $ban] 0]"
   }
   foreach banwrap [wordwrap $bans] {
    puthelp "NOTICE $nick :$fzcom(logo): global internal bans: $banwrap"
   }
   return 0
  }
  "chattr" {
   if {![check:auth $nick $hand]} {return 0}
   if {![matchattr $hand n|n $chan]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)chattr nick/user:<nick/user> <+/-flags>."
    return 0
   }
   if {[lindex [split $arg] 2] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)chattr nick/user:<nick/user> <+/-flags>."
    return 0
   }
   if {![string match \[-+\] [string index [lindex [split $arg] 2] 0]]} {
    puthelp "NOTICE $nick :$fzcom(logo): flags should be +/-flags."
    return 0
   }
   if {[string equal -nocase "nick" "[lindex [split [lindex [split $arg] 1] :] 0]"]} {
    if {[onchan [set anick [lindex [split [lindex [split $arg] 1] :] 1]] $chan]} {
     if {[matchattr [nick2hand $anick] m|m $chan] && ![matchattr $hand n|n $chan]} {
      puthelp "NOTICE $nick :$fzcom(logo): $anick is a master/owner, you can't manipulate his flags unless you're an onwer."
      return 0
     }
     if {[matchattr [nick2hand $anick] m]} {
      puthelp "NOTICE $nick :$fzcom(logo): youc can't maniplulate  global owners/masters' flags."
      return 0
     }
     if {![string match "*n*" "[lindex [split $arg] 2]"] && ![string match "*m*" "[lindex [split $arg] 2]"]} {
      if {[validuser [nick2hand $anick]]} {
       chattr [nick2hand $anick] |[lindex [split $arg] 2] $chan
       puthelp "NOTICE $nick :$fzcom(logo): gave [lindex [split $arg] 2] flags to $anick ([nick2hand $anick]) on $chan."
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): $anick does not exist in my userlist."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): You cannot give or remove the owner/master flags."
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $anick is not on $chan."
    }
   } elseif {[string equal -nocase "user" "[lindex [split [lindex [split $arg] 1] :] 0]"]} {
    if {[matchattr [lindex [split [lindex [split $arg] 1] :] 1] m|m $chan] && ![matchattr $hand n|n $chan]} {
     puthelp "NOTICE $nick :$fzcom(logo): [lindex [split [lindex [split $arg] 1] :] 1] is a master/owner and you can't manipulate his flags unless you're an owner."
     return 0
    }
    if {[matchattr [lindex [split [lindex [split $arg] 1] :] 1] n]} {
     puthelp "NOTICE $nick :$fzcom(logo): You can't manipulate global owners/masters' flags."
     return 0
    }
    if {![string match "*n*" "[lindex [split $arg] 2]"] && ![string match "*m*" "[lindex [split $arg] 2]"]} {
     if {[validuser [set anick [lindex [split [lindex [split $arg] 1] :] 1]]]} {
      chattr $anick |[lindex [split $arg] 2] $chan
      puthelp "NOTICE $nick :$fzcom(logo): gave [lindex [split $arg] 2] flags to user $anick on $chan."
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $anick does not exist in my userlist."
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): You cannot give or remove the owner/master flags."
    }
   } else {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)chattr nick/user:<nick/user> <+/-glags>."
   }
   return 0
  }
  "user" {
   if {![check:auth $nick $hand]} {return 0}
   if {![matchattr $hand n|n $chan]} {
    puthelp "NOTICE $nick :$fzcom(logo): Only owners can add/del/list users."
    return 0
   }
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)user add/del/list [user/nick]:<nick/[user]>."
    return 0
   }
   if {[string equal -nocase "add" "[lindex [split $arg] 1]"]} {
    if {[lindex [split $arg] 2] == ""} {
     puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)user add <nick>."
     return 0
    }
    if {[onchan [set anick [lindex [split $arg] 2]] $chan]} {
     if {[isbotnick $anick]} {
      puthelp "NOTICE $nick :$fzcom(logo): Can't outsmart me."
      return 0
     }
     if {![validuser [nick2hand $anick]]} {
      if {![validuser $anick]} {
       adduser $anick [maskhost [getchanhost $anick $chan]]
       puthelp "NOTICE $nick :$fzcom(logo): Added $anick with handle $anick ([maskhost [getchanhost $anick $chan]]) to my userlist."
       setuser $anick PASS [rand 9999999]
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): I already have a handle called $anick."
      }
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $anick already exists in my userlist under handle [nick2hand $anick]."
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $anick is not on $chan."
    }
   } elseif {[string equal -nocase "del" "[lindex [split $arg] 1]"]} {
    if {[lindex [split $arg] 2] == ""} {
     puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)user del nick/user:<nick/user>."
     return 0
    }
    if {[string equal -nocase "nick" "[lindex [split [lindex [split $arg] 2] :] 0]"]} {
     if {[onchan [set anick [lindex [split [lindex [split $arg] 2] :] 1]] $chan]} {
      if {[validuser [nick2hand $anick]]} {
       if {[matchattr [nick2hand $anick] m]} {
        puthelp "NOTICE $nick :$fzcom(logo): You cannot delete the global owner/master."
        return 0
       }
       deluser [nick2hand $anick]
       puthelp "NOTICE $nick :$fzcom(logo): Deleted $anick ([nick2hand $anick]) from my userlist."
      } else {
       puthelp "NOTICE $nick :$fzcom(logo): Deleted $anick does not exist in my userlist."
      }
     } else {
      puthelp "NOTICE $nick :$anick is not on $chan."
     }
    } elseif {[string equal -nocase "user" "[lindex [split [lindex [split $arg] 2] :] 0]"]} {
     if {[validuser [set anick [lindex [split [lindex [split $arg] 2] :] 1]]]} {
      if {[matchattr $anick m]} {
       puthelp "NOTICE $nick :$fzcom(logo): You cannot delete a global master/owner."
       return 0
      }
      deluser $anick
      puthelp "NOTICE $nick :$fzcom(logo): Deleted $anick from my userlist."
     } else {
      puthelp "NOTICE $nick :$fzcom(logo): $anick is not a valid user."
     }
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)user del nick/user:<nick/user>."
    }
   } elseif {[string equal -nocase "list" "[lindex [split $arg] 1]"]} {
    if {[userlist] == ""} {
     puthelp "NOTICE $nick :$fzcom(logo): No users on me."
     return 0
    }
    foreach user [userlist] {
     lappend users "$user ([chattr $user $chan])"
    }
    foreach userwrap [wordwrap [join $users { - }]] {
     puthelp "NOTICE $nick :$fzcom(logo): Users: $userwrap"
    }
   } else {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)user add/del/list \[nick/user\]:<nick>."
   }
   return 0
  }
  "cmode" {
   if {![check:auth $nick $hand]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)cmode <+/-modes> [target]."
    return 0
   }
   if {![string match \[-+\] [string index [lindex [split $arg] 1] 0]]} {
    puthelp "NOTICE $nick :$fzcom(logo): modes should be +/-modes."
    return 0
   }
   putserv "MODE $chan [lindex [split $arg] 1] [join [lrange [split $arg] 2 end]]"
   puthelp "NOTICE $nick :$fzcom(logo): Set [join [lrange [split $arg] 1 end]] on $chan."
   return 0
  }
  "cycle" {
   if {![check:auth $nick $hand]} {return 0}
   putserv "PART $chan :$fzcom(logo): Cycle request by $nick."
   puthelp "NOTICE $nick :$fzcom(logo): Cycled $chan."
   return 0
  }
  "up" {
   if {![check:auth $nick $hand]} {return 0}
   if {![botisop $chan]} {
    putserv "$fzcom(chanserv) :[string map [list %chan $chan %botnick $botnick] $fzcom(chanservop)]"
    puthelp "NOTICE $nick :$fzcom(logo): Asked chanserv for op on $chan."
   } else {
    puthelp "NOTICE $nick :$fzcom(logo): I'm already oped on $chan."
   }
   return 0
  }
  "invite" {
   if {![check:auth $nick $hand]} {return 0}
   if {[lindex [split $arg] 1] == ""} {
    puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: $fzcom(trigger)invite <nick>."
    return 0
   }
   if {[botisop $chan]} {
    putserv "INVITE [lindex [split $arg] 1] $chan"
    puthelp "NOTICE $nick :$fzcom(logo): Invited [lindex [split $arg] 1] to $chan."
   } else {
    puthelp "NOTICE $nick :$fzcom(logo): I'm not oped on $chan."
   }
   return 0
  }
  "cmdhelp" {
   if {![check:auth $nick $hand]} {return 0}
   puthelp "NOTICE $nick :$fzcom(logo): These are my public commands:"
   puthelp "NOTICE $nick :$fzcom(logo): <> means required. \[\] means not obligatory."
   puthelp "NOTICE $nick :$fzcom(logo): ## \[CommandS\] ##"
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)op \[nicks/*\]."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)deop \[nicks/*\]."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)voice \[nicks/*\]."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)devoice \[nicks/*\]."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)kick <nick1,nick2,..> \[reason\]."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)bankick <nick1/ban1,nick2/ban2,..> \[reason\] \[bantime\]."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)+ban <nick1/ban1,nick2/ban2,..> \[reason\] \[bantime\]."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)-ban <nick1/ban1> <nick2/ban2> ..."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)+gban <nick1/ban1,nick2/ban2,..> \[reason\] \[bantime\]. (owners only)"
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)-gban <nick1/ban1> <nick2/ban2> ..."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)ban <nick1/host1> <nick2/host2> ..."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)unban <nick1/host1/*> <nick2/host2> ..."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)part : Parts channel. (owners only)"
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)master <add/del> <nick>. (owners only)"
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)owner <add/del> <nick>. (global owners only)"
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)host nick/user:<nick/user> <add/del/list> <hosts>. (owners only)"
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)access \[nick\]."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)banlist."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)gbanlist."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)chattr nick/user:<nick/user> <+/-flags>. (owners only)"
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)user add/del/list \[nick/user\]:<nick/user>. (owners only)"
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)cmode <+/-modes>."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)cycle."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)up."
   puthelp "NOTICE $nick :$fzcom(logo): $fzcom(trigger)invite <nick>."
   puthelp "NOTICE $nick :$fzcom(logo): ## \[EnjoY\] ##"
   puthelp "NOTICE $nick :$fzcom(logo): '/msg $botnick cmdhelp' for private commands." 
  }
 }
 return 0
}

proc fz:op {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "op $a"
}

proc fz:deop {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "deop $a"
}

proc fz:voice {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "voice $a"
}

proc fz:devoice {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "devoice $a"
}

proc fz:kick {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "kick $a"
}

proc fz:bankick {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "bankick $a"
}

proc fz:+ban {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "+ban $a"
}

proc fz:-ban {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "-ban $a"
}

proc fz:+gban {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "+gban $a"
}

proc fz:-gban {n u h a} {
 if {![check:auth $ $h]} {return 0}
 fz:msgcom $n $u $h "-gban $a"
}

proc fz:ban {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "ban $a"
}

proc fz:unban {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "unban $a"
}

proc fz:part {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "part $a"
}

proc fz:master {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "master $a"
}

proc fz:owner {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "owner $a"
}

proc fz:host {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "host $a"
}

proc fz:access {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "access $a"
}

proc fz:banlist {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "banlist $a"
}

proc fz:gbanlist {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "gbanlist $a"
}

proc fz:chattr {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "chattr $a"
}

proc fz:user {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "user $a"
}

proc fz:join {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "join $a"
}

proc fz:cmode {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "cmode $a"
}

proc fz:cycle {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "cycle $a"
}

proc fz:up {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "up $a"
}

proc fz:invite {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h "invite $a"
}

proc fz:cmdhelp {n u h a} {
 if {![check:auth $n $h]} {return 0}
 fz:msgcom $n $u $h cmdhelp
}

proc fz:msgcom {nick uhost hand arg} {
 global fzcom botnick
 switch -- [set cmd [lindex [split $arg] 0]] {
  "gbanlist" {
   fz:pubcom $nick $uhost $hand default "$fzcom(trigger)gbanlist"
   putcmdlog "$fzcom(logo): <<$nick>> !$hand! gbanlist"
   return 0
  }
  "join" {
   if {![matchattr $hand n]} {
    puthelp "NOTICE $nick :$fzcom(logo): You don't have enough access to use this command."
    return 0
   }
   if {[string first # [set c [lindex [split $arg] 1]]] == 0} {
    if {![validchan $c]} {
     channel add $c
     puthelp "NOTICE $nick :$fzcom(logo): Joined $c."
     putcmdlog "$fzcom(logo): <<$nick>> !$hand! $arg"
    } else {
     puthelp "NOTICE $nick :$fzcom(logo): $c is already in my chanfile."
    }
   } else {
    if {$c == ""} { 
     puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: join <chan>."
    } {
     puthelp "NOTICE $nick :$fzcom(logo): $c is not valid (use \002#\002chan)."
    }
   }
   return 0
  }
  "cmdhelp" {
   puthelp "PRIVMSG $nick :$fzcom(logo): These are the private commands:"
   puthelp "PRIVMSG $nick :$fzcom(logo): <> means required. \[\] means not obligatory."
   puthelp "PRIVMSG $nick :$fzcom(logo): ## \[CommandS\] ##"
   puthelp "PRIVMSG $nick :$fzcom(logo): op <chan> \[nicks/*\]."
   puthelp "PRIVMSG $nick :$fzcom(logo): deop <chan> \[nicks/*\]."
   puthelp "PRIVMSG $nick :$fzcom(logo): voice <chan> \[nicks/*\]."
   puthelp "PRIVMSG $nick :$fzcom(logo): devoice <chan> \[nicks/*\]."
   puthelp "PRIVMSG $nick :$fzcom(logo): kick <chan> <nick1,nick2,..> \[reason\]."
   puthelp "PRIVMSG $nick :$fzcom(logo): bankick <chan> <nick1/ban1,nick2/ban2,..> \[reason\] \[bantime\]."
   puthelp "PRIVMSG $nick :$fzcom(logo): +ban <chan> <nick1/ban1,nick2/ban2,..> \[reason\] \[bantime\]."
   puthelp "PRIVMSG $nick :$fzcom(logo): -ban <chan> <nick1/ban1> <nick2/ban2> ..."
   puthelp "PRIVMSG $nick :$fzcom(logo): +gban <chan> <nick1/ban1,nick2/ban2,..> \[reason\] \[bantime\]. (owners only)"
   puthelp "PRIVMSG $nick :$fzcom(logo): -gban <chan> <nick1/ban1> <nick2/ban2> ..."
   puthelp "PRIVMSG $nick :$fzcom(logo): ban <chan> <nick1/host1> <nick2/host2> ..."
   puthelp "PRIVMSG $nick :$fzcom(logo): unban <chan> <nick1/host1/*> <nick2/host2> ..."
   puthelp "PRIVMSG $nick :$fzcom(logo): join <chan>. (global owners only)"
   puthelp "PRIVMSG $nick :$fzcom(logo): part <chan>. (owners only)"
   puthelp "PRIVMSG $nick :$fzcom(logo): master <chan> <add/del> <nick>. (owners only)"
   puthelp "PRIVMSG $nick :$fzcom(logo): owner <chan> <add/del> <nick>. (global owners only)"
   puthelp "PRIVMSG $nick :$fzcom(logo): host <chan> nick/user:<nick/user> <add/del/list> <host>. (owners only)"
   puthelp "PRIVMSG $nick :$fzcom(logo): banlist <chan>."
   puthelp "PRIVMSG $nick :$fzcom(logo): gbanlist."
   puthelp "PRIVMSG $nick :$fzcom(logo): access <chan> \[nick\]."
   puthelp "PRIVMSG $nick :$fzcom(logo): chattr <chan> nick/user:<nick/user> <+/-flags>. (owners only)"
   puthelp "PRIVMSG $nick :$fzcom(logo): user <chan> add/del/list \[nick/user\]:<nick/user>. (owners only)"
   puthelp "PRIVMSG $nick :$fzcom(logo): cmode <chan> <+/-modes>."
   puthelp "PRIVMSG $nick :$fzcom(logo): cycle <chan>."
   puthelp "PRIVMSG $nick :$fzcom(logo): up <chan>."
   puthelp "PRIVMSG $nick :$fzcom(logo): invite <chan> <nick>."
   puthelp "PRIVMSG $nick :$fzcom(logo): ## \[Auth CommandS\] ##"
   puthelp "PRIVMSG $nick :$fzcom(logo): auth <pass>: Authenticates you on me."
   puthelp "PRIVMSG $nick :$fzcom(logo): deauth <pass>: Deauthenticates you on me."
   puthelp "PRIVMSG $nick :$fzcom(logo): pass <pass>: Sets a pass to you on me if you have no pass."
   puthelp "PRIVMSG $nick :$fzcom(logo): ## \[EnjoY\] ##"
   puthelp "PRIVMSG $nick :$fzcom(logo): $fzcom(trigger)cmdhelp in channel for public commands."
   putcmdlog "$fzcom(logo): <<$nick>> !$hand! cmdhelp"
   return 0
  }
  default {
   if {![isaccessed $nick $hand [set c [lindex [split $arg] 1]]]} {return 0}
   fz:pubcom $nick $uhost $hand $c "$fzcom(trigger)$cmd [join [lrange [split $arg] 2 end]]"
   putcmdlog "$fzcom(logo): <<$nick>> !$hand! $arg"
  }
 }
 return 0
}

proc check:auth {nick hand} {
 global fzcom botnick
 if {[matchattr $hand Q]} {
  return 1
 } else {
  puthelp "NOTICE $nick :$fzcom(logo): You are not authenticated, '/msg $botnick auth <pass>' to authenticate."
  return 0
 }
}

proc isaccessed {nick hand chan} {
 global fzcom
 if {[string first # $chan] != 0} {
  puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: invite <chan> <nick>."
  return 0
 }
 if {[validchan $chan]} {
  if {[matchattr $hand mo|mo $chan]} {
   return 1
  } else {
   puthelp "NOTICE $nick :$fzcom(logo): You don't have access on $chan."
   return 0
  }
 } else {
  puthelp "NOTICE $nick :$fzcom(logo): $chan is not a valid channel (not in my chanfile.)"
  return 0
 }
}

proc fz:mpass {nick uhost hand arg} {
 global botnick fzcom
 if {[set pw [lindex [split $arg] 0]] == ""} {
  puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: /msg $botnick pass <password>" 
  return 0
 }
 if {![passwdok $hand ""]} {
  puthelp "NOTICE $nick :$fzcom(logo): Your password has been set before, you don't need to set it again. Simply type: \[/msg $botnick auth <password>\] to authenticate yourself."
  return 0
 }
 setuser $hand PASS $pw
 puthelp "NOTICE $nick :$fzcom(logo): Your password is now set to: \002$pw\002, remember your password for future use."
 putcmdlog "$fzcom(logo): <<$nick>> !$hand! Set Password."
 return 0
}

proc fz:mauth {nick uhost hand arg} {
 global botnick fzcom
 if {[set pw [lindex [split $arg] 0]] == ""} {
  puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: /msg $botnick auth <password>"
  return 0
 }
 if {[passwdok $hand ""]} {
  puthelp "NOTICE $nick :$fzcom(logo): You haven't set your password. Type: \[/msg $botnick pass <password>\] to set-up Your password."
  return 0
 }
 if {[matchattr $hand Q]} {
  puthelp "NOTICE $nick :$fzcom(logo): You have authenticate before, no need another authentication."
  return 0
 }
 if {![passwdok $hand $pw]} {
  puthelp "NOTICE $nick :$fzcom(logo): Authentication \002rejected\002!!, check out Your password."
  return 0
 }
 chattr $hand +Q
 puthelp "NOTICE $nick :$fzcom(logo): Authentication \002accepted\002!!, thank you for Your authentication."
 putcmdlog "$fzcom(logo): <<$nick>> !$hand! Authentication."
 return 0
}

proc fz:mdeauth {nick uhost hand arg} {
 global botnick fzcom
 if {[set pw [lindex [split $arg] 0]] == ""} {
  puthelp "NOTICE $nick :$fzcom(logo): SYNTAX: /msg $botnick deauth <password>"
  return 0
 }
 if {[passwdok $hand ""]} {
  puthelp "NOTICE $nick :$fzcom(logo): You haven't set your password. Type: \[/msg $botnick pass <password>\] to set-up Your password."
  return 0
 }
 if {![matchattr $hand Q]} {
  puthelp "NOTICE $nick :$fzcom(logo): You haven't authenticate at all!!, Type: \[/msg $botnick auth <password>\] to do so."
  return 0
 }
 if {![passwdok $hand $pw]} {
  puthelp "NOTICE $nick :$fzcom(logo): Deauthentication \002rejected\002!!, check out Your password."
  return 0
 }
 chattr $hand -Q
 puthelp "NOTICE $nick :$fzcom(logo): Deauthentication \002finished\002!!, remember to authenticate again before You run another PUBLIC commands."
 putcmdlog "$fzcom(logo): <<$nick>> !$hand! Deauthenticate."
 return 0
}

proc fz:pdeauth {nick uhost hand chan arg} {
 global botnick fzcom
 if {![matchattr $hand Q]} {return 0}
 chattr $hand -Q
 putlog "$fzcom(logo): \002$hand\002 no longer exist on \002$chan\002, performing Auto-deatentication."
 return 0
}

proc cmdbtype [list name [list type 3]] { 
 if {[scan $name {%[^!]!%[^@]@%s} nick user host]!=3} { 
  error "Usage: cmdbtype <nick!user@host> \[type\]" 
 } 
 if [string match {[3489]} $type] { 
  if [string match {*[0-9]} $host] { 
   set host [join [lrange [split $host .] 0 2] .].* 
  } elseif {[string match *.*.* $host]} { 
   set host *.[join [lrange [split $host .] end-1 end] .] 
  } 
 } 
 if [string match {[1368]} $type] { 
  set user *[string trimleft $user ~] 
 } elseif {[string match {[2479]} $type]} { 
  set user * 
 } 
 if [string match {[01234]} $type] { 
  set nick * 
 } 
 set name $nick!$user@$host 
}

proc wordwrap {str {len 100} {splitChr { }}} { 
   set out [set cur {}]; set i 0 
   foreach word [split [set str][unset str] $splitChr] { 
      if {[incr i [string len $word]]>$len} { 
         lappend out [join $cur $splitChr] 
         set cur [list $word] 
         set i [string len $word] 
      } { 
         lappend cur $word 
      } 
      incr i 
   } 
   lappend out [join $cur $splitChr] 
}

putlog "FzCommands.tcl v3.1 by Opposing Loaded..."
