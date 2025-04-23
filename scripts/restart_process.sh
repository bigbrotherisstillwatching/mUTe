#!/bin/sh

var1=$(pgrep mute)
var2=$(readlink -e /proc/$var1/cwd/)

if [ $var2 = "/opt/click.ubuntu.com/mute.bigbrotherisstillwatching/1.0.1" ]; then
    kill $var1
    /opt/click.ubuntu.com/mute.bigbrotherisstillwatching/1.0.1/mute
else
    :
fi