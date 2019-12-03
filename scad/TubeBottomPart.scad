// bottom part of the tube
// contains: skittle feeder, sensor trap door, 

$fn = 200;

tubeBot();
difference(){
    tubeWall();
    translate([-10.5,19.8,21])cube([21,3,21]);
}
latch();

tubeHeight = 50;
tubeDiamete = 40;
//sensor dimension
sensorLength = 21;

module tubeBot(){
    difference(){
        cylinder(d=tubeDiamete+4, h = tubeHeight);
        translate([0,0,2]) cylinder(d=tubeDiamete, h = tubeHeight); //tube cavity 
        cylinder(d=6,h=4.5,center=true); // motor hole
        translate([0,0,10])rotate([90,0,0])cylinder(d=15,h=30); //skittle sorter hole
        translate([0,20,sensorLength/2+2+20])rotate([90,0,0])cube([sensorLength,sensorLength,50],true); //color sensor hole
    }
}


module tubeWall(){
    intersection(){
        translate([-10.5,15,22])cube([21,7,21]); 
            difference(){
                cylinder(d=tubeDiamete+4, h = tubeHeight);
                translate([0,0,2]) cylinder(d=tubeDiamete, h = tubeHeight); //tube cavity 
            }
    }
    
}

module latch(){
    translate([0,23,42])cube([5,2,6],true);
    translate([0,23,22])cube([5,2,6],true);
}



