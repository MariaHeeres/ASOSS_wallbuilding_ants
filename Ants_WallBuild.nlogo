patches-own[
pheromone
sim-pheromone
]

globals[
counter
patch-amount
]

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  clear-all
  set-default-shape turtles "bug"

  ask patches [ if random-float 100 < density
  [ set pcolor yellow ]
  set pheromone 0]

  create-turtles number [
    set color white
    setxy random-xcor random-ycor
    set size 4 ]
  reset-ticks
  set counter 0
end

to go
 ask turtles [ pickup-stone ]
 ask turtles [ drop-stone ]
 ask turtles [ wiggle ]
 ask turtles [ drop-pheromone ]
 ;ask turtles [ output-print [sim-pheromone] of patch-ahead 1]
 diffuse pheromone 0.1
 diffuse sim-pheromone 0.2
 ask patches[ if pheromone > 0.1 [set pheromone pheromone * 0.9]]
 ask patches[ if sim-pheromone > 0.1 [set sim-pheromone sim-pheromone * 0.98]]
 ask patches[ pheromone-colour]
 set counter counter + 1
 if pheromone-sim-stigmergy and counter >= pherotimer
  [set counter 0
    set patch-amount 0
    ask patches[ count-patches ]
    if patch-amount > 0
      [ask patches[ simulate-pheromone ]]
  ]
 tick

end

to simulate-pheromone
  if (not (pcolor = yellow)) and distancexy 0 0 > template-radius - 0.25 * template-width
    and distancexy 0 0 < template-radius + 0.25 * template-width
  [ set sim-pheromone pherosim-amount / patch-amount]
end

to count-patches
  if (not (pcolor = yellow)) and distancexy 0 0 > template-radius - 0.25 * template-width
    and distancexy 0 0 < template-radius + 0.25 * template-width
    [set patch-amount patch-amount + 1]

end

to pickup-stone
  if color != orange
  [ if [ pcolor ] of patch-ahead 1 = yellow
    [ if random-float 1 < (1 - calc-template 0 ) * (1 - calc-stone-stigmergy 0 ) * (calc-pheromone-stigmergy 0 ) * (calc-sim-pheromone-stigmergy 0 )
      [ ask patch-ahead 1 [ set pcolor black ]
        set color orange ] ] ]
end

to drop-stone
  if color = orange
  [ if (not ([ pcolor ] of patch-ahead 1 = yellow)) and not any? turtles-on patch-ahead 1
    [ if random-float 1 < calc-template 1 * calc-stone-stigmergy 1 * calc-pheromone-stigmergy 1 * calc-sim-pheromone-stigmergy 1
      [ ask patch-ahead 1 [ set pcolor yellow ]
        set color white
        rt 180 ] ] ]
end

to-report calc-template [ default ]
  ifelse template
  [ report (1 / (1 + template-width  * (distancexy 0 0 - template-radius)^(2))) ]
  [ report default ]
end

to-report calc-stone-stigmergy [ default ]
  ifelse rock-stigmergy
  [ report (count (patch-set patch-right-and-ahead 30 2 patch-left-and-ahead 30 2 patch-ahead 2) with [ pcolor = yellow ]) / 3 ]
  [ report default ]
end

to-report calc-ant-stigmergy [ default threshold]
  ifelse ant-stigmergy and (count (turtles-on neighbors) > threshold)
  [ report (1 - default) ]
  [ report default ]
end

to-report calc-pheromone-stigmergy-threshold [ default]
  if not pheromone-stigmergy
  [ report 1 ]
  ifelse ([pheromone] of patch-ahead 1) > 1
  [ report (1 - default) ]
  [ report default ]
end

to-report calc-sim-pheromone-stigmergy-threshold [ default]
  if not pheromone-sim-stigmergy
  [ report 1 ]
  ifelse ([sim-pheromone] of patch-ahead 1) > 1
  [ report (1 - default) ]
  [ report default ]
end

to-report calc-pheromone-stigmergy [ default ]
  ifelse pheromone-stigmergy
  [ ifelse ([pheromone] of patch-ahead 1) > 5
    [ report 1 - default ]
    [ report 1 - ([pheromone] of patch-ahead 1) / 5]
  ]
  [report 1]
end

to-report calc-sim-pheromone-stigmergy [ default ]
  ifelse pheromone-sim-stigmergy
  [ ifelse ([sim-pheromone] of patch-ahead 1) > (pherosim-amount / 50)
    [ report 1 - default ]
    [ report 1 - ([sim-pheromone] of patch-ahead 1) / (pherosim-amount / 50)]
  ]
  [report 1]
end

to drop-pheromone
  ask patch-here[set pheromone pheromone + pheromone-drop-concentration]
end

to pheromone-colour
  if not (pcolor = yellow)
  [ ifelse pheromone > sim-pheromone
    [set pcolor scale-color blue pheromone 0 5]
    [set pcolor scale-color red sim-pheromone 0 (pherosim-amount / 50)]
  ]
end

