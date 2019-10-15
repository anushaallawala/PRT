function runIntroduction(screen,face,cross,setup,demo)

%% Timing Variables
flickerDur = screen.ifi*3;
facePreStimDur = 0.5;
faceStimDur = 0.097;
feedbackDur = 1.5;

%% Intro 1
duration=int2str(ceil((setup.blockNumber*setup.trialsPerBlock*4.5)/60));
if setup.blockNumber == 1
    experimentIntro1 = ['Welcome! The game will last approximately ',duration,' minutes.',...
    '\n\n [Press any key to continue]'];
else
    blocks = [int2str(setup.blockNumber),' blocks'];
    experimentIntro1 = ['Welcome! The game will last approximately ',duration,' minutes ',...
    'and is composed of ',blocks,' separated by a short break between blocks.\n\n [Press any key to continue]'];
end
DrawFormattedText(screen.windowHandle,experimentIntro1,'center','center',screen.foregroundColor);
Screen('Flip',screen.windowHandle);
getInput(setup);

%% Intro 2
% Key Map Text Changed to Correspond to Input Device - JA 20190808
experimentIntro2 = ['In this experiment you will be presented with a face with either a Short ',lower(setup.stimulusVersion),'\n',...
    'or a Long ',lower(setup.stimulusVersion),'. You will see them one at a time.\n\n',...
    'Your task will be to decide whether a Short or Long ',lower(setup.stimulusVersion),' was presented by pushing the correct\n',...
    'button as quickly and accurately as possible.\n\n',...
    'The LEFT key will be used to identify the Short ',lower(setup.stimulusVersion),...
    ' and the RIGHT key will be used to identify the Long ',lower(setup.stimulusVersion),'.\n',...
    'Examples of what the ',lower(setup.stimulusVersion),' sizes look like are below:\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n [Press any key to continue]'];
