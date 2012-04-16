function [D,xo,names]=KMcoef_2D(xo,pc,dt,ord)
%[D,x,names]=KMcoef_2D(xo,pc,dt,ord)
%Computation of Kramers-Moyal coefficients
%
% input:  - xo bin centers of the cond. probability distribution
%         - pc conditional probability distribution (see prob_2D)
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
j=1;
for k=1:length(ord)
   for n1=ord(k):-1:0
      for n2=ord(k):-1:0
         if sum([ n1 n2 ])==ord(k), names{j}=[ n1 n2 ]; j=j+1; end
      end
   end
end
D=cell(length(names),1);
for k=1:length(names)
   pcc=pc;
   if names{k}(1)==1
      for i=1:length(xo{1})
         for j=1:length(xo{1})
            pcc(i,:,j,:)=pcc(i,:,j,:)*(xo{1}(i)-xo{1}(j));
         end
      end
   elseif names{k}(1)
      for i=1:length(xo{1})
         for j=1:length(xo{1})
            pcc(i,:,j,:)=pcc(i,:,j,:)*(xo{1}(i)-xo{1}(j))^(names{k}(1));
         end
      end
   end
   if names{k}(2)==1
      for i=1:length(xo{2})
         for j=1:length(xo{2})
            pcc(:,i,:,j)=pcc(:,i,:,j)*(xo{2}(i)-xo{2}(j));
         end
      end
   elseif names{k}(2)
      for i=1:length(xo{2})
         for j=1:length(xo{2})
            pcc(:,i,:,j)=pcc(:,i,:,j)*(xo{2}(i)-xo{2}(j))^(names{k}(2));
         end
      end
   end
   for n=1:2
      pcc=squeeze(trapz(xo{n},pcc,1));
   end
   D{k}=(1/factorial(sum(names{k})))*(1/dt)*permute(pcc,[2,1,3:ndims(pcc)]);
   pack;
end
