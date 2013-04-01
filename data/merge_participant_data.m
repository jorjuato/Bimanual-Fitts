function obj = merge_participant_data(data_path, mode)
%Recommended method to group per-participant data
%Does not support raw data, but it is not really usefull.
if nargin<1, data_path='./'; end
if nargin<2, mode=2; end % Modes:  1=bygroup, 
                         %         2=bypp, 

%Set some globals for data fetching
global vtypes
global C
vtypes={'ts','osc','vf','ls'};
C=[2,3,6,8,9];


%Fetch data files in a single cell array
data_files=dir2(data_path);
pp=length(data_files);
pps=cell(1,pp);
for p=1:pp
    pps{p}=load(joinpath(data_path,data_files(p).name));
end

%Instantiate metadata
obj=struct;
obj.vnamesB=pps{1}.vnamesB;
obj.vnamesU=pps{1}.vnamesU;
obj.vtypesB=pps{1}.vtypesB;
obj.vtypesU=pps{1}.vtypesU;
[vbno,hno,ss,idl,idr,r]=size(pps{1}.dataB);
vuno=length(obj.vnamesU);

%Group (C-U) based or participant based grouping
if mode==1
    grp=2;
else
    grp=pp;
end

%Create output matrices
obj.dataU=zeros(vbno,hno,grp,ss,idr,r)*NaN;
obj.dataB=zeros(vuno,hno,grp,ss,idl,idr,r)*NaN;

%Merge bimanual data
for v=1:vbno
    for h=1:hno
        for p=1:pp
            if grp==2
                if any(C==p)
                    g=1;
                else
                    g=2;
                end
            else
                g=p;
            end
            for s=1:ss
                for rid=1:idr
                    for lid=1:idl
                        obj.dataB(v,h,g,s,lid,rid,:)=pps{p}.dataB(v,h,s,lid,rid,:);
                    end
                end
            end
        end
    end
end

%Merge unimanual data
for v=1:vuno
    for h=1:hno
        for p=1:pp
            if grp==2
                if any(C==p)
                    g=1;
                else
                    g=2;
                end
            else
                g=p;
            end            
            for s=1:ss
                if h==1
                    idmax=2;
                else
                    idmax=3;
                end
                for i=1:idmax
                    obj.dataU(v,h,g,s,i,:)=pps{p}.dataU(v,h,s,i,:);
                end
            end
        end
    end
end
obj.dataL = squeeze(obj.dataU(:,1,:,:,:,:));
obj.dataR = squeeze(obj.dataU(:,2,:,:,:,:));
obj.dataRel = get_data_rel(obj);
obj.dataD = merge_ID_factors(obj.dataB);
end