function [p,F] = nested_f(SE1, p1, SE2, p2, ndata)

F = ((SE1-SE2)/(p2-p1))/((SE2)/(ndata-p2));

p = 1-fcdf(F, p2-p1, ndata-p2);
