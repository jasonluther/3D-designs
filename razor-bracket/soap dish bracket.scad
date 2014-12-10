// bracket for a square towel rack
// used to attach a plate from a broken soap dish

$fn=200;
bracket_thickness = 5;
bracket_width = 10;

towel_rack_width = 21.3;
towel_rack_length = 60;

hanger_radius = 12.5;

offset = sqrt(pow(towel_rack_width, 2)/2);
bracket_offset = sqrt(pow(bracket_thickness, 2)/2);

module towel_rack() {
  color("Brown") rotate(a=45, v=[1,0,0]) 
    cube([towel_rack_length, towel_rack_width, towel_rack_width], center=true);
}

module rounded_edge() {
  translate([
    -bracket_width/2, 
    -towel_rack_width-(hanger_radius-bracket_thickness)-bracket_offset, 
    offset/2
  ]) 
    rotate(a=90, v=[0,1,0]) 
      cylinder(h=bracket_width, r=bracket_thickness/1.5);    
}

module bracket() {
  difference() {
    rotate(a=45, v=[1,0,0]) 
      cube([bracket_width, towel_rack_width+bracket_thickness, towel_rack_width+bracket_thickness], center=true);
    translate([0, -2, -12]) towel_rack();
    //translate([0, -5, -7]) towel_rack();
  }
}

module the_bracket() {
  difference() {
    union() {
      bracket();
      holder();
    }
    towel_rack();
    soapdish_cutout();
  }
}
//translate([0, 0, bracket_width/2]) rotate(a=90, v=[0,1,0]) 
the_bracket();

module cutout() {
  translate([0, -offset*2, -towel_rack_width/3]) cylinder(h=towel_rack_width, r=12.5);
  translate([0, -offset*2-12.5, 0]) cube([25, 25, 25], center=true);
}

holder_length = 78;
holder_width = 5;
plate_length = 73;
plate_height = 1.5;
holder_height = 15;
cutout_length = plate_length - 5;
support_size = 15;
more_height = 1;
module soapdish_cutout() {
translate([-bracket_width/2-1,-plate_length/2,holder_height+holder_width/2-plate_height/2+more_height]) 
      cube([bracket_width+2,plate_length,plate_height]);
}
module holder() {
  difference() {
    union() {
      translate([-bracket_width/2,-holder_length/2,holder_height+more_height]) 
        cube([bracket_width,holder_length,holder_width]);
      translate([-bracket_width/2,-support_size/2,holder_height-holder_width+more_height]) 
        cube([bracket_width,support_size,holder_width]);
    }
    soapdish_cutout();
    translate([-bracket_width/2-1,-cutout_length/2,holder_height+holder_width/2-plate_height/2+more_height]) 
      cube([bracket_width+2,cutout_length,holder_width]);
  }
}
