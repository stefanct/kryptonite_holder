include <utils/transformations.scad>

hbar_d=10;
hbar_h=150;
hbar_ext_h=90;
hbar_ext_angle=90-35;
vbar_d=8;
vbar_h=250;

module bike() {
  hbar_ext_h=30;
  // horizontal extension
  color("gold")
    rotate([90, 90, 90])
      t([0, 0, (hbar_h+hbar_ext_h)/2])
        cylinder(d=hbar_d, h=hbar_ext_h, center=true);

  color("silver") {
    // horizontal
    rotate([90, 90, 90])
      cylinder(d=hbar_d, h=hbar_h, center=true);

    // back horizontal (angled)
    t([-hbar_h/2, 0, 0])
      r([0, -hbar_ext_angle, 0])
        cylinder(d=hbar_d, h=hbar_ext_h);

    // back
    rotate([-10, 0, 0])
      translate([-hbar_h/2, 35, 0])
        rotate([0, -20, 0])
          translate([0, 0, -vbar_h])
            cylinder(d=vbar_d, h=vbar_h);

    // front
    rotate([-5, 0, 0])
      translate([hbar_h/2, 12, 0])
        rotate([0, 8, 0])
          translate([0, 2, -vbar_h])
            cylinder(d=vbar_d, h=vbar_h);
  }
}

// FIXME: requires OpenSCAD 2019.5+
// if (is_undef($parent_modules))
  // bike();
