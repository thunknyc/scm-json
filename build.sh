#!/bin/sh

cd `dirname $0`
snow-chibi package \
	   --test=thunknyc/json-test.scm \
	   thunknyc/json.sld
