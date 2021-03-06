/*
 * Model of a Kryptonite Evolution LS (ca. 2007, ART 3315)
 */

include <utils/transformations.scad>

kryptonite_d_add = 1;

kryptonite_base_d=31.75 + kryptonite_d_add;
kryptonite_cover_d=36 + kryptonite_d_add;
kryptonite_base_orange_d=31 + kryptonite_d_add;
kryptonite_base_cap_r=30;

kryptonite_base_h=24;
kryptonite_cover_h=45;
kryptonite_base_orange_h=92;
kryptonite_base_cap_h=5;
kryptonite_w=kryptonite_base_h+kryptonite_cover_h+kryptonite_base_orange_h+kryptonite_base_cap_h;

kryptonite_u_d=16 + kryptonite_d_add/2;
kryptonite_u_dist=120;
kryptonite_u_len=250;


module kryptonite_base() {
  // cylinder
  color("dimgray")
    tr([kryptonite_w/2-kryptonite_base_h/2, 0, 0],
       [0, 90, 0])
        cylinder(d=kryptonite_base_d, h=kryptonite_base_h, center=true);

  // hole cover
  color("black")
    tr([kryptonite_w/2-kryptonite_base_h-kryptonite_cover_h/2, 0, 0],
       [0, 90, 0])
      cylinder(d=kryptonite_cover_d, h=kryptonite_cover_h, center=true);

  // orange cylinder cover
  color("orange")
    tr([kryptonite_w/2-kryptonite_base_h-kryptonite_cover_h-kryptonite_base_orange_h, 0, 0],
       [0, 90, 0])
        union() {
          intersection() {
            translate([0, 0, kryptonite_base_cap_r-kryptonite_base_cap_h])
              sphere(r=kryptonite_base_cap_r);
            translate([0, 0, -kryptonite_base_cap_h])
              cylinder(d=kryptonite_base_orange_d, h=kryptonite_base_cap_h);
          }
          cylinder(d=kryptonite_base_orange_d, h=kryptonite_base_orange_h);
        }
}

module kryptonite_u_bars() {
  color("black")
    for(i=[-1,1]) {
      translate([i*kryptonite_u_dist/2+kryptonite_base_cap_h/2, 0, -kryptonite_u_len])
        cylinder(d=kryptonite_u_d, h=kryptonite_u_len);
    }
}

module kryptonite_u() {
  color("black")
    union() {
      kryptonite_u_bars();
      translate([kryptonite_base_cap_h/2, 0, -kryptonite_u_len])
          rotate([-90,0,0])
          rotate_extrude(angle = 180)
            translate([kryptonite_u_dist/2, 0, 0])
              circle(d=kryptonite_u_d);
    }
}

module kryptonite() {
  kryptonite_u();
  kryptonite_base();
}

// FIXME: requires OpenSCAD 2019.5+
// if (is_undef($parent_modules))
  // kryptonite();
