% create a traingular pluck displacement x0 vector 
% at position with amplitude x
% returns an column vector  dof x1 elements

function [ XVector] = pm_mdof_triangle_pluck_condition( dof, position, x)

try
       if ( position <1 || position > dof )
           error('Apex Pluck position is out of bounds %d greater than dof %d ',position, dof);
       end
       %if position is not an integer 
       if ( mod(position,1) ~= 0)
           error('Apex Pluck position is not a valid mass position');
       end
       % positions start at 1 for mass 1 
       if(position == 1)
          left_gradient = x;
       else
          left_gradient = x/ (position -1);
       end
       right_gradient =  x/ ( position -dof );
       
        for (i=0:dof-1)
            if (i < position)
                if (position == 1)
                    x0(i+1) = left_gradient;
                else
                x0(i+1) = i * left_gradient;
                end
            else
                x0(i+1)= -1 *  ( (dof-i- 1) * right_gradient );
            end
        end
        XVector =x0';
 catch e
       error('pm_mdof_triangle_pluck_condition: %s',e.message);
end
 
end