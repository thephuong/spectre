%% (TPN) This function is the generalization of the functions MC_USTM_2x2 and MC_USTM_4x4 for arbitrary Mr
% Tested :
% - compared with MC_USTM_2x2 (see example_durisi.m)
% 
% pow_all is a L x Mt matrix. Each row is distribution power of
% the realization fading block index l over Mt antenna. Sum of a row of Mt elements must be 1.
%%
function [R,current_eps,current_prec]=MC_USTM_Mt_x_Mr(snrdB,T,L,Mtalt,Mt,Mr, ...
    epsilon,prec,pow_all,filename)
%
% note: 
%-------------------------------------------------------------------
%                       SET-UP PARAMETERS
%-------------------------------------------------------------------
SAVE=0;
MAT=0; % if set, the .mat extension is used to save the file

K = 2^prec; % number of monte carlo simulations (at least 100 x 1/epsilon)
rho = 10.^(snrdB/10); % SNR in linear scale

% Mr=2;
% Mt=2;

%-------------------------------------------------------------------
%                       MONTE CARLO SIMULATION
%-------------------------------------------------------------------
Ip = zeros(K,1); %allocate for the montecarlo runs
%-------------------------------------------------------------------
%                       CONSTANTS
%-------------------------------------------------------------------
rho_tilde = T*rho/Mtalt;

lambda=1+rho_tilde;
lambda1=1/lambda;
lambda2=rho_tilde*lambda1;
c2 = logComplexGammaRatio(Mtalt,Mr,T); %gamma constant

% P = max(Mt,Mr);

%Optim
xx = Mtalt *rho_tilde * pow_all; % or just T*rho*pow_all_frac, i.e. fraction of power over Mt antenna (col) for each block l (row)
const_tab = -Mr*sum(log(1+xx), 2) + Mtalt*(T-Mtalt)*log(lambda2) + Mr*Mtalt*log(lambda) + c2;

%-------------------------------------------------------------------
%                       MONTE CARLO
%-------------------------------------------------------------------
noise_norm=sqrt(.5);
% can be replaced by parfor
for k=1:K
        i_Lp = 0;  
        Z = randn(T,Mr,L)*noise_norm+1i*randn(T,Mr,L)*noise_norm; 

        %Create each realization
        for l = 1:L
%             x1=(Mtalt/Mt)*rho_tilde*(2*pow_all(l));
%             x2=(Mtalt/Mt)*rho_tilde*2*(1-pow_all(l));
%             D= [diag([sqrt(1+x1), sqrt(1+x2)]), zeros(Mt,T-Mt);
%     zeros(T-Mt,Mt), eye(T-Mt)]; % D matrix (covariance matrix of equivalent noise)
%             c1 = Mtalt*(T-Mtalt)*log(lambda2) + Mr*Mtalt*log(lambda) + Mr*log(1/(1+x1))+Mr*log(1/(1+x2)); % SNR constant
%             const = c1+c2;

            %pow_all_frac is Mt-dimension showing the fraction of power
            %over Mt tx antenna : sum(pow_all_frac) = 1
            % (Mtalt/Mt)*rho_tilde == T*rho/Mt
            
            % Optim
