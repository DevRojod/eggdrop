#
#  TCL scripts by Ofloo all rights reserved.
#
#  HomePage: http://ofloo.net/
#  CVS: http://cvs.ofloo.net/
#  Email: support[at]ofloo.net
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
#
#  Requires lib ip2c
#  svn co https://narf.ofloo.net/svn/ip2c.tcl/trunk ip2c
#


#
# Now supports ipv6 lookups, reserved ranges are returned with abbreviation ZZ
#

package require ip2c
package require ip

#
# Change the command trigger
#

set trigger "!ip2c"

#
# Change the bind permissions
#

set permis "-|-"

#
# Cookie list
# %2 : Two letter country abbreveration
# %3 : Tree letter country abbreveration
# %c : Full country name
# %i : IP
# %a : Time allocated IP space
# %r : Assinged registry
#

set message_format "Mapped IP \(\002%i\002\) to \(\002%c\002\)"

#
# Error locate for input
# %e : locate input
#

set error_format "No result found for \(\002%e\002\)"

#
# DNS error
# %i : Failed IP
# %h : Failed host
#

set dns_format "Couldn't assosicate an ip with \(\002%h\002\)"


#
# Time output format http://tcl.tk/man/tcl8.5/TclCmd/clock.htm#M26 for more information
#

set time_format {%D}



#
#  DO NOT EDIT BELOW
#



set ip-to-country 0.9

proc locate {chan arg}  {
  global message_format error_format time_format
  if {[ip2c::locate -ip $arg]} {
    foreach {x} [split $message_format \n] {
      if {[string equal {} $x]} {continue}
      set i 0
      foreach {n} [ip2c::abbr -short] {
        array set short [list $i $n]
        incr i
      }
      set i 0
      foreach {n} [ip2c::abbr -long] {
        array set long [list $i $n]
        incr i
      }
      set i 0
      foreach {n} [ip2c::country] {
        array set country [list $i $n]
        incr i
      }
      set i 0
      foreach {n} [ip2c::country] {
        array set country [list $i $n]
        incr i
      }
      set i 0
      foreach {n} [ip2c::assigned] {
        array set assigned [list $i $n]
        incr i
      }
      set i 0
      foreach {n} [ip2c::registry] {
        array set registry [list $i $n]
        incr i
      }
      for {set i 0} {$i < [llength [ip2c::assigned]]} {incr i} {
        putserv "PRIVMSG $chan :[string trimleft [string map [list \
          %2 $short($i) \
          %3 $long($i) \
          %c [join $country($i)] \
          %i [ip2c::address] \
          %a [clock format $assigned($i) -format [list $time_format]] \
          %r $registry($i) \
        ] $x]]"
      }
    }
    ip2c::cleanup
  } else {
    foreach {x} [split $error_format \n] {
      if {[string equal {} $x]} {continue}
      putserv "PRIVMSG $chan :[string trimleft [string map [list %e $lookup] $x]]"
    }
  }
}

proc dns_callback {ip host status chan}  {
  global dns_format
  if {$status} {
    locate $chan $ip
  } else {
    foreach {x} [split $dns_format \n] {
      if {[string equal {} $x]} {continue}
      putserv "PRIVMSG $chan :[string trimleft [string map [list %i $ip %h $host] $x]]"
    }
  }
}

proc ip2c_proc_pub {nick host hand chan arg}  {
  set locate [lindex [split $arg] 0]
  if {[ip::is ipv4 $locate] || [ip::is ipv6 $locate]} {
    locate $chan $locate
  } else {
    if {[string equal {} $locate]} {
      dnslookup [lindex [split [getchanhost $nick] @] end] dns_callback $chan
    } else {
      dnslookup [lindex [split [getchanhost $locate] @] end] dns_callback $chan
    }
  }
}

bind pub $permis $trigger ip2c_proc_pub

putlog "Loaded ip-to-country script ${ip-to-country}"
