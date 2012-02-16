function RPxx_t = get_scaled_PSD(RPxx,f,rho)
    %Compute the respective size of complete and fragment signal
    samples=length(f);
    fragment=floor(samples/rho);

    %Some indexes game
    idx=1:fragment;
    idx_t=floor(idx*rho);

    %Create output vector and fetch values from the input one
    RPxx_t=zeros(size(RPxx));
    RPxx_t(idx_t)=RPxx(idx);

    %Interpolate blank frecuencies after rescaling
    blanks=find(RPxx_t == 0);
    blanks_out=interp1(idx_t,RPxx_t(idx_t),blanks);
    blanks_out(isnan(blanks_out))=0;
    RPxx_t(blanks)=blanks_out;
end