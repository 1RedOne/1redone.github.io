---
title: "New Mod Released - Fox Revolt Fun++ for Royal Revolt Survivors"
date: "2026-05-16"
redirect_from: /fox-revolt-fun-plus-plus-royal-revolt-survivors-mod
coverImage: \assets\images\2026\fox-revolt-fun-plus-plus-hero.png
categories:
  - "programming"
  - "tools"
  - "gaming"
tags:
  - "Royal Revolt Survivors"
  - "BepInEx"
  - "Unity"
  - "Mods"
  - "CSharp"
excerpt: "I released Fox Revolt Fun++, an unofficial fun-first balance mod for Royal Revolt Survivors, and somehow it looks like I may be the first person to mod this game. Maybe I'm the only one playing it?."
fileName: '2026-05-16-fox-revolt-fun-plus-plus-royal-revolt-survivors-mod.md'
---

![](../assets/images/2026/fox-revolt-fun-plus-plus-hero.png)

Hi folks!  Normally this is the part where I talk about PowerShell, Azure, troubleshooting some strange Microsoft account portal that insists reality is optional, or another little tool I made because I saw a workflow and thought "what if this had fewer sharp edges?"

Today is a little different.

I released a new mod!

And not just "I changed one JSON value and now the sword is blue" kind of mod, either.  This is the first mod I wrote from scratch on my own, for a game that, as far as I can tell, no one else had modded yet.

So please imagine me standing on a very small podium, holding a very small trophy, while Unity stack traces rain gently in the background.

## Introducing Fox Revolt Fun++

**Fox Revolt Fun++** is an unofficial, fun-first, BepInEx balance mod for **Royal Revolt Survivors**.

The goal is pretty simple: make runs feel faster, more generous, and less punishing, while still leaving the core game intact.  It gives you a little more attack speed, better healing, more meaningful level-up scaling, and some co-op kindness so your friend going down does not immediately become a group tax audit.

Download it here:

