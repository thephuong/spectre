%% This script tries to reobtain the curve of DT bound and MC bound in the manual for Rayleigh Block Fading No CSI
%%

addpath('../rayleigh-block-fading-no-csi/');
n = 168;
% l_tab = [1 2 4 7 14 21 28 42];
% l_tab = [1 2 4 7 14 21];
l_tab = [1 2 4 7];

Mt = 2;
Mr = 2;
epsilon = 0.001;
snrdB = 6;

%% FILENAME
s = date();
s(s == '-') = '_';
filename = strcat(s, 'example_block_rayleigh_no_csi.mat');

%% RUN MODE
MODE = [0, ...  %DT bound only
    1, ...      %MC bound only with original code
    1];         %MC bound only with new code
DT_index = 1;
original_MC_index = 2;
new_MC_index = 3;

%% CODE
if MODE(DT_index) == 1,
    prec = round(log2(100/epsilon));
    R_DT = zeros(size(l_tab));
    for i = 1:length(l_tab)
        l = l_tab(i);
        nc = round(n/l);
        fprintf(1, 'DT bound for nc=%d l=%d\n', nc, l);
        [R_DT(i), current_eps] = DT_USTM(snrdB,nc,l,Mt,Mr,epsilon,prec,'');
        if (abs(current_eps - epsilon) > 0.0001)
            error('Prec too small');
        end
    end
end

if (MODE(original_MC_index) == 1 || MODE(new_MC_index) == 1),
    R_MC_opt = zeros(size(l_tab));
    for i = 1:length(l_tab)
        l = l_tab(i);
        nc = round(n/l);
        fprintf(1, 'MC bound for nc=%d l=%d\n', nc, l);
        rr1 = -1;
        if (MODE(original_MC_index) == 1)
            rr1 = compute_MC_2x2_telatar(snrdB, nc , l, epsilon);
            disp(rr1);
        end
        
        % New code
        rr2 = -1;
        if (MODE(new_MC_index) == 1)
            rr2 = compute_MC_2x2_telatar_MC_Mt_x_Mr(snrdB, nc , l, epsilon);
            disp(rr2);
        end
        R_MC_opt(i) = rr1;
        fprintf(1, 'rr1=%f rr2=%f\n', rr1, rr2);
    end    
end
save(filename);