%TIME_VARIANT_PICKUP Introduces Time-Variant Pickup for Outputs
% The pickup can sweep to and forth along along mass chain
% If sweep is 1, it will pickup up proportionally from M1,M2,..Mn and Stop.
% If sweep is 2 , it will pickup up proportionally from M1,M2,..Mn and then 
% back to ..M2,M1
% For a 4 DOF System - 1,2,3,4
% sweep 1 = 1,2,3,4    = 4 slices 
% sweep 2 =  1,2,3,4,3,2,1  = 7 slices 
% sweep 3 =  1,2,3,4,3,2,1,2,3,4  = 10 slices
% slices = ( sweeps * ( dof -1 )  + 1
% when the slices count has been determined, this results in a slice-size
% for the time element of the amplitude matrix
function [soundMoves, pickupArray] = pm_mdof_time_variant_pickup(amplitudes, sweeps, mode )


try 
    if ( strcmp(mode,'Amplitude Input')==0 && strcmp(mode,'Moving Linear') ==0 && strcmp(mode,'Moving Linear Reset') == 0  )
       error ('Invalid mode %s', mode );
    end
    [dof,timeSlots]=size(amplitudes);
    soundMoves = zeros(1,timeSlots);
     
    if strcmp(mode,'Amplitude Input')
        if ( sweeps <1 || sweeps > dof )
            error('mass %d for Amplitude Input is ouf of bounds ', sweeps);
        end
       % pickupArray = zeros(1,timeSlots);
        % for now use sweeps as the input mass 
        pickupArray = amplitudes(sweeps,:);
        pickupArray = pm_mdof_normalise_audio(pickupArray);
        pickupArray=pickupArray+1;
        pickupArray=pickupArray*((dof-1)/2);
        pickupArray=pickupArray+1;
%         pickupArray=pickupArray*((dof-1)/20);
%         pickupArray=pickupArray+(dof/3)+0.5;
        pickupArray=round(pickupArray);
    
        for i=1:timeSlots
             soundMoves(i) = amplitudes(pickupArray(i),i);
        end
        return
    end

   
    slices = ( sweeps * ( dof -1 ) )  + 1;
    sliceVal = timeSlots/slices;
    slice = round(sliceVal);
    maxSweeps = floor( ( timeSlots -1 )/ ( dof -1 ) );
    if ( sliceVal < 1 )
        error('Maximum Sweep count is %d', maxSweeps);
    end
    direction = 1;
    pos = 0;
    for i=1:slice:timeSlots    
        pos = pos + direction;
        m = mod ( pos, dof);    
        if ( m == 0 )
             if ( strcmp(mode,'Moving Linear') )
                 direction = direction *  -1;
                 if ( pos == 0 && direction == 1)
                     pos = 2;
                 end
             end
        end
        endExtract = (i + slice - 1);
        if  ( endExtract > timeSlots )        
            endExtract = timeSlots;
        end
        extract = amplitudes(pos,i:endExtract);                             
        for ( x= 1:length(extract) )
          pickupArray(i+x-1) = pos;
          soundMoves(i+x-1) = extract(x);
        end 
        
%        s = sprintf("i = %d  pos = %d m = %d  dir =%d ", i, pos,m , direction);
%        disp ( s);
       disp( extract);
       if ( strcmp(mode,'Moving Linear Reset') &&  m == 0  ) 
           pos = 0;
       end
    end 
catch e
    str = sprintf('pm_mdof_time_variant_pickup : %s',e.message);
    %disp(str);
    error ( str);
end

end

