%% Test the new function MC_USTM_Mt_x_Mr()
%%
function R = example_compute_MC_2x2_telatar_Mt_x_Mr(snrdB,T,L,epsilon)

% Mt=2;
% Mr=2;

prec=round(log2(100/epsilon));

numIt=L+1;
% pow_all=zeros(1,L);
Ralt1=zeros(numIt,1);
Ralt2=zeros(numIt,1);


for ii=1:1:numIt, % try all points according to generalized Telatar conjecture
    %numIt-ii;
    bstring=dec2bin(2^(ii-1)-1,L);
    filename = ''; %create filename of raw data

    btmp = reshape(bstring - '0', [], 1);
    pow_all_frac = [btmp, 2-btmp] / 2;
    Ralt1(ii)=MC_USTM_Mt_x_Mr(snrdB,T,L,1,2,2,epsilon,prec,pow_all_frac,filename);
    Ralt2(ii)=MC_USTM_Mt_x_Mr(snrdB,T,L,2,2,2,epsilon,prec,pow_all_frac,filename);
    
end

Ralt1_max=max(Ralt1);
Ralt2_max=max(Ralt2);

R=min(Ralt1_max,Ralt2_max);

