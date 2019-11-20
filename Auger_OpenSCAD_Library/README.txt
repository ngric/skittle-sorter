                   .:                     :,                                          
,:::::::: ::`      :::                   :::                                          
,:::::::: ::`      :::                   :::                                          
.,,:::,,, ::`.:,   ... .. .:,     .:. ..`... ..`   ..   .:,    .. ::  .::,     .:,`   
   ,::    :::::::  ::, :::::::  `:::::::.,:: :::  ::: .::::::  ::::: ::::::  .::::::  
   ,::    :::::::: ::, :::::::: ::::::::.,:: :::  ::: :::,:::, ::::: ::::::, :::::::: 
   ,::    :::  ::: ::, :::  :::`::.  :::.,::  ::,`::`:::   ::: :::  `::,`   :::   ::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  :::::: ::::::::: ::`   :::::: ::::::::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  .::::: ::::::::: ::`    ::::::::::::::: 
   ,::    ::.  ::: ::, ::`  ::: ::: `:::.,::   ::::  :::`  ,,, ::`  .::  :::.::.  ,,, 
   ,::    ::.  ::: ::, ::`  ::: ::::::::.,::   ::::   :::::::` ::`   ::::::: :::::::. 
   ,::    ::.  ::: ::, ::`  :::  :::::::`,::    ::.    :::::`  ::`   ::::::   :::::.  
                                ::,  ,::                               ``             
                                ::::::::                                              
                                 ::::::                                               
                                  `,,`


https://www.thingiverse.com/thing:96462
Auger OpenSCAD Library by wtgibson is licensed under the GNU - GPL license.
http://creativecommons.org/licenses/GPL/2.0/

# Summary

A library to generate a printable [auger](http://en.wikipedia.org/wiki/Auger) in one piece without required support material.  

The STLs provided are not intended for direct use, but instead show examples of what can be done with the parametric script.  

-Customize the radii, height, number of turns, and even do multiple-start augers.   
-Vary the thickness to change the tooth strength.   
-Modify the overhang angle to what your printer is capable of.   
-Choose a left- or right-handed screw   
-Library actually respects $fs, $fa and $fn  

Optionally, add a perimeter of support material - forming an [Archimedes' Screw](https://en.wikipedia.org/wiki/Archimedes%27_screw).

# Instructions

It works!  
--  
I have succesfully printed a design made with this library on an Ultimaker. An overhang angle of 20Â° works just fine.   
If you know the overhang angle your printer is capable of, use that - otherwise try 20 or maybe 30 degrees.   

Why is this thing better than the MCAD auger in scew.scad?  
--  
1. The design is smooth; a series of correctly-shaped polyhedron rather than a series of flat extruded polygons.  
2. The overhang angle is directly specified, rather than produced as a side-effect.  
3. Easy to change the strength of the flight by making it thicker  
4. Doesn't require you to mess around with creating the correct polygon to make the auger shape you desire.  

Cons:  
--  
1. The underside angle is specified as the overhang angle, but the topside angle is zero; flat. If there is a desire I can change this.  
2. There are no fillets anywhere; they would be nice-to-have but are difficult to add. (read: I don't know how to do this)  

Future considerations:  
--  
1. Variable pitch along the length  
2. Variable radius along the length  
3. Ability to change the auger's top end - whether or not it should be truncated, changing the orientation of the last piece of the flight.  
Currently the bottom is truncated, and the top is not. Truncating the top would yield an "axial" face like the bottom, compared to its current "tangential" face.  


Notes:  
--  
1. Make sure r1 > 0  
2. Overhang angle [0 < angle < 60]  
(you could go higher but then it isn't really an auger any more...)  
3. Make sure flightThickness is >= the layer thickness of your printer (0.2 on Ultimaker)  
4. Minimum support thickness >= 2 * extruded width (0.8 on Ultimaker)  
5. Turns is in complete turns. Use turns=angle/360 if needed.