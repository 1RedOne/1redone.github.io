---
title: "Hundreds of Baseline Settings with just one assignment!"
date: "2026-10-27"
redirect_from: /azure-policy-baseline-customization
coverImage: /assets/images/2026/DidYouKnow-Customization.png
hero_image: /assets/images/2026/DidYouKnow-Customization.png
categories:
  - "azure"
  - "security"
tags:
  - "Azure Policy"
  - "Azure Machine Configuration"
  - "Baseline Customization"
  - "Security Baselines"
  - "Windows"
  - "Linux"
excerpt: "Baseline Customization in Azure Policy lets you tailor hundreds of security settings in a single assignment for your chosen baseline. Less policy sprawl, a clearer compliance picture, and one important caveat: audit only."
fileName: '2026-10-27-azure-policy-baseline-customization.md'
---

![Azure Policy Baseline Customization: hundreds of settings in a single assignment.](/assets/images/2026/DidYouKnow-Customization.png)

# Hundreds of Baseline Settings. One Assignment. A Lot Less Policy Sprawl.

If you've ever tried to customize security settings across a fleet of Windows and Linux machines, you know how quickly the policy list can multiply.

One policy here. Another one there. And before long, keeping track of which settings are enabled, excluded, or customized becomes its own full-time job.

**Baseline Customization in Azure Policy** gives us a much cleaner way to do it.

## Pick a baseline. Make it yours.

You can tailor hundreds of settings in a single assignment for the baseline you choose. That includes:

- **Azure Linux Baseline**
- **Azure Windows Baseline**
- **CIS Linux Security Baseline**
- **CIS Windows Baseline** *(currently in preview)*

Choose the rules that matter to your organization, adjust supported values, and assign that customized baseline to the machines in scope. The result is a much more focused way to manage a large set of settings together.

## Fewer policies to juggle

The old approach could mean stitching together dozens of built-in policies, each with a small set of configurable settings—often around 20.

That gets noisy fast. It also makes it harder to see the shape of your organization's baseline and keep the whole thing consistent.

Baseline Customization brings those settings together, so you can work with hundreds of controls in one place and carry them in **a single policy assignment for that baseline**. Less policy sprawl, fewer moving pieces, and a much clearer picture of what you're auditing.

## One important caveat: audit only

Today, Baseline Customization evaluates settings and reports compliance. It does **not** change machine settings or remediate noncompliant machines.

That makes it a great way to define and measure the baseline you want across your fleet. If a machine doesn't meet a setting, Azure Policy can tell you; you'll need another process to make the change.

This is a big step toward making baseline management more manageable—and I'm super excited to share more soon.

Try it today in an Azure portal near you, under Policy \ Authoring \ Baseline Customization
 

Microsoft Ignite is **November 17–20, 2026**: [Microsoft Ignite 2026](https://ignite.microsoft.com/en-US/home).

![Baseline Customization — I made this.](/assets/images/2026/baselineIMadethis.png)