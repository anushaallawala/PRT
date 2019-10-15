function faceDemos(screen,setup,demo)

% Face Locations on Screen
position = [-350 30;350 30];
size = 100;
scalar = demo.headRadius/size;

% Head
headRadius = round(demo.headRadius/scalar);
headThickness = round(demo.headThickness/scalar);

% Nose (Both Types)
noseHeights = round(demo.noseHeights/scalar);
noseThickness = round(demo.noseThickness/scalar);

% Mouth (Both Types)
mouthWidths = round(demo.mouthWidths/scalar);
mouthYPos = round(demo.mouthYPos/scalar);
mouthThickness = round(demo.mouthThickness/scalar);

% Eyes
eyeRadius = round(demo.eyeRadius/scalar);
eyeYPos = round(demo.eyeYPos/scalar);
eyeDist = round(demo.eyeDist/scalar);

stimulus = {'Short','Long'};
%Key Map Text Changed to Correspond to Input Device - JA 20190808
key = {'LEFT','RIGHT'};

for stimuli=1:2
    headRect = [0 0 headRadius*2 headRadius*2];
    centeredHeadRect = CenterRectOnPointd(headRect, screen.centerCoord(1)+position(stimuli,1), screen.centerCoord(2)+position(stimuli,2));
    
    eyeRect = [0 0 eyeRadius*2 eyeRadius*2];
    eyeSep = [eyeDist/2 0 eyeDist/2 0];
    eyeHeight = [0 eyeYPos 0 eyeYPos];
    centeredEyeRect = CenterRectOnPointd(eyeRect, screen.centerCoord(1)+position(stimuli,1), screen.centerCoord(2)+position(stimuli,2));
    eyeRectCoords = [centeredEyeRect-eyeSep+eyeHeight; centeredEyeRect+eyeSep+eyeHeight]';
    
    switch setup.stimulusVersion
        case 'Mouth'
            mouthCoords = [-mouthWidths(stimuli)/2 mouthWidths(stimuli)/2; mouthYPos mouthYPos];
            noseCoords = [0 0; -noseHeights(1)/2 noseHeights(1)/2];
            Screen('DrawLines', screen.windowHandle, noseCoords,...
                noseThickness, screen.foregroundColor, [screen.centerCoord(1)+position(stimuli,1) screen.centerCoord(2)+position(stimuli,2)]);
            Screen('DrawLines', screen.windowHandle, mouthCoords,...
                mouthThickness, screen.foregroundColor, [screen.centerCoord(1)+position(stimuli,1) screen.centerCoord(2)+position(stimuli,2)]);
            label = [stimulus{stimuli},' ',setup.stimulusVersion,'\n''',upper(key{stimuli}),''' Key'];
            
            
        case 'Nose'
            mouthCoords = [-mouthWidths(1)/2 mouthWidths(1)/2; mouthYPos mouthYPos];
            noseCoords = [0 0; -noseHeights(stimuli)/2 noseHeights(stimuli)/2];
            Screen('DrawLines', screen.windowHandle, mouthCoords,...
                mouthThickness, screen.foregroundColor, [screen.centerCoord(1)+position(stimuli,1) screen.centerCoord(2)+position(stimuli,2)]);
            Screen('DrawLines', screen.windowHandle, noseCoords,...
                noseThickness, screen.foregroundColor, [screen.centerCoord(1)+position(stimuli,1) screen.centerCoord(2)+position(stimuli,2)]);
            label = [stimulus{stimuli},' ',setup.stimulusVersion,'\n''',upper(key{stimuli}),''' Key'];

            
    end

    DrawFormattedText(screen.windowHandle,label,screen.centerCoord(1)+position(stimuli,1)-60,screen.centerCoord(2)+position(stimuli,2)+125,screen.foregroundColor)

    Screen('FrameOval',screen.windowHandle,screen.foregroundColor,centeredHeadRect,headThickness);
    Screen('FillOval', screen.windowHandle, screen.foregroundColor, eyeRectCoords);
end

end