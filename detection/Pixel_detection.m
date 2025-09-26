function idxs = Pixel_detection(received_symbols, D, d, snr_db, sigma_phi, constellation)
% PIXEL detection (Algorithm 2 in the paper).
%
% Inputs:
%   received_symbols : vector of received complex symbols
%   D                : lookup table (K x K x N) of nearest constellation indices
%   d                : grid spacing
%   R                : search radius in grid cells
%   snr_db           : SNR in dB
%   sigma_phi        : phase noise std dev
%   constellation    : full constellation vector
%
% Output:
%   idxs             : detected symbol indices (0-based)

    K = size(D,1);            
    num_rx = numel(received_symbols);
    idxs = zeros(num_rx,1);

    m_idx = round(real(received_symbols)/(2*d) + K/2 + 0.5);
    n_idx = round(imag(received_symbols)/(2*d) + K/2 + 0.5);
    m_idx = min(max(m_idx,1),K);
    n_idx = min(max(n_idx,1),K);

    for i = 1:num_rx
        m_low = max(m_idx(i),1);
        m_high= min(m_idx(i),K);
        n_low = max(n_idx(i),1);
        n_high= min(n_idx(i),K);

        candidates = unique(D(m_low:m_high, n_low:n_high, :));
        cand_syms = constellation(candidates+1);

        [idx_local,~] = GAP_D(received_symbols(i), cand_syms, snr_db, sigma_phi);
        idxs(i) = candidates(idx_local+1);
    end
end
