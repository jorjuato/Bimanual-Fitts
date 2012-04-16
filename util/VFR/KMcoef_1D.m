function [D,xo,names]=KMcoef_1D(xo,pc,dt,ord)
%[D,x,names]=KMcoef_1D(xo,pc,dt,ord)
%Computation of Kramers-Moyal coefficients
%
% input:  - xo bin centers of the cond. probability distribution
%         - pc conditional probability distribution (see prob_1D)
%         - dt (the real) time step
%         - ord order of the KM-coefficient(s), e.g., [1,2,4]
%
% output: - D cell-array containing the KM coefficients
%         - xo bin centers (see above)
%         - names integer array giving the 'names' of the KM coefficients
%
%                            (c) A. Daffertshofer 02/04
%
% created by makefunction_KMcoef [25-Mar-2004 16:05:34]

D=cell(length(ord),1);
for k=1:length(ord)
   pcc=pc;
   if ord(k)==1
      for i=1:length(xo{1})
         for j=1:length(xo{1})
            pcc(i,j)=pcc(i,j)*(xo{1}(i)-xo{1}(j));
         end
      end
   elseif ord(k)
      for i=1:length(xo{1})
         for j=1:length(xo{1})
            pcc(i,j)=pcc(i,j)*(xo{1}(i)-xo{1}(j))^(ord(k));
         end
      end
   end
   D{k}=(1/factorial(ord(k)))*(1/dt)*squeeze(trapz(xo{1},pcc,1))';
   names{k}=ord(k);
   pack;
end
