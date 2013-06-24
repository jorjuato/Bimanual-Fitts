function x=resize_vector(arr,newL)
    oldL=length(arr);
    t=linspace(1,oldL,newL);
    x=interp1(1:oldL,arr,t);
end