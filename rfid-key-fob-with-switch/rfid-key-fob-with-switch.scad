$fn=100;
// Antenna Space
// Suspended in the middle of the case
// define shell around it
// Make a cutout as well

// Switch space
// Suspended in the middle of the case
// Easy to relocate, so define the shell around it that holds it

// Case
// exterior walls, not solid with cutouts
// push fit pins

// Generic: part, part holder
antenna_diameter = 24;
antenna_height = 2.1;
switch_height = 4.05;
switch_width = 12; //11.7

case_z_thickness = 0.3; // depends on layer thickness
case_xy_thickness = 0.4*2; // depends on nozzle
case_height = switch_height + case_z_thickness * 2;

top_bottom_x_offset = 0;
top_bottom_y_offset = 20;

module antenna_part() {
  translate([0,0,case_height/2-antenna_height/2]) 
    union() {
      color("Gold") cylinder(d=antenna_diameter,h=antenna_height);
      translate([0,-switch_width/2,0]) cube([antenna_diameter,switch_width,antenna_height]);
    }
}
module antenna_enclosure_shell() {
  translate([0,0,0]) 
    color("Gold") 
      cylinder(d=antenna_diameter+case_xy_thickness*2,h=case_height);
      //cylinder(d=antenna_diameter+case_xy_thickness*2,h=antenna_height+2*case_z_thickness);
}

module antenna() {
  difference() {
    antenna_enclosure_shell();
    antenna_part();
  }
}
//antenna();

extra_layers = 0.5;
module case_cutout_for_bottom() {
  translate([-50,-50,case_height/2+case_z_thickness*extra_layers]) cube([100,100,case_height]);
}
module case_cutout_for_top() {
  translate([-50,-50,-case_height/2-case_z_thickness*extra_layers]) cube([100,100,case_height]);
}

switch_w = switch_width;
switch_d = 5.1;
switch_tab_d = 1.3;
switch_depth = switch_d + switch_tab_d;
switch_connector_depth = 5.6;
switch_full_depth = switch_d + switch_connector_depth;
switch_h = switch_height;
switch_x_offset = 21;
switch_tab_width = 2; // 1.4
module switch_unit() {
  x= switch_d;
  y = switch_w;
  z = switch_h;
  color("DimGray") cube([x,y,z]);
  sx = 2;
  sy = 5;
  sz = 2.1;
  translate([x,y/2-sy/2,z/2-sz/2]) color("Black") cube([sx,sy,sz]);
  wx = switch_connector_depth+0.5;
  wy = 6;
  wz = 0.75;
  translate([-wx,y/2-wy/2,z/2-wz/2]) color("LightSlateGray") cube([wx,wy,wz]);
  lx = switch_tab_d;
  ly = switch_tab_width;
  lz = z;
  translate([-lx,0,0]) color("DimGray") cube([lx,ly,lz]);  
  translate([-lx,y-ly,0]) color("DimGray") cube([lx,ly,lz]);  
}
module switch_part() {
  translate([case_xy_thickness+switch_tab_d,case_xy_thickness,case_z_thickness]) switch_unit();
}
module switch_enclosure_shell() {
  translate([-switch_connector_depth+2.5*case_xy_thickness,0,0])
    cube([switch_full_depth+1.5*case_xy_thickness-case_xy_thickness, switch_width + 2*case_xy_thickness, case_height]);
}
module switch() {
  translate([switch_x_offset,0,0])
  translate([-(switch_depth+2*case_xy_thickness)/2,-(switch_width + 2*case_xy_thickness)/2,0]) 
  difference() {
    switch_enclosure_shell();
    switch_part();
  }
}

// keyring holder
ring_holder_diameter = 15;
ring_holder_width = 5;
module ring_holder() {
  difference() {
    translate([-antenna_diameter/2,0,0])
      difference() {
        cylinder(d=ring_holder_diameter, h=case_height);
        cylinder(d=ring_holder_diameter-ring_holder_width, h=case_height);
    }
    cylinder(d=antenna_diameter, h=case_height);
  }
}

snap_r = case_xy_thickness;
clearance_layers = 0.25; 
collar_height = case_height/2+0.5*case_z_thickness;
pin_height = case_height-2*case_z_thickness;
module snap_m() {
  cylinder(d=2*snap_r*2, h=collar_height, $fn=100);
  cylinder(d=2*snap_r, h=pin_height, $fn=100);
}
module snap_f() {
  difference() {
    cylinder(d=2*snap_r*2, h=collar_height, $fn=100);
    translate([0,0,case_z_thickness]) cylinder(d=2*snap_r+clearance_layers*case_xy_thickness, h=case_height, $fn=100);
  }
}
//snap_m();
//translate([4,0,0]) snap_f();


module all() {
    union() {
      antenna();
      switch();
      switch_case();
      ring_holder();
    }
}

function y_dist(x, r) = sqrt(r*r - x*x);
snap_x_offset = antenna_diameter/2.2;
snap_radius_offset = antenna_diameter/2+case_xy_thickness*2.25;

module bottom() {
  difference() {
    all();
    case_cutout_for_bottom();
  }
  translate([-snap_x_offset, y_dist(snap_x_offset, snap_radius_offset),0]) snap_f();
  translate([-snap_x_offset, -y_dist(snap_x_offset, snap_radius_offset),0]) snap_f();
}
translate([0,-top_bottom_y_offset,0]) bottom();

module top() {
  translate([0,0,case_height]) 
  rotate(a=180, v=[1,0,0])
    difference() {
      all();
      case_cutout_for_top();
    }
  translate([-snap_x_offset, y_dist(snap_x_offset, snap_radius_offset),0]) snap_m();
  translate([-snap_x_offset, -y_dist(snap_x_offset, snap_radius_offset),0]) snap_m();
}
translate([0,top_bottom_y_offset,0]) top();


//case
module switch_case() {
  translate([switch_x_offset-switch_full_depth+0.5*case_xy_thickness,-(switch_width+2*case_xy_thickness)/2,0]) 
    difference() {
      cube([switch_full_depth+3,switch_width+2*case_xy_thickness,case_height]);
      translate([0,case_xy_thickness,case_z_thickness]) cube([switch_full_depth+3,switch_width+2*case_xy_thickness-case_xy_thickness*2,case_height-2*case_z_thickness]);
    }
}

// snaps