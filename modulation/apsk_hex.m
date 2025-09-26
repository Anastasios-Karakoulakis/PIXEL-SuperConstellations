function y = apsk_hex(M, Es, gamma)
% APSK_HEX  Generate hexagonal APSK constellation
    symbols_per_ring = M/gamma;
    dth = 2*pi*gamma/M; 
    dr = sqrt(12*Es/(4*gamma^2-1)); 
    phaseOff = dth/2;
    y = [];
    for q=1:gamma
        for p=1:symbols_per_ring
            if mod(q,2) == 0
                temp = dr/2*(2*q-1)*exp(1j*dth/2*(2*p-1))*exp(1j*phaseOff);
            else
                temp = dr/2*(2*q-1)*exp(1j*dth/2*(2*p-1));
            end
            y = cat(2,y,temp);
        end
    end
end
