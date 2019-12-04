//Tube Stand
//Holds the tube at 10 degree angle up
$fn = 100;

//tube dimension
TubeDiameter = 44;
TubeLength = 232;

holder1();
translate([-200,0,0])holder2();


//Holder diemensions
holderL = 20;
holderW = TubeDiameter+8;
holderH = 50;


module tube(){
    translate([7,0,40])rotate([0,80,0])cylinder(d=TubeDiameter+0.5,h=TubeLength);//the Tube
}


module holder1(){
        difference(){//holder1
        translate([0,-holderW/2,0])cube([holderL,holderW,holderH]);
        tube();
        translate([0,0,40])cube([20,holderW-8,50],true);
    }
}

module holder2(){
        difference(){//holder2
        translate([TubeLength-8,-holderW/2,0])cube([holderL,holderW,holderH+20]);
        tube();
    }
}
