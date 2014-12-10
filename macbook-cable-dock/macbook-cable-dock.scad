macbook_height = 12.35;

magsafe_right_edge_from_end = 17.25;
magsafe_width = 17.1; // 16.09
magsafe_height = 5.30; // 4.6
magsafe_top_height = 11.47;

displayport_right_edge_from_end = 32.43;
displayport_width = 11.56; // 11.62
displayport_height = 8.40; // 7.82
displayport_top_height = 13.13;

usb_right_edge_from_end = 65.39;
usb_width = 15.72; // 15.27
usb_height = 7.75; // 7.17
usb_top_height = 12.97;

depth = 10;
extra_width = 3;
extra_height = 3;
height_offset = 0.3;
corner_radius = 3;
extra_cutout_height = 0.6;
module connector(width, height, top_height, right_edge_offset, depth) {
  translate([-depth, -right_edge_offset-width + width, top_height-height+extra_cutout_height/2]) 
    cube([depth, width, height+extra_cutout_height]);
}

container = [
  depth/2,
  extra_width+usb_right_edge_from_end+extra_width,
  macbook_height-height_offset+extra_height
];

//%translate([-container[0]-1,-(extra_width+usb_right_edge_from_end),height_offset]) cube(container);

module bracket() {
  translate([-container[0]-1+container[0],-(extra_width+usb_right_edge_from_end),height_offset]) 
    rotate([0,-90,0])
      rectangle_with_corners(container,corner_radius);
}
module doit() {
  difference() {
    bracket();
    connector(magsafe_width, magsafe_height, magsafe_top_height, magsafe_right_edge_from_end, depth);
    connector(displayport_width, displayport_height, displayport_top_height, displayport_right_edge_from_end, depth);
    connector(usb_width, usb_height, usb_top_height, usb_right_edge_from_end, depth);
  }
}
translate([0,0,-1]) rotate([0,90,0]) doit();

module rectangle_with_corners(size, corner_radius) {
  $fn=50;
  x = size[2];
  y = size[1];
  z = size[0];
  r = corner_radius;
  linear_extrude(height=z) hull() {
    translate([r,r,0]) circle(r=r);
    translate([x-r,r,0]) circle(r=r);
    translate([x-r,y-r,0]) circle(r=r);
    translate([r,y-r,0]) circle(r=r);
  }
}