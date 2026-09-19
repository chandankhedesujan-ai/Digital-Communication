clc;
clear all;
close all;
warning('off','octave:function-name-clash');
rng(0); % reproducible noise

% ===== AWGN Function =====
function rx = add_awgn(tx, SNR_dB)
  snr_lin = 10^(SNR_dB/10);
  signal_power = mean(abs(tx).^2);
  noise_power = signal_power / snr_lin;
  noise = sqrt(noise_power/2) * (randn(size(tx)) + 1j*randn(size(tx)));
  rx = tx + noise;
endfunction

% ===== MAIN SIMULATION =====
M = input("Enter the value of M (4, 8, 16): ");
if ~ismember(M,[4,8,16])
    error("Only M = 4, 8, 16 are supported");
endif

% Parameters
N = 50000;                        % Number of symbols
SNR_Constellation_dB = 12;        % SNR for constellation plot
SNR_range = 0:2:20;               % SNR range for BER
k = log2(M);                      % Bits per symbol

% Generate random bits
data_bits = randi([0 1], N*k, 1);

% Map bits to symbols
bits_mat = reshape(data_bits, k, []).';   % N x k
weights = 2.^(k-1:-1:0).';                % k x 1
data_symbols = bits_mat * weights;        % N x 1, values 0..M-1

% Generate PSK constellation
const_points = exp(1j * 2 * pi * (0:M-1) / M);
tx_signal = const_points(data_symbols + 1);

% ===== Constellation Diagram =====
figure('Name',sprintf('%d-PSK Constellation',M),'NumberTitle','off');

% Ideal
subplot(1,2,1);
plot(real(const_points), imag(const_points), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
hold on;
plot(real(tx_signal(1:2000)), imag(tx_signal(1:2000)), 'k.', 'MarkerSize', 5);
title(sprintf('Ideal %d-PSK (no noise)', M));
xlabel('In-Phase'); ylabel('Quadrature');
grid on; axis equal; hold off;

% Noisy
rx_const = add_awgn(tx_signal, SNR_Constellation_dB);
subplot(1,2,2);
plot(real(rx_const(1:2000)), imag(rx_const(1:2000)), '.', 'MarkerSize', 5);
hold on;
plot(real(const_points), imag(const_points), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title(sprintf('%d-PSK with AWGN (SNR = %d dB)', M, SNR_Constellation_dB));
xlabel('In-Phase'); ylabel('Quadrature');
legend('Received samples','Ideal points');
grid on; axis equal; hold off;

% ===== BER vs SNR =====
BER_sim = zeros(size(SNR_range));

fprintf('\nSimulating BER for M = %d (N = %d symbols → %d bits total)\n', M, N, N*k);

for ii = 1:length(SNR_range)

    % Add AWGN
    rx = add_awgn(tx_signal, SNR_range(ii));
    rx = rx(:); % ensure column vector

    % Demodulation: nearest constellation point
   % Demodulation: nearest constellation point (fixed dimensions)
const_points = const_points(:).';                % ensure row vector (1xM)
D = abs(bsxfun(@minus, rx, const_points)).^2;    % (N x 1) - (1 x M) = N x M
[~, idx_min] = min(D, [], 2);                    % closest symbol index
rx_symbols = idx_min - 1;                        % map back to 0..M-1


    % Convert symbols back to bits (robust arithmetic method)
    rx_symbols_d = double(rx_symbols);
    rx_bits_mat = zeros(N, k);

    for bitpos = 1:k
        rx_bits_mat(:, bitpos) = mod(floor(rx_symbols_d ./ 2^(k - bitpos)), 2);
    end

    rx_bits = reshape(rx_bits_mat.', N*k, 1);

    % BER (bit-level)
    bit_errors = sum(rx_bits ~= data_bits);
    BER_sim(ii) = bit_errors / (N*k);

    % Print SNR & BER
    fprintf('M = %d, SNR = %2d dB -> BER = %.5e (bit errors = %d)\n', ...
        M, SNR_range(ii), BER_sim(ii), bit_errors);
end

% Avoid log(0) issue in semilogy
BER_plot = BER_sim;
BER_plot(BER_plot==0) = 1e-12;

% Plot BER vs SNR
figure('Name', sprintf('BER vs SNR (%d-PSK)', M), 'NumberTitle', 'off');
semilogy(SNR_range, BER_plot, 'bo-', 'LineWidth', 2, 'MarkerSize', 6);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title(sprintf('BER vs SNR for %d-PSK (Simulation)', M));
axis([0 20 1e-5 1]);

% Print BER at constellation SNR
[~, idx_closest] = min(abs(SNR_range - SNR_Constellation_dB));
fprintf('\nConstellation SNR = %d dB (closest tested = %d dB) -> BER = %.5e\n\n', ...
    SNR_Constellation_dB, SNR_range(idx_closest), BER_sim(idx_closest));

