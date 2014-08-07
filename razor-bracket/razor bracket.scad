// Razor bracket for a square towel rack

$fn=200;
bracket_thickness = 2;
bracket_width = 45;

towel_rack_width = 21.3;
towel_rack_length = 60;

hanger_radius = 12.5;

offset = sqrt(pow(towel_rack_width, 2)/2);
bracket_offset = sqrt(pow(bracket_thickness, 2)/2);

module towel_rack() {
  color("Brown") rotate(a=45, v=[1,0,0]) cube([towel_rack_length, towel_rack_width, towel_rack_width], center=true);
}

module rounded_edge() {
  translate([-bracket_width/2, -towel_rack_width-(hanger_radius-bracket_thickness)-bracket_offset, offset/2]) 
    rotate(a=90, v=[0,1,0]) 
      cylinder(h=bracket_width, r=bracket_thickness/1.5);    
}

module bracket() {
  difference() {
    rotate(a=45, v=[1,0,0]) 
      cube([bracket_width, towel_rack_width+bracket_thickness, towel_rack_width+bracket_thickness], center=true);
    translate([0, -5, -7]) towel_rack();
  }

  difference() {
    translate([-bracket_width/2, -towel_rack_width-bracket_offset/2, towel_rack_width/2]) 
      rotate(a=90, v=[0,1,0]) 
        cylinder(h=bracket_width, r=hanger_radius);    
    translate([
        -(bracket_width+bracket_thickness)/2, 
        -towel_rack_width-bracket_offset/2, 
        towel_rack_width/2
      ]) rotate(a=90, v=[0,1,0]) 
        cylinder(h=bracket_width+bracket_thickness, r=hanger_radius-bracket_thickness/2);
    translate([0, -offset, offset+bracket_offset]) towel_rack();
    translate([0, -towel_rack_width, towel_rack_width]) towel_rack();
    translate([0, -towel_rack_width*(1.7), towel_rack_width]) towel_rack();
  }
}

module the_bracket() {
  difference() {
    rounded_edge();
    cutout();
  }
  difference() {
    bracket();
    towel_rack();
    cutout();
  }
}
translate([0, 0, bracket_width/2]) rotate(a=90, v=[0,1,0]) 
the_bracket();

module cutout() {
  translate([0, -offset*2, -towel_rack_width/3]) cylinder(h=towel_rack_width, r=12.5);
  translate([0, -offset*2-12.5, 0]) cube([25, 25, 25], center=true);
}

