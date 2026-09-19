clc;
clear all;
close all;
pkg load communications

N = 4000;                     % Number of bits to transmit
x = randi([0,1], 1, N);       % Random input bits
M = 16;                       % 16-QAM
d = sqrt(2/5);                % Normalized average symbol energy

% ===== Symbol Generation =====
yy = [];
for i = 1:4:length(x)
  if     x(i)==0 && x(i+1)==0 && x(i+2)==0 && x(i+3)==0
    y = -3*d/2 + j*(-3*d/2);
  elseif x(i)==0 && x(i+1)==0 && x(i+2)==0 && x(i+3)==1
    y = -3*d/2 + j*(-d/2);
  elseif x(i)==0 && x(i+1)==0 && x(i+2)==1 && x(i+3)==1
    y = -3*d/2 + j*(d/2);
  elseif x(i)==0 && x(i+1)==0 && x(i+2)==1 && x(i+3)==0
    y = -3*d/2 + j*(3*d/2);
  elseif x(i)==0 && x(i+1)==1 && x(i+2)==0 && x(i+3)==0
    y = -d/2 + j*(-3*d/2);
  elseif x(i)==0 && x(i+1)==1 && x(i+2)==0 && x(i+3)==1
    y = -d/2 + j*(-d/2);
  elseif x(i)==0 && x(i+1)==1 && x(i+2)==1 && x(i+3)==1
    y = -d/2 + j*(d/2);
  elseif x(i)==0 && x(i+1)==1 && x(i+2)==1 && x(i+3)==0
    y = -d/2 + j*(3*d/2);
  elseif x(i)==1 && x(i+1)==1 && x(i+2)==0 && x(i+3)==0
    y = d/2 + j*(-3*d/2);
  elseif x(i)==1 && x(i+1)==1 && x(i+2)==0 && x(i+3)==1
    y = d/2 + j*(-d/2);
  elseif x(i)==1 && x(i+1)==1 && x(i+2)==1 && x(i+3)==1
    y = d/2 + j*(d/2);
  elseif x(i)==1 && x(i+1)==1 && x(i+2)==1 && x(i+3)==0
    y = d/2 + j*(3*d/2);
  elseif x(i)==1 && x(i+1)==0 && x(i+2)==0 && x(i+3)==0
    y = 3*d/2 + j*(-3*d/2);
  elseif x(i)==1 && x(i+1)==0 && x(i+2)==0 && x(i+3)==1
    y = 3*d/2 + j*(-d/2);
  elseif x(i)==1 && x(i+1)==0 && x(i+2)==1 && x(i+3)==1
    y = 3*d/2 + j*(d/2);
  elseif x(i)==1 && x(i+1)==0 && x(i+2)==1 && x(i+3)==0
    y = 3*d/2 + j*(3*d/2);
  endif
  yy = [yy y]; % Transmitted symbols
endfor

% ===== Reference Symbol Mapping =====
ref_symbols = [
  -3*d/2+j*(-3*d/2), -3*d/2+j*(-d/2), -3*d/2+j*(d/2), -3*d/2+j*(3*d/2), ...
  -d/2+j*(-3*d/2),  -d/2+j*(-d/2),  -d/2+j*(d/2),  -d/2+j*(3*d/2), ...
   d/2+j*(-3*d/2),   d/2+j*(-d/2),   d/2+j*(d/2),   d/2+j*(3*d/2), ...
   3*d/2+j*(-3*d/2), 3*d/2+j*(-d/2), 3*d/2+j*(d/2), 3*d/2+j*(3*d/2)
];

ber_simulated = [];
ber_theoretical = [];

% ===== Loop over Eb/N0 =====
for EbN0db = 0:15
  EbN0 = 10^(EbN0db/10);
  n = (1/sqrt(2))*(randn(1, length(yy)) + 1j*randn(1, length(yy)));
  sigma = sqrt(1/((log2(M))*EbN0));
  r = yy + sigma*n; % Received signal

  % ===== Detection by Minimum Euclidean Distance =====
  min_dist_index = zeros(1, length(r));
  for i = 1:length(r)
    [~, idx] = min(abs(r(i) - ref_symbols));
    min_dist_index(i) = idx;
  endfor

  % ===== Bit Estimation =====
  symbol_bits = [
    0 0 0 0; 0 0 0 1; 0 0 1 1; 0 0 1 0;
    0 1 0 0; 0 1 0 1; 0 1 1 1; 0 1 1 0;
    1 1 0 0; 1 1 0 1; 1 1 1 1; 1 1 1 0;
    1 0 0 0; 1 0 0 1; 1 0 1 1; 1 0 1 0
  ];
  x_estimated = reshape(symbol_bits(min_dist_index, :).', 1, []);

  % ===== BER Calculation =====
  ber_simulated = [ber_simulated sum(x ~= x_estimated) / N];
  ber_theoretical = [ber_theoretical (3/(2*log2(M)))*erfc(sqrt(2*EbN0/5))];
endfor

% ===== BER Plot =====
EbN0db = 0:15;
semilogy(EbN0db, ber_simulated, 'ro-', EbN0db, ber_theoretical, 'k>-');
title('BER vs Eb/N0 for 16-QAM');
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (BER)');
grid on;
legend('Simulated', 'Theoretical');
axis([0 15 1e-3 1]);

