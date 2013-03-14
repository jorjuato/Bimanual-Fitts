function Pxx_t = get_scaled_PSD(Pxx,f,rho)
    %Compute the respective size of complete and fragment signal
    samples=length(f);
    fragment=floor(samples/rho);

    %Some indexes game
    idx=1:fragment;
    idx_t=floor(idx*rho);

    %Create output vector and fetch values from the input one
    Pxx_t=zeros(size(Pxx));
    Pxx_t(idx_t)=Pxx(idx);

    %Interpolate blank frecuencies after rescaling
    blanks=find(Pxx_t == 0);
    blanks_out=interp1(idx_t,Pxx_t(idx_t),blanks);
    blanks_out(isnan(blanks_out))=0;
    Pxx_t(blanks)=blanks_out;
end