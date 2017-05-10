bound_DT_init

filename = 'DT_nSU.mat';

%% Normal SU
R_DT_unb_nSU = zeros(size(snrdB_tab));
Ralt_DT_unb_nSU = zeros(size(snrdB_tab));
eps_DT_unb_nSU = zeros(size(snrdB_tab));

R_DT_dsss_nSU = zeros(size(snrdB_tab));
Ralt_DT_dsss_nSU = zeros(size(snrdB_tab));
eps_DT_dsss_nSU = zeros(size(snrdB_tab));

for i = 1:length(snrdB_tab)
    infos_unb = sprintf('DT bound for nSU UNB at SNR = %d', snrdB_tab(i));
    disp(infos_unb);
    [R_DT_unb_nSU(i),Ralt_DT_unb_nSU(i),eps_DT_unb_nSU(i)] = try_with_prec(ntry_max, ntry_step, seuil, snrdB_tab(i), nc, l, Mt, Mr, epsilon, prec, infos_unb);
    disp('Saving ...');
    save(filename);
    
    infos_dsss = sprintf('DT bound for nSU DSSS at SNR = %d', snrdB_tab(i));
    disp(infos_dsss);
    [R_DT_dsss_nSU(i),Ralt_DT_dsss_nSU(i),eps_DT_dsss_nSU(i)] = try_with_prec(ntry_max, ntry_step, seuil, snrdB_tab(i) - logG2, nc, l, Mt, Mr*G, epsilon, prec, infos_dsss);
    disp('Saving ...');
    save(filename);
end

%% MU
R_DT_unb_MU = nunb * R_DT_unb_nSU;
R_DT_dsss_MU = nSF * R_DT_dsss_nSU;

%% SAVE
save(filename);