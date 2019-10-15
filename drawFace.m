function drawFace(screen,face,stimuli,stimulusPresent,stimulusVersion)
% Using Psychtoolbox, draw basic facial features (head, eyes, nose, mouth)
% to the screen for the Probabilistic Reward Task. Requires three
% structures, screen and face, which provide information about the
% characteristics of the screen and face, respectively, and variable
% stimuli, which determines whether the rich or lean stimulus is drawn to
% the screen. The parameter stimulusPresent (logical true or
% false) determines if the randomized facial feature is drawn for this
% instance of the function. This is important for initiating presentation
% of the face to the participant and prior to providing the randomized
% stimulus. The value stimulusVersion allows the user to specify whether
% the 'Mouth' or 'Nose' is the facial characteristic that changes between
% trials. stimulusVersion is an optional input that defaults to 'Mouth'.

if nargin<=4
    face.mouthCoords = [-face.mouthWidths(stimuli)/2 face.mouthWidths(stimuli)/2; face.mouthYPos face.mouthYPos];
    face.noseCoords = [0 0; -face.noseHeights(1)/2 face.noseHeights(1)/2];
else
    
    switch stimulusVersion
        case 'Mouth'
            face.mouthCoords = [-face.mouthWidths(stimuli)/2 face.mouthWidths(stimuli)/2; face.mouthYPos face.mouthYPos];
            face.noseCoords = [0 0; -face.noseHeights(1)/2 face.noseHeights(1)/2];
        case 'Nose'
            face.mouthCoords = [-face.mouthWidths(1)/2 face.mouthWidths(1)/2; face.mouthYPos face.mouthYPos];
            face.noseCoords = [0 0; -face.noseHeights(stimuli)/2 face.noseHeights(stimuli)/2];
    end
    
end

Screen('FrameOval',screen.windowHandle,screen.foregroundColor,face.centeredHeadRect,face.headThickness);
Screen('FillOval', screen.windowHandle, screen.foregroundColor, face.eyeRectCoords);

if stimulusPresent
    Screen('DrawLines', screen.windowHandle, face.noseCoords,...
        face.noseThickness, screen.foregroundColor, screen.centerCoord);
    Screen('DrawLines', screen.windowHandle, face.mouthCoords,...
        face.mouthThickness, screen.foregroundColor, screen.centerCoord);
    
elseif nargin <=4
    Screen('DrawLines', screen.windowHandle, face.noseCoords,...
        face.noseThickness, screen.foregroundColor, screen.centerCoord);
    
else
    
    switch stimulusVersion
        case 'Mouth'
            Screen('DrawLines', screen.windowHandle, face.noseCoords,...
                face.noseThickness, screen.foregroundColor, screen.centerCoord);
        case 'Nose'
            Screen('DrawLines', screen.windowHandle, face.mouthCoords,...
                face.mouthThickness, screen.foregroundColor, screen.centerCoord);
    end
    
end

end
