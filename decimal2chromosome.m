function [chromosome] = decimal2chromosome(decimal)
    inverse = (1e3)/decimal;
    chromosome = zeros(1,21);
    for i = 21:-1:1
        if inverse > 2^(i-1)
            inverse = inverse - 2^(i-1);
            chromosome(i) = 1;
        end
    end
end