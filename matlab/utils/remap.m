function [value] = remap(input, ab, xy)
%REMAP Summary of this function goes here
%   Detailed explanation goes here

    a = ab(1);
    b = ab(2);
    x = xy(1);
    y = xy(2);

    value = (input - a) * (y - x) / (b - a) + x;

end

