SLSNMP - Syslogger SNMP
=======================

This is a simple tool to fetch/poll certians objects from SNMP 
capable devices and hosts, and output them to syslog with `logger` or just in raw form.

 * It can do some minor conversion with `bc`
 * It can be modified just to output the raw lines instead
 * It can handle float/int/string type of values


Example output
--------------

This is an example output:

    snmp_hostname=node1 snmp_object=sys.temperature value_float=53.0
    snmp_hostname=node1 snmp_object=sys.voltage value_float=37.7
    snmp_hostname=node1 snmp_object=sys.mem.used value_int=30288
    snmp_hostname=node2 snmp_object=sys.temperature value_float=36.0
    snmp_hostname=node2 snmp_object=sys.voltage value_float=26.6
    snmp_hostname=node2 snmp_object=sys.mem.used value_int=27188

It can't later be easily parsed by Logstash or other parsing tool.
I have included a example Logstash configuration for this.



