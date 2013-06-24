classdef Session < handle
    
    properties(SetObservable = true)
        conf
    end
    
    properties(SetAccess = private)
        bimanual
        uniLeft
        uniRight
        train=0
    end % properties
    
    methods
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Methods prototypes (body in separate file)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        plot(obj,mode,graphPath,rootname,ext)
        
        plot_va(obj,mode,graphPath,rootname,ext)
        
        plot_vf(obj,mode,graphPath,rootname,ext)
        
        plot_relative_osc(obj,mode,graphPath,rootname,ext)
        
        update_vf(obj)
        
        update_ls(obj)
        
        update_idx(obj)
        
        update_conf(obj,src,evnt)
        
        B = subsref(obj,sth,S)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = Session(session_path,conf)
            if nargin<2, conf=Config(); end
            
            blocks = dir2(session_path);
            obj.conf = conf;
            obj.conf.number=str2num(session_path(end));
            addlistener(obj,'conf','PostSet',@(src,evnt)update_conf(obj,src,evnt));
            
            for b=1:length(blocks)
                name = blocks(b).name;
                %Skip train blocks
                if strcmp(name,'train')
                    obj.train=1;
                    continue;
                end
                %Generate a Block instance
                obj.(name) = Block(joinpath(session_path,name),copy(obj.conf));
            end
        end
    end % methods
end% classdef
