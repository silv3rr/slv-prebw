###################################################################################################################
# slv-prebw v0.52 02142007 slv (first public rls)
###################################################################################################################

set slvprebw "$glroot/bin/slv-prebw.sh"

namespace eval ::ngBot::PreBW {
    variable scriptName [namespace current]::LogEvent
    bind evnt -|- prerehash [namespace current]::DeInit
}

proc ::ngBot::PreBW::Init {args} {
    global precommand
    variable scriptName
    lappend precommand(PRE) $scriptName
    putlog "\[ngBot\] PreBW :: Loaded successfully."
    return
}

proc ::ngBot::PreBW::DeInit {args} {
    global precommand
    variable scriptName
    if {[info exists precommand(PRE)] && [set pos [lsearch -exact $precommand(PRE) $scriptName]] !=  -1} {
        set precommand(PRE) [lreplace $precommand(PRE) $pos $pos]
    }
    namespace delete [namespace current]
    catch {unbind evnt -|- prerehash [namespace current]::DeInit}
    return
}

#proc ::ngBot::PreBW::GetBW {args} {
#    global binary announce speed theme speedmeasure speedthreshold
#
#    checkchan $nick $chan
#
#    set output "$theme(PREFIX)$announce(BW)"
#    set raw [exec $binary(WHO) --nbw]
#    set dn [format_speed [lindex $raw 3] "none"]
#    set output [replacevar $output "%dnspeed" $dn]
#    sndone "#test" $dn
#    return $dn
#}

proc ::ngBot::PreBW::LogEvent {event section logData} {
    global slvprebw

    if {![string equal "PRE" $event]} {return 1}
    set fullpath [lindex $logData 0]
    exec $slvprebw $fullpath &
    return 1
}

::ngBot::PreBW::Init
