use <MCAD/regular_shapes.scad>
$fn=300;

motor_end();
//open_end(true);

// tube connection point
module ring() {
    difference() {
        cylinder(d=49, h=12);
        cylinder(d=45, h=10);
        cylinder(d=40, h=25, center=true);
    }
}

module motor_end() {
    difference() {
        open_end();
        //translate([-20,-30,0])
        //#cube([40,20,12]);
        rotate([0,90,90]) translate([0,0,-30])
            #cylinder(d=20, h=20);
    }
    difference() {
        translate([20,-13,12])
            cube([12,26,33]);
        #translate([25,7.85,23.25]) rotate([0,90,0])
            cylinder(d=4,h=20, center=true);
        #translate([25,-7.85,23.25]) rotate([0,90,0])
            cylinder(d=4,h=20, center=true);
        #translate([25,7.85,37.3]) rotate([0,90,0])
            cylinder(d=4,h=20, center=true);
        #translate([25,-7.85,37.3]) rotate([0,90,0])
            cylinder(d=4,h=20, center=true);
    }
}

module open_end(stop=false) {
    ring();
    translate([23,-5,0])
        cube([5,10,12]);
    translate([28,-20,0])
        difference() {
            cube([4,40,12]);
            hex_hole();
            translate([0,26,0]) hex_hole();
        }
    if (stop) {
        difference() {
            translate([0,0,10]) cylinder(h=2, d=40);
            #translate([-25,-20,0])cube([100,20,15]);
        }
    }
}

module hex_hole() {
    rotate([0,90,0]) translate([-6,7,0]) rotate([0,0,30]) {
        hexagon_prism(2, 5);
        cylinder(d=5,h=10);
    }
}
