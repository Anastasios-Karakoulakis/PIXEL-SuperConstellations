function [D,square_centers,d]=preprocessing_search_space(constellation,K,snr_awgn_db,sigma_phi,max_area,N)
% SUPER_SQUARE_CENTERS
% Constructs the lookup table D (Algorithm 1 in the paper).
%
% Inputs:
%   constellation : constellation points
%   K             : number of grid divisions per axis
%   snr_awgn_db   : SNR in dB
%   sigma_phi     : phase noise std dev
%   max_area      : scaling factor (usually 1)
%   N             : number of nearest constellation points per grid cell
%
% Outputs:
%   D             : lookup table (K x K x N) of nearest indices
%   square_centers: grid centers
%   d             : grid spacing

    r = max(abs(constellation));
    if nargin<=5
        r = 1.5*r;
    else
        r = max_area*r;
    end
    d = r/K;
    D = zeros(K,K,N);
    square_centers = zeros(K,K);

    for m=1:K
        for n=1:K
            x = (2*m-K-1)*d;
            y = (2*n-K-1)*d;
            square_center = x+1i*y;
            D(m,n,:)=GAP_D_search_space(square_center,constellation,snr_awgn_db,sigma_phi,N);
            square_centers(m,n) = square_center;
        end
    end
end
