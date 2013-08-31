# ipcheck.tcl v4.0
# arfer <DALnet #Atlantis>

# geolocate a nick, host or numeric ip
# in the case of a nick, a network /whois is sent to derive the host/ip if they are not in a bot
# channel

# v4.0 represents a complete rewrite from previous scripts

# install & load the script in the normal way (after configuration below)
# to function in #channelname requires (in partyline) .chanset #channelname +ipcheck

# syntax
# .ip <nick|host|ip> ... (default geolocation server - see configuration section)
# .ip ?-server? <nick|host|ip> (specified geolocation server - currently -d, -g or -h)

# if region, city, certainty, latitude and longitude fields are not returned by the geolocation
# server, then they are not shown in the script output

# tested and working with eggdrop 1.6.18+ and tcl 8.4+

set vIpcheckVersion 4.0
package require http
setudef flag ipcheck

namespace eval ipcheck {

    # ------------------------------------------------------------------------------------------- #
    # ----- configuration ----------------------------------------------------------------------- #
    # ------------------------------------------------------------------------------------------- #

    # set here the single character command trigger
    set vIpcheckTrigger !

    # set here the text colors used in the bot's responses
    # settings are only valid where channel mode permits color
    # as per mIRC color codes (the existing settings are recommended)
    set vIpcheckColor(arrow) 03
    set vIpcheckColor(compliance) 10
    set vIpcheckColor(dimmed) 14
    set vIpcheckColor(emphasis) 05
    set vIpcheckColor(errors) 04

    # set here the default geolocation server to use (the existing setting is recommended)
    # -d (dnsstuff)
    # -g (geobytes)
    # -h (hostip)
    set vIpcheckDefault -g

    # ------------------------------------------------------------------------------------------- #
    # ----- end of configuration ---------------------------------------------------------------- #
    # ------------------------------------------------------------------------------------------- #

    proc pIpcheckTrigger {} {
        variable vIpcheckTrigger
        return $vIpcheckTrigger
    }

    array set vIpcheckServer {
        -d "dnsstuff"
        -g "geobytes"
        -h "hostip"
    }

    array set vIpcheckUrl {
        -d "http://private.dnsstuff.com/tools/ipall.ch?domain="
        -g "http://www.geobytes.com/IpLocator.htm?GetLocation&ipaddress="
        -h "http://api.hostip.info/get_html.php?position=true&ip="
    }

    bind PUB - [::ipcheck::pIpcheckTrigger]ip ::ipcheck::pIpcheckCommand
    bind RAW - 311 ::ipcheck::pIpcheckRaw311
    bind RAW - 318 ::ipcheck::pIpcheckRaw318
    bind RAW - 402 ::ipcheck::pIpcheckRaw402

    proc pIpcheckBuilder {chan t1 t2 t3 t4 t5 t6 t7} {
        for {set loop 1} {$loop <= 8} {incr loop} {
            set c($loop) [::ipcheck::pIpcheckColor $chan 1 $loop]
        }
        lappend result "Source ($c(3)$t1$c(4)),"
        lappend result "Country ($c(3)$t2$c(4)),"
        if {(![string equal $t3 na]) && (![string equal $t3 unknown])} {lappend result "Region ($c(3)$t3$c(4)),"}
        if {(![string equal $t4 na]) && (![string equal $t4 unknown])} {lappend result "City ($c(3)$t4$c(4)),"}
       # if {(![string equal $t5 na]) && (![string equal $t5 unknown])} {lappend result "Certainty ($c(3)$t5$c(4)),"}
       # if {(![string equal $t6 na]) && (![string equal $t6 unknown])} {lappend result "Latitude ($c(3)$t6$c(4)),"}
       # if {(![string equal $t7 na]) && (![string equal $t7 unknown])} {lappend result "Longitude ($c(3)$t7$c(4)),"}
        return [string trimright [join $result] ,]
    }

