function Z = single_gaussian_plot(P, xi, wrap)

Z = P(1) + P(2)*exp(-(angdiffwrap(xi-P(3),wrap).^2)/(2*P(4)*P(4)));
