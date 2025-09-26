function [idx, s_detected] = GAP_D(r_k, constellation, snr_awgn_db, sigma_phi)
% GAP_D  Gaussian Amplitude-Phase Detector
% Implements symbol detection metric from the paper.
%
% Inputs:
%   r_k          : received symbol
%   constellation: vector of constellation points
%   snr_awgn_db  : SNR in dB
%   sigma_phi    : phase noise std dev
%
% Outputs:
%   idx          : detected index (0-based)
%   s_detected   : detected symbol (not used in PIXEL, set to 0)

    snr_awgn_linear = 10^(snr_awgn_db / 10);
    No = mean(abs(constellation).^2) / snr_awgn_linear;

    [r_th,r_rho] = cart2pol(real(r_k),imag(r_k));
    cost = zeros(1,length(constellation));

    for i=1:length(constellation)
        s = constellation(i);
        [s_th,s_rho] = cart2pol(real(s),imag(s));
        if s_th*r_th > 0
            cost(i) = (r_rho - s_rho)^2/(No/2) + ...
                       (r_th - s_th)^2/(sigma_phi^2+No/(2*s_rho^2)) + ...
                       log(sigma_phi^2+No/(2*s_rho^2));
        else
            cost(i) = (r_rho - s_rho)^2/(No/2) + ...
                       mod((r_th - (2*pi+s_th)),2*pi)^2/(sigma_phi^2+No/(2*s_rho^2)) + ...
                       log(sigma_phi^2+No/(2*s_rho^2));
        end
    end
    [~,min_idx] = min(cost);
    idx = min_idx - 1;   % 0-based index
    s_detected=0;
end
