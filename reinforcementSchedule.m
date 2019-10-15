function reinSched = reinforcementSchedule(setup)

switch setup.richStimuli
    case 'Long'
        reinSched=nan(1,length(setup.trialSeq));
        tmpR=find(setup.trialSeq==2);
        reinSched(tmpR(randperm(length(tmpR),round((30/100)*length(setup.trialSeq)))))=1;
        tmpL=find(setup.trialSeq==1);
        reinSched(tmpL(randperm(length(tmpR),round((10/100)*length(setup.trialSeq)))))=-1;
    case 'Short'
        reinSched=nan(1,length(setup.trialSeq));
        tmpR=find(setup.trialSeq==1);
        reinSched(tmpR(randperm(length(tmpR),round((30/100)*length(setup.trialSeq)))))=1;
        tmpL=find(setup.trialSeq==2);
        reinSched(tmpL(randperm(length(tmpR),round((10/100)*length(setup.trialSeq)))))=-1;
end

end
