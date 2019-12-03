// color sensor holder

//sensor dimensions
sensorLength = 20.5;

//Holder dimensions
extraRoom = 1;
holderLength = sensorLength + extraRoom*2;
holderHeight = 6;
wallThickness = 4;
transparentCoverThickness = 3;


difference(){
    holder();
    cavity();
}

module holder(){
    cube([holderLength+(wallThickness*2),holderLength+(wallThickness*2),holderHeight + 2]);
}

module cavity(){
    translate([wallThickness,wallThickness,2])cube([holderLength,holderLength,holderHeight+1]);
    translate([wallThickness-1,wallThickness-1,holderHeight-transparentCoverThickness+2])cube([holderLength+2,holderLength+2,holderHeight+10]);
}