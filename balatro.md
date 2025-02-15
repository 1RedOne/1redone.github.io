---
layout: page
title: Balatro Mod Project
permalink: /jokers/
---

## FoxDeploy Balatro Mod

Hi!  I've begun working on a balatro mod.  A full release and github project will come later!

This doc is laid out in this order:
* Overall list of all cards names and their status
* Approved Cards - Cards being built or fully fleshed out
* Planning and concepts - cards still being developed in the planning phase

# Status

Type | Status | Card Name
--|---|---
Joker | Golden Retriever | Done
Joker | Lucky Retriever | Done
Joker | Fickle Fox | Done
Joker | Fickle Fox Follow Up | Done
Joker | Akuma Themed Card | Testing
Joker | Power Up First Card | Planning
Joker | Fox Themed | Planning
Joker | Kyuubi Themed | Planning
Joker | Clone and Power Up  | Planning
Joker | Octopus Themed | Planning
Joker | Kraken Themed | Planning
Tarot | Enfeeble | Planning
Tarot | Summoning Circle | Planning

Fully Fleshed out cards are at the bottom of the list.  Concepts are at the top.

# Approved Cards

These are being built or are a complete idea and ready to be built.

## Golden Retriever
Design: A golden retriever dog in Balatro-style with two tennis balls in its mouth.
![alt text](../assets/images/balatro/goldenRetriever.png)

Effect:
When a gold card is played, one in three chance of a copy of it being added to your deck.
Should say "Good boy!' when this happens

~~If a gold card returns, it increases in value before being played again.~~

✅ - Card Art Finalized

✅ - Card Appears in Joker List

✅ - Card Functions


## Lucky Retriever
Design: A golden retriever dog in Balatro-style with two tennis balls in its mouth.
![alt text](../assets/images/balatro/luckyRetriever.png)

Effect:
When a lucky card is played, one in three chance of a copy of it being added to your deck.


## Fickle Fox 

- Fickle Fox
- - Applies gold seal to last played hand of cards all played cards? First played hand?
- - Could be Golden Fox Effigy
- One is six chance to vanish

Art Concepts

![alt text](../assets/images/balatro/ficklefox.png)


## Fickle Fox Follow Up - Benevolance

- - Benevolant Fox God
- Follow up Joker, similar to Gros Michel and Cavendish, once fleet fox vanshes
- Gold Seal cards apply 1.5x mult

Concept art - unused

![alt text](../assets/images/balatro/benevolanceConcept.png)

Finalized art

![alt text](../assets/images/balatro/benevolance.png)

## A Kuma
![alt text](../assets/images/balatro/a_kuma.png)
Card Design ideas: 
* Features the Japanese kanji for "Heaven" (天), pronounced "ten".
* Akuma looking joker
* Backwards facing fighter with kanji for heaven
* Backwards facing fighter with katakana for 'joker' 

Effect: When a 10 is played, grants +15 chips and a random buff.
Special Mechanic: Has a chance to count twice, similar to the Blood mechanic.

# Approved Cards

## Summoning Circle Tarot

- - Apply the 'Tag Effect' of Free Uncommon or Rare
- - Applies 'Free Reroll' 

![alt text](../assets/images/balatro/Balatro_Summoning_Circle.webp)

![alt text](../assets/images/balatro/greaterCircle.png)

# Concept Phase Cards

These cards are all presently just a base idea that should be fleshed out more.  

### To Go Even Further Beyond
Design: A Joker card featuring an anime-style transformation with spiky black hair (base form) and spiky blonde hair with glowing green eyes (powered-up form) in retro pixel art.
Effect: When played as the first hand, it increases the power level of a card by +1.

Need better themeing ideas for this card

### Concepts 

These cards all need some more work in the areas of theming and affects

Clone Card → Creates one copy of itself and increases the copy’s power level by +1.

Beautiful Fox → Interacts specifically with cards numbered 7.

Ethereal Nine-Tailed Fox → Interacts specifically with cards numbered 9.

Undertow → Replaces a played single card with a number 8 card.

Squidlord → Eights become lucky & wild, and hit twice.

Enfeeble Tarot → Decreases the power of up to two cards (i.e. 2 becomes Ace, Ace becomes King)

