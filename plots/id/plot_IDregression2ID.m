function plot_IDregression2ID(IDMatrix,mode)
    if nargin<2, mode='ID'; end
    [ss,idl,idr,~]=size(IDMatrix);
    colors={'r','g','b'};
    switch mode
       case 'ID'
          figure; 
          x=3:0.1:7;
          for l=1:idl
              for r=1:idr
                  subplot(idl,idr,(l-1)*idr+r); hold on;
                  for s=1:ss
                      plot(x,x*IDMatrix(s,l,r,2)+IDMatrix(ss,l,r,1),colors{s});
                  end
              end
              hold off;
          end
       case 'session'
          figure; 
          x=3:0.1:7;
          for s=1:ss
              subplot(1,ss,s); hold on;
              for id=1:ids
                  plot(x,x*IDMatrix(s,id,2)+IDMatrix(ss,id,1),colors{id});
              end
              hold off;
          end
       otherwise
          return;
    end
end
