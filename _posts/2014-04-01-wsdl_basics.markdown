---
layout: post
title:  "WSDL Basics"
date:   2014-04-01
categories: technical wsdl
description: "WSDL Basics, WSDL structure and WSDL components"
author: "Raunak Kathuria"
---

WSDL is a description language for the web services. It provides a modal and XML format for describing web services. WSDL represents information about how to invoke a web service exposed at the specified location.

When we develop web service we create its WSDL definitions and then link to this WSDL is published in the web service registry (UDDI for instance) so that users(s) of the service can follow this link to locate the web service, methods exposed and how to invoke these calls. Finally the user(s) would use this infomation to create a request message (based on binding information) to invoke the function of the web service.

WSDL contains mainly four important pieces/components of information about the web service:

* Interface information about the methods exposed by the web service.
* Data type for the incoming and the outgoing messages to the method exposed.
* Binding information which defines message format and protocol to be used for invoking the specified web service.
* Location/Address of the exposed web service.

![WSDL Structure]({{ "/assets/images/wsdl/wsdl_specifications.jpg" | relative_url }})

> WSDL Structure
