module right_triangle(width, height, center=false)
{
    if (center)
    {
        polygon([
            [-width/2, -height/2],
            [width/2, -height/2],
            [width/2, height/2]
        ]);
    }
    else
    {
        polygon([
            [0, 0],
            [width, 0],
            [0, height]
        ]);
    }
}

module isoscelese_triangle(width, height, center=false)
{
    if (center)
    {
        polygon([
            [-width/2, -height/2],
            [0, height/2],
            [width/2, -height/2]
        ]);
    }
    else
    {
        polygon([
            [0, 0],
            [width, 0],
            [width/2, height]
        ]);
    }
}
