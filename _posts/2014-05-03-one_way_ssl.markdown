---
layout: post
title: "One Way SSL"
date: 2014-05-03
categories: technical ssl
description: "One way ssl basics - Implementation on Weblogic 10 and Glassfish 3 with self signed certificates"
tags: ['one way ssl', 'ssl implementation', 'configure one way ssl', 'one way ssl glassfish', 'one way ssl weblogic']
author: "Raunak Kathuria"
---

> Please note that the link and screenshot used in this post may be outdated as it was implemented few years back. Please use this for reference purpose only.

In one way SSL the server is required to present the certificate to the client to verify the credentials of the server but client is not verified by the server.

![One Way SSL Flow]({{ site.url }}/assets/images/ssl/one-way-ssl.png)

> One Way SSL Flow Diagram

### Implementation

> Weblogic Version: 10, Glassfish Version 3, OS: Windows

Example below shows how to configure one way SSL for client connecting to Weblogic/Glassfish Server. Both servers provide default keystore (database of private keys and certificate) which are complete in themselves for SSL implementation in testing environment. In production environment you should implement your own certificate signed by your own CA.

More information on configuring SSL on Weblogic at: [Weblogic SSL](http://docs.oracle.com/cd/E13222_01/wls/docs81/secmanage/ssl.html){:target="_blank"}

Java provides keytool, a key and certificate management utility. It enables users to administer their own public/private key pairs and associated certificates for use in self-authentication.

*keytool stores the keys and certificates in a so-called keystore.*

For more information on keytool visit: [Keytool Tutorial](http://docs.oracle.com/cd/E19798-01/821-1841/gjrgy/index.html){:target="_blank"}

Following are the steps to implement One Way SSL:

* Set the path to use keytool: set the path to your jdk `set path="c:\Program Files\Java\jdk{version}\bin"`
* Configure the servers to enable One Way SSL

    **Weblogic**

    * Configure the servers to enable One Way SSL

        For Weblogic `Start Weblogic -> Login to console -> Click on Environment -> Servers -> SSL ->Advanced`

    * Make sure in Two Way Client Cert behavior option Client certs not requested is selected
    ![One Way SSL configuration on weblogic]({{ site.url }}/assets/images/ssl/client_certs_not_requested_weblogic.png)

    > One Way SSL configuration on weblogic

    **Glassfish**

    Make sure that client authentication is not selected
    ![One Way SSL config for glassfish]({{ site.url }}/assets/images/ssl/client_authentication_not_enabled_glassfish.png)

    > One Way SSL config for glassfish

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

*Implementation steps from now on are explained by taking example of weblogic as steps are same for both the server*

* To print the information about the certificate created `C:\>keytool -printcert -v -file D:\certificates\server.cer`

* To view the information about certificates in the client keystore(Java provides its own truststore which is placed in `C:\Program Files\Java\jdk1.6.0_06\jre\lib\security` directory with name cacerts

    `C:\>keytool -list -v -keystore "C:\Program Files\Java\jdk1.6.0_06\jre\lib\security\cacerts"`

* Start the execution of client (in this example client is a java program) before importing the certificate to client keystore (default java keystore)

    > Note: Service deployed on server has basic addition and subtraction operation exposed

    {% highlight bash %}
    Client Run
    Enter your choice:
    Addition
    Subtraction
    1
    Enter the first number for the operation. 10
    Enter the second number for the operation. 20
    {% endhighlight %}

The following error will occur indicating certificate is missing

* Import the server certificate into the client cacert

    `C:\>keytool -import -alias demoidentity -trustcacerts -file D:\certificates\server.cer - keystore "c:\Program Files\Java\jdk1.6.0_06\jre\lib\security\cacerts"`

    > Note: For glassfish import the glasscert.cer into the cacert

* Run the client again

    {% highlight bash %}
    Start the execution of client

    Enter your choice:
    1. Addition
    2. Subtraction
    1
    Enter the first number for the operation. 10
    Enter the second number for the operation. 20
    Port is JAX-WS RI 2.1.1 in JDK 6:
    Stub for https://116.73.230.57:7002/WebServices/AdditionsubtractionService Result of addition is 30
    BUILD SUCCESSFUL (total time: 33 seconds)
    {% endhighlight %}

#### Additional Information

If you get the following error while running your client:

{% highlight bash %}
javax.xml.ws.WebServiceException: Failed to access the WSDL at: https://116.73.230.57:7002/WebServices/AdditionsubtractionService?WSDL. It failed with:
java.security.cert.CertificateException: No subject alternative names present.
at com.sun.xml.internal.ws.wsdl.parser.RuntimeWSDLParser.tryWithMex(RuntimeWSDLParser. java:136)
at com.sun.xml.internal.ws.wsdl.parser.RuntimeWSDLParser.parse(RuntimeWSDLParser.java:1 22)
{% endhighlight %}

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

![SSL Hostname Verification Weblogic Setting]({{ site.url }}/assets/images/ssl/ssl_hostname_verification_weblogic.png)

> SSL Hostname Verification Weblogic Setting

[get the pdf with example]({{ site.url }}/assets/documents/ssl/one_way_ssl.pdf)
