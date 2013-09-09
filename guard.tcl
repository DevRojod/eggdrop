
    # --- protection v1.4 beta

    # --- contact information

    #  Alexander Martin
    #
    #  E-Mail:   bugs@dev.alex.ip-am.de
    #  Homepage: http://fat.egg.irc.ag:1337 {http://dev.alex.ip-am.de}
    #
    #  #xela on iRC.ag {/server -m de.irc.ag 6667 -j #xela}

    #                       __ _  _            _     __   
    #    __ _ _ __ ___     / /| || |___  _____| | __ \ \  
    #   / _` | '_ ` _ \   | |_  ..  _\ \/ / _ \ |/ _` | | 
    #  | (_| | | | | | | < <|_      _|>  <  __/ | (_| |> >
    #   \__,_|_| |_| |_|  | | |_||_| /_/\_\___|_|\__,_| | 
    #                      \_\                       /_/  

    # --- copyright
    #
    # I made this script, not you, wish to touch the copyright? fuck off :)
    #
    # This software is copyrighted (c) 2005 by Alexander Martin 'am' #xela. 
    # All rights reserved. The following terms apply to all files associated with
    # the software unless explicitly disclaimed in individual files or
    # directories.
    #
    # The authors hereby grant permission to use, copy, modify, distribute,
    # and license this software for any purpose, provided that existing
    # copyright notices are retained in all copies and that this notice is
    # included verbatim in any distributions. No written agreement, license,
    # or royalty fee is required for any of the authorized uses.
    # Modifications to this software may be copyrighted by their authors and
    # need not follow the licensing terms described here, provided that the
    # new terms are clearly indicated on the first page of each file where
    # they apply.
    #
    # IN NO EVENT SHALL THE AUTHORS OR DISTRIBUTORS BE LIABLE TO ANY PARTY
    # FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
    # ARISING OUT OF THE USE OF THIS SOFTWARE, ITS DOCUMENTATION, OR ANY
    # DERIVATIVES THEREOF, EVEN IF THE AUTHORS HAVE BEEN ADVISED OF THE
    # POSSIBILITY OF SUCH DAMAGE.
    #
    # THE AUTHORS AND DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES,
    # INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY,
    # FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.  THIS SOFTWARE
    # IS PROVIDED ON AN "AS IS" BASIS, AND THE AUTHORS AND DISTRIBUTORS HAVE
    # NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
    # MODIFICATIONS.
    #
    # GOVERNMENT USE: If you are acquiring this software on behalf of the
    # U.S. government, the Government shall have only "Restricted Rights"
    # in the software and related documentation as defined in the Federal 
    # Acquisition Regulations (FARs) in Clause 52.227.19 (c) (2).  If you
    # are acquiring the software on behalf of the Department of Defense, the
    # software shall be classified as "Commercial Computer Software" and the
    # Government shall have only "Restricted Rights" as defined in Clause
    # 252.227-7013 (c) (1) of DFARs.  Notwithstanding the foregoing, the
    # authors grant the U.S. Government and others acting in its behalf
    # permission to use and distribute the software in accordance with the
    # terms specified in this license.
    #

    # --- script information

    # Punish methode 1 and 2 seems to be buggy, no way to fix it >:(

    # --- changes

    # 1.4b Bug fixed (Command: access (19.06.2005 12:15))
    # 1.3b Bug fixed (Command: access (16.06.2005 19:28))

    # --- script settings

    namespace eval ::protection::settings {

      # -- variables

        variable trigger "\$"

        variable version "1.4b"
        variable author  "Alexander Martin 'am' \{#xela\}"

        variable levels
        variable required
        variable reactions

        variable available "deopall recover clearchan invite reop unbanall"

        if {[array exists reactions]} {
          array unset reactions
        }

        array set reactions {
          "bot-kick"     {deopall}
          "mass-mode"    {deopall}
          "mass-kick"    {deopall}
          "need-invite"  {clearchan:invite}
          "need-key"     {clearchan:invite}
          "need-unban"   {unbanall:invite}
          "need-op"      {deopall:reop}
        }

        if {[array exists required]} {
          array unset required
        }

        array set required {
          "mytrigger"    {% 3 4 5 6 7 8 9 10}
          "levels"       {% 3 4 5 6 7 8 9 10}
          "methode"      {% 3 4 5 6 7 8 9 10}
          "protect"      {& 5 6 9 10}
          "topicsave"    {& 5 6 9 10}
          "status"       {% 6 10}
          "reaction"     {& 5 6 9 10}
          "adduser"      {% 5 6 9 10}
          "access"       {% 5 6 9 10}
          "deluser"      {% 10}
          "whois"        {% 5 6 9 10}
          "userlist"     {% 5 6 9 10}
          "remflags"     {& 5 6 9 10}
          "banlist"      {% 5 6 9 10}
          "maxmodes"     {& 5 6 9 10}
          "maxkicks"     {& 5 6 9 10}
          "bitchmode"    {& 5 6 9 10}
          "mode"         {% 5 6 9 10}
          "punish"       {& 5 6 9 10}
          "kickmsg"      {% 5 6 9 10}
          "kick"         {% 4 5 6 8 9 10}
          "ban"          {% 5 6 9 10}
          "unban"        {% 5 6 9 10}
          "autoop"       {% 5 6 9 10}
          "autovoice"    {% 5 6 9 10}
          "autolimit"    {% 5 6 9 10}
          "op"           {% 4 5 6 8 9 10}
          "voice"        {% 3 4 5 6 7 8 9 10}
          "deop"         {% 4 5 6 8 9 10}
          "devoice"      {% 3 4 5 6 7 8 9 10}
          "topic"        {% 5 6 9 10}
          "showcommands" {+ 3 4 5 6 7 8 9 10}
          "help"         {+ 3 4 5 6 7 8 9 10}
          "commands"     {+ 3 4 5 6 7 8 9 10}
          "modechange"   {5 6 9 10}
          "version"      {- 0}
          "copyright"    {- 0}
        }

        if {[array exists levels]} {
          array unset levels
        }

        array set levels {
           "0" {-|-}
           "1" {-|B}
           "2" {-|d}
           "3" {-|v}
           "4" {-|o}
           "5" {-|m}
           "6" {-|n}
           "7" {v|-}
           "8" {o|-}
           "9" {m|-}
          "10" {n|-}
        }

      # -- setudef {flag:string}

        # - flag

          setudef flag protection
          setudef flag onjoin-voice
          setudef flag onjoin-operator
          setudef flag bitchmode
          setudef flag topicsave
          setudef flag first-use
          setudef flag service-prot

        # - string

          setudef str kick-id
          setudef str kick-message
          setudef str protected-modes
          setudef str channel-topic
          setudef str punish-methode
          setudef str remove-flags
          setudef str maximal-modes
          setudef str maximal-kicks
          setudef str autolimit

          foreach reaction [array names ::protection::settings::reactions] {
            setudef str reaction-$reaction
          }

      # -- required module

        if {[catch { loadmodule blowfish } error]} {
          putlog "You can't use this fuckin' nice script dude, blowfish module req. >:("
          return
        }

    }

    # --- bindings

      # -- quakenet service {join:leave}

        # - leave

          bind SIGN -|- {*} ::protection::qnet:service:leave
          bind PART -|- {*} ::protection::qnet:service:leave
          bind SPLT -|- {*} ::protection::qnet:service:leave:netsplit

        # - rejoin/join

          bind JOIN -|- {*} ::protection::qnet:service:join
          bind REJN -|- {*} ::protection::qnet:service:join

      # -- incr kick counter

        bind KICK -|- {*} ::protection::incr:kickcount

      # -- timers {autolimit}

        bind TIME -|- {*} ::protection::auto:limit

      # -- auto mode on join {operator:voice:ban}

        bind JOIN -|- {*} ::protection::auto:mode

      # -- public

        bind PUBM -|- {*} ::protection::parse:public

      # -- protection

        # - topic change

          bind TOPC -|- {*} ::protection::topic:change

        # - mode change

          bind MODE -|- {*} ::protection::mode:change

        # - kick

          bind KICK -|- {*} ::protection::user:kick

      # -- need

        bind NEED -|- {*} ::protection::need:settings

    # --- script main source

    namespace eval ::protection {

      # --- quakenet service {leave:join}

        # -- join

          proc qnet:service:join { nickname hostname handle channel } {
            global reop autoop
            if {[isbotnick $nickname]} { return }
            if {[lsearch -exact [userlist |S $channel] $nickname] > -1 && [channel get $channel "protection"]} {
              putserv "PRIVMSG $channel :\001ACTION [lindex "hugs loves kisses misses" [rand 3]] $nickname \\\\\F4\001"
              foreach service [userlist |S $channel] {
                 if {$service == ""} {
                  continue
                }
                chattr $service |-S $channel
              }
              chattr $nickname |+S $channel
              if {[info exists reop($channel)] && [botisop $channel]} {
                foreach idler $reop($channel) {
                  if {![onchan $idler $channel]} {
                    continue
                  }
                  pushmode $channel +o $idler
                }
                flushmode $channel
                unset reop($channel)
              }
              if {[info exists autoop($channel)]} {
                unset autoop($channel)
                putserv "PRIVMSG $channel :Autoop on join enabled once again."
                channel set $channel +onjoin-operator -onjoin-voice         
              }
            }
          }

        # -- leave

          proc qnet:service:leave:netsplit { nickname hostname handle channel } {
            if {[isbotnick $nickname]} { return }
            if {[lsearch -exact [userlist |S $channel] $nickname] > -1 && [channel get $channel "protection"]} {
              ::protection::qnet:service:leave $nickname $hostname $handle $channel ""
            }
          }

          proc qnet:service:leave { nickname hostname handle channel reason } {
            global reop autoop
            if {[isbotnick $nickname]} { return }
            if {[lsearch -exact [userlist |S $channel] $nickname] > -1 && [channel get $channel "protection"]} {
              putserv "PRIVMSG $channel :\001ACTION hates $nickname for this :(\001"
              if {[channel get $channel "onjoin-operator"]} {
                putserv "PRIVMSG $channel :Autoop on join temporary disabled."
                channel set $channel -onjoin-operator +onjoin-voice
                set autoop($channel) 1
              }
              if {[channel get $channel "service-prot"] && [botisop $channel]} {
                foreach idler [chanlist $channel] {
                  if {[isbotnick $idler]} {
                    continue
                  } elseif {[matchattr [nick2hand $idler] mno|mno $channel]} {
                    continue
                  } elseif {![isop $idler $channel]} {
                    continue
                  } else {
                    lappend reop($channel) $idler; pushmode $channel -o $idler
                  }
                }
                flushmode $channel
              }
            }
          }

      # --- auto mode on join {operator:voice:ban}

        # -- panel

          proc auto:mode { nickname hostname handle channel } {
            global joins utimer
            if {![botisop $channel] || [isbotnick $nickname]} { return }
            if {[::protection::user:level $handle $channel] == "1"} {
              if {[string match "*users.quakenet.org" $hostname]} {
                set banmask *!*@[lindex [split $hostname "@"] 1]
              } else {
                set banmask [maskhost $hostname]
              }
              set reason "You have been BANNED from this channel."
              putserv "MODE $channel -ov+b $nickname $nickname $banmask"
              putserv "KICK $channel $nickname :[string map "\":nickname:\" \"$nickname\" \":reason:\" \"$reason\" \":counter:\" \"[expr [channel get $channel "kick-id"] + 1]\"" [join [channel get $channel "kick-message"]]]"
              return
            }
            if {[channel get $channel "onjoin-operator"] && [::protection::user:level $handle $channel] != "2"} {
              if {![onchansplit $nickname]} {
                if {![info exists joins($channel)]} {
                  set joins($channel) 1; utimer 1 [list ::protection::unset:variable joins($channel)]
                } else {
                  incr joins($channel) 1
                  if {$joins($channel) == "5"} {
                    foreach {id value} [array get utimer "*:$channel"] {
                      catch { killutimer $utimer($id) }; unset utimer($id)
                    }
                    channel set $channel -onjoin-operator; timer [expr $joins($channel) * 5] [list channel set $channel +onjoin-operator]
                    ::protection::unset:variable joins($channel); ::protection::unset:variable victims($channel)
                    putquick "PRIVMSG $channel :\001ACTION turned the autoop temporary off ...\001" -next
                    return
                  }
                }
              }
              if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                die "Uh, Oh, Yeah, you really think you can use my script without my copyright ???? :D"
              }
              set utimer($nickname:$channel) [utimer 2 [list pushmode $channel +o $nickname]]
            } elseif {[channel get $channel "onjoin-voice"]} {
              pushmode $channel +v $nickname
            }
          }

      # --- commands

        # -- parse command {public}

          # - parse public message

            proc parse:public { nickname hostname handle channel arguments } {
              ::protection::parse $nickname $hostname $handle $arguments $channel
            }

          # - redirect command to proc

            proc parse { nickname hostname handle arguments channel } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig lasthost
              set utrigger [getuser $handle XTRA trigger]
              if {[llength $utrigger] < 1} {
                set utrigger [join [string trim $::protection::settings::trigger]]
              }
              if {[lsearch -exact "NOTICE PRIVMSG" [string toupper [getuser $handle XTRA methode]]] < 0} {
                setuser $handle XTRA methode NOTICE
              }
              if {[llength $channel] > 0} {
                if {[string equal -nocase $botnick [lindex [split $arguments] 0]]} {
                  set command [string tolower [lindex [split $arguments] 1]]; set trigger "$botnick $command"
                  if {[string index [lindex [split $arguments] 2] 0] == "#" && [validchan [lindex [split $arguments] 2]]} {
                    set channel [lindex [split $arguments] 2]; set arguments [lrange [split $arguments] 3 end]
                  } else {
                    set arguments [lrange [split $arguments] 2 end]
                  }
                } elseif {[string equal -nocase [string index [lindex [split $arguments] 0] 0] $utrigger]} {
                  set trigger [lindex [split $arguments] 0]; set command [string tolower [string range [lindex [split $arguments] 0] 1 end]]
                  if {[string index [lindex [split $arguments] 1] 0] == "#" && [validchan [lindex [split $arguments] 1]]} {
                    set channel [lindex [split $arguments] 1]; set arguments [lrange [split $arguments] 2 end]
                  } else {
                    set arguments [lrange [split $arguments] 1 end]
                  }
                }
              } else {
                return
              }
              if {![info exists command] || [llength $command] < 1} {
                return
              } elseif {![info exists trigger] || [llength $trigger] < 1} {
                return
              } elseif {![info exists channel] || ![validchan $channel]} {
                return
              } elseif {![validuser $handle]} {
                return
              }
              set lastnick $nickname
              set lastargs $arguments
              set lastchan $channel
              set lastcmd  $command
              set lasttrig $trigger
              set lasthost $hostname
              set redirect $command
              if {[lsearch "op deop voice devoice" $command] > -1} {
                set redirect usermode
              } elseif {[lsearch "autoop autovoice" $command] > -1} {
                set redirect automode 
              } elseif {[lsearch "copyright version" $command] > -1} {
                set redirect authorinfo
              } elseif {[lsearch "help commands" $command] > -1} {
                set redirect showcommands
              }
              if {![info exists ::protection::settings::required($command)]} {
                return
              } elseif {[lsearch -exact "$::protection::settings::required($command)" 0] < 0 && [lsearch -exact "$::protection::settings::required($command)" [::protection::user:level $handle $channel]] < 0} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :You are not enough known on this channel \{$channel\} and can't use [string toupper $command]!"; return
              } elseif {[string index $::protection::settings::required($command) 0] == "&" && ![channel get $channel "protection"]} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :In order to use [string toupper $command] you have to enable the protection script on this channel! \{$channel\}"; return
              } elseif {[lsearch -exact "mode kick usermode topic" $redirect] > -1 && ![botisop $channel]} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :In order to use [string toupper $command] the bot requires OP on this channel! \{$channel\}"; return
              } elseif {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                putserv "PRIVMSG $channel :\001ACTION *thinks* my owner tries to touch teh fuckin' copyright >:)\001"; return
              }
              ::protection::missing:settings $channel; ::protection::command:$redirect $command $nickname $hostname $handle $channel $arguments
            }

          # -- command levels

            proc command:levels { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig lastuse
              foreach level "\{0 Without access\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A05 Channel master\} \{1 Channel auto ban list\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A06 Channel owner\} \{2 Channel auto deop list\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A07 Global auto voice list\} \{3 Channel auto voice list\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A08 Global auto operator list\} \{4 Channel auto operator list\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A0\A09 Global master\} \{10 Global owner\}" {
                if {[string length [lindex [split $level] 0]] == 1} {
                  set level "\A0$level"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :$level"
              }
            }

          # -- command methode

            proc command:methode { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig lastuse
              if {[lsearch -exact "NOTICE PRIVMSG" [string toupper [lindex [split $arguments] 0]]] < 0} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :You will receive all bot messages via [string toupper [getuser [nick2hand $lastnick] XTRA methode]]"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037notice\037|\037privmsg\037"
                return
              }
              setuser $handle XTRA methode [string toupper [lindex [split $arguments] 0]]
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Message methode successfully set to [string toupper [getuser [nick2hand $lastnick] XTRA methode]]"
            }

          # -- command authorinfo

            proc command:authorinfo { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig lastuse
              if {[info exists lastuse($command:$channel)] && [expr [unixtime] - $lastuse($command:$channel)] < 90} {
                return
              }
              set lastuse($command:$channel) [unixtime]
              putquick "PRIVMSG $channel :\001ACTION protection script v$::protection::settings::version developed by $::protection::settings::author\001"
              putquick "PRIVMSG $channel :Due to the trouble last time on quakenet, I left to my own network /server -m de.irc.ag 6667 -j #xela :)"
            }

          # -- command status

            proc command:status { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              switch -exact -- [string tolower [lindex [split $arguments] 0]] {
                "on" {
                  if {[channel get $channel "protection"]} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Protection already on."
                  } else {
                    if {![validuser Q]} {
                      adduser Q *!TheQBot@CServe.quakenet.org
                      chattr Q +afmo
                    }
                    if {![validuser L]} {
                      adduser L *!TheLBot@lightweight.quakenet.org
                      chattr L +afmo
                    }
                    if {[onchan Q $channel]} {
                      set service Q
                    } elseif {[onchan L $channel]} {
                      set service L
                    } else {
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Quakenet service bot required."
                      return
                    }
                    chattr $service |+S $channel
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Protection turned on."
                    channel set $channel +protection +autoop +service-prot +autovoice; ::protection::missing:settings $channel
                    set utrigger [getuser $handle XTRA trigger]
                    if {[llength $utrigger] < 1} {
                      set utrigger [join [string trim $::protection::settings::trigger]]
                    }
                    if {![channel get $channel "first-use"]} {
                      channel set $channel +first-use
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Thanks for choosing my protection script, please report bugs to me."
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :To get a complete list with available commands for you please type in: ${utrigger}help"
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :---"
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :v$::protection::settings::version developed by $::protection::settings::author"
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :IRC: /server -m de.irc.ag 6667 -j #xela >:)"
                    }
                  }
                }
                "off" {
                  if {![channel get $channel "protection"]} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Protection already off."
                  } else {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Protection turned off."
                    if {[regexp {[0-9]{1,}} [channel get $channel "autolimit"]] && [string match *l* [lindex [getchanmode $channel] 0]]} {
                      putquick "MODE $channel -l"; channel set $channel -autolimit
                    }
                    channel set $channel -protection
                  }
                }
                "default" {
                  if {[channel get $channel "protection"]} {
                    set status "Protection is on."
                  } else {
                    set status "Protection is off."
                  }
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :$status Please use: $lasttrig \037?#channel?\037 \037on\037|\037off\037"
                }
              }
            }

          # -- command punish

            proc command:punish { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {![regexp -- {[1-3]} [lindex [split $arguments] 0]]} {
                set methode [channel get $channel "punish-methode"]
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current channel punish methode \{$channel\} is: $methode"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Informatio\037n\037\002:\002 Avaialable methodes are: 1 \{deop\}, 2 \{kick\} and 3 \{kickban\}"
                return
              }
              channel set $channel punish-methode [lindex [split $arguments] 0]
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel punish methode \{$channel\} successfully set to: [lindex [split $arguments] 0]"
            }

          # -- command reaction

            proc command:reaction { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              set reaction [string tolower [lindex [split $arguments] 0]]
              set types    [string tolower [join [lrange [split $arguments] 1 end]]]
              if {![info exists ::protection::settings::reactions($reaction)] || $reaction == "" || $types == ""} {
                if {[info exists ::protection::settings::reactions($reaction)] && [channel get $channel "reaction-$reaction"] != ""} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Reactio\037n\037\002:\002 [string toupper $reaction] \{$channel\} -> [join [split [channel get $channel "reaction-$reaction"] ":"] ", "]"; return
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037[join [array names ::protection::settings::reactions] "\037|\037"]\037 \037?reactions?\037"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Informatio\037n\037\002:\002 Available reactions are: [join $::protection::settings::available ", "]"
                return
              }
              foreach option $types {
                if {[lsearch -exact $::protection::settings::available $option] < 0} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Invalid reaction specified: [string toupper $option]"
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Informatio\037n\037\002:\002 Available reactions are: [join $::protection::settings::available ", "]"
                  return
                }
              }
              channel set $channel reaction-$reaction [join $types ":"]
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Reaction for [string toupper $reaction] \{$channel\} successfully set to: [join $types ", "]"
            }

          # -- command userlist

            proc command:userlist { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {[string equal -nocase -global [lindex [split $arguments] 0]]} {
                set global 1; set type Global
              } else {
                set global 0; set type $channel
              }
              if {$global && [lsearch -exact "9 10" [::protection::user:level $handle $channel]] < 0} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :You are not enough known and can't view the GLOBAL userlist."; return
              }
              foreach user [userlist] {
                if {!$global && [lsearch -exact "7 8 9 10" [::protection::user:level $user $channel]] > -1} {
                  continue
                } elseif {$global && [lsearch -exact "7 8 9 10" [::protection::user:level $user $channel]] < 0} {
                  continue
                }
                set info #$user
                set usernicks ""
                foreach host [getuser $user hosts] {
                  foreach chan [channels] {
                    foreach nicks [chanlist $chan] {
                      if {[string match "*users.quakenet.org" [getchanhost $nicks]]} {
                        set userhost *!*@[lindex [split [getchanhost $nicks] "@"] 1]
                      } else {
                        set userhost [maskhost [getchanhost $nicks]]
                      }
                      if {[string match -nocase $userhost $host] && [lsearch -exact $usernicks $nicks] < 0} {
                        lappend usernicks $nicks
                      }
                    }
                  }
                }
                if {[llength $usernicks] < 1} {
                  set usernicks n/a
                }
                set info "$info \{[join $usernicks ", "]\}"
                if {![info exists userlist([::protection::user:level $user $channel])]} {
                  set userlist([::protection::user:level $user $channel]) ""
                }
                lappend userlist([::protection::user:level $user $channel]) $info
              }
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Userlisttype: $type"
              set level    11
              set total    0
              set owner    0
              set master   0
              set operator 0
              set voice    0
              set deop     0
              set banned   0         
              while {$level > 1} {
                incr level -1
                if {![info exists userlist($level)]} {
                  continue
                }
                incr total [llength $userlist($level)]
                if {$level == "10" || $level == "6"} {
                  set type "Owner"; incr owner [llength $userlist($level)]
                } elseif {$level == "9" || $level == "5"} {
                  set type "Master"; incr master [llength $userlist($level)]
                } elseif {$level == "8" || $level == "4"} {
                  set type "Operator"; incr operator [llength $userlist($level)]
                } elseif {$level == "7" || $level == "3"} {
                  set type "Voice"; incr voice [llength $userlist($level)]
                } elseif {$level == "2"} {
                  set type "Auto Deop"; incr deop [llength $userlist($level)]
                } elseif {$level == "1"} {
                  set type "Banned"; incr banned [llength $userlist($level)]
                } else {
                  continue
                }
                set list ""
                foreach user $userlist($level) {
                  if {[llength $list] == "5"} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :\{$level\} $type: [join $list ", "]"; set list ""
                  }
                  lappend list $user
                }
                if {[llength $list] != "0"} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :\{$level\} $type: [join $list ", "]"; set list ""
                }
              }
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :End of list."
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Total: $total \{owner: $owner, master: $master, operator: $operator, voice: $voice, deop: $deop, ban: $banned\}"
              if {[lsearch -exact "9 10" [::protection::user:level $handle $channel]] > -1} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :To view the global userlist please use: $lasttrig \037-global\037"
              }
            }

          # -- command mode

            proc command:mode { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {[llength [split $arguments]] < 1 || [string equal -nocase -default [lindex [split $arguments] 0]] && [join [lrange [split $arguments] 1 end]] == ""} {
                set curmodes [getchanmode $channel]
                if {$curmodes == ""} {
                  set curmodes n/a
                }
                if {[llength [channel get $channel "chanmode"]] > 0} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current default channel modes \{$channel\} are: [join [channel get $channel "chanmode"]] \{Channel Modes: $curmodes\}"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037?-default?\037 \037clear\037|\037+-modes\037"
                return
              }
              if {[string equal -nocase -default [lindex [split $arguments] 0]]} {
                if {[string equal -nocase clear [lindex [split $arguments] 1]]} {
                  channel set $channel chanmode ""
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Default channel modes \{$channel\} successfully cleared."
                  return
                }
                set default [lindex [split $arguments] 1]
                regsub -all {[cCnNtulikrspmDd\+\-]} $default "" check
                if {[llength $check] > 0} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Invalid channel mode \{$channel\} specified: [join [split $check ""] ", "]"; return
                }
                channel set $channel chanmode $default
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Default channel modes \{$channel\} successfully set to: $default"
                return
              }
              if {[string equal -nocase clear [lindex [split $arguments] 0]]} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Clear option only available for option -default."
                return
              }
              putquick "MODE $channel [join $arguments]"
            }

          # -- command topic {resynch:set:clear}

            proc command:topic { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {[llength [split $arguments]] < 1} {
                if {[llength [channel get $channel "channel-topic"]] > 0} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current saved channel topic \{$channel\} is: [join [channel get $channel "channel-topic"]]"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037new topic\037|\037resynch\037|\037clear\037|\037save\037"
                return
              }
              if {[string equal -nocase resynch [lindex [split $arguments] 0]]} {
                if {[llength [channel get $channel "channel-topic"]] < 1} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :No channel topic saved to resynch."; return
                }
                if {[onchan Q $channel]} {
                  putquick "PRIVMSG Q :SETTOPIC $channel [join [channel get $channel "channel-topic"]]"
                } else {
                  putquick "TOPIC $channel :[join [channel get $channel "channel-topic"]]"
                }
                return
              } elseif {[string equal -nocase clear [lindex [split $arguments] 0]]} {
                channel set $channel channel-topic ""
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel topic cleared. \{$channel\}"
                if {[onchan Q $channel]} {
                  putquick "PRIVMSG Q :SETTOPIC $channel \A0"
                } else {
                  putquick "TOPIC $channel :"
                }
                return
              } elseif {[string equal -nocase save [lindex [split $arguments] 0]]} {
                if {[topic $channel] == ""} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :There is currently no topic set. \{$channel\}"; return
                }
                channel set $channel channel-topic [topic $channel]
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel topic saved. \{$channel\}"
                return
              }
              channel set $channel channel-topic $arguments
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel topic saved. \{$channel\}"
              if {[onchan Q $channel]} {
                putquick "PRIVMSG Q :SETTOPIC $channel [join [channel get $channel "channel-topic"]]"
              } else {
                putquick "TOPIC $channel :[join [channel get $channel "channel-topic"]]"
              }
              if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                die "Uh, Oh, Yeah, you really think you can use my script without my copyright ???? :D"
              }
            }

          # -- command autolimit

            proc command:autolimit { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {[string equal -nocase off [lindex [split $arguments] 0]]} {
                channel set $channel autolimit ""
                if {[botisop $channel] && [string match "*l*" [lindex [split [getchanmode $channel]] 0]]} {
                  putquick "MODE $channel -l"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Autolimit successfully turned OFF in $channel"
                return
              }

              if {[string index [lindex [split $arguments] 0] 0] != "#" || ![regexp {[0-9]{1,}} [string range [lindex [split $arguments] 0] 1 end]] || [expr round([string range [lindex [split $arguments] 0] 1 end])] < 1} {
                if {[set limit [channel get $channel "autolimit"]] != ""} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current channel limit \{$channel\} is: +$limit"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037#limit\037|\037off\037"
                return
              }
              channel set $channel autolimit [expr round([string range [lindex [split $arguments] 0] 1 end])]
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel limit successfully set to +[expr round([string range [lindex [split $arguments] 0] 1 end])] \{$channel\}"
              if {![botisop $channel]} {
                return
              }
              set newlimit [expr [llength [chanlist $channel]] + [set autolimit [string range [lindex [split $arguments] 0] 1 end]]]
              if {[string match "*l*" [lindex [getchanmode $channel] 0]]} {
                regexp {\S[\s]([0-9]+)} [getchanmode $channel] "" limit
              } else {
                set limit 0
              }
              if {($newlimit == "$limit")} {
                return
              }
              if {$newlimit > $limit} {
                set difference [expr $newlimit - $limit]
              } elseif {$newlimit < $limit} {
                set difference [expr $limit - $newlimit]
              }
              if {($difference <= [expr round($autolimit * 0.5)]) && ($autolimit > 5)} {
                return
              } elseif {($difference < [expr round($autolimit * 0.38)]) && ($autolimit <= 5)} {
                return
              }
              putquick "MODE $channel +l $newlimit"
            }

          # -- command kick

            proc command:kick { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex $arguments 0]]
              set reason [join [lrange [split $arguments] 1 end]]
              if {[llength [join $victim]] < 1} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037nickname\037|\037hostmask\037 \037?reason?\037"; return
              } elseif {[regexp -- {\?|\*|\!|\@|\.|\~} [join $victim]] && [lsearch -exact "4 8" [::protection::user:level $handle $channel]] > -1} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :You are not enough known on this channel \{$channel\} and can't use hostmasks to kick other users."; return
              }
              if {[llength $reason] < 1} {
                set reason "You have been KICKED from this channel."
              }
              if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                die "Uh, Oh, Yeah, you really think you can use my script without my copyright ???? :D"
              }
              array set disallowed {
                "4" {4 5 6 7 8 9 10}
                "5" {5 6 8 9 10}
                "8" {4 5 6 8 9 10}
                "9" {10}
              }
              set id 1
              foreach user [chanlist $channel] {
                set kick 1
                if {![string equal -nocase $user $botnick] && ![string equal -nocase $user $nickname] && ![string match -nocase $victim $botname] && ![string match -nocase $victim $hostname] && ([string equal -nocase [join $victim] $user] || [string map {{*} {}} $victim] != "$victim" && [string match -nocase $victim $user![getchanhost $user]] || [string map {{?} {}} $victim] != "$victim" && [string match -nocase $victim $user])} {
                  foreach {level value} [array get disallowed] {
                    if {[::protection::user:level $handle $channel] == "$level" && [lsearch -exact "$value" [::protection::user:level [nick2hand $user] $channel]] > -1} {
                      set kick 0
                    }
                  }
                  if {$kick} {
                    set counter [expr [channel get $channel "kick-id"] + $id]
                    putquick "KICK $channel $user :[string map "\":nickname:\" \"$nickname\" \":reason:\" \"$reason\" \":counter:\" \"$counter\"" [join [channel get $channel "kick-message"]]]"
                    incr id 1            
                  }
                }
              }
            }

          # -- command mytrigger

            proc command:mytrigger { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              array set triggers {
                "1" {$} "2" {!} "3" {?} "4" {.} "5" {-}
                "6" {\B2} "7" {%} "8" {&} "9" {*} "10" {:}
              }
              if {![info exists triggers([string range [lindex [split $arguments] 0] 1 end])]} {
                if {[llength [set trigger [getuser $handle XTRA trigger]]] < 1} {
                  set trigger "[string trim $::protection::settings::trigger] \{default\}"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current personal trigger is: $trigger"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#id?\037"
                set list ""
                set id   0
                while {$id < 10} {
                  incr id 1
                  lappend list "#$id ($triggers($id))"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Available triggers are: [join $list ", "]"
                return
              }
              setuser $handle XTRA trigger $triggers([string range [lindex [split $arguments] 0] 1 end])
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Your personal trigger has been successfully set to: [getuser $handle XTRA trigger]"
            }

          # -- command protect

            proc command:protect { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              regsub -all {[cCnNbturkilmsDdp\+\-]} $arguments "" check
              if {[string match "*o*" [split $arguments]]} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :If you wish to protect deop's and/or op's please use the bitchmode option."
              }
              if {[llength [split $arguments]] < 1 || $check != ""} {
                set positiv ""; set negativ ""
                if {[lindex [channel get $channel "protected-modes"] 0] != ""} {
                  set positiv +[lindex [channel get $channel "protected-modes"] 0]
                }
                if {[lindex [channel get $channel "protected-modes"] 1] != ""} {
                  set negativ -[lindex [channel get $channel "protected-modes"] 1]
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current protected mode changes \{$channel\} are: $positiv$negativ"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037+-modes\037 \{example: +birks-bCtu\}"
                return
              }
              set positiv ""; set negativ ""; set lastmode ""
              foreach mode [string trim [split [lindex [split $arguments] 0] ""]] {
                if {$mode == "o"} {
                  continue
                } elseif {$mode == "+" || $mode == "-"} {
                  set lastmode $mode; continue
                } 
                if {$lastmode == ""} {
                  continue
                }
                if {$lastmode == "+"} {
                  append positiv $mode
                } elseif {$lastmode == "-"} {
                  append negativ $mode
                } else {
                  continue
                }                
              }
              if {$positiv == ""} {
                set positiv %
              }
              if {$negativ == ""} {
                set negativ %
              }
              if {$positiv == "%" && $negativ == "%"} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Invalid modechanges."; return
              }
              channel set $channel protected-modes "$positiv $negativ"
              if {[lindex [channel get $channel "protected-modes"] 0] != "%" && [lindex [channel get $channel "protected-modes"] 0] != ""} {
                set positiv +[lindex [channel get $channel "protected-modes"] 0]
              } else {
                set positiv ""
              }
              if {[lindex [channel get $channel "protected-modes"] 1] != "%" && [lindex [channel get $channel "protected-modes"] 1] != ""} {
                set negativ -[lindex [channel get $channel "protected-modes"] 1]
              } else {
                set negativ ""
              }
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Protected mode changes \{$channel\} set to: $positiv$negativ"
            }

          # -- command showcommands

            proc command:showcommands { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              set utrigger [getuser $handle XTRA trigger]
              if {[llength $utrigger] < 1} {
                set utrigger [join [string trim $::protection::settings::trigger]]
              }
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Available commands for userlevel \{[::protection::user:level $handle $channel]\}"
              foreach overview "\{+help commands\} \{%general commands\} \{&protection commands (+protection req.)\} \{-free for all users\}" {
                set available 0
                set list ""
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :\A0\037[string range $overview 1 end]:\037"
                foreach cmd [lsort -dictionary [array names ::protection::settings::required]] {
                  if {[lsearch -exact "$::protection::settings::required($cmd)" 0] < 0 && [lsearch -exact "$::protection::settings::required($cmd)" [::protection::user:level $handle $channel]] < 0} {
                    continue
                  } elseif {[string equal -nocase modechange $cmd]} {
                    continue
                  } elseif {[string index $::protection::settings::required($cmd) 0] != "[string index $overview 0]"} {
                    continue
                  }
                  if {[llength $list] == "10"} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :\A0\A0[join $list ", "]"; set list ""
                  }
                  lappend list $cmd
                  set available 1
                }
                if {!$available} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :No commands available for you."
                }
                if {[llength $list] != "0"} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :\A0\A0[join $list ", "]"
                }
              }
            }

          # -- command mode {op:voice:deop:devoice}

            proc command:usermode { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              switch -exact -- $command {
                "op" { set mode +o }
                "voice" { set mode +v }
                "deop" { set mode -o }
                "devoice" { set mode -v }
              }
              if {[lsearch -exact "3 4 7 8" [::protection::user:level $handle $channel]] > -1 && [llength [split $arguments]] > 0 && ![string equal -nocase $nickname [join $arguments]]} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :You are not enough known on this channel \{$channel\} and can't [string toupper $command] other users!"; return
              }
              if {[llength $arguments] < 1 || [string equal -nocase $nickname [join [split $arguments]]]} {
                putquick "MODE $channel $mode $nickname"; return
              }
              set list ""
              foreach victim $arguments {
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} $victim]
                foreach user [chanlist $channel] {
                  if {[llength $list] == "6"} {
                    putquick "MODE $channel [string index $mode 0][string repeat [string index $mode 1] [llength $list]] [join $list]" -next; set list ""
                  }
                  if {([string length $user] != "1") && ![string equal -nocase $user $botnick] && ([string equal -nocase [join $victim] $user] || [string map {{*} {}} $victim] != "$victim" && [string match -nocase $victim $user![getchanhost $user]] || [string map {{?} {}} $victim] != "$victim" && [string match -nocase $victim $user])} {
                    if {$mode == "+o" && [isop $user $channel] || [lsearch -exact "1 2" [::protection::user:level [nick2hand $user] $channel]] > -1} {
                      continue
                    } elseif {$mode == "-o" && (![isop $user $channel] || [lsearch -exact "4 5 6 8 9 10" [::protection::user:level [nick2hand $user] $channel]] > -1)} {
                      continue
                    } elseif {$mode == "-v" && (![isvoice $user $channel] || [lsearch -exact "3 4 5 6 7 8 9 10" [::protection::user:level [nick2hand $user] $channel]] > -1)} {
                      continue
                    } elseif {$mode == "+v" && [isvoice $user $channel]} {
                      continue
                    }
                    lappend list $user                    
                  }
                }
              }
              if {[llength $list] > 0} {
                putquick "MODE $channel [string index $mode 0][string repeat [string index $mode 1] [llength $list]] [join $list]"
              }
            }

         # -- command kickmsg {set:default}

            proc command:kickmsg { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {[llength [split $arguments]] < 1} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current channel kick message \{$channel\} is: [join [channel get $channel "kick-message"]]"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037?kick message?\037"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Informatio\037n\037\002:\002 You can use :nickname:, :reason: and :counter: in the kick message too."
                return
              }
              channel set $channel kick-message $arguments
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel kick message \{$channel\} has been successfully set to: [join [channel get $channel "kick-message"]]"
            }

          # -- command banlist 

            proc command:banlist { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              set id 1
              if {[string equal -nocase "-global" [lindex [split $arguments] 0]]} {
                if {[lsearch -exact "9 10" [::protection::user:level $handle $channel]] < 0} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :You are not enough known to view the GLOBAL BANLIST!"; return
                }
                foreach ban [banlist] {
                  if {[::protection::user:level $handle $channel] != 10 && ![string equal -nocase [lindex $ban 5] $handle] && [::protection::user:level [lindex $ban 5] $channel] >= [::protection::user:level $handle $channel]} {
                    continue
                  }
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :#$id [lindex $ban 0] set by [lindex $ban 5] \{[expr {([expr [lindex $ban 2] - [unixtime]] > 0) ? "auto expire ([duration [expr [lindex $ban 2] - [unixtime]]])" : "perm. banned" }]\}"
                  incr id 1
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :End of global banlist. \{Total of [llength [banlist]] [expr {([llength [banlist]] == 1) ? "Ban" : "Bans" }]\}"
                return
              }
              foreach ban [banlist $channel] {
                if {[::protection::user:level $handle $channel] != 10 && ![string equal -nocase [lindex $ban 5] $handle] && [::protection::user:level [lindex $ban 5] $channel] >= [::protection::user:level $handle $channel]} {
                  continue
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :#$id [lindex $ban 0] set by [lindex $ban 5] \{[expr {([expr [lindex $ban 2] - [unixtime]] > 0) ? "auto expire ([duration [expr [lindex $ban 2] - [unixtime]]])" : "perm. banned" }]\}"
                incr id 1
              }
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :End of $channel banlist. \{Total of [llength [banlist $channel]] [expr {([llength [banlist $channel]] == 1) ? "Ban" : "Bans" }]\}"
              if {[lsearch -exact "9 10" [::protection::user:level $handle $channel]] > -1} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :To view the global banlist please use: $lasttrig \037-global\037"
              }
            }

          # -- command whois

            # - raw result

              proc command:whois:raw:end { server raw arguments } {
                catch { unbind RAW -|- {318} ::protection::command:whois:raw:end }
                catch { unbind RAW -|- {330} ::protection::command:whois:raw:authname }
                catch { unbind RAW -|- {311} ::protection::command:whois:raw:hostname }
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global whoismask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [string trim [lindex [split $arguments] 1]]]
                if {![info exists whoismask([string tolower [join [join $victim]]])] && [string index [join [join $victim]] 0] != "#"} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Seems like that [string trim [lindex [split $arguments] 1]] is currently not online."; return
                } elseif {[string index [join [join $victim]] 0] == "#"} {
                  set handle [string range [join [join $victim]] 1 end]
                } else {
                  foreach user [userlist] {
                    foreach hostname [getuser $user hosts] {
                      foreach whoishost $whoismask([string tolower [join [join $victim]]]) {
                        if {[string match -nocase $whoishost $hostname]} {
                          set handle $user
                        }
                      }
                    }
                  }
                }
                if {![info exists handle]} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Who on earth is that?"
                  if {[info exists whoismask([string tolower [join [join $victim]]])]} {
                    unset whoismask([string tolower [join [join $victim]]])
                  }
                  return
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Information for account $handle"
                set nicknames ""
                foreach chan [channels] {
                  foreach idler [chanlist $chan] {
                    foreach hosts [getuser $handle hosts] {
                      if {[string match -nocase $hosts $idler![getchanhost $idler]] && [lsearch -exact $nicknames $idler] < 0} {
                        lappend nicknames $idler
                      }
                    }
                  }
                }
                if {$nicknames == ""} {
                  set nicknames "\{seems to be not online\}"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Account [expr {([llength $nicknames] == 1) ? "nickname" : "nicknames" }]: [join $nicknames ", "]"
                if {[matchattr $handle n]} {
                  set global "bot owner"; set level 10
                } elseif {[matchattr $handle m]} {
                  set global "bot master"; set level 9
                } elseif {[matchattr $handle o]} {
                  set global "operator"; set level 8
                } elseif {[matchattr $handle v]} {
                  set global "voice"; set level 7
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Known with [llength [getuser $handle hosts]] [expr {([llength [getuser $handle hosts]] == 1) ? "hostname" : "hostnames" }] \{[join [getuser $handle hosts] ", "]\}"
                if {[info exists global]} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Known as global $global \{Level: $level\}"
                }
                foreach chan [channels] {
                  if {![matchattr [nick2hand $lastnick] mn|mn $chan]} {
                    continue
                  } elseif {[lindex [split [chattr $handle - $chan] "|"] 1] == "-"} {
                    continue
                  } elseif {[matchattr $handle |S $chan]} {
                    continue
                  }
                  if {[matchattr $handle |n $chan]} {
                    set level 6
                  } elseif {[matchattr $handle |m $chan]} {
                    set level 5
                  } elseif {[matchattr $handle |o $chan]} {
                    set level 4
                  } elseif {[matchattr $handle |v $chan]} {
                    set level 3
                  } elseif {[matchattr $handle |B $chan]} {
                    set level 2
                  } elseif {[matchattr $handle |d $chan]} {
                    set level 1
                  } else {
                    continue
                  }
                  if {![info exists access($level)]} {
                    set access($level) $chan
                  } else {
                    lappend access($level) $chan
                  }
                }
                set curlevel 6
                while {$curlevel > 0} {
                  if {[info exists access($curlevel)]} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Access level $curlevel on [join $access($curlevel) ", "]"
                  }
                  incr curlevel -1
                }
                if {[info exists whoismask([string tolower [join [join $victim]]])]} {
                  unset whoismask([string tolower [join [join $victim]]])
                }
              }

              proc command:whois:raw:authname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global whoismask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![info exists whoismask([string tolower [join [join $victim]]])]} {
                  set whoismask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                } else {
                  lappend whoismask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                }
              }

              proc command:whois:raw:hostname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global whoismask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![string match "*users.quakenet.org" [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]} {
                  set whoismask([string tolower [join [join $victim]]]) [maskhost [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]
                }
              }

            # - panel

              proc command:whois { command nickname hostname handle channel arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                if {[llength [split $arguments]] < 1} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037nickname\037|\037#handle\037"; return
                }
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 0]]
                bind RAW -|- {311} ::protection::command:whois:raw:hostname
                bind RAW -|- {330} ::protection::command:whois:raw:authname
                bind RAW -|- {318} ::protection::command:whois:raw:end
                putquick "WHOIS [join [join $victim]]" -next
              }

          # -- command unban

            # - raw result

              proc command:unban:raw:end { server raw arguments } {
                catch { unbind RAW -|- {330} ::protection::command:unban:raw:authname }
                catch { unbind RAW -|- {311} ::protection::command:unban:raw:hostname }
                catch { unbind RAW -|- {318} ::protection::command:unban:raw:end }
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global unbanmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [string trim [lindex [split $arguments] 1]]]
                if {![info exists unbanmask([string tolower [join [join $victim]]])] && ![regexp -- {\?|\*|\!|\@|\.|\~|\#} [join [join $victim]]]} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Seems like that [string trim [lindex [split $arguments] 1]] is currently not online."; return
                }
                if {[info exists unbanmask([string tolower [join [join $victim]]])] && ![string equal -nocase "all" [join [join $victim]]]} {
                  set temp $unbanmask([string tolower [join [join $victim]]]); unset unbanmask([string tolower [join [join $victim]]]); set victim $temp
                } else {
                  if {[info exists unbanmask([string tolower [join [join $victim]]])]} {
                    unset unbanmask([string tolower [join [join $victim]]])
                  }
                  set victim [join $victim]
                }
                set unbanned 0; set id 1
                if {[string equal -nocase "-global" [lindex [split $lastargs] 1]]} {
                  if {[lsearch -exact "9 10" [::protection::user:level [nick2hand $lastnick] $lastchan]] < 0} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :You are not enough known to remove GLOBAL BANS!"; return
                  }
                  foreach ban [banlist] {
                    if {[::protection::user:level [nick2hand $lastnick] $lastchan] != 10 && ![string equal -nocase [lindex $ban 5] [nick2hand $lastnick]] && [::protection::user:level [lindex $ban 5] $lastchan] >= [::protection::user:level [nick2hand $lastnick] $lastchan]} {
                      continue
                    }
                    if {[string equal -nocase "all" $victim]} {
                      killban [lindex $ban 0]; incr unbanned 1
                    } elseif {[string index $victim 0] == "#" && [string range $victim 1 end] == "$id"} {
                      killban [lindex $ban 0]; incr unbanned 1
                    } else {
                      foreach unban $victim { 
                        if {[string match -nocase $unban [lindex $ban 0]]} {
                          killban [lindex $ban 0]; incr unbanned 1
                        }
                      }
                    }
                    incr id 1
                  }
                } else {
                  foreach ban [banlist $lastchan] {
                    if {[::protection::user:level [nick2hand $lastnick] $lastchan] != 10 && ![string equal -nocase [lindex $ban 5] [nick2hand $lastnick]] && [::protection::user:level [lindex $ban 5] $lastchan] >= [::protection::user:level [nick2hand $lastnick] $lastchan]} {
                      continue
                    }
                    if {[string equal -nocase "all" $victim]} {
                      killchanban $lastchan [lindex $ban 0]; incr unbanned 1
                    } elseif {[string index $victim 0] == "#" && [string range $victim 1 end] == "$id"} {
                      killchanban $lastchan [lindex $ban 0]; incr unbanned 1
                    } else {
                      foreach unban $victim { 
                        if {[string match -nocase $unban [lindex $ban 0]]} {
                          killchanban $lastchan [lindex $ban 0]; incr unbanned 1
                        }
                      }
                    }
                    incr id 1
                  }
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$unbanned [expr {($unbanned == 1) ? "Ban" : "Bans" }] removed."
              }

              proc command:unban:raw:authname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global unbanmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![info exists unbanmask([string tolower [join [join $victim]]])]} {
                  set unbanmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                } else {
                  lappend unbanmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                }
              }

              proc command:unban:raw:hostname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global unbanmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![string match "*users.quakenet.org" [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]} {
                  set unbanmask([string tolower [join [join $victim]]]) [maskhost [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]
                }
              }

            # - panel

              proc command:unban { command nickname hostname handle channel arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                if {[llength [split $arguments]] < 1} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037all\037|\037nickname\037|\037hostmask\037|\037#number\037 \037?-global?\037"; return
                }
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 0]]
                bind RAW -|- {311} ::protection::command:unban:raw:hostname
                bind RAW -|- {330} ::protection::command:unban:raw:authname
                bind RAW -|- {318} ::protection::command:unban:raw:end
                putquick "WHOIS [join [join $victim]]" -next
              }

          # -- command ban

            # - raw result

              proc command:ban:raw:end { server raw arguments } {
                catch { unbind RAW -|- {313} ::protection::command:ban:raw:operator }
                catch { unbind RAW -|- {318} ::protection::command:ban:raw:end }
                catch { unbind RAW -|- {311} ::protection::command:ban:raw:hostname }
                catch { unbind RAW -|- {330} ::protection::command:ban:raw:authname }
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global banmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [string trim [lindex [split $arguments] 1]]]
                if {![info exists banmask([string tolower [join [join $victim]]])] && ![regexp -- {\?|\*|\!|\@|\.|\~|\#} [join [join $victim]]]} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Seems like that [string trim [lindex [split $arguments] 1]] is currently not online."; return
                }
                if {[info exists banmask([string tolower [join [join $victim]]])]} {
                  set temp $banmask([string tolower [join [join $victim]]]); unset banmask([string tolower [join [join $victim]]]); set victim $temp
                } else {
                  set victim [join $victim]
                }
                if {[string equal -nocase "-global" [lindex [split $lastargs] 1]]} {
                  set global 1
                } else {
                  set global 0
                }
                if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                  die "Uh, Oh, Yeah, you really think you can use my script without my copyright ???? :D"
                }
                if {$global} {
                  if {[lsearch -exact "9 10" [::protection::user:level [nick2hand $lastnick] $lastchan]] < 0} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :You are not enough known to set up GLOBAL BANS!"; return
                  }
                  if {[string index [lindex [split $lastargs] 2] 0] == "%"} {
                    set duration [string range [lindex [split $lastargs] 2] 1 end]; set reason [join [lrange [split $lastargs] 3 end]]
                  } else {
                    set duration 1h; set reason [join [lrange [split $lastargs] 2 end]]
                  }
                } else {
                  if {[string index [lindex [split $lastargs] 1] 0] == "%"} {
                    set duration [string range [lindex [split $lastargs] 1] 1 end]; set reason [join [lrange [split $lastargs] 2 end]]
                  } else {
                    set duration 1h; set reason [join [lrange [split $lastargs] 1 end]]
                  }
                }
                if {$duration != "0"} {
                  set temporary 0
                  array set variables {
                    "y" {525600}
                    "w" {10080}
                    "d" {1440}
                    "h" {60}
                    "m" {1}
                  }
                  foreach {variable minutes} [array get variables] {
                    if {![regexp -nocase "(\[0-9\]{1,})$variable" $duration incr]} {
                      continue
                    }
                    incr temporary [expr [string trimright $incr $variable] * $minutes]
                  }
                  if {$temporary == "0"} {
                    set temporary 60
                  }
                  set duration $temporary
                }
                if {[string index $victim 0] == "#"} {
                  set victim *!*@[string range $victim 1 end].users.quakenet.org
                }
                if {$duration == "0" || [duration [expr $duration * 60]] == "0 seconds"} {
                  set result "\{Permanent Banned\}"; set duration 0
                } else {
                  set result "\{Temporary Banned, auto expire in [duration [expr $duration * 60]]. ([strftime "%A, %d.%m.%y - %H:%M:%S" [expr $duration * 60 + [unixtime]]])\}"
                }
                if {[llength [join $reason]] < 1} {
                  if {$global} {
                    if {$duration == "0"} {
                      set reason "You have been GLOBAL PERM BANNED from all channels."
                    } else {
                      set reason "You have been GLOBAL BANNED for [duration [expr $duration * 60]] from all channels."
                    }
                  } else {
                    if {$duration == "0"} {
                      set reason "You have been PERM BANNED from this channel. ($lastchan)"
                    } else {
                      set reason "You have been BANNED from this channel ($lastchan) for [duration [expr $duration * 60]]."
                    }
                  }
                }
                set error    0
                set banmasks $victim
                set nickname $lastnick
                set channel  $lastchan
                set reason   [join $reason]
                set counter  [expr [channel get $channel "kick-id"] + 1]
                foreach bmask $banmasks {
                  if {[string map {{*} {} {?} {} {.} {}} $bmask] == "!@" || ![regexp -- {^.+!.+@.+$} $bmask]} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$bmask is a invalid banmask. \{nickname!ident@hostname\}"; return
                  } elseif {[string match -nocase $bmask $botname]} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$bmask would match my hostname."; return
                  }
                  foreach handle [userlist mno|mno $channel] {
                    if {[lsearch [string tolower [getuser $handle hosts]] [string tolower $bmask]] > -1} {
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :$bmask would match one of my users. \{$handle\}"; return
                    }
                  }
                  if {$global} {
                    newban $bmask [nick2hand $lastnick] [string map "\":nickname:\" \"$lastnick\" \":reason:\" \"$reason\" \":counter:\" \"$counter\"" [join [channel get $channel "kick-message"]]] $duration
                  } else {
                    if {![regexp -- {\?|\*|\!|\@|\.|\~|\#} [join [lindex [split $arguments] 1]]] && [onchan [join [lindex [split $arguments] 1]] $lastchan]} {
                      putquick "KICK $channel [join [lindex [split $arguments] 1]] :[string map "\":nickname:\" \"$lastnick\" \":reason:\" \"$reason\" \":counter:\" \"$counter\"" [join [channel get $channel "kick-message"]]]"
                      putquick "MODE $channel [string repeat "b" [llength [join $banmasks]]] [join $banmasks]"
                    }
                    newchanban $lastchan $bmask [nick2hand $lastnick] [string map "\":nickname:\" \"$lastnick\" \":reason:\" \"$reason\" \":counter:\" \"$counter\"" [join [channel get $channel "kick-message"]]] $duration
                  }
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :[expr {([llength $banmasks] == 1) ? "Banmask" : "Banmasks" }] '[join $banmasks ", "]' [expr {([llength $banmasks] == 1) ? "has" : "have" }] been successfully set. $result" -next
              }

              proc command:ban:raw:authname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global banmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![info exists banmask([string tolower [join [join $victim]]])]} {
                  set banmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                } else {
                  lappend banmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                }
              }

              proc command:ban:raw:hostname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global banmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![string match "*users.quakenet.org" [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]} {
                  set banmask([string tolower [join [join $victim]]]) [maskhost [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]
                }
              }

              proc command:ban:raw:operator { server raw arguments } {
                catch { unbind RAW -|- {313} ::protection::command:ban:raw:operator }
                catch { unbind RAW -|- {330} ::protection::command:ban:raw:authname }
                catch { unbind RAW -|- {311} ::protection::command:ban:raw:hostname }
                catch { unbind RAW -|- {318} ::protection::command:ban:raw:end }
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :You are not allowed to BAN an IRC Operator/Helper/Service. \{[join [join $victim]]\}"
                if {[info exists banmask([string tolower [join [join $victim]]])]} {
                  unset banmask([string tolower [join [join $victim]]])
                }
                if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                  die "*Copyright miss* >:("
                }
              }               

            # - panel

              proc command:ban { command nickname hostname handle channel arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                if {[llength [split $arguments]] < 1} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037nickname\037|\037#authname\037|\037hostmask\037 \037?-global?\037 \037?%duration?\037 \037?reason?\037"; return
                }
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 0]]
                bind RAW -|- {311} ::protection::command:ban:raw:hostname
                bind RAW -|- {330} ::protection::command:ban:raw:authname
                bind RAW -|- {313} ::protection::command:ban:raw:operator
                bind RAW -|- {318} ::protection::command:ban:raw:end
                putquick "WHOIS [join [join $victim]]" -next
              }

          # -- command adduser

            # - raw result

              proc command:adduser:raw:end { server raw arguments } {
                catch { unbind RAW -|- {318} ::protection::command:adduser:raw:end }
                catch { unbind RAW -|- {311} ::protection::command:adduser:raw:hostname }
                catch { unbind RAW -|- {330} ::protection::command:adduser:raw:authname }
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global hostmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [string trim [lindex [split $arguments] 1]]]
                if {![info exists hostmask([string tolower [join [join $victim]]])]} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Seems like that [string trim [lindex [split $arguments] 1]] is currently not online."; return
                }
                foreach handle [userlist] {
                  foreach addhost $hostmask([string tolower [join [join $victim]]]) {
                    foreach hostname [getuser $handle hosts] {
                      if {[string match -nocase $addhost $hostname]} {
                        putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Already recognizing [string trim [lindex [split $arguments] 1]] as $handle"; return
                      }
                    }
                  }
                }
                adduser [lindex [split $lastargs] 1]
                switch -exact -- [lindex [split $lastargs] 2] {
                  "10" { chattr [lindex [split $lastargs] 1] +amnov; set level "[lindex [split $lastargs] 2] 'Bot Owner'"; foreach channel [channels] { pushmode $channel +o [string trim [lindex [split $arguments] 1]] } }
                  "9" { chattr [lindex [split $lastargs] 1] +amov; set level "[lindex [split $lastargs] 2] 'Bot Master'"; foreach channel [channels] { pushmode $channel +o [string trim [lindex [split $arguments] 1]] } }
                  "8" { chattr [lindex [split $lastargs] 1] +aov; set level "[lindex [split $lastargs] 2] 'Global Operator'"; foreach channel [channels] { pushmode $channel +o [string trim [lindex [split $arguments] 1]] } }
                  "7" { chattr [lindex [split $lastargs] 1] +av; set level "[lindex [split $lastargs] 2] 'Global Voice'"; foreach channel [channels] { pushmode $channel +v [string trim [lindex [split $arguments] 1]] } }
                  "6" { chattr [lindex [split $lastargs] 1] |+amnov $lastchan; set level "[lindex [split $lastargs] 2] 'Channel Owner'"; pushmode $lastchan +o [string trim [lindex [split $arguments] 1]] }
                  "5" { chattr [lindex [split $lastargs] 1] |+amov $lastchan; set level "[lindex [split $lastargs] 2] 'Channel Master'"; pushmode $lastchan +o [string trim [lindex [split $arguments] 1]] }
                  "4" { chattr [lindex [split $lastargs] 1] |+aov $lastchan; set level "[lindex [split $lastargs] 2] 'Channel Operator'"; pushmode $lastchan +o [string trim [lindex [split $arguments] 1]] }
                  "3" { chattr [lindex [split $lastargs] 1] |+av $lastchan; set level "[lindex [split $lastargs] 2] 'Channel Voice'"; pushmode $lastchan +v [string trim [lindex [split $arguments] 1]] }
                  "2" { chattr [lindex [split $lastargs] 1] |+d $lastchan; set level "[lindex [split $lastargs] 2] 'Autodeop'"; pushmode $lastchan -o [string trim [lindex [split $arguments] 1]] }
                  "1" {
                    chattr [lindex [split $lastargs] 1] |+B $lastchan; set level "[lindex [split $lastargs] 2] 'Banned from channel'"
                    set reason "You have been BANNED from this channel."
                    set counter [expr [channel get $lastchan "kick-id"] + 1]
                    if {[onchan [string trim [lindex [split $arguments] 1]] $lastchan]} {
                      putquick "KICK $lastchan [string trim [lindex [split $arguments] 1]] :[string map "\":nickname:\" \"$lastnick\" \":reason:\" \"$reason\" \":counter:\" \"$counter\"" [join [channel get $lastchan "kick-message"]]]"
                      putquick "MODE $lastchan [string repeat "b" [llength [join $hostmask([string tolower [join [join $victim]]])]]] [join $hostmask([string tolower [join [join $victim]]])]"
                    }
                  }
                }
                if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                  die "READD TEH FUCKIN' COPYRIGHT..."
                }
                foreach hostname $hostmask([string tolower [join [join $victim]]]) {
                  setuser [lindex [split $lastargs] 1] hosts [join $hostname]
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :[string trim [lindex [split $arguments] 1]] \{[join $hostmask([string tolower [join [join $victim]]]) ", "]\} successfully added with handle #[lindex [split $lastargs] 1] and level $level to the userlist."
                unset hostmask([string tolower [join [join $victim]]])
              }

              proc command:adduser:raw:authname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global hostmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![info exists hostmask([string tolower [join [join $victim]]])]} {
                  set hostmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                } else {
                  lappend hostmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                }
              }

              proc command:adduser:raw:hostname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global hostmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![string match "*users.quakenet.org" [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]} {
                  set hostmask([string tolower [join [join $victim]]]) [maskhost [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]
                }
              }       

            # - panel

              proc command:adduser { command nickname hostname handle channel arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                array set levels {
                  "10" {1 2 3 4 5 6 7 8 9 10}
                   "9" {1 2 3 4 5 6 7 8}
                   "6" {2 3 4 5 6}
                   "5" {2 3 4}
                }
                if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                  die "Touching teh copyright sucks as much as life >:("
                }
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 0]]
                regsub -nocase -all {[A\D6\DC\E4\F6\FCA-Za-z0-9\s]} [join [lindex [split $arguments] 1]] "" check
                if {[llength [split $arguments]] < 3 || [lsearch -exact $levels([::protection::user:level $handle $channel]) [lindex [split $arguments] 2]] < 0 || [string length [lindex [split $arguments] 1]] > $::handlen} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037nickname\037 \037handle\037 \{max. $::handlen characters\} \037level\037 \{[join $levels([::protection::user:level $handle $channel]) ", "]\}"; return
                } elseif {[validuser [lindex [split $arguments] 1]]} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Handle '[lindex [split $arguments] 1]' already in use."; return
                } elseif {[string length $check] > 0} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Invalid handle characters specified: [join [split $check ""] ", "]"; return
                } elseif {[isbotnick [join [join $victim]]]} {
                  putquick "PRIVMSG $channel :\001ACTION slaps $nickname with a fish\001"; return
                }
                if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                  die "OMG, WTF?!?!? XD"
                }
                bind RAW -|- {311} ::protection::command:adduser:raw:hostname
                bind RAW -|- {330} ::protection::command:adduser:raw:authname
                bind RAW -|- {318} ::protection::command:adduser:raw:end
                putquick "WHOIS [join [join $victim]]" -next
              }

          # -- command access

            # - raw result

              proc command:access:raw:end { server raw arguments } {
                catch { unbind RAW -|- {318} ::protection::command:access:raw:end }
                catch { unbind RAW -|- {330} ::protection::command:access:raw:authname }
                catch { unbind RAW -|- {311} ::protection::command:access:raw:hostname }
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global levelmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [string trim [lindex [split $arguments] 1]]]
                if {![info exists levelmask([string tolower [join [join $victim]]])] && [string index [join [join $victim]] 0] != "#"} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Seems like that [string trim [lindex [split $arguments] 1]] is currently not online."; return
                } elseif {[string index [join [join $victim]] 0] == "#"} {
                  set handle [string range [join [join $victim]] 1 end]
                } else {
                  foreach user [userlist] {
                    foreach hostname [getuser $user hosts] {
                      foreach whoishost $levelmask([string tolower [join [join $victim]]]) {
                        if {[string match -nocase $whoishost $hostname]} {
                          set handle $user
                        }
                      }
                    }
                  }
                }
                if {![info exists handle]} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Who on earth is that?"
                  if {[info exists levelmask([string tolower [join [join $victim]]])]} {
                    unset levelmask([string tolower [join [join $victim]]])
                  }
                  return
                }
                if {![regexp -- {[0-9]{1,}} [lindex [split $lastargs] 1]]} {
                  if {[string equal -nocase clear [lindex [split $lastargs] 1]]} { 
                    if {![string equal -nocase -global [lindex [split $lastargs] end]]} {
                      if {[::protection::user:level [nick2hand $lastnick] $lastchan] == "6" && [lsearch -exact "6 7" [::protection::user:level $handle $lastchan]] > -1} {
                        putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$handle is known with an higher or equal level."
                      } else {
                        if {[::protection::user:level $handle $lastchan] > 5} {
                          chattr $handle |-amnov $lastchan
                        } else {
                          chattr $handle |-aov $lastchan
                        }
                        putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Access level cleared."
                      }
                    } else {
                      if {[::protection::user:level [nick2hand $lastnick] $lastchan] == "9" && [lsearch -exact "9 10" [::protection::user:level $handle $lastchan]] > -1} {
                        putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$handle is known with an higher or equal level."
                      } else {
                        if {[::protection::user:level $handle $lastchan] > 8} {
                          chattr $handle -amnov
                        } else {
                          chattr $handle -aov
                        }
                        putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Access level cleared."
                      }
                    }
                  } elseif {[string equal -nocase -global [lindex [split $lastargs] end]]} {
                    if {![matchattr $handle mnov]} {
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$handle is not known with any global access."
                    } else {
                      if {[matchattr $handle n]} {
                        set access "owner"; set lvl 10
                      } elseif {[matchattr $handle m]} {
                        set access "master"; set lvl 9
                      } elseif {[matchattr $handle o]} {
                        set access "operator"; set lvl 8
                      } elseif {[matchattr $handle v]} {
                        set access "voice"; set lvl 7
                      }                      
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$handle global access level is: $lvl \{$access\}"
                    }
                  } else {
                    if {![matchattr $handle |mnoBSdv $lastchan]} {
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$handle is not known with any access on $lastchan."
                    } else {
                      if {[matchattr $handle |S $lastchan]} {
                        set access "quakenet service"; set lvl ""
                      } elseif {[matchattr $handle |n $lastchan]} {
                        set access "owner"; set lvl 6
                      } elseif {[matchattr $handle |m $lastchan]} {
                        set access "master"; set lvl 5
                      } elseif {[matchattr $handle |o $lastchan]} {
                        set access "opera"; set lvl 4
                      } elseif {[matchattr $handle |v $lastchan]} {
                        set access "voice"; set lvl 3
                      } elseif {[matchattr $handle |B $lastchan]} {
                        set access "banned"; set lvl 2
                      } elseif {[matchattr $handle |d $lastchan]} {
                        set access "auto deop"; set lvl 1
                      }
                      putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$handle access level on $lastchan is: $lvl \{$access\}"
                    }
                  }
                } else {
                  if {[::protection::user:level [nick2hand $lastnick] $lastchan] != "10" && [lindex [split $lastargs] 1] >= [::protection::user:level [nick2hand $lastnick] $lastchan]} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :You are not enough known to add this level."
                  } else {
                    switch -exact -- [lindex [split $lastargs] 1] {
                      "10" { chattr $handle +amnov; set level "[lindex [split $lastargs] 1] 'Bot Owner'" }
                       "9" { chattr $handle -n+amov; set level "[lindex [split $lastargs] 1] 'Bot Master'" }
                       "8" { chattr $handle -nm+aov; set level "[lindex [split $lastargs] 1] 'Global Operator'" }
                       "7" { chattr $handle -nmo+av; set level "[lindex [split $lastargs] 1] 'Global Voice'" }
                       "6" { chattr $handle |+amnov $lastchan; set level "[lindex [split $lastargs] 1] 'Channel Owner'" }
                       "5" { chattr $handle |+amov-n $lastchan; set level "[lindex [split $lastargs] 1] 'Channel Master'" }
                       "4" { chattr $handle |+aov-nm $lastchan; set level "[lindex [split $lastargs] 1] 'Channel Operator'" }
                       "3" { chattr $handle |+av-nmo $lastchan; set level "[lindex [split $lastargs] 1] 'Channel Voice'"}
                       "2" { chattr $handle |+d-nmova $lastchan; set level "[lindex [split $lastargs] 1] 'Autodeop'" }
                       "1" { chattr $handle |+B-nmova $lastchan; set level "[lindex [split $lastargs] 1] 'Banned from channel'" }
                    }
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Level successfully set to $level"
                  }
                }
                if {[info exists levelmask([string tolower [join [join $victim]]])]} {
                  unset levelmask([string tolower [join [join $victim]]])
                }
              }

              proc command:access:raw:authname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global levelmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![info exists levelmask([string tolower [join [join $victim]]])]} {
                  set levelmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                } else {
                  lappend levelmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                }
              }

              proc command:access:raw:hostname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global levelmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![string match "*users.quakenet.org" [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]} {
                  set levelmask([string tolower [join [join $victim]]]) [maskhost [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]
                }
              }       

            # - panel

              proc command:access { command nickname hostname handle channel arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 0]]
                regsub -nocase -all {[A\D6\DC\E4\F6\FCA-Za-z0-9#\s]} [join [join $victim]] "" check
                if {[llength [split $arguments]] < 1} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037nickname\037|\037#handle\037 ?\037level\037|\037clear\037? \037?-global?\037"; return
                } elseif {[string index [join [join $victim]] 0] == "#" && [string length $check] > 0} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Invalid handle characters specified: [join [split $check ""] ", "]"; return
                }
                bind RAW -|- {311} ::protection::command:access:raw:hostname
                bind RAW -|- {330} ::protection::command:access:raw:authname
                bind RAW -|- {318} ::protection::command:access:raw:end
                putquick "WHOIS [join [join $victim]]" -next
              }

          # -- command deluser

            # - raw result

              proc command:deluser:raw:end { server raw arguments } {
                catch { unbind RAW -|- {318} ::protection::command:deluser:raw:end }
                catch { unbind RAW -|- {311} ::protection::command:deluser:raw:hostname }
                catch { unbind RAW -|- {330} ::protection::command:deluser:raw:authname }
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global hostmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [string trim [lindex [split $arguments] 1]]]
                if {[string index [join [join $victim]] 0] != "#" && ![info exists hostmask([string tolower [join [join $victim]]])]} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Seems like that [string trim [lindex [split $arguments] 1]] is currently not online."; return
                }
                if {[string index [join [join $victim]] 0] == "#"} {
                  if {![validuser [string range [join [join $victim]] 1 end]]} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Unknown handle specified. \{[string range [join [join $victim]] 1 end]\}"; return
                  } elseif {[string equal -nocase [string range [join [join $victim]] 1 end] [nick2hand $lastnick]] || [matchattr [string range [join [join $victim]] 1 end] |S $lastchan]} {
                    putquick "PRIVMSG $lastchan :\001ACTION slaps $lastnick XD\001"; return
                  }
                  if {[deluser [string range [join [join $victim]] 1 end]]} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :[join [join $victim]] has been successfully deleted." 
                  } else {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Unknown error."
                  }
                  return
                }
                set found ""
                foreach handle [userlist] {
                  if {[string equal -nocase [nick2hand $lastnick] $handle]} {
                    continue
                  }
                  foreach addhost $hostmask([string tolower [join [join $victim]]]) {
                    foreach hostname [getuser $handle hosts] {
                      if {[string match -nocase $addhost $hostname] && [lsearch -exact $found $handle] < 0} {
                        lappend found $handle
                      }
                    }
                  }
                }
                unset hostmask([string tolower [join [join $victim]]])
                if {[llength $found] < 1} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :Seems like that [string trim [lindex [split $arguments] 1]] is not known to me."; return
                }
                set deleted 0
                foreach handle $found {
                  if {[::protection::user:level [nick2hand $lastnick] $lastchan] == "9" && [lsearch -exact "6 9 10" [::protection::user:level $handle $lastchan]] > -1} {
                    continue
                  } elseif {[::protection::user:level [nick2hand $lastnick] $lastchan] == "5" && [lsearch -exact "6 7 8 9 10" [::protection::user:level $handle $lastchan]] > -1} {
                    continue
                  }
                  if {[deluser $handle]} {
                    incr deleted 1
                  }
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $lastnick :$deleted of [llength $found] [expr {([llength $found] == 1) ? "handle" : "handles" }] for [string trim [lindex [split $arguments] 1]] were deleted."
              }

              proc command:deluser:raw:authname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global hostmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![info exists hostmask([string tolower [join [join $victim]]])]} {
                  set hostmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                } else {
                  lappend hostmask([string tolower [join [join $victim]]]) *!*@[lindex [split $arguments] 2].users.quakenet.org
                }
              }

              proc command:deluser:raw:hostname { server raw arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                global hostmask
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 1]]
                if {![string match "*users.quakenet.org" [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]} {
                  set hostmask([string tolower [join [join $victim]]]) [maskhost [lindex [split $arguments] 2]@[lindex [split $arguments] 3]]
                }
              }       

            # - panel

              proc command:deluser { command nickname hostname handle channel arguments } {
                global botnick botname
                global lastnick lastchan lastargs lastcmd lasttrig
                set victim [string map {"\{" "\\\{" "\\" "\\\\" "\}" "\\\}" "\[" "\\\[" "\]" "\\\]"} [lindex [split $arguments] 0]]
                regsub -nocase -all {[A\D6\DC\E4\F6\FCA-Za-z0-9\s]} [join [lindex [split $arguments] 1]] "" check
                if {[llength [split $arguments]] < 1} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037nickname\037|\037#handle\037"; return
                } elseif {[string length $check] > 0} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Invalid handle characters specified: [join [split $check ""] ", "]"; return
                } elseif {[isbotnick [join [join $victim]]] || [string equal -nocase [join [join $victim]] $nickname] || [string equal -nocase [join [join $victim]] $handle]} {
                  putquick "PRIVMSG $channel :\001ACTION slaps $nickname with a fish\001"; return
                } elseif {[matchattr [join [join $victim]] |S $channel] || [string length [join [join $victim]]] == 1} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Not allowed."; return
                }
                bind RAW -|- {311} ::protection::command:deluser:raw:hostname
                bind RAW -|- {330} ::protection::command:deluser:raw:authname
                bind RAW -|- {318} ::protection::command:deluser:raw:end
                putquick "WHOIS [join [join $victim]]" -next
              }

          # -- command bitchmode

            proc command:bitchmode { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {[lsearch -exact "on off" [string tolower [lindex [split $arguments] 0]]] < 0} {
                if {[channel get $channel "bitchmode"]} {
                  set status "enabled \{Maximal [lindex [split [channel get $channel "maximal-modes"] ":"] 0] [expr {([lindex [split [channel get $channel "maximal-modes"] ":"] 0] == 1) ? "mode" : "modes" }] in [duration [lindex [split [channel get $channel "maximal-modes"] ":"] 1]] allowed\}"
                } else {
                  set status "disabled"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current channel bitchmode status \{$channel\} is: [string toupper [lindex $status 0]] [lrange $status 1 end]"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037?on\037|\037off?\037"
                return
              }
              if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                die "Uh, Oh, Yeah, you really think you can use my script without my copyright ???? :D"
              }
              if {[string equal -nocase on [lindex [split $arguments] 0]]} {
                channel set $channel +bitchmode
              } else {
                channel set $channel -bitchmode
              }
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel bitchmode status \{$channel\} successfully turned [string toupper [lindex [split $arguments] 0]]"
            }

          # -- command topicsave

            proc command:topicsave { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {[lsearch -exact "on off" [string tolower [lindex [split $arguments] 0]]] < 0} {
                if {[channel get $channel "topicsave"]} {
                  set status enabled
                } else {
                  set status disabled
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current channel topicsave status \{$channel\} is: [string toupper $status]"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037?on\037|\037off?\037"
                return
              }
              if {[string equal -nocase on [lindex [split $arguments] 0]]} {
                channel set $channel +topicsave
                if {[topic $channel] != ""} {
                  channel set $channel channel-topic [topic $channel]
                }
              } else {
                channel set $channel -topicsave; channel set $channel channel-topic ""
              }
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel topicsave status \{$channel\} successfully turned [string toupper [lindex [split $arguments] 0]]"
            }

          # -- command maximal modes

            proc command:maxmodes { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {![regexp -- {[0-9]{1,}:[0-9]{1,}} [lindex [split $arguments] 0]] || [lindex [split [lindex [split $arguments] 0] ":"] 0] > 12 || [lindex [split [lindex [split $arguments] 0] ":"] 0] == "0" || [lindex [split [lindex [split $arguments] 0] ":"] 1] == "0"} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current channel maximal modes \{$channel\} [expr {([lindex [split [channel get $channel "maximal-modes"] ":"] 0] == 1) ? "is" : "are" }]: [lindex [split [channel get $channel "maximal-modes"] ":"] 0] [expr {([lindex [split [channel get $channel "maximal-modes"] ":"] 0] == 1) ? "mode" : "modes" }] in [duration [lindex [split [channel get $channel "maximal-modes"] ":"] 1]]"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037?modes:seconds?\037 \{maximal modes are 12\}"
                return
              }
              channel set $channel maximal-modes [lindex [split $arguments] 0]
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel maximal modes \{$channel\} successfully set up to: [lindex [split [channel get $channel "maximal-modes"] ":"] 0] [expr {([lindex [split [channel get $channel "maximal-modes"] ":"] 0] == 1) ? "mode" : "modes" }] in [duration [lindex [split [channel get $channel "maximal-modes"] ":"] 1]]"
            }

          # -- command maximal kicks

            proc command:maxkicks { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {![regexp -- {[0-9]{1,}:[0-9]{1,}} [lindex [split $arguments] 0]] || [lindex [split [lindex [split $arguments] 0] ":"] 0] > 5 || [lindex [split [lindex [split $arguments] 0] ":"] 0] == "0" || [lindex [split [lindex [split $arguments] 0] ":"] 1] == "0"} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current channel maximal kicks \{$channel\} [expr {([lindex [split [channel get $channel "maximal-kicks"] ":"] 0] == 1) ? "is" : "are" }]: [lindex [split [channel get $channel "maximal-kicks"] ":"] 0] [expr {([lindex [split [channel get $channel "maximal-kicks"] ":"] 0] == 1) ? "kick" : "kicks" }] in [duration [lindex [split [channel get $channel "maximal-kicks"] ":"] 1]]"
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037?kicks:seconds?\037 \{maximal kicks are 5\}"
                return
              }
              channel set $channel maximal-kicks [lindex [split $arguments] 0]
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel maximal kicks \{$channel\} successfully set up to: [lindex [split [channel get $channel "maximal-kicks"] ":"] 0] [expr {([lindex [split [channel get $channel "maximal-kicks"] ":"] 0] == 1) ? "kick" : "kicks" }] in [duration [lindex [split [channel get $channel "maximal-kicks"] ":"] 1]]"
            }

          # -- command remove flags

            proc command:remflags { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {[llength [set flags [string tolower [lindex [split $arguments] 0]]]] < 1 || ![regexp -- {\+|\-} $flags] && ![string equal -nocase none $flags]} {
                if {[llength [set flags [channel get $channel "remove-flags"]]] > 0} {
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Current flags to remove \{$channel\} are: $flags"
                }
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037?+-flags?\037|\037none\037"
                return
              }
              if {[string equal -nocase none $flags]} {
                channel set $channel remove-flags ""
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Bot won't remove any flags. \{$channel\}"
                return
              }
              if {[onchan Q $channel]} {
                regsub -all {[amnotvb\+\-]} $flags "" check
              } elseif {[onchan L $channel]} {
                regsub -all {[aomnvg\+\-]} $flags "" check
              } else {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :There is currently no Quakenet Service \{Q|L\} in $channel"; return
              }
              if {[llength $check] > 0} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Invalid flags specified \{$channel\}: [join [split $check ""] ", "]"; return
              }
              channel set $channel remove-flags $flags
              putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Channel flags to remove \{$channel\} set to: $flags"
              if {[string match "*m*" $flags]} {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Informatio\037n\037\002:\002 In order to remove the requested flags it's required to add me OWNER status in $channel \{ /MSG [join [userlist |S $channel] ","] CHANLEV $channel $botnick +n \}"
              } else {
                putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Informatio\037n\037\002:\002 In order to remove the requested flags it's required to add me MASTER status in $channel \{ /MSG [join [userlist |S $channel] ","] CHANLEV $channel $botnick +amo \}"
              }
            }

          # -- command automode {operator:voice}

            proc command:automode { command nickname hostname handle channel arguments } {
              global botnick botname
              global lastnick lastchan lastargs lastcmd lasttrig
              if {$command == "autoop"} {
                set flag onjoin-operator; set other onjoin-voice
              } else {
                set flag onjoin-voice; set other onjoin-operator
              }
              set option [string tolower [lindex [split $arguments] 0]]
              switch -exact -- $option {
                "off" {
                  if {![channel get $channel $flag]} {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :[string toupper [string index $command 0]][string tolower [string range $command 1 end]] status \{$channel\} should be already [string toupper $option]"
                  } else {
                    channel set $channel -$flag; putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :[string toupper [string index $command 0]][string tolower [string range $command 1 end]] status \{$channel\} successfully turned [string toupper $option]"
                  }
                }
                "on" {
                  if {![channel get $channel $flag]} {
                    channel set $channel +$flag -$other; putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :[string toupper [string index $command 0]][string tolower [string range $command 1 end]] status \{$channel\} successfully turned [string toupper $option]"
                  } else {
                    putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :[string toupper [string index $command 0]][string tolower [string range $command 1 end]] status \{$channel\} should be already [string toupper $option]"
                  }
                }
                "default" {
                  if {![channel get $channel $flag]} {
                    set status "off"
                  } else {
                    set status "on"
                  }
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :[string toupper [string index $command 0]][string tolower [string range $command 1 end]] status \{$channel\} is: [string toupper $status]"
                  putserv "[getuser [nick2hand $lastnick] XTRA methode] $nickname :Please use: $lasttrig \037?#channel?\037 \037?on\037|\037off?\037"                 
                }
              }
            }

      # --- remove Delay join +D

        # -- raw result

          # - end

            proc clear:delay:end { server raw arguments } {
              catch { unbind RAW -|- {355} ::protection::clear:delay }
              catch { unbind RAW -|- {366} ::protection::clear:delay:end }
              if {[info exists ::cleared([lindex [split $arguments] 1])]} {
                putserv "PRIVMSG [lindex [split $arguments] 1] :\001ACTION welcome back you hidden users ... \\\\\F4\001"; unset ::cleared([lindex [split $arguments] 1])
              }
            }

          # - input

            proc clear:delay { server raw arguments } {
              set channel [lindex [split $arguments] 2]
              set victims [lrange [split $arguments] 3 end]
              if {[string index $victims 0] == ":"} {
                set victims [string range $victims 1 end]
              }
              set list ""
              foreach victim $victims {
                if {[llength $list] == "6"} {
                  set ::cleared($channel) 1
                  putserv "MODE $channel +vvvvvv [join $list]"
                  if {![channel get $channel "onjoin-voice"]} {
                    utimer 1 [list putserv "MODE $channel -vvvvvv [join $list]"]
                  }
                  set list ""
                }
                lappend list $victim
              }
              if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
                die "You did this nice script? don't think so ;)"
              }
              if {[llength $list] != "0"} {
                set ::cleared($channel) 1
                putserv "MODE $channel +[string repeat "v" [llength [join $list]]] [join $list]"
                if {![channel get $channel "onjoin-voice"]} {
                  utimer 1 [list putserv "MODE $channel -[string repeat "v" [llength [join $list]]] [join $list]"]
                }
              }
            }

      # --- protection {topic:mode:kick}

        # -- topic change

          proc topic:change { nickname hostname handle channel topic } {
            global flags
            if {![channel get $channel "topicsave"] || $topic == "[join [channel get $channel "channel-topic"]]"} {
              return
            } elseif {[::protection::mode:change:abort $nickname $hostname $handle $channel] && $topic != ""} {
              channel set $channel channel-topic $topic; return
            }
            if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
              die "Uh, Oh, Yeah, you really think you can use my script without my copyright ???? :D"
            }
            if {[onchan Q $channel]} {
              puthelp "PRIVMSG Q :SETTOPIC $channel [join [channel get $channel "channel-topic"]]"
            } else {
              puthelp "TOPIC $channel :[join [channel get $channel "channel-topic"]]"
            }
            set reason "Don't abuse your operator privileges!"
            if {[channel get $channel "remove-flags"] != "" && ![info exists flags(removed:$hostname:$channel)]} {
              putquick "PRIVMSG $service :CHANLEV $channel $nickname [channel get $channel "remove-flags"]" -next
              set flags(removed:$hostname:$channel) 1
              utimer 5 [list ::protection::unset:variable flags(removed:$hostname:$channel)]
            }
            if {[string match "*users.quakenet.org" $hostname]} {
              set banmask *!*@[lindex [split $hostname "@"] 1]
            } else {
              set banmask [maskhost $hostname]
            }
            switch -exact -- [channel get $channel "punish-methode"] {
              "1" { if {![botisop $channel]} { return }; putquick "MODE $channel -o $nickname" -next }
              "2" { if {![onchan $nickname $channel]} { return }; putquick "KICK $channel $nickname :[string map "\":nickname:\" \"$nickname\" \":reason:\" \"$reason\" \":counter:\" \"[expr [channel get $channel "kick-id"] + 1]\"" [join [channel get $channel "kick-message"]]]" }
              "3" { newchanban $channel $banmask #xela [string map "\":nickname:\" \"$nickname\" \":reason:\" \"$reason\" \":counter:\" \"[expr [channel get $channel "kick-id"] + 1]\"" [join [channel get $channel "kick-message"]]] 15 }
            }
          }

        # -- mode change

          proc mode:change { nickname hostname handle channel mode victim } {
            global botnick botname
            global modes victims after operator last
            if {[info exists after($hostname:$channel)]} {
              after cancel $after($hostname:$channel); unset after($hostname:$channel)
            }
            if {![channel get $channel "protection"]} {
              return
            }
            set service [join [userlist |S $channel] ","]
            if {![info exists modes($hostname:$channel)]} {
              set modes($hostname:$channel) ""
            }
            if {![info exists victims($hostname:$channel)]} {
              set victims($hostname:$channel) ""
            }
            lappend modes($hostname:$channel) $mode
            if {$victim != ""} {
              lappend victims($hostname:$channel) $victim
            }
            if {$mode == "+b" && $nickname == "Q" && [string match -nocase $victim $botname]} {
              clearqueue all
              putquick "PRIVMSG Q :BANDEL $channel $victim" -next
              if {[botonchan $channel] && [botisop $channel]} {
                putquick "MODE $channel -b $victim" -next
              } else {
                putquick "JOIN $channel" -next
              }
              if {[info exists after($hostname:$channel)]} {
                after cancel $after($hostname:$channel); unset after($hostname:$channel)
              }
              if {[info exists modes($hostname:$channel)]} {
                unset modes($hostname:$channel)
              }
              if {[info exists victims($hostname:$channel)]} {
                unset victims($hostname:$channel)
              }
              return
            }
            if {![::protection::mode:change:abort $nickname $hostname $handle $channel] && [string index $mode 1] == "o" && [lsearch -exact "4 5 6 8 9 10" [::protection::user:level [nick2hand $victim] $channel]] < 0} {
              if {![info exists operator($channel)]} {
                set operator($channel) 1; utimer [lindex [split [channel get $channel "maximal-modes"] ":"] 1] [list ::protection::unset:variable operator($channel)]
              } else {
                incr operator($channel) 1
              }
              if {[info exists operator($channel)] && $operator($channel) == "[lindex [split [channel get $channel "maximal-modes"] ":"] 0]"} {
                ::protection::unset:variable operator($channel)
                clearqueue all
                if {[info exists after($hostname:$channel)]} {
                  after cancel $after($hostname:$channel); unset after($hostname:$channel)
                }
                if {[info exists modes($hostname:$channel)]} {
                  unset modes($hostname:$channel)
                }
                if {[info exists victims($hostname:$channel)]} {
                  unset victims($hostname:$channel)
                }
                if {[info exists last(service:$channel)] && [expr [unixtime] - $last(service:$channel)] < 1} {
                  return
                }
                foreach option [split [channel get $channel "reaction-mass-mode"] ":"] {
                  if {[string equal -nocase "reop" $option]} {
                    if {![botisop $channel]} {
                      putquick "PRIVMSG $service :OP $channel" -next
                    } 
                  } else {
                    if {[string equal -nocase "invite" $option] && ![botonchan $channel]} {
                      putquick "PRIVMSG $service :$option $channel" -next
                    } elseif {[string equal -nocase "unbanall" $option] && $service == "Q"} {
                      putquick "PRIVMSG $service :BANCLEAR $channel" -next
                    } else {
                      putquick "PRIVMSG $service :$option $channel" -next
                    }
                  }
                }
                set last(service:$channel) [unixtime]
                return 
              }
            }
            if {[llength $victims($hostname:$channel)] >= 6} {
              set delay 1
            } else {
              set delay 0
            }
            set after($hostname:$channel) [after $delay [list ::protection::mode:change:parse $nickname $hostname $handle $channel $modes($hostname:$channel) $victims($hostname:$channel)]]    
          }

          proc mode:change:parse { nickname hostname handle channel modechg victim } {
            global botnick botname
            global modes victims after start flags
            set service [join [userlist |S $channel] ","]
            if {[llength $hostname] > 0} {
              if {[string match "*users.quakenet.org" $hostname]} {
                set banmask *!*@[lindex [split $hostname "@"] 1]
              } else {
                set banmask [maskhost $hostname]
              }
            }
            if {[info exists victims($hostname:$channel)]} {
              unset victims($hostname:$channel)
            }
            if {[info exists modes($hostname:$channel)]} {
              unset modes($hostname:$channel)
            }
            set mode-change ""
            set mode-last "+"
            set mode-string "0"
            set punish "0"
            foreach mode [split $modechg ""] {
              if {$mode == "+" || $mode == "-"} {
                set mode-last $mode; continue
              }
              if {[lsearch -exact "o b k v" $mode] > -1 || ${mode-last} == "+" && $mode == "l"} {
                lappend mode-change "${mode-last}${mode} [lindex $victim ${mode-string}]"; incr mode-string 1
              } else {
                lappend mode-change "${mode-last}${mode}"
              }
            }
            set punish-methode [channel get $channel "punish-methode"]
            set negativ-mode "-"
            set positiv-mode "+"
            set negativ-victim ""
            set positiv-victim ""
            set punish "0"
            set reason "Don't abuse your operator privileges!"
            if {${punish-methode} != "2"} {
              append negativ-mode o; set negativ-victim $nickname
            } 
            if {${punish-methode} == "3"} {
              append positiv-mode b; set positiv-victim $banmask
              if {[isvoice $nickname $channel]} {
                append negativ-mode v; lappend negativ-victim $nickname
              }
            }
            foreach mode ${mode-change} {
              set victim [lindex $mode 1]
              set mode   [lindex $mode 0]
              if {[string index $mode 1] == ""} {
                continue
              }
              set total  [expr [llength ${negativ-victim}] + [llength ${positiv-victim}]]
              if {$total == "6" && $punish && [botonchan $channel] && [botisop $channel]} {
                if {[channel get $channel "remove-flags"] != "" && ![info exists flags(removed:$hostname:$channel)]} {
                  putquick "PRIVMSG $service :CHANLEV $channel $nickname [channel get $channel "remove-flags"]" -next
                  set flags(removed:$hostname:$channel) 1
                  utimer 5 [list ::protection::unset:variable flags(removed:$hostname:$channel)]
                }
                putquick "MODE $channel ${negativ-mode}${positiv-mode} [join "${negativ-victim} ${positiv-victim}"]" -next
                set negativ-mode "-"; set positiv-mode "+"; set negativ-victim ""; set positiv-victim ""
              }
              if {$mode == "+o" && [string equal -nocase $botnick [join $victim]]} {
                continue  
              } elseif {$mode == "-D" && [isbotnick $nickname]} {
                bind RAW -|- {355} ::protection::clear:delay
                bind RAW -|- {366} ::protection::clear:delay:end
                putserv "NAMES -d $channel"
              } elseif {$mode == "-o" && [string equal -nocase $botnick [join $victim]]} {
                if {![::protection::mode:change:abort $nickname $hostname $handle $channel]} {
                  set punish 1
                  if {![info exists last(service:$channel)] || [info exists last(service:$channel)] && [expr [unixtime] - $last(service:$channel)] > 1} {
                    foreach option [split [channel get $channel "reaction-need-op"] ":"] {
                      if {[string equal -nocase "reop" $option]} {
                        if {![botisop $channel]} {
                          putquick "PRIVMSG $service :OP $channel" -next
                        } 
                      } else {
                        if {[string equal -nocase "invite" $option] && ![botonchan $channel]} {
                          putquick "PRIVMSG $service :$option $channel" -next
                        } elseif {[string equal -nocase "unbanall" $option] && $service == "Q"} {
                          putquick "PRIVMSG $service :BANCLEAR $channel" -next
                        } else {
                          putquick "PRIVMSG $service :$option $channel" -next
                        }
                      }
                    }
                    set last(service:$channel) [unixtime]
                  }
                }
                continue
              } elseif {$mode == "-o" && [lsearch -exact "4 5 6 8 9 10" [::protection::user:level [nick2hand [join $victim]] $channel]] > -1} {
                if {[::protection::mode:change:abort $nickname $hostname $handle $channel] == "0"} {
                  set punish 1
                }
                append positiv-mode [string index $mode 1]; lappend positiv-victim $victim; continue
              } elseif {$mode == "-o" && [string equal -nocase $nickname [join $victim]]} {
                continue
              } elseif {$mode == "+b" && [string match -nocase $hostname [join $victim]]} {
                continue
              } elseif {$mode == "+o" && [lsearch -exact "4 5 6 8 9 10" [::protection::user:level [nick2hand [join $victim]] $channel]] > -1} {
                continue
              } elseif {[string index $mode 1] == "o" && ![channel get $channel "bitchmode"]} {
                continue
              } elseif {[string index $mode 1] == "o" && [channel get $channel "bitchmode"]} {
                if {[::protection::mode:change:abort $nickname $hostname $handle $channel] == "1"} {
                  continue
                }
                set punish 1
                if {[string index $mode 0] == "+"} {
                  append negativ-mode [string index $mode 1]; lappend negativ-victim $victim
                }
                continue
              } elseif {$mode == "-v" && [lsearch -exact "3 4 5 6 7 8 9 10" [::protection::user:level [nick2hand [join $victim]] $channel]] > -1} {
                if {[::protection::mode:change:abort $nickname $hostname $handle $channel] == "0" && [string match *[string index $mode 1]* [lindex [channel get $channel "protected-modes"] 1]]} {
                  set punish 1
                }
                append positiv-mode [string index $mode 1]; lappend positiv-victim $victim; continue
              } elseif {$mode == "-v" && [lsearch -exact "3 4 5 6 7 8 9 10" [::protection::user:level [nick2hand [join $victim]] $channel]] < 0} {
                continue
              } elseif {$mode == "-b"} {
                if {[::protection::mode:change:abort $nickname $hostname $handle $channel] < 1} {
                  foreach ban [banlist $channel] {
                    if {[string match -nocase [lindex $ban 0] [join $victim]]} {
                      set punish 1; append positiv-mode [string index $mode 1]; lappend positiv-victim $victim
                    }
                  }
                  foreach ban [banlist] {
                    if {[string match -nocase [lindex $ban 0] [join $victim]]} {
                      set punish 1; append positiv-mode [string index $mode 1]; lappend positiv-victim $victim
                    }
                  }
                }
                continue
              } elseif {$mode == "+l" && $victim > [llength [chanlist $channel]]} {
                continue
              } elseif {[string index $mode 1] == ""} {
                continue
              } elseif {[string index $mode 0] == "+" && ![string match *[string index $mode 1]* [lindex [channel get $channel "protected-modes"] 0]]} {
                continue
              } elseif {[string index $mode 0] == "-" && ![string match *[string index $mode 1]* [lindex [channel get $channel "protected-modes"] 1]]} {
                continue
              }
              if {[::protection::mode:change:abort $nickname $hostname $handle $channel] < 1} {
                set punish 1
              }
              if {[string index $mode 0] == "-"} {
                append positiv-mode [string index $mode 1]
                if {$victim != ""} {
                  lappend positiv-victim $victim
                }
              } elseif {[string index $mode 0] == "+"} {
                append negativ-mode [string index $mode 1]
                if {$victim != "" && [string index $mode 1] != "l"} {
                  lappend negativ-victim $victim
                }
              }
             }
            if {${negativ-mode} == "-"} {
              set negativ-mode ""
            }
            if {${positiv-mode} == "+"} {
              set positiv-mode ""
            }
            if {$punish && ![::protection::mode:change:abort $nickname $hostname $handle $channel]} {
              if {[channel get $channel "remove-flags"] != "" && ![info exists flags(removed:$hostname:$channel)]} {
                putquick "PRIVMSG $service :CHANLEV $channel $nickname [channel get $channel "remove-flags"]" -next
                set flags(removed:$hostname:$channel) 1
                utimer 5 [list ::protection::unset:variable flags(removed:$hostname:$channel)]
              }
              if {${positiv-mode} != "" || ${negativ-mode} != "" && [botonchan $channel] && [botisop $channel]} {
                putquick "MODE $channel ${negativ-mode}${positiv-mode} [join "${negativ-victim} ${positiv-victim}"]"
              }
              if {${punish-methode} > 1} {
                if {[onchan $nickname $channel] && ${punish-methode} == "2"} {
                  putquick "KICK $channel $nickname :[string map "\":nickname:\" \"$nickname\" \":reason:\" \"$reason\" \":counter:\" \"[expr [channel get $channel "kick-id"] + 1]\"" [join [channel get $channel "kick-message"]]]"
                }
                if {${punish-methode} > 2} {
                  newchanban $channel $banmask #xela [string map "\":nickname:\" \"$nickname\" \":reason:\" \"$reason\" \":counter:\" \"[expr [channel get $channel "kick-id"] + 1]\"" [join [channel get $channel "kick-message"]]] 15
                }
              }
              set negativ-mode "-"; set positiv-mode "+"; set negativ-victim ""; set positiv-victim ""
            }
          }

          proc mode:change:abort { nickname hostname handle channel } {
            if {[llength $nickname] < 1} {
              return 1
            } elseif {[string length $nickname] == "1"} {
              return 1
            } elseif {![channel get $channel "protection"]} {
              return 1
            } elseif {[llength $hostname] < 1} {
              return 1
            } elseif {[string match *.* $nickname]} {
              return 1
            } elseif {[lsearch -exact $::protection::settings::required(modechange) [::protection::user:level $handle $channel]] > -1} {
              return 1
            } elseif {[matchattr $handle b] || [islinked $handle]} {
              return 1
            } elseif {[isbotnick $nickname]} {
              return 1
            } else {
              return 0
            }
          }

      # --- user kick

        proc user:kick { nickname hostname handle channel victim reason } {
          global botnick botname flags kicks last
          if {[::protection::mode:change:abort $nickname $hostname $handle $channel] || [string equal -nocase $victim $nickname]} {
            return
          }
          set service [join [userlist |S $channel] ","]
          if {[isbotnick $victim]} {
            foreach option [split [channel get $channel "reaction-bot-kick"] ":"] {
              if {[string equal -nocase "invite" $option] && ![botonchan $channel]} {
                putquick "PRIVMSG $service :$option $channel" -next
              } elseif {[string equal -nocase "unbanall" $option] && $service == "Q"} {
                putquick "PRIVMSG $service :BANCLEAR $channel" -next
              } else {
                putquick "PRIVMSG $service :$option $channel" -next
              }
            }
          } 
          if {![info exists kicks($channel)]} {
            set kicks($channel) 1; utimer [lindex [split [channel get $channel "maximal-kicks"] ":"] 1] [list ::protection::unset:variable kicks($channel)]
          } else {
            incr kicks($channel) 1
            if {$kicks($channel) == "[lindex [split [channel get $channel "maximal-kicks"] ":"] 0]"} {
              ::protection::unset:variable kicks($channel)
              set punish 1
              if {![info exists last(service:$channel)] || [info exists last(service:$channel)] && [expr [unixtime] - $last(service:$channel)] > 1} {
                foreach option [split [channel get $channel "reaction-mass-kick"] ":"] {
                  if {[string equal -nocase "reop" $option]} {
                    if {![botisop $channel]} {
                      putquick "PRIVMSG $service :OP $channel" -next
                    } 
                  } else {
                    if {[string equal -nocase "invite" $option] && ![botonchan $channel]} {
                      putquick "PRIVMSG $service :$option $channel" -next
                    } elseif {[string equal -nocase "unbanall" $option] && $service == "Q"} {
                      putquick "PRIVMSG $service :BANCLEAR $channel" -next
                    } else {
                      putquick "PRIVMSG $service :$option $channel" -next
                    }
                  }
                }
                set last(service:$channel) [unixtime]
              }
            }
          }
          if {[matchattr [nick2hand $victim] mno|mno $channel] && [botisop $channel]} {
            putserv "INVITE $victim $channel"
          }
          set reason "Don't abuse your operator privileges!"
          if {[channel get $channel "remove-flags"] != "" && ![info exists flags(removed:$hostname:$channel)]} {
            putquick "PRIVMSG $service :CHANLEV $channel $nickname [channel get $channel "remove-flags"]" -next
            set flags(removed:$hostname:$channel) 1
            utimer 5 [list ::protection::unset:variable flags(removed:$hostname:$channel)]
          }
          if {[string match "*users.quakenet.org" $hostname]} {
            set banmask *!*@[lindex [split $hostname "@"] 1]
          } else {
            set banmask [maskhost $hostname]
          }
          switch -exact -- [channel get $channel "punish-methode"] {
            "1" { if {![botisop $channel]} { return }; putquick "MODE $channel -o $nickname" -next }
            "2" { if {![onchan $nickname $channel]} { return }; putquick "KICK $channel $nickname :[string map "\":nickname:\" \"$nickname\" \":reason:\" \"$reason\" \":counter:\" \"[expr [channel get $channel "kick-id"] + 1]\"" [join [channel get $channel "kick-message"]]]" }
            "3" { newchanban $channel $banmask #xela [string map "\":nickname:\" \"$nickname\" \":reason:\" \"$reason\" \":counter:\" \"[expr [channel get $channel "kick-id"] + 1]\"" [join [channel get $channel "kick-message"]]] 15 }
          }
        }

      # --- need settings

        proc need:settings { channel need } {
          set need [string tolower $need]
          if {![validchan $channel] || ![channel get $channel "protection"] || [set service [join [userlist |S $channel] ","]] == ""} {
            return
          }
          clearqueue all
          putlog "\{#xela (protection v$::protection::settings::version)\} bot requires $need in $channel ($service)"
          if {$need == "op"} {
            putquick "PRIVMSG $service :OP $channel" -next; return
          }
          foreach option [split [channel get $channel "reaction-need-$need"] ":"] {
            if {[string equal -nocase "reop" $option]} {
              if {![botisop $channel]} {
                putquick "PRIVMSG $service :OP $channel" -next
              }
            } else {
              if {[string equal -nocase "invite" $option] && ![botonchan $channel]} {
                putquick "PRIVMSG $service :$option $channel" -next
              } elseif {[string equal -nocase "unbanall" $option] && $service == "Q"} {
                putquick "PRIVMSG $service :BANCLEAR $channel" -next
              } else {
                putquick "PRIVMSG $service :$option $channel" -next
              }
            }
          }
        }

      # --- get user level

        proc user:level { handle channel } {
          set return 0
          if {![validuser $handle]} {
            return $return
          }
          set level 0
          while {$level <= 10} {
            if {[info exists ::protection::settings::levels($level)] && [matchattr $handle $::protection::settings::levels($level) $channel]} {
              set return $level
            }
            incr level 1
          }
          return $return
        }

      # --- incr kick counter

        proc incr:kickcount { nickname hostname handle channel victim reason } {
          global botnick
          if {[isbotnick $nickname]} {
            channel set $channel kick-id [expr [channel get $channel "kick-id"] + 1]
          }
        }

      # --- unset variable

        proc unset:variable { variable } {
          if {![info exists ::${variable}]} {
            return
          }
          unset ::${variable}
        }

      # --- autolimit

        # -- set up new channel limit

          proc auto:limit { minute hour day month year } {
            foreach channel [channels] {
              if {![botisop $channel] || ![regexp {[0-9]{1,}} [channel get $channel "autolimit"]]} {
                continue
              }
              set newlimit [expr [llength [chanlist $channel]] + [channel get $channel "autolimit"]]
              if {[string match *l* [lindex [getchanmode $channel] 0]]} {
                regexp {\S[\s]([0-9]+)} [getchanmode $channel] -> limit
              } else {
                set limit 0
              }
              if {($newlimit == "$limit")} {
                continue
              }
              if {$newlimit > $limit} {
                set difference [expr $newlimit - $limit]
              } elseif {$newlimit < $limit} {
                set difference [expr $limit - $newlimit]
              }
              if {($difference <= [expr round([channel get $channel "autolimit"] * 0.5)]) && ([channel get $channel "autolimit"] > 5)} {
                continue
              } elseif {($difference < [expr round([channel get $channel "autolimit"] * 0.38)]) && ([channel get $channel "autolimit"] <= 5)} {
                continue
              }
              pushmode $channel +l $newlimit
            }
          }

      # --- set up default channel settings

        proc missing:settings { channel } {
          if {![regexp -- {[0-9]{1,}} [channel get $channel "kick-id"]]} {
            channel set $channel kick-id "1"
          }
          if {![regexp -- {[0-9]{1,}:[0-9]{1,}} [channel get $channel "maximal-modes"]] || [lindex [split [channel get $channel "maximal-modes"] ":"] 0] > 12 || [lindex [split [channel get $channel "maximal-modes"] ":"] 0] == "0" || [lindex [split [channel get $channel "maximal-modes"] ":"] 1] == "0"} {
            channel set $channel maximal-modes "6:30"
          }
          if {![regexp -- {[0-9]{1,}:[0-9]{1,}} [channel get $channel "maximal-kicks"]] || [lindex [split [channel get $channel "maximal-kicks"] ":"] 0] > 5 || [lindex [split [channel get $channel "maximal-kicks"] ":"] 0] == "0" || [lindex [split [channel get $channel "maximal-kicks"] ":"] 1] == "0"} {
            channel set $channel maximal-kicks "3:10"
          }
          if {![regexp {[1-3]} [channel get $channel "punish-methode"]]} {
            channel set $channel punish-methode "3"
          }
          if {[channel get $channel "protected-modes"] == ""} {
            channel set $channel protected-modes "iksprDlb bCnNt"
          }
          if {[channel get $channel "chanmode"] == ""} {
            channel set $channel chanmode "+CnNtu-rkspmiDd"
          }
          if {[channel get $channel "kick-message"] == ""} {
            channel set $channel kick-message "Kicked (*.xela.development (:nickname: (:reason: (ID: :counter:))))"
          }
          if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
            die "WEEEE COPYRIGHT ABUSER WEE :D"
          }
          foreach {reaction value} [array get ::protection::settings::reactions] {
            if {[channel get $channel "reaction-$reaction"] == ""} {
              channel set $channel reaction-$reaction $value
            }
          }
        }

    }

    # --- copyright information

      putlog "protectio\037n\037\002:\002 v$::protection::settings::version developed by $::protection::settings::author"

      if {![info exists ::protection::settings::author] || [info exists ::protection::settings::author] && ![string equal 1pr/X1lH0dx0oJYDZ/pNsjV.xLysJ/N77mt.ew3xD.lSY/w/ [encrypt xela $::protection::settings::author]]} {
        die "Uh, Oh, Yeah, you really think you can use my script without my copyright ???? :D"
      }
