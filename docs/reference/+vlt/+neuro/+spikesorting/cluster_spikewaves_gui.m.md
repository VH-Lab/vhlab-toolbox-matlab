# vlt.neuro.spikesorting.cluster_spikewaves_gui

```
  CLUSTER_SPIKEWAVES_GUI - Cluster spikewaves into groups with manual checking
 
    [CLUSTERIDS,CLUSTERINFO] = vlt.neuro.spikesorting.cluster_spikewaves_gui('WAVES', WAVES, ...
       'WAVEPARAMETERS', WAVEPARAMETERS, ...)
 
    Brings up a graphical user interface to allow the user to divide the
    spikewaves WAVES into groups using several algorithms, and to check
    the output of these algorithms with different views (raw data views, 
    feature views, etc).
 
    WAVES should be NumSamples X NumChannels X NumSpikes
    WAVEPARAMETERS should be a structure with the following fields:
 
     NAME (type):                      DESCRIPTION         
     -------------------------------------------------------------------------
     waveparameters.numchannels (uint8)    : Number of channels
     waveparameters.S0 (int8)              : Number of samples before spike center
                                           :  (usually negative)
     waveparameters.S1 (int8)              : Number of samples after spike center
                                           :  (usually positive)
     waveparameters.name (80xchar)         : Name (up to 80 characters)
     waveparameters.ref (uint8)            : Reference number
     waveparameters.comment (80xchar)      : Up to 80 characters of comment
     waveparameters.samplingrate           : The sampling rate (float64)
    (this is the same as the output of HEADER in vlt.file.custom_file_formats.readvhlspikewaveformfile)
 
    Additional parameters can be adjusted by passing name/value pairs 
    at the end of the function:
    
    'clusterids'                           :    preliminary cluster ids
    'wavetimes'                            :    1xNumSpikes; the time of each spike
    'spikewaves2NpointfeatureSampleList'   :    [x1 x2] the locations where we should measure the
                                           :        voltage, defaults [half_way 5/6 of way]
    'spikewaves2pcaRange'                  :    [x1 x2] the locations within which we should examine pca
                                           :        default [6 22]/24 * number of spike samples
    'ColorOrder'                           :    Color order for cluster drawings; defaults
                                           :        to axes color order
    'UnclassifiedColor'                    :    Color of unclassified spikes, default [0.5 0.5 0.5]
    'NotPresentColor'                      :    Color of spikes not present, default [1 0.5 0.5] (light pink)
    'RandomSubset'                         :    Do we plot a random subset of spikes? Default 1
    'RandomSubsetSize'                     :    How many?  Default 200
    'ForceQualityAssessment'               :    Should we force the user to choose cluster quality
                                           :        before closing?  Default 1
    'EnableClusterEditing'                 :    Should we enable cluster editing?  Default 1
    'AskBeforeDone'                        :    Ask user to confirm they are really done Default 1
    'MarkerSize'                           :    MarkerSize for plotting; default 10
    'FigureName'                           :    Name of the figure; default "Cluster spikewaves".
    'IsModal'                              :    Is it a modal dialog? That is, should it stop all other
                                           :        windows until the user finishes? Default is 1.
                                           :        If the dialog is not modal then it cannot return
                                           :        any values.
    'EpochStartSamples'                    :    Array with the sample corresponding to the start
                                           :        of each recording epoch. Default [1], which specifies
                                           :        a single recording epoch that starts with the first
                                           :        sample.
    'EpochNames'                           :    Cell list of string names of the recording epochs.
                                           :        Default {'Epoch1'}. There must be the same number
                                           :        of EpochNames as there are entries in the array
                                           :        EpochStartSamples.

```