    proc pIpcheckCallback {token} {
        variable vIpcheckData
        switch -- [::http::status $token] {
            "timeout" {::ipcheck::pIpcheckError 015 $vIpcheckData(nick) $vIpcheckData(chan)}
            "error" {::ipcheck::pIpcheckError 016 $vIpcheckData(nick) $vIpcheckData(chan) [::http::error $token]}
            "ok" {
                switch -- [::http::ncode $token] {
                    200 {::ipcheck::pIpcheckProcess $token}
                    default {::ipcheck::pIpcheckError 017 $vIpcheckData(nick) $vIpcheckData(chan) [::http::ncode $token]}
                }
            }
        }
        ::http::cleanup $token
        return 0
    }

    proc pIpcheckCommand {nick uhost hand chan text} {
        variable vIpcheckData
        variable vIpcheckDefault
        variable vIpcheckServer
        if {[channel get $chan ipcheck]} {
            if {[array size vIpcheckData] == 0} {
                set txt [split [string trim [subst -nocommands -nobackslashes {$text}]]]
                switch -- [llength $txt] {
                    1 {
                        set vIpcheckData(server) $vIpcheckDefault
                        set vIpcheckData(query) [lindex $txt 0]
                    }
                    2 {
                        if {[lsearch -exact [array names vIpcheckServer] [lindex $txt 0]] != -1} {
                            set vIpcheckData(server) [lindex $txt 0]
                            set vIpcheckData(query) [lindex $txt 1]
                        } else {::ipcheck::pIpcheckError 097 $nick $chan [lindex $txt 0]}
                    }
                    default {::ipcheck::pIpcheckError 098 $nick $chan}
                }
                if {[array size vIpcheckData] != 0} {
                    set vIpcheckData(status) 0
                    set vIpcheckData(nick) $nick
                    set vIpcheckData(chan) $chan
                    utimer 40 ::ipcheck::pIpcheckTimeoutCommand
                    ::ipcheck::pIpcheckParse
                }
            } else {::ipcheck::pIpcheckError 099 $nick $chan}
        }
        return 0
    }

    proc pIpcheckClass {ip} {
        set o1 [lindex [split $ip .] 0]
        set o2 [lindex [split $ip .] 1]
        set o3 [lindex [split $ip .] 2]
        if {($o1 == 0) || ([string equal "255.255.255.255" $ip])} {set t 1}
        if {$o1 == 127} {set t 2}
        if {($o1 == 172) && ($o2 >= 16) && ($o2 <= 31)} {set t 3}
        if {($o1 == 192) && ($o2 == 168)} {set t 3}
        if {$o1 == 10} {set t 3}
        if {($o1 == 192) && ($o2 == 0) && ($o3 == 2)} {set t 4}
        if {($o1 == 169) && ($o2 == 254)} {set t 5}
        if {($o1 >= 224) && ($o1 <= 239)} {set t 6}
        if {![info exists t]} {
            if {($o1 >= 240) && ($o1 <= 255)} {set t 7}
            if {($o1 >= 1) && ($o1 <= 126)} {set t 8}
            if {($o1 >= 128) && ($o1 <= 191)} {set t 9}
            if {($o1 >= 192) && ($o1 <= 223)} {set t 10}
        }
        switch -- $t {
            1  {set text "Broadcast"}
            2  {set text "Loopback"}
            3  {set text "Private LAN"}
            4  {set text "TEST-NET Example Block"}
            5  {set text "Link Local"}
            6  {set text "Multicasting Class D"}
            7  {set text "Experimental Class E"}
            8  {set text "Class A"}
            9  {set text "Class B"}
            10 {set text "Class C"}
        }
        return $text
    }

    proc pIpcheckColor {chan type number} {
        variable vIpcheckColor
        if {[regexp -- {^\+[^-]*c} [getchanmode $chan]]} {
            return ""
        } else {
            switch -- $number {
                1 {
                    switch -- $type {
                        0 {return "\003$vIpcheckColor(errors)"}
                        1 {return "\003$vIpcheckColor(compliance)"}
                    }
                }
                3 {return "\003$vIpcheckColor(dimmed)"}
                5 {return "\003$vIpcheckColor(arrow)"}
                7 {return "\003$vIpcheckColor(emphasis)"}
                2 - 4 - 6 - 8 {return "\003"}
            }
        }
    }

