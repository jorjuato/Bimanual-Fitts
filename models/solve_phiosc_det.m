function [t,phi] = solve_phiosc_det(params,y0,tspan)
    [omega1,omega2,alpha]=params{:};
    options = odeset('RelTol',1e-6,'AbsTol',[1e-7 1e-7]);    
    [t,phi] = ode23(@phase_oscillators,tspan,y0,options);
    
    function dy = phase_oscillators(t,y)
        dy = zeros(2,1);    % a column vector
        dy(1) = omega1 + sin(2*y(1)) + alpha*sin(y(1)-y(2));
        dy(2) = omega2 + sin(2*y(2)) + alpha*sin(y(2)-y(1));
    end
end