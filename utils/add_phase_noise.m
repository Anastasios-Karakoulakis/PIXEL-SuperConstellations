function noisy_signal = add_phase_noise(signal, sigma_phi)
% ADD_PHASE_NOISE Adds Gaussian phase noise to a complex signal
    phase_noise = sigma_phi * randn(size(signal));
    noisy_signal = signal .* exp(1j * phase_noise);
end
