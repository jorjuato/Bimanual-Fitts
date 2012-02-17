function validS = getValidSessions(obj,blockname)
    if nargin < 2, blockname = ''; end
    
    validS = [];
    S=obj.sessions;
    if ~isempty(blockname)
        for i=1:length(S)
            if ~isempty(S(i).(blockname))
                validS = [validS,i];
            end
        end
    else
        for i=1:length(S)
            if ~isempty(S(i).bimanual) && ~isempty(S(i).uniLeft) && ~isempty(S(i).uniRight)
                validS = [validS,i];
            end
        end
    end
end