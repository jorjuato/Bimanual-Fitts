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
    
        plot(obj,mode,graphPath,rootname,ext);
        
        plot_va(obj,mode,graphPath,rootname,ext);
        
        plot_vf(obj,mode,graphPath,rootname,ext);
        
        plot_relative_osc(obj,mode,graphPath,rootname,ext);
        
        update_vf(obj);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = Session(session_dir,conf)
            if nargin<2, conf=Config(); end
            
            blocks = dir2(session_dir);
            conf.number=str2num(session_dir(end));
            obj.conf = conf;
            confListener = addlistener(obj,'conf','PostSet',@(src,evnt)update_conf(obj,src,evnt));
            
            for b=1:length(blocks)
                name = blocks(b).name;
                %Skip train blocks
                if strcmp(name,'train')
                    obj.train=1;
                    continue;
                end
                %Generate a Block instance
                obj.(name) = Block(joinpath(session_dir,name),copy(conf));
            end
        end
        
%         function B = subsref(obj,S)
%             'holaS'
%             if length(S) > 1
%                 if strcmp(S(1).type,'.')
%                     %tmp = obj.(S(1).subs{1});
%                     %B = tmp.subsref(tmp,S(2:end));
%                     B = obj.(S(1).subs{1});
%                 else
%                     disp('Wrong access method for class Session')
%                     B =zeros(0);
%                 end
%             elseif strcmp(S.type,'.')
%                 B = obj.(S(1).subs{1});
%             else
%                 B=zeros(0);
%             end
%         end
        
    end % methods
end% classdef
