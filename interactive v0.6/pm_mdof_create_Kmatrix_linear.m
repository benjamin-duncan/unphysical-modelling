 % From the general form :
% ( [M] * xdotdot ) + ( [K] * x )= 0 ( free vibration - no damping )
% derive the stiffness KMatrix for a linear M-Dof system FIXED at both ends
% To use for 3 dof FIXED-FREE set k4 =0  pm_mdof_create_kmatrix_linear( [1,1,1,0] ); 
% To use for 3 dof FREE-FREE set k1=0,k4 =0 ,  pm_mdof_create_kmatrix_linear( [0,1,1,0] ); 
% Input is an array (row ) of stiffness K's
% the array size has  dof + 1 elements
% Example 3 -dof
% [  k1+k2    -k2        0
%     -k2     k2+k3    -k3
%      0     -k3      k3 +4 ]
% pm_mdof_create_kmatrix_linear( [1,1,1,1] );
%Returns
%   [  2    -1     0
%     -1     2    -1
%      0    -1     2 ]


function [KMatrix] = pm_mdof_create_Kmatrix_linear( kVector)

    try
        dof = length( kVector) -1 ;
        % create a dof length vector of values k1+k2, k2+k3, k3+k4
        addedKs= zeros(dof,1);  
        for ( i = 1:dof )
            addedKs(i) = kVector (i) + kVector(i+1);
        end
        % diagonal out of k1+k2, k2+k3, k3+k4
        KMatrix = diag(addedKs);
        % vector of negative k's starting at position 2
         negativeKs = zeros(dof-1,1);
        for ( i = 2:dof)
            negativeKs(i-1) = -kVector (i);
        end
        % apply diagonally either size of the k matrix 
        for ( i = 1:dof -1 )
            KMatrix( i, i+1 ) = negativeKs(i);
            KMatrix( i+1, i ) = negativeKs(i);
        end
        if ( issymmetric( KMatrix ) == 0 )
             error('**** Error. \nCalculated [K] Matrix is incorrect ( not symmetrical )' )
        end
        
    catch e
        error('pm_mdof_create_Kmatrix_linear: %s',e.message);
    end
end








