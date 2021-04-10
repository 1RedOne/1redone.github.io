---
title: "Jekyll Migration From WordPress - What about the stats?!"
date: "2021-04-12"
redirect_from : 2021/04/12/jekyll-migration-stats
coverImage: ..\assets\images\2021\trackingStates.webp
categories: 
  - "scripting"
tags: 
  - "Jekyll"
  - "blogging"
  - "githubPages"
  - "googleAnalytics"
excerpt: "In migrating from Wordpress.com hosting, I noticed that there wasn't any great one solution for the 'WordPress Stats' info I got from WordPress' JetPack Service.  In this post, I'll show you exactly how I recreated both the utility AND more importantly the Vanity I got from WordPress Stats (the later to satisfy my ego!)"
fileName: '2021-04-10-jekyll-migration-from-wordpress-what-about-the-stats'
---

## {{ post.title }}

Recently I migrated my blog off of WordPress hosting and over to static sites generated from Markdown files, hosted on GitHub Pages.

In migrating from Wordpress.com hosting, I noticed that there wasn't any great one step  solution for the 'WordPress Stats' info I got from WordPress' JetPack Service.  In this post, I'll show you exactly how I recreated both the utility AND more importantly the Vanity I got from WordPress Stats (the later to satisfy my ego!)

![Header for this post, reads 'How To Make GitHub Button']({{ post.coverImage }})

*Post Outline*

* What were WordPress Stats?
* Finding a way to satisfy my ego
* Automatically adding it below posts in Jekyll
* How does this compare to Google Analytics?
  
## What are WordPress Stats

If you're a long time reader of blogs but don't blog on your own, you might never have paid much attention to little widgets like these on the sites you visit.

![shows a common website stat counter, which reads 'Hits to this blog', and shows the number, 2.7 million](/assets/images/2021/jekyll_statCounter.png)

But believe me, the authors of those sites **definitely** know what I'm talking about.

What does it do?  Well, it might be a little bit old school but it just keeps track of the page loads of a site.  If someone comes and visits an article, then clicks to see some more in the series and ends up looking at four other articles, it would tick up five more times.

If you host your blog on WordPress, one of the nifty features you can enable is a Plugin called JetPack which gives you a number of cool features, one of which is the stat tracker I showed above.

Unfortunately if you migrate away from WordPress...you can't bring it with you.

## >Why do you even need this though?

![depicts Marge Simpson from the Simpsons holding a potatoe saying 'I just think they're neat](/assets/images/2021/jekyll_statMarge.webp)

## Can we just hack this into place?

Or can we?? I originally looked at monitoring to see if the request to the WordPress.com hosted site had an obvious method to...extract the call to the API used to track hits to the site.  

Unfortunately, stats seem to be tracked as part of the page load request, and not a separate API call.  

Furthermore, while their API does allow you to query the current traffic stats and milestones, they do not allow you to increment the hits with a simple call that I could find.

This didn't stop me though, I needed a way to see my pretty numbers counting up!

# Finding a way to satisfy my ego

All I *really* needed was an API that could increment simply.  I thought of writing my own dotnet core app, as I've done a bunch of times, like when I wrote a Game of Throne Deathpool site with logons and passwords, or when I wrote a simple app to check the UV levels of a given day (needed because of my ghastly palor, due to being a redhead).

But then...I got lazy.

![depicts an adorable small black kitten asleep on a laptop keyboard](/assets/images/2021/lazyCat.webp)
*My normal level of energy on a given day*

So I hunted for an easy peasey API, and found a great on in [api.countapi.xyz](https://api.countap.xyz)

With that in place, I just needed to register the starting hit tracker from my old site and secure it so I could prevent tampering.

Then to test it, I started with a simple `Invoke-WebRequest` in PowerShell

irm "https://api.countapi.xyz/create?key=foxdeployhits&value=2065292"


## Getting it working in JavaScript




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




## Automatically adding it to posts in Jekyll

This was really easy.  My blog theme, Bulma-Clean-Theme already had a look and feel I liked from WordPress, so with a minimal amount of configuration, I had something that felt familiar.

It even had a great sidebar function, provided via a file called `Latest-Posts.html`.  Here's mine if you want to see what it looks like:

# Add link to my latestpost

## Add blushing anime girt - when someone looks at your source code

Adding this below every post is easy!
## How does this compare to Google Analytics?
  

Why?  Well, we want to know how many people have seen our posts and which ones are most beloved.
