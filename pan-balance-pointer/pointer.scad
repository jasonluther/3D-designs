// Length in mm
l = 64;

// Width in mm
w = 7;

// Height in mm
h = 2;

// Quantity
q = 6;

// Pointy?
p = 1; // [1:Pointy,0:Not Pointy]

module widget(l, w, h) {
  cube(size = [l, w, h]);
  if (p) {
    point_width = sqrt(w*w + w*w)/2;
    rotate([0,0,45]) cube(size = [point_width,point_width,h]);
  }    
}

for (i = [0:q-1]) {
  translate([0, i * 1.5 * w]) widget(l, w, h);
}   