function [V,square_centers,d] = preprocessing_search_space_N_1(constellation,K,snr_awgn_db,sigma_phi,max_area)
% SQUARE_CENTERS_GAP_D
% Simpler lookup table construction: only the single nearest constellation 
% point per grid cell (N=1). Used in fast detection baselines.
%
% Inputs:
%   constellation : constellation points
%   K             : number of grid divisions per axis
%   snr_awgn_db   : SNR in dB
%   sigma_phi     : phase noise std dev
%   max_area      : scaling factor (default 1)
%
% Outputs:
%   V             : lookup table (K x K) with nearest indices
%   square_centers: grid cell centers
%   d             : grid spacing

    r = max(abs(constellation));
    if nargin<=4
        r = 1.5*r;
    else
        r = max_area*r;
    end

    d = r/K;
    V = zeros(K,K);
    square_centers = zeros(K,K);

    for m=1:K
        for n=1:K
            x = (2*m-K-1)*d;
            y = (2*n-K-1)*d;
            square_center = x+1i*y;
            [idx_min,~] = GAP_D(square_center,constellation,snr_awgn_db,sigma_phi);
            V(m,n)=idx_min;
            square_centers(m,n) = square_center;
        end
    end
end
