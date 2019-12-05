// bottom part of the tube
// contains: skittle feeder, sensor trap door, 

$fn = 150;

screwDiameter = 3;


difference(){
    tubeBot();
    translate([0,0,14.5])rotate([0,0,180])translate([-((sensorLength+1)/2),19.8,22])cube([sensorLength+1,sesnorThickness,sensorLength+1.5]); //sensor hole
}
translate([0,0,15])rotate([0,0,180])latch();
tubeConnector();

tubeHeight = 65;
tubeDiamete = 40;
//sensor dimension
sensorLength = 21;
sesnorThickness = 3;

module tubeBot(){
    difference(){
        tubeCylinder();
        tubeCavity();
        cylinder(d=6,h=4.5,center=true); // motor hole
        translate([0,0,11])rotate([90,0,180])cylinder(d=17,h=30); //skittle sorter hole d= 17mm
    }
}


module latch(){
    translate([-sensorLength/2,25.2,44])rotate([90,0,0])cube([sensorLength+2,2,5]);//top horizontal bar
    translate([-sensorLength/2+3,23.2,19.5])cube([sensorLength-2,2,26.5]);//middle pane
    translate([-sensorLength/2,25.2,19.5])rotate([90,0,0])cube([sensorLength+2,2,5]);//bot horizontal bar
    translate([11.5,16.7,19.5])cube([2,8.5,sensorLength+5.5]);//top 
    translate([8,18.5,19.5])cube([4,3,2]);//patch
}

module tubeCylinder(){
    cylinder(d=tubeDiamete+4, h = tubeHeight); //tube cylinder
}
module tubeCavity(){
      translate([0,0,2]) cylinder(d=tubeDiamete, h = tubeHeight); //tube cavity 
}


module tubeConnector(){
    //extend cover length = 10
    
    difference(){
        translate([0,0,tubeHeight-6])difference(){
            cylinder(d=48,h=16);
            translate([0,0,1])cylinder(d=45,h=16);
            translate([0,0,-1])cylinder(d=41,h=3);
        }
        translate([0,0,tubeHeight+5])rotate([90,0,0])cylinder(d=3,h=50,center = true);//screw hole
        rotate([0,0,90])translate([0,0,tubeHeight+5])rotate([90,0,0])cylinder(d=3,h=50,center = true);//screw hole  
    }
   
}