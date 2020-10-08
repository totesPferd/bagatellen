#!/bin/sh

git ls-files | awk '/\.fun$/ || /\.sml$/ { print "use \""$0"\";" }' | sort >probe_1.ml