% experimentIntro2 = ['In this experiment you will be presented with a face with either a Long ',lower(setup.stimulusVersion),'\n',...
%     'or a Short ',lower(setup.stimulusVersion),'. You will see them one at a time.\n\n',...
%     'Your task will be to decide whether a Long or Short ',lower(setup.stimulusVersion),' was presented by pushing the correct\n',...
%     'button as quickly and accurately as possible.\n\n',...
%     'The ''',upper(setup.longKeyMap),''' key will be used to identify the Long ',lower(setup.stimulusVersion),...
%     ' and the ''',upper(setup.shortKeyMap),''' key will be used to identify the Short ',lower(setup.stimulusVersion),'.\n',...
%     'Examples of what the ',lower(setup.stimulusVersion),' sizes look like are below:\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n [Press any key to continue]'];
DrawFormattedText(screen.windowHandle,experimentIntro2,'center','center',screen.foregroundColor);
faceDemos(screen,setup,demo)
Screen('Flip',screen.windowHandle);
getInput(setup);

%% Intro 3
% Key Map Text Changed to Correspond to Input Device - JA 20190808
experimentIntro3 = ['Now, let''s take a practice run. You will see a fixation cross, "+", on the screen.\n\n',...
    'You should always focus your attention on the fixation cross as\n',...
    'this will help you identify the ',lower(setup.stimulusVersion),' as quickly and accurately as possible.\n\n',...
    'The fixation cross will be followed by a face with a Short or a Long ',lower(setup.stimulusVersion),'.\n\n',...
    'Remember, if you think the ',lower(setup.stimulusVersion),' is Short, press the LEFT key.',...
    'If you think the ',lower(setup.stimulusVersion),' is Long, press the RIGHT key.'];
% experimentIntro3 = ['Now, let''s take a practice run. You will see a fixation cross, "+", on the screen.\n\n',...
%     'You should always focus your attention on the fixation cross as\n',...
%     'this will help you identify the ',lower(setup.stimulusVersion),' as quickly and accurately as possible.\n\n',...
%     'The fixation cross will be followed by a face with a Long or a Short ',lower(setup.stimulusVersion),'.\n\n',...
%     'Remember, if you think the ',lower(setup.stimulusVersion),' is Short, press the ''',...
%     upper(setup.shortKeyMap),''' key. If you think the ',lower(setup.stimulusVersion),' is Long, press the ''',...
%     upper(setup.longKeyMap),''' key.'];
DrawFormattedText(screen.windowHandle,experimentIntro3,'center','center',screen.foregroundColor);
Screen('Flip',screen.windowHandle);
getInput(setup);

%% Practice
practice = true;
while practice
    prac = randi(2);
    for i=1:2
        if prac==1 && i==2
            prac = 2;
        elseif prac==2 && i==2
            prac = 1;
        end
        %% Stimulus Cycle
        % Fixation Cross
        fixationCrossJitter = (0.700+randi(4)*.05);
        Screen('DrawLines',screen.windowHandle,cross.coords,cross.barThickness,screen.foregroundColor,screen.centerCoord);
        Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
        fixCrossOnset=Screen('Flip',screen.windowHandle);
        Screen('DrawLines',screen.windowHandle,cross.coords,cross.barThickness,screen.foregroundColor,screen.centerCoord);
        Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
        Screen('Flip',screen.windowHandle,fixCrossOnset+flickerDur);
        
        % Draw Face without Stimulus
        drawFace(screen,face,prac,false,setup.stimulusVersion);
        Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
        Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter);
        drawFace(screen,face,prac,false,setup.stimulusVersion);
        Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
        Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+flickerDur);
        
        % Draw Face with Stimulus
        drawFace(screen,face,prac,true,setup.stimulusVersion);
        Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
        Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+facePreStimDur);
        drawFace(screen,face,prac,true,setup.stimulusVersion);
        Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
        Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+facePreStimDur+flickerDur);
        
        % Draw Face without Stimulus
        drawFace(screen,face,prac,false,setup.stimulusVersion);
        Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
        Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+facePreStimDur+faceStimDur);
        drawFace(screen,face,prac,false,setup.stimulusVersion);
        Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
        Screen('Flip',screen.windowHandle,fixCrossOnset+fixationCrossJitter+facePreStimDur+faceStimDur+flickerDur);
        
        response=getInput(setup);
        
        
        
        % Determine if correct response
        switch prac
            % Short Stimuli
            case 1
                Size = 'Short';
                if strcmpi(setup.shortKeyMap,response)
                    Test = 'Correct!';
                else
                    Test = 'Oops.';
                end
                % Long Stimuli
            case 2
                Size = 'Long';
                if strcmpi(setup.longKeyMap,response)
                    Test = 'Correct!';
                else
                    Test = 'Oops.';
                end
        end
        
        experimentPracticeTrialResponse = [Test,'\n\nThat was the ',Size,' ',lower(setup.stimulusVersion),'.\n\n[Press any key to continue]'];
        DrawFormattedText(screen.windowHandle,experimentPracticeTrialResponse,'center','center',screen.foregroundColor);
        Screen('Flip',screen.windowHandle);
        getInput(setup);
    end
    
    %% Continue Practicing?
    % Key Map Text Changed to Correspond to Input Device - JA 20190808
    experimentPracticeContinue = ['Would you like to practice more? (LEFT = no, RIGHT = yes)'];
    %experimentPracticeContinue = ['Would you like to practice more? (', upper(setup.shortKeyMap),'=no, ',upper(setup.longKeyMap),'=yes)'];
    DrawFormattedText(screen.windowHandle,experimentPracticeContinue,'center','center',screen.foregroundColor);
    Screen('Flip',screen.windowHandle);
    response=getInput(setup);
    if strcmpi(setup.shortKeyMap,response)
        practice = false;
    end
end

%% Intro 4
% Text changed to denote scoring points instead of earning money - JA
% 20190808
experimentNote1 = ['For some trials, a correct identification will result in scoring 20 points.\n\n',...
    'Press any key to see what this will look like.'];
% experimentNote1 = ['For some trials, a correct identification will result in a monetary reward of 20 cents.\n\n',...
%     'Press any key to see what this will look like.'];
DrawFormattedText(screen.windowHandle,experimentNote1,'center','center',screen.foregroundColor);
Screen('Flip',screen.windowHandle);
getInput(setup);

DrawFormattedText(screen.windowHandle,'Correct!! You scored 20 points!','center','center',screen.foregroundColor);
% DrawFormattedText(screen.windowHandle,'Correct!! You win 20 cents.','center','center',screen.foregroundColor);
Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
[estFeedbackOnset] = Screen('Flip',screen.windowHandle);
DrawFormattedText(screen.windowHandle,'Correct!! You scored 20 points!','center','center',screen.foregroundColor);
% DrawFormattedText(screen.windowHandle,'Correct!! You win 20 cents.','center','center',screen.foregroundColor);
Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
Screen('Flip',screen.windowHandle,estFeedbackOnset+flickerDur);

Screen('FillRect', screen.windowHandle, screen.foregroundColor, screen.flickerSquare);
Screen('Flip',screen.windowHandle,estFeedbackOnset+feedbackDur);
Screen('FillRect', screen.windowHandle, screen.backgroundColor, screen.flickerSquare);
Screen('Flip',screen.windowHandle,estFeedbackOnset+feedbackDur+flickerDur);
WaitSecs(1)

%% Intro 5
% Text changed to denote scoring points instead of earning money - JA
% 20190808
experimentNote2 = ['Not all correct responses will show that you scored. The more correct identifications you make,\n',...
    'the more points you will earn.\n\n[Press any key to continue]'];
% experimentNote2 = ['Not all correct responses will receive a reward. At the end of the experiment you will be given\n',...
%     'the amount of money you have accumulated. The more correct identifications you make,\n',...
%     'the more money you will take home.\n\n[Press any key to continue]'];
DrawFormattedText(screen.windowHandle,experimentNote2,'center','center',screen.foregroundColor);
Screen('Flip',screen.windowHandle);
getInput(setup);

%% Intro 6
% Key Map Text Changed to Correspond to Input Device - JA 20190808
experimentIntro4 = ['We are now ready to begin the experiment. If you have any questions, please ask the experimenter now.\n\n',...
    'Remember, focus your attention on the fixation cross before each trial. Press the LEFT key if you think the ',...
    lower(setup.stimulusVersion),' is Short.\n','Press the RIGHT key if you think the ',...
    lower(setup.stimulusVersion),' is Long.\n\nGood Luck!\n\n[Press any key to begin]'];
% experimentIntro4 = ['We are now ready to begin the experiment. If you have any questions, please ask the experimenter now.\n\n',...
%     'Remember, focus your attention on the fixation cross before each trial. Press the ''',upper(setup.longKeyMap),''' key if you think the ',...
%     lower(setup.stimulusVersion),' is Long.\n','Press the ''',upper(setup.shortKeyMap),''' key if you think the ',...
%     lower(setup.stimulusVersion),' is Short.\n\nGood Luck!\n\n[Press any key to begin]'];
DrawFormattedText(screen.windowHandle,experimentIntro4,'center','center',screen.foregroundColor);
Screen('Flip',screen.windowHandle);
getInput(setup);
end