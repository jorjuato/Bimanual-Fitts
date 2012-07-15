classdef AnalysisFitts < dynamicprops
    methods
        function obj=AnalysisFitts(conf,i)
            if nargin==0, conf=Config(); end
            if nargin<2, i=0; end
            
            addprop(obj,'conf');
            obj.conf=conf;
            if obj.conf.split_analysis==0
                for p=1:10                    
                    obj.get_data(p);
                end
            elseif obj.conf.split_analysis==1
                if i==0 %We're in first call to Analysis in splitted mode
                    if obj.conf.parallelMode==1
                        labsConf = findResource(); 
                        if matlabpool('size') == 0
                            %matlabpool(labsConf.ClusterSize); 
                            matlabpool(obj.conf.workers)
                            %matlabpool local 2;
                        end
                        pp=[1,4,9,10]
                        parfor k=1:4
                            p=pp(k);
                            an=AnalysisFitts(obj.conf,p); %Second call
                            an.save(p);
                        end
                    else
                        for p=[1:10]      
                            an=AnalysisFitts(obj.conf,p); %Second call
                            an.save(p);
                        end
                    end
                else%We're in second call to Analysis
                    obj.get_data(i);
                end 
            end
            %else->split_analysis==-1 Do nothing, called from merge fcn
        end
        
        function save(obj,p)
            name=sprintf('Anal_pp%03d',p);
            save(joinpath(obj.conf.anal_path,name),'obj','-v7.3');
        end
            
        function get_data(obj,p)
            if isa(p,'Participant')
                pp=p;
            else
                disp(sprintf('Loading participant %d',p));
                pp=Participant.load(p,obj.conf);
            end            
            vtypes={'osc','vf','ls'};
            fmtstrs={'%sR';'%sL';'U%sR';'U%sL'};
            %Fetch Oscillations/Vectorfield variables
            for t=[1,2]
                if strcmp('osc',vtypes{t})
                    vars=Oscillations.get_anova_variables();
                else
                    vars=VectorField.get_anova_variables();
                end
                for v=1:length(vars)
                    for fmt=1:4
                        %Create variable names and current type
                        vn=sprintf(strcat('Anova_',fmtstrs{fmt}), vars{v});
                        ty=sprintf(fmtstrs{fmt}, vtypes{t});
                        %Create properties if this is first participant  %if ~isprop(obj,vn{n})                   
                        if isempty(obj.findprop(vn)) 
                            addprop(obj,vn);                     
                            if isempty(findstr('U',fmtstrs{fmt}))
                                obj.(vn)=AnovaBimanual();
                            else
                                obj.(vn)=AnovaUnimanual();
                            end                      
                        end
                        %Add participant's data
                        obj.(vn).add_participant(pp,ty,vars{v});
                    end
                end
            end
            %Fetch LockingStrength variables
            vars=LockingStrength.get_anova_variables();
            for v=1:length(vars)
                vname=strcat('Anova_',vars{v});
                if isempty(obj.findprop(vname))%if ~isprop(obj,vname)                
                    addprop(obj,vname);
                    obj.(vname)=AnovaBimanual();
                end
                obj.(vname).add_participant(pp,'ls',vars{v});
            end    
        end
        
        function finalize(obj)
            props=properties(obj);
            for p=1:length(props)
                if strfind(props{p},'Anova_')
                    obj.(props{p}).finalize_data();
                end
            end
        end
        
        function promediate(obj)
            props = properties(obj);
            for p=1:length(props)
                if strfind(props{p},'Anova_')
                    obj.(props{p}).promediate_Anova2();
                end
            end
        end

        function export2spss(obj,savepath)
            if nargin==1, savepath=getuserdir();end
            props = properties(obj);
            for p=1:length(props)
                AV=obj.(props{p});
                data=[AV.grLevels, AV.ppLevels , AV.ssLevels , AV.rhLevels , AV.lhLevels , AV.data];
                varnames=AV.varnames; 
                varnames{end+1}='value';
                filename=joinpath(savepath,strcat(props{p}(7:end),'.dat'));
                save4spss(data,varnames, filename);
            end
        end
        
        function export2R(obj,filename,savepath)
            if nargin<2, filename='fitts.dat';end
            if nargin<3, savepath=getuserdir();end
            
            %Get properties, varnames and factor levels
            props=properties(obj);
            flagBi=0; flagUniL=0; flagUniR=0;
            for p=1:length(props)
                %Fetch Anova property
                AV=obj.(props{p});
                %Get variable name and data from Anova property
                if isa(AV,'AnovaBimanual') & flagBi==0
                    flagBi=1;
                    varnamesBi=AV.factors;
                    dataBi = [AV.grLevels, AV.ppLevels , AV.ssLevels , AV.rhLevels , AV.lhLevels];
                elseif isa(AV,'AnovaUnimanual')
                    if strfind(props{p}(end),'R') & flagUniR==0
                        flagUniR=1;
                        varnamesUniR=AV.factors;
                        dataUniR = [AV.grLevels, AV.ppLevels , AV.ssLevels , AV.idLevels];
                    elseif strfind(props{p}(end),'L') & flagUniL==0
                        flagUniL=1;
                        varnamesUniL=AV.factors;
                        dataUniL = [AV.grLevels, AV.ppLevels , AV.ssLevels , AV.idLevels];
                    end
                elseif flagUniR==1 & flagUniR==1 & flagBi==1
                    break
                end
            end
            %Add numeeric dependent variables to matrix
            for p=1:length(props)
                %Fetch Anova property
                vname=props{p};
                AV=obj.(vname);
                %Get variable name and data from Anova property
                if isa(AV,'AnovaBimanual')
                    dataBi=[dataBi, AV.data];
                    tmp=regexp(vname,'_','split');
                    varnamesBi{end+1}=tmp{end};
                elseif strfind(props{p}(end),'L')
                    dataUniL=[dataUniL, AV.data];
                    tmp=regexp(vname,'_','split');
                    varnamesUniL{end+1}=tmp{end};
                elseif strfind(props{p}(end),'R')
                    dataUniR=[dataUniR, AV.data];
                    tmp=regexp(vname,'_','split');
                    varnamesUniR{end+1}=tmp{end};
                end
                
            end
            
            %%%Print unimanual L
            %Prepare header
            header=varnamesUniL{1};
            for v=2:length(varnamesUniL)
                header=sprintf('%s %s %s',header,',',varnamesUniL{v});
            end
            header=sprintf('%s\n',header);

            %Open file, print header and close it
            filepath=joinpath(savepath,strcat('UniL_',filename));           
            outfd = fopen(filepath, 'w+');
            fprintf(outfd, '%s', header);
            fclose(outfd);
            %Print the real data, much faster this way
            dlmwrite (filepath,dataUniL,'-append');            
            %end
            
            
            %%%Print unimanual R
            %Prepare header
            header=varnamesUniR{1};
            for v=2:length(varnamesUniR)
                header=sprintf('%s %s %s',header,',',varnamesUniR{v});
            end
            header=sprintf('%s\n',header);

            %Open file, print header and close it
            filepath=joinpath(savepath,strcat('UniR_',filename));           
            outfd = fopen(filepath, 'w+');
            fprintf(outfd, '%s', header);
            fclose(outfd);
            %Print the real data, much faster this way
            dlmwrite (filepath,dataUniR,'-append');            
            %end
            
            
            %%%%Print bimanual
            %Prepare header
            header=varnamesBi{1};
            for v=2:length(varnamesBi)
                header=sprintf('%s %s %s',header,',',varnamesBi{v});
            end
            header=sprintf('%s\n',header);
            %Open file, print header and close it
            filepath=joinpath(savepath,strcat('Bi_',filename));           
            outfd = fopen(filepath, 'w+');
            fprintf(outfd, '%s', header);
            fclose(outfd);
            %Print the real data, much faster this way
            dlmwrite (filepath,dataBi,'-append');   
        end
    end
    
    methods(Static=true)
        function an = merge_files(conf)
            if nargin==0
                conf=Config();
            elseif ischar(conf)
                conf_tmp=Config();
                conf_tmp.anal_path=conf;
                conf=conf_tmp;
            end
            conf.split_analysis=-1;
            an=AnalysisFitts(conf);
            fnames=dir2(conf.anal_path);
            for n=1:length(fnames)
                tmp=load(joinpath(conf.anal_path,fnames(n).name));
                pp=tmp.obj;
                props=properties(pp);
                for p=1:length(props)
                    if isempty(strfind(props{p},'Anova_'))
                        continue; 
                    end
                    AVpp=pp.(props{p});
                    %AVpp.finalyze()
                    if n==1
                        addprop(an,props{p});
                        an.(props{p})=AVpp.copy(conf.root_path);
                        continue
                    end
                    %Fetch Anova property
                    AVan=an.(props{p});                
                    %Get variable name and data from Anova property
                    AVan.data    =[AVan.data;AVpp.data(:)];
                    AVan.grLevels=[AVan.grLevels;AVpp.grLevels(:)];
                    AVan.ppLevels=[AVan.ppLevels;AVpp.ppLevels(:)];  
                    AVan.ssLevels=[AVan.ssLevels;AVpp.ssLevels(:)];
                    if isa(AVan,'AnovaBimanual')
                        AVan.rhLevels=[AVan.rhLevels;AVpp.rhLevels(:)];        
                        AVan.lhLevels=[AVan.lhLevels;AVpp.lhLevels(:)];
                    else
                        AVan.idLevels=[AVan.idLevels;AVpp.idLevels(:)];
                    end
                end
            end
        end
    end    
end

                
                
