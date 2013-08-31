# Original Script (Diccionario.TCL) by BaRDaHL
#
# by ICU <icu@eggdrop-support.org> (#eggdrop.support @ irc.QuakeNet.org)
#
# Thanks to #eggdrop.support for all the tips and support :)
#
# ChangeLog
# 
# 20030106 - Changed Name to faq.tcl (changed purpose)
#          - Changed some commands
#	   - Updated the language
#	   - Added some commands
#	   - Fixes:)
#
# 20030115 - Changed the ?faq helptext
#	   - Fixed all to key word
#
# 20030122 - Removed some private parts from the script (?send-faq) till 
#	     i found a solution to make it in tcl (not in perl ;-))
#	   - Changed the way ?faq works. it now uses public replys
#	     (requested by #eggdrop.support)
#
# 20030123 - Some cosmetic changes
# 
# 20030219 - Changed matchattr to don't use quotation marks
#
# 20030411 - Fixed handling of some special chars in facts/description. 
#	     Mainly changed listtostring proc.
#	     Thx to |sPhiNX| for reporting ;)
#
# 20030728 - Removed the listtostring proc. 
#            Format updates
#            Spelling
#            Changed matchattr to check for chan M too
#            Switched the Settings handling
#            Added configurable cmdchar, splitchar, glob_flag and chan_flag:
#            cmdchar: char to prefix commands
#            splitchar: seperator between keyword and definition
#            glob_flag: globalflag to be a FAQ Master
#            chan_flag: channelflag to be a FAQ Master
#            Now using keyword instead of key word
#            Switched from using "" to \002
#
# 20030730 - Fixed the "?faq nick key word" bug (wouldn't notice the second
#            part of the word)
#
# 20030731 - Added the ability to limit the chans where the script is active
#          - Bugfixes - thanks to AliTriX on #eggdrop.support
#
# 20030805 - Last bugfixes and public relase v2.07
#
# 20031011 - Honored the latest changes on egghelp.org by slennox
#
# 20040122 - Changed the default faq(splitchar) since it causes some trouble 
#            on TCL 8.4+
#          - Removed egghelp.org stuff for public release.
#
# 20040314 - Using string trim to remove trailing spaces from fact lookups
#            Thanks to bUrN for reporting
#
# 20040629 - Added possibility to use multi-line responses.
#            Thanks to arena7|Blacky for the idea
#
#
# creates a file in your eggdrop-dir to store facts
# if you want to modify the faq-database status you need to have the +M flag
# to set this flag you just need to copy ".chattr <handle> +M" to the partyline
#
# The most current Version is available here: http://no-scrub.de/other/faq.tcl.zip
#
# Depending on your faq(cmdchar) setting prefix something other then a questionmark
# Depending on your faq(splitchar) settings use something other then a paragraph sign
#
# Public commands:
# ?faq-help - usage
# ? keyword - used to look up something from the db
# ?faq nick keyword - used to explain something(keyword) to someone(nick)
#
# Master commands:
# ?addword keyword§definition - used to add something to the db
# ?delword keyword - used to delete something from the db
# ?modify keyword§definition - used to modify a keyword in the db
# ?open-faq - opens the database if closed
# ?close-faq - closes the database if opened

########
# SETS #
########

# File will be created in your eggdrop dir unless you specify a path
# Ex. set faq(database) "/path/to/faqdatabase"
set faq(database) "faqdatabase"

# This char will be prefixed to all commands
set faq(cmdchar) "?"

# This char is used to split the keyword from the definition on irc commands and in the database.
# Note: § will not longer work on TCL 8.4+ for some strange reason.
set faq(splitchar) "|"

# This char is used to split multiple lines in your reply/definition.
# Note: § will not longer work on TCL 8.4+ for some strange reason.
set faq(newline) ";;"

# Global flag needed to use the FAQ Master commands
set faq(glob_flag) "M"

# Channel flag needed to use FAQ Master commands (empty means noone)
set faq(chan_flag) ""

