#!/usr/bin/env bash
#
# SLSNMP
#   Fetches syslog objects and outputs to stdout, for use with syslogging
#   https://github.com/mada3k/slsnmp
#
SNMP_COMMUNITY="public"
SNMP_OID_HOSTNAME="iso.3.6.1.2.1.1.5.0"
SNMP_OIDS=""
BC_SCALE="1"
SYSLOG_PORT="514"
SYSLOG_PRI="local0.notice"
UNAME=`uname -s`
out=""
rc=0


source slsnmp.conf


function log() {
    # testmode
    if [ "$TESTMODE" == "1" ]; then
        echo $out
        return
    fi

    # local logging
    if [ -z "$SYSLOG_HOST" ]; then
        echo $out|logger -t slsnmp -p ${SYSLOG_PRI}
        return
    fi

    # RedHat/CentOS or Linux
    if [ "${UNAME}" == "Linux" ]; then
        if [ -f "/etc/redhat-version" ]; then
            echo $out|logger -t slsnmp -p ${SYSLOG_PRI}     # doesn't support remote logging
        else
            echo $out|logger -t slsnmp -p ${SYSLOG_PRI} -d -n ${SYSLOG_HOST} -P ${SYSLOG_PORT} 
        fi
    fi

    # FreeBSD
    if [ "${UNAME}" == "FreeBSD" ]; then
        echo $out|logger -t slsnmp -p ${SYSLOG_PRI} -h ${SYSLOG_HOST} -P ${SYSLOG_PORT} 
    fi 
}


for host in `cat ${SNMP_NODES}`; do
    # fetch hostname
    NODENAME=`snmpget -v2c -Oqv -c ${SNMP_COMMUNITY} ${host} "${SNMP_OID_HOSTNAME}"`
    rc=$?

    # fetch objects
    if [ "$rc" == "0" ]; then
        for foid in ${SNMP_OIDS}; do
            # fetch value
            value=`snmpget -v2c -Oqv -c ${SNMP_COMMUNITY} ${host} "${SNMP_OID[$foid]}"`

            # perform math
            if [ -n "${SNMP_OID_CONVERT[$foid]}" ]; then
                conv=${SNMP_OID_CONVERT[$foid]}
                value=`echo "scale=$BC_SCALE; $value$conv"|bc`
            fi

            # build message
            out="snmp_hostname=${NODENAME} snmp_object=${SNMP_OID_KEY[$foid]} value_${SNMP_OID_TYPE[$foid]}=${value}"

            # log! 
            log

            # sleep
            sleep ${SNMP_GET_DELAY}
        done
    fi
done



