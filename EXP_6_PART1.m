clc;
clear all;
close all;
pkg load communications
N = 16000; % Number of bits to be transmitted using 16-Square QAM
x = randi([0,1],1,N); % Random input bits generation
M = 16; % Number of Symbols in 16-Square QAM
d = sqrt(2/5); % Average symbol energy is normalised to unity
% Symbol Generation
yy = [];
for i = 1:4:length(x)
  if x(i)==0 && x(i+1)==0 && x(i+2)==0 && x(i+3)==0
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
  yy = [yy y]; % Transmitted Symbols
endfor

scatterplot(yy);
EbN0db = 20; % Change this value & run program to see the noisy constellation
EbN0 = 10^(EbN0db/10);
% AWGN Channel
n = (1/sqrt(2))*[randn(1,length(yy)) + 1j*randn(1,length(yy))];
sigma = sqrt(1/((log2(M))*EbN0));
% Received Symbols
r = yy + sigma*n;
scatterplot(r);


