function [idxs,detected_symbols] = GAP_D_array(received,constellation,snr_db,sigma_phi)
% Applies GAP-D detection to a batch of received symbols
    idxs             = NaN(length(received),1);
    detected_symbols = NaN(length(received),1);
    for k=1:length(received)
        [idxs(k),detected_symbols(k)] = GAP_D(received(k),constellation,snr_db,sigma_phi);
    end
end
