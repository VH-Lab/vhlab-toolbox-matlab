# vlt.math.cluster_points_gui

```
  CLUSTER_POINTS_GUI - Cluster points into groups with manual checking
 
    [CLUSTERIDS,CLUSTERINFO] = vlt.math.cluster_points_gui('POINTS', POINTS)
 
    Brings up a graphical user interface to allow the user to cluster
    POINTS (a structure with field names and 1-D values) using several algorithms.
 
    POINTS should be a structure with fieldnames equal to the variable names 
    (e.g., 'x', 'y', etc), and the value in each field name should be 1-dimensional. 
 
    Additional parameters can be adjusted by passing name/value pairs 
    at the end of the function:
    
    'clusterids'                           :    preliminary cluster ids
    'ColorOrder'                           :    Color order for cluster drawings; defaults
                                           :        to axes color order
    'UnclassifiedColor'                    :    Color of unclassified spikes, default [0.5 0.5 0.5]
    'RandomSubset'                         :    Do we plot a random subset of spikes? Default 1
    'RandomSubsetSize'                     :    How many?  Default 200
    'ForceQualityAssessment'               :    Should we force the user to choose cluster quality
                                           :        before closing?  Default 1
    'EnableClusterEditing'                 :    Should we enable cluster editing?  Default 1
    'AskBeforeDone'                        :    Ask user to confirm they are really done Default 1
    'MarkerSize'                           :    MarkerSize for plotting; default 10
    'FigureName'                           :    Name of the figure; default "Cluster Points".
    'IsModal'                              :    Is it a modal dialog? That is, should it stop all other
                                           :        windows until the user finishes? Default is 1.
                                           :        If the dialog is not modal then it cannot return
                                           :        any values.

```
