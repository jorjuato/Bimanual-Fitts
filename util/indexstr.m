function str=indexstr(S)
%Given a subscripting structure array S, such as output by substruct() and
%used in indexing methods SUBSREF and SUBSASGN, a single string STR is
%returned bearing a subscript expression equivalent to that expressed
%by S. This is useful when combined with EVAL() to implement overloaded
%SUBSASGN and SUBSREF methods based on
%already-defined subscript operations.
%
%Usage:
%
% str=indexstr(S)
%
%EXAMPLE:
%
% >>a.g={1 2 3};
% >>M=substruct('.', 'g', '{}', {':'});
% >>str=indexstr(M)
%
% str =
%
% .g{M(2).subs{:}}
%
% >>eval(['a' str]) %equivalent to a.g{:}
%
% ans =
%
% 1
%
%
% ans =
%
% 2
%
%
% ans =
%
% 3

%NOTE: When it exists, the INPUTNAME of S is used in generating STR. Otherwise,
% this name defaults to 'S'
%
%
%See also SUBSTRUCT, INPUTNAME


name=inputname(1);

%DEFAULT
if isempty(name), name='S'; end


%%
str='';

for ii=1:length(S)

 switch S(ii).type

 case '.'



   str=[str '.' S(ii).subs];

 case '()'

   insert=[name '(' num2str(ii) ')'];

   str=[str '(' insert '.subs{:})'];

 case '{}'

   insert=[name '(' num2str(ii) ')'];

   str=[str '{' insert '.subs{:}}'];

 end

end