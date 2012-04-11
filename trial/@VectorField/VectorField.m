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
      angles2circle
      maxangle
      circularity
      qcircularity
      q1
      q2
      q3
      q4
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
       
       plot_vf(obj,graphPath,rootname,ext)
           
       plot_va(obj,graphPath,rootname,ext)
       
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
       
       function maxangle = get.maxangle(obj)
           env=obj.conf.maxAngle_localenv;
           dim=obj.conf.binnumber-1;
           fact=round(env*dim)
           center=dim/2;
           ang=obj.angles{2};
           size(ang)
           dim-fact:dim
           center-fact:center+fact
           lmax=max(max(ang(1:fact,center-fact:center+fact)));
           rmax=max(max(ang(dim-fact:dim,center-fact:center+fact)));
           maxangle=max(lmax,rmax);
       end
       
       function circularity = get.circularity(obj);
           circularity=nanmedian(nanmedian(obj.angles2circle));
       end
       
       function qcircularity = get.qcircularity(obj)
           bin=(obj.conf.binnumber-1)/2;
           fcn=@(x) nanmedian(nanmedian(x));
           qcircularity=cellfun(fcn,mat2cell(obj.angles2circle,[bin,bin],[bin,bin]));
       end
       
       function q1 = get.q1(obj)
           q1=obj.qcircularity(2,1);
       end
       
       function q2 = get.q2(obj)
           q2=obj.qcircularity(2,2);
       end
       
       function q3 = get.q3(obj)
           q3=obj.qcircularity(1,2);
       end
       
       function q4 = get.q4(obj)
           q4=obj.qcircularity(1,1);
       end
       
       function angles2circle = get.angles2circle(obj)
           angles2circle=obj.get_VF_circularity();
       end
              
       function pc = get.pc(obj)
           if obj.conf.compress_pc==1
                pc=dunzip(obj.pc_);
            else
                pc=obj.pc_;
            end
       end
       
       function set.pc(obj,value)
            if obj.conf.compress_pc==1
                obj.pc_= dzip(value);
            else
                obj.pc_=value;
            end
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
            %conf.hand=obj.conf.hand;
            obj.conf=conf;
        end
        
        ang = get_VF_circularity(vf)
   end % methods
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Prototypes of public static methods
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   methods(Static=true, Access=private)       
      
      [D,xo,names]=KMcoef_2D(xo,pc,dt,ord)
      
      angleMax = get_maxAngle(a)       
      
      b = eval_neighbours(a,nhood,fun,params)   
   end
   
   methods(Static=true)
      function anova_var = get_anova_variables()
         anova_var = { 'circularity' 'q1' 'q2' 'q3' 'q4' 'maxangle'};
      end 
   end %methods(Static)
end% classdef
