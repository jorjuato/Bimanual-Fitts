classdef Analysis < dynamicprops
    methods
        function obj=Analysis(exp)
            if nargin==0, exp=Config(); end
            vars=Oscillations.get_anova_variables();
            for v=1:length(vars)
                vnameR=strcat(strcat('Anova_',vars{v}),'R');
                vnameL=strcat(strcat('Anova_',vars{v}),'L');
                vnameRrel=strcat(strcat('Anova_U',vars{v}),'R');
                vnameLrel=strcat(strcat('Anova_U',vars{v}),'L');
                addprop(obj,vnameR);
                addprop(obj,vnameL);
                addprop(obj,vnameRrel);
                addprop(obj,vnameLrel);                
                obj.(vnameR)=Anova(exp,'oscR',vars{v});
                obj.(vnameL)=Anova(exp,'oscL',vars{v});
                obj.(vnameRrel)=Anova(exp,'UoscR',vars{v});
                obj.(vnameLrel)=Anova(exp,'UoscL',vars{v});
            end
            vars=LockingStrength.get_anova_variables();
            for v=1:length(vars)
                vname=strcat('Anova_',vars{v});
                addprop(obj,vname);
                obj.(vname)=Anova(exp,'ls',vars{v});     
            end    
            vars=VectorField.get_anova_variables();
            for v=1:length(vars)
                vnameR=strcat(strcat('Anova_',vars{v}),'R');
                vnameL=strcat(strcat('Anova_',vars{v}),'L');
                vnameRrel=strcat(strcat('Anova_U',vars{v}),'R');
                vnameLrel=strcat(strcat('Anova_U',vars{v}),'L');
                addprop(obj,vnameR);
                addprop(obj,vnameL);
                addprop(obj,vnameRrel);
                addprop(obj,vnameLrel);                
                obj.(vnameR)=Anova(exp,'vfR',vars{v});
                obj.(vnameL)=Anova(exp,'vfL',vars{v});
                obj.(vnameRrel)=Anova(exp,'UvfR',vars{v});
                obj.(vnameLrel)=Anova(exp,'UvfL',vars{v});                
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
end

                
                
