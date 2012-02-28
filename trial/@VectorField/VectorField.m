classdef VectorField < handle
   properties
       conf
   end
   properties(SetAccess = private)      
      xo
   end % properties
   
   properties(Hidden, SetAccess = private)
      pc_
   end
   properties (Dependent = true, SetAccess = private)
      vectors
      angles
   end
   
   properties (Dependent = true, SetAccess = public)
      pc
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Public methods
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   methods
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %Prototypes of public methods
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       concatenate(obj,obj1)
       
       get_trial_vf(obj,ts)
       
       get_combined_vf(obj,DS)
       
       plot(obj,graphPath,rootname,ext)
       
       plot_vf(obj,graphPath,rootname,ext);
           
       plot_va(obj,graphPath,rootname,ext);
       
       xo = get_bincenters_normalized(obj)
       
       xo = get_bincenters(obj,DS,dim)
       
       [P,B,PC]=prob_2D(obj,x,b,step,minValsToComputeCondProb)
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %Properties getters
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function vectors = get.vectors(obj)
           %Get Kramers-Moyal coefficients
           [vectors, xo, ~]=obj.KMcoef_2D(obj.xo,obj.pc,1/obj.conf.fs,[1,2]);
           vectors{end+1} = xo;
       end
       
       function pc = get.pc(obj)
           pc=dunzip(obj.pc_);
       end
       
       function set.pc(obj,value)
           obj.pc_= dzip(value);
       end
       
       function angles = get.angles(obj)
           absAngles = atan2(obj.vectors{1},obj.vectors{2});
           angDiff = obj.eval_neighbours(absAngles, obj.conf.neighbourhood, @obj.get_maxAngle);
           angles = {absAngles, angDiff};
       end % angles Property
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %Constructor
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function obj = VectorField(ts,hand,conf)
           if nargin < 2, hand=''; end
           obj.conf = conf;
           obj.conf.hand = hand;
           disp('Wait while computing conditional probabilites...')
           obj.get_trial_vf(ts);
       end
        function update_conf(obj,conf)
            conf.hand=obj.conf.hand;
            obj.conf=conf;
        end
   end % methods
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Prototypes of public static methods
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   methods(Static=true, Access=private)       
      
      [D,xo,names]=KMcoef_2D(xo,pc,dt,ord)
      
      angleMax = get_maxAngle(a)       
      
      b = eval_neighbours(a,nhood,fun,params)   
      
   end %methods(Static)
end% classdef
