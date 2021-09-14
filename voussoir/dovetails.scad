ZFIGHT = 0.001;

module dovetails(dovetail_width, dovetail_height, count, clearance)
{
    centering = ((count-1) * dovetail_width / 2);
    for (index=[0:count-1])
    {
        x_off = (index * dovetail_width) - centering;
        translate([x_off, 0])
        intersection()
        {
            trapezoid(
                upper_width=(dovetail_width * 2 / 3 - clearance),
                lower_width=(dovetail_width * 1 / 3 - clearance),
                height=dovetail_height
            );

            // Masks off the clearance from the top side.
            translate([0, -clearance/2])
            square([dovetail_width, dovetail_height - clearance], center=true);
        }
    }
}

module dovetail_block(block_width, block_height, dovetail_width, dovetail_height, clearance=0)
{
    module mask()
    {
        square([block_width, block_height], center=true);
    }
    module main_block()
    {
        w = block_width;
        h = block_height - (2 * dovetail_height);
        square([w, h], center=true);
    }
    module upper_dovetails()
    {
        count = ceil(block_width / dovetail_width);
        y = (block_height - dovetail_height) / 2;
        translate([0, y - ZFIGHT])
        dovetails(dovetail_width, dovetail_height, count, clearance);
    }
    module lower_dovetails()
    {
        count = ceil(block_width / dovetail_width) + 1;
        y = (block_height - dovetail_height) / 2;
        translate([0, -(y - ZFIGHT)])
        mirror([0, 1])
        dovetails(dovetail_width, dovetail_height, count, clearance);
    }
    intersection()
    {
        union()
        {
            main_block();
            upper_dovetails();
            lower_dovetails();
        }

        mask();
    }
}

module trapezoid(upper_width, lower_width, height)
{
    x1 = upper_width / 2;
    x2 = lower_width / 2;
    y1 = height / 2;
    polygon([
        [-x1, y1],
        [x1, y1],
        [x2, -y1],
        [-x2, -y1]
    ]);
}
