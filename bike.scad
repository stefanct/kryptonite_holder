hbar_d=10;
hbar_h=150;
vbar_d=8;
vbar_h=250;

module bike() {
  color("silver") {
    rotate([90, 90, 90])
      cylinder(d=hbar_d, h=hbar_h, center=true);

    rotate([-10, 0, 0])
      translate([-hbar_h/2, 35, 0])
        rotate([0, -20, 0])
          translate([0, 0, -vbar_h])
            cylinder(d=vbar_d, h=vbar_h);

    rotate([-5, 0, 0])
      translate([hbar_h/2, 15, 0])
        rotate([0, 8, 0])
          translate([0, 0, -vbar_h])
            cylinder(d=vbar_d, h=vbar_h);

  }
}

// FIXME: requires OpenSCAD 2019.5+
// if (is_undef($parent_modules))
  bike();
