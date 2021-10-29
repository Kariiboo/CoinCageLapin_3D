/*
File: coin_grille_cage_lapin.scad

Description:
Coin d'assemblage de deux grilles d'une cage à lapin.

Author: Nicolas Moteau (nicolas.moteau@orange.fr)
Version: 0.0.1
Date: 2021-09-19->26

License: [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
*/

$fn = 120; // 1st print at 120.

// w=width, H=Height, h=small height, T=thickness, t=little thickness
module side_profile_1(w=12, H=8, h=4, T=1.5, t=1) { 
  square([t, h]);
  square([w, t]);
  translate([w-t-0.5, 0, 0]) square([T, H]);
}

module side_profile_2(w=12, H=8, h=4, T=1.5, t=1) { 
  square([w, t]);
  translate([w-t-0.5, 0, 0]) square([T, H]);
}

module side_part_1(L=37) {
  linear_extrude(height=L) side_profile_1();
}
module side_part_2(L=3) {
  linear_extrude(height=L) side_profile_2();
}
module clips_1() {
  cube([3, 4, 4]);
  translate([0, 4, 0]) cube([3.5, 4, 4]);
}
module prism(l, w, h) { // from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
  polyhedron(
    points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
    faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
  );
}
module clips_2() {
  translate([12-5, 0, 0]) cube([5, 4, 4]);
  translate([12-5.5, 4, 0]) cube([5.5, 1, 4]);
  translate([12-5.5, 5, 0]) rotate([-90, -90, 0]) prism(4, 2, 3);
  translate([12-3.5, 5, 0]) cube([2, 3, 4]);
}
module side_1(Length_part_1=37, Length_part_2=3) {
  difference() {
    translate([0, 0, -1]) union() {
      side_part_1(L=Length_part_1);
      translate([0, 0, -Length_part_2]) side_part_2(L=Length_part_2);
    }  
    translate([2, -1, 1]) cube(4); // square hole
    translate([3, -1, Length_part_1-10]) cube(4); // square hole
  }
  translate([0, 0, 1]) clips_1();
  translate([0, 0, Length_part_1-10]) clips_1();
  translate([0, 0, 1]) clips_2();
  translate([0, 0, Length_part_1-10]) clips_2();
}
module side_2(Length_part_1=37, Length_part_2=3) {
  difference() {
    translate([0, 0, 1]) union() {
      translate([0, 0, -Length_part_1]) side_part_1(L=Length_part_1);
      side_part_2(L=Length_part_2);
    }
    translate([3, -1, -5]) cube(4); // square hole
    translate([3, -1, -(Length_part_1 - 6)]) cube(4); // square hole
  }
  translate([0, 0, -5]) clips_1();
  translate([0, 0, -(Length_part_1-10+4)]) clips_1();
  translate([0, 0, -5]) clips_2();
  translate([0, 0, -(Length_part_1-10+4)]) clips_2();
}

module corner_profile() {
  translate([-1.5 - 7, 0, 0]) square([1.5, 8]);
  translate([-7, 0, 0]) square([7, 1]);
}
module corner() {
  translate([3.5, 3.5, 0]) rotate([0, 0, 180]) rotate_extrude(angle=90, convexity = 10)
    corner_profile();
}

module stopper_side_profile() {
  t = 0.5;
  h = 8;
  square([t, h]);
}
module stopper_side(L=4) {
  rotate([90, 0, 0]) linear_extrude(height=L) 
    stopper_side_profile(); 
}
module stopper_corner() {
  translate([5+1.5, 5+1.5, -1])
  rotate([0, 0, 180])
  rotate_extrude(angle=90, convexity = 15)
  translate([1, 1 , 0])
    stopper_side_profile();
}
module stopper() {
  translate([5, 12-1.5, 0]) stopper_side();
  translate([12-5.5, 5, 0]) rotate([0, 0, 90]) stopper_side();
  stopper_corner();
}

union() {
  rotate([90, 0, 0]) side_1();
  rotate([90, 0, 90]) side_2();
  corner();
  stopper();
}
 