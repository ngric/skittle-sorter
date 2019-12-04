// bottom part of the tube
// contains: skittle feeder, sensor trap door, 

$fn = 200;

difference(){
    tubeBot();
    rotate([0,0,180])translate([-((sensorLength+1)/2),19.75,22])cube([sensorLength+1,sesnorThickness,sensorLength+1]);
}
rotate([0,0,180])latch();
tubeConnector();

tubeHeight = 50;
tubeDiamete = 40;
//sensor dimension
sensorLength = 21;
sesnorThickness = 3;

module tubeBot(){
    difference(){
        tubeCylinder();
        tubeCavity();
        cylinder(d=6,h=4.5,center=true); // motor hole
        translate([0,0,10])rotate([90,0,180])cylinder(d=15,h=30); //skittle sorter hole
    }
}


module latch(){
    translate([0,23,46])cube([5,5,2],true);
    translate([0,23.5,44])cube([5,2,6],true);
    translate([0,23,20])cube([5,5,2],true);
    translate([0,23.5,22])cube([5,2,6],true);
}

module tubeCylinder(){
    cylinder(d=tubeDiamete+4, h = tubeHeight); //tube cylinder
}
module tubeCavity(){
      translate([0,0,2]) cylinder(d=tubeDiamete, h = tubeHeight); //tube cavity 
}


module tubeConnector(){
    translate([0,0,tubeHeight-5])difference(){
        cylinder(d=48,h=15);
        translate([0,0,1])cylinder(d=45,h=15);
        translate([0,0,-1])cylinder(d=41,h=3);
    }
    
}