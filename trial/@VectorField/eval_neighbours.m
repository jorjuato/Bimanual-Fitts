function b = eval_neighbours(a,nhood,fun,params)
    %Applies a funtion iterativelity to an input matrix taking
    %a certain neighbourhood for each point. Boundaries are not
    %handled in a general way, only good for present use (repeting values).

    if nargin<4, params = cell(0,0); end

    [ma,na] = size(a);
    b = zeros([ma,na]);

    for i=1:ma,
        for j=1:na,
            rows=i-floor((nhood(1)-1)/2):i+floor((nhood(1)-1)/2);
            cols=j-floor((nhood(2)-1)/2):j+floor((nhood(2)-1)/2);
            cols(cols<1)=1; cols(cols>na)=na;
            rows(rows<1)=1; rows(rows>ma)=ma;
            b(i,j) = feval(fun,a(rows,cols),params{:});
        end
    end
end % eval_neighbours