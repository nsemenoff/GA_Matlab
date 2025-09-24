% Main script: Genetic Algorithm vs Brute-force for TSP (MATLAB)

% Parameters
seed = 42;
N_GA = 12;
N_BF = 12; % keep small; factorial growth
pop = 300;
gens = 500;
px = 0.9; % crossover rate
pm = 0.2; % mutation rate
elitism = 2;

% GA run
rng(seed);
cities_ga = generate_cities(N_GA, seed);
D_ga = compute_distance_matrix(cities_ga);
config = struct('population_size', pop, 'generations', gens, ...
                'crossover_rate', px, 'mutation_rate', pm, ...
                'elitism', elitism, 'tournament_size', 5);

t_ga_start = tic;
[bestRouteGA, bestLenGA, histGA] = ga_evolve(D_ga, config);
GA_time = toc(t_ga_start);

fprintf('GA: N=%d, best=%.3f, time=%.3fs, first_gen=%.3f, last_gen=%.3f\n', ...
    N_GA, bestLenGA, GA_time, histGA(1), histGA(end));

% Brute-force run
rng(seed);
cities_bf = generate_cities(N_BF, seed);
D_bf = compute_distance_matrix(cities_bf);

t_bf_start = tic;
[bestRouteBF, bestLenBF] = bruteforce_tsp(D_bf, 1);
BF_time = toc(t_bf_start);

fprintf('Brute-force: N=%d, best=%.3f, time=%.3fs\n', N_BF, bestLenBF, BF_time); 