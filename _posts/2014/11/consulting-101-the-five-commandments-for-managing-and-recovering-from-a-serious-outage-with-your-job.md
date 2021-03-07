---
title: "The Five Commandments of managing and recovering from a serious outage (with your job!)"
date: "2014-11-07"
categories: 
  - "consulting"
tags: 
  - "consulting-101"
  - "disaster-recovery"
---

### Topic introduction: Consulting 101

I know that I tend to write mostly about PowerShell, tool-building and some sysadmin topics here, but I would like to expand that out and begin writing about the business behind delivering IT and how to be a good sysadmin/consultant. I plan to draw on my experiences serving as an IT Consultant for the last five years.

If you'd like me to touch on a particular topic, or think I've made a mistake, please contact me and let me know.

### The Five Commandments for recovering (with your job!) from a serious outage or failure

We've all had that creeping sensation when we hit enter, and the system takes just a little too long.  Our hands get clammy, we may start to sweat, you get that taste of metal in your mouth.  For instance, when you meant to update one row and see this instead

\[caption id="attachment\_946" align="alignnone" width="705"\][!["Uhm, honey...I might be late for dinner..."](images/runawayquery.png)](https://foxdeploy.files.wordpress.com/2014/11/runawayquery.png) "Uhm, honey...I might be late for dinner..."\[/caption\]

 

Believe me, I've been in this position before, and I survived every instance of it with my skin still on.  When done correctly, you can even build a relationship further through proper management of a serious outage.  First and foremost, when the going gets tough, you should remember the Hitchhiker's Guidebook cover and...

**Thou shalt not panic even if the wall is aflame and spiders are crawling out of the vents**

Don't panic!  Keep your wits about you and understand what went wrong.  Don't be afraid to immediately inform your technical management that something has gone wrong.   There is no surer method to be shown the door than to try to conceal a problem, especially a serious one.

Put feelers out to your colleagues and peers to seek their feedback in dealing with similar issues.  Perhaps one of them knows a quick method to restore everything. Ensure that you do not cause further damage due to rash decisions.  Once you know what happened...

### Thou shalt quench the flames consuming thy infrastructure

Cancel your dinner plans and roll up your sleeves, it's time to dig in and get things back up and running. If you have the team, appoint a single person as the point man to handle communicating out the status updates, and expect to give updates quite regularly while things are still broken.

If you have the option, aim to get things limping if need be while you engineer a more perfect solution.It's okay to have an accident, but doing a stupid mistake because you're tired or under the wire will lead to questions you'd like not to answer.

For an example of a team doing a wonderful job of communicating status updates and really puling together and recover, see how Emory handled progress reporting (https://web.archive.org/web/20140517145618/http://it.emory.edu/windows7-incident/) when they had a damaging run-away ConfigMan task sequence earlier in the year.

Every few hours, they would update a point web page, and they made efforts to roll people off to go home and rest while maintaining the work effort. This is how it's done, people. Get things up and working and then go home and rest.

When you return to work…

### Thou shalt take ownership of thy mistakes and not blame another

I'm really going to emphasize what not to do here. Don't blame others. Don't throw yourself under the bus when you do accept the blame either. Finally, don't be too worried about losing your job, as it takes a lot of money and time to train a replacement. Instead, invest your effort in framing how you'll explain the problem and really understand what took place. Don't squirm out of the way by delivering a jargon filled explanation.  Think of how you may feel when the car mechanic comes back with a confusing description of whats wrong with your car, and a huge bill.

In the midst of a disaster is _not_ when you should be updating your resume.

You'll need to take good notes on what happened and when, you'll need this because next…

### Thou shalt understand the error of thy ways

This means you need to research in great depth the details of what happened.

You need to become an unchallenged expert on the best practices related to the problem, and be able to highlight problems inherent in the previous approach that lead to things falling apart.  Don't be a weasel about it, as an admin/consultant, we're here to simplify explanations of things like this to our customers. You've got to maintain your credibility, and you can do so with an honest explanation of what went wrong.  You need to write things up. Make it look pretty and identify other similar problems that you can fix while you're doing this. You've got to come up with and present some safe-guards to keep this from happening again. If the same failure occurs again, you're pretty much going to be shown the door in most places.

It's of the upmost importance that for the next few weeks…

### Thou shalt present thyself in a manner most becoming

It's time to be on point.  You'll be under a microscope, as your customers and peers wonder if this was a one-off thing or actually the first indication that maybe you don't know what you're doing.

Keep in mind that you need to present yourself as a professional who had an accident of the sort that happens from time to time in any professional industry. You don't want to be seen as someone in over his head who made a preventable mistake. There are a lot of things you can do at this point to make sure you're presenting yourself well.

**Come into work on time.**  Studies show that even in this day and age of universal connectivity and remote work, most managers when surveyed about their workers consistently listed those who came into the office and were there earliest as their perceived hardest workers.

**Show up looking sharp.** Get your hair cut, look good, and iron your clothes.Avoid flashy colors, as most studies state that men look most professional in charcoal or khaki slacks, and with a light blue or white dress shirt.  Now is the time to speak properly, not in contractions or colloquially, it's the time to sound like a smart guy too.

**Compose yourself**.  Stay calm.  You may be the victim of some good natured ribbing over the next few weeks.  Now is not the time to get your back against the wall and lash out at people who are trying to make light of the issue.  Take it all in stride and grin while they throw a little bit of poo at you.  We've all been there before.

If you're in this situation, or recovering from it, let me know if this advice was helpful to you please.

In my next piece in this series, I'll go through what you should put in a post-mortem or after-action report.
