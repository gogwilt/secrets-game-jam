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

# Milestone 1 Entry: Level Signalling (11/4)

Made the outline of the secret dimension visible in the main dimension.

# Milestone 2 Entry: Multiple levels and "Level 2" (11/6)

I added a level selector and a ways to switch between levels.

I also started building the first "real level." Adding some of the corridor
mechanics makes things start to feel almost fun.

I also added a pulse to the secret level, to hopefully make it more obvious that
it isn't part of the main level.

Some thoughts on this:
* "Boost ready" animation is too subtle. I'm actually imagining something
rotating around the player (like cards orbiting a path) to make it more visually
appealing and obvious.
* Easy way to reset the level would be good. I don't think we need to add a way
to "die," so that new players feel comfortably like they can progress through
the game. BUT when someone is trying to optimize a speedrun, we should give them
a quick "pause => reset level" option so they don't waste time getting out of
the hole they fell in.

# Milestone 2 Entry: Level completion, pausing, etc (11/7)

Added logic around level completion, player starting location, pause menus, win
screens, etc.

# Playtest 1 (11/7)

Playtester went through Level 1 (with tutorials as labels in the background) and
Level 2. Overall, seemed to think it was quite fun, and it reminded him of a game
called "Animal Well."

* Speed Running - He almost immediately asked for a timer, saying "what would be
  super cool would be a timer, so I can beat my time."
* Movement - Jump right/left acceleration was too low. Felt sluggish when he was
  jumping from a standing state.
* Boost - He really liked the boost mechanic, but it took a long time for him to
  understand how it worked. He didn't read the tutorial instructions about how
  to charge it up, and he never discovered that he could direct it in any
  direction. He suggested (1) using a different button for the boost and
  (2) adding a charge bar, showing that the boost is charging. He also suggested
  progressively adding the boost mechanic, and granting it at a different level,
  perhaps as an item bonus.
* Secret Parts of Levels - He suggested hiding secret parts of each level that
  are unlocked by gaining access to new abilities. Two specific examples he gave
  were: (1) adding an upwards boost, and having a path in a level that is only
  accessible once you can do the upward boost; and (2) adding a third dimension.

Based on this playtest, I want to rework movement and boost a little.
Specifically, I want to separate the buttons for boost and dimension-switching.
One idea for keeping the controls simple would be to add boost to the jump (and
remove the double-jump). If you jump when already in the air, you instead boost
in a direction. This is a mini-boost if you don't already have it charged, and
a big boost if you already have it charged.

I also want to tweak jump right/left movement, so that it doesn't feel as
sluggish if you jump from standing.

# Milestone 2 Entry: Tutorial Level (11/7)

Redid the tutorial level, because originally it was just the test level with
some labels. I created a way to show dialogue text when the player enters an
area, and made some of the parts of the level less punishing.

Some thoughts that came out of this:
* Dashable chasms need to be fully visible to the player. You can't see the other
  side right now, so it's a leap of faith. Maybe we can have the camera skew
  towards the forward direction for a player?
* Movement still feels janky.
* Collectibles hidden around the level would be good, especially to motivate the
  player to move forward in the level, and to give you a reward at the end.

Edit: fixed the camera, and a few bugs.

# Planning: What Next?

* Movement - let's rethink dash/boost.
* Concept Art - let's sketch what things might look like, especially the player.
* More Playtest - can we get advice on improving movement?
* Art
* Dialogue/Story
* Additional Levels
* Collectible Items
* Sound Design
* Time trials
* Leaderboard

# Milestone 3 Entry: Player Art (11/10)

We're using PixelLab, an Aseprite plugin, to generate our sprites, and it's
working fairly well. We generated a cool-looking character, and then rotated him
and animated him running and jumping. The default skeletons are OK, but it's
very easy to pose the skeletons, and then generate from there.

We also updated the boost mechanic, so that it's on a separate button from
dimension-switching. The player can now boost whenever they want, but they'll
get a big boost when their dimension boost is charged.

Our hope is that the art makes the player movement feel better. To that end, I
added in a few critical animations just now, including:
* Run
* Jump
* Idle

I think a few things that will make this feel a ton better are:
* Boost Animation - seeing the player strike a pose as they boost will look great.
* Fall Animation - The player has a long coat, so I think seeing it billow
behind them will be cool.
* Boost Particle Effect - make the boost look like a dash, spawning player shadow
particles behind the player.
* Charged Boost Effect - have particles rotating around the player to indicate
the charge.

# Milestone 3 Entry: Player Art Continued (11/11)

Added boost animation, and animated the long coat for the fall, run, and jump.

I'm feeling very bullish on AI-generated sprite-sheets. A couple of things I've
learned:
* Separately animate the jacket/cape. When I animated the running sequence, the
  long jacket disappeared. I think the AI generator works quite well when the
  legs and arms are well-defined. On top of that, it's easy for me as a person to
  draw those in separately. They're rather inexact, and especially for animations,
  there should be some randomness there.
* Edit the Skeleton. Editing the skeleton takes some getting used to, but it
  feels totally worthwhile! In the future, I'd love to experiment with crafting
  my own pixel art character (rather than generating one directly).
* Plan on Regenerating A Lot. The regeneration usually goes fairly well, but the
  inputs might change a lot.

# Milestone 3 Entry: Level Art (11/12)

Added parallax layer for level 2, and some geometric details. Might be getting
visually confusing.

# Milestone 3 Entry: Dialog with Dialogic (11/13)

Installed 2.0-alpha-16 of Dialogic.

Things are getting pretty scrappy, but I like where they're headed. Dialogic
makes things super easy, so I'm glad I tried it.

I've been AI generating the heck out of anime characters, and it's going OK.

# Milestone 3 Entry: Title Screen (11/16)

Went ham on the AI art with the title screen, and I'm pretty happy with it.

Logo was generated by DALL-E/ChatGPT. I deleted the background and modified it a
bit in Aseprite.

Background itself was LayerAI.

Updated the cards to use the Tarot card designs. They move fast enough, that you
can't really make them out anyway.

I may use a CC0 set of assets for the Tarot cards.

Tarot card images: https://luciellaes.itch.io/rider-waite-smith-tarot-cards-cc0

# Milestone 3 Entry: Level Select (11/17)

Updated the level select screen to look like a table with cards. Opted for the
CC0 Tarot cards listed above, since generating consistent assets felt like it
would be difficult, for very little additional gain.

# Milestone 3 Entry: Level Saving (11/20)

Added basic save state. Eventually, this could be used for tracking best level
times, but for now it just tracks whether you've completed the level.

# Milestone 3 Entry: Collectible Cards

This was *almost* easy to add. But it took me almost an hour to figure out why
the cards seemed to show correctly in the main world in level 1, and then showed
incorrectly in the main world on level 2. Turns out, the "material" needed to be
uniquified, since I was updating them directly.
