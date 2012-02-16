function B = subsref(obj,ref)
    % Re-implement dot referencing for methods.
    if strcmp(ref(1).type, '.')
        % User trying to access a method
        % Methods access
        if ismember(ref(1).subs, methods(obj))
            if length(ref) > 1
                % Call with args
                B = obj.(ref(1).subs)(ref(2).subs{:});
            else
                % No args
                B = obj.(ref.subs);
            end
            return;
        elseif ismember(ref(1).subs, properties(obj))
            B = obj.(ref.subs);
            return;
        end
        % User trying to access something else.
        error(['Reference to non-existant property or method ''' ref.subs '''']);
    end
    switch ref(1).type
        case '()'
            B = obj.sessions(ref(1).subs{1});                    
        case '{}'
            error('() indexing not supported.');
        otherwise
            error('Should never happen');
    end
end