# Channels the FAQ is active on
set faq(channels) "#eggdrop.support #tcl #eggdropzone" 

#################
# END OF CONFIG #
#################














##############
# STOP HERE! #
##############

# Initial Status of the Database (0 = open 1 = closed)
set faq(status) 0
# Current Version of the Database
set faq(version) "20040926 v2.10"

#########
# BINDS #
#########

bind pub - "[string trim $faq(cmdchar)]" faq:explain_fact
bind pub - "[string trim $faq(cmdchar)]faq" faq:tell_fact
bind pub - "[string trim $faq(cmdchar)]addword" faq:add_fact
bind pub - "[string trim $faq(cmdchar)]delword" faq:delete_fact
bind pub - "[string trim $faq(cmdchar)]modify" faq:modify_fact
bind pub - "[string trim $faq(cmdchar)]close-faq" faq:close-faqdb
bind pub - "[string trim $faq(cmdchar)]open-faq" faq:open-faqdb
bind pub - "[string trim $faq(cmdchar)]faq-help" faq:faq_howto

#########
# PROCS #
#########

proc faq:close-faqdb {nick idx handle channel args} {
 global faq
 if { [lsearch -exact [split [string tolower $faq(channels)]] [string tolower $channel]] < 0 } { 
  return 0
 }
 if {![matchattr $handle [string trim $faq(glob_flag)]|[string trim $faq(chan_flag)] $channel]} {
  putnotc $nick "You can't change the faq-database status."
  return 0
 }
 if {$faq(status)==0} {
  set faq(status) 1
  putnotc $nick "The faq-database was \002closed correctly\002."
  putnotc $nick "Now anybody cant use the command '[string trim $faq(cmdchar)] keyword'."
  putnotc $nick "To open the faq-database again use the command '[string trim $faq(cmdchar)]open-faq'."
  return 0
 }
 if {$faq(status)==1} {
  putnotc $nick "The faq-database is \002already closed\002."
  return 0
 }
}

proc faq:open-faqdb {nick idx handle channel args} {
 global faq
 if { [lsearch -exact [split [string tolower $faq(channels)]] [string tolower $channel]] < 0 } {
  return 0
 }
 if {![matchattr $handle [string trim $faq(glob_flag)]|[string trim $faq(chan_flag)] $channel]} {
  putnotc $nick "You can't change the faq-database status."
  return 0
 }
 if {$faq(status)==1} {
  set faq(status) 0
  putnotc $nick "The faq-database was \002opened correctly\002."
  putnotc $nick "Now anybody can use the command '[string trim $faq(cmdchar)] \002keyword\002'."
  putnotc $nick "To close the faq-database again just use the command '[string trim $faq(cmdchar)]close-faq'."
  return 0
 }
 if {$faq(status)==0} {
  putnotc $nick "The faq-database is \002already open\002."
  return 0
 }
}


proc faq:explain_fact {nick idx handle channel args} {
 global faq
 if { [lsearch -exact [split [string tolower $faq(channels)]] [string tolower $channel]] < 0 } {
  return 0
 }
 if {$faq(status) == 1} { 
  putnotc $nick "The faq-database is \002closed\002."
  return 0 
 }
 if {![file exist $faq(database)]} { 
  set database [open $faq(database) w]
  puts -nonewline $database ""
  close $database
 }
 set fact [ string trim [ string tolower [ join $args ] ] ]
 if {$fact == ""} {
#  putmsg $nick "Syntax: [string trim $faq(cmdchar)] \002keyword\002"
  return 0
 }
 set database [open $faq(database) r]
 set dbline ""
 while {![eof $database]} {
  gets $database dbline
  set dbfact [ string tolower [ lindex [split $dbline [string trim $faq(splitchar)]] 0 ]] 
  set dbdefinition [string range $dbline [expr [string length $fact]+1] end]
  if {$dbfact==$fact} {
    if {[string match -nocase "*$faq(newline)*" $dbdefinition]} {
      set out1 [lindex [split $dbdefinition $faq(newline)] 0]
      set out2 [string range $dbdefinition [expr [string length $out1]+2] end]
      putmsg $channel "\002$fact\002: $out1"
      putmsg $channel "\002$fact\002: $out2"
   } else { 
     putmsg $channel "\002$fact\002: $dbdefinition"
   }
   close $database
   return 0
  }
 }
 close $database
 putnotc $nick "I don't know about \002$fact\002."
 if {[matchattr $handle [string trim $faq(glob_flag)]|[string trim $faq(chan_flag)] $channel]} {
  putnotc $nick "You could add \002$fact\002 by using [string trim $faq(cmdchar)]addword \002$fact\002[string trim $faq(splitchar)]Definition goes here."
 } else {
#  putnotc $nick "If you're looking for a TCL-Script try http://www.egghelp.org/cgi-bin/tcl_archive.tcl?strings=$fact"
 }
 return 0
}

