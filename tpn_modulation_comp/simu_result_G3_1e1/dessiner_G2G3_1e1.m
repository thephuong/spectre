load DT_nsU_G3_1e1.mat;
R_DT_dsss_G3_nSU = R_DT_dsss_nSU;
R_DT_dsss_G3_nSU(R_DT_dsss_G3_nSU == -1) = 0;
load 2017_5_11_18_4_MC_G3_1e1.mat;
Ralt1_G3_unb = fliplr(reshape(Ralt1_unb,1,[]));
Ralt1_G3_dsss = fliplr(reshape(Ralt1_dsss,1,[]));
snrdB_tab = fliplr(reshape(snrdB_tab,1,[]));

%G=2
load('2017_5_4_18_44_MC_1e1.mat', 'Ralt1_unb', 'Ralt1_dsss','l','nc','epsilon'); % be careful this one is fliplr
Ralt1_G2_unb = fliplr(reshape(Ralt1_unb,1,[]));
Ralt1_G2_dsss = fliplr(reshape(Ralt1_dsss,1,[]));
load('DT_nSU_1e1.mat', 'R_DT_unb_nSU', 'R_DT_dsss_nSU');
R_DT_G2_unb_nSU = reshape(R_DT_unb_nSU,1,[]);
R_DT_G2_dsss_nSU = reshape(R_DT_dsss_nSU,1,[]);
R_DT_G2_unb_nSU(R_DT_G2_unb_nSU==-1)=0;
R_DT_G2_dsss_nSU(R_DT_G2_dsss_nSU==-1)=0;


linewidth = 1.5;
figure;
hold on; grid on;
plot(snrdB_tab,R_DT_G2_unb_nSU,'ro--');
plot(snrdB_tab,Ralt1_G2_unb,'bo-');
plot(snrdB_tab,R_DT_G2_dsss_nSU,'rs--', 'LineWidth', linewidth);
plot(snrdB_tab,Ralt1_G2_dsss,'bs-', 'LineWidth', linewidth);
plot(snrdB_tab,R_DT_dsss_G3_nSU,'rd--', 'LineWidth', linewidth);
plot(snrdB_tab,Ralt1_G3_dsss,'bd-', 'LineWidth', linewidth);
% fdsss_G2 = fill([snrdB_tab fliplr(snrdB_tab)], [R_DT_G2_dsss_nSU fliplr(Ralt1_G2_dsss)],[0.25 0.25 0.25]);
% fdsss_G3 = fill([snrdB_tab fliplr(snrdB_tab)], [R_DT_dsss_G3_nSU fliplr(Ralt1_G3_dsss)],[0.75 0.75 0.75]);
legend('UNB DT lower bound','UNB MC upper bound','DSSS G=2 lower bound','DSSS G=2 upper bound','DSSS G=3 lower bound','DSSS G=3 upper bound');
ylabel('bits/channel use');
xlabel('SNR in dB');
titre = sprintf('Rate R^*(l=%d,nc=%d,epsilon=1e%d)',l,nc,log10(epsilon));
title(titre);