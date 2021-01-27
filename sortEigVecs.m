% Input:
% evls: not sorted eigenvalues (row vector)
% evs: not sorted eigenvactors (columns)
% m: number of eigenvectors/eigenvalues to keep
%
% Output:
% mevcs: maximun eigenvectors in descending order
% mevls maximun eigenvalues in descending order
function [mevcs, mevls] = sortEigVecs(evs,evls,type)

if nargin < 3,  type = 'descend';  end
nans_found = sum(isnan(evls));      complex_found = sum( imag(evls) ~=0 ); 
if nans_found~=0,    evls(isnan(evls)) = min(evls)*10^(-1)*ones(nans_found,1);       end % replace NANs with smallest value
if complex_found~=0, evls(imag(evls)~=0) = min(evls)*10^(-1)* ones(complex_found,1); end % replace complex numbers with smallest value

nans_found = sum(isnan(evs));      complex_found = sum( imag(evs) ~=0 ); 
if nans_found~=0,    evs(isnan(evs)) = 0;     end % replace NANs with smallest value
if complex_found~=0, evs(imag(evs)~=0) = 0;   end % replace complex numbers with smallest value


% sort eigenvalues
[auxv, auxi] = sort(evls,type);     clear auxv; 

% sort eigenvectors
for i=1:length(evls);
    idx = auxi(i); % get index of ith eigenvalue 
    mevls(:,i) = evls(idx); % get ith eigenvalue
    mevcs(:,i) = evs(:,idx); % get ith eigenvector
end
