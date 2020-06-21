function F = wheel_of_fortune(P,X)
x = cumsum([0 P(:).'/sum(P(:))]);
x(end) = 1e3*eps + x(end);
[a a] = histc(rand,x);
F = X(a);