clc;
clear;
close all;
pkg load statistics

N = 10000;  % number of samples

% ----- Generate Random Processes -----
x_gauss   = randn(N,1);                  % Gaussian: mean 0, var 1
x_uniform = rand(N,1);                   % Uniform: [0,1]
lambda_exp = 1;
x_exp     = exprnd(1/lambda_exp, N,1);   % Exponential: mean=1
lambda_pois = 5;
x_pois    = poissrnd(lambda_pois, N,1);  % Poisson: mean=5

processes = {x_gauss, x_uniform, x_exp, x_pois};
names = {'Gaussian','Uniform','Exponential','Poisson'};

figure('Name','Random Processes: PDFs Only','NumberTitle','off');

for i = 1:4
    x = processes{i};
    subplot(2,2,i);  % 2x2 grid for 4 PDFs
    nbins = 50;
    [counts, bin_edges] = hist(x, nbins);
    bin_width = bin_edges(2) - bin_edges(1);
    pdf_vals = counts / (sum(counts) * bin_width); % normalize to PDF
    bar(bin_edges, pdf_vals, 'hist');
    xlabel('x'); ylabel('PDF'); title([names{i} ' PDF']);
    grid on;
end

