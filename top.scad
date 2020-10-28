include <utils/tolerance_calc.scad>
include <utils/transformations.scad>
include <utils/BOSL/shapes.scad>
include <utils/BOSL/constants.scad>
include <bike.scad>
include <kryptonite.scad>

$fn=50;
// $fn=20;

top_l=kryptonite_w-38;
top_h=kryptonite_base_d+12;
top_w=kryptonite_base_d+12;

bike_off_y=kryptonite_cover_d/2+10;

top_chamfer=10;
top_cut=7;

tie_w=8;
tie_h=2;
tie_off = (top_l/2) - 23;

// test();
// test2();
// environment();
top();
// reinforcement_infill();

module top () {
  d() {
    u() {
      hull() {
        base();
        mount();
      }
      strut();
    }
    t([0, 0, top_h-top_cut])
      cube([top_l, top_w, top_h], center=true);
    clearances();
  }
}

module base () {
  t([kryptonite_base_cap_h/2, 0, 0])
    cuboid([top_l, top_w, top_h], chamfer=top_chamfer);
}

module tie_translation () {
  tr([kryptonite_base_cap_h/2+5, bike_off_y, 0], [0, 0, 90])
    children();
}
module tie_center_off() {
  t([0, +8, 0])
    children();
}

module tie_reinforcement (off) {
  l=hbar_d+15;
  w=tie_w*2.5;
  tr([0, w/2+off, 0], [90, 0, 0])
    d() {
      cylinder(d=l, h=w);
      rt([-90, 0, 0], [l/2, -w/2, 0])
        cube([l, w+overlap, l], center=true);
    }
}

module reinforcement_infill () {
  tie_translation() {
    tie_center_off()
      tie_reinforcement(0);
    for (o=[-1, 1])
      tie_reinforcement(o*tie_off+3);
  }
}

module tie_channel (d, h, w, off_h=0) {
  translate([0, +w/2-off_h, 0]) // Center
    r([90, 0, 0])
      rotate_extrude(angle = 360, convexity = 2) 
        translate([d/2, 0, 0]) // Move to "orbit"
          square([h, w]);
}

module clearances_zip_ties () {
  d_off=4;
  tie_translation() {
    tie_center_off()
      tie_channel(d=hbar_d+d_off, w=tie_w, h=tie_h);
    for (o=[-tie_off, tie_off]) {
      tie_channel(d=hbar_d+d_off, w=tie_w, h=tie_h, off_h=o-3);
    }
  }
}

module clearances_velcro () {
  velcro_w=22;
  velcro_h=2;

  velcro_span=kryptonite_cover_d+(top_w - kryptonite_cover_d);

  mount_off_x=26;
  // hack required if the inner velcro clearance intersects with the bike's bar
  mount_off_y=0;
    
  // top
  velcro_arc_r=3;
  d() {
    t([mount_off_x, 0, top_h-top_cut-velcro_arc_r])
      cube([velcro_w, velcro_span, top_h], center=true);
    t([mount_off_x, -mount_off_y/2, top_h/2-velcro_arc_r-top_cut])
      cuboid([velcro_w, velcro_span-2*velcro_h-mount_off_y, 2*velcro_arc_r], fillet=velcro_arc_r, edges=EDGE_TOP_BK+EDGE_TOP_FR);
  }
  // outside
  t([mount_off_x, -(velcro_span/2-velcro_h/2), 0])
    cube([velcro_w, velcro_h+overlap, top_h], center=true);
  // inside
  t([mount_off_x, +(velcro_span/2-velcro_h/2)-mount_off_y, 0])
    cube([velcro_w, velcro_h, top_h], center=true);
}

module mount () {
  mount_w=2*hbar_d;
  t([kryptonite_base_cap_h/2, top_w/2, 0])
    cuboid([top_l-2*top_chamfer, mount_w, mount_w], chamfer=mount_w/2);
}

module strut_base() {
  base_l=top_chamfer*2;
  base_bottom=5;
  t([-base_l/2+top_l/2+kryptonite_base_cap_h/2-base_bottom/2, top_w/2-base_l/2, -top_h/2+base_l/2])
    cuboid([base_l+base_bottom, base_l, base_l], chamfer=base_l/2);
}

module strut() {
  i() {
    hull() {
      strut_base();
      t([-5, bike_off_y, 0])
        rotate([-5, 0, 0])
          translate([hbar_h/2, 12, 0])
            rotate([0, 8, 0])
              translate([0, 2, -22]) {
                d() {
                  strut_cyl_h=10;
                  cylinder(d=vbar_d, h=strut_cyl_h);
                  rt([0, 0, -15],
                     [0, hbar_d-2, strut_cyl_h*1.5/2])
                    cube([hbar_d*2, hbar_d*2, strut_cyl_h*1.5], center=true);
                }
              }
    }
    // hack to make bottom smooth
    hack_off = 25;
    t([kryptonite_base_cap_h/2+5, hack_off/2, 0])
      cuboid([top_l+10, top_w+hack_off, top_h]);
  }
}

module environment() {
  t([-5, bike_off_y, 0]) {
    bike();
  }

  rt([0, 0, 0],
     [0, 0, 0]) {
    kryptonite();
  }
}

module clearances_kryptonite () {
  linear_extrude(50)
    projection()
      kryptonite_base();

  kryptonite_u_bars();
  kryptonite_base();

  tr([0, -50, top_h],[-90, 0, 0])
    linear_extrude(50)
      projection()
        r([90, 0, 0])
          kryptonite_u_bars();

  // cut away a small corner near the stud
  tr([kryptonite_w/2-kryptonite_base_h-kryptonite_cover_h/2+20, 0, top_h/2],
     [0, 0, 0])
    cube([kryptonite_cover_h, kryptonite_cover_d, 20], center=true);

}

module clearances () {
  clearances_kryptonite();
  clearances_velcro();
  clearances_zip_ties();
  environment();
}


module test2 () {
  // Strut area
    i() {
      top();
      t([60, 25, -10])
        cube([25, 30, 27], center=true);
    }
}

module test () {
  // Right bar entry
  t([0,0,top_h/2])
    i() {
      top();
      t([62.5, 2, -18])
        cube([30, 20, 11], center=true);
    }

  // Left side
  t([40, -top_w/4, 0])
    i() {
      top();
      t([-kryptonite_w/2, 0, 4/2])
        cube([21, top_w, 4], center=true);
    }

  // Kryptonite base circumference
  d() {
    linear_extrude(4)
      projection(cut=true)
        top();
      t([0,-15,0])
        cube([115, 20, 10], center=true);
    }
}

