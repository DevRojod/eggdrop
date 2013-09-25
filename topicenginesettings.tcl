## TopicEngine settings file

#####
# Settings you can change
#
# Starting with 1.19, the "topicChannels" setting is no longer used.
# set topicChannels [list "#lamest"] <-- NO!
#
# It's replaced by the topicengine flag on the channel.
# Use: .chanset #lamest +topicengine

#
# Maximum topic length for the network
#
# 80 is the safest setting for IRCNet, 120 and 160 are common (watch out for
#   truncation though)
# 120 is typical on EFNet
set topicLengthLimit 120

#
# Announce a topic being reset after a split? (0/1)
set topicAnnounceReset 1

#
# This is the char (or several chars) that separate a topic. A space will go each side of this string.
set topicSeparator "|"

#
# Respond to "!topic info" in the chan or in notice (just to the user to did it)
# 1 = channel, 0 = notice
set topicInfoBroadcast 1

#DO NOT REMOVE THIS LINE:
if {$topicEngineLoad == 1} {
# HOW TO USE:
# (please also read the readme file)
#
# set values for channels in here, like this:
#
# set topicInfo(#channel,setting) <value>
#
# setting               value(s)                              Default
# -------               --------                              -------
#
# leadIn                Default prefix for topic              (blank)
# leadOut               Default postfix                       (blank)
# topicBits             [list "topicBit1" "topicBit2" ...]    (empty list)
# learnOnChange         1 = learn topic on change (and join)  1
#
# NOTE NEW PERMISSIONS SYSTEM >= 1.19! Old settings will not work:
# canFlags              Eggdrop-style flags for who can use
#                       the script: globalflags|chanflags     o|ov (global ops,
#                                                      chanops, and chan voices)
# canModes              List of chanmodes which allow use.
#                       Valid characters are ohv              ov (any voice or op)
# cantFlags             Like canFlags, but posessing it
#                       PREVENTS use of script                T|T
#
# Do not set other settings in the topicInfo array.
#
# e.g to set the default topic for #lamest to be "www.lamest.net | pop | frogs"
# where the URL is a prefix, do this:
#
# set topicInfo(#lamest,leadIn) "www.lamest.net"
# set topicInfo(#lamest,topicBits) [list "pop" "frogs"]
#


# (put your settings here, if needed)


#DO NOT REMOVE THIS BRACKET
}