    proc pIpcheckCompliance {number nick chan {t1 ""} {t2 ""} {t3 ""} {t4 ""} {t5 ""} {t6 ""} {t7 ""}} {
        variable vIpcheckData
        for {set loop 1} {$loop <= 8} {incr loop} {
            set c($loop) [::ipcheck::pIpcheckColor $chan 1 $loop]
        }
        set out1 "$c(1)Compliance$c(2) ($c(3)$nick$c(4)) $c(5)-->$c(6)"
        switch -- $number {
            001 {set out2 "target acquired ($c(3)$vIpcheckData(ip)$c(4)) ($c(3)$vIpcheckData(class)$c(4)) $c(5)-->$c(6) [::ipcheck::pIpcheckBuilder $chan $t1 $t2 $t3 $t4 $t5 $t6 $t7]"}
        }
        putserv "PRIVMSG $chan :$out1 $out2"
        switch -glob -- $number {
            09* {return 0}
            default {::ipcheck::pIpcheckReset}
        }
        return 0
    }

    proc pIpcheckDns {ip host status} {
        variable vIpcheckData
        if {[array size vIpcheckData] != 0} {
            foreach item [utimers] {
                if {[string equal ::ipcheck::pIpcheckTimeoutDns [lindex $item 1]]} {
                    killutimer [lindex $item 2]
                }
            }
            switch -- $status {
                0 {
                    switch -- $vIpcheckData(target) {
                        "" {::ipcheck::pIpcheckError 006 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(query)}
                        default {::ipcheck::pIpcheckError 007 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(target) $vIpcheckData(host)}
                    }
                }
                1 {
                    set vIpcheckData(class) [::ipcheck::pIpcheckClass $ip]
                    set vIpcheckData(ip) $ip
                    if {[string match Class* $vIpcheckData(class)]} {
                        ::ipcheck::pIpcheckFetch
                    } else {
                        switch -- $vIpcheckData(target) {
                            "" {::ipcheck::pIpcheckError 008 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(query) $ip $vIpcheckData(class)}
                            default {::ipcheck::pIpcheckError 009 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(target) $host $ip $vIpcheckData(class)}
                        }
                    }
                }
            }
        }
        return 0
    }

    proc pIpcheckError {number nick chan {t1 ""} {t2 ""} {t3 ""} {t4 ""} {t5 ""} {t6 ""} {t7 ""}} {
        for {set loop 1} {$loop <= 8} {incr loop} {
            set c($loop) [::ipcheck::pIpcheckColor $chan 0 $loop]
        }
        set out1 "$c(1)Error$c(2) ($c(3)$nick$c(4)) $c(5)-->$c(6)"
        switch -- $number {
            001 {set out2 "$c(7)$t1$c(8) appears to be a host but contains one or more illegal characters"}
            002 {set out2 "$c(7)$t1$c(8) appears to be a numeric ip but is not externally useable ($c(3)$t2$c(4))"}
            003 {set out2 "$c(7)$t1$c(8) appears to be a numeric ip but one or more octets are outside the permitted range of 0 through 255"}
            004 {set out2 "$c(7)$t1$c(8) appears to be a numeric ip but is in an illegal format"}
            005 {set out2 "$c(7)$t1$c(8) appears to be a nick but contains one or more illegal characters"}
            006 {set out2 "$c(7)$t1$c(8) appears to be a host but will not dns resolve"}
            007 {set out2 "$c(7)$t1$c(8) is a nick but their host ($c(3)$t2$c(4)) will not dns resolve"}
            008 {set out2 "$c(7)$t1$c(8) is a host but resolves to an ip ($c(3)$t2$c(4)) that should not be externally useable ($c(3)$t3$c(4))"}
            009 {set out2 "$c(7)$t1$c(8) is a nick but their host ($c(3)$t2$c(4)) resolves to an ip ($c(3)$t3$c(4)) that should not be externally useable ($c(3)$t4$c(4))"}
            010 {set out2 "your query timed out while attempting to dns resolve the host $c(7)$t1$c(8)"}
            011 {set out2 "your query timed out while attempting to dns resolve the host $c(7)$t1$c(8) as determined from a network whois on the nick $c(7)$t2$c(8)"}
            012 {set out2 "your query $c(7)$t1$c(8) timed out without returning any results"}
            013 {set out2 "your query timed out while awaiting response from a network whois on the nick $c(7)$t1$c(8)"}
            014 {set out2 "$c(7)$t1$c(8) appears to be a nick but is not currently online"}
            015 {set out2 "http operation timed out"}
            016 {set out2 "http operation returned error ($c(3)$t1$c(4))"}
            017 {set out2 "http operation returned code $t1 ($c(3)[::ipcheck::pIpcheckHttp $t1]$c(4))"}
            018 {set out2 "http operation failed"}
            019 {set out2 "http operation did not return any useful information from $c(7)$t1$c(8), try an alternative geolocation server"}
            097 {set out2 "unrecognised geolocation server ($c(3)$t1$c(4))"}
            098 {set out2 "correct syntax is [::ipcheck::pIpcheckTrigger]ip ?-server? <nick|host|ip>"}
            099 {set out2 "a previous query has not yet cleared (maximum 40 sec timeout)"}
        }
        putserv "PRIVMSG $chan :$out1 $out2"
        switch -glob -- $number {
            09* {return 0}
            default {::ipcheck::pIpcheckReset}
        }
        return 0
    }

