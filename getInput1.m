function [response, responseTime] = getInput1(setup)

for i=1:length(setup.keyboardIDs)
    KbQueueCreate(setup.keyboardsIDs(i));
    KbQueueStart(setup.keyboardIDs(i));
end
ListenChar(-1)

response = NaN;

while isnan(response)
    
    for i=1:length(setup.keyboardIDs)
        [pressed, pressTime] = KbQueueCheck(keyboardIDs(i));
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