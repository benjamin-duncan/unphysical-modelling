% dofs + 1 number of springs  
% example for 3 masses , there are 4 springs {k's ) k-M-k-M-k-M-k
% for non fixed boundary conditions set the spring stiffness to zero.
function [vector]=pm_mdof_modify_k_vector(kvector, boundaryMode )
 
  try
      springs = length( kvector );
      switch boundaryMode 
           case 'fixed-fixed'
               vector = kvector;
           case 'fixed-free'
               vector = kvector;
               vector(  springs)=0;
           case 'free-free'    
               vector = kvector;
               vector(1)=0;
               vector( springs)=0;
         otherwise
              error(['**** Error. \nInvalid boundary mode : ' boundaryMode] );
      end
    catch e
        error('pm_mdof_modify_k_vector: %s',e.message);
    end
end