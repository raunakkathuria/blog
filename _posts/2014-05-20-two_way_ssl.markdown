---
layout: post
title: "Two Way SSL"
date: 2014-05-20
categories: technical ssl
tags: ['two way ssl', 'ssl implementation', 'configure two way ssl', 'two way ssl glassfish', 'two way ssl weblogic']
description: "Two Way SSL Basics - Implementation on Weblogic 10 and Glassfish 3 with self signed certificates"
author: "Raunak Kathuria"
---

> Please note that the link and screenshot used in this post may be outdated as it was implemented few years back. Please use this for reference purpose only.

In Two Way SSL (mutual authentication) the client verifies the identity of the server, and then the server verifies the credentials of the client. The figure below gives an overview of the Two Way SSL process.

![Two Way SSL Flow]({{ "/assets/images/ssl/two-way-ssl.png" | relative_url }})

> Two Way SSL Flow Diagram

### Implementation

> Weblogic Version: 10, Glassfish Version 3, OS: Windows

Example below shows how to configure Two Way SSL for client connecting to Weblogic/Glassfish Server. Both servers provide default keystore (database of private keys and certificate) which are complete in themselves for SSL implementation in testing environment. In production environment you should implement your own certificate signed by your own CA.

More information on configuring SSL on Weblogic at: [Weblogic SSL](http://docs.oracle.com/cd/E13222_01/wls/docs81/secmanage/ssl.html){:target="_blank"}

Java provides keytool, a key and certificate management utility. It enables users to administer their own public/private key pairs and associated certificates for use in self-authentication.

*keytool stores the keys and certificates in a so-called keystore.*

For more information on keytool visit: [Keytool Tutorial](http://docs.oracle.com/cd/E19798-01/821-1841/gjrgy/index.html){:target="_blank"}

Following are the steps to implement Two Way SSL:

* Set the path to use keytool: set the path to your jdk `set path="c:\Program Files\Java\jdk{version}\bin"`
* Configure the servers to enable Two Way SSL

    **Weblogic**

    * Configure the servers to enable Two Way SSL

        For Weblogic `Start Weblogic -> Login to console -> Click on Environment -> Servers -> SSL ->Advanced`

    * Make sure in Two Way Client Cert behavior option Client Certs Requested and Enforced is selected
    ![Two Way SSL configuration on weblogic]({{ "/assets/images/ssl/two-way-ssl-config-weblogic.png" | relative_url }})

    > Two Way SSL configuration on weblogic

    **Glassfish**

    Make sure that client authentication is enabled
    ![Two Way SSL config for glassfish]({{ "/assets/images/ssl/two-way-ssl-config-glassfish.png" | relative_url }})

    > Two Way SSL config for glassfish

* To view the information about certificate(s) in default keystore

    **Weblogic**

    `C:\>keytool -list -v -keystore D:\Oracle\Middleware\wlserver_10.3\server\lib\DemoIdentity.jks`

    Default Password for DemoIdentity.jks is DemoIdentityKeyStorePassPhrase

    **Glassfish**

    `C:\>keytool -list -v -keystore "c:\Program Files\glassfish-v3- prelude\glassfish\domains\domain1\config\keystore.jks`

    Keystore password is masterpassword of domain that is defined by user during domain creation. (For netbeans glassfish the password is “changeit”)

* Export the certificate in keystore to a file. This certificate file will be imported to client keystore.

    **Weblogic**

    `C:\>keytool -export -alias demoidentity -file D:\certificates\server.cer –keystore D:\Oracle\Middleware\wlserver_10.3\server\lib\DemoIdentity.jks`

    **Glassfish**

    `C:\> keytool -export -v -alias s1as -file D:\certificates\glasscert.cer –keystore "D:\Program Files\glassfish-v3-prelude-b28c\glassfish\domains\domain1\config\keystore.jks"`


* To print the information about the certificate created `C:\>keytool -printcert -v -file D:\certificates\server.cer`

* To view the information about certificates in the client keystore(Java provides its own truststore which is placed in `C:\Program Files\Java\jdk1.6.0_06\jre\lib\security` directory with name cacerts

    `C:\>keytool -list -v -keystore "C:\Program Files\Java\jdk1.6.0_06\jre\lib\security\cacerts"`

* Import the server certificate into the client cacert

    **Weblogic**

    `C:\>keytool -import -alias demoidentity -trustcacerts -file D:\certificates\server.cer - keystore "c:\Program Files\Java\jdk1.6.0_06\jre\lib\security\cacerts"`

    **Glassfish**

    `C:\>keytool -import -v -trustcacerts -alias s1as -keystore "C:\Program Files\Jav a\jdk1.6.0_06\jre\lib\security\cacerts" -file D:\certificates\glasscert.cer`

* Import the client certificate into the server cacert

    **Weblogic**

    `C:\>keytool -import -v -trustcacerts -alias clientalias -keystore D:\Oracle\Middleware\wlserver_10.3\server\lib\DemoTrust.jks -file D:\certificates\clientcert.cer`

    **Glassfish**

    `keytool -import -v -trustcacerts -alias clientalias -file D:\certificates\clientcert.cer -keystore "D:\Program Files\glassfish-v3-prelude-b28c\glassfish\domains\domain1\config\cacerts.jks"`

#### Additional Information

> Note: If you are using self-signed certificate include following property in JAVA_OPTIONS of setDomainEnv of weblogic else weblogic will show Basic CA constraint error and restart the server.

{% highlight bash %}
-Dweblogic.security.SSL.enforceConstraints=off

set JAVA_OPTIONS=%JAVA_OPTIONS% %JAVA_PROPERTIES% -Dweblogic.security.SSL.enforceConstraints=off
{% endhighlight %}

### Errors and Solution

**Error**

If you get the following error while running your client:

{% highlight bash %}
javax.xml.ws.WebServiceException: Failed to access the WSDL at: https://localhos t:7002/BasicOperations/BasicOperationService?wsdl. It failed with:
Received fatal alert: handshake_failure.
at com.sun.xml.internal.ws.wsdl.parser.RuntimeWSDLParser.tryWithMex(Unkn own Source)
at com.sun.xml.internal.ws.wsdl.parser.RuntimeWSDLParser.parse(Unknown Source)
at com.sun.xml.internal.ws.client.WSServiceDelegate.parseWSDL(Unknown Source)
at com.sun.xml.internal.ws.client.WSServiceDelegate.(Unknown Source)
at com.sun.xml.internal.ws.client.WSServiceDelegate.(Unknown Source)
at com.sun.xml.internal.ws.spi.ProviderImpl.createServiceDelegate(Unknown Source)
at javax.xml.ws.Service.(Unknown Source)
at basicoperationservice.wsdl.BasicOperationService.(BasicOperatio nService.java:46)
at client.ClientMain.subtraction(ClientMain.java:51)
at client.ClientMain.main(ClientMain.java:91)
Caused by: javax.net.ssl.SSLHandshakeException: Received fatal alert: handshake_ failure
at com.sun.net.ssl.internal.ssl.Alerts.getSSLException(Unknown Source)
at com.sun.net.ssl.internal.ssl.Alerts.getSSLException(Unknown Source)
at com.sun.net.ssl.internal.ssl.SSLSocketImpl.recvAlert(Unknown Source)
{% endhighlight %}

**Solution**

Make sure that certificates are imported correctly on both client and server side. Error signifies that either server hello or client hello was incomplete.

To check for detailed debug information for SSL include the following property during invocation of client

{% highlight bash %}
-Djavax.net.debug=ssl or –Djavax.net.debug=handshake java -Djavax.net.debug=ssl 
or
You can include it in your code also System.setProperty(“javax.net.debug”,”ssl”);
{% endhighlight %}

**Error**

{% highlight bash %}
javax.xml.ws.WebServiceException: Failed to access the WSDL at: https://localhos t:7002/BasicOperations/BasicOperationService?wsdl. It failed with:
sun.security.validator.ValidatorException: PKIX path building failed: su n.security.provider.certpath.SunCertPathBuilderException: unable to find valid c ertification path to requested target.
at com.sun.xml.internal.ws.wsdl.parser.RuntimeWSDLParser.tryWithMex(Unkn own Source)
at com.sun.xml.internal.ws.wsdl.parser.RuntimeWSDLParser.parse(Unknown Source)
at com.sun.xml.internal.ws.client.WSServiceDelegate.parseWSDL(Unknown Source)
at com.sun.xml.internal.ws.client.WSServiceDelegate.(Unknown Source)
at com.sun.xml.internal.ws.client.WSServiceDelegate.(Unknown Source)
at com.sun.xml.internal.ws.spi.ProviderImpl.createServiceDelegate(Unknown Source)
at javax.xml.ws.Service.(Unknown Source)
at basicoperationservice.wsdl.BasicOperationService.(BasicOperatio nService.java:46)
at client.ClientMain.subtraction(ClientMain.java:51)
at client.ClientMain.main(ClientMain.java:91)
Caused by: javax.net.ssl.SSLHandshakeException: sun.security.validator.Validator Exception: PKIX path building failed: sun.security.provider.certpath.SunCertPath BuilderException: unable to find valid certification path to requested target
at com.sun.net.ssl.internal.ssl.Alerts.getSSLException(Unknown Source) at com.sun.net.ssl.internal.ssl.SSLSocketImpl.fatal(Unknown Source)
{% endhighlight %}

**Solution**

Error signifies that the client was not able to find a valid certificate keystore path. Include the following properties during client invocation

{% highlight bash %}
-Djavax.net.ssl.keyStore="C:\Program Files\Java\jdk1.6.0_06\jre\lib\security\cacerts" - Djavax.net.ssl.keyStorePassword=changeit -Djavax.net.ssl.trustStore="C:\Program Files\Java\jdk1.6.0_06\jre\lib\security\cacerts" - Djavax.net.ssl.trustStorePassword=changeit
For example:
java -Djavax.net.ssl.keyStore="C:\Program Files\Java\jdk1.6.0_06\jre\lib\security\cacerts" -Djavax.net.ssl.keyStorePassword=changeit -Djavax.net.ssl.trustStore="C:\Program Files\Java\jdk1.6.0_06\jre\lib\security\cacerts" - Djavax.net.ssl.trustStorePassword=changeit
{% endhighlight %}

**Error**

When Weblogic is acting as client (i.e. when service deployed on weblogic is accessing the service deployed on another server) in Two Way SSL, you may get the following error “No suitable identity certificate chain has been found.”

**Solution**

Go to SSL tab of your server where application is deployed and enable Use Server Certs

**Error**

If you get the following error while running your client:

{% highlight bash %}
javax.xml.ws.WebServiceException: Failed to access the WSDL at: https://localhos t:7002/BasicOperations/BasicOperationService?wsdl. It failed with:
java.security.cert.CertificateException: No subject alternative names present.
at com.sun.xml.internal.ws.wsdl.parser.RuntimeWSDLParser.tryWithMex(RuntimeWSDLParser.java:136) at com.sun.xml.internal.ws.wsdl.parser.RuntimeWSDLParser.parse(RuntimeWSDLParser.java:122)
at com.sun.xml.internal.ws.client.WSServiceDelegate.parseWSDL(WSServiceDelegate.java:226)
at com.sun.xml.internal.ws.client.WSServiceDelegate.(WSServiceDelegate.java:189)
at com.sun.xml.internal.ws.client.WSServiceDelegate.(WSServiceDelegate.java:159)
at com.sun.xml.internal.ws.spi.ProviderImpl.createServiceDelegate(ProviderImpl.java:81)
{% endhighlight %}

**Solution**

Include the following code in your codebase

{% highlight java %}
static {
   //WORKAROUND. TO BE REMOVED.   javax.net.ssl.HttpsURLConnection.setDefaultHostnameVerifier(new 
   javax.net.ssl.HostnameVerifier() {
    public boolean verify(String hostname, javax.net.ssl.SSLSession sslSession) {
       return true;
    }
    });
}
{% endhighlight %}

Or For Weblogic goto

`Start Weblogic -> Login to console -> Click on Environment -> Servers -> SSL -> Advanced -> Set the Hostname Verification to None`

![SSL Hostname Verification Weblogic Setting]({{ "/assets/images/ssl/ssl_hostname_verification_weblogic.png" | relative_url }})

> SSL Hostname Verification Weblogic Setting

**Client Run**

{% highlight bash %}
C:\Documents and Settings\Raunak\Desktop\client>
java - Djavax.net.ssl.keyStore="C
 :\Program Files\Java\jdk1.6.0_06\jre\lib\security\cacerts" -Djavax.net.ssl.keySt orePassword=changeit -Djavax.net.ssl.trustStore="C:\Program Files\Java\jdk1.6.0_
 06\jre\lib\security\cacerts" -Djavax.net.ssl.trustStorePassword=changeit client. ClientMain

 Enter your choice:
 1. Addition
 2. Subtraction 
 2

 Enter the first number for the operation.. 32
 Enter the second number for the operation.. 28

Client subtract Port is JAX-WS RI 2.1.6 in JDK 6: Stub for https://localhost:700 2/BasicOperations/BasicOperationService
 Result = 4
 Result of subtraction is 4
{% endhighlight %}

[get the pdf with example]({{ "/assets/documents/ssl/two_way_ssl.pdf" | relative_url }})
