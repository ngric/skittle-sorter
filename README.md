# skittle-sorter

![complete](pictures/complete.jpg)

## Schematics

Not so good schematic:

![schematic](https://github.com/ngric/skittle-sorter/blob/master/pictures/schematic.jpg)

Wired up:

![wiredauduino.jpg](https://github.com/ngric/skittle-sorter/blob/master/pictures/wiredarduino.jpg)

## Auger

The centerpiece of our design was an auger, or screw of archimedes.  The skittles were supposed to be carried down a path by the auger, and then get dropped out into thier specific bins.

We went through a couple different revisions of the auger, changing the number of flights and the amount of twist. What we settled on had thwee flights, and 1500 degrees of twist. As it was too long for us to print in one piece, we split it in half then glued them together.

![auger printing](https://github.com/ngric/skittle-sorter/blob/master/pictures/AugerImage.jpg)

## Tube

The auger was contained within a tube.

The tube was split into two parts, as well, not due to length but complexity of design. The bottom section contained a hole that skittles fell into to get sorted, and an enclosure for the color sensor. The top part of the tube had four doors that skittles of specific colors were supposed to fall through.

![doors](https://github.com/ngric/skittle-sorter/blob/master/pictures/doors.jpg)

Each door needed some guides so that it would properly seat into the tube

![augerthroughdoor](https://github.com/ngric/skittle-sorter/blob/master/pictures/augerthroughdoor.jpg)

## Color Sensor

![sensor](https://github.com/ngric/skittle-sorter/blob/master/pictures/sensorenclosure.jpg)

Our color sensor was placed at the bottom of the auger tube.
We had a lot of issues getting the sensor to read skittle color reliably. With no skittles in the chamber, we would often get readings for colors at random, regardless of how much calibration we attempted to do. Near the deadline, we found out that the sensor was starved for light, and were able to make some improvements by increasing the sensor's integration time, but we didn't get it 100% reliable. If we were to continue working on the sorter, we would likely try out different sensor chambers, and/or continue messing with the integration time, though increasing it significantly slowed down our _potential_ top sorting speed.


## Motor

The auger was powered by an encoded dc motor. Using it, we were able to count the number of steps it took for something on a specific flight of the auger to travel from the color sensor to any given door.

![motor](https://github.com/ngric/skittle-sorter/blob/master/pictures/motor.jpg)

To time it, we kept a "queue" of upcoming skittles, and the doors that should be open at any given time. Unfortunately, due to color sensing issues, we were never able to really test out the queueing.
