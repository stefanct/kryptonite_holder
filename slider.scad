include <utils/transformations.scad>
include <utils/threaded_inserts.scad>
include <utils/BOSL/constants.scad>
include <utils/BOSL/metric_screws.scad>

$fa=5;
$fs=0.1;

clearance_off=0.05;
clearance_alpha=0.05;

screw_size=3;
wall_thick=3;

spring_h=12;
spring_d=5;

knob_sphere_h=5;
knob_hemisphere_h=knob_sphere_h/2;
knob_disk_h = knob_hemisphere_h/2;
knob_spacer_h = wall_thick/2;
knob_h=knob_spacer_h+knob_hemisphere_h+knob_disk_h;
knob_d=15;
// screw_h=23; // FIXME: gotta buy larger ones
screw_h=knob_h+wall_thick+spring_h+get_threaded_insert_plain_h(screw_size);
echo("screw_h: ", screw_h);

function get_true_bolt_head_h(size) = (get_metric_socket_cap_diam(screw_size)-screw_size)/2;

module bolt () {
  // color("orange", 0.5)
  t([0, get_true_bolt_head_h(screw_size), 0])
    metric_bolt(
      headtype="countersunk",
      size=screw_size,
      l=screw_h-get_true_bolt_head_h(screw_size),
      // shank=0.05,
      pitch=0,
      // details=false,
      orient=ORIENT_YNEG
    );
  // Clearance for the screwdriver
  color("black", clearance_alpha)
    tr([0, 0.01, 0],
      [90, 0, 0])
      cylinder (d=get_metric_bolt_head_size(3), h=4*wall_thick);
}

module knob () {
  color("orange", 0.5) {
    d() {
      u() {
        // disk
        tr([0, knob_disk_h/2, 0],
          [-90, 0, 0])
          cylinder (d=knob_d, h=knob_disk_h, center=true);
        // hemisphere
        t([0, knob_disk_h, 0])
          d() {
            scale([knob_d/knob_sphere_h, 1, knob_d/knob_sphere_h])
              sphere (d=knob_sphere_h);
            tr([0, -knob_hemisphere_h/2, 0],
              [-90, 0, 0])
              cylinder (d=knob_d, h=knob_hemisphere_h, center=true);
          }
        // spacer (overlaps hemisphere to make contact)
        tr([0, knob_disk_h+knob_hemisphere_h/2+knob_spacer_h/2, 0],
          [-90, 0, 0])
          cylinder (d=screw_size+wall_thick, h=knob_spacer_h+knob_hemisphere_h, center=true);
        }
      bolt();
    }
  }
}

module spring () {
  color("grey", 0.5)
    tr([0, knob_h+wall_thick, 0],
       [-90, 0, 0])
      cylinder (d=spring_d, h=spring_h);
}

module threaded_insert () {
  tr([0, knob_h+wall_thick+spring_h+get_threaded_insert_plain_h(screw_size), 0],
     [90, 0, 0])
    threaded_insert_plain();
}

module wedge () {
  wedge_h=get_threaded_insert_plain_flange_d(screw_size)+wall_thick;
  wedge_w=15;
  wedge_l=wedge_h*tan(30);
  ext_l=max(get_threaded_insert_plain_h(screw_size), 2*wall_thick);
  
  color("green", 0.5)
    d() {
      t([0, knob_h+wall_thick+spring_h, 0]) {
        u() {
          // actual wedge
          tr([-wedge_w/2, get_threaded_insert_plain_h(screw_size), -wedge_h/2],
             [90, 0, 90])
            linear_extrude(wedge_w)
              polygon([[0, 0], [wedge_l, 0], [0, wedge_h]]);
          t([0, get_threaded_insert_plain_h(screw_size)-ext_l, 0]) {
            // cubic wedge extension to enclose the insert
            t([-wedge_w/2, clearance_off, -wedge_h/2])
              cube([wedge_w, ext_l-clearance_off, wedge_h]);

            // blockers
            for (i = [1, -1]) {
              t([-wedge_w/2, clearance_off, (i*wedge_h+(i-1)*wall_thick)/2])
              cube([wedge_w, wall_thick, wall_thick]);
            }
          }
        }
      }
      threaded_insert();
    }
}

module slider () {
  bolt();
  knob();
  spring();
  threaded_insert();
  wedge();
}

// FIXME: requires OpenSCAD 2019.5+
// if (is_undef($parent_modules))
  slider ();
