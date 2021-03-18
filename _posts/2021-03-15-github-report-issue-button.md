---
title: "GitHub Report Issue Button"
date: "2021-03-15"
redirect_from : /2021/03/15/github-report-issue-button
coverImage: ..\assets\images\2021\title_githubbutton.webp
categories: 
  - "scripting"
tags: 
  - "Jekyll"
  - "blogging"
  - "github"
excerpt: "I have long admired the Report Issue button on Microsoft Docs and sought to recreate it.  Then I loved it so much, I added it to the end of every post!  Here's how, and you can just copy and paste it and then take the rest of the day off!"
---

## GitHub Report Issue Button

I have long admired the Report Issue button on Microsoft Docs and sought to recreate it.  Then I loved it so much, I added it to the end of every post!  Here's how, and you can just copy and paste it and then take the rest of the day off!

![Header for this post, reads 'How To Make GitHub Button'](..\assets\images\2021\title_githubbutton.webp)


*Post Outline*


* Example of What I'm talking about
* Why is this useful?
* OK, I'm sold, let's make one! - WIP
* How to make it into a snippet - WIP
* Automatically adding it below posts in Jekyll

## What are you smoking, Stephen?

This is a reasonable question to ask anyone, and especially me.  

Way back in the day when I was writing a Wiki or docs for work, I knew that if I had a bug or error in my documentation, I could count on my good ol' buddy [Wayne from @waingrositblog](https://twitter.com/waingrositblog) to spin in his chair and shout

>Yo, this shit is whack, son

before he went back to looking at collectible Transformer figurines and then you knew you had to make some changes to your docs.  

But not everyone had a Wayne of their own. So eventually everyone else started rolling comments on their blogs with Disqus or something similar.  However they got flooded by Spam and noise and it was hard to stay on top of them.  

So now we're left with needing a way for people to report issues in your posts without using comments which are hard to stay on top of without a lot of effort.

Enter the Report Issue Button, which can be found in a lot of Microsoft Docs, [like this page on adding Application Insights to your app](https://docs.microsoft.com/en-us/azure/azure-monitor/app/api-custom-events-metrics).

![shows a Microsoft docs page with a Feedback bar, with two buttons.  One button reads 'This Product', and the other reads 'This Page'](..\assets\images\2021\issuebuttonInAction.png)

##  Why is this useful?

Clicking this button takes the user to the 'Report an issue' page but also populated the body of the issue with a lot of useful info.

![Shows the Github repository for Azure Docs, opening a new Issue, with a body for the issue popualted with lots of fields listed below the image](..\assets\images\2021\issuebuttonBody.png)

This implementation is great, because it automagically includes a lot of info about the post including which specific URL they viewed and also a link to the source file, so the dev or whoever isn't left wondering what the heck the person is talking about.  

I loved this and knew that I with me hosting my new blog on GitHub pages, I wanted to rely on GitHub Issues as well to keep track of needed changes and feedback. 

##  OK, I'm sold, let's make one!
##  How to make it into a snippet

##  Automatically adding it below posts in Jekyll

Adding this snippet automatically is super easy.  With it saved in the `./includes` folder, we can then reference it within any page manually by using this syntax. 

```
`{`% include gitHubLink.html `%`}
```

>Remove the backticks!

So now our final step is to add this to our default `post.html` layout, which will be found in the layouts folder.

Merge the new `include` statement here after post content.

{% gist c923f896d01ae1470f7b84a6ad24d99b %}

And then after a Jekyll Rebuild, it should appear beneath your posts!

![Shows a working Report Issue Github button below a blog post.](..\assets\images\2021\GitHubReportButton.png)
