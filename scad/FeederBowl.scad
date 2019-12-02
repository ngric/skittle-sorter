//Feeder
$fn = 100;
//Skittle dimensions
DiameterOfSkittle = 13;
ThicknessOfSkittle = 9;

//Feeder dimensions
wallThickness = 2;
//bowl dimensions
topDiameter = 100;
botDiameter = DiameterOfSkittle + 2;
bowlHeight = 60;
//tube dimensions
tubeHeight = ThicknessOfSkittle*2;

difference(){
    union(){
        bowl();
        tube();
    }
    cavity();
}

module bowl(){
    difference(){    
        cylinder(d1=botDiameter,d2=topDiameter,h=bowlHeight);
        translate([0,0,wallThickness]) cylinder(d1=botDiameter,d2=topDiameter,h=bowlHeight);
    }
}


module tube(){
    translate([0,0,-tubeHeight])cylinder(d=botDiameter+wallThickness,h=tubeHeight+2);  
}

module cavity(){
    cylinder(d=DiameterOfSkittle+2,h=100,center=true);
}