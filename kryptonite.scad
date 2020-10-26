/*
 * Model of a Kryptonite Evolution LS (ca. 2007, ART 3315)
 */

include <utils/transformations.scad>

kryptonite_base_d=31.5;
kryptonite_base_h=160;
kryptonite_base_cap_h=5;
kryptonite_base_cap_r=50;
kryptonite_w=kryptonite_base_h+kryptonite_base_cap_h;

u_kryptonite_base_d=16;
u_kryptonite_base_dist=120;
u_kryptonite_base_len=250;

module kryptonite_base() {
  // cylinder
  color("orange")
    translate([kryptonite_base_cap_h/2-kryptonite_base_h/2, 0, 0])
      rotate([0,90,0])
        union() {
          intersection() {
            translate([0, 0, kryptonite_base_cap_r-kryptonite_base_cap_h])
              sphere(r=kryptonite_base_cap_r);
            translate([0, 0, -kryptonite_base_cap_h])
              cylinder(d=kryptonite_base_d, h=kryptonite_base_cap_h);
          }
          cylinder(d=kryptonite_base_d, h=kryptonite_base_h);
        }

  kryptonite_cover_d=36;
  kryptonite_cover_h=45;
  kryptonite_cover_off=90;

  // hole cover
  color("black")
    tr([kryptonite_base_cap_h/2-kryptonite_base_h/2+kryptonite_cover_h/2+kryptonite_cover_off, 0, 0],
       [0, 90, 0])
      cylinder(d=kryptonite_cover_d, h=kryptonite_cover_h, center=true);
}

module kryptonite_u_bars() {
  color("black")
    for(i=[-1,1]) {
      translate([kryptonite_base_cap_h/2 + i*u_kryptonite_base_dist/2, 0, -u_kryptonite_base_len])
        cylinder(d=u_kryptonite_base_d, h=u_kryptonite_base_len);
    }
}

module kryptonite_u() {
  color("black")
    union() {
      kryptonite_u_bars();
      translate([kryptonite_base_cap_h/2, 0, -u_kryptonite_base_len])
          rotate([-90,0,0])
          rotate_extrude(angle = 180)
            translate([u_kryptonite_base_dist/2, 0, 0])
              circle(d=u_kryptonite_base_d);
    }
}

module kryptonite() {
  kryptonite_u();
  kryptonite_base();
}

// FIXME: requires OpenSCAD 2019.5+
// if (is_undef($parent_modules))
  kryptonite();
