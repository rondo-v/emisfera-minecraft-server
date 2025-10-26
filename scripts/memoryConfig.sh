#!/bin/bash        

if ! `echo $JVM_OPTS | grep -q "\-Xms[[:digit:]\.]"`
then
        [ -z "$XMS" ] && { XMS="-Xms32M"; }
        JVM_OPTS=$JVM_OPTS" $XMS"; 
fi

if ! `echo $JVM_OPTS | grep -q "\-Xmn[[:digit:]\.]"`
then
        [ -z "$XMN" ] && { XMN="-Xmn30M"; }
        JVM_OPTS=$JVM_OPTS" $XMN"; 
fi

if ! `echo $JVM_OPTS | grep -q "\-Xmx[[:digit:]\.]"`
then
        [ -z "$XMX" ] && {
        	#optimal XMX = 80% * total available RAM
        	#it differs a little bit from default values -Xmx http://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html
        	memory_total=`free -m | grep Mem | awk '{print $2}'`;
        	let XMX=memory_total*8/10;
        	XMX="-Xmx${XMX}M";
        }
        JVM_OPTS=$JVM_OPTS" $XMX";
fi

if ! `echo $JVM_OPTS | grep -q "\-Xminf[[:digit:]\.]"`
then
        [ -z "$XMINF" ] && { XMINF="-Xminf0.1"; }
        JVM_OPTS=$JVM_OPTS" $XMINF"; 
fi

if ! `echo $JVM_OPTS | grep -q "\-Xmaxf[[:digit:]\.]"`
then
        [ -z "$XMAXF" ] && { XMAXF="-Xmaxf0.3"; }
        JVM_OPTS=$JVM_OPTS" $XMAXF"; 
fi

XMX_VALUE=`echo $XMX | grep -o "[0-9]*"`;
XMX_UNIT=`echo $XMX | sed "s/-Xmx//g" | grep -io "g\|m"`;
if [[ $XMX_UNIT == "g" ]] || [[ $XMX_UNIT == "G" ]] ; then 
	let XMX_VALUE=$XMX_VALUE*1024; 
fi

JAVA_AGENT = "-javaagent:/data/jelastic-gc-agent.jar=period=300"
JVM_OPTS=$JVM_OPTS" $JAVA_AGENT";

JAVA_VERSION=$(java -version 2>&1 | grep version |  awk -F '.' '{print $2}')

if ! `echo $JVM_XX_OPTS | grep -q "\-XX:MaxPermSize"`
then
        [ -z "$MAXPERMSIZE" ] && { 
        	# if java version <= 7 then configure MaxPermSize otherwise ignore 
        	[ $JAVA_VERSION -le 7 ] && {
			let MAXPERMSIZE_VALUE=$XMX_VALUE/10; 
        		[ $MAXPERMSIZE_VALUE -ge 64 ] && {
				[ $MAXPERMSIZE_VALUE -gt 256 ] && { MAXPERMSIZE_VALUE=256; }
				MAXPERMSIZE="-XX:MaxPermSize=${MAXPERMSIZE_VALUE}M";
                	}
		}
  	}
        JVM_XX_OPTS=$JVM_XX_OPTS" $MAXPERMSIZE";
fi
 
if ! `echo $JVM_XX_OPTS | grep -q "\-XX:+Use.*GC"`
then	
	[ -z "$GC" ] && {  
        	[ $JAVA_VERSION -le 7 ] && {
       			GC_LIMMIT=8000;
	    		[ "$XMX_VALUE" -ge "$GC_LIMMIT" ] && GC="-XX:+UseG1GC" || GC="-XX:+UseParNewGC";
	    	} || {
	    		GC="-XX:+UseG1GC";
	    	}
     	}
        JVM_XX_OPTS=$JVM_XX_OPTS" $GC"; 
fi 
   
if ! `echo $JVM_XX_OPTS | grep -q "UseCompressedOops"`
then
    	JVM_XX_OPTS=$JVM_XX_OPTS" -XX:+UseCompressedOops"
fi

export JVM_OPTS
export JVM_XX_OPTS
