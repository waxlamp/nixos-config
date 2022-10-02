#!/bin/sh

# Get the battery level and charging time information.
info="`@acpi@ -b | tail -1`"
if [ $? -ne 0 ]; then
  echo "B:??%"
fi

# Parse out the percentage of battery time remaining.
percent=`echo "${info}" | sed -n 1p | awk '{print $4}' | sed s/,$// | sed 's/%$//'`

# Parse out the time left to charge/deplete the battery.
remain=`echo "${info}" | awk '{print $5}'`

# Parse out whether the battery is plugged in or not.
mode=`echo "${info}" | awk '{print $3}'`
if [ "${mode}" = "Charging," ]; then
  color="<fc=#00cc00>"
else
  color="<fc=#cc0000>"
fi

# Convert the remaining time value into a more readable string.
hrs=`echo $remain | awk 'BEGIN { FS = ":" } ; {print $1}' | xargs printf %0d`
mins=`echo $remain | awk 'BEGIN { FS = ":" } ; {print $2}' | xargs printf %02d`
if [ "${percent}" = "100" ]; then
  remain=""
elif [ "$hrs" = "0" ]; then
  remain="${color}(0:${mins})</fc>"
else
  remain="${color}(${hrs}:${mins})</fc>"
fi

# Finally, display the end result.
echo "B:${percent}% ${remain}"
