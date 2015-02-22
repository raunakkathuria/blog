---
layout: post
title: "Grunt gh-pages error"
date: 2014-06-10
categories: technical
tags: ['gh-pages error', 'grunt gh-pages']
description: "Grunt gh-pages error - Couldn't find remote ref refs/heads/gh-pages"
author: "Raunak Kathuria"
---

Using grunt gh-pages module can give the following error while pushing to the origin:

{% highlight bash %}
Cloning git@github.com:<organization>/<repo>.git into .grunt/grunt-gh-pages/gh-pages/src
Cleaning
Fetching origin
Warning: fatal: Couldn't find remote ref refs/heads/gh-pages
Use --force to continue.
{% endhighlight %}

This can occur if you have executed the **gh-pages** command at least once and then deleted the remote branch. Now if you again run the **gh-pages** command the above error will occur.

This occurs because **gh-pages** updates the .gitconfig under (**.grunt/grunt-gh-pages/gh-pages/src/.git/config**) with the reference and if you do `git clean -fd` it skips the **.grunt/gh-pages** folder.

The solution is to do `rm -rf .grunt` and then run the `grunt gh-pages` command
