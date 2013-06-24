function [t,phi] = solve_phiosc_det(params,y0,tspan)

    if length(params)==1
        omega=params;
        options = odeset('RelTol',1e-9,'AbsTol',1e-7);
        fcn=@phase_oscillator;
    else
        [omega1,omega2,alpha]=params{:};
        options = odeset('RelTol',1e-6,'AbsTol',[1e-7 1e-7]);
        fcn=@phase_oscillators_coupled;
    end


        function dy = phase_oscillator(t,y)
            %dy = zeros(1,1);    % a column vector
            dy = omega + sin(2*y);
        end

        function dy = phase_oscillators_coupled(t,y)
            dy = zeros(2,1);    % a column vector
            dy(1) = omega1 + sin(2*y(1)) + alpha*sin(y(1)-y(2));
            dy(2) = omega2 + sin(2*y(2)) + alpha*sin(y(2)-y(1));
        end

    [t,phi] = ode23(fcn,tspan,y0,options);
end