proc faq:tell_fact {nick idx handle channel args} {
 global faq
 if { [lsearch -exact [split [string tolower $faq(channels)]] [string tolower $channel]] < 0 } {
  return 0
 }
 if {$faq(status)==1} { 
  putnotc $nick "The faq-database is \002closed\002."
  return 0 
 }
 if {![file exist $faq(database)]} { 
  set database [open $faq(database) w]
  puts -nonewline $database ""
  close $database
 }
 set tellnick [ lindex [split [join $args]] 0 ] 
 set fact [ string trim [ string tolower [ join [ lrange [split [join $args]] 1 end ] ] ] ]
 if {$tellnick == ""} { 
  putnotc $nick "Syntax: [string trim $faq(cmdchar)]faq \002nick\002 keyword"
  return 0 
 }
 if {$fact == ""} { 
  putnotc $nick "Syntax: [string trim $faq(cmdchar)]faq nick \002keyword\002"
  return 0
 }
 set database [open $faq(database) r]
 set dbline ""
 while {![eof $database]} {
  gets $database dbline
  set dbfact [ string tolower [ lindex [split $dbline [string trim $faq(splitchar)]] 0 ] ]
  set dbdefinition [string range $dbline [expr [string length $fact]+1] end]
  if {$dbfact==$fact} {
    if {[string match -nocase "*$faq(newline)*" $dbdefinition]} {
      set out1 [lindex [split $dbdefinition "$faq(newline)"] 0]
      set out2 [string range $dbdefinition [expr [string length $out1]+2] end]
      putmsg $channel "\002$tellnick\002: ($dbfact) $out1"
      putmsg $channel "\002$tellnick\002: ($dbfact) $out2"
    } else {
      putmsg $channel "\002$tellnick\002: ($dbfact) $dbdefinition"
    }
    putlog "FAQ: Send keyword \"\002$fact\002\" to $tellnick by $nick ($idx)"
    close $database
    return 0
  }
 }
 close $database
 putnotc $nick "I don't have the keyword \002$fact\002 in my database."
 if {[matchattr $handle [string trim $faq(glob_flag)]|[string trim $faq(chan_flag)] $channel]} {
  putnotc $nick "You could add \002$fact\002 by using [string trim $faq(cmdchar)]addword \002$fact\002[string trim $faq(splitchar)]Definition goes here."
 } else {
#  putnotc $nick "If you're looking for a TCL-Script try http://www.egghelp.org/cgi-bin/tcl_archive.tcl?strings=$fact"
 }
 return 0
}

