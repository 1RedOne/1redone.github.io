---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
title: Automation Tails from the FoxHole
food: Pizza
layout: page
show_sidebar: true
hero_image: /assets/images/foxdeployMOUNTAINTOP_hero.jpg
---
<style>
  meta{
  
    color: #426f86;
    font-family: Raleway,Arial,Helvetica,sans-serif;
    /* font-size: 13px; */
    font-size: 0.6rem;
    margin-top: 1em;

  }
</style>
<ul>
  {% for post in site.posts %}

      <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
      <div class="meta"><i class="fa fa-calendar" aria-hidden="true"></i> {{ post.date | date: '%B %d, %Y' }}
        <i class="fa fa-user" aria-hidden="true"></i> FoxDeploy
      </div>
      <a href="{{ post.url }}"><img src="{{ post.header }}{{ post.coverImage }}"></a><br>
      {{ post.excerpt }}
      <i><a href="{{ post.url }}" style="padding-left:25px;">Continue Reading...</a></i>
      <div class="tags">
        {% for tag in post.tags %}
          {% include tag.html tag=tag %}
        {% endfor %}
      </div>
      <hr>
  {% endfor %}
</ul>