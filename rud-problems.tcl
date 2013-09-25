######################
#  rud-problems.tcl  #
######################
#
##########
#  Info  #
##########
#
# webpage: http://www.distorted.se/tcl/
#
# A script to handle problems and requests for crews (siteops or others). Users report problems with !problem <problem goes here> or if they need
# siteop attention they can use !siteop <whatever>. Bot pastes the stuff in the crew chan. Problems are listable with !problems.
# Announce unsolved problems periodically and most output is cookied as usual.
#
#############
#  Licence  #
#############
#
# Feel free to do whatever with this script as long as I'm credited as original author
#
###############
#  Changelog  #
###############
#
# 2009-04-08 0.6.1
#    Fixed a problem with unknown var in the rud:problems:timer:problems proc
#
# 2007-07-28 0.6
#    Fixed so rud:problems:pub:addproblem requires minimum 1 argument
#    Added option to print in mainchan(s) when a problem is fixed
#
# 2007-07-26 0.5
#	 Initial alpha release
#
#####################
#  Config Settings  #
#####################

## file to store the problems in ?
set rudproblems(file) "data.problems"

## what channel should it allow the crew stuff in ? (listing and fixing, also chan that's posted on adds)
set rudproblems(crewchan) "#personal"

### Timer stuff ###

## max number of problems to show when triggered by timer, -1 for all (consider anti-flood protection)
set rudproblems(showtimer) 10

## timer headerstyle
set rudproblems(header) "\0037\002PROBLEMS:\002 - !problems for a longer list\003"

## what delay between the problems in minutes, 0 disables timed announce
set rudproblems(timer) 0

## what delay in minutes from loading this script till it prints the problems first time, 0 disables timed announce
set rudproblems(firstrun) 10

## header for timer announce
set rudproblems(header) "Unresolved problems:"

### Display ###

## max number of problems to show when triggered by !problems, -1 for all (consider anti-flood protection)
set rudproblems(showtrigger) -1

## Where to display !problems and !fixed output, 0 = chan, 1 = privmsg, 2 = notice
set rudproblems(method) 0

## dateformat (default is: 2007-07-25 16:20) http://www.tcl.tk/man/tcl8.4/TclCmd/clock.htm#M6 for help
set rudproblems(dateformat) "%Y-%m-%d %H:%M"

## linestyle for problems; %id, %time, %adder, %problem are valid cookies
set rudproblems(problemline) "%id - \[%time\] %adder: %problem"

## linestyle for fixed problems; %id, %time, %adder, %problem, %fixer and %solution are valid cookies
set rudproblems(fixedline) "%id - \[%time\] %adder: %problem  ::  %fixer's solution: %solution"

## add problem style, %user and %problem are valid cookies
set rudproblems(addstyle) "\0037\002Problem added by %user:\002\003 %problem"

## message sent to the adder to notify that the siteops been informed
set rudproblems(addmsg) "Okey, siteops have been informed"

## message sent to fixer (chan, privmsg or notice); %id, %time, %adder, %problem, %fixer, %solution and %problems are valid cookies
set rudproblems(fixedmsg) "%fixer fixed \"%problem\" (id: %id) added by %adder at %time, solution was \"%solution\". %unsolved problems remain unsolved."

## notify the following channels about the fix
set rudproblems(fixedchans) "#chatworld"

## message to send to those channels; %id, %time, %adder, %problem, %fixer, %solution and %problems are valid cookies
set rudproblems(fixedchansmsg) "%fixer fixed \"%problem\" added by %adder at %time"

## text to display if nothing is found while searching, %search for the search string
set rudproblems(nothingfound) "No problems was found when searching for %search"

### Help ###

## help text for rud:problems:pub:siteop (!siteop !problem)
set rudproblems(problemhelp) {
!siteop <problem/message/request>
}

## help text for rud:problems:pub:problems (!problems)
set rudproblems(problemshelp) {
!problems [-fixed] [searchstring]
}

## help text for rud:problems:pub:siteop (!fixed)
set rudproblems(fixedhelp) {
!fixed <id> <solution>
}


