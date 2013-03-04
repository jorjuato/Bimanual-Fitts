function [dataBi,dataUn,varnamesBi,varnamesUn,vartypesBi, vartypesUn] = merge_participant_data(data_path, mode)
if nargin<1, data_path='./'; end
if nargin<2, mode=2; end % Modes:  1=bygroup, 
                         %         2=bypp, 

%Set some globals for data fetching
global vtypes
global C
vtypes={'ts','osc','vf','ls'};
C=[2,3,6,8,9];
max_raw_data=1000;

%Fetch data files in a single cell array
data_files=dir2(data_path);
pp=length(data_files);
pps={};
for p=1:pp
    pps{p}=load(joinpath(data_path,data_files(p).name));
end

%Instantiate metadata
varnamesBi=pps{1}.varnamesBi;
varnamesUn=pps{1}.varnamesUn;
vartypesBi=pps{1}.vartypesBi;
vartypesUn=pps{1}.vartypesUn;
[vbno,hno,ss,idl,idr,r]=size(pps{1}.dataBi);
vuno=length(varnamesUn);

%Group (C-U) based or participant based grouping
if mode==1
    grp=2;
else
    grp=pp;
end

%Create output matrices
dataUn=zeros(vbno,hno,grp,ss,idr,r)*NaN;
dataBi=zeros(vuno,hno,grp,ss,idl,idr,r)*NaN;

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
                        dataBi(v,h,g,s,lid,rid,:)=pps{p}.dataBi(v,h,s,lid,rid,:);
                    end
                end
            end
        end
    end
end

%Merge unimanual data
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
                if h==1
                    idx=2;
                else
                    idx=3;
                end
                for i=1:idx
                    dataUn(v,h,g,s,i,:)=pps{p}.dataUn(v,h,s,i,:);
                end
            end
        end
    end
end

end