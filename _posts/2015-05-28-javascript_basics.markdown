---
layout: post
title:  "Javascript Basics"
date:   2015-05-28
categories: learning javascript
description: "Javascript basics, javascript object creation, way to create object in javascript, javascript inheritance"
author: "Raunak Kathuria"
---

This post is about self-learning, I like to note down my understanding of concept that I am working on or learning for better understanding and grasp.

> Please note that information in this post may not be accurate or not as per standards

##Javascript Object - Ways to create javascript object

###Factory Pattern

{% highlight javascript %}
function createPerson(name, age) {
    var obj = new Object();
    obj.name = name;
    obj.age = name;
    obj.sayName = function () {
        console.log(this.name);
    };
    return obj;
}
var person = createPerson("abc", 29);
{% endhighlight %}

Problem with this approach is that all object created with this will have type of Object so it leads to problem of Object Identification

###Constructor Pattern

{% highlight javascript %}
function Person(name, age) { // by convention constructor function begin with capital
    this.name = name;
    this.age = age;
    this.sayName = function () {
        console.log(this.name);
    };
}
var person = new Person("abc", 29);
{% endhighlight %}

It solved the Object identification which is great advantage over `factory pattern`

*Contructors defined in this way are defined in global object* so `window.Person` and `window.person` are accessible.

Only difference between functions and contructors is the way they are called, for constructor we use `new Person` and functions are called normally

so above contructor can be called like this

``var person = new Person("abc", 29); // constructor``

``Person('abc', 29);`` adds to windows object so ``window.sayName`` prints abc

The problem with contructor function is that each object has its own method even though they serve the same purpose, here `sayName` is creating for every `Person` object. to fix this we can move sayName outside contructor function

{% highlight javascript %}
function Person(name, age) {
    this.name = name;
    this.age = age;
    this.sayName = sayName;
}

function sayName() {
    console.log(this.name);
};

var person = new Person("abc", 29);
{% endhighlight %}

but this leads to issue of populating global space with `sayName` so we have now `window.sayName` function

##Prototype Pattern

{% highlight javascript %}
function Person() {}

Person.prototype.name = "Nicholas";
Person.prototype.age = 29;
Person.prototype.sayName = function () {
    console.log(this.name);
}

var person = new Person();
person.sayName(); // Nicholas
{% endhighlight %}

Each function is created with prototype property, prototype property is an object containing properties and methods that would be available to instance of reference type. As name suggest its actually a prototype of object that will be created when constructor is called. All properties and methods are shared across instances.

When function is created its prototype property is also created and gets a property called *constructor* that points back to function of which prototype is property of (properties passed through constructor will also be added), so `Person.prototype.constructor` points to `Person`.

Whenever new instance is created that instance has one internal property (`__proto__` or `[[Prototype]]`) that points to `constructor prototype` not to constructor directly.

![Prototype Constructor Instance Relation]({{ site.url }}/assets/images/learning/prototype_constructor_relation.png)

> Prototype Constructor Instance Relation

Although prototype property are readable but its not possible to overwrite them, for e.g.

{% highlight javascript %}
var person1 = new Person();
var person2 = new Person();

person1.name = "xyz"; // this only mask the prototype property
person2.name; // prints abc as its not possible to overwrite
{% endhighlight %}

**hasOwnProperty**

`hasOwnProperty` can be used to determine if instance has property not prototype so `person2.hasOwnProperty("name")` will return false
Object properties can be iterated with `for in`, `Object.keys` and `Object.getOwnPropertyNames`

**for in**

This iterate over all the object property that are *enumerable* i.e. instance property as well as property present in prototype, so `for (var o in person) { console.log(o); }` prints `name, age, sayName`

ECMAScript 5 sets `[[Enumerable]]` to false on the constructor and prototype properties, but this is inconsistent across implementations.

**Object.keys**

To iterate over instance own enumerable property use `Object.keys` so `Object.keys(person1)` will give you `["name"]` only and `Object.keys(Person.prototype)` will output `["name", "age", "sayName"]`

**Object.getOwnPropertyNames**

`Object.getOwnPropertyNames` returns an array for both *enumerable* and *non enumerable* object properties, so `Object.getOwnPropertyNames` will output `["constructor", "name", "age", "sayName" ]`

> Both `Object.keys()` and `Object.getOwnPropertyNames()` may be suitable replacements for using `for-in`

### Alternate Prototype Syntax

In previous prototype pattern notice that we had to type `Person.prototype` for all the properties individually, this can be replaced with object literal structure

{% highlight javascript %}
function Person() {}
Person.prototype = {
    name : "Nicholas",
    age  : 29,
    sayName : function () { alert(this.name); }
}
{% endhighlight %}

Please note that with this you are defining a new prototype completely for `Person`, end result is same, with one exception the `constructor` property no longer points `Person` as that now points to new object created. `instanceof` will work fine but `constructor` will not work

