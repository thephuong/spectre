bound_DT_init

filename = 'DT_fSU.mat';

%% Full SU
R_DT_unb_fSU = zeros(size(snrdB_tab));
Ralt_DT_unb_fSU = zeros(size(snrdB_tab));
eps_DT_unb_fSU = zeros(size(snrdB_tab));

R_DT_dsss_fSU = zeros(size(snrdB_tab));
Ralt_DT_dsss_fSU = zeros(size(snrdB_tab));
eps_DT_dsss_fSU = zeros(size(snrdB_tab));
for i = 1:length(snrdB_tab)
%     fprintf(1, 'DT bound for fSU UNB at SNR = %d\n', snrdB_tab(i));
%     ncc = nc * nunb_Bc; %nc was 1
%     ll = l * nBc;
%     for ntry = 1:ntry_max
%         [R_DT_unb_fSU(i), current_eps] = DT_USTM(snrdB_tab(i),ncc,ll,Mt,Mr,epsilon,prec + (ntry-1) * ntry_step,'');
%         if (abs(current_eps - epsilon) < seuil)
%             break;
%         end
%     end
%     if (ntry == ntry_max) && (abs(current_eps - epsilon) > seuil)
%         error('Prec too small current_eps=%.5f epsilon=%.5f', current_eps, epsilon);
%     end
%     
%     fprintf(1, 'DT bound for fSU DSSS at SNR = %d\n', snrdB_tab(i));
%     ncc = nc * nSF;
%     ll = l;
%     for ntry = 1:ntry_max
%         [R_DT_dsss_fSU(i), current_eps] = DT_USTM(snrdB_tab(i)-logG2,ncc,ll,Mt,Mr*G,epsilon,prec + (ntry-1) * ntry_step,'');
%         if (abs(current_eps - epsilon) < seuil)
%             break;
%         end
%     end
%     if (ntry == ntry_max) && (abs(current_eps - epsilon) > seuil)
%         error('Prec too small current_eps=%.5f epsilon=%.5f', current_eps, epsilon);
%     end
    
    infos_unb = sprintf('DT bound for fSU UNB at SNR = %d', snrdB_tab(i));
    disp(infos_unb);
    ncc = nc * nunb_Bc; %nc was 1
    ll = l * nBc;
    [R_DT_unb_fSU(i),Ralt_DT_unb_fSU(i),eps_DT_unb_fSU(i)] = try_with_prec(ntry_max, ntry_step, seuil, snrdB_tab(i), ncc, ll, Mt, Mr, epsilon, prec, infos_unb);
    
    infos_dsss = sprintf('DT bound for fSU DSSS at SNR = %d', snrdB_tab(i));
    disp(infos_dsss);
    ncc = nc * nSF;
    ll = l;
    [R_DT_dsss_fSU(i),Ralt_DT_dsss_fSU(i),eps_DT_dsss_fSU(i)] = try_with_prec(ntry_max, ntry_step, seuil, snrdB_tab(i) - logG2, ncc, ll, Mt, Mr*G, epsilon, prec, infos_dsss);
end

%% SAVE
save(filename);