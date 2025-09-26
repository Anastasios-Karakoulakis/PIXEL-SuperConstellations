%% PIXEL Detection Simulation
% Evaluates SER of GAP-D vs PIXEL N=1 vs PIXEL.
%
% Author: Anastasios Karakoulakis
% Paper:  PIXEL: A Novel Detection Algorithm for Super Constellations
% Date:   26/9/2025

clear; close all; clc;

%% ---------------- Setup Paths ----------------
% Add all subfolders of the project to MATLAB path automatically
root_folder = fileparts(mfilename('fullpath'));
addpath(genpath(root_folder));

init_time = datetime;

%% ---------------- Constellation Setup ----------------
% Example constellations
% constellation = qammod(0:256-1,256,"UnitAveragePower",true); const_name = "QAM256";
% constellation = qammod(0:1024-1,1024,"UnitAveragePower",true); const_name = "QAM1024";
% constellation = qammod(0:4096-1,4096,"UnitAveragePower",true); const_name = "QAM4096";
% constellation = GAM(4096); const_name = "GAM4096";
% constellation = apsk_hex(4096,1,2048); const_name = "SAPSK4096";

constellation = qammod(0:512-1,512,"UnitAveragePower",true);
const_name = "QAM512";

M = length(constellation);

fprintf('=============================================\n');
fprintf('Simulating for %s...\n', const_name);

%% ---------------- Simulation Parameters ----------------
snr_values   = 30:5:80;           % SNR values in dB
sigma_phi    = 10^(-1.5);         % Phase noise std. dev.

num_symbols  = 1e5;               % Number of transmitted symbols

grid_sizes   = 2.^(7:1:10);       % Grid divisions per axis (K)
N_values     = 2.^(0:1:3);        % Candidate constellation points per cell (N)


%% ---------------- Storage ----------------
SEP_gapd       = zeros(1,length(snr_values));
results_matrix = [];
results_header = ["SNR_dB","GridSize_K","Candidates_N", ...
                  "SEP_GAPD","Time_GAPD","SEP_FAST","Time_FAST","SEP_PIXEL","Time_PIXEL"];

counter = 1;

%% ---------------- Main Loop ----------------
for i = 1:length(snr_values)
    snr_db = snr_values(i);

    fprintf("\n=================================================\n");
    fprintf(" SNR = %d dB | Constellation = %s\n", snr_db, const_name);
    fprintf("=================================================\n");

    % --- Generate random transmitted symbols ---
    tx_data = randi([0 M-1], num_symbols, 1);
    tx_sig  = constellation(tx_data+1);

    % --- Add AWGN + Phase Noise ---
    rx_sig = awgn(tx_sig, snr_db, 'measured');
    rx_sig = add_phase_noise(rx_sig, sigma_phi);

    % --- Baseline GAP-D detection (once per SNR) ---
    tic;
    detected_gapd = GAP_D_array(rx_sig, constellation, snr_db, sigma_phi);
    t_gapd = toc;
    [~,SEP_gapd(i)] = symerr(tx_data,detected_gapd);

    fprintf(" GAP-D Reference -> SEP = %.3e | Time = %.4fs\n", SEP_gapd(i), t_gapd);

    % --- Loop over grid sizes ---
    for K = grid_sizes
        fprintf("-------------------------------------------------\n");
        fprintf(" Grid Size K = %d\n", K);

        % --- Fast Square detection (once per grid size) ---
        [D,~,d] = preprocessing_search_space(constellation,K,snr_db,sigma_phi,1,1);
        V = D(:,:,1); % best candidate per cell
        tic;
        detected_fast = Pixel_detection_N_1(rx_sig, V, d);
        t_fast = toc;
        [~,SEP_fast] = symerr(tx_data,detected_fast);

        fprintf("   Fast PIXEL N=1 -> SEP = %.3e | Time = %.4fs\n", SEP_fast, t_fast);

        % --- PIXEL detection for each N ---
        fprintf("   PIXEL detection results:\n");
        fprintf("       N |    SEP     | Time\n");
        fprintf("   -------------------------------\n");

        for N = N_values
            [D,~,d] = preprocessing_search_space(constellation,K,snr_db,sigma_phi,1,N);

            tic;
            detected_pixel = Pixel_detection(rx_sig, D, d, snr_db, sigma_phi, constellation);
            t_pixel = toc;
            [~,SEP_pixel] = symerr(tx_data,detected_pixel);

            results_matrix(counter,:) = [snr_db, K, N, ...
                                         SEP_gapd(i), t_gapd, ...
                                         SEP_fast, t_fast, ...
                                         SEP_pixel, t_pixel];

            fprintf("    %4d |  %.3e |  %.2fs\n", N, SEP_pixel, t_pixel);

            counter = counter + 1;
        end
    end
end



%---------------- Save Results ----------------
% save("results_pixel.mat","results_matrix","results_header","SEP_gapd","snr_values","const_name");
% 
% finish_time = datetime;
% fprintf("Duration: %s\n", string(finish_time-init_time));

