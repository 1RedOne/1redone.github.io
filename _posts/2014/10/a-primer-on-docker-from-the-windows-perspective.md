---
title: "A primer on Docker from the Windows Perspective"
date: "2014-10-29"
categories: 
  - "azure"
  - "virtualization"
tags: 
  - "docker"
---

If you’re keeping up with the Azure talks from TechEd Barcelona this week (and you should be!) you’ve heard a lot of mentions about Docker recently.

Wondering what it is?

Docker is a technology that allows an application developer to install and sequence the execution of their application to ‘containerize’ it in a portable container which can be docked and executed anywhere, seamlessly alongside other applications without application installation dependencies causing interference. The key differentiation point here is that the application and its dependencies are virtualized, rather than the underlying OS, as in traditional virtualization. The big benefit to abstraction of the OS is portability and a significant reduction in overhead.

Instead of developers giving out an install script and binaries, they can provide a fully configured Docker image, which can be run on any system with the Docker engine installed, which includes OS X, Windows and pretty much any version of Linux. Keep in mind while running Docker in Windows that while VirtualBox will be used, Docker does not require hardware virtualization support.

This graphic from Docker does a great job of explaining why it is becoming so popular. Note the size difference between a system with many docked containers versus the system load of a system with many VMs.

![](https://foxdeploy.files.wordpress.com/2014/10/docker-vm-container-620x3501.png) Traditional VM vs Docker Containers\[/caption\]

Early adopters are reporting four to six times increases in density!

I used the word ‘sequencing’ earlier for a reason, as it should be a keyword for anyone who used App-V in the past, evoking either sublime memories of a halcyon era, or a shudder of knowing fear.

> Docker can basically be thought of as the second-coming of App-V application virtualization for the Linux World.

Many of the same concepts that we used to sequence applications using that technology apply, such as installing and running an app to declare dependencies and so on. Additionally, these Docker containers can be linked together to facilitate intra-application communication as well.

One should note though that using Docker on a Windows System necessitates the introduction of VirtualBox, as Docker needs OS features from Linux to function. The installation process currently for a Windows system is quite clunky, and involves the install of VirtualBox to run Ubuntu, from within which Dockerized Containers can be used.

This means that if you want to streamline your AWS or Azure experience to cram some containers in along your Windows VMs, you should be mindful of the compute and storage overheads.

Definitely a technology to keep an eye on, especially if it expands to support Windows Applications. Abstracting away the need for the underlying OS is a very powerful concept still in its infancy.
