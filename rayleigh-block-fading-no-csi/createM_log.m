%% TODO: need to optimize it, i.e. avoid exp(.)
% This function is for creating the M matrix of the equation (22) of the
% article "Short-Packet Communications Over Multiple-Antenna
% Rayleigh-Fading Channels"
function M = createM_log(Mt,Mr,T,Sigma,lambda)
    M = nan(Mr,Mr); %(l is the row, k is the column)
    for l = 1:Mr,
        for k=1:Mt,
%             M(l,k)=(Sigma(l)^(Mt-k))*gammainc(lambda*Sigma(l),T+k-Mt-Mr);
            tmp = (Mt-k)*log(Sigma(l)) + log(gammainc(lambda*Sigma(l),T+k-Mt-Mr));
            M(l,k) = exp(tmp);
        end
        for k=Mt+1:Mr,
%             M(l,k)=(Sigma(l)^(T-k))*exp(-Sigma(l)*lambda); % case Mt<Mr
            tmp = (T-k)*log(Sigma(l)) - Sigma(l)*lambda;
            M(l,k) = exp(tmp);
        end
    end
    if (any(isnan(M(:))) || any(isinf(M(:))))
        error('createM() number overflow');
    end
end