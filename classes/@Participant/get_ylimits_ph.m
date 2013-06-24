function ylimits_=get_ylimits_ph(obj,i,j,v)
   ylimits=zeros(4,3,2);
   ylimits_=zeros(4,2);
   v=[v,'_hist'];
   for r=1:3;
       %UniLeft
       data=[obj.sessions(1).uniLeft{i,r}.ts.(v),...
             obj.sessions(4).uniLeft{i,r}.ts.(v),...
             obj.sessions(7).uniLeft{i,r}.ts.(v)];
       if ylimits(1,r,1)>min(data)
           ylimits(1,r,1)=min(data);
       end
       if ylimits(1,r,2)<max(data)
           ylimits(1,r,2)=max(data);
       end

       %BiLeft
       data=[obj.sessions(1).bimanual{i,j,r}.ts.(['L',v]),...
             obj.sessions(4).bimanual{i,j,r}.ts.(['L',v]),...
             obj.sessions(7).bimanual{i,j,r}.ts.(['L',v])];
       if ylimits(2,r,1)>min(data)
           ylimits(2,r,1)=min(data);
       end
       if ylimits(2,r,2)<max(data)
           ylimits(2,r,2)=max(data);
       end

       %BiRight
       data=[obj.sessions(1).bimanual{i,j,r}.ts.(['R',v]),...
             obj.sessions(4).bimanual{i,j,r}.ts.(['R',v]),...
             obj.sessions(7).bimanual{i,j,r}.ts.(['R',v])];
       if ylimits(3,r,1)>min(data)
           ylimits(3,r,1)=min(data);
       end
       if ylimits(3,r,2)<max(data)
           ylimits(3,r,2)=max(data);
       end

       %UniRight
       data=[obj.sessions(1).uniRight{j,r}.ts.(v),...
             obj.sessions(4).uniRight{j,r}.ts.(v),...
             obj.sessions(7).uniRight{j,r}.ts.(v)];
       if ylimits(4,r,1)>min(data)
           ylimits(4,r,1)=min(data);
       end
       if ylimits(4,r,2)<max(data)
           ylimits(4,r,2)=max(data);
       end
   end
   for trtype=1:4
       ylimits_(trype,1)=min(squeeze(ylimits(trtype,:,1));
       ylimits_(trype,2)=max(squeeze(ylimits(trtype,:,2));
   end
end   
