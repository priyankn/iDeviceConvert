#!/bin/bash

###################
# iDeviceConvert - Patch an iPad-only app which doesn't run on an iPhone or vice-versa.
# Maintained by - Priyank Nigam
# Syntax: ./iDeviceConvert.sh [/path/to/IPA/file]
# Runs on MacOS. Needs plutil which should be installed by default. 
#
#
# How this Works --
#
# We change the UIDeviceFamily (Number or Array - iOS) which specifies the underlying hardware type on which this app is designed to run. 
#  1 - (Default) The app runs on iPhone and iPod touch devices
#  2 - The app runs on iPad devices
#
# Some apps might declare UISupportedDevices, we will just remove it.
###################



Help()
{
   # Display Help
   echo "----------------------------------------------------------------------"
   echo "Patch an iPad-only app which doesn't run on an iPhone or vice-versa."
   echo "Syntax: ./iDeviceConvert.sh [/path/to/IPA/file] "
   echo 
   echo "options:"
   echo "h     Print this help"
   echo "----------------------------------------------------------------------"

}

while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
     \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done

if [ $# -lt 1 ] ; then
    Help
    exit
fi


if [ ! -d "./tmp_d" ]; then
	mkdir tmp_d
else 
	echo "[+] Removing tmp_d"
	rm -rf tmp_d
fi


echo "[+] Extracting.."
unzip -q -d tmp_d $1
if [ $? != 0 ]; then
	exit
fi


#plutil -insert UIDeviceFamily.0 -integer "1" tmp_d/Payload/*.app/Info.plist

p_out=$(plutil -extract UIDeviceFamily json -o - tmp_d/Payload/*.app/Info.plist)

echo "$p_out" 

if [ $p_out == "[1,2]" ]; then
        echo "[+] The App is already configured to run on both platforms, stop fucking around"
	exit
elif [ $p_out == "[2]" ]; then
	echo "[+] Detected IPad, Insert for iPhone"
	plutil -insert UIDeviceFamily.0 -integer "1" tmp_d/Payload/*.app/Info.plist
elif [ $p_out == "[1]" ]; then
	echo "[+] Detected iPhone, Insert for iPad" 
	plutil -insert UIDeviceFamily.0 -integer "2" tmp_d/Payload/*.app/Info.plist
fi

# Check for UISupportedDevices

p_out_ui=$(plutil -remove UISupportedDevices tmp_d/Payload/*.app/Info.plist)

if [ $? == 0 ]; then
        echo "[+] Detected UISupportedDevices, removing this key"
fi

#plutil -extract UIDeviceFamily xml1 -o - tmp_d/Payload/*.app/Info.plist


cd tmp_d && zip -q -r ../"updated_"$1 Payload
rm -rf ../tmp_d
echo "[+] Done. Patched as "updated_"$1"



 
