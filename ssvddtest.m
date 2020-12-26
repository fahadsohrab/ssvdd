function varargout=ssvddtest(Testdata,testlabels,ssvddmodel)
%ssvddtest() is a function for testing a model based on "Subspace Support
%Vector Data Description"
% Input
%   Testdata  = Contains testing data from
%   Testlabels= contains original test lables
%   ssvddmodel= contains the output obtained from "ssvddmodel=ssvddtrain(Traindata,varargin)"
% Output      
%   output argument #1 = predicted labels
%   output argument #2 = accuracy 
%   output argument #3 = sensitivity (True Positive Rate)
%   output argument #4 = specificity (True Negative Rate)
%   output argument #5 = precision 
%   output argument #6 = F-Measure
%   output argument #7 = Geometric mean i.e, sqrt(tp_rate*tn_rate)
%Example
%[predicted_labels,accuracy,sensitivity,specificity]=ssvddtest(Testdata,testlabels,ssvddmodel);

Q=ssvddmodel.Q;
Model=ssvddmodel.modelparam{end};
RedTestdata=Q{end}* Testdata;
predict_label = svmpredict(testlabels, RedTestdata', Model);
EVAL = Evaluate_SSVDD(testlabels,predict_label);
% accuracy =EVAL(1);
% sensitivity =EVAL(2);
% specificity =EVAL(3);
% precision =EVAL(4);
% f_measure =EVAL(5);
% gmean=EVAL(6);
varargout{1}=predict_label;
for jj=2:7
    varargout{jj}=EVAL(jj-1);
end
end
