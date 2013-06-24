function justdoit(alphar,omr)
    if nargin<2, omr=0.5:0.5:2;end
    if nargin<1, alphar=2;end

    % show_model_byinitconditions()
    % plot_toroidal_trajectories()
    % [PH1,PH2,dPH1,dPH2]=get_vector_fields();

    syms phi omega

    or=length(omr);
    ar=length(alphar);
    figure; k=0;
    for i=1:ar
        for j=1:or
            k=k+1;
            %subplot(i,j,j+j*(i-1)); ezplot(subs(fcn,[alpha,omega],[alphar(i),omr(j)]));
            fcn=int(1/(omega+sin(alphar(i)*phi)),phi);
            subplot(ar,or,k); ezplot(subs(abs(diff(fcn)),[omega],[omr(j)]));
            title('')
            ylabel('')
            xlabel('')
        end
    end
end