proc faq:add_fact {nick idx handle channel args} {
 global faq
 if { [lsearch -exact [split [string tolower $faq(channels)]] [string tolower $channel]] < 0 } {
  return 0
 }
 if {$faq(status)==1} {
  putnotc $nick "The faq-database is \002closed\002."
  return 0
 }
 if {![matchattr $handle [string trim $faq(glob_flag)]|[string trim $faq(chan_flag)] $channel]} {
	putnotc $nick "You can't add keywords into my dababase."
  return 0
 }
 if {![file exist $faq(database)]} {
  set database [open $faq(database) w]
  puts -nonewline $database ""
  close $database
 }
 set fact [ string tolower [ lindex [split [join $args] [string trim $faq(splitchar)]] 0 ] ]
 set definition [string range [join $args] [expr [string length $fact]+1] end]  
 set database [open $faq(database) r]
 if {($fact=="")} {
  putnotc $nick "Left parameters."
  putnotc $nick "use: [string trim $faq(cmdchar)]addword \002keyword\002[string trim $faq(splitchar)]definition"
  return 0
 } elseif {($definition=="")} {
  putnotc $nick "Left parameters."
  putnotc $nick "use: [string trim $faq(cmdchar)]addword keyword[string trim $faq(splitchar)]\002definition\002"
  return 0
 }
 while {![eof $database]} {
  gets $database dbline
  set add_fact [ string tolower [ lindex [split $dbline [string trim $faq(splitchar)]] 0 ] ]
  if {$add_fact==$fact} {
   putnotc $nick "This keyword is already in my database:"
   putnotc $nick "Is: \002$fact\002 - $definition"
   putnotc $nick "If you want to modify it just use '[string trim $faq(cmdchar)]modify $fact[string trim $faq(splitchar)]\002definition\002'"
   close $database
   return 0
  }
 }
 close $database
 set database [open $faq(database) a]
 puts $database "$fact[string trim $faq(splitchar)]$definition"
 close $database
 putnotc $nick "The keyword \002$fact\002 was added correctly to my database."
 putnotc $nick "Now: \002$fact\002 - $definition"
}

proc faq:delete_fact {nick idx handle channel args} {
 global faq
 if { [lsearch -exact [split [string tolower $faq(channels)]] [string tolower $channel]] < 0 } {
  return 0
 }
 if {$faq(status)==1} {
  putnotc $nick "The faq-database is \002closed\002."
  return 0
 }
 if {![matchattr $handle [string trim $faq(glob_flag)]|[string trim $faq(chan_flag)] $channel]} {
  putnotc $nick "You can't delete keywords from my database."
  return 0
 }
 if {![file exist $faq(database)]} { 
  set database [open $faq(database) w]
  puts -nonewline $database ""
  close $database
 }
 set fact [string tolower [join $args]]
 if {($fact=="")} {
  putnotc $nick "Left parameters."
  putnotc $nick "use: [string trim $faq(cmdchar)]delword \002keyword\002"
  return 0
 }
 set database [open $faq(database) r]
 set dbline ""
 set found 0
 while {![eof $database]} {
  gets $database dbline
  set dbfact [ string tolower [ lindex [split $dbline [string trim $faq(splitchar)]] 0 ] ]
  set dbdefinition [string range $dbline [expr [string length $fact]+1] end]
  if {$dbfact!=$fact} {
   lappend datalist $dbline
  } else {
   putnotc $nick "The keyword \002$fact\002 was deleted correctly from my database."
   putnotc $nick "Was: \002$dbfact\002 - $dbdefinition"
   set found 1
  }
 }
 close $database
 set databaseout [open $faq(database) w]
 foreach line $datalist {
  if {$line!=""} {puts $databaseout $line}
 }
 close $databaseout
 if {$found != 1} {putnotc $nick "\002$fact\002 not found in my database."}
}

