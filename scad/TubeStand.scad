//Tube Stand
//Holds the tube at 10 degree angle up
$fn = 100;

//tube dimension
TubeDiameter = 44;
TubeLength = 200;

TubeHolder();


//Holder diemensions
holderL = 20;
holderW = TubeDiameter+8;
holderH = 40;

module TubeHolder(){
    difference(){
        translate([0,-holderW/2,0])cube([holderL,holderW,holderH]);
        tube();
        translate([0,0,40])cube([20,holderW-8,50],true);
    }
    difference(){
        translate([TubeLength-20,-holderW/2,0])cube([holderL,holderW,holderH+20]);
        tube();
    }
}

module tube(){
    translate([7,0,30])rotate([0,80,0])cylinder(d=TubeDiameter+2,h=TubeLength);//the Tube
}