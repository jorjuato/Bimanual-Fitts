function [D,xo,names]=KMcoef_nD(xo,pc,dt,ord)
%[D,x]=KMcoef_nD(xo,pc,dt,ord) computation of Kramers-Moyal coefficients
%
% input:  - xo bin centers of the cond. probability distribution
%         - pc conditional probability distribution (see prob_nD)
%         - dt (the real) time step
%         - ord order of the KM-coefficient(s), e.g., [1,2,4]
%
% output: - D cell-array containing the KM coefficients
%         - xo bin centers (see above)
%         - names integer array giving the 'names' of the KM coefficients
%
%                            (c) A. Daffertshofer 02/04
dim=length(xo);
cr=sprintf('\n');
ta=sprintf('\t');
fstrg=['j=1;' cr 'for k=1:length(ord)' cr];
nn=zeros(1,dim);
for d=1:dim
   fstrg=[fstrg repmat(ta,1,d) 'for n' num2str(d) '=ord(k):-1:0' cr];
end
nstrg='[';
for d=1:dim,
   nstrg=[nstrg ' n' num2str(d)];
end
nstrg=[nstrg ' ]'];
fstrg=[fstrg repmat(ta,1,dim+1) 'if sum(' nstrg ')==ord(k), ' 'names{j}=' nstrg '; j=j+1; end' cr];
for d=dim:-1:1
   fstrg=[fstrg repmat(ta,1,d) 'end' cr];
end;
fstrg=[fstrg 'end'];
eval(fstrg);
M=repmat(size(xo,1),1,size(xo,2));
ind=repmat(':,',1,length(M)); ind=ind(1:end-1);
D=cell(length(names),1);
for k=1:length(names)
   strg=[];
   for l=1:dim
      if names{k}(l)
         ind2=[ind ',' ind]; 
         ind2(2*l-1)='i';
         ind2(2*l+length(ind))='j';
         strg=[strg ...
               'for i=1:' num2str(length(xo{l})) ',' ...
               'for j=1:' num2str(length(xo{l})) ',' ...
               'pcc(' ind2 ')=(xo{' num2str(l) '}(i)-xo{ ' num2str(l) '}(j))'];
         if names{k}(l)>1
            strg=[strg '^' num2str(names{k}(l))];
         end
         strg=[strg '*pcc(' ind2 ');end,end,'];
      end
   end
   pcc=pc;
   eval(strg);
   pack;
   for i=1:size(xo,2)
      pcc=squeeze(trapz(xo{i},pcc,1));
   end
   D{k}=(1/factorial(sum(names{k})))*(1/dt)*permute(pcc,[2,1,3:ndims(pcc)]);
   pack;
end
