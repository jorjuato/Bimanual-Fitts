function disp(obj)
    props = properties(obj);
    fprintf('\nProperties of object Oscillations...\n');
    for i=1:length(props)
        p=obj.(props{i});
        %if ~isa(p,'Config') && ~isa(p,'TimeSeriesBimanual') && ~isa(p,'TimeSeriesUnimanual') 
        if isnumeric(p)
            fprintf('%10s = %2.3f +/- %1.3f\n', props{i}, mean(p),std(p));
        end
    end
    fprintf('\n');
end
