function allinone(vname,data,vnames)

factors={'grp','ss','idl','idr'};

%Rearrange data matrices by group if needed
if size(data,3)==10
    data=group_participant_data(data);
end
%Turn session into a two level categorial variable
data=session2learning(data);

%Get IDef covariates
v=strcmp('IDef', vnames);
IDefL = squeeze(data(v,1,:));
IDefR = squeeze(data(v,2,:));
IDefL=IDefL-mean(IDefL);
IDefR=IDefR-mean(IDefR);

%Get cathegorial covariates
%[grp,ss]=get_factors(data);
[g1,g2,s1,s2,s3]=get_factors(data);

%Get rho data to compute grp ef
rho = squeeze(data(strcmp('rho', vnames),1,:));

%Get response variable 
if vname(end)=='L'
    v=strcmp(vname(1:end-1), vnames);
    vdata=squeeze(data(v,1,:));
elseif vname(end)=='R'
    v=strcmp(vname(1:end-1), vnames);
    vdata=squeeze(data(v,2,:));
else
    v=strcmp(vname, vnames);
    vdata=squeeze(data(v,1,:));
end


%Fit models
g1
g2
s1
s2
rank([g1',g2',s1',s2'])
rank([g1',g2',s1',s2'])
rank([s1',s2'])
rank([g1',g2'])
%disp('normal group')
lm = LinearModel.fit([g1',g2',s1',s2',IDefL,IDefR],vdata,'interactions','CategoricalVars',1:4)
%step(lm)
%disp('efficient group')
%lm = LinearModel.fit([rho~=1,ss',IDefL,IDefR],vdata,'interactions','CategoricalVars',[1,2])

end


function dataout=session2learning(datain)
%Learning from 1-2 and learning 2-3
[vno,hno,grp,ss,idl,idr,rep]=size(datain);
dataout=zeros([vno,hno,grp,2,idl,idr,rep])*NaN;
for v=1:vno
    for h=1:hno
        for g=1:grp
%             for l=1:idl
%                 for r=1:idr
%                     dataout(v,h,g,1,l,r)=nanmedian(datain(v,h,g,1,l,r,:))-nanmedian(datain(v,h,g,2,l,r,:));
%                     dataout(v,h,g,2,l,r)=nanmedian(datain(v,h,g,2,l,r,:))-nanmedian(datain(v,h,g,3,l,r,:));
%                 end
%             end
            dataout(v,h,g,1,:,:,:)=datain(v,h,g,2,:,:,:)-datain(v,h,g,1,:,:,:);
            dataout(v,h,g,2,:,:,:)=datain(v,h,g,3,:,:,:)-datain(v,h,g,2,:,:,:);
        end
    end
end
end

function [g1,g2,s1,s2,s3]=get_factors(data)
[vno,hands,gno,sno,lno,rno,rep]=size(data);
g1=zeros(1,gno*sno*lno*rno*rep);
g2=zeros(1,gno*sno*lno*rno*rep);
s1=zeros(1,gno*sno*lno*rno*rep);
s2=zeros(1,gno*sno*lno*rno*rep);
s3=zeros(1,gno*sno*lno*rno*rep);

i=0;
for g=1:gno
    for s=1:sno
        for l=1:lno
            for r=1:rno
                for rr=1:rep
                    i=i+1;
                    if g==1
                        g1(i)=1;
                    elseif g==2
                        g2(i)=1;
                    end
                    if s==1
                        s1(i)=1;
                    elseif s==2
                        s2(i)=1;
                    elseif s==3
                        s3(i)=1;
                    end
                end
            end
        end
    end
end
end

function [grps,sss]=get_factors2(data)
[vno,hands,grp,ss,idl,idr,rep]=size(data);
grps=zeros(1,grp*ss*idl*idr*rep);
sss=zeros(1,grp*ss*idl*idr*rep);
i=0;
for g=1:grp
    for s=1:ss
        for l=1:idl
            for r=1:idr
                for rr=1:rep
                    i=i+1;
                    grps(i)=g;
                    sss(i)=s;
                end
            end
        end
    end
end
end