    proc pIpcheckFetch {} {
        variable vIpcheckData
        variable vIpcheckUrl
        set agent [::http::config -useragent "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"]
        if {![catch {set token [::http::geturl $vIpcheckUrl($vIpcheckData(server))$vIpcheckData(ip) -timeout 15000]}]} {
            ::ipcheck::pIpcheckCallback $token
        } else {::ipcheck::pIpcheckError 018 $vIpcheckData(nick) $vIpcheckData(chan)}
        return 0
    }

    proc pIpcheckHttp {code} {
        switch -- $code {
            100 {return "expected continuation of http request"}
            101 {return "server switching protocols"}
            201 {return "http request accepted, new resource created"}
            202 {return "http request accepted, not yet processed"}
            203 {return "non-authoritative information supplied"}
            204 {return "http request does not require returned content"}
            205 {return "http request accepted, user-agent should reset the document view"}
            206 {return "http request successful, partial response only"}
            300 {return "redirection to multiple possible locations"}
            301 {return "resource has moved permanently"}
            302 {return "resource found at this URL but redirects to another URL"}
            303 {return "resource is at a different URL"}
            304 {return "resource has not been modified since the last request"}
            305 {return "resource can only be accessed through a proxy specified in the location field"}
            306 {return "resource is no longer used"}
            307 {return "resource has temporarily moved to a different URL"}
            400 {return "bad http request"}
            401 {return "unauthorised http request"}
            402 {return "payment is required to use resource"}
            403 {return "server has refused to fulfill the http request"}
            404 {return "resource was not found"}
            405 {return "http request method not allowed"}
            406 {return "unacceptable headers in http request"}
            407 {return "proxy authentication required first"}
            408 {return "client failed to send http request in the time allotted"}
            409 {return "unsuccessful http request due to conflict in the resource"}
            410 {return "resource is unavailable at this URL"}
            411 {return "http request due to missing content length header"}
            412 {return "a precondition specified in one or more header fields returned false"}
            413 {return "http request too large"}
            414 {return "http URL too long"}
            415 {return "http request was of an unsupported media type"}
            416 {return "range request header could not be fulfilled"}
            417 {return "expect request header could not be fulfilled"}
            500 {return "internal server error"}
            501 {return "server could not fulfill the requested functionality"}
            502 {return "invalid response from an upstream server"}
            503 {return "server down or overloaded"}
            504 {return "upstream server failed to process the http request in the time allotted"}
            505 {return "http version not supported"}
            default {return "unknown"}
        }
    }

