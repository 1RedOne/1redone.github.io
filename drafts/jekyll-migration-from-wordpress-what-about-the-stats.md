---
title: "Jekyll Migration From WordPress - What about the stats?!"
date: "2021-04-10"
redirect_from : 2021/04/10/github-report-issue-button
coverImage: ..\assets\images\2021\imageNeeded.webp
categories: 
  - "scripting"
tags: 
  - "Jekyll"
  - "blogging"
  - "github"
  - "draft"
excerpt: "In migrating from Wordpress.com hosting, I noticed that there wasn't any great one solution for the 'WordPress Stats' info I got from WordPress' JetPack Service.  In this post, I'll show you exactly how I recreated both the utility AND more importantly the Vanity I got from WordPress Stats (the later to satify my ego!)"
fileName: '2021-04-10-jekyll-migration-from-wordpress-what-about-the-stats'
---

## {{ post.title }}

Recently I migrated my blog off of WordPress hosting and over to static sites generated from Markdown files, hosted on GitHub Pages.

# Octocat photo here

In migrating from Wordpress.com hosting, I noticed that there wasn't any great one solution for the 'WordPress Stats' info I got from WordPress' JetPack Service.  In this post, I'll show you exactly how I recreated both the utility AND more importantly the Vanity I got from WordPress Stats (the later to satify my ego!)

![Header for this post, reads 'How To Make GitHub Button']({{ post.coverImage }})

*Post Outline*

* Example of What I'm talking about
* Why is this useful?
* The Actual Meaningful Part
* Satisfying My Ego
* Automatically adding it below posts in Jekyll

## What are WordPress Stats

If you're a long time reader of blogs but don't blog on your own, you might never have paid much attention to little widgets like these on the sites you visit.

# Screen shot of stat counter

But believe me, the authors of those sites **definitely** know what I'm talking about.

What does it do?  Well, it might be a little bit old school but it just keeps track of the page loads of a site.  If someone comes and visits an article, then clicks to see some more in the series and ends up looking at four other articles, it would tick up five more times.

# Marge I just think they're neat

If you host your blog on WordPress, one of the nifty features you can enable is a Plugin called JetPack which gives you a number of cool features, one of which is the stat tracker I showed above.

Unfortunately if you migrate away from WordPress...you can't bring it with you.

Or can we??

https://tutorial.eyehunts.com/js/javascript-number-format-comma-html-format-number-thousands-separator/



<div class="card" style="padding-top:20px;">    
    <header class="card-header">
        <div class="card-header-title">Blog Stats</a>
    </header>
    
    <div class="card-content">
        <div class="content">            
            <div id='blogHits'></div>
            <!-- initial value at migration was 2,065,292 -->
            <Script>
var xhr = new XMLHttpRequest();
xhr.open("GET", "https://api.countapi.xyz/hit/foxdeployhits");
xhr.responseType = "json";
xhr.onload = function() {
    document.getElementById('blogHits').innerText = this.response.value.toLocaleString('en') + ' hits';
    console.log("total hits " + this.response.value.toLocaleString('en'));
}
xhr.send();

</Script>
<p></p>
        </div>        
    </div>    
</div>


irm "https://api.countapi.xyz/create?key=foxdeployhits&value=2065292"