% function B = subsref(obj,ref)
% % Re-implement dot referencing for methods.
% if strcmp(ref(1).type, '.')
%     % User trying to access a method
%     % Methods access
%     if ismember(ref(1).subs, methods(obj))
%         if length(ref) > 1
%             % Call with args
%             B = obj.(ref(1).subs)(ref(2).subs{:});
%         else
%             % No args
%             B = obj.(ref.subs);
%         end
%         return;
%     elseif ismember(ref(1).subs, properties(obj))
%         B = obj.(ref.subs);
%         return;
%     end
%     % User trying to access something else.
%     error(['Reference to non-existant property or method ''' ref.subs '''']);
% end
% switch ref(1).type
%     case '{}'
%         B = obj.sessions(ref(1).subs{1});
%     case '()'
%         error('() indexing not supported.');
%     otherwise
%         error('Should never happen');
% end
% end

function B = subsref(obj,S)
if length(S) > 1
    if strcmp(S(1).type,'{}')
        if length(S(1).subs) == 2
            %tmp = obj.data_set{S(1).subs{1},S(1).subs{2}};
            B = obj.data_set{S(1).subs{1},S(1).subs{2}};
        else
            %tmp = obj.data_set{S(1).subs{1},S(1).subs{2},S(1).subs{3}};
            B = obj.data_set{S(1).subs{1},S(1).subs{2},S(1).subs{3}};
        end
        %B = tmp.subsref(S(2:end));
    else
        disp('Wrong access method for class Block')
    end
elseif strcmp(S.type,'{}')
    if length(S.subs) == 2
        B = obj.data_set{S.subs{1},S.subs{2}};
    else
        B = obj.data_set{S.subs{1},S.subs{2},S.subs{3}};
    end
else
    disp('Wrong access method for class Block')
end
end