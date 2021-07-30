#!/bin/bash

CRS_PATH=/coraza/crs

if [ "$CRS_USE" != "true" ]
then
    echo "CRS was not enabled"
    exit 0
fi

if [ "$CRS_VERSION" != "" ]
then
    echo "Cloning CRS version $CRS_VERSION"
    git clone --depth 1 --branch $CRS_VERSION https://github.com/coreruleset/coreruleset
else
    echo "Cloning CRS latest version"
    git clone --depth 1 https://github.com/coreruleset/coreruleset
fi

EXCLUSIONS=""
if [ "$CRS_EXCLUDE_WORDPRESS" == "true" ]
then
    EXCLUSIONS='SecAction "id:900130,phase:1,nolog,pass,t:none,setvar:tx.crs_exclusions_wordpress=1"'
fi

curl -o $CRS_PATH/rules.conf https://raw.githubusercontent.com/jptosso/coraza-waf/master/coraza.conf-recommended
cat coreruleset/crs-setup.conf.example >> $CRS_PATH/rules.conf
echo $EXCLUSIONS >> $CRS_PATH/rules.conf
cat coreruleset/rules/*.conf >> $CRS_PATH/rules.conf
mv coreruleset/rules/*.data $CRS_PATH/