##############
#  Bindings  #
##############

# the o means that only users the bot recognize as op will be allowed to use the command
# set this to - to allow all users no matter the status in the bot to run the command

bind pub - !siteop	rud:problems:pub:problem
bind pub - !problem rud:problems:pub:problem
bind msg - !siteop	rud:problems:msg:problem
bind msg - !problem rud:problems:msg:problem

bind pub o !problems rud:problems:pub:problems

bind pub o !fixed rud:problems:pub:fixed


###############################
#  No edit below here needed  #
###############################

set rudproblems(version) 0.6.1

proc rud:problems:void:switch { nick chan output } {
	switch $::rudproblems(method) {
		0 {
			putserv "PRIVMSG $chan :$output"
		}
		1 {
			putserv "PRIVMSG $nick :$output"
		}
		2 {
			putserv "NOTICE $nick :$output"
		}
	}
}

proc rud:problems:pub:problems { nick uhost handle chan arg } {
	upvar #0 rudproblems conf

	if { $chan == $conf(crewchan) } {
		if { $arg eq "help" } {
			foreach line [split $conf(problemshelp) \n] {
				if { [string trim $line] != "" } {
					putserv "NOTICE $nick :$line"
				}
			}
			return
		}
	
		set fp [open $conf(file) r]
		set data [split [read $fp] "\n"]
		close $fp

		if { [lindex [split $arg] 0] eq "-fixed" } {
			set showfixed 1
			set searchstring [join [lrange [split $arg] 1 end]]
		} else {
			set showproblems 1
			set searchstring $arg
		}

		if { [string trim $searchstring] == "" } {
			set searchstring *
		}

		foreach line $data {
			if { [string trim $line] == "" } { continue }
			if { [string match -nocase "*$searchstring*" [join $line]] } {
				
				lappend newdata $line
			}
		}

		if { ![info exists newdata] } { rud:problems:void:switch $nick $chan [string map [list %search $searchstring] $conf(nothingfound)] ; return }
		
		if { $conf(showtrigger) > [llength $newdata] } { set newdata [lrange $newdata end-$conf(showtrigger) end] }

		set i 0
		foreach line $newdata {
			foreach { id time status adder problem fixer solution } $line { }
			if { $status && [info exist showfixed] } {
				rud:problems:void:switch $nick $chan "[string map [list %id $id %time [clock format $time -format $conf(dateformat)] %adder $adder %problem $problem %fixer $fixer %solution $solution] $conf(fixedline)]"
				incr i
			} elseif { !$status && [info exist showproblems] } {
				rud:problems:void:switch $nick $chan "[string map [list %id $id %time [clock format $time -format $conf(dateformat)] %adder $adder %problem $problem] $conf(problemline)]"
				incr i
			}
		}
		if { $i == 0 } { rud:problems:void:switch $nick $chan [string map [list %search $searchstring] $conf(nothingfound)] }
	}
}

proc rud:problems:pub:problem { nick uhost hand chan arg } {
	set result [rud:problems:void:addproblem $nick $arg]
	switch $result {
		0 { }
		1 { rud:problems:void:switch $nick $chan $::rudproblems(addmsg) }
		default {
			foreach line [split $result \n] {
				rud:problems:void:switch $nick $chan $line
			}
		}
	}
}

proc rud:problems:msg:problem { nick uhost hand arg } {
	set result [rud:problems:void:addproblem $nick $arg]
	switch $result {
		0 { }
		1 { putserv "PRIVMSG $nick :$::rudproblems(addmsg)" }
		default {
			foreach line [split $result \n] {
				putserv "PRIVMSG $nick :$line"
			}
		}
	}
}

