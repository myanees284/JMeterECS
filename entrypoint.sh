#!/bin/bash
set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"
export TEST_LOG=/test/testconsole.log
export TEST_LOG_XML=/test/test_results.xml
export AWS_ACCESS_KEY_ID=<provide your access key ID>
export AWS_SECRET_ACCESS_KEY=<secret key>
export DEFAULT_REGION=<region>

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "jmeter args=$@"

# Keep entrypoint simple: we must pass the standard JMeter arguments
jmeter -n -t JMeter_TEST.jmx -l myscript.xml -j myscript.log -Jjmeter.save.saveservice.output_format=xml -Jjmeter.save.saveservice.response_data=true -Jjmeter.save.saveservice .samplerData=true -JnumberOfThreads=20 -JloopCount=50
echo "END Running Jmeter on `date`"

echo "Uploading test logs into ecsjmeter-logs/upload folder"
echo $TEST_LOG
aws s3 cp $TEST_LOG s3://ecsjmeter-logs/upload/
aws s3 cp $TEST_LOG_XML s3://ecsjmeter-logs/upload/
echo "Uploading Completed.Cleaning Local logs"
rm myscript.*
