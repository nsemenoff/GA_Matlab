function D = compute_distance_matrix(cities)
%COMPUTE_DISTANCE_MATRIX Euclidean distance matrix for cities (n x 2)
    n = size(cities,1);
    D = zeros(n);
    for i = 1:n
        for j = i+1:n
            dx = cities(i,1) - cities(j,1);
            dy = cities(i,2) - cities(j,2);
            dij = hypot(dx, dy);
            D(i,j) = dij;
            D(j,i) = dij;
        end
    end
end 