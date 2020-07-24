% From the general form :
% ( [M] * v0 ) + ( [K] * v0 )= 0 ( free vibration - no damping )
% derive the massMatrix for a linear M-Dof system FIXED at both ends
%  FIX:k1-m1-k2-m2-k3-m3-k4:FIX 
% Input is an array (row ) of masses m's

% pm_mdof_create_mmatrix_linear( [1,2,3] );
%Returns
%   [  1    0      0
%      0     2     0
%      0    0     3]

function [MMatrix] = pm_mdof_create_Mmatrix_linear( mVector)

    MMatrix = diag(mVector);
  
end