proc faq:modify_fact {nick idx handle channel args} {
 global faq
 if { [lsearch -exact [split [string tolower $faq(channels)]] [string tolower $channel]] < 0 } {
  return 0
 }
 if {$faq(status)==1} {
  putnotc $nick "The faq-database is \002closed\002."
  return 0
 }
 if {![matchattr $handle [string trim $faq(glob_flag)]|[string trim $faq(chan_flag)] $channel]} {
  putnotc $nick "You can't modify keywords in my database."
  return 0
 }
 if {![file exist $faq(database)]} { 
  set database [open $faq(database) w]
  puts -nonewline $database ""
  close $database
 }
 set fact [ string tolower [ lindex [split [join $args] [string trim $faq(splitchar)]] 0 ] ]
 set definition [string range [join $args] [expr [string length $fact]+1] end]
 set database [open $faq(database) r]
 if {($fact=="")} {
  putnotc $nick "Left parameters."
  putnotc $nick "use: [string trim $faq(cmdchar)]modify \002keyword\002[string trim $faq(splitchar)]definition"
  return 0
 }
 if {($definition=="")} {
  putnotc $nick "Left parameters."
  putnotc $nick "use: [string trim $faq(cmdchar)]modify keyword[string trim $faq(splitchar)]\002definition\002"
  return 0
 }
 set database [open $faq(database) r]
 set dbline ""
 set found 0
 while {![eof $database]} {
  gets $database dbline
  set dbfact [ string tolower [ lindex [split $dbline [string trim $faq(splitchar)]] 0 ] ]
  set dbdefinition [string range $dbline [expr [string length $fact]+1] end]
  if {$dbfact!=$fact} {
   lappend datalist $dbline
  } else {
   if {$dbdefinition!=$definition} {
    lappend datalist "$fact[string trim $faq(splitchar)]$definition"
    putnotc $nick "The keyword \002$fact\002 was modified correctly in my database."
    putnotc $nick "Is now: \002$fact\002 - $definition"
    putnotc $nick "Was: $dbfact - $dbdefinition"
    set found 1
   } else {
    lappend datalist $dbline
    putnotc $nick "I already had it that way. \002$fact\002 was not modified."
    putnotc $nick "Is: \002$fact\002 - $definition"
    set found 1
   }
  }
 }
 close $database
 set databaseout [open $faq(database) w]
 foreach line $datalist {
  if {$line!=""} {puts $databaseout $line}
 }
 close $databaseout
 if {$found != 1} {
  putnotc $nick "\002$fact\002 not found in my database"
  putnotc $nick "If you want to add the fact to the database use: [string trim $faq(cmdchar)]addword $fact[string trim $faq(splitchar)]\002description\002"
 }
}

proc faq:faq_howto {nick idx handle channel args} {
 global faq
 if { [lsearch -exact [split [string tolower $faq(channels)]] [string tolower $channel]] < 0 } {
  return 0
 }
 putnotc $nick "Help commands for FAQ Database $faq(version)"
 if {[matchattr $handle [string trim $faq(glob_flag)]|[string trim $faq(chan_flag)] $channel]} {
  if {$faq(status)==0} {
   putnotc $nick " - [string trim $faq(cmdchar)]close-faq"
   putnotc $nick " - [string trim $faq(cmdchar)]addword : [string trim $faq(cmdchar)]addword \002keyword\002[string trim $faq(splitchar)]your description goes here..."
   putnotc $nick " - [string trim $faq(cmdchar)]delword : [string trim $faq(cmdchar)]delword \002keyword\002"
   putnotc $nick " - [string trim $faq(cmdchar)]modify : [string trim $faq(cmdchar)]modify \002keyword\002[string trim $faq(splitchar)]your new description goes here..."
  }
  if {$faq(status)==1} {
   putnotc $nick " - [string trim $faq(cmdchar)]open-faq"
  }
 }
 if {$faq(status)==0} {
  putnotc $nick " - [string trim $faq(cmdchar)] \002keyword\002 : looks up keyword in the database"
  putnotc $nick " - To let the bot tell someone about something use [string trim $faq(cmdchar)]faq nick \002keyword\002"
 }
 if {$faq(status)==1} {
  putnotc $nick "The faq-database is \002closed\002."
 }
}

#######
# LOG #
#######

putlog "FAQ-Database $faq(version) (by ICU <icu@eggdrop-support.org>) loaded. - Original by BaRDaHL"

#################
# END OF SCRIPT #
#################
