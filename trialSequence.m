function [trialSeq]=trialSequence(trialLength)
% Generate Pseudorandom Number Sequence used for determining the order of
% two possible stimuli given for each trial over a given block. This
% sequence of psuedorandom numbers satisfies three conditions:
%   1) There must be a given number of trials for a given block (Given by
%      varaible trialLength) with at least 3 trials
%   2) If the number of trials is even, then there must be an equal number
%      of rich and lean stimuli in the block. If the number of trials is
%      odd, then there will be one more lean stimuli than rich stimuli.
%   3) No more than three consecutive trials can have
%      the same stimulus type
% This function generates the sequence with these conditions using a
% bottom-up approach, starting with a vector with a single value, and
% concatenating additional values to the end of the vector, satisfying
% condition (3) until condition (1) is met. Then, the function appends new
% values to the end of the vector, still satisfying condition (3), and
% deletes the first value in the vector to maintain condition (1).
% Condition (2) is satisfied once the sum of values in the vector equals
% 1.5*trialLength (for even) or (1.5*trialLength-1)+1 (for odd) 

trialSeq=randi(2);
trialSeq=[trialSeq,randi(2)];
trialSeq=[trialSeq,randi(2)];
while length(trialSeq)~=trialLength
    if sum(trialSeq(end-2:end))==3
        trialSeq=[trialSeq,2];
    elseif sum(trialSeq(end-2:end))==6
        trialSeq=[trialSeq,1];
    else
        trialSeq=[trialSeq,randi(2)];
    end
end

if mod(trialLength,2)==0
    trialSum = 1.5*trialLength;
else
    trialSum = (1.5*(trialLength-1))+1;
end

while sum(trialSeq)~=trialSum
    if sum(trialSeq(end-2:end))==3
        trialSeq=[trialSeq,2];trialSeq(1)=[];
    elseif sum(trialSeq(end-2:end))==6
        trialSeq=[trialSeq,1];trialSeq(1)=[];
    else
        trialSeq=[trialSeq,randi(2)];trialSeq(1)=[];
    end
end
end