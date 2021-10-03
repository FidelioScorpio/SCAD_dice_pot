box_w = 50;
corner_curve = 1/4;
$fn = 90;

wall_thickness = 0.8;

box_height = 60;
bottom = wall_thickness*2;
top = wall_thickness*8;

module shape_2d()
{
    translate([-0.5*(box_w - (2*corner_curve*box_w)), -0.5*(box_w - (2*corner_curve*box_w)), 0]) minkowski()
    {
        square(box_w - (2*corner_curve*box_w));
        circle(corner_curve * box_w);
    }
}
module internal_shape_2d()
{
    offset(r=-wall_thickness) shape_2d();
}
module altw_shape_2d(altw)
{
    translate([-0.5*(altw - (2*corner_curve*altw)), -0.5*(altw - (2*corner_curve*altw)), 0]) minkowski()
    {
        square(altw - (2*corner_curve*altw));
        circle(corner_curve * altw);
    }
}

module hollow_shape_2d()
{
    difference()
    {
        shape_2d();
        internal_shape_2d();
    }
}

module pot()
{
    linear_extrude(height=bottom) shape_2d();
    color("orange") translate([0, 0, bottom]) linear_extrude(height=box_height-bottom-top, twist=90, $fn=360) hollow_shape_2d();
    translate([0, 0, box_height-top]) linear_extrude(height=top) hollow_shape_2d();
}
module solid_pot()
{
    linear_extrude(height=bottom) shape_2d();
    color("orange") translate([0, 0, bottom]) linear_extrude(height=box_height-bottom-top, twist=90, $fn=360) shape_2d();
    translate([0, 0, box_height-top]) linear_extrude(height=top) shape_2d();
}
module pot_lid()
{
    linear_extrude(height=top - wall_thickness) internal_shape_2d();
    translate([0, 0, top - wall_thickness]) linear_extrude(height=wall_thickness) shape_2d();
    
    //translate([0,0,top + wall_thickness]) linear_extrude(height=2*wall_thickness) altw_shape_2d(box_w/8);
    //translate([0,0,top + 3*wall_thickness]) linear_extrude(height=wall_thickness) altw_shape_2d(box_w/8 + wall_thickness);
}
module hollow_pot_lid()
{
    difference()
    {
        linear_extrude(height=top - wall_thickness) internal_shape_2d();
        translate([0,0,-wall_thickness]) linear_extrude(height=top) altw_shape_2d(box_w-2*wall_thickness);
    }
    translate([0, 0, top - wall_thickness]) linear_extrude(height=2*wall_thickness) shape_2d();
    
    //translate([0,0,top + wall_thickness]) linear_extrude(height=2*wall_thickness) altw_shape_2d(box_w/8);
    //translate([0,0,top + 3*wall_thickness]) linear_extrude(height=wall_thickness) altw_shape_2d(box_w/8 + wall_thickness);
}



if ($preview)
{
    translate([box_w*2,0,0]) 
        pot();
}
//pot_lid();

solid_pot();
//hollow_pot_lid();

