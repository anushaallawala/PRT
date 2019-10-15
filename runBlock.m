function runBlock(screen,face,cross,setup,iBlock)
flickerDur = screen.ifi*3;  % NOTE: This value must be small so that it doesn't exceed faceStimDur
facePreStimDur = 0.5;
faceStimDur = 0.097;
feedbackDur = 1.5;

if iBlock > 1
    %Key Map Text Changed to Correspond to Input Device - JA 20190808 
    experimentBreak2 = ['Remember, the LEFT button is used to identify the Short ',...
        lower(setup.stimulusVersion),' and\nthe RIGHT button is used to identify the Long ',...
        lower(setup.stimulusVersion),'.\n\n[Press any key to resume the experiment]'];
%     experimentBreak2 = ['Remember, the ''',upper(setup.longKeyMap),''' button is used to identify the Long ',...
%         lower(setup.stimulusVersion),' and\nthe ''',upper(setup.shortKeyMap),''' button is used to identify the Short ',...
%         lower(setup.stimulusVersion),'.\n\n[Press any key to resume the experiment]'];
    DrawFormattedText(screen.windowHandle,experimentBreak2,'center','center',screen.foregroundColor);
    Screen('Flip',screen.windowHandle);
    getInput(setup);
end
results.blockNumber = iBlock;
results.stimulusVersion = setup.stimulusVersion;
setup.timeBlockStart = datestr(now);
leanFeedDue=0;
richFeedDue=0;
setup.adjReinSched = setup.initReinSched;
for iTrial=1:setup.trialsPerBlock
    
    results.trialNumber = iTrial;
    switch setup.trialSeq(iTrial)
        case 1
            results.stimulusType{iTrial} = 'Short';
        case 2
            results.stimulusType{iTrial} = 'Long';
    end
    correct = NaN;
    
    % Fixation Cross
    fixationCrossJitter = (0.700+randi(4)*.05);
    Screen('DrawLines',screen.windowHandle,cross.coords,cross.barThickness,screen.foregroundColor,screen.centerCoord);
    Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
    [fixCrossOnset] = Screen('Flip',screen.windowHandle);
    Screen('DrawLines',screen.windowHandle,cross.coords,cross.barThickness,screen.foregroundColor,screen.centerCoord);
    Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
    Screen('Flip',screen.windowHandle,fixCrossOnset+flickerDur);
    
    % Draw Face without Stimulus
    drawFace(screen,face,setup.trialSeq(iTrial),false,setup.stimulusVersion);
    Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
    Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter);
    drawFace(screen,face,setup.trialSeq(iTrial),false,setup.stimulusVersion);
    Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
    Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+flickerDur);
    
    % Draw Face with Stimulus
    drawFace(screen,face,setup.trialSeq(iTrial),true,setup.stimulusVersion);
    Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
    [faceTwoOnset] = Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+facePreStimDur);
    drawFace(screen,face,setup.trialSeq(iTrial),true,setup.stimulusVersion);
    Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
    Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+facePreStimDur+flickerDur);
    
    % Draw Face without Stimulus
    drawFace(screen,face,setup.trialSeq(iTrial),false,setup.stimulusVersion);
    Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
    Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+facePreStimDur+faceStimDur);
    drawFace(screen,face,setup.trialSeq(iTrial),false,setup.stimulusVersion);
    Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
    Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+facePreStimDur+faceStimDur+flickerDur);
    
%     fixCrossTiming = faceOneOnset-fixCrossOnset;
%     faceOneTiming = faceTwoOnset-faceOneOnset;
%     faceTwoTiming = faceThreeOnset-faceTwoOnset;
    
    
    [response, responseTime]=getInput(setup);
    
    
    
    % Determine if correct response
    switch setup.trialSeq(iTrial)
        % Little Stimuli
        case 1
            if strcmpi(setup.shortKeyMap,response)
                correct = 1;
            else
                correct = 0;
            end
            % Big Stimuli
        case 2
            if strcmpi(setup.longKeyMap,response)
                correct = 1;
            else
                correct = 0;
            end
    end
    
    results.responseKey{iTrial} = response;
    results.correctResponse(iTrial) = correct;
    results.reactionTime(iTrial) = responseTime - faceTwoOnset;
    
    
    
    switch correct
        
        % Correct Response
        case 1
            % Display Positive Feedback?
            % NO
            if isnan(setup.adjReinSched(iTrial))
                results.feedbackOccurance(iTrial)=0;
                results.feedbackDue(iTrial)=0;
                results.leanFeedbackDue(iTrial)=leanFeedDue;
                results.richFeedbackDue(iTrial)=richFeedDue;
                
                % Inter-Trial Delay
                Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
                [estFeedbackOnset] = Screen('Flip',screen.windowHandle);
                Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
                Screen('Flip',screen.windowHandle,estFeedbackOnset+flickerDur);
                WaitSecs(2)
                continue
                % YES
            else
                results.feedbackOccurance(iTrial)=1;
                results.feedbackDue(iTrial)=1;
                switch setup.adjReinSched(iTrial)
                    case -1
                        leanFeedDue=leanFeedDue-1;
                        leanFeedDue(leanFeedDue<=0)=0;
                        results.leanFeedbackDue(iTrial)=leanFeedDue;
                        results.richFeedbackDue(iTrial)=richFeedDue;
                        
                    case 1
                        richFeedDue=richFeedDue-1;
                        richFeedDue(richFeedDue<=0)=0;
                        results.leanFeedbackDue(iTrial)=leanFeedDue;
                        results.richFeedbackDue(iTrial)=richFeedDue;
                end
                
                % Display Positive Feedback based on Reinforcement Schedule
                % Text changed to denote scoring points instead of earning money - JA
                % 20190808
                DrawFormattedText(screen.windowHandle,'Correct!! You scored 20 points!','center','center',screen.foregroundColor);
%                 DrawFormattedText(screen.windowHandle,'Correct!! You win 20 cents.','center','center',screen.foregroundColor);
                Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
                [estFeedbackOnset] = Screen('Flip',screen.windowHandle);
                DrawFormattedText(screen.windowHandle,'Correct!! You scored 20 points!','center','center',screen.foregroundColor);
%                 DrawFormattedText(screen.windowHandle,'Correct!! You win 20 cents.','center','center',screen.foregroundColor);
                Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
                Screen('Flip',screen.windowHandle,estFeedbackOnset+flickerDur);
                
                % Inter-Trial Delay
                Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
                Screen('Flip',screen.windowHandle,estFeedbackOnset+feedbackDur);
                Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
                Screen('Flip',screen.windowHandle,estFeedbackOnset+feedbackDur+flickerDur);
                WaitSecs(2)
                continue
            end
            
            % Incorrect Response
        case 0
            results.feedbackOccurance(iTrial)=0;
            
            % Was Positive Feedback Going to be Given?
            % NO
            if isnan(setup.adjReinSched(iTrial))
                results.feedbackDue(iTrial)=0;
                results.leanFeedbackDue(iTrial)=leanFeedDue;
                results.richFeedbackDue(iTrial)=richFeedDue;
                
                % Inter-Trial Delay
                Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
                [estFeedbackOnset] = Screen('Flip',screen.windowHandle);
                Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
                Screen('Flip',screen.windowHandle,estFeedbackOnset+flickerDur);
                WaitSecs(2)
                continue
                % YES
            else
                results.feedbackDue(iTrial)=1;
                
                switch setup.adjReinSched(iTrial)
                    case -1
                        leanFeedDue=leanFeedDue+1;
                        results.leanFeedbackDue(iTrial)=leanFeedDue;
                        results.richFeedbackDue(iTrial)=richFeedDue;
                        
                        % Adjust Reinforcement Schedule (Lean)
                        tmp=intersect(find(isnan(setup.adjReinSched)),find(setup.trialSeq==1));
                        setup.adjReinSched(tmp(find(tmp>iTrial,1)))=setup.adjReinSched(iTrial);
                        setup.adjReinSched(iTrial) = NaN;
                    case 1
                        richFeedDue=richFeedDue+1;
                        results.leanFeedbackDue(iTrial)=leanFeedDue;
                        results.richFeedbackDue(iTrial)=richFeedDue;
                        
                        % Adjust Reinforcement Schedule (Rich)
                        tmp=intersect(find(isnan(setup.adjReinSched)),find(setup.trialSeq==2));
                        setup.adjReinSched(tmp(find(tmp>iTrial,1)))=setup.adjReinSched(iTrial);
                        setup.adjReinSched(iTrial) = NaN;
                end
                
                % Inter-Trial Delay
                Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
                [estFeedbackOnset] = Screen('Flip',screen.windowHandle);
                Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
                Screen('Flip',screen.windowHandle,estFeedbackOnset+flickerDur);
                WaitSecs(2)
                continue
            end
            
    end
    
end
summary = summarizeBlock(setup,results);

save([setup.saveDir,filesep,'PRT_Results_Subject',setup.subjectID,'_Session',sprintf('%0*d',3,setup.sessionNumber),'_Block',sprintf('%0*d',2,iBlock)],'results','setup','summary')

if iBlock~=setup.blockNumber
    experimentBreak1 = ['END OF BLOCK ',iBlock,'\n\nWell Done!\nPlease take a short break. The experimenter will be with you shortly.'];
    DrawFormattedText(screen.windowHandle,experimentBreak1,'center','center',screen.foregroundColor);
    Screen('Flip',screen.windowHandle);
    getInput(setup);
else
    % Text changed to denote scoring points instead of earning money - JA
    % 20190808
    experimentFinal = ['Congratulations!!\n\nYou have scored ',setup.finalPrice,'!\n\nThank you for participating!'];
%     experimentFinal = ['Congratulations!!\n\nYou have won ',setup.finalPrice,'!\n\nThank you for participating!'];
    DrawFormattedText(screen.windowHandle,experimentFinal,'center','center',screen.foregroundColor);
    Screen('Flip',screen.windowHandle);
    getInput(setup);
end

end







