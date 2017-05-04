%% To plot the bounds of UNB and DSSS
% 20170502 : UNB and DSSS nSU, MU case is just a scale. fSU case too long
%%

% load('2017_5_2_18_29_MC_1e1.mat', 'snrdB_tab', 'Ralt1_unb', 'Ralt1_dsss','l','nc','epsilon'); % this one no fliplr
load('2017_5_4_18_44_MC_1e1.mat', 'snrdB_tab', 'Ralt1_unb', 'Ralt1_dsss','l','nc','epsilon'); % be careful this one is fliplr
snrdB_tab = fliplr(snrdB_tab);
Ralt1_unb = flipud(Ralt1_unb);
Ralt1_dsss = flipud(Ralt1_dsss);

load('DT_nSU_1e1.mat', 'R_DT_unb_nSU', 'R_DT_dsss_nSU');

R_dt_unb_plot = R_DT_unb_nSU;
R_dt_unb_plot(R_DT_unb_nSU == -1) = 0;
R_dt_dsss_plot = R_DT_dsss_nSU;
R_dt_dsss_plot(R_DT_dsss_nSU == -1) = 0;

snrdB_tab = reshape(snrdB_tab, 1, []);
R_dt_unb_plot = reshape(R_dt_unb_plot, 1, []);
R_dt_dsss_plot = reshape(R_dt_dsss_plot, 1, []);
Ralt1_unb = reshape(Ralt1_unb, 1, []);
Ralt1_dsss = reshape(Ralt1_dsss, 1, []);

figure;
hold on; grid on;

funb = fill([snrdB_tab fliplr(snrdB_tab)], [R_dt_unb_plot fliplr(Ralt1_unb)],[0.25 0.25 0.25]);
fdsss = fill([snrdB_tab fliplr(snrdB_tab)], [R_dt_dsss_plot fliplr(Ralt1_dsss)],[0.75 0.75 0.75]);

lunb_dt = plot(snrdB_tab,R_dt_unb_plot,'ro-', 'MarkerFaceColor', 'r');
lunb_mc = plot(snrdB_tab,Ralt1_unb,'bo-', 'MarkerFaceColor', 'b');
ldsss_dt = plot(snrdB_tab,R_dt_dsss_plot,'rs--', 'MarkerFaceColor', 'r');
ldsss_mc = plot(snrdB_tab,Ralt1_dsss,'bs--', 'MarkerFaceColor', 'b');

ylabel('bits/channel use');
xlabel('SNR in dB');
titre = sprintf('Rate R^*(l=%d,nc=%d,epsilon=1e%d)',l,nc,log10(epsilon));
title(titre);

legend('R^*_{SU,unb}', 'R^*_{SU,dsss}', 'UNB DT lower bound', 'UNB MC upper bound','DSSS DT lower bound', 'DSSS MC upper bound');

% axis([-30 5 0 0.9]);
% axis([-5 35 2 11]);