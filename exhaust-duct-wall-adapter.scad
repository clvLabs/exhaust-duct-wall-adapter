// ----------------------------------------------
// Author: Tony Aguilar
// Date : 2021/12/05
// Description: Parametric exhaust duct wall adapter.
// Based on: https://www.thingiverse.com/thing:4690733
// ----------------------------------------------

// preview[view:south, tilt:top]

/* [General] */

// Inside diameter of the connecting exhaust duct.
DUCT_DIAMETER = 150;        // [1:500]
// Wall thickness for the generated object.
WALL_THICKNESS = 4;         // [1:10]
// Height of the generated adapter pipe.
PIPE_HEIGHT = 40;           // [5:100]
// Resolution for all circles.
CIRCLE_RESOLUTION = 100;    // [1:200]
// Add a brim?
ADD_BRIM = "yes";           // [yes, no]
// Add screw holes?
ADD_SCREW_HOLES = "yes";    // [yes, no]
// Add reinforcing ribs?
ADD_RIBS = "yes";           // [yes, no]

/* [Brims] */

// Width of the generated brim.
BRIM_WIDTH = 30;            // [1:200]

/* [Screw holes] */

// How many screw holes?
SCREW_HOLE_COUNT = 6;       // [2:100]
// Diameter of each hole.
SCREW_HOLE_DIAMETER = 6;    // [1:12]

/* [Ribs] */

// How many reinforcing ribs?
RIB_COUNT = 3;              // [2:20]
// Thickness of each rib.
RIB_THICKNESS = 2;          // [2:10]


/* [Hidden] Auto-calculated values */

/* Pipe */
PIPE_TOTAL_HEIGHT = PIPE_HEIGHT + WALL_THICKNESS;
PIPE_ID = DUCT_DIAMETER - (WALL_THICKNESS*2);
PIPE_OD = PIPE_ID + (WALL_THICKNESS*2);

/* Brim */
BRIM_ID = PIPE_OD;
BRIM_OD = BRIM_ID + (BRIM_WIDTH * 2);

/* Ribs */
RIB_LENGTH = PIPE_ID + ((PIPE_OD-PIPE_ID)/2);

/* Holes */
HOLE_HEIGHT = PIPE_TOTAL_HEIGHT * 2.5;


module _pipe() {
  translate([0,0,(PIPE_TOTAL_HEIGHT/2)])
    cylinder(h=PIPE_TOTAL_HEIGHT, d=PIPE_OD, center=true, $fn=CIRCLE_RESOLUTION);
}

module _brim() {
    translate([0,0,(WALL_THICKNESS/2)])
      cylinder(h=WALL_THICKNESS, d=BRIM_OD, center=true, $fn=CIRCLE_RESOLUTION);
}

module _main_body() {
  union () {
    _pipe();
    if (ADD_BRIM == "yes") _brim();
  }
}

module _main_body_hole() {
    cylinder(h=HOLE_HEIGHT, d=PIPE_ID, center=true, $fn=CIRCLE_RESOLUTION);
}

module _screw_holes() {
  hole_offset = (BRIM_ID / 2) + (BRIM_WIDTH / 2);
  for (i = [1:SCREW_HOLE_COUNT])
    rotate((360/SCREW_HOLE_COUNT) * i)
      translate([0,hole_offset,0])
        cylinder(h=HOLE_HEIGHT, d=SCREW_HOLE_DIAMETER, center=true, $fn=CIRCLE_RESOLUTION);
}

module _ribs() {
  for (i = [1:RIB_COUNT])
    rotate(a=[0, 0, (180/RIB_COUNT) * i])
      translate([0,0,(PIPE_TOTAL_HEIGHT/2)])
        cube(size=[RIB_LENGTH, RIB_THICKNESS, PIPE_TOTAL_HEIGHT], center=true);
}

module main() {
  union () {
    difference () {
      _main_body();
      _main_body_hole();

      if (ADD_SCREW_HOLES == "yes") _screw_holes();
    }
    if (ADD_RIBS == "yes") _ribs();
  }
}


main();
