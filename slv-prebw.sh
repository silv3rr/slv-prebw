#!/bin/bash
if [ "${1}" == "" ]; then
    exit 1
fi

###################################################################################################################
# slv-prebw v0.53 24072012 slv
# based on wspre-bw.sh, from *somewhere* ;)
###################################################################################################################
# todo: -round floating points better (awk)
#       -total users in avg
###################################################################################################################

GLROOT="/jail/glftpd"
GLLOG="/ftp-data/logs/glftpd.log"
SITEWHO="/bin/sitewho"
#SLEEPS="1 1 1"
SLEEPS="2 3 5 5 5"

KBS="kb/s"
MBS="mb/s"
SEC="s: "
AVG="avg: "
SEP="@"
SPACE=" "
BOLD=""

###################################################################################################################
# ONLY EDIT BELOW IF YOU KNOW WHAT YOU'RE DOING
###################################################################################################################

rls=${1}

proc_convert() {
    if [ "${1}" -ge "0" ] && [ "${1}" -lt "1024" ]; then
        echo "${1}${KBS}"
    fi
    if [ "${1}" -ge "1024" ]; then
        echo "`echo "${1} 1024" | awk '{printf "%0.1f", $1 / $2}'`${MBS}"
    fi
}

bwtext=""; time=0; i=0

for slp in ${SLEEPS}; do
    sleep $slp
    bw=0
    u=0
    let "time=time+slp"
    for leech in `${GLROOT}${SITEWHO} --raw | grep ${rls} | grep \"DN\" | cut -d '"' -f 12`; do
        leech="`echo "${leech}" | awk '{printf "%0.0f", $1}'`"
        let "bw=bw+leech"
        let "u=u+1"
    done
    bwavg[i]="${bw}"
    users[i]="${u}"
    let "i=i+1"
    bwtext="${bwtext}${time}${SEC}`echo ${u}${SEP}`${BOLD}`proc_convert "${bw}"`${BOLD}${SPACE}"
done

element_count=${#bwavg[@]}; index=0
bwavgtotal="0"
while [ "${index}" -lt "${element_count}" ]
do    # List all the elements in the array.
    bwavgtotal=`echo "${bwavgtotal} + ${bwavg[$index]}" | bc`
    let "index = ${index} + 1"
done

bwavgtotal="`echo "${bwavgtotal} / ${i}" | bc`"
bwavgtext="${AVG}${BOLD}`proc_convert ${bwavgtotal}`${BOLD}"

if [ "$bwavgtotal" != "0" ]; then
    echo `date "+%a %b %d %T %Y"` PREBW: \"${rls}\" \"${bwtext}${bwavgtext}\" >> ${GLROOT}${GLLOG}
fi

exit 0
