SLSNMP - Syslogger SNMP
=======================

This is a simple tool to fetch/poll certians objects from SNMP 
capable devices and hosts, and output them to syslog with `logger` or just in raw format.

 * It can do some minor math and conversion with `bc`
 * It can handle float/int/string value types
 * It can publish the result to a MQTT bus

An example use for this is to collect firmware version, voltages, signal strength or similar for multiple devices and save it to a ELK/Grafana.

Example output
--------------

This is an example output:

    snmp_hostname=node1 snmp_object=sys.temperature value_float=53.0
    snmp_hostname=node1 snmp_object=sys.voltage value_float=37.7
    snmp_hostname=node1 snmp_object=sys.mem.used value_int=30288
    snmp_hostname=node2 snmp_object=sys.temperature value_float=36.0
    snmp_hostname=node2 snmp_object=sys.voltage value_float=26.6
    snmp_hostname=node2 snmp_object=sys.mem.used value_int=27188

It can't later be parsed by Logstash, Splunk or other log solution.
I have included a example Logstash configuration for this.

It also possible to publish the values to a MQTT bus


