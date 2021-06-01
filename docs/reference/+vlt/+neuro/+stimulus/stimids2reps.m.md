# vlt.neuro.stimulus.stimids2reps

  STIMIDS2REPS - Label each stimulus id with the repetition number for a regular stimulus sequence
 
   [REPS, ISREGULAR] = vlt.neuro.stimulus.stimids2reps(STIMIDS, NUMSTIMS)
 
   Given a list of STIMIDS that indicate an order of presentation,
   and given that STIMIDS range from 1..NUMSTIMS, vlt.neuro.stimulus.stimids2reps returns a label
   REPS, the same size as STIMIDS, that indicates the repetition
   number if the stimuli were to be presented in a regular order. 
   Regular order means that all stimuli 1...NUMSTIMS are shown in some order once,
   followed by 1..NUMSTIMS in some order a second time, etc.
 
   ISREGULAR is 1 if the sequence of STIMIDS is in a regular order. The last
   repetition need not be complete for the stimulus presentation to be regular
   (that is, if a sequence ended early it can still be regular).
 
  Example:
     [reps,isregular] = vlt.neuro.stimulus.stimids2reps([1 2 3 1 2 3],3)
        % reps = [1 1 1 2 2 2]
        % isregular = 1
