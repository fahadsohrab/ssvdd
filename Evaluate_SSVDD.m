 function EVAL = evaluate_pred(ACTUAL,PREDICTED)
% This fucntion evaluates the performance of a SSVDD model by 
% calculating the common performance measures: Accuracy, tp_rate, 
% Precision, F-Measure, G-mean.
% Input: ACTUAL = Column matrix with actual class labels of the training
%                 examples
%        PREDICTED = Column matrix with predicted class labels by the
%                    classification model
% Output: EVAL = Row matrix with all the performance measures
idx = (ACTUAL()==1);
p = length(ACTUAL(idx));
n = length(ACTUAL(~idx));
N = p+n;
tp = sum(ACTUAL(idx)==PREDICTED(idx));
tn = sum(ACTUAL(~idx)==PREDICTED(~idx));
fp = n-tn;
tp_rate = tp/p;
tn_rate = tn/n;
accuracy = (tp+tn)/N;
precision = tp/(tp+fp);
precision(isnan(precision))=0; 
recall = tp_rate;
f_measure = 2*((precision*recall)/(precision + recall));
f_measure(isnan(f_measure))=0;  
tp_rate(isnan(tp_rate))=0; tp_rate(isnan(tp_rate))=0; tn_rate(isnan(tn_rate))=0; 
gmean = sqrt(tp_rate*tn_rate);
EVAL = [accuracy tp_rate tn_rate precision f_measure gmean];
 end