Lesser Summoning Circle Tarot → Applies tag, like 'Uncommon free joker in shop' 

Greater Summoning Circle Tarot → Applies tag, like 'Rare free joker in shop' 


### Additional todo 

* Come up with overall mod name
* setup standalone github project
* enable issues
* create Releases pipeline for ease of use

## End Game Fun Improvements
I want to workshop some Ideas for long term viability, i.e. most of the power in decks comes from same-same builds like Mime and Baron

### Sources of end game viabulity today
- Mime - retrigger all cards in hand
- Baron - steel like trigger for all kings held in hand
- Planetary cards apply steel like mult with certain legendary
- Dusk - retrigger all cards on final hand

### Ideas
- I'd like a one/two joker setup in my mod.  One applied a buff to a card but is ephemeral
- another low probability card rewards the buff.  Players could have fun using Death and the copy card spectral to make more, or use deck thinning.  Thought is that maybe we increase the xMult per card played with buff, OR when a card with buff is played, increase Joker xMult.  

Fickly Joker Idea for long term viability
- Fickle Joker Idea - elemental joker which changes alignment.  If only cards of alignment are played, xMult upgrades once per round.  But resets if wrong alignment played.

## General Card Concepts

### Orbital Bombardment 
- Blue seal cards apply an extra affect Joker, maybe we can name after a famous original astronomer?
- Gold seal card affect joker?  Midas?  Gold seal cards add mult = to held dollars in hand

### Fickle Fox
- - Applies gold seal to last played hand of cards?  First played hand?
- - Could be Golden Fox Effigy
- One is six chance to vanish


### Benevolant Fox God
- Follow up Joker, similar to Gros Michel and Cavendish, once fleet fox vanshes
- Gold Seal cards apply 1.5x mult
- need to implement some kind of depletion, or it's basically like turning an entire deck into quasi-glass

### Bandit loach / Racoon concepot
- - Increases level of played hand once per round.  Eats 30 chips as payment

### Space Cat / Souyuz idea 
- - Starts at $3.  Adds + chips to each card played.  Gone after six hands

### Sonar Bat
- - Reveals next card in deck

### Fickle Fennec
* Elemental joker which changes alignment from red/black.  If only cards of alignment are played, xMult upgrades once per round.  But resets if wrong alignment played.

### Reward 7's and 9's

good synergy with odd card

### Add mult when straights or flushes played
Card

### Flying Feret
* Blesses up to five played cards with a blue seal

### Eminence
* xmult for gold cards held in hand, not scored (inverse of gold cards to reward saving)

Something

Radiance

# To do 

✅ Fix crash bug on golden due to align letters

✅ see how cryptid Ship handles this interaction

...fails on retrigger. Retrigger uses old style of trigger message. Testing new copy logic

✅ copy works!

✅ golden retriever works!

✅Test Lucky Retriever - works!

✅ Fix white outline on Golden retriever DONE
✅ Fix white outline on fickle fox too DONE

For copy cards
[ ] Somehow the 'copy' affect plays before the card is scored


Image size should be 71 x 95


Fix fickle fox
- FIXED gold seals are appearing on non played cards?!?
- FIXED pops up word 'ERROR' on both blessing and vanishing
- FIXED needs to vanish more quickly
- animation happens before card is played
- needs to not appear again after first appearance

try logic like this to fix the fox.  It should iterate through the cards and have a 1 / 3 chance of blessing them.  If it blesses them say 'bless'.

Finally it should support forsaking the card

- need to find out how to add custom toasts

```lua
            for i = 1, #G.hand.cards do
				if not G.hand.cards[i].murdered_by_impostor then
					choosable_cards[#choosable_cards + 1] = G.hand.cards[i]
					if is_impostor(G.hand.cards[i]) then
						has_impostor = true
					end
				end
			end
```

### Special Thanks

- Special thanks to the official Balatro / Balatro modding discord
- Special thanks to the Extra Credit team for their fantastic documentation on Balatro and modding
- Special thanks to the Triple Click podcast for introducing me to Balatro
- Special thanks to Roffle for introducing me to the world of modded Balatro