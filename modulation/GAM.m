function constellation_points=GAM(N)
% GAM  Generate Golden Angle Modulation constellation
    n = 1:N;
    phi = (1 + sqrt(5)) / 2;
    c_disc = sqrt(2/(N+1));
    r_n = c_disc*sqrt(n);
    phase = 2*pi*n*phi;
    s_n = r_n.*exp(phase*1j);
    constellation_points = s_n(:);
end
