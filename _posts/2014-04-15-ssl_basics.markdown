---
layout: post
title: "SSL Basics"
date: 2014-04-15
categories: technical ssl
author: "Raunak Kathuria"
---

Secure Sockets Layer is a protocol designed to enable applications to transmit information back and forth securely. It allows client/server applications to communicate across a network in a way designed to prevent eavesdropping and tampering. SSL provides endpoint authentication and communications confidentiality over the Internet using cryptography.

A SSL client and server negotiate a stateful connection by using a handshaking procedure. During this handshake, the client and server agree on various parameters used to establish the connection’s security.

* The handshake begins when a client connects to a SSL-enabled server requesting a secure connection, and presents a list of supported CipherSuites (ciphers and hash functions).
* From this list, the server picks the strongest cipher and hash function that it also supports and notifies the client of the decision.
* The server sends back its identification in the form of a digital certificate. The certificate usually contains the server name, the trusted certificate authority (CA), and the server’s public encryption key.
* The client may contact the server that issued the certificate (the trusted CA as above) and confirm that the certificate is authentic before proceeding.
* In order to generate the session keys used for the secure connection, the client encrypts a random number with the server’s public key, and sends the result to the server. Only the server should be able to decrypt it (with its private key): this is the one fact that makes the keys hidden from third parties, since only the server and the client have access to this data. The client knows public key and random number, and the server knows private key and (after decryption of the client’s message) random number. A third party may only know random number if private key has been compromised.
* From the random number, both parties generate key material for encryption and decryption.

This concludes the handshake and begins the secured connection, which is encrypted and decrypted with the key material until the connection closes.
