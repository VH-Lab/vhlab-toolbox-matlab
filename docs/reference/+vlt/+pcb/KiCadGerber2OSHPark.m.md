# vlt.pcb.KiCadGerber2OSHPark

```
  KiCadGerber2OSHPark - Convert KiCad Gerber extensions to OSH Park convention
 
  vlt.pcb.KiCadGerber2OSHPark(DIRNAME)
 
  Given a directory name with Gerber files, this function creates a subdirectory
  'OSHPark' that has renamed Gerber files whose extensions match that expected 
  by the OSH Park fabrication service.
 
  B.Cu.gbr      -> B.Cu.gbr.GBL
  B.Mask.gbr    -> B.Mask.gbr.GBS
  B.SilkS.gbr   -> B.SilkS.gbr.GBO
  F.Cu.gbr      -> F.Cu.gbr.GTL
  F.Mask.gbr    -> F.Mask.gbr.GTS
  F.SilkS.gbr   -> F.SilkS.gbr.GTO
  Edge.Cuts.gbr -> Edge.Cuts.gbr.GKO
  .drl          -> drl.XLN (any .drl file is renamed)

```
