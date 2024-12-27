mounting_hole_distance = 120; // center to center distance of screw
depth = 50; // total depth of the handle
thickness = 20; // total thicness of the handle
chamfer = 2; // chamfer size
screw_diameter = 4.5; // monting hole diameter
head_screw_diameter = 9; // monting hole diameter to pass screw head
screw_space_left = 22; // space left between top of the head screw and target material

length = mounting_hole_distance + thickness;

short_central_body_length = length - (thickness + ((depth - thickness) * (sqrt(2) - 1))) * 2;
echo(short_central_body_length);

long_central_body_length = short_central_body_length + (sqrt((thickness / cos(22.5))^2 - thickness^2))*2;
echo(long_central_body_length);

residual_length_space = (length-long_central_body_length)/2;

rotate([90, 0, 0]) difference() {
    union() {
        ChamferTrapeze([long_central_body_length, thickness, thickness, 22.5, 22.5], chamfer);

        translate([long_central_body_length/2 + residual_length_space / 2 - 0.001, 0, (residual_length_space*sqrt(2)/2)/sqrt(2)]) rotate([0, -45, 0]) ChamferTrapeze([(residual_length_space*sqrt(2)), thickness, thickness, 22.5, 22.5], chamfer);
        mirror([1,0,0]) translate([long_central_body_length/2+residual_length_space/2-0.001,0,(residual_length_space*sqrt(2)/2)/sqrt(2)]) rotate([0, -45, 0]) ChamferTrapeze([(residual_length_space*sqrt(2)), thickness, thickness, 22.5, 22.5], chamfer);

        translate([long_central_body_length/2 + residual_length_space - 0.001, 0, residual_length_space + (depth-residual_length_space) / 2 - 0.002]) rotate([0, -90, 0]) ChamferTrapeze([depth-residual_length_space,thickness, thickness, 22.5, 0], chamfer);
        mirror([1,0,0]) translate([long_central_body_length/2 + residual_length_space - 0.001, 0, residual_length_space + (depth-residual_length_space) / 2 - 0.002]) rotate([0, -90, 0]) ChamferTrapeze([depth-residual_length_space,thickness, thickness, 22.5, 0], chamfer);
    }

    translate([long_central_body_length/2 + residual_length_space - thickness/2, 0, 0]) cylinder(depth + 2, screw_diameter/2, screw_diameter/2, false, $fn=40);
    mirror([1,0,0]) translate([long_central_body_length/2 + residual_length_space - thickness/2, 0, 0]) cylinder(depth + 2, screw_diameter/2, screw_diameter/2, false, $fn=40);

    translate([long_central_body_length/2 + residual_length_space - thickness/2, 0, 0]) cylinder(depth - screw_space_left, head_screw_diameter/2, head_screw_diameter/2, false, $fn=40);
    mirror([1,0,0]) translate([long_central_body_length/2 + residual_length_space - thickness/2, 0, 0]) cylinder(depth - screw_space_left, head_screw_diameter/2, head_screw_diameter/2, false, $fn=40);

    translate([long_central_body_length/2 + residual_length_space - thickness/2, 0, depth-screw_space_left]) cylinder(h=head_screw_diameter/2, r1=head_screw_diameter/2, r2=0, center=false, $fn=40);
    mirror([1,0,0]) translate([long_central_body_length/2 + residual_length_space - thickness/2, 0, depth-screw_space_left]) cylinder(h=head_screw_diameter/2, r1=head_screw_diameter/2, r2=0, center=false, $fn=40);
}


module ChamferTrapeze(size, chamferSize){
    c = (size[2]/cos(size[3]));
    a = sqrt(c^2 - size[2]^2);

    d = (size[2]/cos(size[4]));
    b = sqrt(d^2 - size[2]^2);

    CubePoints = [
        [ -size[0]/2, -size[1]/2, 0 ],  //0
        [ size[0]/2, -size[1]/2, 0 ],  //1
        [ size[0]/2,  size[1]/2,  0 ],  //2
        [ -size[0]/2,  size[1]/2,  0 ],  //3
        [ -size[0]/2 + a, -size[1]/2, size[2]],  //4
        [ size[0]/2 - b, -size[1]/2, size[2]],  //5
        [ size[0]/2 - b, size[1]/2, size[2]],  //6
        [  -size[0]/2 + a, size[1]/2, size[2]]]; //7

    CubeFaces = [
        [0,1,2,3],  // bottom
        [4,5,1,0],  // front
        [7,6,5,4],  // top
        [5,6,2,1],  // right
        [6,7,3,2],  // back
        [7,4,0,3]]; // left

    chamferCLength = sqrt(chamferSize * chamferSize * 2);

    difference() {
        polyhedron(CubePoints, CubeFaces);

        translate([0, size[1]/2, size[1]])
        rotate([45, 0, 0])
        cube([size[0], chamferCLength, chamferCLength], true);

        translate([0, -size[1]/2, size[1]])
        rotate([45, 0, 0])
        cube([size[0], chamferCLength, chamferCLength], true);

        translate([0, size[1]/2, 0])
        rotate([45, 0, 0])
        cube([size[0], chamferCLength, chamferCLength], true);

        translate([0, -size[1]/2, 0])
        rotate([45, 0, 0])
        cube([size[0], chamferCLength, chamferCLength], true);
    }
}