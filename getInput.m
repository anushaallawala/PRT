function [response, responseTime] = getInput(setup)
% Switched from KbQueueCheck to KbCheck to avoid compatability issues in
% EMU - JA 20190808
for i=1:length(setup.keyboardIDs)
    KbQueueCreate(setup.keyboardIDs(i));
    KbQueueStart(setup.keyboardIDs(i));
end
ListenChar(-1)

response = NaN;

while isnan(response)
    
    for i=1:length(setup.keyboardIDs)
        [pressed, pressTime] = KbQueueCheck(setup.keyboardIDs(i));
    end
    %     [pressed, pressTime] = KbQueueCheck();
    if pressed
        
        %         % Earliest Key Pressed Since Last Call to KbQueueCheck
        %         response = KbName(find(pressTime==min(pressTime(pressTime~=0))));
        % Most Recent Key Pressed Sincle Last Call to KbQueueCheck
        response = KbName(find(pressTime==max(pressTime)));
        
        if strcmpi(response,'escape')
            ListenChar(0)
            sca
            error('Experiment Terminated')
        end
        break
    end
end
responseTime = pressTime(pressTime==max(pressTime));
KbQueueStop();
ListenChar(0)
end
% % KbQueueCreate();
% % KbQueueStart();
% ListenChar(-1)
% 
% response = NaN;
% 
% while isnan(response)
%     
%     [pressed, pressTime, keyCode] = KbCheck(-1);
%     %     [pressed, pressTime] = KbQueueCheck();
%     if pressed
%         response = KbName(find(keyCode==1,1));
%         
%         %         % Earliest Key Pressed Since Last Call to KbQueueCheck
%         %         response = KbName(find(pressTime==min(pressTime(pressTime~=0))));
%         % Most Recent Key Pressed Sincle Last Call to KbQueueCheck
%         %         response = KbName(find(pressTime==max(pressTime)));
%         
%         if strcmpi(response,'escape')
%             ListenChar(0)
%             sca
%             error('Experiment Terminated')
%         end
%         break
%     end
% end
% responseTime = pressTime(pressTime==max(pressTime));
% % KbQueueStop();
% ListenChar(0)
% end