// Box Feeder Version 2
$fn=150;

BoxL = 180;
BoxW = 44;
BoxH = 40;
WallThickness = 2;

translate([0,0,40])BoxFeeder();

module BoxFeeder(){
    difference(){
        box();
        translate([WallThickness,WallThickness,WallThickness])boxCavity();
        translate([0,0,-1])skittleHole();
    }
    
}

module box(){
    cube([BoxL,BoxW,BoxH]);
}

module boxCavity(){
    cube([BoxL-WallThickness*2,BoxW-WallThickness*2,BoxH]);
}


module skittleHole(){
    holeCenterHeight = 11;    
    translate([holeCenterHeight,BoxW/2,0])cylinder(d=17,h=5);
    
}

//---------------------------------code for the entire Tube-----------------------------------//

difference(){
    translate([0,0,-23])cube([220,44,23]);
    translate([54.5,22,-24])rotate([0,90,0])rotate([0,0,90])entireTube();
}


module entireTube(){
    id = 40;    //inner diameter
od = id+4;  //outter diameter
height = 180;   //total Height
$fn = 150;

//Bottom cut off 10.5mm
distanceFromBottomToFirstServo = 14;

difference(){
    tubeTopPart();
    translate([0,0,-1])cylinder(d=od+10,h=24.5-distanceFromBottomToFirstServo+1);//cut bottom
    translate([0,-20,15.5])rotate([90,0,0])cylinder(d=3,h=3);//screw hole
    rotate([0,0,180])translate([0,-20,15.5])rotate([90,0,0])cylinder(d=3,h=3);//screw hole
    rotate([0,0,90])translate([0,-20,15.5])rotate([90,0,0])cylinder(d=3,h=3);//screw hole
    rotate([0,0,270])translate([0,-20,15.5])rotate([90,0,0])cylinder(d=3,h=3);//screw hole
}

module tubeTopPart(id=40, shole=true, height=180) {
    difference(){
        union() {
            cylinder(d=id+4, h = height);    

            translate([-3,0,-20])
                servo_rail();
            translate([-3,0,15])
                servo_rail();
            translate([-3,0,50])
                servo_rail();
            translate([-3,0,85])
                servo_rail();
        }
        translate([0,0,-1]) // seal bottom
            cylinder(d=id, h = height+2); 
        
        /**
         * trap door holes
         */
        translate([0,-20,50])
            cube([30,15,20], center = true);
        translate([0,-20,85])
            cube([30,15,20], center = true);
        translate([0,-20,120])
            cube([30,15,20], center = true);
        translate([0,-20,155])
            cube([30,15,20], center = true);
    }
}

module servo_rail() {
    translate([-21,2,52]){
        difference() {
            union() {
                //side clips
                cube([24,27,15], center=true);
                // top stop
                translate([0,7,15.5])
                    cube([22,7,2], center=true);
            }
            // hollow out clips
            cube([26,23,16], center=true); 
            // make room for wires
            translate([0,-5,-5.5])
                cube([26,23,6], center=true);
        }
        // long side snap
        translate ([.25,0,-7.5]) linear_extrude(height=15)
            polygon( points = [ [-12,11.5], [-11,11.5], [-11,10.5]]);
        // short side snap
        translate ([.25,0,-2.5]) linear_extrude(height=10)
            polygon( points = [ [-12,-11.5], [-11,-11.5], [-11,-10.5]]);
        // top snap
        translate([1,3.5,3]) rotate([-90,0,0]) linear_extrude(height=7)
            polygon( points = [ [-12,-11.5], [-11,-11.5], [-11,-10.5]]);
        // flat backing
        translate([7,0,4.25])
            cube([10,27,23.5], center=true); 
    }
}

//-----------------------------------------tube Bottom part-------------------------//
translate([0,0,-54.5])bot();
module bot(){
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
}
    
    
    
}