% function to return initial conditions vectors
% all or some them can be applied to displacements, velocities
% masses, stiffness and damping modal coefficents
% example, N,0,0,0,N would not be applicable to masses or stiffness
% arg4 is for the pluck position
function [ vector] = pm_create_initial_condition_vector( dof, modeStr, arg3, pluckPosition)

   % remove any white spaces '1,2 ,3, 4,5 ' 
   % becomes '1,2,3,4,5' 
   % 'Triangle Pluck' becomes 'TrianglePluck'
   
   mode = modeStr(~isspace(modeStr));
    % INITIAL CONDITIONS 
   % the ' will transpose 1 X N matrix to N x 1 ( Vector )  
   vector = zeros(1,dof)';
   
   switch mode 
       case 'LinearIncrease' % increases for each mode up to arg3
%             if ( nargin ~= 3 )
%               error('**** Error. \nRequire a 3 arguments to apply increase condition')
%            end 
           for i=1:dof
                vector(i,1)=i*arg3/dof;
           end
           return;
       case 'LinearDecrease' % decreases for each mode starting at arg3
           for i=1:dof
                vector(dof-i+1,1)=i*arg3/dof;
           end
           return;
       case 'Linear'
           vector = ones(1,dof)';
       case 'None' 
           vector = zeros(1,dof)';
       case 'Triangle' 
           vector = pm_mdof_triangle_pluck_condition( dof, pluckPosition, arg3);
           % already scaled so just return 
           return;
       case 'SoftTriangle' 
           vector = pm_mdof_triangle_pluck_condition( dof,pluckPosition, arg3);
           vector = lowpass(vector,0.2);
           % already scaled so just return 
           return;
       case 'Bell'
           temp = zeros(1,dof); 
           scale = 1000;
           step = 1/ scale;
           x = [-3:step:3];
           y = normpdf(x,0,1);
           r = length(y)/dof;
           for (  i= 1:dof )
              pos = round ( i * r );
              temp( i) =  y (pos);
           end
           vector = temp';
    
     case 'Step'
           direction = 1;
           cnt=1;
           for ( i = 1 : dof )
               vector(i) = direction ;
               if ( mod(cnt,5) == 0 )
                 direction = direction * -1;
               end 
               cnt = cnt +1;
           end
           
     case 'N_2N_4N_8N'
          marray = 1 *  2.^(0:dof-1);
          vector = marray';
         
      case 'N_2N_3N_4N'
         vector = (1:dof)';
   
      case 'N_2N_N_2N'
          temp = ones(1,dof); 
           for ( i=1:dof)
               if (mod(i,2) == 0 )
                   temp(i) = 2;
               end
           end  
           vector = temp';
      case 'N_N_N_2N_2N_2N_N_N_N'
           temp = ones(1,dof); 
           for ( i=1:dof)
               a = ceil( i/3);
               if (mod(a,2) == 0 )
                   temp(i) = 2;
               end
           end  
           vector = temp';
           
       % These are more applicable for MASSES ie mass values
       % should not be ZERO or NEGATIVE
       case 'N,0,0,0,-N'
           vector(1) = -1;
           vector(dof) = +1;
       case 'N,0,0,0,N'
           vector(1) = +1;
           vector(dof) = +1;
        case '0,0,N,0,0'
           %  0, 0, 0, 1 , 0, 0 , 0
           if ( mod ( dof, 2 ) == 0 )
              error('**** Error. \nThere is no middle mass of a System with Dof: %d.', dof)
           end 
           vector( ceil( dof/2 ) ) = 1;
        case '0,0,-N,N,0,0'
           if ( mod ( dof, 2 ) == 1 )
              error('**** Error. \nThere is no middle mass pair of a System with Dof: %d.', dof)
           end 
           vector(  dof/2  ) = -1;
           vector(  (dof/2) + 1  ) = 1;
       case '0,N,-N,N,0'
           if ( mod ( dof, 2 ) == 0 )
              error('**** Error. \nThere is no middle mass set of a System with Dof: %d.', dof)
           end 
           vector(  ceil( dof/2 ) -1  ) = +1;
           vector(   ceil( dof/2 ) ) = -1;
           vector(  ceil( dof/2 ) +1  ) = +1;
   
       case 'N,-N,N,-N,N'
           direction = 1;
           for ( i = 1 : dof )
               vector(  i ) = direction ;
               direction = direction * -1;
           end

       otherwise
         disp(['Applying CSV for input : ' mode]);
         % assume comma seperated list if not already processed
         vector = pm_mdof_csv_vector (dof, modeStr );
         
   end
   % scale the vector   
   vector = arg3 * vector;
  
end

