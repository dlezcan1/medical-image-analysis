function ret = bspline2(x)

    if abs(x) < 1/2
        ret = 3/4 - x^2;
    elseif (1/2 <= abs(x)) && (abs(x) < 3/2)
        ret = 1/2 * (3/2 - abs(x))^2;
    else
        ret = 0;
    end
end