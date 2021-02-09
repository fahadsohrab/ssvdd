function [ssvdd]=ssvddtrain(Traindata,varargin)
%ssvddtrain() is a function for training a model based on "Subspace Support
%Vector Data Description"
% Input
%    Traindata = Contains training data from a single (target) class for training a model.
%   'maxIter' :Maximim iteraions, Default=100
%   'C'       :Value of hyperparameter C, Default=0.1
%   'd'       :data in lower dimension, make sure that input d<D, Default=1,
%   'eta'     :Used as step size for gradient, Default=0.1
%   'psi'     :regularization term, Default=1 i.e., No regularization term
%             :Other options for psi are 2,3,4 (Please refer to paper for more details)
%   'B'       :Controling the importance of regularization term, Default=0.1
%   'npt'     :1 for Non-linear Projection Trick (NPT)-based non-linear Subspace-SVDD (Default=0, linear)
%   's'       :Hyperparameter for the kernel inside NPT (Default=0.001). 
%
% Output      :ssvdd.modelparam = Trained model (for every iteration)
%             :ssvdd.Q= Projection matrix (after every iteration)
%Example
%Model=ssvddtrain(Traindata,'C',0.12,'d',2,'eta',0.02,'psi',3,'npt',1,'s',0.01);

p = inputParser;
defaultVal_maxIter = 100;
defaultVal_Cval = 0.1;
defaultVal_d = 1;
defaultVal_eta = 0.001;
defaultVal_psi=1;
defaultVal_b=0.01;
defaultVal_npt=0;
defaultVal_s=0.001;

addParameter(p,'maxIter',defaultVal_maxIter)
addParameter(p,'C',defaultVal_Cval)
addParameter(p,'d',defaultVal_d)
addParameter(p,'eta',defaultVal_eta)
addParameter(p,'psi',defaultVal_psi)
addParameter(p,'B',defaultVal_b)
addParameter(p,'npt',defaultVal_npt)
addParameter(p,'s',defaultVal_s)
parse(p,varargin{:});
maxIter=p.Results.maxIter;
Cval=p.Results.C;
d=p.Results.d;
eta=p.Results.eta;
consType=p.Results.psi;
Bta=p.Results.B;
npt=p.Results.npt;
kappa=p.Results.s;
Trainlabel= ones(size(Traindata,2),1); %Training labels (all +1s)

    if(npt~=1)&&(npt~=0)
    msg = 'Error in ssvddtrain() input: npt value should be either 1 for non-linear data description, or 0 (defaullt if no argument is passed) for linear data description.';
    error(msg)
    end

if npt==1
    disp('NPT bases non-linear S-SVDD running...')
    %RBF kernel
    N = size(Traindata,2);
    Dtrain = ((sum(Traindata'.^2,2)*ones(1,N))+(sum(Traindata'.^2,2)*ones(1,N))'-(2*(Traindata'*Traindata)));
    sigma = kappa * mean(mean(Dtrain));  A = 2.0 * sigma;
    Ktrain = exp(-Dtrain/A);
    %center_kernel_matrices
    N = size(Ktrain,2);
    Ktrain = (eye(N,N)-ones(N,N)/N) * Ktrain * (eye(N,N)-ones(N,N)/N);
    [U,S] = eig(Ktrain);        s = diag(S);
    s(s<10^-6) = 0.0;
    [U, s] = sortEigVecs(U,s);  s_acc = cumsum(s)/sum(s);   S = diag(s);
    II = find(s_acc>=0.999);
    LL = II(1);
    Pmat = pinv(( S(1:LL,1:LL)^(0.5) * U(:,1:LL)' )');
    %Phi
    Phi = Pmat*Ktrain;
    %Saving useful variables for non-linear testing
    npt_data={1,A,Ktrain,Phi,Traindata};%1,A,Ktrain,Phi,Traindata (1 is for flag)
    Traindata=Phi;
else
    disp('Linear S-SVDD running...')
end

Q = initialize_Q(size(Traindata,1),d);
reducedData=Q*Traindata;
Model = svmtrain(Trainlabel, reducedData', ['-s ',num2str(5),' -t 0 -c ',num2str(Cval)]);
for ii=1:maxIter
    %Get the alphas
    Alphaindex=Model.sv_indices; %Indices where alpha is non-zero
    AlphaValue=Model.sv_coef;    %values of Alpha
    Alphavector=zeros(size(reducedData,2),1);
    for i=1:size(Alphaindex,1)
        Alphavector(Alphaindex(i))=AlphaValue(i);
    end
    const= constraintssvdd(consType,Cval,Q,Traindata,Alphavector);
    %compute the gradient and update the matrix Q
    Sa = Traindata*(diag(Alphavector) - Alphavector*Alphavector')*Traindata';
    Grad=(2*Q*Sa)+(Bta*const);
    Q = Q - eta*Grad;
    %orthogonalize and normalize Q1
    Q = OandN_Q(Q);
    reducedData = Q * Traindata;
    Model = svmtrain(Trainlabel, reducedData', ['-s ',num2str(5),' -t 0 -c ',num2str(Cval)]);
    Qiter{ii}=Q;
    Modeliter{ii}=Model;
end
ssvdd.modelparam= Modeliter;
ssvdd.Q= Qiter;

if npt==1
ssvdd.npt=npt_data;
else
ssvdd.npt{1}=0;
end

end
