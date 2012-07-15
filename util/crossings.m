function [ind] = crossings(S, val)
if nargin==1, val=0; end

ind0 = find(S==val); %find amplitudes which are exactly zero 
S1=S-val;
S2 = S1(1:end-1) .* S1(2:end); 
ind1 = find(S2< 0); 
ind_all_unsort = [ind0 ind1]; 
ind = sort(ind_all_unsort);%sorts values in ascending order 
