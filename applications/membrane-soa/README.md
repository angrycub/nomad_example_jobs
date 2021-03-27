Deploying a Java REST to SOAP Proxy in Connect

Technologies:

- Consul Service Mesh
- Consul Egress Gateways
- Nomad Java Task Driver

https://www.membrane-soa.org/service-proxy-doc/4.7/soap-quickstart.htm

<https://www.membrane-soa.org/service-proxy-doc/4.7/rest2soap-gateway.htm>


http://localhost:2000/bank/37050198




service-proxy.sh

```
#!/bin/bash
homeSet() {
 echo "MEMBRANE_HOME variable is now set"
 CLASSPATH="$MEMBRANE_HOME/conf"
 CLASSPATH="$CLASSPATH:$MEMBRANE_HOME/starter.jar"
 export CLASSPATH
 echo Membrane Router running...
 java  -classpath "$CLASSPATH" com.predic8.membrane.core.Starter -c proxies.xml
 
}

terminate() {
	echo "Starting of Membrane Router failed."
	echo "Please execute this script from the appropriate subfolder of MEMBRANE_HOME/examples/"
	
}

homeNotSet() {
  echo "MEMBRANE_HOME variable is not set"

  if [ -f  "`pwd`/../../starter.jar" ]
    then 
    	export MEMBRANE_HOME="`pwd`/../.."
    	homeSet	
    else
    	terminate    
  fi 
}


if  [ "$MEMBRANE_HOME" ]  
	then homeSet
	else homeNotSet
fi

```

