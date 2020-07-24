
% create a vector from a comma seperated list and pad out to zero other
% values
% this can be used for displacement and velocities
% example,  if dof = 7 and CSV = 0,1,2
% vector is [ 0,1,2,0,0,0,0 ]

function [vec] = pm_mdof_csv_vector ( dofLimit,  csv )
try            
        vec = zeros(1, dofLimit)';

        if ( length( csv ) > 0 ) 
           csvColumn = split(csv, ',',1);
           sz = size ( csvColumn , 1);
           % only take up the number of dof's
           limit = min ( [ dofLimit sz] );
           for j=1:limit
                 num = csvColumn( j,1);
                 if ( strcmp(num, '') )
                     value = 0;
                 else
                    value = str2double ( num ); 
                 end 
                 vec( j,1 ) = value;
           end
        end

catch e
    error('pm_mdof_csv_vector : %s',e.message);
end
          
 end 