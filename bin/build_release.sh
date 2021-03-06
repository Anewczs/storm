#!/bin/bash

RELEASE=`head -1 project.clj | awk '{print $3}' | sed -e 's/\"//' | sed -e 's/\"//'`

echo Making release $RELEASE

DIR=_release/storm-$RELEASE

rm -rf _release
export LEIN_ROOT=1
rm *jar
lein clean
lein deps
lein compile
mv conf/log4j.properties conf/storm.log.properties
lein jar
mv conf/storm.log.properties conf/log4j.properties
mkdir -p $DIR
mkdir $DIR/lib
cp storm*jar $DIR/
cp lib/*.jar $DIR/lib

cp -R log4j $DIR/
mkdir $DIR/logs

mkdir $DIR/conf
cp conf/storm.yaml.example $DIR/conf/storm.yaml

cp -R src/ui/public $DIR/

cp -R bin $DIR/

cp README.markdown $DIR/
cp LICENSE.html $DIR/

cd _release
zip -r storm-$RELEASE.zip *
cd ..
mv _release/storm-*.zip .
rm -rf _release

