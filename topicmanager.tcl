    #                       
    #       +------------------------------------------------------+
    #       | © Christian 'chris' Hopf <mail@dev.christianhopf.de> |
    #       +------------------------------------------------------+
    #                                                                     
    #          
    #           developer:  Christian 'chris' Hopf
    #           system:     eggdrop v1.6.18+RC1 - tcl/tk v.8.5a2
    #           product:    topic manager (http://www.christianhopf.de/?page_id=58)
    #           version:    1.0.0.1
    #                         
    #           contact:    mail@dev.christianhopf.de
    #           irc:        #chris at QuakeNet
    #           web:        www.christianhopf.de
    #


    # topic manager 1.0.0.1
    # copyright (c) 2006 Christian 'chris' Hopf

    # This program is free software; you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation; either version 2 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with this program; if not, write to the Free Software
    # Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
    #
    #
    # changelog
    #
    #   24.07.2006 - 1.0.0.0 release
    #   26.07.2006 - 1.0.0.1
    #                 changed:
    #                   - resynch use Q, if function is enabled
    #
    #
    #   for more questions please ask via eMail or IRC (#chris at QuakeNet)
    #
    
    
    # --- namespace ::topic
    namespace eval ::topic {
      
      # --- namespace variable   
      namespace eval variable {         
        
        # string variable trigger {default}
        variable trigger "!topic"
        
        # string variable keyword {default}
        variable keyword "topic"
        
        # string variable flag
        variable flag "nm|nm"
        
        # integer variable botnick
        # 0 = botnick keyword command text
        # 1 = botnick command text
        variable botnick 1
        
        # integer variable update {default}
        # 0 = no notify, if an update is available
        # 1 = notify, if an update is available (only for bot owners)
        variable update 1

        # {{{ NOW don't change anything, if you aren't 100% sure what you are doing }}}
        # {{{ NOW don't change anything, if you aren't 100% sure what you are doing }}}
        # {{{ NOW don't change anything, if you aren't 100% sure what you are doing }}}
        # {{{ NOW don't change anything, if you aren't 100% sure what you are doing }}}
        
        # string variable up2date
        variable up2date "http://stuff.christianhopf.de/script/index.php?script=topic"
        
        # string variable regexp (for trigger)
        variable regexp {[!|\?|.|-|²|\%|&|\*|:|\+|$|A-Z|a-z]}
        
        # string variable topicregexp
        variable topicregexp {[!|\?|.|-|²|\%|&|\*|:|\+|$|A-Z|a-z]}
        
        # string variable author
        variable author "2006 Christian 'chris' Hopf \002(\002#chris - www.christianhopf.de\002)\002"
        
        # string variable version
        variable version "v1.0.0.1"
        
        package require http
        
        # user defined
        setudef str topic-skin
        setudef str topic-variable
        setudef flag topic-q
        setudef flag topic-resynch
        setudef flag topic-save
        
      }
      
      # binds
      bind PUBM -|- {*} ::topic::pubm
      bind MSGM -|- {*} ::topic::msgm
      bind TOPC -|- {*} ::topic::tsave
      
      foreach time {12 15 19 00} {
        bind TIME -|- "00 $time *" ::topic::up2date
      }
      
      foreach time {03 09 15 21} {
        bind TIME -|- "00 $time *" ::topic::resynch
      }      
      
      # - void proc pubm {bind PUBM}
      proc pubm { nickname hostname handle channel arguments } {
          ::topic::parse $nickname $hostname $handle $arguments $channel "pubm"
      }
      
      # - void proc msgm {bind MSGM}
      proc msgm { nickname hostname handle arguments } {
          ::topic::parse $nickname $hostname $handle $arguments [lindex [split $arguments] 2] "msgm"
      }
      
      # - void proc up2date {bind TIME}
      proc up2date { {args ""} } {
          regexp -- {(.+) \| (.+) \| (.+) \| (.+) \| (.+)} [::topic::utilities::up2date] -> id name link version help
          
          set publicversion [string map {"." ""} $version]
          set scriptversion [string map {"v" "" "." ""} $::topic::variable::version]
          
          if { $publicversion > $scriptversion } {
            foreach owner [userlist n] {
              if { [::topic::utilities::update $owner] && [hand2nick $owner] != "" } {
                putserv "NOTICE [hand2nick $owner] :\002(\002\037topic\037\002)\002 a new version of your topic is available (v${version}). more infos at $help"
              }
            }
          }
      }
      
      # - void proc resynch {bind TIME}
      proc resynch { {args ""} } {
          foreach channel [channels] {
            if { [channel get $channel topic-resynch] } {
              
              if {[onchan Q $channel] && [channel get $channel topic-q]} {
                putquick "PRIVMSG Q :SETTOPIC $channel Resynching ..."
                utimer 2 [list ::topic::utilities::check:topic:status $channel $nickname $topic]
              } else {
                putquick "TOPIC $channel :Resynching ..."
              }
              utimer 3 [list ::topic::utilities::settopic $channel]
            }
          }
      }
      
      # - void proc tsave {bind TOPC}
      proc tsave { nickname hostname handle channel topic } {
          global warn
          
          if { ![channel get $channel topic-save] || [isbotnick $nickname] } { 
            return
          }
          
          if { ![matchattr $handle nm|mn $channel] } {
            putquick "MODE $channel -o $nickname"
            ::topic::utilities::settopic $channel
            
            if { ![info exists warn($hostname)] } {
              putserv "NOTICE $nickname :You are not allowed to change the topic, if you do that wants again u risk a kick."
              set warn($hostname) 1
              timer 30 [list unset warn($hostname)]
            } else {
              putquick "KICK $channel $nickname :You are not allowed to change the fucking topic!"
            }
          } else {
            channel set $channel topic-skin $topic
            putserv "NOTICE $nickname :the new topic has been saved"
          }
      }
      
      # - void proc parse
      proc parse { nickname hostname handle arguments channel mode} {
          global botnick rchannel lastparse lastchannel lastnickname
          
          set utrigger [::topic::utilities::trigger $handle]
          set ukeyword [::topic::utilities::keyword $handle]
          set rchannel $channel
  
          if { $mode == "pubm" } {
  
            if { $::topic::variable::botnick == 1 && [string equal -nocase $botnick [lindex [split $arguments] 0]] } {
              set command [string tolower [lindex [split $arguments] 1]]
              set arguments [join [lrange [split $arguments] 2 end]]
              set lastparse "$botnick $command"
            } elseif { $::topic::variable::botnick == 0 && [string equal -nocase $botnick [lindex [split $arguments] 0]] && [string equal -nocase $::topic::variable::keyword [lindex [split $arguments] 1]] } {
              set command [string tolower [lindex [split $arguments] 2]]
              set arguments [join [lrange [split $arguments] 3 end]]
              set lastparse "$botnick $utrigger $command"            
            } elseif { [string equal -nocase $utrigger [lindex [split $arguments] 0]] } {
              set command [string tolower [lindex [split $arguments] 1]]
              set arguments [join [lrange [split $arguments] 2 end]]
              set lastparse "$utrigger $command" 
            } else {
              return
            }
            
            if {[string index [lindex [split $arguments] 0] 0] == "#" && [validchan [lindex [split $arguments] 0]]} {
              set channel [lindex [split $arguments] 0]
              set arguments [join [lrange [split $arguments] 1 end]]
            }
          
          } elseif { $mode == "msgm" } {
            if { [string equal -nocase [lindex [split $arguments] 0] $ukeyword] } {
              set command [lindex [split $arguments] 1]
              set channel [lindex [split $arguments] 2]              
              set arguments [join [lrange [split $arguments] 3 end]]
              set lastparse "$ukeyword $command"          
            } else {
              return
            }
            
          } else {
            return
          }
          
          if { ![matchattr $handle $::topic::variable::flag $channel] } {
            return
          } elseif {![info exists lastparse] || [llength [split $lastparse]] < 1} {
            return
          } elseif {(![info exists command] || [llength [split $command]] < 1)} {
            return
          } elseif { [info proc ::topic::command:$command] == ""  } {
            return
          } elseif { ![botisop $channel] && ![channel get $channel topic-q] && [string match "*t*" [lindex [split [getchanmode $channel] 0]]] } {
            putserv "NOTICE  $nickname :\002(\002\037topic\037\002)\002 i need operator status to do my work"
            
            return
          } elseif { ![validchan $channel] } {
            if { $mode == "msgm" } {
              putserv "PRIVMSG $nickname :\002(\002\037trigger\037\002)\002 you forgot the channel parameter!"
              
              return
            }
          }
          
          set lastnickname $nickname
          set lastchannel $channel
          ::topic::command:$command $nickname $hostname $handle $channel $arguments
      }      
      
      
      if { ![string equal [md5 $::topic::variable::author] "011281e61b37fa84d5042e0d2ec3aec5"] } {
        die "touching my copyright suxx :("
      }
      
      # - void proc remove
      proc command:remove { nickname hostname handle channel arguments } {
          global lastparse
            
          if { [llength $arguments] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 synta\037x\037\002:\002 $lastparse \037?#channel?\037 <\037variable\037>"
             
            return
          }
         
          set variable [lindex [split $arguments] 0]
          
          if { ![::topic::utilities::exist $channel $variable] } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \0034error\003: sorry, your variable name (${variable}) doesn't exists"
          } elseif { [::topic::utilities::delete $channel $variable] } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \0033done\003: successfully deleted variable $variable"
          } else {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \0034error\003: sorry, an unknown error caused please contact the developer of this script"
          }
          
          ::topic::utilities::settopic $channel
          
          return
      }
      
      # - void proc set
      proc command:set { nickname hostname handle channel arguments } {
          global lastparse
            
          if { [llength [split $arguments]] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 synta\037x\037\002:\002 $lastparse \037?#channel?\037 <\037variable\037> <\037value\037>"
             
            return
          }
         
          set variable [lindex [split $arguments] 0]
          set value [join [lrange [split $arguments] 1 end]]
          
          if { ![::topic::utilities::exist $channel $variable] } {
            if { ![regexp -- $::topic::variable::topicregexp $variable] } { 
              putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \0034error\003: sorry, but special chars are not allowed as variable name"
            
              return 
            }
            
            if { [::topic::utilities::add $channel $variable $value] } {
              putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \0033done\003: successfully added variable $variable"
            } else {
              putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \0034error\003: sorry, an unknown error caused please contact the developer of this script"
            }
            
          } elseif { [::topic::utilities::set:var $channel $variable $value] } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \0033done\003: successfully set variable $variable to $value"
          } else {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \0034error\003: sorry, an unknown error caused please contact the developer of this script"
          }
          
          ::topic::utilities::settopic $channel
          
          return
      }
      
      # - void proc settopic
      proc command:settopic { nickname hostname handle channel arguments } {
          global lastparse
          
          if { [llength [split $arguments]] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 synta\037x\037\002:\002 $lastparse \037?#channel?\037 <\037topic\037>"
            
            if { [set varlist [::topic::utilities::varlist $channel]] != 0 } {
              putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 current variabl\037e\037\002:\002 $varlist"
            }
            
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 curren\037t\037\002:\002 [join [channel get $channel topic-skin]]"
            
            return
          }
          
          channel set $channel topic-skin $arguments
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 successfully set new topic!"
          ::topic::utilities::settopic $channel
      }
            
      # - void proc resynch
      proc command:resynch { nickname hostname handle channel arguments } {
          global lastparse           
          
          if { [llength $arguments] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 synta\037x\037\002:\002 $lastparse \037?#channel?\037 <\037on/enable|off/disable\037>"
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 curren\037t\037\002:\002 [expr {([channel get $channel "topic-resynch"]) ? "\0033enabled\003" : "\0034disabled\003"}]"
            
            if { ![string equal -nocase [channel get $channel topic-skin] [topic $channel]] } {
              ::topic::utilities::settopic $channel
            }
            
            return
          }
          
          switch -- [string tolower [lindex [split $arguments] 0]] {
            {on} - {enable} {
              channel set $channel +topic-resynch
            }
            
            {off} - {disable} {
              channel set $channel -topic-resynch
            }
          }
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 topic resynch is now [expr {([channel get $channel "topic-resynch"]) ? "\0033enabled\003" : "\0034disabled\003"}]"
      }
      
      # - void proc q
      proc command:q { nickname hostname handle channel arguments } {
          global lastparse           
          
          if { [llength $arguments] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 synta\037x\037\002:\002 $lastparse \037?#channel?\037 <\037on/enable|off/disable\037>"
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 curren\037t\037\002:\002 [expr {([channel get $channel "topic-q"]) ? "\0033enabled\003" : "\0034disabled\003"}]"
            
            return
          }
          
          if { ![onchan Q $channel] } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 i cant see Q in $channel <:(, so the script will automatically disable this function"
            if { [channel get $channel topic-q] } {
              channel set $channel -topic-q
            }
            
            return
          }
          
          switch -- [string tolower [lindex [split $arguments] 0]] {
            {on} - {enable} {
              channel set $channel +topic-q
            }
            
            {off} - {disable} {
              channel set $channel -topic-q
            }
          }
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 topic by Q is now [expr {([channel get $channel "topic-q"]) ? "\0033enabled\003" : "\0034disabled\003"}]"
      }      
      
      # - void proc save
      proc command:save { nickname hostname handle channel arguments } {
          global lastparse           
          
          if { [llength $arguments] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 synta\037x\037\002:\002 $lastparse \037?#channel?\037 <\037on/enable|off/disable\037>"
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 curren\037t\037\002:\002 [expr {([channel get $channel "topic-save"]) ? "\0033enabled\003" : "\0034disabled\003"}]"
            
            return
          }
          
          switch -- [string tolower [lindex [split $arguments] 0]] {
            {on} - {enable} {
              channel set $channel +topic-save
            }
            
            {off} - {disable} {
              channel set $channel -topic-save
            }
          }
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 topic save is now [expr {([channel get $channel "topic-save"]) ? "\0033enabled\003" : "\0034disabled\003"}]"
      }
      
      # - void proc show
      proc command:show { nickname hostname handle channel arguments } {
          global lastparse      
          
          set varlist [::topic::utilities::varlist $channel]
          
          if { $varlist == 0 } {
            putquick "NOTICE $nickname :\002(\002\037topic\037\002)\002 there are no variables defined for $channel."
            
            return
          }
          
          foreach var $varlist  {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 ${var}: [::topic::utilities::get:value $channel $var]"
          }
      }
      
      if { ![string equal "011281e61b37fa84d5042e0d2ec3aec5" [md5 $::topic::variable::author]] } {
        die "you're a lamer :("
      }       
      
      
      # - void proc up2date?
      proc command:up2date? { nickname hostname handle channel arguments } {            
          if {[info exists ::topicflood(protection_u)] && [expr [unixtime] - $::topicflood(protection_u)] < 120} { 
            return
          }
          
          set ::topicflood(protection_u) [unixtime]                    
          regexp -- {(.+) \| (.+) \| (.+) \| (.+) \| (.+)} [::topic::utilities::up2date] -> id name link version help
          
          set publicversion [string map {"." ""} $version]
          set scriptversion [string map {"v" "" "." ""} $::topic::variable::version]
          
          if { $publicversion > $scriptversion } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 ffs, your script is out of date <:( please update it to the new one v${version} ($help)"
          } else {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 your script is up to date :o)"
          }
      }      
      
      # - void proc contact
      proc command:contact { nickname hostname handle channel arguments } {            
          if {[info exists ::topicflood(protection_c)] && [expr [unixtime] - $::topicflood(protection_c)] < 120} { 
            return
          }
        
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 eMai\037l\037\002:\002 mail@dev.christianhopf.de - irc\002:\002 #chris at QuakeNet - web\002:\002 www.christianhopf.de"
          set ::topicflood(protection_c) [unixtime]        
      }
      
      # - void proc webhelp
      proc command:webhelp { nickname hostname handle channel arguments } {            
          if {[info exists ::topicflood(protection_w)] && [expr [unixtime] - $::topicflood(protection_w)] < 120} { 
            return
          }
        
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 webhelp\002:\002 http://www.christianhopf.de/?page_id=58"
          set ::topicflood(protection_w) [unixtime]        
      }
      
      # - void proc version
      proc command:version { nickname hostname handle channel arguments } {            
          if {[info exists ::topicflood(protection_v)] && [expr [unixtime] - $::topicflood(protection_v)] < 120} { 
            return
          }
          
          if { [string match "*c*" [getchanmode $channel]] } {
            putserv "PRIVMSG $channel :\001ACTION [stripcodes rcub "is running the topic $::topic::variable::version (c) $::topic::variable::author"]\001"
          } else {
            putserv "PRIVMSG $channel :\001ACTION is running the topic manager $::topic::variable::version \002(\002c\002)\002 $::topic::variable::author\001"
          }
          
          set ::topicflood(protection_v) [unixtime]        
      }
      
      if { ![string equal [md5 $::topic::variable::author] "011281e61b37fa84d5042e0d2ec3aec5"] } {
        die "i think, that i dont like YOU! <:("
      }      
      
      # - void proc trigger
      proc command:trigger { nickname hostname handle channel arguments } { 
          global botnick botname lastparse

          set trigger [::topic::utilities::trigger $handle]            
          
          if { [llength $arguments] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 synta\037x\037\002:\002 $lastparse <\037trigger\037>"
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 your personal trigger is $trigger"
            
            
            return
          } elseif { [llength [set trigger [string map { " " "" } [join [regexp -all -inline "$::topic::variable::regexp" [split [lindex [split $arguments] 0]]]]]]] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 your trigger has too many charactes which are not allowed as trigger"
            
            return
          }
          
          setuser $handle XTRA topic-trigger $trigger
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 your personal trigger is now: [getuser $handle XTRA topic-trigger]"
      }
      
      # - void proc keyword
      proc command:keyword { nickname hostname handle channel arguments } { 
          global botnick botname lastparse
          set keyword [::topic::utilities::keyword $handle]            
          
          if { [llength $arguments] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 synta\037x\037\002:\002 $lastparse <\037keyword\037>"
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 your personal keyword is $keyword"
            
            return
          } elseif { ![regexp -nocase {^[a-z]{1,}$} [lindex [split $arguments] 0]] } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 only alphabetical chars are allowed."
            
            return
          }
          
          setuser $handle XTRA topic-keyword [lindex [split $arguments] 0]
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 your personal keyword is now: [getuser $handle XTRA topic-keyword]"
      }
      
      # - void proc update
      proc command:update { nickname hostname handle channel arguments } { 
          global botnick botname lastparse
          set update [::topic::utilities::update $handle]            
          
          if { [llength $arguments] < 1 } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 synta\037x\037\002:\002 $lastparse <\0371|0\037>"
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 currently update info is [expr {([getuser $handle XTRA topic-update]) ? "\0033enabled\003" : "\0034disabled\003"}]"
            
            return
          } elseif { ![string is int [lindex [split $arguments] 0]] && [lindex [split $arguments] 0] != 0 && [lindex [split $arguments] 0] != 1   } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 only 1 and 0 are as value allowed."
            
            return
          }
          
          setuser $handle XTRA topic-update [lindex [split $arguments] 0]
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 your personal updater info is now: [expr {([getuser $handle XTRA topic-update]) ? "\0033enabled\003" : "\0034disabled\003"}]"
      }
      
      # - void proc help
      proc command:help { nickname hostname handle channel arguments } { 
          ::topic::command:userhelp $nickname $hostname $handle $channel $arguments
      }
      
      # - void proc showcommands
      proc command:showcommands { nickname hostname handle channel arguments } { 
          ::topic::command:userhelp $nickname $hostname $handle $channel $arguments
      }
      
      # - void proc commands
      proc command:commands { nickname hostname handle channel arguments } { 
          ::topic::command:userhelp $nickname $hostname $handle $channel $arguments
      }      
      
      
      # - void proc userhelp
      proc command:userhelp { nickname hostname handle channel arguments } {            
          set trigger [::topic::utilities::trigger $handle]
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \037topic command overview\002\037:\002"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger settopic \037?#channel?\037 <\037topic\037>"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger save \037?#channel?\037 <\037on|off\037>"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger resynch \037?#channel?\037 <\037on|off\037>"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger Q \037?#channel?\037 <\037on|off\037>"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger up2date?"
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger set \037?#channel?\037 <\037variable\037> <\037value\037>"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger remove \037?#channel?\037 <\037variable\037>"          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger show \037?#channel?\037 (shows all variable you already set)"
          
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002"
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \037user command overview\002\037:\002"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger trigger \037?trigger?\037 \002(\002personal trigger\002)\002"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger keyword \037?keyword?\037 \002(\002personal keyword\002)\002"
          
          if { [matchattr $handle n] } {
            putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger update \037?1|0?\037 \002(\002personal update info (on/off))\002)\002"
          }
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002"
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 \037author command overview\002\037:\002"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger webhelp"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger contact"
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 $trigger version \037?#channel?\037"        
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002"
          
          putserv "NOTICE $nickname :\002(\002\037topic\037\002) \037note\037:\002 \037?word?\037 -> optional AND <\037word\037> -> required"
      }
     
      # namespace eval utilities
      namespace eval utilities {
        
        # - void proc up2date
        proc up2date { } {
            set connection [http::config -useragent "Mozilla 4.0"]
          
            if {[catch { set connection [http::geturl $::topic::variable::up2date -timeout 1000] } error]} {
              putlog "\002(\002\037topic\037\002)\002 error while reading up2date site. \002(\002$error\002)\002"
              
              return
            }
            
            set source [string trim [http::data $connection]]
            http::cleanup $connection
            
            foreach data [split $source "\n"] {
              if { [regexp -- {^<input type='hidden' value='(.+)'>} $data -> result] } {
                return $result
              }
            }
        }

        # - void proc trigger
        proc trigger { handle } {
            set utrigger [getuser $handle XTRA topic-trigger]
            
            if {[llength $utrigger] < 1 || ![validuser $handle]} {
              set utrigger [join [string trim $::topic::variable::trigger]]
            }
                       
            return $utrigger
        }
        
        # - void proc update
        proc update { handle } {
            set uupdate [getuser $handle XTRA topic-update]
            
            if {[llength $uupdate] < 1 || ![validuser $handle]} {
              set uupdate [join [string trim $::topic::variable::update]]
            }
                       
            return $uupdate
        }
        
        # - void proc keyword
        proc keyword { handle } {
            set ukeyword [getuser $handle XTRA topic-keyword]
            
            if {[llength $ukeyword] < 1 || ![validuser $handle]} {
              set ukeyword [join [string trim $::topic::variable::keyword]]
            }
                       
            return $ukeyword
        }
        
        # - void proc add
        proc add { channel variable value } {
            if { [llength [channel get $channel "topic-variable"]] < 1 } {
              channel set $channel topic-variable [list "$variable $value"]
            } else {
              channel set $channel topic-variable "[channel get $channel topic-variable] [list "$variable $value"]"
            }
            
            return 1
        }
        
        # - void proc exist
        proc exist { channel value } {
            if { [lsearch [channel get $channel topic-variable] "$value *"] < 0} {
              return 0
            } else {
              return 1
            }
        }
        
        # - void proc delete
        proc delete { channel value } {
            set data [list]
            
            foreach text [channel get $channel topic-variable] { 
              set var [lindex [split $text] 0]
              
              if { [string equal -nocase $var $value] } {
                continue          
              }
    
              lappend data $text
            }
            
            channel set $channel topic-variable $data
            
            return 1
        }
        
        # - void proc settopic
        proc settopic { channel } {
            global lastnickname
            
            set replace [list]
            
            foreach temp [::topic::utilities::varlist $channel] {
                lappend replace "\"$temp\" \"[::topic::utilities::get:value $channel $temp]\""
            }
            
            set topic [string map [join $replace] [channel get $channel "topic-skin"]]

            if {[onchan Q $channel] && [channel get $channel topic-q]} {
              putquick "PRIVMSG Q :SETTOPIC $channel $topic"
              utimer 4 [list ::topic::utilities::check:topic:status $channel $::botnick $topic]
            } else {
              if { ![botisop $channel] } {
                putserv "PRIVMSG $channel :I need Operator Status to set the new topic."
              } else {
                putquick "TOPIC $channel :$topic"
              }
            }
        }
        
        proc check:topic:status { channel nickname topic } {
            if { [string equal -nocase $topic [topic $channel]] } {
              return
            } else {
              if { ![botisop $channel] } {
                putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 I need Operator Status to set the new topic."
              } else {
                putquick "TOPIC $channel :$topic"
              }
              putserv "NOTICE $nickname :\002(\002\037topic\037\002)\002 :Q says i dont have +t flag on that channel, so the Q function will be disabled!"
              channel set $channel -topic-q
            }
        }
        
        if { ![string equal [md5 $::topic::variable::author] "011281e61b37fa84d5042e0d2ec3aec5"] } {
          die "u know c o p y r i g h t? no? <:("
        }
        
        # - void proc varlist
        proc varlist { channel } {
            set data ""
            
            foreach text [channel get $channel topic-variable] { 
              lappend data [lindex [split $text] 0]
            }
            
            if { [llength $data] < 1 } {
              return 0
            }
                    
            return $data
        }
        
        # - void proc get:value
        proc get:value { channel variable } {        
            foreach text [channel get $channel topic-variable] { 
              set var [lindex [split $text] 0]
              
              if { [string equal -nocase $var $variable] } {
                regsub -all -- {(\\|\[|\]|\"|\")} $text {\\\1} text
                return [join [lrange [split $text] 1 end]]
              }
            }
                    
            return 0
        }
        
        # - void proc set:var
        proc set:var { channel variable value } {
            set data ""
            
            foreach text [channel get $channel topic-variable] { 
              set var [lindex [split $text] 0]
              
              if { [string equal -nocase $var $variable] } {
                set text "$var $value"
              }
    
              lappend data $text
            }
            
            channel set $channel topic-variable $data
            return 1
         }
      }
      
      # log
      putlog "topic manager version <${::topic::variable::version}> (c) $::topic::variable::author successfully loaded ..."
    }
