% This fucntion is used to compute regularization term for "Subspace support vector data description"
% Input:  ConsType = type of regularization (psi) used 1,2,3,4
%         Cval= a hyperparameter C value from to identify support vectors etc
%         Q= Projection matrix
%         Traindata = contains training data
%         Alphavector = contains corresponding alpha vectors 
% Output: const = The regularization term expresses
function const= constraintssvdd(consType,Cval,Q,Traindata,Alphavector)
if consType==1
      const=0;
elseif consType==2
    const= (2*Q*(Traindata*Traindata'));
elseif consType==3
    const= (2*Q*(Traindata*(Alphavector*Alphavector')*Traindata'));
elseif consType==4
  Alphavector_C=Alphavector;
  Alphavector_C(Alphavector_C==Cval)=0;
 const= (2*Q*(Traindata*(Alphavector_C*Alphavector_C')*Traindata'));
else
       disp('Only psi 1,2,3 or 4 is possible')
end

end
