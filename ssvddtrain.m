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
%
% Output      :ssvdd.modelparam = Trained model (for every iteration)
%             :ssvdd.Q= Projection matrix (after every iteration)
%Example
%Model=ssvddtrain(Traindata,'C',0.12,'d',2,'eta',0.02,'psi',3);

p = inputParser;
    defaultVal_maxIter = 100;
    defaultVal_Cval = 0.1;
    defaultVal_d = 1;
    defaultVal_eta = 0.001;
    defaultVal_psi=1;
    defaultVal_b=0.01;

addParameter(p,'maxIter',defaultVal_maxIter)
addParameter(p,'C',defaultVal_Cval)
addParameter(p,'d',defaultVal_d)
addParameter(p,'eta',defaultVal_eta)
addParameter(p,'psi',defaultVal_psi)
addParameter(p,'B',defaultVal_b)
parse(p,varargin{:});
    maxIter=p.Results.maxIter;
    Cval=p.Results.C;
    d=p.Results.d;
    eta=p.Results.eta;
    consType=p.Results.psi;
    Bta=p.Results.B;
Trainlabel= ones(size(Traindata,2),1); %Training labels (all +1s)

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
    Sum1_data = Traindata*diag(Alphavector)*Traindata';
    Sum2_data = Traindata*(Alphavector*Alphavector')*Traindata';
    Grad = (2*Q * (Sum1_data-Sum2_data))+ (Bta*const);
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
end
