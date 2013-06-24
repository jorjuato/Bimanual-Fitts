function ylimits=get_ylimits(obj,i,j,v)
   ylimits=zeros(4,2);
   v=[v,'_hist'];
   r=1;
   %UniLeft
   data=[obj.sessions(1).uniLeft{i,r}.ts.(v),...
         obj.sessions(4).uniLeft{i,r}.ts.(v),...
         obj.sessions(7).uniLeft{i,r}.ts.(v)];
   if ylimits(1,1)>min(data)
       ylimits(1,1)=min(data);
   end
   if ylimits(1,2)<max(data)
       ylimits(1,2)=max(data);
   end
   
   %BiLeft
   data=[obj.sessions(1).bimanual{i,j,r}.ts.(['L',v]),...
         obj.sessions(4).bimanual{i,j,r}.ts.(['L',v]),...
         obj.sessions(7).bimanual{i,j,r}.ts.(['L',v])];
   if ylimits(2,1)>min(data)
       ylimits(2,1)=min(data);
   end
   if ylimits(2,2)<max(data)
       ylimits(2,2)=max(data);
   end
   
   %BiRight
   data=[obj.sessions(1).bimanual{i,j,r}.ts.(['R',v]),...
         obj.sessions(4).bimanual{i,j,r}.ts.(['R',v]),...
         obj.sessions(7).bimanual{i,j,r}.ts.(['R',v])];
   if ylimits(3,1)>min(data)
       ylimits(3,1)=min(data);
   end
   if ylimits(3,2)<max(data)
       ylimits(3,2)=max(data);
   end
   
   %UniRight
   data=[obj.sessions(1).uniRight{j,r}.ts.(v),...
         obj.sessions(4).uniRight{j,r}.ts.(v),...
         obj.sessions(7).uniRight{j,r}.ts.(v)];
   if ylimits(4,1)>min(data)
       ylimits(4,1)=min(data);
   end
   if ylimits(4,2)<max(data)
       ylimits(4,2)=max(data);
   end
     
end   
