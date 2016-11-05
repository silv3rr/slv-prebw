###################################################################################################################
# slv-prebw v0.53 21072012 silver for ngBot/dZSbot
###################################################################################################################

namespace eval ::ngBot::plugin::PreBW {
    variable ns [namespace current]
    ## Config Settings ###############################
    ##
    ## Choose one of two settings, the first when using ngBot, the second when using dZSbot
    variable np [namespace qualifiers [namespace parent]]
    #variable np ""
    ##
    set slvprebw "$::ngBot::glroot/bin/slv-prebw.sh"
    variable scriptName ${ns}::LogEvent
    bind evnt -|- prerehash ${ns}::DeInit

    if {[string equal "" $np]} {
            bind evnt -|- prerehash ${ns}::deinit
    }

    proc init {} {
        variable np
        variable scriptName
        variable ${np}::precommand
        lappend precommand(PRE) $scriptName
        putlog "\[ngBot\] PreBW :: Loaded successfully."
        return
    }

    proc deinit {} {
        variable ns
        variable np
        variable scriptName
        variable ${np}::precommand
        if {[info exists precommand(PRE)] && [set pos [lsearch -exact $precommand(PRE) $scriptName]] !=  -1} {
            set precommand(PRE) [lreplace $precommand(PRE) $pos $pos]
        }
        namespace delete $ns
        catch {unbind evnt -|- prerehash ${ns}::deinit}
        return
    }

    proc LogEvent {event section logData} {
        variable slvprebw

        if {![string equal "PRE" $event]} {return 1}
        set fullpath [lindex $logData 0]
        exec $slvprebw $fullpath &
        return 1
    }
}

if {[string equal "" $::ngBot::plugin::PreBW::np]} {
        ::ngBot::plugin::PreBW::init
}
