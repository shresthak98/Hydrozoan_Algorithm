function y = fitness(hydrozoan)
    y = 0;
    for i=1:size(hydrozoan,2)-1
        y = y + (hydrozoan(i)-1)^2 + 100*(hydrozoan(i+1) - hydrozoan(i)^2)^2;
    end
endfunction

D = 2;
N = 2;
low = 0;
high = 1;
Iteration = 5; 
H = zeros(N,D);

for i=1:N
    for j=1:D
        H(i, j) = rand()*(high-low) + low; 
    end 
end
growth_low = 0.01;
growth_high = 0.1;

while(Iteration > 0)
    Fit = [];
    for i = 1:N
        Fit = [Fit; fitness(H(i,:))];
    end
    G = [];
    for i=1:N
        G(i) = rand()*(growth_high-growth_low) + growth_low;
    end
    
    Med = median(G); 
    
    Swarm = zeros(N);
    Swarm = G - Med;
    
    Split = zeros(N);
    
    Min = min(Swarm);
    Max = max(Swarm);
    for i = 1:N
        if(Swarm(i) < 0) then
            Split(i) = 0;
        elseif (Swarm(i) == 0) then
            Split(i) = 1;
        elseif (Swarm(i) > 0 & Swarm(i) == Min) then
            Split(i) = 1;
        elseif (Swarm(i) > 0 & Swarm(i) == Max) then
            Split(i) = 3;
        else
            Split(i) = 2;
        end    
    end
    
    Clone = [];
    
    for i = 1:N
        for j = 1:Split(i)
            Clone = [Clone; H(i,:)];
        end
    end
    
    Min = 1e-9;
    Max = 1e-7;
     
    for i = 1:size(Clone,1)
        for j = 1:size(Clone,2)
            RP = (Max - Min)*rand() + Min;
            Clone(i,j) = Clone(i,j)*(1 + RP);      
        end
    end    
    
    Fit = [];
    for i = 1:size(Clone, 1)
        Fit = [Fit; fitness(Clone(i,:))];
    end
    
    sum_of_fitness = 0;
    for i = 1:size(Clone ,1)
        sum_of_fitness = sum_of_fitness + Fit(i); 
    end
    
    Probability = [];
    
    for i = 1:size(Clone ,1)
        Probability = [Probability; (Fit(i)/sum_of_fitness)];  
    end    
    
    max_probability = max(Probability);
    counter = zeros(size(Clone,1),1);
    n_select = 1000;
    index = -1;
    for i=1:n_select
        while(1)
            index = ceil(size(Clone,1)*rand());
            if  (rand() < Probability(index)) 
                break;
            end
        end    
        counter(index) = counter(index)+1;
    end
    
    par1 = -1;
    par2 = -1;
    first_max = 0;
    second_max = 0; 
    for i=1:size(Clone,1)
        if(first_max < counter(i))
           second_max = first_max;
           par2 = par1;
           par1 = i;
           first_max = counter(i); 
        elseif(second_max < counter(i))
            second_max = counter(i);
            par2 = i;
        end
    end
    
    swap_probability = 0.5;
    
    for i=1:D
        if(swap_probability < rand())
            swap_val = Clone(par1,i);
            Clone(par1,i) = Clone(par2,i);
            Clone(par2,i) = swap_val;            
        end    
    end     
    
    for i=1:size(Clone, 1)
        Clone(i,1+ceil(rand()*D)) = low + rand()*(high-low);
    end
    
    Fit = [];
    
    for i=1:size(Clone, 1)
        Fit = [Fit; fitness(Clone(i,:))];
    end
    
    gsort(Fit);
    
    bestcount = 2;
    
    Fit_threshold = Fit(bestcount);
    
    for i=1:size(Clone, 1)
        if(fitness(Clone(i,:)) == Fit_threshold)
           Ibest = Clone(i,:);
           break; 
        end
    end
    
    for i=1:size(Clone, 1)
        if(fitness(Clone(i,:)) >= Fit_threshold)
            Clone(i, :) = Ibest;
        end
    end
    
    H = Clone;
    Iteration = Iteration-1;
end

//disp(Ibest);
disp(fitness(Ibest));
