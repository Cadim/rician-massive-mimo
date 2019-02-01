function SE_Theoretical = functionTheoreticalSE_UL_MO( R,HMean,K,L,p,prelogFactor)
%Computes the UL SE with MO estimator in Section IV.D
%Note that the covariance matrices and the mean vectors are same for all
%channel realizations.
%
%This Matlab function was developed to generate simulation results to:
%
%Ozgecan Ozdogan, Emil Bjornson, Erik G. Larsson, “Massive MIMO with
%Spatially Correlated Rician Fading Channels,” IEEE Transactions on
%Communications, To appear.
%
%Download article: https://arxiv.org/abs/1805.07972
%
%This is version 1.0 (Last edited: 2019-02-01)
%
%License: This code is licensed under the GPLv2 license. If you in any way
%use this code for research that results in publications, please cite our
%original article listed above.


%Prepare to store  (35) and (36)
CCterm1=zeros(K,L);
CCterm2=zeros(K,L);
CCterm2_p1=zeros(K,L,L,K);

%Prepare to store UL SE
SE_Theoretical=zeros(K,L);

% Go through all BSs
for j = 1:L
    
    %Go through all UEs
    for k = 1:K
        %Compute (35) in Section IV.D
        CCterm1(k,j)=norm(HMean(:,k,j,j))^2;
        
        %Go through all UEs
        for lx=1:L
            for i=1:K
                %Calculate (36) in Section IV.D
                CCterm2_p1(k,j,lx,i)= p*HMean(:,k,j,j)'*R(:,:,i,lx,j)*HMean(:,k,j,j)+ p*abs(HMean(:,k,j,j)'*HMean(:,i,lx,j))^2;
            end
        end
        
        %Sum all the interferences from all UEs
        CCterm2(k,j)=sum(sum(CCterm2_p1(k,j,:,:),3),4);
    end
end

%Compute the SE with (37) for each UE
for k=1:K
    for j=1:L
        SE_Theoretical(k,j)=prelogFactor*real(log2(1+ (p*abs(CCterm1(k,j))^2)/(CCterm2(k,j) -p*abs(CCterm1(k,j))^2 + CCterm1(k,j))));
    end
end


end
