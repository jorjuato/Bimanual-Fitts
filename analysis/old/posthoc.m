function mdl=posthoc(vname,data,vnames,factors,order)
    if nargin<5, order='Lineal'; end
    if nargin<4, error('need bimanual data and variable names');end    
    
    switch length(factors)        
        case 0
        case 1
            error('Not implemented')
        case 2 % {grp-id[l,r]} {ss-id[l,r]} {idl-idr}
            mdl=do_two_factors(vname,data,vnames,factors,order);
        case 3 % {grp-ss-id[l,r]} {ss-idl-idr} {grp-idl-+idr}
            mdl=do_three_factors(vname,data,vnames,factors,order);
        case 4 %{grp-ss-idl-idr}
            mdl=do_four_factors(vname,data,vnames,factors,order);            
    end
    print_posthoc_table(mdl,factors)
end

function lm=do_lm(data,order)
    verbosity=0;
    if length(data)==2
        if verbosity
            lm = LinearModel.fit(data{1}-mean(data{1}),data{2}-mean(data{2}),'quadratic')
        else
            lm = LinearModel.fit(data{1}-mean(data{1}),data{2}-mean(data{2}),'quadratic');
        end
    elseif length(data)==3
        if verbosity
            lm = LinearModel.fit([data{1}-mean(data{1}),data{2}-mean(data{2})],data{3},'interactions')
        else
            lm = LinearModel.fit([data{1}-mean(data{1}),data{2}-mean(data{2})],data{3},'interactions');
        end
    else
        error('bad parameters')
    end
    if verbosity
        disp('anova results')
        anova(lm)
        disp('anova summary')
        anova(lm,'summary')
        disp('Confidence Interval at 95%')
        coefCI(lm)
        disp('Attempt to improve model')
        mdl1 = step(lm,'NSteps',5)    
    %     anova(lm,'summary')
    %     anova(lm)
    %     coefCI(lm)
    %     [p,F,d] = coefTest(lm)
    end    
end

function res = get_model_results(lm)
coefs=length(lm.CoefficientNames);
res=zeros(coefs,6);
coefCI=lm.coefCI;
for i=1:coefs
    res(i,1)=lm.Coefficients.Estimate(i);
    res(i,2)=lm.Coefficients.SE(i);
    res(i,3)=lm.Coefficients.tStat(i);
    res(i,4)=lm.Coefficients.pValue(i);
    res(i,5)=coefCI(i,1);
    res(i,6)=coefCI(i,2);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function print_posthoc_table(tbl,factors)
params={'category','Estimate','SE','tStat','pValue','low','high'};
grps={'Strong','Weak','StrongEff','WeakEff'};
sessions={'S1','S2','S3'};
fmtstr='\t%3.3f \t%3.3f \t%3.3f \t%3.3f \t%3.3f \t%3.3f ';
coefstrfmt=[];
cats={};

disp(params)
if length(size(tbl))==2
    [coefno,values] = size(tbl); 
    row=[];
    coefstrfmt=[];
    for coef=1:coefno
        row=[row,squeeze(tbl(coef,:))];
        coefstrfmt=[coefstrfmt,fmtstr];
    end
    row(row<0.000001)=0;
    fprintf(['%10s',coefstrfmt,'\n'],'none',row);
else
    [catno,coefno,values] = size(tbl);
    if catno==12
        k=0;
        for g=1:length(grps)
            for s=1:length(sessions)
                k=k+1;
                cats{k}=[grps{g},sessions{s}];
            end
        end
    elseif strcmp('grp',factors{1})
        cats=grps;
    elseif strcmp('ss',factors{1})
        cats=sessions;
    end    
    for ct=1:catno
        row=[];
        coefstrfmt=[];
        for coef=1:coefno
            row=[row,squeeze(tbl(ct,coef,:))];
            coefstrfmt=[coefstrfmt,fmtstr];
        end
        fprintf(['%10s',coefstrfmt,' \n'],cats{ct},row);
    end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbl=do_two_factors(vname,data,vnames,factors,order)

if any(strcmp('idl',factors))
    IDefL = rearrange_var_data('IDefL',data,vnames,factors);
end
if any(strcmp('idr',factors))
    IDefR = rearrange_var_data('IDefR',data,vnames,factors);
end
rho = rearrange_var_data('rho',data,vnames,factors);
v = rearrange_var_data(vname,data,vnames,factors);

if strcmp('grp',factors{1})
    if strcmp('idl',factors{2})
        iddata=IDefL;
    elseif strcmp('idl',factors{2})
        iddata=IDefR;
    else
        error('grp-ss factors not supported')
    end
    tbl=zeros(4,2,6);
    for g=1:2
        %Normal grouping
        fprintf('Computing Post-Hoc regresions for group factor %d\n',g)
        x=squeeze(v(g,:));
        y=squeeze(iddata(g,:));
        mdl=do_lm({x,y},order);
        tbl(g,:)=get_model_results(mdl);
    end
    %Efficient grouping
    r=rho(:);
    x=v(:);
    y=iddata(:);
    idx=r==1;
    fprintf('Computing Post-Hoc regresions for Efficient group 1\n')
    mdl=do_lm({x(idx),y(idx)},order);
    tbl(3,:)=get_model_results(mdl);
    fprintf('Computing Post-Hoc regresions for Efficient group 2\n')
    idx=r~=1;
    mdl=do_lm({x(idx),y(idx)},order);
    tbl(4,:)=get_model_results(mdl);    
