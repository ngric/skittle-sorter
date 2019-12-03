//Box Feeder

$fn = 10;
//Skittle dimensions
DiameterOfSkittle = 13;
ThicknessOfSkittle = 9;

//Feeder dimensions
wallThickness = 2;


feeder();

module feeder(){
    difference(){    
        box();
        cavity();
        rotate([0,10,0])translate([2,2,-18])cube([boxLength-4,boxWidth-4,boxHeight-4]);
    }
    cover();
}

//box dimension
boxLength = 180;
boxWidth = 50;
boxHeight = 50;
module box(){
    cube([boxLength,boxWidth,boxHeight]);
}

//cavity dimension
topDiameter = boxWidth;
botDiameter = boxWidth*4/5;
//hole dimension
holeDiameter = DiameterOfSkittle + 2;

module cavity(){
    //cylinder
    rotate([0,8,0])translate([0,boxWidth/2,boxHeight])rotate([0,90,0])cylinder(d1=botDiameter,d2=topDiameter,h=boxLength);
    //hole
    translate([boxLength-holeDiameter+2,boxWidth/2,-1]) cylinder(d=holeDiameter, h= 100,$fn=100
    );
    translate([5,5,35]) cube([170,40,30]);
}

module cover(){
   translate([175,0,0])cube([5,boxWidth,boxHeight]);
}