# Q challenge auth script by perplexa

### INSTALLATION
##
## 1. Copy this script to your scripts directory (manual assumes it's scripts)
##
## 2. Edit your eggdrop config file and add the following lines to it
##
#
# set qscript(auth) DevPi
# set qscript(pass) DQ4auth
# set qscript(usermodes) +iwRx
# source scripts/qchallengeauth.tcl
#
##
## 3. Rehash your bot, the script should work.
##
### PROBLEMS
##
## Contact perplexa on irc.quakenet.org / #perplexa
##
### DO NOT CHANGE THE FOLLOWING VALUES IF NOT NECESSARY (usually not)
### Changing these might cause the script to stop working

set qscript(fullhost) "Q!TheQBot@CServe.quakenet.org";
set qscript(target) "Q@CServe.quakenet.org";
set qscript(authedmasks) {
  "CHALLENGEAUTH'd successfully."
  "You are already authed."
};
set qscript(failedmasks) {
  "Username or response incorrect, or you are already authed."
  "Too many users AUTH'd to this account."
  "Due to overload your command cannot be processed at present. Please try again in a few moments."
};
set qscript(challenge) "^CHALLENGE MD5 (\[0-9a-f\]{32})$"; # regex

####### NO NEED TO PROCEED ANY FURTHER #######

if {![info exists qscript(usermodes)]} {
  set qscript(usermodes) "";
}

if {![info exists qscript(authed)]} {
  set qscript(authed) 0;
}

if {(![info exists qscript(auth)]) || (![info exists qscript(pass)])} {
  error "You have not used to read [file tail [info script]]. Please read the installation hints and configure your bot properly.";
}

namespace eval qa {
  variable version "1.2.4";
  bind evnt -|- "init-server" [namespace current]::challenge;
  bind evnt -|- "disconnect-server" [namespace current]::deauth;
  bind raw  -|- "NOTICE" [namespace current]::response;
  namespace export challenge wait deauth response;
};

proc qa::response {from keyw args} {
 global qscript;
  set arg(1) [lindex [split [lindex $args 0] :] 1];
  if {$qscript(authed) == 0} {
    if {[string match -nocase $qscript(fullhost) $from]} {
      if {[regexp -nocase -- $qscript(challenge) $arg(1) -> md5sum]} {
        putlog "Got challenge from network service.";
        putquick "PRIVMSG $qscript(target) :CHALLENGEAUTH $qscript(auth) [md5 "$qscript(pass) $md5sum"]";
        return 1;
      }
      foreach mask $qscript(authedmasks) {
        if {[string match -nocase $mask $arg(1)]} {
          set qscript(authed) 1;
          killwait 1;
          putlog "Authenticated with network service. \[$arg(1)\]";
          return 1;
        }
      }
      foreach mask $qscript(failedmasks) {
        if {[string match -nocase $mask $arg(1)]} {
          set qscript(authed) 0
          putlog "Authentication with network service failed. \[$arg(1)\]"
          return -1;
        }
      }

    }
  }
  return 0;
}

proc qa::check {from keyw args} {
 global qscript;
  set arg(1) [clean [lindex $args 0]];
  set id [lindex $arg(1) 1];
  if {$id == 697} {
    set nick [lindex $arg(1) 2];
    set flags [lindex $arg(1) 3];
    set validcserve [string equal -nocase $nick [lindex [split $qscript(fullhost) "!"] 0]];
    if {[string match "*\\**" $flags] && $validcserve} {
      putquick "PRIVMSG $qscript(target) :CHALLENGE";
    }
    unbind raw -|- "354" [namespace current]::check;
  }
}

proc qa::checkifauthed {args} {
 global qscript;
  if {!($qscript(authed))} {
    bind raw -|- "354" [namespace current]::check;
    putquick "WHO [lindex [split $qscript(fullhost) "!"] 0] n%tnf,697";
    addtimer;
    return 1;
  }
  return 0;
}

proc qa::deauth {args} {
 global qscript;
  set qscript(authed) 0;
  addtimer;
}

proc qa::challenge {args} {
 global qscript botnick;
  if {$qscript(authed)} {return 0;}
  addtimer;
  wait;
  if {$qscript(usermodes) != ""} {
    putquick "MODE $botnick $qscript(usermodes)";
  }
  putquick "PRIVMSG $qscript(target) :CHALLENGE";
}

proc qa::wait {args} {
  foreach chan [channels] { channel set $chan +inactive; }
  utimer 30 [list [namespace current]::killwait 0];
  return 1;
}

proc qa::addtimer {args} {
  if {![string match *[clean [namespace current]::checkifauthed]* [timers]]} {
    timer 5 [namespace current]::checkifauthed;
    return 1;
  }
  return 0;
}

proc qa::killwait {args} {
  if {[lindex $args 0] == 0} {
    putlog "Got no response from network service, joining channels..";
  }
  killutimerbyname [namespace current]::killwait*
  foreach chan [channels] { channel set $chan -inactive; }
  return 1;
}

proc qa::killutimerbyname {name} {
  set return 0;
  set name [clean $name];
  foreach utimer [utimers] {
    if {[string match -nocase $name [lindex $utimer 1]]} {
      killutimer [lindex $utimer 2];
      incr return 1;
    }
  }
  return $return;
}

proc qa::clean {i} {
  regsub -all -- {([\(\)\[\]\{\}\$\"\\])} $i {\\\1} i;
  return $i;
}
