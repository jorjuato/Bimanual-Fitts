function s = subsref(r, subscript)
%SUBSREF Loop through the array of subscript structures. Initialize the referenced object
% to the input. Whenever the referenced object remaining from the previous iteration is a
% myclass, evaluate the subscript reference and return a new referenced object. Whenever
% the referenced object remaining from the previous iteration is not a myclass object, call
% the appropriate subscript reference function.

    s = r; % Initialize the referenced object to the input.
    
    % Loop through the array of subscript structures.
    while ~isempty(subscript)
        % Peel off next subscript for processing.
        thisSubscript = subscript(1);
        if isa(s, 'Participant') % See if the referenced object is a myclass object.        
            % process next subscript
            switch thisSubscript.type  
                case '()' % parentheses
                    if length(s) > 1
                        s = s(thisSubscript.subs{:});
                    else
                        switch thisSubscript.subs{:}
                            case 2
                                s = s.sessions(4);
                            case 3
                                s= s.sessions(7);
                            otherwise
                                s = s.sessions(thisSubscript.subs{:});
                        end
                    end
                    %error('Improper subscript reference for myclass object.')
                case '{}'
                    %s = curlybraces(s);
                    error('Improper subscript reference for Participant object.')
                case '.'
                    if ismethod(s, thisSubscript.subs)
                        str=indexstr(subscript);
                        eval(['s' str ';']) ;
                        subscript=[];
                    else
                        str=indexstr(thisSubscript);
                        s=eval(['s' str ';']) ;
                    end
                otherwise
                    error('Improper subscript reference for Participant object.')            
            end

        else % If referenced object isn't a myclass object, then callanother subsref.        
            s = subsref(s, thisSubscript); % Matlab will choose the subsrefappropriate for s.        
        end

        subscript = subscript(2:end); % Remove this (just processed) subscript from list.
    end
end
