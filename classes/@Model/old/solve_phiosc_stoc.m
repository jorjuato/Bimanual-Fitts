function [t,phi] = solve_phiosc_stoc(params,y0,tspan)
    if length(params)==1
        params={params};
        myinline = inline('omega + sin(2*y)','t','y','kk','omega');
    else
         myinline = inline([' [ omega1 + sin(2*y(1)) - sin(4*y(1)) + alpha*sin(y(1)-y(2)) ;' ...
                               'omega2 + sin(2*y(2)) - sin(4*y(2)) + alpha*sin(y(2)-y(1)) ]'],...
                               't','y','kk','omega1','omega2','alpha');
        %myinline = inline(['[ (omega1 + sin(2*y(1)) + alpha*sin(y(1)-y(2))) / (1-sin(4*y(1)))  ;' ...
        %                     '(omega2 + sin(2*y(2)) + alpha*sin(y(2)-y(1))) / (1-sin(4*y(2)))]'],...            
        %                    't','y','omega1','omega2','alpha');
    end
    
    options = odeset('MaxStep',.01); % maximal time integration step
    options.Q = 0.0075;                % noise strength with same dimension as variable
    options.NoiseFn = 'ynoise';      % Noise function

    [t,phi] = ode15sn(myinline,tspan,y0,options,params{:});
end