> **[Fox Revolt Fun++ on GitHub](https://github.com/1RedOne/Fox-Revolt-Fun-Plus-Plus)**

Grab the newest release from the Releases page, unzip it into your BepInEx plugins folder, and then go forth and make the numbers more fun.

## What It Changes

The short version is this:

- Faster combat
- Stronger healing
- Better passive health regeneration
- Friendlier co-op revives
- Better scaling from level-up picks
- A much more exciting version of Moe's Cheers ability
- A config file, because hard-coded balance values are where fun goes to become a spreadsheet crime scene

Or, if you prefer the technical version:

```text
FoxRevoltFunPlusPlus.dll
```

I made a dll!

That little DLL patches several player stat and ability behaviors at runtime using BepInEx.  Which sounds very normal until you remember that the first few hours of Unity modding mostly feel like walking through someone else's house in the dark while carrying a plate of spaghetti.

## Faster Combat

The mod improves player attack pacing in two ways.

First, it adds a base attack speed bonus:

```text
BasePlayerAttackSpeedBonus = 0.15
```

That means you get an extra 15 percent attack speed on top of whatever bonuses you buy in the store.

Second, level-up picks now contribute a small speed and area bonus over the run.  The first few picks matter more, then later picks keep helping without turning the screen into an overclocked leaf blower.

Default scaling:

```text
First three effective level-up picks: +3% speed and area each
Later effective level-up picks:      +0.5% speed and area each
```

The design goal here is "early level-ups feel great" and not "the entire combat model becomes pudding by minute twelve."

## Stronger Healing

Healing gets a nice bump:

```text
HealingMultiplier = 3.0
```

This makes recovery feel much less stingy, especially when a run starts going sideways and you are trying to keep the dream alive through the ancient tactical art of "please no, please no, please no."

## Better Health Regeneration

The mod also injects an added health regeneration multiplier into player stats:

```text
HealthRegenerationMultiplier = 2.0
```

With a fully buffed Recharge ring, you can go from 0 to full health in about 30 seconds now.

Just don't get hit.

I realize that advice has the same energy as "have you tried winning?" but there it is.

## Co-Op Revives Are Less Mean Now

Royal Revolt Survivors has a co-op rescue world event where reviving a teammate originally punished the rescuer with a health penalty.

Fox Revolt Fun++ patches that behavior so rescuing a friend no longer turns into "congratulations, you helped, now suffer."

The revived player comes back with configurable health:

```text
CoopReviveHealthPercent = 0.5
```

I have tested this locally.  Online play is still in the "probably? maybe? let me know if the machine spirits become upset" category.

## Moe Cheers Buff

Moe's special move, Cheers / DrinkBrew, got special attention because its original effects felt weak and included some health-related penalties that were not exactly screaming "good times."

So I fixed it.

Let's get drank.

The mod:

- Adds `+1` max/current charge
- Halves recharge time
- Halves cooldown
- Triples positive Cheers stat effects
- Doubles Cheers buff duration
- Removes negative health-related Cheers penalties

Now it feels more like a special move and less like a suspicious beverage from a side quest.

## Installing BepInEx

Fox Revolt Fun++ is a BepInEx plugin, so you need BepInEx installed first.

Download BepInEx here:

> **[BepInEx on GitHub](https://github.com/BepInEx/BepInEx)**

Unzip the BepInEx package into the game's install folder, alongside files like:

```text
Steam\steamapps\common\Royal Revolt Survivors\rrw.exe
Steam\steamapps\common\Royal Revolt Survivors\UnityPlayer.dll
```

The BepInEx files, including `winhttp.dll`, should be in that same folder.

Launch the game once, then quit.  After that, check for the BepInEx log file:

```text
Steam\steamapps\common\Royal Revolt Survivors\BepInEx\LogOutput.log
```

If that file exists, you're golden.

## Installing Fox Revolt Fun++

Download the newest release from the Fox Revolt Fun++ releases page, then extract the mod DLL into the BepInEx plugins folder:

```text
Steam\steamapps\common\Royal Revolt Survivors\BepInEx\plugins\FoxRevoltFunPlusPlus.dll
```

Launch the game, start a run, and enjoy the gently enhanced chaos.

If you're installing on Steam Deck: yes, I see you.  Steam Deck support is on my mind, and the setup should be similar to other BepInEx-on-Proton workflows, but I want to test it properly before I write the "click exactly these things" version and accidentally send someone into Linux folder-path jazz.

## Configuration

The mod reads its tuning values from:

```text
BepInEx/config/buffs.json
```

If the file does not exist, the mod creates it with default values.

Current default config:

```json
{
  "HealingMultiplier": 3.0,
  "BasePlayerAttackSpeedBonus": 0.15,
  "EarlyLevelPickSpeedAreaBonus": 0.03,
  "LaterLevelPickSpeedAreaBonus": 0.005,
  "HealthRegenerationMultiplier": 2.0,
  "CoopReviveHealthPercent": 0.5,
  "MoeWarriorIdContains": "Hero_Monk",
  "MoeSecretMoveAbilityIdContains": "Cheers,DrinkBrew",
  "MoeSecretMoveExtraCharges": 1,
  "MoeSecretMoveRechargeTimeMultiplier": 0.5,
  "MoeSecretMoveCooldownMultiplier": 0.5,
  "CheersAbilityIdContains": "Cheers,DrinkBrew",
  "CheersBuffStatMultiplier": 3.0,
  "CheersBuffDurationMultiplier": 2.0,
  "CheersRemoveHealthPenalty": true,
  "CheersBuffNegativeStats": false,
  "VerboseLogging": false,
  "HeartbeatLogging": false
}
```

If you want a more relaxed run, turn the numbers up.  If you want a more vanilla-ish experience, turn them down.  If you set everything to 50 and the game becomes a physics presentation, I support you emotionally but possibly not technically.

## How It Works

Royal Revolt Survivors is a Unity game, which means BepInEx can load a plugin DLL into the game process and let us patch behavior at runtime.

That sentence is doing a lot of work.

The practical version is:

- Build a C# BepInEx plugin
- Load it into the game
- Find the right Unity / IL2CPP types
- Patch the right methods
- Add logging
- Launch the game
- Watch everything explode
- Add more logging
- Repeat until the fun number goes up and the crash number goes down

I learned a lot making this.  Some of that learning was peaceful.  Some of it involved staring at method names and wondering if I was reading code or a prophecy.

## Why This One Feels Special

This is my first mod written from scratch, by me, for a game that did not appear to have an existing modding scene.

That made every little breakthrough feel enormous.

Getting BepInEx to load?  Huge.

Finding the right stat hooks?  Huge.

Seeing the plugin actually change gameplay?  Absolutely massive.

At some point the project crossed that magical line from "I am poking at a process and hoping" into "wait, I can actually shape the game now," which is one of those feelings that keeps programmers voluntarily walking back into the puzzle room.

## Build And Deployment

The project builds a BepInEx plugin DLL:

```text
FoxRevoltFunPlusPlus.dll
```

The deploy target copies the built DLL to:

```text
BepInEx/plugins/FoxRevoltFunPlusPlus.dll
```

But if you're just here to play the mod, you probably don't care about that part.  Click Releases, download the newest bits, and go have a faster, friendlier run.

## TL;DR

I made a mod for **Royal Revolt Survivors**.

It is called **Fox Revolt Fun++**.

It makes combat faster, healing stronger, co-op revives nicer, level-ups more exciting, and Moe's Cheers ability significantly less rude.

Download it here:

> **[https://github.com/1RedOne/FoxRevoltFunPlusPlus](https://github.com/1RedOne/FoxRevoltFunPlusPlus)**

And if you try it, please let me know how it feels.  Especially if you find a weird edge case, a broken interaction, or a build where Moe becomes too powerful and starts making eye contact with the renderer.