    proc pIpcheckOctet {ip} {
        foreach o [split $ip .] {
            if {$o > 255} {
                return 0
            }
        }
        return 1
    }

    proc pIpcheckParse {} {
        variable vIpcheckData
        if {[regexp {[.]} $vIpcheckData(query)]} {
            if {[regexp {[^0-9.]} $vIpcheckData(query)]} {
                if {[regexp -- {^[0-9a-zA-Z][-0-9a-zA-Z\.]*$} $vIpcheckData(query)]} {
                    set vIpcheckData(class) ""
                    set vIpcheckData(host) $vIpcheckData(query)
                    set vIpcheckData(ip) ""
                    set vIpcheckData(target) ""
                    utimer 10 ::ipcheck::pIpcheckTimeoutDns
                    dnslookup $vIpcheckData(host) ::ipcheck::pIpcheckDns
                } else {::ipcheck::pIpcheckError 001 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(query)}
            } else {
                if {[regexp {^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$} $vIpcheckData(query)]} {
                    if {[::ipcheck::pIpcheckOctet $vIpcheckData(query)]} {
                        set vIpcheckData(class) [::ipcheck::pIpcheckClass $vIpcheckData(query)]
                        if {[string match Class* $vIpcheckData(class)]} {
                            set vIpcheckData(host) ""
                            set vIpcheckData(ip) $vIpcheckData(query)
                            set vIpcheckData(target) ""
                            ::ipcheck::pIpcheckFetch
                        } else {::ipcheck::pIpcheckError 002 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(query) $vIpcheckData(class)}
                    } else {::ipcheck::pIpcheckError 003 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(query)}
                } else {::ipcheck::pIpcheckError 004 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(query)}
            }
        } else {
            if {[regexp -- {^[\x41-\x7D][-\d\x41-\x7D]*$} $vIpcheckData(query)]} {
                set vIpcheckData(class) ""
                set vIpcheckData(host) ""
                set vIpcheckData(ip) ""
                set vIpcheckData(target) $vIpcheckData(query)
                utimer 10 ::ipcheck::pIpcheckTimeoutWhois
                putserv "WHOIS $vIpcheckData(target) $vIpcheckData(target)"
            } else {::ipcheck::pIpcheckError 005 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(query)}
        }
        return 0
    }

