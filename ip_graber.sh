#!/bin/bash -x
# Name:         ip_graber.sh
# Author:       x31xc0
# Date:         13/09/2015
# Usage:        This simple script will search for unique ip addresses in a give list of files and pipe them into a new file

#Globals
array=()


#Function protos
CreateConfigFile()
{
  cat <<-EOF > config.txt
        # config.txt
        #
        # This file will be used by ip_graber.sh as a collection of locations to read from
        # Please only enter the full paths to the file locations and nothing else.
        # e.g. /var/log/auth.log
        #
        /var/log/apache/error.log
        /var/log/apache/access.log
        /var/log/auth.log
        /var/log/messages
        EOF
}

ReadConfigFile()
{
        if [ -s "file_list.txt" ]; then
        i=0;
        while read line;
        do
                if [[ ! $line =~ ^# ]]; then
                        array[i]=$line
                        i=$(($i + 1))
                        fi
                done < "file_list.txt"
        else
                CreateConfigFile
        fi
}

ScanFiles()
{
        for i in "${array[@]}"
        do
                grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" $i >> tmp.txt
        done
        sort tmp.txt | uniq  > ip_list.txt
        rm tmp.txt
}
#Main
ReadConfigFile
ScanFiles
