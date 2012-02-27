classdef VectorField < handle
   properties(SetAccess = private)      
      xo
      neighbourhood=[3,3]
      binnumber=41
      fs = 1E3
      step=1
      minValsToComputeCondProb=11%11
      hand=''
      use_norm=true
      unimanual=false
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
           [vectors, xo, ~]=obj.KMcoef_2D(obj.xo,obj.pc,1/obj.fs,[1,2]);
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
           angDiff = obj.eval_neighbours(absAngles, obj.neighbourhood, @obj.get_maxAngle);
           angles = {absAngles, angDiff};
       end % angles Property
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %Constructor
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       function obj = VectorField(ts,hand)
           if nargin < 2, hand=''; end
           obj.hand = hand;
           disp('Wait while computing conditional probabilites...')
           obj.get_trial_vf(ts);
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
