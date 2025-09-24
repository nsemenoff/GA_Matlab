function [bestRoute, bestLen, history] = ga_evolve(D, config)
%GA_EVOLVE Genetic algorithm for TSP using distance matrix D
% config fields: population_size, generations, crossover_rate, mutation_rate, elitism, tournament_size
    n = size(D,1);
    if ~isfield(config,'population_size'), config.population_size = 300; end
    if ~isfield(config,'generations'), config.generations = 500; end
    if ~isfield(config,'crossover_rate'), config.crossover_rate = 0.9; end
    if ~isfield(config,'mutation_rate'), config.mutation_rate = 0.2; end
    if ~isfield(config,'elitism'), config.elitism = 2; end
    if ~isfield(config,'tournament_size'), config.tournament_size = 5; end

    population = initialize_population(n, config.population_size);
    history = zeros(config.generations,1);

    for g = 1:config.generations
        fitness = compute_fitness(population, D);
        [fitness, idx] = sort(fitness, 'ascend');
        population = population(idx);
        history(g) = fitness(1);

        next_population = population(1:min(config.elitism, numel(population)));

        while numel(next_population) < config.population_size
            p1 = tournament_select(population, fitness, config.tournament_size);
            p2 = tournament_select(population, fitness, config.tournament_size);

            if rand < config.crossover_rate
                [c1, c2] = ordered_crossover(p1, p2);
            else
                c1 = p1; c2 = p2;
            end

            if rand < config.mutation_rate
                if rand < 0.5
                    c1 = swap_mutation(c1);
                else
                    c1 = insert_mutation(c1);
                end
            end
            if rand < config.mutation_rate
                if rand < 0.5
                    c2 = swap_mutation(c2);
                else
                    c2 = insert_mutation(c2);
                end
            end

            next_population{end+1} = c1; %#ok<AGROW>
            if numel(next_population) < config.population_size
                next_population{end+1} = c2; %#ok<AGROW>
            end
        end

        population = next_population;
    end

    fitness = compute_fitness(population, D);
    [bestLen, bestIdx] = min(fitness);
    bestRoute = population{bestIdx};
end

function population = initialize_population(n, popSize)
    base = 1:n;
    population = cell(popSize,1);
    for i = 1:popSize
        population{i} = base(randperm(n));
    end
end

function fitness = compute_fitness(population, D)
    m = numel(population);
    fitness = zeros(m,1);
    for i = 1:m
        r = population{i};
        total = 0;
        for k = 1:(numel(r)-1)
            total = total + D(r(k), r(k+1));
        end
        total = total + D(r(end), r(1));
        fitness(i) = total;
    end
end

function ind = tournament_select(population, fitness, k)
    m = numel(population);
    idx = randperm(m, k);
    [~, j] = min(fitness(idx));
    ind = population{idx(j)};
end

function [child1, child2] = ordered_crossover(p1, p2)
    n = numel(p1);
    ab = sort(randperm(n,2)); a = ab(1); b = ab(2);
    child1 = -ones(1,n);
    child1(a:b) = p1(a:b);
    pos = mod(b, n) + 1;
    for x = p2
        if ~ismember(x, child1)
            child1(pos) = x; pos = mod(pos, n) + 1;
        end
    end
    child2 = -ones(1,n);
    child2(a:b) = p2(a:b);
    pos = mod(b, n) + 1;
    for x = p1
        if ~ismember(x, child2)
            child2(pos) = x; pos = mod(pos, n) + 1;
        end
    end
end

function r = swap_mutation(r)
    n = numel(r);
    if n < 2, return; end
    ab = randperm(n,2); i = ab(1); j = ab(2);
    tmp = r(i); r(i) = r(j); r(j) = tmp;
end

function r = insert_mutation(r)
    n = numel(r);
    if n < 2, return; end
    ab = randperm(n,2); i = ab(1); j = ab(2);
    gene = r(i);
    r(i) = [];
    r = [r(1:j-1), gene, r(j:end)];
end 