%             x = Mtalt *rho_tilde * pow_all_frac(l,:);

            % D matrix (covariance matrix of equivalent noise)
            D = [diag(sqrt(1+xx(l,:))), zeros(Mt,T-Mt);
                zeros(T-Mt,Mt), eye(T-Mt)];
            const = const_tab(l);
            
            % compute samples of information density log dPy|x/dQy for y~ Py|x
            
            Sigma=svd(D*Z(:,:,l)).^2; 
            SigmaAlt=Sigma*lambda2;
            
            % Create matrix M, automatic
            M = createM(Mtalt,Mr,T,Sigma,lambda2);
            logdetM=log(det(M));
            vanderTerm = det(vander(Sigma)); %get the determinant of the vandermode matrix
            TraceZ=real(trace(Z(:,:,l)'*Z(:,:,l)));
            logDetSigma = (T-Mr)*sum(log(Sigma));% compute det(Sigma^(T-M))
            
            ip = const- TraceZ  + lambda1*sum(Sigma) - logdetM + log(vanderTerm) + logDetSigma;%Information density for time l (i(x_l, y_l)
            i_Lp = i_Lp + ip; %add it to the total i_L
            
%             % Create matrix M, manual
%             if (Mtalt==1)
%                 a1=gammainc(lambda2*Sigma(1),T-2);
%                 a2=gammainc(lambda2*Sigma(2),T-2);
%                 sigmaprod=(Sigma(1)/Sigma(2))^(T-2);
%                 expratio=exp(-lambda2*(Sigma(1)-Sigma(2)));
%                 a3= (a2/a1)*sigmaprod * expratio;         
%                 logdetM=log(a1) +(T-2)*log(Sigma(2))-Sigma(2)*lambda2+log( 1- a3);
%                 vanderTerm = det(vander(Sigma)); %get the determinant of the vandermode matrix
%                 TraceZ=real(trace(Z(:,:,l)'*Z(:,:,l)));
%                 logDetSigma = (T-Mr)*sum(log(Sigma));% compute det(Sigma^(T-M))
%                 ip = const- TraceZ  + lambda1*sum(Sigma) - logdetM + log(vanderTerm) + logDetSigma;%Information density for time l (i(x_l, y_l)
%             else
%                 M=[Sigma(1)*gammainc(SigmaAlt(1),T-3), gammainc(SigmaAlt(1),T-2); ...
%                 Sigma(2)*gammainc(SigmaAlt(2),T-3), gammainc(SigmaAlt(2),T-2)];
%                 detM = det(M); %get the determinant
%                 vanderTerm = det(vander(Sigma)); %get the determinant of the vandermode matrix
%                 logdetM=log(detM);
%                 TraceZ=abs(trace(Z(:,:,l)'*Z(:,:,l)));
%                 logDetSigma = (T-Mr)*sum(log(Sigma));% compute det(Sigma^(T-M))
%                 ip = const- TraceZ  + lambda1*sum(Sigma) - logdetM + log(vanderTerm) + logDetSigma;%Information density for time l (i(x_l, y_l)
%             end
%             i_Lp = i_Lp + ip; %add it to the total i_L
            
        end
        Ip(k) =  i_Lp; %put all computations on a pile to compute the average later
end
  


if (SAVE==1) 
  if (MAT==1)
    save(filename,'Ip')
  else
    save(filename,'Ip','-ascii','-append')
  end
end





%---------------------------------------
%   SEARCHING THE RATE
%--------------------------------------- 

% load saved data (to account for append possibilities)
if (SAVE==1 && MAT==0)

    Ip=load(filename);
end

Ip=sort(Ip);

Kcurrent=length(Ip); % redefine K to account for append

current_prec=floor(log2(Kcurrent)); % actual precision

K=2^(current_prec); % round off K to avoid search errors


% first find a suitable initial point for the linear search
step=K/2;
index=step;

onevec=ones(K,1);

while(step>1),
    
   th=Ip(index);
   
   current_eps=sum(Ip<=th)/K;
   
   step=step/2;
   
   if current_eps> epsilon,
       
       index=index-step;
       
   else
       
       index=index+step;
       
   end
   
end

current_eps=sum(Ip<=Ip(index))/K; 

if(current_eps<epsilon)
    index=index+1;
end




%complete search--somewhat slower
% for ii=1:K-index+1,
%
%     current_rate=Ip(ii+index-1)-log(sum(Ip<=Ip(ii+index-1))/K-epsilon);
%
%     Rvect(ii)=current_rate;
%
% end
% R=min(Rvect)/(L*T*log(2));
    
%faster search (potentially less tight)

count=0;

R=Ip(index)-log(sum(Ip<=Ip(index))/K-epsilon);

% can be replaced by parfor
for ii=1:K-index+1, 
    current_rate=Ip(ii+index-1)-log(sum(Ip<=Ip(ii+index-1))/K-epsilon);  
    if current_rate<= R
        R=current_rate;
     else
       count=count+1;
    end
     
    if count==20,
      break
    end
end
R=R/(L*T*log(2)); 

end

function val = logComplexGammaRatio(Mt,Mr,T)
    k=T-min(Mt,Mr)+1:1:T;
    val = -sum(gammaln(k));
    % New, however this term is relatively small and can be ignored
    if (Mt > 2)
        %because gammaln(1) = gammaln(2) = 0
        val = val + sum(gammaln(3:Mt));
    end
end

function M = createM(Mt,Mr,T,Sigma,lambda)
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

                