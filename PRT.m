%% Run PRTSetup to Select Experiment Parameters
% Code adjusted for EMU use. Setup inputs will be hardcoded until proper
% adjustments can be made - JA 20190808

% app=PRTSetup;
% waitfor(app)
% sca

%% Experiment Parameters
% Hardcoded setup parameters
setup.subjectID = 'TEST';
setup.sessionNumber = 1;
setup.saveDir = [pwd filesep 'Results'];
setup.blockNumber = 2;
setup.trialsPerBlock = 10;
setup.richStimuli = 'Long';
setup.leanStimuli = 'Short';
setup.longKeyMap = 'c';
setup.shortKeyMap = 'z';
setup.stimulusVersion = 'Mouth';
setup.finalPrice = '1580 points';
runIntro=1; 

% Find Keyboards used for Task in EMU
d = PsychHID('Devices');
d=struct2cell(d');
keyboards=find(strcmp(d(3,:),'Keyboard')==1);
model1=find(strcmp(d(10,:),'Magic Keyboard')==1);
model2=find(strcmp(d(10,:),'XK-12 Joystick')==1);
kID=intersect(keyboards,model1);
kID=sort([kID intersect(keyboards,model2)]);
setup.keyboardIDs = kID;

% setup.subjectID = subjectID;
% setup.sessionNumber = sessionNumber;
% setup.saveDir = saveDir;
% setup.blockNumber = blockNumber;
% setup.trialsPerBlock = trialsPerBlock;
% setup.richStimuli = richStimuli;
% setup.leanStimuli = leanStimuli;
% setup.longKeyMap = longKeyMap;
% setup.shortKeyMap = shortKeyMap;
% setup.stimulusVersion = stimulusVersion;
% setup.finalPrice = finalPrice;

%% Configuration Parameters
% Hardcoded configuration parameters
load('configEMU.mat')
background=bg;
barLength = bL;
barThickness = bT;
eyeDistance = eD;
eyeRadius = eR;
eyeYPos = eY;
headRadius = hR;
headThickness = hT;
mouthThickness = mT;
mouthWidths = mW;
mouthYPos = mY;
noseHeights = nH;
noseThickness = nT;
noseYPos = nY;
slideScalar = sS;

%% Setup Psychtoolbox
% Setup Screen/Initiate Psychtoolbox
Screen('Preference', 'SkipSyncTests', 1);
screenNumber = max(Screen('Screens'));
switch background
    case 'White'
        screen.backgroundColor = WhiteIndex(screenNumber);
        screen.foregroundColor = BlackIndex(screenNumber);
    case 'Black'
        screen.backgroundColor = BlackIndex(screenNumber);
        screen.foregroundColor = WhiteIndex(screenNumber);
end
[screen.windowHandle,screen.windowRect] = Screen('OpenWindow',screenNumber,screen.backgroundColor);
[screen.centerCoord(1), screen.centerCoord(2)] = RectCenter(screen.windowRect);
screen.ifi = Screen('GetFlipInterval', screen.windowHandle);

% Prepare Input
KbName('UnifyKeyNames')

% Flicker Square for Synchronization with Monitor
screen.width = 24; %Currently in Inches
screen.flickerSquare = flickerSquareLoc(screen.windowRect,screen.width,2,'BottomLeft');

%% Demo Image Data
demo.headRadius = headRadius;
demo.headThickness = headThickness;
demo.eyeRadius = eyeRadius;
demo.eyeDist = eyeDistance;
demo.eyeYPos = eyeYPos;
demo.noseHeights = noseHeights;
demo.noseThickness = noseThickness;
demo.noseYPos = noseYPos;
demo.mouthWidths = mouthWidths;
demo.mouthYPos = mouthYPos;
demo.mouthThickness = mouthThickness;

%% Fixation Cross
cross.barLength = barLength;
cross.barThickness = barThickness;

%% Stimulus Image Data
scalar = 2^slideScalar;
% Head
face.headRadius = round(headRadius*scalar);
face.headThickness = round(headThickness*scalar);
% Eyes
face.eyeRadius = round(eyeRadius*scalar);
face.eyeDist = round(eyeDistance*scalar);
face.eyeYPos = round(eyeYPos*scalar);
% Nose (Both Types)
face.noseHeights = round(noseHeights*scalar);
face.noseThickness = round(noseThickness*scalar);
face.noseYPos = round(noseYPos*scalar);
% Mouth (Both Types)
face.mouthWidths = round(mouthWidths*scalar);
face.mouthYPos = round(mouthYPos*scalar);
face.mouthThickness = round(mouthThickness*scalar);

%% Image Parameters (For Psychtoolbox)
cross.coords = [0 0 -cross.barLength/2 cross.barLength/2; -cross.barLength/2 cross.barLength/2 0 0];
face.headRect = [0 0 face.headRadius*2 face.headRadius*2];
face.centeredHeadRect = CenterRectOnPointd(face.headRect, screen.centerCoord(1), screen.centerCoord(2));
face.eyeRect = [0 0 face.eyeRadius*2 face.eyeRadius*2];
face.eyeSep = [face.eyeDist/2 0 face.eyeDist/2 0];
face.eyeHeight = [0 face.eyeYPos 0 face.eyeYPos];
face.centeredEyeRect = CenterRectOnPointd(face.eyeRect, screen.centerCoord(1), screen.centerCoord(2));
face.eyeRectCoords = [face.centeredEyeRect-face.eyeSep+face.eyeHeight; face.centeredEyeRect+face.eyeSep+face.eyeHeight]';
face.noseHeights = sort(face.noseHeights);
face.mouthWidths = sort(face.mouthWidths);

%% Clear Variables Created by PRTSetup
clearvars barThickness barLength headRadius headThickness...
    noseHeights noseThickness noseYPos mouthWidths mouthYPos mouthThickness...
    eyeRadius eyeYPos eyeDistance richStimuli leanStimuli longKeyMap...
    shortKeyMap stimulusVersion finalPrice subjectID sessionNumber...
    saveDir blockNumber trialsPerBlock scalar

%% Run Experiment
if runIntro
runIntroduction(screen,face,cross,setup,demo)
end

for iBlock=1:setup.blockNumber
    
    setup.trialSeq = trialSequence(setup.trialsPerBlock);
    setup.initReinSched = reinforcementSchedule(setup);
    
    runBlock(screen,face,cross,setup,iBlock);
    
end

% summary = summarizeExperiment(setup);
% save([setup.saveDir,filesep,'PRT_Results_Subject',setup.subjectID,'_Session',sprintf('%0*d',3,setup.sessionNumber),'_Overall'],'summary')

sca