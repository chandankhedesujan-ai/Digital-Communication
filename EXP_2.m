clc;
clear;
close all;

n=input("Enter the no of source elements ");
q=input("enter the channel matrix P(X/Y)");

disp(q);
disp("");
N=1:n;
p=input("Enter source probablities");
px=diag(p,0);
disp("P(X)");
disp(px);
disp("");

pxy=px*q;
disp("P(X,Y)");
disp(pxy);

disp("");

py=p*q;
disp("P(Y)");
disp(py);
disp("");

Hx=0;
for i=1:n
 if p(i)>0
  Hx=Hx-p(i)*log2(p(i));
 endif
endfor
disp("H(x)");
disp(Hx);
disp("");

Hy=0;
for i=1:n
 if py(i)>0
  Hy=Hy-py(i)*log2(py(i));
 endif
endfor
disp("H(y)");
disp(Hy);
disp("");

hxy=0;
for i=1:n
 for j=1:n
  if pxy(i,j)>0
   hxy=hxy-pxy(i,j)*log2(pxy(i,j));
  endif
 endfor
endfor
disp("H(x,y)");
disp(hxy);
disp("");

h1=hxy-Hx;
h2=hxy-Hy;
disp("H(y/x)");
disp(h1);
disp("");
disp("H(x/y)");
disp(h2);
disp("");

Ixy=Hx-h2;
disp("I(x,y)");
disp(Ixy);
disp("");

if h2==0
 disp("This cghannel is a lossless channel");
endif
if Ixy==0;
 disp("this channel is useless channel");
endif
if Hx==Hy
 if h1==0
  disp("This channel is noiseless channel");
 else
  disp("this channel has noise");
 endif
elseif ~(h2==0||Ixy==0||(Hx==Hy&&h1==0))
 disp("This channel has noise");
 endif

 % ===== Plot Entropy vs Probability Curve =====
p_vals = 0:0.01:1;                     % Probability range
H_vals = -p_vals .* log2(p_vals) - (1 - p_vals) .* log2(1 - p_vals);
H_vals(isnan(H_vals)) = 0;             % Handle NaN at p=0 or p=1

figure;
plot(p_vals, H_vals, 'LineWidth', 2);
title('Entropy vs Probability');
xlabel('Probability (p)');
ylabel('Entropy H(p) in bits');
grid on;

