classdef Analysis3 < dynamicprops
    methods
        function obj=Analysis3(conf,i)
            if nargin==0, obj.conf=Config(); end
            if nargin<2, i=0; end
            
            if obj.conf.split_analysis==0
                for p=1:10                    
                    obj.get_data(p);
                end
            else
                if i==0 %Fist call to Analysis
                    for p=1:10      
                        save(Analysis3(obj.conf,p),p);
                    end
                else
                    obj.get_data(i);
                end
            end
        end
        
        function save(obj,p)
            name=sprintf('Anal_pp%03d',p);
            save(joinpath(obj.conf.anal_path,name),'obj','-v7.3');
        end
    
            
        function get_data(obj,p)
            pp=Participant.load(p,obj.conf);
            vars=Oscillations.get_anova_variables();
            for v=1:length(vars)
                vnameR=strcat(strcat('Anova_',vars{v}),'R');
                vnameL=strcat(strcat('Anova_',vars{v}),'L');
                vnameRrel=strcat(strcat('Anova_U',vars{v}),'R');
                vnameLrel=strcat(strcat('Anova_U',vars{v}),'L');
                
                if isempty(obj.findprop(vnameR))
                %if ~isprop(obj,vnameR)
                    addprop(obj,vnameR);
                    addprop(obj,vnameL);
                    addprop(obj,vnameRrel);
                    addprop(obj,vnameLrel);                
                    obj.(vnameR)=AnovaBimanual();
                    obj.(vnameL)=AnovaBimanual();
                    obj.(vnameRrel)=AnovaUnimanual();
                    obj.(vnameLrel)=AnovaUnimanual();
                end
                obj.(vnameR).add_participant(pp,'oscR',vars{v});
                obj.(vnameL).add_participant(pp,'oscL',vars{v});
                obj.(vnameRrel).add_participant(pp,'UoscR',vars{v});
                obj.(vnameLrel).add_participant(pp,'UoscL',vars{v});
            end
            vars=LockingStrength.get_anova_variables();
            for v=1:length(vars)
                vname=strcat('Anova_',vars{v});
                if isempty(obj.findprop(vname))
                %if ~isprop(obj,vname)
                    addprop(obj,vname);
                    obj.(vname)=Anova2();
                end
                obj.(vname).add_participant(pp,'ls',vars{v});
            end    
            vars=VectorField.get_anova_variables();
            for v=1:length(vars)
                vnameR=strcat(strcat('Anova_',vars{v}),'R');
                vnameL=strcat(strcat('Anova_',vars{v}),'L');
                vnameRrel=strcat(strcat('Anova_U',vars{v}),'R');
                vnameLrel=strcat(strcat('Anova_U',vars{v}),'L');
                if isempty(obj.findprop(vnameR))
                %if ~isprop(obj,vnameR)
                    addprop(obj,vnameR);
                    addprop(obj,vnameL);
                    addprop(obj,vnameRrel);
                    addprop(obj,vnameLrel);                
                    obj.(vnameR)=Anova2();
                    obj.(vnameL)=Anova2();
                    obj.(vnameRrel)=Anova2();
                    obj.(vnameLrel)=Anova2();
                end
                obj.(vnameR).add_participant(pp,'vfR',vars{v});
                obj.(vnameL).add_participant(pp,'vfL',vars{v});
                obj.(vnameRrel).add_participant(pp,'UvfR',vars{v});
                obj.(vnameLrel).add_participant(pp,'UvfL',vars{v});                    
            end
        end
        props=properties(obj)
        for p=1:length(props)
            if strcmp(props{p},'Anova_')
                obj.(props{p}).finalize_data();
            end
        end
        end
        
        function promediate(obj)
            props = properties(obj);
            for p=1:length(props)
                if strfind(props{p},'Anova_')
                    promediate_Anova2(obj.(props{p}));
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
            props = properties(obj);  
            AV = obj.(props{1});
            
            if AV.promediate==0
                for p=1:length(props)
                    AV=obj.(props{p});
                    varnames=AV.varnames;
                    data = [AV.grLevels, AV.ppLevels , AV.ssLevels , AV.rhLevels , AV.lhLevels, AV.data];
                    tmp=regexp(props{p},'_','split');
                    varnames{end+1}=tmp{end};
                    
                    %Prepare header
                    header=varnames{1};
                    for v=2:length(varnames)
                        header=sprintf('%s %s %s',header,',',varnames{v});
                    end
                    header=sprintf('%s\n',header);
                    
                    %Open file, print header and close it
                    filepath=strcat(joinpath(savepath,varnames{end}),filename);
                    outfd = fopen(filepath, 'w+');
                    fprintf(outfd, '%s', header);
                    fclose(outfd);
                    %Print the real data, much faster this way
                    dlmwrite (filepath,data,'-append');                    
                end
            else
                varnames=AV.varnames;
                data = [AV.grLevels, AV.ppLevels , AV.ssLevels , AV.rhLevels , AV.lhLevels];
                %Add numeeric dependent variables to matrix
                for p=1:length(props)
                    %Fetch Anova property
                    AV=obj.(props{p});
                    %Get variable name and data from Anova property
                    data=[data, AV.data];               
                    tmp=regexp(props{p},'_','split');
                    varnames{end+1}=tmp{end};
                end

                %Prepare header
                header=varnames{1};
                for v=2:length(varnames)
                    header=sprintf('%s %s %s',header,',',varnames{v});
                end
                header=sprintf('%s\n',header);

                %Open file, print header and close it
                filepath=joinpath(savepath,filename);
                outfd = fopen(filepath, 'w+');
                fprintf(outfd, '%s', header);
                fclose(outfd);
                %Print the real data, much faster this way
                dlmwrite (filepath,data,'-append');            
            end
        end
    end
    methods(Static=true)
        function an = merge_files(path)
            if isempty(path)
                conf=Config();
            else
                conf=Config(path);
            end
            conf.split_analisys=-1;
            an=Analisys3(conf);
            fnames=dir2(conf.anal_path);
            for n=1:length(fnames)
                pp=load(joinpath(path,fnames{n}));
                props=properties(pp);
                for p=1:length(props)
                    if n==1, addprop(an,props{p}); end
                    %Fetch Anova property
                    AVpp=pp.(props{p});
                    AVan=an.(props{p});                   
                    %Get variable name and data from Anova property
                    AVan.data    =[AVan.data;AVpp.data(:)];
                    AVan.grLevels=[AVan.grLevels;AVpp.grLevels];
                    AVan.ppLevels=[AVan.ppLevels;AVpp.ppLevels];  
                    AVan.ssLevels=[AVan.ssLevels;AVpp.ssLevels];
                    if isa(AVan,'AnovaBimanual')
                        AVan.rhLevels=[AVan.rhLevels;AVpp.rhLevels];        
                        AVan.lhLevels=[AVan.lhLevels;AVpp.lhLevels];
                    else
                        AVan.idLevels=[AVan.idLevels;AVpp.idLevels];
                    end
                end
            end
        end
    
end

                
                
