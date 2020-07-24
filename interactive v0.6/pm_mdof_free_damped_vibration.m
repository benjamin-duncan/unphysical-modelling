% M - Mass Matrix , K - Stiffness Matrix 
% x0 (displacement) and v0 ( velocity ) as column vectors for the masses
% time span 't:interval:extent' over which to the calculate displacements
% Based on the initial conditions
% The Katrix could be representative of a fixed-fixed or fixed-open etc
% boundary condition
% zetas is a vector of modal damping ratios( ie damping applied to each mode
% zetas must be < 1 , as equation is based on Underdamping
% amplitudes returned as N rows * length(t) - 1 row for each mass 
function [amplitudes, omegas, naturals, eigenVectors, eigenValues] = pm_mdof_free_damped_vibration(M,K,zetas,x0,v0,t)
try
    maxZeta = max(max(zetas));
    minZeta = min(min(zetas));

    if (  maxZeta >= 1 ||  minZeta < 0 )
        error ( 'Values for zeta damping must be  0 <= zeta < 1 for an underdamped system (max,min)=(%d,%d)', minZeta, maxZeta  );
    end

    [dofs,cols]=size(M);
    xSz = length( x0);
    vSz = length( v0);
    zSz = length( zetas);
    [kdofs,kcols]=size(K);

    if ( xSz ~= dofs || vSz ~= dofs || zSz ~= dofs || kdofs ~= dofs || kcols ~= dofs || cols ~= dofs)
         error ('Values of the input paramters are not for the same DOF dimensions' );
    end


    amplitudes= zeros(dofs,length(t));
    [eigenVectors,eigVals]=eig(K,M);
    % Each eigenVector returned is a column
    % the eigVals are returned as a diagonal, change to a vector
    eigenValues = diag(eigVals);

    omegas=sqrt(eigenValues);
    naturals = omegas/(2*pi); % frequency in Hertz

    % normalize the eigen vectors to the mass matrix
    parfor dof=1:dofs
        norm=sqrt(eigenVectors(:,dof)'*M*eigenVectors(:,dof));
        eigenVectors(:,dof)=eigenVectors(:,dof)/norm;
    end

    dampedOmegas =  omegas.*sqrt(1-zetas.^2);

    parfor dof=1:dofs
        zeta  = zetas(dof);
        eigenVector = eigenVectors(:,dof);
        eigenArray = eigenVector';
        omega = omegas(dof);
        dampedOmega = dampedOmegas(dof);
        ampT= eigenVector*(eigenArray * M* x0*cos(omega.*t)/sqrt(1-zeta^2) + eigenArray*M*v0/omega *sin(omega.*t)/dampedOmega);
        ampT =  ampT.*exp(-zeta*omega.*t);
        % add the parts to form the total ( superposition of modes )
        amplitudes=amplitudes+ampT;
    end
catch e
    error('pm_mdof_free_damped_vibration : %s',e.message);
end
end