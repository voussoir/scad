module cookiecutter_inset(distance)
{
    /*
    Given a 2D polygon, return a "cookie cutter" of thickness `distance` where
    the outer edge of the cookiecutter is the outer edge of the original shape.
    */
    difference()
    {
        children();
        offset(-distance) children();
    }
}

module honeycomb_tiles(outer_radius, inner_radius, x_span, y_span, center=false)
{
    /*
    Returns a tiling of 2D hexagons.

    outer_radius:
        The radius which controls the spacing between centers of hexagons.
        The "personal space" of each hex.

    inner_radius:
        The radius of each hexagon itself. Smaller values will leave bigger
        channels in between each hex.

    x_span,
    y_span:
        The dimensions of the rectangle which more or less encloses the tiles.

    center:
        The tiling will be roughly centered around the origin.
    */
    // In a densely packed tiling of circles / hexagons, the centers of two
    // diagonal circles make a triangle of x=radius, y=sqrt(3), hyp=diameter.
    // The x=radius offset is done by translating x on odd rows. The y=sqrt(3)
    // offset is done by multiplying the row by sqrt(3)/2, compressing the rows
    // to the appropriate density.
    diameter = outer_radius * 2;
    y_step = sqrt(3) / 2;
    x_count = floor(x_span / diameter);
    y_count = floor(y_span / (diameter * y_step));

    actual_x_span = (x_count + 0.5) * diameter;
    actual_y_span = y_count * y_step * diameter;

    x_translate = center==true ? (-actual_x_span / 2) : 0;
    y_translate = center==true ? (-actual_y_span / 2) : 0;
    translate([x_translate, y_translate])
    union()
    {
        for(i=[0:1:x_count], j=[0:1:y_count])
        {
            alternate_offset = (j % 2) * outer_radius;
            translate([i * diameter + alternate_offset, (j * y_step) * diameter])
            rotate([0,0,30])
            circle(inner_radius, $fn=6);
        }
    }
}

module honeycomb_mesh(outer_radius, inner_radius, x_span, y_span, center=false)
{
    /*
    Returns a 2D rectangle with hexagonal holes throughout.
    */
    difference()
    {
        square([x_span, y_span], center=center);
        // Make the tiling bigger so we're sure it fills the whole square.
        honeycomb_tiles(
            outer_radius,
            inner_radius,
            x_span+3*outer_radius,
            y_span+3*outer_radius,
            center=center
        );
    }
}

module interior_honeycomb(
    outer_radius,
    inner_radius,
    x_span,
    y_span,
    perimeter,
    rotate=0,
    center=false
)
{
    /*
    Given a 2D polygon children(), returns a 2D polygon with an internal
    honeycomb while preserving a solid perimeter.
    */
    union()
    {
        cookiecutter_inset(perimeter) children();
        intersection()
        {
            rotate([0, 0, rotate])
            honeycomb_mesh(outer_radius, inner_radius, x_span, y_span, center=center);
            children();
        }
    }
}
