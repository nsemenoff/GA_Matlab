function cities = generate_cities(n, seed, width, height)
%GENERATE_CITIES Generate random cities within [0,width]x[0,height]
%   cities: n x 2 matrix of [x,y]
    if nargin < 2 || isempty(seed)
        % do not set rng
    else
        rng(seed);
    end
    if nargin < 3 || isempty(width)
        width = 1000;
    end
    if nargin < 4 || isempty(height)
        height = 1000;
    end
    cities = [rand(n,1)*width, rand(n,1)*height];
end 