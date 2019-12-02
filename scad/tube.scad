include <FeederBox.scad>

feeder();




//-------------------------------------------------------

id = 40;
od = id+4;
height = 180;

include <CustomizablePrintableAuger.scad>

#tube();

module tube(id=40, shole=true, height=182) {
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

        translate([0,0,1]) // seal bottom
            cylinder(d=id, h = height); 

        /**
         * skittle hole
         */
        if (shole) {
            translate([0,20,11])
                cube([20,15,20], center = true);
        }
        
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

        /**
         * motor shaft hole
         */
        cylinder(d=6,h=4.5,center=true);
    }
}

//test_section();

module test_section() {
    difference() {
        tube(shole=false);
        cube([50,50,49], center=true);
        translate([0,0,162])
            cube([100,100,200], center=true);
        translate([0,0,55])
            difference() {
                cylinder(d=38+50, h = 50);
                cylinder(d=38+6, h = 50);      
            }
    }
}

//trap_door(od);

module trap_door(od, height = 20) {
    difference() {
        // outter curved section
        cylinder(d=od+4, h=height, center=true);
        // inner curved section
        cylinder(d=44, h = height+2, center=true);
        // cut off door from full cylinder
        translate([-85,-50,-50])
            cube([100,100,100]);
    }

    // inner seat of door
    difference() {
        intersection() {
            translate([23,0,0])
                cube([15,29,18], center = true);
                    cylinder(d=od, h=height, center=true);
            }
        cylinder(d=od-4, h=height, center=true);
    }

    // servo connection base
    difference() {
        union() {
            translate([10,-20,1.5])
                cube([20,30,3.8], center=true);
            translate([-.1,-30,-.4])
                cylinder(h=3.8, d=10);
        }
        cylinder(d=od+4, h=height, center=true);
        translate([0,-30,3.5]) rotate([180,0,0]) scale([1.05,1.05,1.05])
            servo_horn();
    }
}


/**
 * single-section horn for blue servo
 */
module servo_horn() {
    cylinder(h=3.8, d = 7);
    translate([14,0,0])
        cylinder(h=1.3, d = 4); // tip
    linear_extrude(height = 1.4)
        //polygon(points = [[0,3.5], [0,-3.5], [14,-2], [14,2]]);
        polygon(points = [[2.3,2.65], [2.3,-2.65], [14,-2], [14,2]]);
}
//servo_horn();

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

module clip_test() {
    difference() {
        servo_rail();
        translate([-15,-20,0])
            cube([100,100,100]);
    }
}

//clip_test();