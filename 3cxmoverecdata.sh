#!/bin/bash

# This script moves and renames the 3CX recordings to a new location with the correct naming convention for the CCmodule to upload to Atmos. See example of 3CX supported recording names be$
#outbound example []_100-0836826436_20190211124709(2).wav
#inbound example [27836826436]_27836826436-100_20190211124743(3).wav
#outbound with space [Zinhle Phungula]_201-0114627554_20190219120918(380).wav

# Set the soure directory to read files
# default is /var/lib/3cxpbx/Instance1/Data/Recordings/
SRCDR="/var/lib/3cxpbx/Instance1/Data/Recordings"

# Set the destination output directory to the CallCabinet respository
DSTDR="/home/callcabinet/recordings"

# Set CustID + SiteID -ONLY for MT solutions
#SUBSITEID=0b982357-443b-4894-8e70-35b73ad7a24b+fdecbbdf-991a-41ff-9b92-82b44044d0a0

#spin='-\|/'

OIFS="$IFS"
IFS=$'\n'

   for filename in $(find $SRCDR -type f -mmin +1 -name "*.wav")
        do
#  i=$(( (i+1) %4 ))
#  printf "\r Please wait... ${spin:$i:1}"
        movelogs=/home/callcabinet/movelogs
        find /home/callcabinet/movelogs/*.log -mtime +30 -exec rm {} \;
        logdate=$(date +%Y-%m-%d)
        logfile=$movelogs/${logdate}.log
#       echo "$filename" >>./getccrecdata.log
        SRCDST=$(echo $filename | cut -f2 -d_)
#       echo "$SRCDST" >>./getccrecdata.log
        SRC=$(echo $SRCDST | cut -f2 -d-) >>./getccrecdata.log
#       echo "$SRC" >>./getccrecdata.log
        DST=$(echo $SRCDST | cut -f1 -d-) >>./getccrecdata.log
#       echo "$DST" >>./getccrecdata.log
#       CID=$(echo $filename | cut -f6 -d-)
#       CALLID="${CID%.*}"
          if [ "$SRC" -gt "$DST" ]; then DIR=INCOMING; EXT=$SRC; PHN=$DST
          else DIR=OUTGOING; EXT=$DST; PHN=$SRC
          fi
          if [ -z "$EXT" ]; then EXT=anonymous;
          fi
          if [ -z "$PHN" ]; then PHN=anonymous;
          fi
        DATEF=$(stat -c %y "$filename");
        DATEFO="${DATEF%.*}"
        DATETIME=${DATEFO/ /T}
        DATE=$DATETIME MIN=$(echo $DATETIME| cut -c 11,12)
        FOLDERS='date +"%Y/%m/%d"' SEC=$(echo $DATETIME| cut -c 13,14)
        DURATION=$(soxi -D "$filename" | cut -d . -f1)
        mkdir -p /home/callcabinet/recordings/${FOLDERS}
# Without SubSiteID:
        mv "$filename" $DSTDR/${FOLDERS}/${PHN}_${DATE}_${EXT}_${DIR}_${DURATION}.WAV
# Example with SubSiteID:
#       mv "$filename" $DSTDR/${FOLDERS}/${PHN}_${DATE}_${EXT}_0_${DIR}_${SUBSITEID}.WAV
        now=$(date +%Y-%m-%d%I:%M:%S)
        echo $now Found new recording and moved file: "$filename" to CallCabinet repository: $DSTDR/${PHN}_${DATE}_${EXT}_${DIR}_${DURATION}.WAV >> $logfile
        done
IFS="$OIFS"
#echo Completed. View movelogs for details
