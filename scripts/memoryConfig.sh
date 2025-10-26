#!/bin/bash        

if ! `echo $JAVA_OPTS | grep -q "\-Xms[[:digit:]\.]"`
then
        [ -z "$XMS" ] && { XMS="-Xms32M"; }
        JAVA_OPTS=$JAVA_OPTS" $XMS"; 
fi

if ! `echo $JAVA_OPTS | grep -q "\-Xmn[[:digit:]\.]"`
then
        [ -z "$XMN" ] && { XMN="-Xmn30M"; }
        JAVA_OPTS=$JAVA_OPTS" $XMN"; 
fi

if ! `echo $JAVA_OPTS | grep -q "\-Xmx[[:digit:]\.]"`
then
        [ -z "$XMX" ] && {
        	#optimal XMX = 80% * total available RAM
        	#it differs a little bit from default values -Xmx http://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html
        	memory_total=`free -m | grep Mem | awk '{print $2}'`;
        	let XMX=memory_total*8/10;
        	XMX="-Xmx${XMX}M";
        }
        JAVA_OPTS=$JAVA_OPTS" $XMX";
fi

if ! `echo $JAVA_OPTS | grep -q "\-Xminf[[:digit:]\.]"`
then
        [ -z "$XMINF" ] && { XMINF="-Xminf0.1"; }
        JAVA_OPTS=$JAVA_OPTS" $XMINF"; 
fi

if ! `echo $JAVA_OPTS | grep -q "\-Xmaxf[[:digit:]\.]"`
then
        [ -z "$XMAXF" ] && { XMAXF="-Xmaxf0.3"; }
        JAVA_OPTS=$JAVA_OPTS" $XMAXF"; 
fi

XMX_VALUE=`echo $XMX | grep -o "[0-9]*"`;
XMX_UNIT=`echo $XMX | sed "s/-Xmx//g" | grep -io "g\|m"`;
if [[ $XMX_UNIT == "g" ]] || [[ $XMX_UNIT == "G" ]] ; then 
	let XMX_VALUE=$XMX_VALUE*1024; 
fi

JAVA_VERSION=$(java -version 2>&1 | grep version |  awk -F '.' '{print $2}')
   
if ! `echo $JAVA_OPTS | grep -q "UseCompressedOops"`
then
    	JAVA_OPTS=$JAVA_OPTS" -XX:+UseCompressedOops"
fi

export JAVA_OPTS