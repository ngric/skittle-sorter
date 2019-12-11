// Skittle Box

trapDoor = 26;
boxWidth = 40;
boxHeight = 100;
wall = 2;

difference(){
    box();
    boxCavity(); 
}

module box(){
    cube([trapDoor+wall*2,boxWidth+wall*2,boxHeight+wall]);
}

module boxCavity(){
    translate([wall,wall,wall])cube([trapDoor,boxWidth,boxHeight+1]);
}