to wiggle
  rt random-float 90 - random-float 90
  if not (([ pcolor ] of patch-ahead 1) = yellow)
  [ fd 1 ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
584
385
-1
-1
6.0
1
10
1
1
1
0
1
1
1
-30
30
-30
30
1
1
1
ticks
30.0

BUTTON
142
10
203
43
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
6
10
67
43
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
6
49
203
82
number
number
1
300
100.0
1
1
ants
HORIZONTAL

SLIDER
6
88
203
121
density
density
0.0
100.0
15.0
1.0
1
%
HORIZONTAL

BUTTON
73
10
136
43
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
207
202
240
template-width
template-width
1
10
5.0
1
1
units
HORIZONTAL

SLIDER
7
168
203
201
template-radius
template-radius
5
25
15.0
1
1
units
HORIZONTAL

SWITCH
42
128
165
161
template
template
0
1
-1000

SWITCH
38
247
176
280
rock-stigmergy
rock-stigmergy
0
1
-1000

SLIDER
6
283
203
316
pheromone-drop-concentration
pheromone-drop-concentration
0
100
10.0
1
1
NIL
HORIZONTAL

SWITCH
35
334
169
367
ant-stigmergy
ant-stigmergy
1
1
-1000

SWITCH
64
403
241
436
pheromone-stigmergy
pheromone-stigmergy
0
1
-1000

SLIDER
119
455
291
488
pherotimer
pherotimer
1
100
1.0
1
1
NIL
HORIZONTAL

SWITCH
70
505
268
538
pheromone-sim-stigmergy
pheromone-sim-stigmergy
1
1
-1000

SLIDER
252
407
424
440
pherosim-amount
pherosim-amount
0
1000
242.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This project is inspired by the behavior of termites gathering wood chips into piles. The termites follow a set of simple rules. Each termite starts wandering randomly. If it bumps into a wood chip, it picks the chip up, and continues to wander randomly. When it bumps into another wood chip, it finds a nearby empty space and puts its wood chip down.  With these simple rules, the wood chips eventually end up in a single pile.

## HOW TO USE IT

Click the SETUP button to set up the termites (white) and wood chips (yellow). Click the GO button to start the simulation.  The termites turn orange when they are carrying a wood chip.

The NUMBER slider controls the number of termites. (Note: Changes in the NUMBER slider do not take effect until the next setup.) The DENSITY slider controls the initial density of wood chips.

## THINGS TO NOTICE

As piles of wood chips begin to form, the piles are not "protected" in any way. That is, termites sometimes take chips away from existing piles. That strategy might seem counter-productive. But if the piles were "protected", you would end up with lots of little piles, not one big one.

The final piles are roughly round.  Why is this?  What other physical situations also produce round things?

In general, the number of piles decreases with time. Why? Some piles disappear, when termites carry away all of the chips. And there is no way to start a new pile from scratch, since termites always put their wood chips near other wood chips. So the number of piles must decrease over time. (The only way a "new" pile starts is when an existing pile splits into two.)

This project is a good example of a "decentralized" strategy. There is no termite in charge, and no special pre-designated site for the piles. Each termite follows a set of simple rules, but the colony as a whole accomplishes a rather sophisticated task.

## THINGS TO TRY

Do the results change if you use just a single termite?  What if you use several thousand termites?

When there are just two piles left, which of them is most likely to "win" as the single, final pile? How often does the larger of the two piles win? If one pile has only a single wood chip, and the other pile has the rest of the wood chips, what are the chances that the first pile will win?

## EXTENDING THE MODEL

Can you extend the model to have the termites sort several colors of wood?

Plot the number of piles, or their average size, or the number of termites carrying wood chips, as the model runs.

## NETLOGO FEATURES

Notice that the wood chips do not exist as objects. They are just represented as colors in the patches. The termites update the patch colors as they pick up and put down the wood chips. In effect, the patches are being used as the data structure. This strategy is useful in many NetLogo programs.

Note than when you stop the GO forever button, the termites keep moving for a little while.  This is because they are each finishing the commands in the GO procedure.  To do this, they must finish their current cycle of finding a chip, finding a pile, and then finding an empty spot near the pile.  In most models, the GO function only moves the model forward one step, but in this model, the GO function is written to advance the turtles through a full cycle of activity.  See the "Buttons" section of the Programming Guide in the User Manual for more information on turtle forever buttons.

## RELATED MODELS

Painted Desert Challenge, Shepherds, State Machine Example

## CREDITS AND REFERENCES

This model was developed at the MIT Media Lab using CM StarLogo.  See Resnick, M. (1994) "Turtles, Termites and Traffic Jams: Explorations in Massively Parallel Microworlds."  Cambridge, MA: MIT Press.  Adapted to StarLogoT, 1997, as part of the Connected Mathematics Project.  Adapted to NetLogo, 2001, as part of the Participatory Simulations Project.

To refer to this model in academic publications, please use:  Wilensky, U. (1997).  NetLogo Termites model.  http://ccl.northwestern.edu/netlogo/models/Termites.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

In other publications, please use:  Copyright 1997 Uri Wilensky.  All rights reserved.  See http://ccl.northwestern.edu/netlogo/models/Termites for terms of use.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
setup
ask turtles [ repeat 150 [ go ] ]
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="WallBuilding" repetitions="2" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <exitCondition>progress &lt; wall-radius + 3</exitCondition>
    <metric>progress</metric>
    <enumeratedValueSet variable="wall-radius">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sense-angle">
      <value value="100"/>
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wall-thickness">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density">
      <value value="10"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sense-distance">
      <value value="2"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number">
      <value value="50"/>
      <value value="100"/>
      <value value="200"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
