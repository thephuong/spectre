addpath('../rayleigh-block-fading-no-csi/');

%% simulation point
epsilon = 1e-1;
prec = round(log2(100/epsilon))+2;
seuil = epsilon / 20;   % This threshold has a HUGE impact in simulation time
ntry_max = 3;
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

% snrdB_tab = [-40:5:-20 -18:2:-8];
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

%% check
if (nc < Mt + Mr)
    error('nc=%d is smaller than Mt+Mr=%d+%d=%d is not supported by USTM', nc, Mt, Mr, Mt+Mr);
end

if (nc < Mt + Mr * G)
    error('nc=%d is smaller than Mt+Mr*G=%d+%d*%d=%d is not supported by USTM', nc, Mt, Mr, G, Mt+Mr*G);
end