function strg=poly2str(coef,names)
if nargin<2 | isempty(names)
   names={'x'};
   dim=1;
elseif iscell(names)
   dim=length(names);
elseif ischar(names)
   names={names};
   dim=1;
end
strg=[];
switch (dim)
case 1,
   for n=1:length(coef)
      if coef(n)
         s=sprintf('%g',coef(n));
         if strcmp(s,'1') & n>1, s='+'; 
         elseif strcmp(s,'-1') & n>1, s='-'; 
         elseif s(1)~='-' & isempty(strg)==0, s=['+' s]; end
         if n==length(coef)-1
            s=[s '{' names{1} '}'];
         elseif n~=length(coef)
            s=[s '{' names{1} '}^{' num2str(length(coef)-n) '}'];
         end
         strg=[strg s];
      end
   end
case 2,
   ord=-3/2+1/2*sqrt(1+8*length(coef));
   n=0;
   for j=0:ord
      for i=0:ord-j
         n=n+1;
         if coef(n)
            s=sprintf('%g',coef(n));
            if strcmp(s,'1') & n>1, s='+'; 
            elseif strcmp(s,'-1') & n>1, s='-'; 
            elseif s(1)~='-' & isempty(strg)==0, s=['+' s]; end
            if i==1
               s=[s '{' names{1} '}' ];
            elseif i>1
               s=[s '{' names{1} '}^{' num2str(i) '}'];
            end
            if j==1
               s=[s '{' names{2} '}'];
            elseif j>1
               s=[s '{' names{2} '}^{' num2str(j) '}'];
            end
            strg=[strg s];
         end
      end
   end
end
if isempty(strg), strg='0'; end
