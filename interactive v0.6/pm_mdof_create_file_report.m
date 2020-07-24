% function to generate a report file from interactive GUI runtime experiments
% optionally enter upto 4 figures related to the report
% will save the figures as PNG's and write them to the report 
% the figures MUST have Names !! ie outside the function fig1 = figure('Name','My Plot');

function [folder_name] = pm_mdof_create_file_report( uc , fig1,fig2,fig3,fig4)

 try
    % folder_name = sprintf('c:\\temp\\PM_REPORTS\\%s',datestr(now,'mm-dd-yyyy HH-MM-SS'));
    if ( uc.significant )
        folder_name = sprintf('c:\\temp\\PM_REPORTS\\%s\\%s_SIGNIFICANT',datestr(now,'dd-mm-yyyy'), datestr(now,'HH-MM-SS'));
    else
        folder_name = sprintf('c:\\temp\\PM_REPORTS\\%s\\%s',datestr(now,'dd-mm-yyyy'), datestr(now,'HH-MM-SS'));
    end
    presets_folder_name = 'c:\\temp\\PM_REPORTS\\Presets';
    if not(exist(folder_name,'dir'))
            mkdir(folder_name);
    end
    if not(exist(presets_folder_name,'dir'))
            mkdir(presets_folder_name);
    end

    reportFilename = sprintf('%s\\PM_MDOF_RUN_REPORT.txt', folder_name );

    %open file identifier
    fid=fopen(reportFilename,'w');

    fprintf(fid, '------------------------------------------------ \n');
    fprintf(fid, 'Physical Model Run Report \n');
    fprintf(fid, 'Ben Duncan , Year 3 Project - University of York\n');
    fprintf(fid, '------------------------------------------------ \n');
    fprintf(fid, 'Report File: %s\n', reportFilename);
    fprintf(fid, 'Generated  : %s\n', datestr(now,'mm-dd-yyyy HH:MM:SS'));

    % This report does NOT show the matrices
    % only the vectors and value sused to derive the matrices

    fprintf(fid, '-------------------------------------------------\n');
    fprintf(fid, 'CONTROL PARAMETERS:\n');
    fprintf(fid, '-------------------------------------------------\n');
    fprintf(fid, 'DOF           : %d\n',      uc.dof);
    fprintf(fid, 'Boundary      : %s\n',      uc.boundary);  % fixed-fixed, fixed-free, free-free
    fprintf(fid, 'x0Vector      : %s\n',      uc.x0VectorName);
    fprintf(fid, 'v0Vector      : %s\n',      uc.v0VectorName);
    fprintf(fid, 'kVector       : %s\n',      uc.kVectorName);
    fprintf(fid, 'mVector       : %s\n',      uc.mVectorName);
    fprintf(fid, 'zVector       : %s\n',      uc.zVectorName);
    fprintf(fid, 'k             : %.2f\n',    uc.k);
    fprintf(fid, 'm             : %.7f\n',    uc.m);
    fprintf(fid, 'zeta          : %.7f\n',    uc.zeta);
    fprintf(fid, 'duration      : %d\n',      uc.period);
    fprintf(fid, 'fs            : %d\n',      uc.fs);
    fprintf(fid, 'Lpickup point : %d\n',      uc.pickupPoint);
    fprintf(fid, 'Rpickup point : %d\n',      uc.rightPickupPoint);
    fprintf(fid, 'pickup Method : %s\n',      uc.pickupMethod);
    fprintf(fid, 'Stereo        : %d\n',      uc.stereo);
    naturalsStr = sprintf(repmat('%d ', 1, length(uc.naturals)), uc.naturals);
    fprintf(fid, 'naturals     : %s\n',      naturalsStr);

    report_save_audio_wav( fid, folder_name, '',  uc );

    if ( nargin > 1 )
        report_save_figures(fid, folder_name,  fig1, 1);
    end
    if ( nargin > 2 )
        report_save_figures(fid, folder_name,  fig2, 2);
    end
    if ( nargin > 3 )
         report_save_figures(fid, folder_name,  fig3,3);
    end
    if ( nargin > 4 )
         report_save_figures(fid, folder_name, fig4,4);
    end
    fprintf(fid, '\n');
    fprintf(fid, '-------------------------------------------------\n');
    fprintf(fid, 'ANALYSIS SUMMARY:\n');
    fprintf(fid, '-------------------------------------------------\n');
    if(uc.significant == 1)
        fprintf(fid,'THIS RESULT IS SIGNIFICANT\n');
    end
    % write the  summary text in the UseCase structure 
    fprintf(fid, uc.summaryText);
    fclose(fid);

    % save the use case 
    report_save_use_case( folder_name,presets_folder_name , uc);

 catch e
        error('pm_mdof_create_file_report: %s',e.message);
 end
end

% the figures should have names outside the function fig1 = figure('Name','My Plot');
% if not a generic name is created 
function report_save_figures( fileID, folder_name,  figureObject, figureNumber ) 
    name = figureObject.Name;
    if ( strcmp(name,'' ) )
        % if the figure doesnt have a Name create one eg. 'Figure_1'
         name = sprintf('Figure_%d',figureNumber);
    end
    %write an entry in the report file 
    fprintf(fileID, 'figure%d      : %s\n', figureNumber, name); 
    %save the figure as PNG in the report folder 
    figFilename = sprintf('%s\\%s.png', folder_name , name);
    saveas(figureObject,figFilename);
end

function report_save_audio_wav( fileID, folder_name, filename,  uc) 
   if ( strcmp (filename,'') )
        filename =  datestr(now,'mm_dd_yyyy_HH_MM_SS');
   end
     
   normalisedL = pm_mdof_normalise_audio(uc.soundAmp);
    if ( ~uc.stereo )
         wavFilename = sprintf('%s\\%s.wav', folder_name , filename);
         audiowrite(wavFilename, normalisedL, uc.fs);
    else
         normalisedR = pm_mdof_normalise_audio(uc.soundAmpRight);
         wavFilename = sprintf('%s\\%s-STEREO.wav', folder_name , filename);
         stereo_sound = [normalisedL(:), normalisedR(:)];
         audiowrite(wavFilename, stereo_sound  ,uc.fs);
    end  
   
   
   fprintf(fileID, 'WAV File     : %s\n', wavFilename); 
   

end 

function report_save_use_case( folder_name, presets_folder_name, uc) 
   
   if ( uc.significant )
       datestr(now,'ddmmyy'), datestr(now,'HHMMSS')
       matFilename = sprintf('%s\\UC_%s_%s_SIGNIFICANT.mat', folder_name, datestr(now,'ddmmyy'), datestr(now,'HHMMSS') );
       matFilenamePreset = sprintf('%s\\UC_%s_%s_SIGNIFICANT.mat', presets_folder_name, datestr(now,'ddmmyy'), datestr(now,'HHMMSS') );
       save(matFilenamePreset, 'uc' );
   else
       matFilename = sprintf('%s\\UseCase.mat', folder_name );
   end   
   save(matFilename, 'uc' );
  
   
end 
