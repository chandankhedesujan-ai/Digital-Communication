clc;
clear all;
close all;
pkg load communications;

%define symbols and their probablities
symbols=1:5;
p=[0.4 0.2 0.2 0.1 0.1];
disp("symbols:");
disp(symbols);
disp("probablities");
disp(p);

%build shannon-fano dictionary
dict=shannonfanodict(symbols,p);
disp("shannon fano dictionary");
disp(dict);

%generate random input signals
inputSig=randsrc(10,1,[symbols;p]);
disp("input symbols");
disp(inputSig);

%encode using shannon fano
encoded=shannonfanoenco(inputSig,dict);
disp("Encoded mesage");
disp(encoded);

%decode using shannon fano
dedcoded=shannonfanodeco(encoded,dict);
disp("Decoded symbols");
disp(dedcoded);

%compute code legnth
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
