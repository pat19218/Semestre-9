function bearing = get_bearing_in_degrees(tag)
    north = wb_compass_get_values(tag);
    rad = atan2(north(2), north(1));
    bearing = (rad - 1.5708) / pi * 180.0;
    if (bearing < 0.0)
        bearing = bearing + 360.0;
    end
end
