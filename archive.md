---
layout: page
title: Archives
permalink: /archives/
hero_image: ../assets/images/foxdeployMOUNTAINTOP_hero.webp
hero_height: is-medium
show_sidebar: true
---
## FoxDeploy Older posts
If you'd like to dig into posts from a given year, look no further.
{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %} 


{% for year in postsByYear %}

* [{{ year.name }}](/{{ year.name }}) ({{year.size}} posts)

{% endfor %}



<a href="https://reddit.com/r/foxdeploy"><img src="/assets/images/foxdeploySubreddit.png" alt="depicts a crowd of people in a night club with colored lights and says 'join the foxdeploy subrreddit today'" ></a><br>