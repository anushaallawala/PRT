function summaryTot = summarizeExperiment(setup)
summaryTot.table=cell(1,11);
summaryTot.table{1,1} = 'Trial Number';
summaryTot.table{1,2} = 'Stimulus Type';
summaryTot.table{1,3} = 'Response Key';
summaryTot.table{1,4} = 'Correct Response';
summaryTot.table{1,5} = 'Reaction Time';
summaryTot.table{1,6} = 'Feedback Occurance';
summaryTot.table{1,7} = 'Feedback Due';
summaryTot.table{1,8} = 'Lean Feedback Due';
summaryTot.table{1,9} = 'Rich Feedback Due';
summaryTot.table{1,10} = 'Initial Reinforcement Schedule';
summaryTot.table{1,11} = 'Adjusted Reinforcement Schedule';

for iBlock=1:setup.blockNumber
    load([setup.saveDir,filesep,'PRT_Results_Subject',setup.subjectID,'_Session',sprintf('%0*d',3,setup.sessionNumber),'_Block',sprintf('%0*d',2,iBlock)],'results','summary');
    tmp=(1:setup.trialsPerBlock)+setup.trialsPerBlock*(iBlock-1);
    summaryTot.table(tmp+1,1) = num2cell(tmp);
    summaryTot.table(tmp+1,2) = results.stimulusType;
    summaryTot.table(tmp+1,3) = results.responseKey;
    summaryTot.table(tmp+1,4) = num2cell(results.correctResponse);
    summaryTot.table(tmp+1,5) = num2cell(results.reactionTime);
    summaryTot.table(tmp+1,6) = num2cell(results.feedbackOccurance);
    summaryTot.table(tmp+1,7) = num2cell(results.feedbackDue);
    summaryTot.table(tmp+1,8) = num2cell(results.leanFeedbackDue);
    summaryTot.table(tmp+1,9) = num2cell(results.richFeedbackDue);
    summaryTot.table(tmp+1,10) = num2cell(setup.initReinSched);
%     summaryTot.table(tmp+1,11) = num2cell(setup.adjReinSched);
    summaryTot.blockResponsBias(iBlock) = summary.ResponseBias;
end

summaryTot.subjectID = summary.subjectID;
summaryTot.richStimuli = summary.richStimuli;
summaryTot.numTrials = setup.trialsPerBlock*setup.blockNumber;

reactionTime = cell2mat(summaryTot.table(2:end,5));
abvThrsIndex = find(reactionTime<0.15);
blwThrsIndex = find(reactionTime>2.5);
tmp = sort([abvThrsIndex blwThrsIndex]);
tmp1 = setdiff(1:summaryTot.numTrials,tmp);

if strcmpi(setup.richStimuli,'Long')
    tmpR = find(strcmp(summaryTot.table(:,2),'Long'))-1;
    richIndex = intersect(tmp1,tmpR);
    tmpL = find(strcmp(summaryTot.table(:,2),'Short'))-1;
    leanIndex = intersect(tmp1,tmpL);
    
    summaryTot.richKeyMap = setup.longKeyMap;
    summaryTot.leanKeyMap = setup.shortKeyMap;
else
    tmpR = find(strcmp(summaryTot.table(:,2),'Short'))-1;
    richIndex = intersect(tmp1,tmpR);
    tmpL = find(strcmp(summaryTot.table(:,2),'Long'))-1;
    leanIndex = intersect(tmp1,tmpL);
    summaryTot.richKeyMap = setup.shortKeyMap;
    summaryTot.leanKeyMap = setup.longKeyMap;
end

summaryTot.numRichTrials = length(richIndex);
summaryTot.numLeanTrials = length(leanIndex);
summaryTot.numCorrectRich = sum(cell2mat(summaryTot.table(richIndex+1,4)));
summaryTot.numCorrectLean = sum(cell2mat(summaryTot.table(leanIndex+1,4)));
summaryTot.numPosFeedRich = sum(cell2mat(summaryTot.table(richIndex+1,6)));
summaryTot.numPosFeedLean = sum(cell2mat(summaryTot.table(leanIndex+1,6)));
summaryTot.numCorrectTotal = sum(cell2mat(summaryTot.table(2:end,4)));
summaryTot.numPosFeedTotal = sum(cell2mat(summaryTot.table(2:end,6)));
summaryTot.avgReactionTimeRich = mean(cell2mat(summaryTot.table(richIndex+1,5)));
summaryTot.avgReactionTimeLean = mean(cell2mat(summaryTot.table(leanIndex+1,5)));
summaryTot.avgReactionTimeTotal = mean(cell2mat(summaryTot.table(2:end,5)));
summaryTot.minReactionTime = min(cell2mat(summaryTot.table(2:end,5)));
summaryTot.maxReactionTime = max(cell2mat(summaryTot.table(2:end,5)));
summaryTot.stddevReactionTime = std(cell2mat(summaryTot.table(2:end,5)));
summaryTot.accuracyRich = summaryTot.numCorrectRich/summaryTot.numRichTrials;
summaryTot.accuracyLean = summaryTot.numCorrectLean/summaryTot.numLeanTrials; 
summaryTot.accuracyOverall = (summaryTot.numCorrectRich+summaryTot.numCorrectLean)/summaryTot.numTrials;
summaryTot.numTrialsBlwThrs = length(find(cell2mat(summaryTot.table(2:end,5))<0.15));
summaryTot.numTrialsAbvThrs = length(find(cell2mat(summaryTot.table(2:end,5))>2.5));

meanInThrs = mean(reactionTime);
stdInThrs = std(reactionTime);
summaryTot.numMnStdOutliers = length(find(reactionTime(tmp1)>meanInThrs+3*stdInThrs))...
    +length(find(reactionTime(tmp1)<meanInThrs-3*stdInThrs));
%Does not include outliers above or below threshold as accounted for in numTrialsBlwThrs or numTrialsAbvThrs
summaryTot.numOutliersTotal = summaryTot.numMnStdOutliers+summaryTot.numTrialsBlwThrs+summaryTot.numTrialsAbvThrs;
summaryTot.numValidTrials = summaryTot.numTrials-summaryTot.numOutliersTotal;

summaryTot.Discriminability = log(sqrt(summaryTot.numCorrectRich*summaryTot.numCorrectLean/((summaryTot.numRichTrials-summaryTot.numCorrectRich)*(summaryTot.numLeanTrials-summaryTot.numCorrectLean))));
summaryTot.ResponseBias = log(sqrt(summaryTot.numCorrectRich*(summaryTot.numLeanTrials-summaryTot.numCorrectLean)/((summaryTot.numRichTrials-summaryTot.numCorrectRich)*summaryTot.numCorrectLean)));
if setup.blockNumber>1
summaryTot.ResponseBiasDelta = summaryTot.blockResponseBias(2:end)-summaryTot.blockResponseBias(1:end-1);
end
end