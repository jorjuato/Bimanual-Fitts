%load('/Volumes/MacintoshHD3/research/CurrentProjects/bimanualFitts/save/participant005.mat')

datadir='/Volumes/MacintoshHD3/research/CurrentProjects/bimanualFitts/save/';

% bimanual data = {2x3x4}

%fs = 1000;
fs = 250; % following downsampling
[BB,AA] = butter(4,12/(fs/2),'low');

bin  = {-1.0005:.0667:1.0005};
dt   = 1/fs;
KMO  = [1,2];    % KM order
fitorder = 3;

[BF,AF]=butter(4,12/(fs/2),'low');

session=1:3:7;

N = 30;

for pp=1:10
    if pp<=9
        load(['/Volumes/MacintoshHD3/research/CurrentProjects/bimanualFitts/save/participant00',num2str(pp),'.mat'])
    else
        load(['/Volumes/MacintoshHD3/research/CurrentProjects/bimanualFitts/save/participant0',num2str(pp),'.mat'])
    end
    % ANALYSIS
    for step=1:2:3 %5
        disp(sprintf('... step = %d',step))
        for minValsToComputeCP=11:4:19 %5:2:9
            disp(sprintf('... minValsToComputeCP = %d',minValsToComputeCP))
            km=[]; data=[]; 
            for s=1:3
                disp(sprintf('... session %d',session(s)))
                for idL=1:2
                    for idR=1:3
                        % left hand
                        X=[];Y=[];
                        for repetition=1:3
                            x=obj.sessions(session(s)).bimanual.data_set{idL,idR,repetition}.ts.Lxnorm;
                            y=obj.sessions(session(s)).bimanual.data_set{idL,idR,repetition}.ts.Lvnorm;
                            x=x(:); y=y(:);
                            xn=upsample2(x,fix(length(x)/4));
                            yn=upsample2(y,fix(length(x)/4));
                            xn=filtfilt(BF,AF,xn);
                            yn=filtfilt(BF,AF,yn);
                            data(s,idL,idR,repetition).leftx=xn;
                            data(s,idL,idR,repetition).lefty=yn;
                            X=[X;xn'];
                            Y=[Y;yn'];
                        end
                        [P,B,PC] = prob_2D([X(:),Y(:)],31,5,7);
                        [D,B,names] = KMcoef_2D(B,PC,dt,KMO);
                        km(s,idL,idR).leftB=B;
                        km(s,idL,idR).leftD=D;
                        km(s,idL,idR).leftnames=names;
                        % right hand
                        X=[];Y=[];
                        for repetition=1:3
                            x=obj.sessions(session(s)).bimanual.data_set{idL,idR,repetition}.ts.Rxnorm;
                            y=obj.sessions(session(s)).bimanual.data_set{idL,idR,repetition}.ts.Rvnorm;
                            x=x(:); y=y(:);
                            xn=upsample2(x,fix(length(x)/4));
                            yn=upsample2(y,fix(length(x)/4));
                            xn=filtfilt(BF,AF,xn);
                            yn=filtfilt(BF,AF,yn);
                            data(s,idL,idR,repetition).rightx=xn;
                            data(s,idL,idR,repetition).righty=yn;
                            X=[X;xn'];
                            Y=[Y;yn'];
                        end
                        [P,B,PC] = prob_2D([X(:),Y(:)],31,5,7);
                        [D,B,names] = KMcoef_2D(B,PC,dt,KMO);
                        km(s,idL,idR).rightB=B;
                        km(s,idL,idR).rightD=D;
                        km(s,idL,idR).rightnames=names;
                    end
                end
            end
            save([datadir 'km_participant',num2str(pp),'_MVC',num2str(minValsToComputeCP),'_step',num2str(step)],'km','data');
        end
    end
end

return

for s=1:3
    figure
    for idL=1:2
        for idR=1:3
            subplot(2,3,(idL-1)*3+idR)
            %x=obj.sessions(session(s)).bimanual.data_set{idL,idR,repetition}.ts.Lxnorm;
            %y=obj.sessions(session(s)).bimanual.data_set{idL,idR,repetition}.ts.Lvnorm;
            %plot(x,y),pause    
            KM_Neighbours(km(s,idL,idR).B,km(s,idL,idR).D,'max');colorbar
        end
    end
end

