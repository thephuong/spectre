%% This script simulates MC bounds for UNB and DSSS normal single user mode (nSU)
%  this code is hard-coded for Mt=1, Mr=2 and G=2
%  it is possibly generalized to arbitrary Mt, Mr and G

addpath('../rayleigh-block-fading-no-csi/');

%% simulation point
epsilon = 1e-1;
prec = round(log2(100/epsilon))+2;
seuil = epsilon / 10;   % This threshold has a HUGE impact in simulation time
ntry_max = 4;
ntry_step = 5;          % this one, too

%% channel
Bc = 100e3; %coherence band
Bs = 100; % nominal band UNB
B = 500e3; %total band
tau_m = 5e-6; %delay spread

%normal SU, coherence time Tc = nc * 1/Bs, observation time T = l * Tc
l = 5;
nc = 8;

%% antenna
Mr = 2;
Mt = 1;

%% SNR
% snrdB_tab = [-5 -3 -1 0:4:16];
% snrdB_tab = -15:2:-4;
% snrdB_tab = 18:2:46;
% snrdB_tab = 50:10:100;
% snrdB_tab = 150:50:500;
% snrdB_tab = -40:5:-16;
% snrdB_tab = [-40:5:-20 -18:2:20 25:5:40 50:10:80];
snrdB_tab = [-35:5:-20 -18:2:18 20:5:35];

%% modulation configuration and derivatives
alpha = 0.4;
Bunb = (1+alpha) * Bs;
nunb = floor(B/Bunb);
nunb_Bc = floor(Bc/Bunb);
nBc = floor(B/Bc);

B_dsss_nominal = B/(1+alpha);
nSF = floor(B_dsss_nominal/Bs);
Tchip = 1/B_dsss_nominal;
G = floor(tau_m / Tchip + 0.5);
logG2 = 10 * log10(G);

%% FILENAME
dtime = clock();
dtimes = sprintf('%d_%d_%d_%d_%d_', dtime(1), dtime(2), dtime(3), dtime(4), dtime(5));
filename = strcat(dtimes, 'MC.mat');

%% check
if (nc < Mt + Mr)
    error('nc=%d is smaller than Mt+Mr=%d+%d=%d is not supported by USTM', nc, Mt, Mr, Mt+Mr);
end

if (nc < Mt + Mr * G)
    error('nc=%d is smaller than Mt+Mr*G=%d+%d*%d=%d is not supported by USTM', nc, Mt, Mr, G, Mt+Mr*G);
end

%% SIMU
R_MC_unb_nSU = zeros(size(snrdB_tab));
R_MC_dsss_nSU = zeros(size(snrdB_tab));

numIt = 1; %Mt = 1
% numIt=l+1;

lenSNR = length(snrdB_tab);
Ralt1_unb = zeros(lenSNR, numIt);
Ralt1_dsss = zeros(lenSNR, numIt);
cur_eps_unb = zeros(lenSNR, numIt);
cur_eps_dsss = zeros(lenSNR, numIt);
%These code are hard-coded for Mr=2 and virtual Mr = 4
if (Mr ~= 2 || Mr*G ~= 4)
    error('not supported yet Mr=%d G=%d', Mr, G);
end
use_complete_search = 1;
for i = 1:lenSNR
    %% Normal SU
    %Mt=1 then there is no optimization over TX antenna power distribution
    infos_unb = sprintf('MC bound, nSU UNB, snr=%d', snrdB_tab(i));
    disp(infos_unb);
    [Ralt1_unb(i), cur_eps_unb(i), ~] = MC_USTM_Mt_x_Mr(snrdB_tab(i), nc, l, 1, 1, 2, epsilon, prec, ones(l,1), '', use_complete_search);
    fprintf(1, 'UNB snr=%d, R=%.5f eps=%.5f/epsilon=%.5f\n', snrdB_tab(i), Ralt1_unb(i), cur_eps_unb(i), epsilon);
    save(filename);

    infos_dsss = sprintf('MC bound, nSU DSSS, snr=%d', snrdB_tab(i));
    disp(infos_dsss);
    [Ralt1_dsss(i), cur_eps_dsss(i), ~] = MC_USTM_Mt_x_Mr(snrdB_tab(i)-logG2, nc, l, 1, 1, 4 ... %is Mr*G=2*2=4
        , epsilon, prec, ones(l,1), '', use_complete_search);
    fprintf(1, 'DSSS snr=%d, R=%.5f eps=%.5f/epsilon=%.5f\n', snrdB_tab(i), Ralt1_dsss(i), cur_eps_dsss(i), epsilon);
    save(filename);
    
%     % The code below is for Mt >= 2
%     for ii=1:1:numIt
%         btmp = reshape(dec2bin(2^(ii-1)-1,l) - '0', [], 1);
% %         pow_all = [btmp, 2-btmp] / 2;                 %2 antennas Mr
% %         pow_all = [btmp, btmp, 2-btmp, 2-btmp] / 4;     %4 virtual antennas Mr
%         infos_unb = sprintf('MC bound, nSU UNB, snr=%3d, ii=%d/%d', snrdB_tab(i), ii, numIt);
%         disp(infos_unb);
%         [Ralt1_unb(i, ii), cur_eps_unb(i, ii), ~] = MC_USTM_Mt_x_Mr(snrdB_tab(i), nc, l, 1, 1, 2, epsilon, prec, ([btmp, 2-btmp]/2), '', use_complete_search);
%         fprintf(1, 'UNB snr=%3d, ii=%d/%d, R=%d eps=%.5f/epsilon=%.5f\n', snrdB_tab(i), ii, numIt, Ralt1_unb(i, ii), cur_eps_unb(i, ii), epsilon);
%         save(filename);
%         
%         infos_dsss = sprintf('MC bound, nSU DSSS, snr=%3d, ii=%d/%d', snrdB_tab(i), ii, numIt);
%         disp(infos_dsss);
%         [Ralt1_dsss(i, ii), cur_eps_dsss(i, ii), ~] = MC_USTM_Mt_x_Mr(snrdB_tab(i)-logG2, nc, l, 1, 1, 4 ... %is Mr*G=2*2=4
%             , epsilon, prec, ([btmp, btmp, 2-btmp, 2-btmp]/4), '', use_complete_search);
%         fprintf(1, 'DSSS snr=%3d, ii=%d/%d, R=%d eps=%.5f/epsilon=%.5f\n', snrdB_tab(i), ii, numIt, Ralt1_dsss(i, ii), cur_eps_dsss(i, ii), epsilon);
%         save(filename);
%     end
end