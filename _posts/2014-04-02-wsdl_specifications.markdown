---
layout: post
title: "WSDL Specifications"
date: 2014-04-02
categories: technical wsdl
author: "Raunak Kathuria"
---

A WSDL definition contains the following structural elements:

### &lt;definitions&gt;
It is the root element in WSDL. It defines the name of the web service and specifies the namespace that would be used in the WSDL document.

{% highlight xml %}
<definitions xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" 
    xmlns:tns="http://service.com/"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns="http://schemas.xmlsoap.org/wsdl/"
    targetNamespace="http://service.com/"
    name="AdditionsubtractionService">
{% endhighlight %}

**xmlns:tns** - means this namespace i.e. namespace used for particular WSDL

**xmlns** - specifies default name space i.e. all of the elements in this WSDL definition without namespace prefix such as , are part of this namespace

**targetNamespace** - it lets the WSDL document make references to itself as an XML schema namespace, it’s not required for WSDL document to actually exist at the address specified, it only specifies the way to refer to WSDL definition in unique way

**name** - name of the service

### &lt;types&gt;
It encloses the data type definitions that would be used to define the messages exchanged between user and the service.

{% highlight xml %}
<types>
  <xs:schema version="1.0" targetNamespace="http://service/"
    xmlns:tns="http://service/" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xs:element name="addition" type="tns:addition"/>
   <xs:element name="additionResponse" type="tns:additionResponse"/>
   <xs:complexType name="addition">
     <xs:sequence>
       <xs:element name="a" type="xs:int"/>
       <xs:element name="b" type="xs:int"/>
     </xs:sequence>
   </xs:complexType>
   <xs:complexType name="additionResponse">
     <xs:sequence>
       <xs:element name="return" type="xs:int" minOccurs="0"/>
     </xs:sequence>
   </xs:complexType>
  </xs:schema>
</types>
{% endhighlight %}

**element** - specifies the data type, in above example define two elements “addition” and “additionResponse” which are further categorized as complexType

### &lt;message&gt;

It represents a logical definition of the data being transmitted between service and the user.

{% highlight xml %}
<message name="addition">
  <part name="parameters" element="tns:addition" />
</message>
<message name="additionResponse">
  <part name="parameters" element="tns:additionResponse" />
</message>
<message>
  <part .../>
</message>
{% endhighlight %}

It contains one or more logical parts, part are flexible mechanism for describing logical abstract content of the message and each part is associated with type from some <type> system i.e. type of part are defined by the element in &lt;types&gt;

### &lt;portType&gt;

It defines the abstract definitions of the operations exposed by the web service.

{% highlight xml %}
<portType name="Additionsubtraction"> 
  <operation name="addition">
    <input message="tns:addition" />
    <output message="tns:additionResponse" /> 
  </operation>
</portType>
{% endhighlight %}

It defines operation by combining &lt;input&gt; message as defined by input &lt;message&gt; and &lt;output&gt; message as defined by the output &lt;message&gt; element.

### &lt;binding&gt;

It defines message format and protocols details for operations and message defined by particular &lt;porttype&gt;

{% highlight xml %}
<binding name="AdditionsubtractionPortBinding" type="tns:Additionsubtraction">
  <soap:binding transport="http://schemas.xmlsoap.org/soap/http" style="document" />
  <operation name="addition">
    <soap:operation soapAction="" />
      <input>
        <soap:body use="literal" />
      </input>
      <output>
        <soap:body use="literal" /> 
      </output>
  </operation>
</binding>
{% endhighlight %}

### &lt;service&gt;

* Specifies Location of the service
* &lt;port&gt; in service defines the endpoint by specifying single address for a binding
* Groups a set of related ports together

{% highlight xml %}
<service name="AdditionsubtractionService">
   <port name="AdditionsubtractionPort" binding="tns:AdditionsubtractionPortBinding"> 
     <soap:address location="https://116.73.230.57:7002/WebServices/AdditionsubtractionService" />
  </port>
</service>
{% endhighlight %}

[get the pdf with example]({{ "/assets/documents/wsdl/wsdl_specification.pdf" | relative_url }})