{% highlight javascript %}
var person = new Person();
if (person instanceof Person) // true
if(person.constructor == Person) // false
if(person.constructor == Object) // true
{% endhighlight %}

if `constructor` is important then use this format

{% highlight javascript %}
function Person() {
}
Person.prototype = {
    constructor: Person,
    name : "Nicholas",
    age  : 29,
    sayName : function () { alert(this.name); }
}
{% endhighlight %}

but by adding like this `constructor` would become *enumerable* wherease by normal *Prototype* `constructor` is not *enumerable*. To fix this you can use `Object.defineProperty`

{% highlight javascript %}
Object.defineProperty(Person.prototype, "constructor", {
    enumerable: false,
    value: Person
});
{% endhighlight %}

**Dynamic nature of Prototype**

Changes made to prototype are reflected on all instance even if instance was created before protoype

{% highlight javascript %}
var person = new Person();
Person.prototype.name = "abc";
person.name // abc
{% endhighlight %}

As prototype is assigned when constructor is called so if you define prototype using object literal sytax then it will be only applicable for instance created afterwards

{% highlight javascript %}
var person = new Person();
Person.prototype.name = "Sample";
Person.prototype = {
    constructor: Person,
    name : "Nicholas",
    age  : 29,
    sayName : function () { alert(this.name); }
}
person.sayName(); // gives error
person.name; // prints Sample
var person1 = new Person();
person1.sayName(); // prints Nicholas
{% endhighlight %}

![Prototype object literal behaviour]({{ site.url }}/assets/images/learning/prototype_object_literal_behaviour.png)

### Problems with prototype

First and foremost is that you can pass initialization arguments into constructor, more of a inconvenience rather than problem.

Major issue is that all properties are shared across all the instances. For example

{% highlight javascript %}
function Person() {
}
Person.prototype = {
    constructor: Person,
    name : "Nicholas",
    age  : 29,
    friends: ["dsd", "sasd"],
    sayName : function () { alert(this.name); }
}
var person1 = new Person();
var person2 = new Person();

person1.friends.push("abs");

person1.friends; // dsd, sasd, abs
person2.friends; // dsd, sasd, abs
{% endhighlight %}

as `friends` is property of prototype not instances so change is reflected on all instances

### Constructor/Prototype Pattern

The constructor pattern define the instance properties and prototype pattern define methods and other shared properties.

{% highlight javascript %}
function Person(name, age, job) {
    this.name = name;
    this.age = age;
    this.job = job;
    this.friends = ["Shelby", "Court"];
}

Person.prototype = {
    constructor: Person;
    sayName : function() {
        alert(this.name);
    }
};

var person1 = new Person("Nicholas", 29, "Software Engineer");
var person2 = new Person("Greg", 27, "Doctor");
person1.friends.push("Van");

alert(person1.friends); //"Shelby,Court,Van"
alert(person2.friends); //"Shelby,Court"
alert(person1.friends === person2.friends); //false
alert(person1.sayName === person2.sayName); //true
{% endhighlight %}

The hybrid constructor/prototype pattern is the most widely used and accepted practice for defining custom reference types in ECMAScript. Generally speaking, this is the default pattern to use for defining reference types.

___

## Inheritance

ECMAScript only supports implementation inheritance i.e. actual methods are inherited not method signatures as methods don't have signature in ECMAScript

### Prototype Chaining
{% highlight javascript %}
function SuperType() {
    this.property = true;
}

SuperType.prototype.getSuperValue = function () {
    return this.property;
}

function SubType() {
    this.subproperty = true;
}

SubType.prototype = new SuperType();

SubType.prototype.getSubValue = function (){
    return this.subproperty;
};

var instance = new SubType();
console.log(instance.getSuperValue()); // true
{% endhighlight %}

![Prototype Chaining Inheritance]({{ site.url }}/assets/images/learning/prototype_chaining_inheritance.png)

>Prototype Chaining Inheritance

Instead of using default prototype of `SubType` a new prototype is assigned that points to `SuperType` prototype. As `SubType.prototype` is instance of `SuperType` so it gets properties and methods of `SuperType`.

Please note that the `getSuperValue` remain on `SuperType` but `property` is assigned to `SubType` as `getSuperValue` is prototype method but `property` is instance property.

Also note that `instance.constructor` points to SuperType, because the constructor property on the `SubType.prototype` was overwritten. `SubType.prototype = new SuperType();`

#### Working with methods

Sub type can either define new methods or override Super methods but both should be done after protoype has been assigned `SubType.prototype = new SuperType();`

{% highlight javascript %}
var SuperType = function () {
    this.property = true;
}

SuperType.protoype.getSuperValue = function () {
    return this.value;
}

function SubType() {
    this.subproperty = false;
}

var SubType = new SuperType();

SubType.prototype.getSubValue = function () {
    return this.subProperty;
}

// override
SubType.prototype.getSuperValue = function () {
    return false;
}

