clc; clear; close all;
pkg load statistics
pkg load signal

Fs = 1000;           % Sampling frequency
L = 1000;            % Length of random sequence
t = (0:L-1)/Fs;      % Time vector

% ========== 1. Gaussian Random Process ==========
x_gauss = randn(1, L);

% ========== 2. Uniform Random Process ==========
x_uniform = rand(1, L);   % Range [0,1]

% ========== 3. Exponential Random Process ==========
lambda = 1;               % rate parameter
x_exp = exprnd(1/lambda, 1, L);

% ========== 4. Poisson Random Process ==========
lambda_p = 5;
x_pois = poissrnd(lambda_p, 1, L);

% ========== Function to analyze process ==========
function analyze_process(x, Fs, name)
  [Rxx, lags] = xcorr(x - mean(x), 'biased');
  [pxx, f_psd] = pwelch(x, [], [], [], Fs);

  mean_x = mean(x);
  var_x  = var(x);
  std_x  = std(x);

  fprintf('\n--- %s Process ---\n', name);
  fprintf('Mean = %.4f\n', mean_x);
  fprintf('Variance = %.4f\n', var_x);
  fprintf('Std Dev = %.4f\n', std_x);

  figure('Name', name);
  subplot(3,1,1);
  plot(x);
  title([name ' Random Process']);
  xlabel('Sample'); ylabel('Amplitude');

  subplot(3,1,2);
  plot(lags, Rxx);
  title(['Autocorrelation of ' name]);
  xlabel('Lag'); ylabel('R_{xx}(\tau)');

  subplot(3,1,3);
  plot(f_psd, 10*log10(pxx));
  title(['Power Spectral Density (PSD) of ' name]);
  xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)');
  grid on;
endfunction

% ========== Analyze all processes ==========
analyze_process(x_gauss, Fs, 'Gaussian');
analyze_process(x_uniform, Fs, 'Uniform');
analyze_process(x_exp, Fs, 'Exponential');
analyze_process(x_pois, Fs, 'Poisson');

