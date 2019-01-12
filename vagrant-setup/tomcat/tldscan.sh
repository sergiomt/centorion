#!/bin/sh

# List JARs wwhich do not contain a TLD
# https://stackoverflow.com/a/44246601/3867574

BASE_DIR=/usr/share/tomcat
for i in `find $BASE_DIR -follow -name "*jar"`
do
    jar tvf $i | grep -i tld > /dev/null
    if [ $? -ne 0 ]; then
        echo "$(basename $i),\\"
    fi
done
