function [R,Ralt,current_eps] = try_with_prec(ntry_max, ntry_step, seuil, snrdB, nc, l, Mt, Mr, epsilon, prec, infos)

addpath('../rayleigh-block-fading-no-csi/');

simuok = 0;
for ntry = 1:ntry_max
    precc = prec + (ntry-1) * ntry_step;
    disp([infos '. Trying prec=' num2str(precc) ' ...']);
    [R, current_eps] = DT_USTM(snrdB, nc, l, Mt, Mr, epsilon, precc,'');
    
%     if (current_eps - epsilon < seuil)
    if (abs(current_eps - epsilon) < seuil)
        simuok = 1;
    end
    infoss = sprintf('. Tried=%d/%d prec=%d R=%.5f epsilon=%.5f current_eps=%.5f. OK=%d', ntry, ntry_max, precc, R, epsilon, current_eps, simuok);
    disp([infos infoss]);
    if (simuok == 1)
        break;
    end
end
if ((ntry == ntry_max) && (simuok == 0))
    fprintf(1, 'Warning : %s : Prec too small epsilon=%.5f current_eps=%.5f. R=%.5f --> -1\n\n', infos, epsilon, current_eps, R);
    Ralt = R;
    R = -1;
else
    Ralt = R;
end