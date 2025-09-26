function idxs = Pixel_detection_N_1(received_symbols, search_space, d)

% Baseline fast detection.
% Each received symbol is mapped directly to its nearest grid cell index.
%
% Inputs:
%   received_symbols : received complex symbols
%   search_space     : precomputed lookup table (K x K) of nearest symbol indices
%   d                : grid spacing
%
% Output:
%   idxs             : detected symbol indices (0-based)

    K = size(search_space,1);
    num_rx = numel(received_symbols);
    idxs = zeros(num_rx,1);

    m_idx = round(real(received_symbols)/(2*d) + K/2 + 0.5);
    n_idx = round(imag(received_symbols)/(2*d) + K/2 + 0.5);

    % Clamp indices
    m_idx = min(max(m_idx,1),K);
    n_idx = min(max(n_idx,1),K);

    for i = 1:num_rx
        idxs(i) = search_space(m_idx(i), n_idx(i));
    end
end
