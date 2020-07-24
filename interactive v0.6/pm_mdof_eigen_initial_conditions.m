% M - Mass Matrix , K - Stiffness Matrix 
% return mass normalized eigen values for initial conditions
function [eigenVectors, eigenValues] = pm_mdof_eigen_initial_conditions(M,K)

try
    [dofs,cols]=size(M);
    [kdofs,kcols]=size(K);

    if (  kdofs ~= dofs || kcols ~= dofs || cols ~= dofs)
         error ('Values of the input paramters are not for the same DOF dimensions' );
    end


    [eigenVectors,eigVals]=eig(K,M);
    % Each eigenVector returned is a column
    % the eigVals are returned as a diagonal, change to a vector
    eigenValues = diag(eigVals);

    % normalize the eigen vectors to the mass matrix
    for dof=1:dofs
        norm=sqrt(eigenVectors(:,dof)'*M*eigenVectors(:,dof));
        eigenVectors(:,dof)=eigenVectors(:,dof)/norm;
    end

catch e
    error('pm_mdof_eigen_initial_conditions : %s',e.message);
end
end
