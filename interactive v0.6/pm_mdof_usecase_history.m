% history of PMUseCase accessible from app
% allows for easy comparison of systems
classdef pm_mdof_usecase_history < handle
    
  properties 
      cursor;
      head ;
      maxEntries ;
      historyArray ;
   end
     
   methods
      function obj = pm_mdof_usecase_history(size)
          obj = init(obj, size);
          disp('constructor called ');
      end
      
      function obj = init(obj,size)
          obj.historyArray =  PMUseCase();
          obj.cursor = 0;
          obj.head = 0;
          obj.maxEntries = size;
      end
   end
   
     methods 
         
        function obj = cursorBack( obj )
           apos = obj.cursor -1;
           histLength = length( obj.historyArray );
           if ( apos < 1 )
               apos = histLength; 
           end
           obj.cursor = apos;
        end
        
        function obj = cursorForward( obj )
           apos = obj.cursor +1;
           histLength = length( obj.historyArray );
           if ( apos > histLength )
               apos = 1; 
           end
           obj.cursor = apos;
        end

        function calc = save( obj , inEntry)
           debug(obj, 'save start');
           apos = obj.head +1;
           if ( apos > obj.maxEntries)
               apos = 1; 
           end
           debug(obj, ' save mid');
           obj.historyArray(1,apos)=inEntry;
           debug(obj, ' save end');;
           obj.head = apos;
           obj.cursor = apos;
           calc = inEntry;
           
        end
        
        function outputCalc = next(obj)
            cursorForward(obj);
            outputCalc = obj.historyArray(obj.cursor);
        end
        
        function outputCalc = previous(obj)
            cursorBack(obj);
            outputCalc = obj.historyArray(obj.cursor);
        end
        
        function counts = entries(obj)
           counts =  length( obj.historyArray );  
        end
        
        function posStr = getPosition(obj)
            posStr = sprintf("%d/%d", obj.cursor,length( obj.historyArray )); 
        end
        
       function str = debug(obj, str)
           disp(str);
           cnt = length( obj.historyArray );
           dStr = sprintf('head=%d ,cnt=%d, cursor = %d',obj.head,cnt, obj.cursor) ;
           for ( i = 1:cnt)
               disp ( obj.historyArray(i).dof );
           end
           str = dStr;
       end
        
       function obj = clear(obj)
          obj.historyArray = PMUseCase();
          obj.cursor = 0;
          obj.head = 0;
       end
     end
end

