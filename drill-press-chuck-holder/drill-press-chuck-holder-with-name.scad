use <Write.scad> // http://www.thingiverse.com/thing:16193
writecylinder(label,[0,0,0],clamp_diameter/2,clamp_height,face="top",ccw=true);

$fn=100;
stand_diameter = 59.13;
clamp_addl_width = 7.5;
clamp_diameter = stand_diameter + 2 * clamp_addl_width;
clamp_height = 5;
clip_width = 10;
rack_width = 10;
rack_length = 50;
chuck_rack_diameter = 20;
chuck_rack_hole = 8;
label="LUTHER";

module clamp() {
  cylinder(d=clamp_diameter, h=clamp_height);
}
module clamp_cutout() {
  translate([0,0,-clamp_height*1/2])
    cylinder(d=stand_diameter, h=clamp_height*2);
}

module clip() {
  translate([(stand_diameter+clamp_addl_width)/2,-clip_width/2,0])
    cube([clip_width, clip_width, clamp_height]);
  translate([(stand_diameter+clamp_addl_width)/2+clip_width,-clip_width*1.5/2,0])
    cube([1, clip_width*1.5, clamp_height]);
}
module clip_cutout() {
  translate([stand_diameter/2.2, -3/2, -1]) 
    cube([stand_diameter/2,3,clip_width+2]);
}

rack_offset_x = -clamp_diameter/2-2*clamp_addl_width;
rack_cutout_offset_x = rack_offset_x + chuck_rack_diameter/4;
module rack() {
  translate([rack_offset_x,-rack_length/2,0]) 
    cube([rack_width, rack_length, clamp_height]);
}
module chuck_rack() {
  translate([rack_offset_x+chuck_rack_diameter/4,-rack_length/2,0])
    cylinder(d=chuck_rack_diameter, h=clamp_height);
}
module chuck_cutout() {
  translate([rack_cutout_offset_x,-rack_length/2,-clamp_height])
    cylinder(d=chuck_rack_hole, h=clamp_height*3);
  translate([rack_cutout_offset_x,-rack_length/2,0])
    cylinder(d2=chuck_rack_diameter*1.2, d1=chuck_rack_hole, h=clamp_height*3);
}
module wrench_cutout(d) {
  translate([rack_cutout_offset_x,0,-clamp_height])
    cylinder(d=d, h=clamp_height*3);
}
module rack_end() {
  translate([rack_cutout_offset_x,rack_length/2,0])
    cylinder(d=rack_width, h=clamp_height);
}
module rack_connector() {
  translate([rack_offset_x+rack_width,-rack_length/4,0])
    cube([rack_width,rack_length/2,clamp_height]);
}

module holder() {
  difference() {
    union() {
      clamp();
      rack();
      chuck_rack();
      rack_end();
      rack_connector();
      clip();
    }
    clamp_cutout();
    clip_cutout();
    chuck_cutout();
    translate([0,0,0]) wrench_cutout(6);
    translate([0,rack_length/2/2,0]) wrench_cutout(5);
    translate([0,rack_length/2,0]) wrench_cutout(4);
  }
}
holder();

module printrbot_simple_bed() {
translate([-13,-4,0])
  rotate(a=45, v=[0,0,1])
    translate([-50,-50,-1])
      color("Blue") cube([100,100,1]);
}
