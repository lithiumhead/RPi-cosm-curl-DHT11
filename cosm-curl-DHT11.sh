#!/bin/bash

./sakis3g connect

#Key Codes
ARROWUP='\[A'
ARROWDOWN='\[B'
ARROWRIGHT='\[C'
ARROWDOWN='\[D'
INSERT='\[2'
DELETE='\[3'

#Text Colors - Accent type
BOLD='\033[1m'
DBOLD='\033[2m'
NBOLD='\033[22m'
UNDERLINE='\033[4m'
NUNDERLINE='\033[4m'
BLINK='\033[5m'
NBLINK='\033[5m'
INVERSE='\033[7m'
NINVERSE='\033[7m'
BREAK='\033[m'
NORMAL='\033[0m'

#Text Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'

#Text Colors - Brighter versions
DGRAY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
LYELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LMAGENTA='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[1;37m'

#Text Colors - Background colors
BGBLACK='\033[40m'
BGRED='\033[41m'
BGGREEN='\033[42m'
BGBROWN='\033[43m'
BGBLUE='\033[44m'
BGMAGENTA='\033[45m'
BGCYAN='\033[46m'
BGGRAY='\033[47m'
BGDEF='\033[49m'

#Text Colors - Reset to default
RESET='\033[0;0;39m'






#Configuration:
API_KEY="QGfMEcthzka2KFyAKrqqCYWqZYeSAKwrNnU4bzRkd0dpaz0g"
FEED_ID="90913"

SENSOR_TYPE="11"
PIN_NUM="4"

UPLOAD_INTERVAL="10"

while true
do
	echo -e -n "${LGREEN}"
	echo " "
	echo "Trying to read temperature and humidity from AM/DHT$SENSOR_TYPE on pin $PIN_NUM..."
	echo " "
	DHT11=$(./DHT.out $SENSOR_TYPE $PIN_NUM)
	DHT11_STATUS=$(echo "$DHT11" | awk '{ print $1}')
	DHT11_TEMPERATURE=$(echo "$DHT11" | awk '{ print $2}')
	DHT11_HUMIDITY=$(echo "$DHT11" | awk '{ print $3}')

	if [ "$DHT11_STATUS" == "OK" ] ; then
		echo -e -n "${LCYAN}"
		echo "Status = $DHT11_STATUS"
		echo "Temperature = $DHT11_TEMPERATURE"
		echo "Humidity = $DHT11_HUMIDITY"
		echo -e -n "${LBLUE}"
		echo " "
		echo "Sending reading to Cosm..."
		echo " "
		echo -e -n "${RESET}"
		
		DATA_JSON="{"
		DATA_JSON="$DATA_JSON"$'\n'"  \"title\":\"Temperature and Humidity (RPi DHT11)\","
		DATA_JSON="$DATA_JSON"$'\n'"  \"website\":\"http://www.electronicsfaq.com/\","
		DATA_JSON="$DATA_JSON"$'\n'"  \"version\":\"1.0.0\","
		DATA_JSON="$DATA_JSON"$'\n'"  \"tags\":["
		DATA_JSON="$DATA_JSON"$'\n'"      \"Adafruit\","
		DATA_JSON="$DATA_JSON"$'\n'"	  \"DHT11\","
		DATA_JSON="$DATA_JSON"$'\n'"	  \"Humidity\","
		DATA_JSON="$DATA_JSON"$'\n'"	  \"India\","
		DATA_JSON="$DATA_JSON"$'\n'"	  \"K3770-Z\","
		DATA_JSON="$DATA_JSON"$'\n'"	  \"Python\","
		DATA_JSON="$DATA_JSON"$'\n'"	  \"Raspberry Pi\","
		DATA_JSON="$DATA_JSON"$'\n'"	  \"Temperature\","
		DATA_JSON="$DATA_JSON"$'\n'"	  \"Vodafone 3G\""
		DATA_JSON="$DATA_JSON"$'\n'"  ],"
		DATA_JSON="$DATA_JSON"$'\n'"  \"location\":{"
		DATA_JSON="$DATA_JSON"$'\n'"      \"disposition\":\"fixed\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"ele\":\"23.0\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"name\":\"Pune, India\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"lat\":18.5236,"
		DATA_JSON="$DATA_JSON"$'\n'"      \"exposure\":\"indoor\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"lon\":73.8478,"
		DATA_JSON="$DATA_JSON"$'\n'"      \"domain\":\"physical\""
		DATA_JSON="$DATA_JSON"$'\n'"  },"
		DATA_JSON="$DATA_JSON"$'\n'"   \"datastreams\" : [ {"
		DATA_JSON="$DATA_JSON"$'\n'"      \"current_value\" : \"$DHT11_TEMPERATURE\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"id\" : \"Temperature\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"max_value\" : \"50\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"min_value\" : \"0\""
		DATA_JSON="$DATA_JSON"$'\n'"    },"
		DATA_JSON="$DATA_JSON"$'\n'"    { \"current_value\" : \"$DHT11_HUMIDITY\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"id\" : \"Humidity\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"max_value\" : \"20\","
		DATA_JSON="$DATA_JSON"$'\n'"      \"min_value\" : \"90\""
		DATA_JSON="$DATA_JSON"$'\n'"    }"
		DATA_JSON="$DATA_JSON"$'\n'"  ]"
		DATA_JSON="$DATA_JSON"$'\n'"}"

		curl --request PUT \
		 --data "$DATA_JSON" \
		 --header "X-ApiKey: $API_KEY" \
		 --verbose \
		 http://api.cosm.com/v2/feeds/"$FEED_ID"
		 
	else
		echo -e -n "${LRED}"
		echo "Error in getting reading from the DHT11 Sensor"
		echo -e -n "${RESET}"
	fi
	
	echo -e -n "${LYELLOW}"
	echo " "
	echo "Sleeping for $UPLOAD_INTERVAL seconds"
	sleep $UPLOAD_INTERVAL
done