elseif strcmp('ss',factors{1})
    if strcmp('idl',factors{2})
        iddata=IDefL;
    elseif strcmp('idr',factors{2})
        iddata=IDefR;
    else
        error('grp-ss factors not supported')
    end
    tbl=zeros(3,2,6);
    for s=1:3
        x=squeeze(v(s,:));
        y=squeeze(iddata(s,:));
        %Normal grouping
        fprintf('Computing Post-Hoc regresions for Session %d\n',s)
        mdl=do_lm({x,y},order);
        tbl(s,:)=get_model_results(mdl);
    end
else
    mdl=do_lm({v,IDefL,IDefR},order);
    tbl=get_model_results(mdl);    
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbl=do_three_factors(vname,data,vnames,factors,order)
if any(strcmp('idl',factors))
    IDefL = rearrange_var_data('IDefL',data,vnames,factors);
end
if any(strcmp('idr',factors))
    IDefR = rearrange_var_data('IDefR',data,vnames,factors);
end
rho = rearrange_var_data('rho',data,vnames,factors);
v = rearrange_var_data(vname,data,vnames,factors);
if strcmp('grp',factors{1}) %{grp-  -  }
    if strcmp('ss',factors{2})  %{grp-ss- }
        if strcmp('idl',factors{2}) %{grp-ss-idl}
            iddata=IDefL;
        elseif strcmp('idl',factors{2})  %{grp-ss-idl}
            iddata=IDefR;
        else
            error('not supported')
        end
        tbl=zeros(12,2,6);
        for g=1:2
            for s=1:3
                %Normal grouping
                fprintf('Computing Post-Hoc regresions for group factor %d and session %d\n',g,s)
                x=squeeze(v(g,s,:));
                y=squeeze(iddata(g,s,:));
                mdl=do_lm({x,y},order);
                tbl(s+3*(g-1),:,:)=get_model_results(mdl);
            end
        end
        for s=1:3
            %Efficient grouping
            r=rho(:,s,:);
            r=r(:);
            x=v(:,s,:);
            x=x(:);
            y=iddata(:,s,:);
            y=y(:);
            fprintf('Computing Post-Hoc regresions for Efficient group 1 and session %d\n',s)
            idx=r==1;                        
            mdl=do_lm({x(idx),y(idx)},order);
            tbl(6+2*(s-1)+1,:,:)=get_model_results(mdl);
            fprintf('Computing Post-Hoc regresions for Efficient group 2 and session %d\n',s)
            idx=r~=1;
            mdl=do_lm({x(idx),y(idx)},order); 
            tbl(6+2*(s-1)+2,:,:)=get_model_results(mdl);
        end
    else  %{grp-idr-idl}
        tbl=zeros(4,4,6);
        for g=1:2
            %Normal grouping
            fprintf('Computing Post-Hoc regresions for group factor %d\n',g)
            x=v(g,:);
            y=IDefL(g,:);
            z=IDefR(g,:);
            mdl=do_lm({x(:),y(:),z(:)},order);
            tbl(g,:,:)=get_model_results(mdl);
        end
        %Efficient grouping
        r=rho(:);
        x=v(:);
        y=IDefL(:);
        z=IDefR(:);
        fprintf('Computing Post-Hoc regresions for Efficient group 1\n')
        idx=r==1;
        mdl=do_lm({x(idx),y(idx),z(idx)},order);   
        tbl(3,:,:)=get_model_results(mdl);
        fprintf('Computing Post-Hoc regresions for Efficient group 2\n')
        idx=r~=1;
        mdl=do_lm({x(idx),y(idx),z(idx)},order);
        tbl(4,:,:)=get_model_results(mdl);
    end
else  %{ss-idl-idr}
    tbl=zeros(4,4,6);
    for s=1:3
        x=squeeze(v(s,:));
        y=squeeze(IDefL(s,:));
        z=squeeze(IDefR(s,:));
        %Normal grouping
        fprintf('Computing Post-Hoc regresions for Session %d\n',s)
        mdl=do_lm({x(:),y(:),z(:)},order);
        tbl(4,:)=get_model_results(mdl);
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbl=do_four_factors(vname,data,vnames,factors,order)
if any(strcmp('idl',factors))
    IDefL = rearrange_var_data('IDefL',data,vnames,factors);
end
if any(strcmp('idr',factors))
    IDefR = rearrange_var_data('IDefR',data,vnames,factors);
end
rho = rearrange_var_data('rho',data,vnames,factors);
v = rearrange_var_data(vname,data,vnames,factors);
tbl=zeros(12,4,6);
for g=1:2
    for s=1:3
        %Normal grouping
        fprintf('Computing Post-Hoc regresions for group factor %d and session %d\n',g,s)
        x=v(g,s,:);
        y=IDefL(g,s,:);
        z=IDefR(g,s,:);
        mdl=do_lm({x(:),y(:),z(:)},order);
        tbl(s+3*(g-1),:,:)=get_model_results(mdl);
    end
end
for g=1:2
    for s=1:3
        %Efficient grouping
        r=rho(:,s,:);
        r=r(:);
        x=v(:,s,:);
        x=x(:);
        y=IDefL(:,s,:);
        y=y(:);
        z=IDefR(:,s,:);
        z=z(:);

        
        if g==1
            idx=r~=1;
        else 
            idx=r==1;
        end
        fprintf('Computing Post-Hoc regresions for Efficient group %d and session %d\n',g,s)
        mdl=do_lm({x(idx),y(idx),z(idx)},order);
        tbl(s+3*(g-1)+6,:,:)=get_model_results(mdl);
    end
end
end



