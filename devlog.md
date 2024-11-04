# Github Game Jam 2024 - Secrets

Game Type: 2D Speed-Running Puzzle Platformer
Concept: As a detective, you must navigate the hearts of each of your suspects,
using the secret world beneath to forge hidden paths.

## Entry 1 (11/3)

The game jam's theme is "secrets," which sent me down a path of creating a puzzle
you have to solve to uncover a secret. I started to imagine a narrative, where
each puzzle would actually give you some insight into a person, and that this
might build up into solving a mystery.

Focusing on the gameplay, I initially imagined something like a puzzle box. This
led me to thinking about something like "Hitman Go" or "Monument Valley." I've
never played either, so it felt like I'd probably miss some easy wins if I went
so derivative. Monument Valley sent me down the path of a 2D Platformer with
overlapping worlds. I've been wanting to play with Shaders, Textures, and
Particle Effects, so I thought that making each world have an abstract theme
(eg. metal, stone, or forest) would be cool. And I could keep the general
gameplay similar between levels.

Now, I'm solidly on the "2D Puzzle Platformer with Overlapping Dimensions" rabbit
hole. Apparently this has been overdone in the past, and never done particularly
well, so I may be in for a world of hurt. But that's OK.

Concept 1 WAS to have the "secret dimension" showing as the background. When the
player pressed the "swap" button, that dimension would pop into the foreground.
I thought it would then be cool to have a parallex effect of the secret dimension
in the background. After coding up a quick prototype, I decided that this was
*super* confusing to look at.

Concept 2 is to have the player create a portal to the secret dimension that
expands around them. This direction is starting to feel quite a bit better,
because it's not as visually confusing what's going on. It doesn't feel
particularly fun, yet, but I'm hoping that more satisfying movement controls will
help here.

I'm planning to add a few elements to Concept 2:
1. Movement Abilities. The portal creation is visually interesting, and I think
  it could be cool to give the player an energy boost when they expand the
  portal the whole way. Then, the next time they enter the secret dimension,
  they perform a dash. I could also tie the double-jump to switching dimensions.
2. Speed Running. After the first time a player beats a level, a timer will
  appear. They'll then get points for traversing a level more quickly, and
  rewards for getting below a certain time.
3. Collectible Coins. Should be easy to hide coins in a level, so that players
  get interested in exploring the nooks and crannies of what is possible to find.
4. Secret Level. I plan on having a tutorial level (the Duchess), three regular
  levels (the three suspects), and then a secret level (the Duchess, again) that
  can only be unlocked by speed running (or maybe collecting all the
  collectibles).

But, I only have a month, so let's prioritize what I work on.

*Milestone 1: Gameplay.* I want to work on player movement and gameplay first.
Specifically:
* Player movement should accelerate, to encourage speed-running.
* Jumping should feel precise (short press makes acceleration kick in sooner).
* Power-up dash mechanic. Tap to dash in main dimension. Double-tap hold to dash
  in secret dimensions. (Press and hold will just enter secret dimension.)
* Double-jump after switching dimensions.
* Detect if player alternate dimension is blocked, and stop the switch if so.
* Level signalling - figure out how the heck to make the secret dimension show
  semi-transparently over the main level.

*Milestone 2: Level Design.* Create a few levels. Level concepts:
* Tutorial: Show player how to switch dimensions. Teach falling through grid,
  jumping up platforms, and corridor patterns.
* Level 1: Teach dash. Have gaps that need to be dashed across, then a running
  area to charge up the next gap, then a dash in the alternative dimension.
* Level 2: Teach double-jump. Also add horizontal corridor with gates between
  dimensions.

*Milestone 3: Level Selector and Art.* Make the level selector nice. Add some
narrative. Add backgrounds that make the levels feel like they're thematically
connected to the art (level selector is the duchess card, with the three suspect
cards below it).

*Milestone 4: Narrative.*

*Milestone 5: Speed Running.*

*Milestone 6: Sound Design.*


## Milestone 1 Entry: Basic Movement (11/4)

Added player movement mechanics, trying to encourage speed running. Particularly:
* Acceleration - As you move, speed increases.
* Sticky Floor - If you move the other direction, floor stops you, regardless.
* Jump Height - Hold down jump to jump higher. Tap to do a short hop.
* Ground vs Air Speed - Make air feel more floaty by reducing air acceleration.
* Top Speed - Allow top speed to be ignored.

I'll probably hold off on jump buffering and coyote time.

After dash is implemented, I'll probably want to add deceleration to top speed.

# Milestone 1 Entry: Collision Detection (11/4)

Added detector to see if switching dimensions is valid.

# Milestone 1 Entry: Dimension Boost (11/4)

Added boost. Timer for charging up the boost, and a new state for the boost
actually happening.

Obvious problems include:
* Boost from zero velocity, we need to choose a direction.
* Switching dimensions without using the boost.

I added a player current direction, so that boost from zero would head in that
direction.

I also made the boost direction controllable (and cancellable), to hopefully make
the boost feel more satisfying to use.

I don't think I can add my "tap" vs "tap-and-hold" idea, because I think it will
make the controls feel sluggish during normal gameplay.