    proc pIpcheckProcess {token} {
        variable vIpcheckData
        variable vIpcheckServer
        set d [::http::data $token]
        switch -- $vIpcheckData(server) {
            -d {
                regexp -- {Country \(per outside source\)\:[\s]+([A-Z]{2})} $d -> code
                regexp -- {City \(per outside source\)\:[\s]+([^\n]+)[\n]} $d -> temp
                set temp [split $temp ,]
                switch -- [llength $temp] {
                    0 {set o(city) unknown; set o(regn) unknown}
                    1 {set o(city) $temp; set o(regn) unknown}
                    2 {set o(city) [string trim [lindex $temp 0]]; set o(regn) [string trim [lindex $temp 1]]}
                }
                set o(cert) na
                set o(latt) na
                set o(long) na
            }
            -g {
                regexp -- {input name=\"ro-no_bots_pls12\" value=\"([^\"]+)\"} $d -> code
                regexp -- {input name=\"ro-no_bots_pls15\" value=\"([^\"]+)\"} $d -> o(regn)
                regexp -- {input name=\"ro-no_bots_pls17\" value=\"([^\"]+)\"} $d -> o(city)
                regexp -- {input name=\"ro-no_bots_pls18\" value=\"([^\"]+)\"} $d -> o(cert)
                regexp -- {input name=\"ro-no_bots_pls10\" value=\"([^\"]+)\"} $d -> o(latt)
                regexp -- {input name=\"ro-no_bots_pls19\" value=\"([^\"]+)\"} $d -> o(long)
            }
            -h {
                regexp -- {Country:[^(]+\(([A-Z]{2})\)} $d -> code
                regexp -- {City:[\s]+([^\n]+)[\n]} $d -> temp
                set temp [split $temp ,]
                switch -- [llength $temp] {
                    0 {set o(city) unknown; set o(regn) unknown}
                    1 {set o(city) $temp; set o(regn) unknown}
                    2 {set o(city) [string trim [lindex $temp 0]]; set o(regn) [string trim [lindex $temp 1]]}
                }
                set o(cert) na
                regexp -- {Latitude\:[\s]+([-.0-9]+)} $d -> o(latt)
                regexp -- {Longitude\:[\s]+([-.0-9]+)} $d -> o(long)
            }
        }
        if {[info exists code]} {
            if {[regexp -- {[A-Z]{2}} $code]} {
                set ctry [::ipcheck::pIpcheckTld $code]
                switch -- $ctry {
                    unknown {set o(plce) $code}
                    default {set o(plce) "$code, $ctry"}
                }
                foreach name [list plce ctry regn city cert latt long] {
                    if {![info exists o($name)]} {
                        set o($name) unknown
                    } else {
                        if {([string length [string trim $o($name)]] == 0) || ([regexp -nocase -- {unknown} $o($name)])} {
                            set o($name) unknown
                        }
                    }
                    switch -- $name {
                        cert {
                            if {(![string equal $o($name) na]) && (![string equal $o($name) unknown])} {
                                set o($name) $o($name)%
                            }
                        }
                        latt - long {
                            if {(![string equal $o($name) na]) && (![string equal $o($name) unknown])} {
                                set o($name) $o($name)\xB0
                            }
                        }
                    }
                }
                set o(serv) $vIpcheckServer($vIpcheckData(server))
                ::ipcheck::pIpcheckCompliance 001 $vIpcheckData(nick) $vIpcheckData(chan) $o(serv) $o(plce) $o(regn) $o(city) $o(cert) $o(latt) $o(long)
            } else {::ipcheck::pIpcheckError 019 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckServer($vIpcheckData(server))}
        } else {::ipcheck::pIpcheckError 019 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckServer($vIpcheckData(server))}
        return 0
    }

    proc pIpcheckRaw311 {from keyword text} {
        variable vIpcheckData
        set response [split [stripcodes bcruag [subst -nocommands -nobackslashes {$text}]]]
        set target [lindex $response 1]
        if {[array size vIpcheckData] != 0} {
            if {[string equal -nocase $target $vIpcheckData(target)]} {
                set vIpcheckData(whois) [lindex $response 3]
            }
        }
        return 0
    }

    proc pIpcheckRaw318 {from keyword text} {
        variable vIpcheckData
        set response [split [stripcodes bcruag [subst -nocommands -nobackslashes {$text}]]]
        set target [lindex $response 1]
        if {[array size vIpcheckData] != 0} {
            if {[string equal -nocase $target $vIpcheckData(target)]} {
                foreach item [utimers] {
                    if {[string equal ::ipcheck::pIpcheckTimeoutWhois [lindex $item 1]]} {killutimer [lindex $item 2]}
                }
                if {[regexp -- {^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$} $vIpcheckData(whois)]} {
                    set vIpcheckData(class) [pIpcheckClass $vIpcheckData(whois)]
                    set vIpcheckData(ip) $vIpcheckData(whois)
                    ::ipcheck::pIpcheckFetch
                } else {
                    set vIpcheckData(host) $vIpcheckData(whois)
                    utimer 10 ::ipcheck::pIpcheckTimeoutDns
                    dnslookup $vIpcheckData(host) ::ipcheck::pIpcheckDns
                }
            }
        }
        return 0
    }

    proc pIpcheckRaw402 {from keyword text} {
        variable vIpcheckData
        set response [split [stripcodes bcruag [subst -nocommands -nobackslashes {$text}]]]
        set target [lindex $response 1]
        if {[array size vIpcheckData] != 0} {
            if {[string equal -nocase $target $vIpcheckData(target)]} {
                ::ipcheck::pIpcheckError 014 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(target)
            }
        }
        return 0
    }

    proc pIpcheckReset {} {
        variable vIpcheckData
        foreach item [utimers] {
            if {[string equal ::ipcheck::pIpcheckTimeoutCommand [lindex $item 1]]} {killutimer [lindex $item 2]}
            if {[string equal ::ipcheck::pIpcheckTimeoutDns [lindex $item 1]]} {killutimer [lindex $item 2]}
            if {[string equal ::ipcheck::pIpcheckTimeoutWhois [lindex $item 1]]} {killutimer [lindex $item 2]}
        }
        if {[array exists vIpcheckData]} {array unset vIpcheckData}
        return 0
    }

    proc pIpcheckTimeoutCommand {} {
        variable vIpcheckData
        if {[array size vIpcheckData] != 0} {
            ::ipcheck::pIpcheckError 012 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(query)
        }
        return 0
    }

    proc pIpcheckTimeoutDns {} {
        variable vIpcheckData
        if {[array size vIpcheckData] != 0} {
            switch -- $vIpcheckData(target) {
                "" {::ipcheck::pIpcheckError 010 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(query)}
                default {::ipcheck::pIpcheckError 011 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(target) $vIpcheckData(host)}
            }
        }
        return 0
    }

    proc pIpcheckTimeoutWhois {} {
        variable vIpcheckData
        if {[array size vIpcheckData] != 0} {
            ::ipcheck::pIpcheckError 013 $vIpcheckData(nick) $vIpcheckData(chan) $vIpcheckData(target)
        }
        return 0
    }

    proc pIpcheckTld {code} {
        array set tld {
            AC "Ascension Island" AD "Andorra" AE "United Arab Emirates" AF "Afghanistan" AG "Antigua and Barbuda" AI "Anguilla"
            AL "Albania" AM "Armenia" AN "Netherlands Antilles" AO "Angola" AQ "Antarctica" AR "Argentina" AS "American Samoa"
            AT "Austria" AU "Australia" AW "Aruba" AX "Aland Islands" AZ "Azerbaijan" BA "Bosnia and Hertzegovina" BB "Barbados"
            BD "Bangladesh" BE "Belgium" BF "Burkina Faso" BG "Bulgaria" BH "Bahrain" BI "Berundi" BJ "Benin" BM "Bermuda"
            BN "Brunei Darussalam" BO "Bolivia" BR "Brazil" BS "Bahamas" BT "Bhutan" BV "Bouvet Island" BW "Botswana"
            BY "Belarus" BX "Belize" CA "Canada" CC "Cocos (Keeling) Islands" CD "The Democratic Republic of the Congo"
            CF "Central African Republic" CG "Republic of Congo" CH "Switzerland" CI "Cote d'Ivoire" CK "Cook Islands" CL "Chile"
            CM "Cameroon" CN "China" CO "Columbia" CR "Costa Rica" CU "Cuba" CV "Cape Verde" CX "Christmas Island" CY "Cyprus"
            CZ "Czech Republic" DE "Germany" DJ "Djibouti" DK "Denmark" DM "Dominica" DO "Dominican Republic" DZ "Algeria"
            EC "Equador" EE "Estonia" EG "Egypt" EH "Westewrn Sahara" ER "Eritrea" ES "Spain" ET "Ethiopia" EU "European Union"
            FI "Finland" FJ "Fiji" FK "Falkland Islands (Malvinas)" FM "Federated States of Micronesia" FO "Faroe Islands"
            FR "France" GA "Gabon" GB "Great Britain" GD "Grenada" GE "Georgia" GF "French Guiana" GG "Guernsey" GH "Ghana"
            GI "Gibraltar" GL "Greenland" GM "Gambia" GN "Guinea" GP "Guadeloupe" GQ "Equatorial Guinea" GR "Greece"
            GS "South Georgia and the South Sandwich Islands" GT "Guatamala" GU "Guam" GW "Guinea-Bissau" GY "Guyana"
            HK "Hong Kong" HM "Heards and McDonald Islands" HN "Honduras" HR "Croatia/Hrvatska" HT "Haiti" HU "Hungary"
            ID "Indonesia" IE "Ireland" IL "Israel" IM "Isle of Man" IN "India" IO "British Indian Ocean Territory" IQ "Iraq"
            IR "Islamic Republic of Iran" IS "Iceland" IT "Italy" JE "Jersey" JM "Jamaica" JO "Jordan" JP "Japan" KE "Kenya"
            KG "Kyrgyzstan" KH "Cambodia" KI "Kiribati" KM "Comoros" KN "Saint Kitts and Nevis"
            KP "Democratic People's Republic of Korea" KR "Republic of Korea" KW "Kuwait" KY "Cayman Islands" KZ "Kazakhstan"
            LA "Lao People's Democratic Republic" LB "Lebanon" LC "Saint Lucia" LI "Liechtenstein" LK "Sri Lanka" LR "Liberia"
            LS "Lesotho" LT "Lithuania" LU "Luxembourg" LV "Latvia" LY "Libyan Arab Jamahiriya" MA "Morocco" MC "Monaco"
            MD "Republic of Maldova" ME "Montenegro" MG "Madagascar" MH "Marshall Islands"
            MK "The Former Yugoslav Republic of Macedonia" ML "Mali" MM "Myanmar" MN "Mongolia" MO "Macao"
            MP "Northern Mariana Islands" MQ "Martinique" MR "Mauritania" MS "Montserrat" MT "Malta" MU "Mauritius" MV "Maldives"
            MW "Malawi" MX "Mexico" MY "Malaysia" MZ "Mozambique" NA "Namibia" NC "New Caledonia" NE "Niger" NF "Norfolk Island"
            NG "Nigeria" NI "Nicaragua" NL "Netherlands" NO "Norway" NP "Nepal" NR "Nauru" NU "Niue" NZ "New Zealand" OM "Oman"
            PA "Panama" PE "Peru" PF "French Polynesia" PG "Papua New Guinea" PH "Philippines" PK "Pakistan" PL "Poland"
            PM "Saint Pierre and Miquelon" PN "Pitcairn Island" PR "Puerto Rico" PS "Palestinian Occupied Territory" PT "Portugal"
            PW "Palau" PY "Paraguay" QA "Qatar" RE "Reunion Island" RO "Romania" RS "Serbia" RU "Russian Federation" RW "Rwanda"
            SA "Saudi Arabia" SB "Solomon Islands" SC "Seychelles" SD "Sudan" SE "Sweden" SG "Singapore" SH "Saint Helena"
            SI "Slovenia" SJ "Svalbard and Jan Mayen Islands" SK "Slovak Republic" SL "Sierra Leone" SM "San Marino" SN "Senegal"
            SO "Somalia" SR "Suriname" ST "Sao Tome and Principe" SU "Soviet Union" SV "El Salvador" SY "Syrian Arab Republic"
            SZ "Swaziland" TC "Turks and Caicos Islands" TD "Chad" TF "French Suothern Territories" TG "Togo" TH "Thailand"
            TJ "Tajikistan" TK "Tokelau" TL "Timor-Leste" TM "Turkmenistan" TN "Tunisia" TO "Tonga" TP "East Timor" TR "Turkey"
            TT "Trinidad and Tobago" TV "Tuvalu" TW "Taiwan" TZ "Tanzania" UA "Ukraine" UG "Uganda" UK "United Kingdom"
            UM "United States Minor Outlying Islands" US "United States" UY "Uruguay" UZ "Uzbekistan" VA "Vatican City State"
            VC "Saint Vincent and the Grenadines" VE "Venezuela" VG "British Virgin Islands" VI "United States Virgin Islands"
            VN "Vietnam" VU "Vanuatu" WF "Wallis and Futuna Islands" WS "Samoa" YE "Yemen" YT "Mayotte" YU "Yugoslavia"
            ZA "South Africa" ZM "Zambia" ZW "Zimbabwe"
        }
        if {[array names tld $code] != ""} {set ctry $tld($code)} else {set ctry unknown}
        array unset tld
        return $ctry
    }

}

putlog "ipcheck.tcl version $vIpcheckVersion by arfer loaded"

# eof
