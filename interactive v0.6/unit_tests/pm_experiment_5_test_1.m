%Tests whether 

classdef pm_experiment_5_test_1 < matlab.uitest.TestCase
    
    properties
    App
    %useCase_exp
    end
    
    methods (TestMethodSetup)
        function testAmplitudeInput(testCase)
            testCase.App = pm_interactive_0_6;
            %testCase.addTearDown(@delete,testCase.App);
            %testCase.useCase_exp = UseCase_exp_5;
        end
    end
    
    
    methods(Test)
        function testPlot(testCase)
        
            testCase.press(testCase.App.plotButton);
            plot = isempty(testCase.App.inputUseCase.soundAmp);
            testCase.verifyEqual(plot,false);

             testCase.verifyEqual(plot,false);
%             testCase.App.delete;
        end
        
%         function testPlot2(testCase)
%         
%             testCase.press(testCase.App.plotButton);
%             plot = isempty(testCase.App.inputUseCase.soundAmp);
%             testCase.verifyEqual(plot,false);
% 
%             testCase.App.delete;
%         end
        %function testPresets(testCase)
            
            
    end
            
end