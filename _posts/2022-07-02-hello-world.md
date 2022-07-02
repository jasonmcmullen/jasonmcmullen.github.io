---
title: "Post: Hello World!"
last_modified_at: 2022-07-02T16:20:02-05:00
categories:
  - Blog
tags:
  - Post Formats
  - readability
  - standard
---

Hello World!

This is my homelab documentation project. Feel free to use the details here for your own projects.

Day 1. Documentation: 

I found that Markdown would be the easiest to work with, reference: [MD Cheatsheet](https://www.markdownguide.org/cheat-sheet/)

And hosting would be ideally free, given that this is a personal project and not funded, so I settled on [Pages](https://pages.github.com)

Sticking to a minimalist theme I'll be using theme: [minimal-mistakes](https://github.com/mmistakes/minimal-mistakes)

On initial deployment I was following [jekyllrb](https://jekyllrb.com/)
But found that a gem was missing post install, details discussed with another user here: [discussion](https://github.com/github/pages-gem/issues/752)

The fix was to run the following before running Jekyll:

`bundle add webrick`

And of course, from the root of the local site, to initialize everything I would run:

`bundle install`

and to run it locally for development, before pushing changes to the cloud:

`bundle exec jekyll serve s`

