function plot_IDregression(IDMatrix,mode)
    if nargin<2, mode='ID'; end
    [ss,ids,~]=size(IDMatrix)
    colors={'r','g','b'};
    switch mode
       case 'ID'
          figure; 
          x=3:0.1:7;
          for id=1:ids
              subplot(1,ids,id); hold on;
              for s=1:ss
                  plot(x,x*IDMatrix(s,id,2)+IDMatrix(ss,id,1),colors{s});
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
