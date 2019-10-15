function summary = summarizeBlock(setup,results)
% Table of Output Information from this experiemental block
summary.table=cell(setup.trialsPerBlock+1,9);
summary.table{1,1} = 'Trial Number';        summary.table(2:end,1) = num2cell(1:setup.trialsPerBlock);
summary.table{1,2} = 'Stimulus Type';       summary.table(2:end,2) = results.stimulusType;
summary.table{1,3} = 'Response Key';        summary.table(2:end,3) = results.responseKey;
summary.table{1,4} = 'Correct Response';    summary.table(2:end,4) = num2cell(results.correctResponse);
summary.table{1,5} = 'Reaction Time';       summary.table(2:end,5) = num2cell(results.reactionTime);
summary.table{1,6} = 'Feedback Occurance';  summary.table(2:end,6) = num2cell(results.feedbackOccurance);
summary.table{1,7} = 'Feedback Due';        summary.table(2:end,7) = num2cell(results.feedbackDue);
summary.table{1,8} = 'Lean Feedback Due';   summary.table(2:end,8) = num2cell(results.leanFeedbackDue);
summary.table{1,9} = 'Rich Feedback Due';   summary.table(2:end,9) = num2cell(results.richFeedbackDue);

% Basic Experiemtn Info
summary.subjectID = setup.subjectID;
summary.timeBlockStart = setup.timeBlockStart;
summary.richStimuli = setup.richStimuli;
summary.numTrials = setup.trialsPerBlock;

abvThrsIndex = find(results.reactionTime>2.5);
blwThrsIndex = find(results.reactionTime<0.15);
tmp = sort([abvThrsIndex blwThrsIndex]);
%tmp1 <-vector of indices identifiying trials where the subject exceeded a
%       given reaction time These trials are excluded from calculation.
tmp1 = setdiff(1:length(results.reactionTime),tmp); 

% richIndex <-vector of indices relating to trials with a rich stimuli
%           where the subject responded within a given period of time
% leanIndex <-vector of indices relating to trials with a lean stimuli
%           where the subject responded within a given period of time
if strcmpi(setup.richStimuli,'Long')
    tmpR = find(strcmp(results.stimulusType,'Long'));
    richIndex = intersect(tmp1,tmpR);
    tmpL = find(strcmp(results.stimulusType,'Short'));
    leanIndex = intersect(tmp1,tmpL);

    summary.richKeyMap = setup.longKeyMap;
    summary.leanKeyMap = setup.shortKeyMap;
else
    tmpR = find(strcmp(results.stimulusType,'Short'));
    richIndex = intersect(tmp1,tmpR);
    tmpL = find(strcmp(results.stimulusType,'Long'));
    leanIndex = intersect(tmp1,tmpL);

    summary.richKeyMap = setup.shortKeyMap;
    summary.leanKeyMap = setup.longKeyMap;
end


summary.numRichTrials = length(richIndex);
summary.numLeanTrials = length(leanIndex);
summary.numCorrectRich = sum(results.correctResponse(richIndex));
summary.numCorrectLean = sum(results.correctResponse(leanIndex));
summary.numPosFeedRich = sum(results.feedbackOccurance(richIndex));
summary.numPosFeedLean = sum(results.feedbackOccurance(leanIndex));
summary.avgReactionTimeRich = mean(results.reactionTime(richIndex));
summary.avgReactionTimeLean = mean(results.reactionTime(leanIndex));
summary.accuracyRich = summary.numCorrectRich/summary.numRichTrials;
summary.accuracyLean = summary.numCorrectLean/summary.numLeanTrials;
summary.numCorrectTotal = sum(results.correctResponse);
summary.numPosFeedTotal = sum(results.feedbackOccurance);
summary.numTrialsBlwThrs = length(find(results.reactionTime<0.15));
summary.numTrialsAbvThrs = length(find(results.reactionTime>2.5));


meanInThrs = mean(results.reactionTime(tmp1));
stdInThrs = std(results.reactionTime(tmp1));


summary.numMnStdOutliers = length(find(results.reactionTime(tmp1)>meanInThrs+3*stdInThrs))...
    +length(find(results.reactionTime(tmp1)<meanInThrs-3*stdInThrs));
%Does not include outliers above or below threshold as accounted for in numTrialsBlwThrs or numTrialsAbvThrs
summary.numOutliersTotal = summary.numMnStdOutliers+summary.numTrialsBlwThrs+summary.numTrialsAbvThrs;
summary.numValidTrials = summary.numTrials-summary.numOutliersTotal;

summary.avgReactionTimeTotal = mean(results.reactionTime);
summary.minReactionTime = min(results.reactionTime);
summary.maxReactionTime = max(results.reactionTime);
summary.stdevReactionTime = std(results.reactionTime);
summary.accuracyOverall = (summary.numCorrectRich+summary.numCorrectLean)/summary.numTrials;


summary.Discriminability = log(sqrt(summary.numCorrectRich*summary.numCorrectLean/((summary.numRichTrials-summary.numCorrectRich)*(summary.numLeanTrials-summary.numCorrectLean))));
summary.ResponseBias = log(sqrt(summary.numCorrectRich*(summary.numLeanTrials-summary.numCorrectLean)/((summary.numRichTrials-summary.numCorrectRich)*summary.numCorrectLean)));
end
