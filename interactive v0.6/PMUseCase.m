% UseCase is structure to hold all the control parameters and calculated
% responses
classdef PMUseCase < handle
   
    % transient properties are not saved - minimises file size
    properties ( Transient = true ) 
        % outputs
        eigenVectors;
        eigenValues;
        omegas;
        naturals;
        amplitudes;
        pickupArray;
        soundAmp; % ie mass to plot / sound 
        soundAmpRight;
        t; % time array ie  0:1/(uc.fs):uc.period;
        K,
        M;
    end
    properties
        dof ;
        dofArray; % ie 1:dof
        boundary;
        k ;
        m;
        x;
        v;
        zeta;
        pluckPosition;
        x0Vector;
        v0Vector;
        kVector;
        mVector;
        zVector;
        x0VectorName;
        v0VectorName;
        kVectorName;
        mVectorName;
        zVectorName;
        fs;
        period;       
        pickupPoint;
        rightPickupPoint;
        summaryText;
        significant;
        moves;
        pickupMethod;
        sweeps;
        stereo;
        reserved2;
        reserved3;
    end
    
    methods
      function obj = PMUseCase()
      end
   end
end

