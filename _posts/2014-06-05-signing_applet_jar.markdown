---
layout: post
title: "Signing Applet Jar using signed certificates"
date: 2014-06-05
categories: technical
description: "Signing Applet Jar using signed certificates"
tags: ['signed applet', 'signed applet using signed certificate',  'signing jar']
author: "Raunak Kathuria"
---

As per new security policy Applet needs to be signed with trusted certificates

As per [oracle documentation](http://www.oracle.com/technetwork/java/javase/tech/java-code-signing-1915323.html){:target="_blank"}

> Java Applet & Web Start - Code Signing -->  Starting with Java SE 7 Update 21 in April 2013 all Java Applets and Web Start Applications are encouraged to be signed with a trusted certificate. And starting with 7u25, all files must be added to JARs prior to signing.

This post provides step by step guide for signing applet jar

**Step by step guide**

Consider the path of applet as website/applet/ourapplet.jar

* Create the pkcs12 using openssl file for server certificate and key as keytool don’t have any functionality to import key directly

    `openssl pkcs12 -export -in server.crt -inkey server.key \ -out server.p12 -name some-alias \ -CAfile ca.crt -caname root`

    For example

    `openssl pkcs12 -export -in Documents/signedcert.com.crt -inkey Documents/key/signedcert.com.key  -out Documents/signing_sandbox/cert.com.p12 -name signed-cert  -CAfile Documents/signing_sandbox/bundle-g2.crt -caname GoDaddy -chain -passout pass:<OPEN_SSL_PASSWORD>`

    Please note you need to enter the password for openssl file otherwise it will give some error while importing

* Now import the generated file cert.com.p12 to keystore using keytool

    `keytool -importkeystore -deststorepass <KEYTOOL_PASSWORD> -destkeypass <KEYTOOL_PASSWORD> -destkeystore server.keystore -srckeystore server.p12 -srcstoretype PKCS12 -srcstorepass some-password -alias some-alias`

    `keytool -importkeystore  -deststorepass changeit -destkeypass changeit -destkeystore /root/signing_sandbox/keystore.jks  -srckeystore Documents/signing_sandbox/cert.com.p12 -srcstoretype PKCS12 -srcstorepass <OPEN_SSL_PASSWORD> -alias server-cert`

* Now sign the jar with keystore generated using jarsigner

    `jarsigner  -keystore /root/signing_sandbox/keystore.jks website/appletcode/ourapplet.jar server-cert`

    It will ask for keystore password, enter the keystore password you entered in step 2 KEYTOOL_PASSWORD

* You can verify the jar is signed by using

    `jarsigner -verify -keystore /root/signing_sandbox/keystore.jks website/appletcode/ourapplet.jar`

