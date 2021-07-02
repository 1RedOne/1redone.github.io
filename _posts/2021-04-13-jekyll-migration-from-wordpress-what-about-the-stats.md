---
title: "Jekyll Migration From WordPress - What about the stats?!"
date: "2021-04-13"
redirect_from : 2021/04/13/jekyll-migration-stats/
coverImage: \assets\images\2021\trackingStates.webp
categories: 
  - "scripting"
tags: 
  - "Jekyll"
  - "blogging"
  - "githubPages"
  - "googleAnalytics"
excerpt: "In migrating from Wordpress.com hosting, I noticed that there wasn't any great one solution for the 'WordPress Stats' info I got from WordPress' JetPack Service.  In this post, I'll show you exactly how I recreated both the utility AND more importantly the Vanity I got from WordPress Stats, seeing big numbers pop up like I'm back in WoW..."
fileName: '2021-04-10-jekyll-migration-from-wordpress-what-about-the-stats'
---
Recently I migrated my blog off of WordPress hosting and over to static sites generated from Markdown files, hosted on GitHub Pages.

In migrating from Wordpress.com hosting, I noticed that there wasn't any great one step  solution for the 'WordPress Stats' info I got from WordPress' JetPack Service.  In this post, I'll show you exactly how I recreated both the utility AND more importantly the Vanity I got from WordPress Stats (the later to satisfy my ego!)

![Header for this post, reads 'How To Make GitHub Button'](\assets\images\2021\trackingStates.webp)

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

So I hunted for an easy peasey API, and found a great one in [countapi.xyz](https://api.countap.xyz](https://api.countapi.xyz/))

All you do with this API is register your new counter with an optional reset / control code and then trigger a Get request to increment and retrieve the new value!

So to create a new tracker for a site called `mysite.com` and then set its starting value at 42, we'd run:

```javascript
GET https://api.countapi.xyz/create?namespace=mysite.com&value=42
⇒ 200 {"namespace":"mysite.com", "key":"33606dbe-4800-4228-b042-5c0fb8ec8f08", "value":42}
```

And then, after that, we only need to run a new get request to see that we're up and running.

```powershell
Invoke-RestMethod "https://api.countapi.xyz/hit/foxdeployhits"
>2075540
```
## Getting it working in JavaScript

Now I have a mechanism to track my hits, I just need to actually trigger this when the page is loaded. This needs to happen client side (which sadly means I lose tracking and counts if the user has JavaScript disabled or very strict settings, *c`est la vie*).


## Automatically adding it to posts in Jekyll

This was really easy.  My blog theme, Bulma-Clean-Theme already had a look and feel I liked from my site on WordPress [foxdeploy.wordpress.com](https://www.foxdeploy.wordpress.com), so with a minimal amount of configuration, I had something that felt familiar.

It even had a great sidebar function, provided via a file called `Latest-Posts.html`.  Here's mine if you want to see what it looks like:

[latest-posts](https://github.com/1RedOne/1redone.github.io/blob/master/_includes/latest-posts.html)

![depicts Tails from Sonic the Hedge, blushing](/assets/images/2021/tailsBlush.gif)

**when someone looks at my source code**

Adding a new node here to mimic the 'Page Stats' feature was very easy, just adding a new div with the right class.

```html
<div class="card" style="padding-top:20px;">
    <header class="card-header">
        <div class="card-header-title">Blog Stats</a>
    </header>
    <div class="card-content">
        <div class="content">
            <div id='blogHits'></div>
        </div>
    </div>
</div>
```

>**Note:** Pay special attention to the currently empty div called *blogHits* above, for now it will be empty but we'll use this as an anchor to inject a value in just a moment!


Now to reload and see how it shows up...

![shows a new node added to a menu with the text content of 'Blog Stats' but no value](/assets/images/2021/jekyll_statCounter_empty.png)

I can trigger a http request when this element is loaded by adding a bit of JS, like this:

```js
<Script>
var xhr = new XMLHttpRequest();
xhr.open("GET", "https://api.countapi.xyz/hit/foxdeployhits");
xhr.responseType = "json";
xhr.onload = function() {
    document.getElementById('blogHits').innerText = this.response.value + ' hits';
    console.log("total hits " + this.response.value);
}
xhr.send();

</Script>
```

With this code, we prepare a GET request over to countapi.xyz, and then onload (when we have a response), we scan the document object model (the DOM, a code based interpretation of the current webpage, which feels **very familiar** coming from PowerShell) to find the empty div we setup earlier. 

This works BUT....the number is uggo.


![shows a new node added to a menu with the text content of 'Blog Stats' but no value](/assets/images/2021/jekyll_statCounter_valueweird.png)

Fortunately JavaScript has approximate 857,3028,237 different built in formatting tools, and I can make use of the convenient `.toLocaleString('en')` utility to transpose strings into different formats.  Because I'm Anglo-centric, I have chose the **right way** to do it, using comma separators.  Sorry if you like other format types!

With this in place...

![shows a new node added to a menu with the text content of 'Blog Stats' but no value](/assets/images/2021/jekyll_statCounter_complete.png)

## How does this compare to Google Analytics?

Frankly, Google Analytics gives me INCREDIBLE amounts of data and is dramatically far and away much, much better than what I had before with WordPress stats.  It even has a load of tools to show me ways I can improve the site, like Accessibility and page loads.

I did a lot of work transcribing Accessibility and alt tags onto images, and now have a much better layout for keyboard navigation, and now no longer have screen shots of code, and the site loads much faster.

All of these issues were surfaced to me by Google Analytics, which is frankly the bomb,  and I will probably write a blog post about it later on!

## Wrapping up

Did you like this post?  Are you interested in what it took to migrate my site from WordPress over to GitHub pages?  You're in luck, I have some more posts planned for that topic!  Leave me a message below and lemme know!


🐦 - Shout out to Chris for the excellent [Bulma Clean Theme](https://github.com/chrisrhymes/bulma-clean-theme)

🐦 - Shout out to this [blog post by Rohit from Eyehunts](
https://tutorial.eyehunts.com/js/javascript-number-format-comma-html-format-number-thousands-separator/
) for the tip on how to format numbers in a way that makes me happy.
