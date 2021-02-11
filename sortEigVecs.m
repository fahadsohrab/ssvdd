function [mevcs, mevls] = sortEigVecs(evcs,evls,type)
% Input:
% evls: not sorted eigenvalues (row vector)
% evs: not sorted eigenvactors (columns)
%
% Output:
% sorted eigenvalues and eigenvectors

if nargin < 3,  type = 'descend';  end

%Clean
if isreal(evls)==0
    evcs = abs(evcs); 
    evls = abs(evls);
end
evls(isinf(evls))=0.0; 
evls(isnan(evls))=0.0; 
evcs(isinf(evcs))=0.0; 
evcs(isnan(evcs))=0.0;

%Round near-zero eigenvalues to zero
evls(evls<10^-6) = 0.0;

%Sort eigenvalues and remove zeros
[auxv, auxi] = sort(evls,type);
mevls = auxv;
mevcs = evcs(:,auxi);
mevcs = mevcs(:,mevls > 0);
mevls = mevls(mevls > 0);

%If there are no positive eigenvalues, return zeros
if isempty(mevls)
    mevls = 0.0;
    mevcs = zeros(length(evls), 1);
end
