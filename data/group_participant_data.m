function dataout=group_participant_data(datain)
%Gives unconsistent results, recommeded to use merge_participant_data
%Until debugging is done...

    C=[2,3,6,8,9];
    U=[1,4,5,7,10];
    
    if length(size(datain))==7 
        %Bimanual data matrix
        [vno, hno, pp, ss, idl, idr, reps]=size(datain);
        dataout=zeros(vno,hno, 2, ss, idl, idr, reps*5);
        for v=1:vno
            %Variable name
            for h=1:hno
                %Hand, 1=Left; 2=Right
                idx1=1;idx2=1;
                for p=1:pp
                    %Participant number, 1-10
                    if any(C==p)                        
                        dataout(v,h,1,:,:,:,idx1:idx1+reps-1)=squeeze(datain(v,h,p,:,:,:,:));
                        idx1=idx1+reps;
                    else                        
                        dataout(v,h,2,:,:,:,idx2:idx2+reps-1)=squeeze(datain(v,h,p,:,:,:,:));
                        idx2=idx2+reps;
                    end
                end
            end
        end
    else 
        %Unimanual data or delta ID data
        [vno, hno, pp, ss, id, reps]=size(datain);
        dataout=zeros(vno,hno, 2, ss, id, reps);
        for v=1:vno
            %Variable name
            for h=1:hno
                %Hand, 1=Left; 2=Right
                idx1=1;idx2=1;
                for p=1:pp
                    %Participant number, 1-10
                    if any(C==p)                        
                        dataout(v,h,1,:,:,idx1:idx1+reps-1)=squeeze(datain(v,h,p,:,:,:));
                        idx1=idx1+reps;
                    else                        
                        dataout(v,h,2,:,:,idx2:idx2+reps-1)=squeeze(datain(v,h,p,:,:,:));
                        idx2=idx2+reps;
                    end
                end
            end
        end
    end
end