clc ;
clear all;
close all;
pkg load communications;

symbols=1:5;
p=[0.4 0.2 0.2 0.1 0.1];
disp("symbols:");
disp(symbols);
disp("length of symbols");
disp(length(symbols));
disp("probablities");
disp(p);

dict=huffmandict(symbols,p);
disp("dictionary");
disp(dict);

inputSig=randsrc(10,1,[symbols;p]);
disp("input signal");
disp(inputSig);

encoded=huffmanenco(inputSig,dict);
disp("encoded mesage");
disp(encoded);

decoded=huffmandeco(encoded,dict);
disp("decoded message");
disp(decoded);

avg_code_len=0;
for i=1:length(symbols);
 avg_code_len=avg_code_len + p(i)*length(dict{i});
endfor
disp("Average code legnth");
disp(avg_code_len);

%compute entropy
H=-sum(p.*log2(p));
disp("entropy");
disp(H);

%compute efficiency
efficiency=H/avg_code_len;
disp("efficiency");
disp(efficiency);

%redundancy
redundancy=1-efficiency;
disp("redundancy");
disp(redundancy);
