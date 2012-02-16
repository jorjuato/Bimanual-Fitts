function get_combined_vf(obj,DS,varargin)
    %Prepare matrices to store PCs
    rep=size(DS,length(dim)+1)-1;
    obj.pc = zeros(0);

    %Compute bin centers
    if obj.use_norm == false
        Xo = obj.get_bincenters(DS,dim);
    else
        Xo = obj.get_bincenters_normalized();
    end
    %Other methods
    %Xo = meshgrid(linspace(-1,1,binnumber)',linspace(-1,1,binnumber)');
    %Xo= binnumber;

    %Sum conditional probability matrices of each replications
    for r=1:rep
        %Compute input vector Y = [x,v]
        if obj.use_norm == false
            if length(dim)==1 && ~isempty(DS{dim,r})
                Y = [DS{dim,r}.x,DS{dim,r}.v];
            elseif strcmp(obj.hand,'L') && ~isempty(DS{dim(1),dim(2),r})
                Y = [DS{dim(1),dim(2),r}.Lx,DS{dim(1),dim(2),r}.Lv];
            elseif strcmp(obj.hand,'R') && ~isempty(DS{dim(1),dim(2),r})
                Y = [DS{dim(1),dim(2),r}.Rx,DS{dim(1),dim(2),r}.Rv];
            else
                continue
            end
        else
            if length(dim)==1 && ~isempty(DS{dim,r})
                Y = [DS{dim,r}.xnorm,DS{dim,r}.vnorm];
            elseif strcmp(obj.hand,'L') && ~isempty(DS{dim(1),dim(2),r})
                Y = [DS{dim(1),dim(2),r}.Lxnorm,DS{dim(1),dim(2),r}.Lvnorm];
            elseif strcmp(obj.hand,'R') && ~isempty(DS{dim(1),dim(2),r})
                Y = [DS{dim(1),dim(2),r}.Rxnorm,DS{dim(1),dim(2),r}.Rvnorm];
            else
                continue
            end
        end
        %display(sprintf('Computing replication %d',r));
        [~, xo, pctmp]=obj.prob_2D(Y,Xo,obj.step,obj.minValsToComputeCondProb);
        if isempty(obj.pc)
            obj.pc = pctmp;
        else
            obj.pc = obj.pc + pctmp;
        end
    end
    % Promediate PC
    obj.pc = obj.pc/rep;
    obj.xo = xo;
end %get_replications_vf