proc rud:problems:void:addproblem { adder problem } {
	upvar #0 rudproblems conf

	if { $problem eq "help" || [llength [split $problem]] == 0 } {
		return $conf(problemhelp)
	} else {
		if { [catch {
			set fp [open $conf(file) r+]
			set data [split [read $fp] \n]
			if { [llength $data] == 0 } {
				set id 0
			} else {
				set id [expr [lindex [split [lindex $data [expr [llength $data]-2]]] 0] + 1]
			}
			puts $fp [list $id [clock seconds] 0 $adder $problem {} {}]
			close $fp
		} err] } {
			putlog $err
			return 0
		}
	}
	putserv "PRIVMSG $conf(crewchan) :[string map [list %user $adder %problem $problem] $conf(addstyle)]"
	return 1
}

proc rud:problems:pub:fixed { nick uhost hand chan arg } {
	upvar #0 rudproblems conf
	if {$chan == $conf(crewchan) } {
		if { $arg eq "help" } {
			foreach line [split $conf(fixedhelp) \n] {
				if { [string trim $line] != "" } {
					putserv "NOTICE $nick :$line"
				}
			}
			return
		}
		
		if { [llength [split $arg]] < 2 } { rud:problems:void:switch $nick $chan "Usage: !fixed <id> <solution>" ; return }
	
		set fp [open $conf(file) r]
		set data [split [read $fp] "\n"]
		close $fp

		set id [lindex $arg 0]
		if { ![string is integer $id] } { putserv "NOTICE $nick :id must be an integer" ; return }
		
		set unsolved 0
		foreach line $data {
			if { [lindex $line 0] == $id } {
				foreach { id time status adder problem fixer solution } $line { }
				set fixer $nick
				set solution [lrange $arg 1 end]
				lappend newdata [list $id $time 1 $adder $problem $fixer $solution]
			} else {
				if { [string trim $line] != "" } {
					lappend newdata $line
					if { [lindex $line 2] == 0 } {
						incr unsolved
					}
				}
			}
		}
		
		set fp [open $conf(file) w]
		foreach line $newdata {
			puts $fp $line
		}
		close $fp
		
		rud:problems:void:switch $nick $chan [string map [list %id $id %time [clock format $time -format $conf(dateformat)] %adder $adder %problem $problem %fixer $fixer %solution $solution %unsolved $unsolved] $conf(fixedmsg)]

		foreach chan [split $conf(fixedchans)] {
			putserv "PRIVMSG $chan :[string map [list %id $id %time [clock format $time -format $conf(dateformat)] %adder $adder %problem $problem %fixer $fixer %solution $solution %unsolved $unsolved] $conf(fixedchansmsg)]"
		}
	}
}

proc rud:problems:timer:problems { } {
	upvar #0 rudproblems conf
	if { ![string match "timer*" [timerexists { rud:problems:timer:problems }]] && $conf(timer) > 0 } {
		timer $conf(timer) { rud:problems:timer:problems }
	}
	
	set fp [open $conf(file) r]
	set data [split [read $fp] \n]
	close $fp
	
	foreach line $data {
		if { [string trim $line] == "" } { continue }
		if { [lindex [split $line] 2] == 0 } {
			lappend newdata $line
		}
	}	
	
	if { ![info exists newdata] } { return }
	
	putserv "PRIVMSG $conf(crewchan) :$conf(header)"
	set j 0
	for { set i [expr [llength $newdata] -1] } { $i >= 0 } { incr i -1 } {
		foreach { id time status adder problem fixer solution } [lindex $newdata $i] { }
		putserv "PRIVMSG $conf(crewchan) :[string map [list %id $id %time [clock format $time -format $conf(dateformat)] %adder $adder %problem $problem] $conf(problemline)]"
		incr j
		if { $j >= $conf(showtimer) && $conf(showtimer) != -1 } { break }
	}
}

if { ![string match "timer*" [timerexists { rud:problems:timer:problems }]] && $rudproblems(timer) > 0 && $rudproblems(firstrun) > 0 } {
	timer $rudproblems(firstrun) { rud:problems:timer:problems }
}

if { ![file isfile $rudproblems(file)] } {
	set fp [open $rudproblems(file) w]
	close $fp
}

putlog "rud-problems.tcl $rudproblems(version) by rudenstam loaded..."