var instance = new SubType();
instance.getSuperValue(); // false
{% endhighlight %}

Another important thing to understand is that the object literal approach to creating prototype methods cannot be used with prototype chaining, because you end up overwriting the chain

{% highlight javascript %}
function SuperType(){
    this.property = true;
}

SuperType.prototype.getSuperValue = function(){
    return this.property;
};

function SubType(){
    this.subproperty = false;
}
//inherit from SuperType
SubType.prototype = new SuperType();

//try to add new methods - this nullifi es the previous line
SubType.prototype = {
    getSubValue : function (){
        return this.subproperty;
    },
    someOtherMethod : function (){
        return false;
    }
};

var instance = new SubType();
alert(instance.getSuperValue()); //error!
{% endhighlight %}

#### Problems with prototype chaining

Prototype references are shared across all instances and When implementing inheritance using prototypes, the prototype actually becomes an instance of another type, meaning that what once were instance properties are now prototype properties.

{% highlight javascript %}
function SuperType() {
    this.colors = ["red", "green"];
}

function SubType() {
}

SubType.prototype = new SuperType(); // as prototype is now instance of SuperType so color
// is property of prototype

var instance1 = new SubType();
instance1.push("blue");

var instance2 = new SubType();
instanc2.colors; // "red, green, blue"
{% endhighlight %}

A second issue with prototype chaining is that you cannot pass arguments into the supertype constructor when the subtype instance is being created. In fact, there is no way to pass arguments into the supertype constructor without affecting all of the object instances

### Constructor Stealing

To fix the reference values on prototype issue, constructor stealing was introduced

{% highlight javascript %}
function SuperType (name) {
    this.colors = ["red", "green", "blue"];
    this.name = name;
}
function SubType(name) {
    SuperType.call(this, name);
}

var instance1 = new SubType("Abc"); // passing arguments is possible
instance1.colors.push("black");
instance1.colors // "red", "green", "blue", "black"

var instance2 = new SubType("Xyz");
instance2.colors // "red", "green", "blue"
{% endhighlight %}

Problem with this approach is that methods can't be reused as they are defined inside constructor

### Combination Inheritance / pseudoclassical inheritance

combines prototype and constructor stealing inheritance to take advantage of both.

{% highlight javascript %}
function SuperType (name) {
    this.colors = ["red", "green", "blue"];
    this.name = name;
}

SuperType.prototype.sayName = function () {
    console.log(this.name);
}

// inherits properties - constructor stealing
function SubType(name, age) {
    SuperType.call(this, name);
    this.age = age;
}

// inherits methods - prototype inheritance
SubType.prototype = new SuperType();

SubType.prototype.sayAge = function () {
    console.log(this.age);
}

var instance1 = new SubType("Abc", 29); // passing arguments is possible
instance1.colors.push("black");
instance1.colors // "red", "green", "blue", "black"
instance1.sayName; // Abc
instance1.sayAge; // 29

var instance2 = new SubType("Xyz", 21);
instance2.colors // "red", "green", "blue"
instance1.sayName; // Xyz
instance1.sayAge; // 21
{% endhighlight %}

### Prototypal Interface

This doesn't involve strictly type constructor


{% highlight javascript %}
function object(o) {
    function F() {}
    F.prototype = o;
    return new F();
}
var person = {
    name: "Nicholas",
    friends: ["Shelby", "Court", "Van"]
};

var anotherPerson = object(person);
anotherPerson.name = "Greg";
anotherPerson.friends.push("Rob");

var yetAnotherPerson = object(person);
yetAnotherPerson.name = "Linda";
yetAnotherPerson.friends.push("Barbie");

alert(person.friends); //"Shelby,Court,Van,Rob,Barbie"
{% endhighlight %}

ECMAScript 5 formalized the concept of prototypal inheritance by adding the `Object.create()`

{% highlight javascript %}
var person = {
    name: "Nicholas",
    friends: ["Shelby", "Court", "Van"]
};

var anotherPerson = Object.create(person);
anotherPerson.name = "Greg";
anotherPerson.friends.push("Rob");

var yetAnotherPerson = Object.create(person);
yetAnotherPerson.name = "Linda";
yetAnotherPerson.friends.push("Barbie");

alert(person.friends); //"Shelby,Court,Van,Rob,Barbie"
{% endhighlight %}

Prototypal inheritnace is good if you don't want to have multiple constructors. Please note that the properties containing reference values will be shared across instances

### Parasitic Inheritance

Create a function that does the inheritance and augment the object in some way and returns the object i.e. it performs everything

{% highlight javascript %}
function createAnother(original) {
    var clone = object(original); // Object.create(original);
    clone.sayHi = function () {
        console.log(this.name);
    }
    return clone;
}
{% endhighlight %}

#### Problem with Parasitic Interface

Keep in mind that adding functions to objects using parasitic inheritance leads to ineffi ciencies related to function reuse, similar to the constructor pattern

### Parasitic Combination inheritance
