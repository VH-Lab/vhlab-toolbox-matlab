function KiCadGerber2OSHPark(dirname)
% KiCadGerber2OSHPark - Convert KiCad Gerber extensions to OSH Park convention
%
% KICADGERBER2OSHPARK(DIRNAME)
%
% Given a directory name with Gerber files, this function creates a subdirectory
% 'OSHPark' that has renamed Gerber files whose extensions match that expected 
% by the OSH Park fabrication service.
%
% B.Cu.gbr      -> B.Cu.gbr.GBL
% B.Mask.gbr    -> B.Mask.gbr.GBS
% B.SilkS.gbr   -> B.SilkS.gbr.GBO
% F.Cu.gbr      -> F.Cu.gbr.GTL
% F.Mask.gbr    -> F.Mask.gbr.GTS
% F.SilkS.gbr   -> F.SilkS.gbr.GTO
% Edge.Cuts.gbr -> Edge.Cuts.gbr.GKO
% .drl          -> drl.XLN (any .drl file is renamed)
%
%

searchCell = { 'B.Cu.gbr' 'B.Mask.gbr' 'B.SilkS.gbr' 'F.Cu.gbr' 'F.Mask.gbr' ...
	'F.SilkS.gbr' 'Edge.Cuts.gbr' '.drl' };

replaceCell = {'B.Cu.gbr.GBL' 'B.Mask.gbr.GBS' 'B.SilkS.gbr.GBO' ...
	'F.Cu.gbr.GTL' 'F.Mask.gbr.GTS' 'F.SilkS.gbr.GTO' ...
	'Edge.Cuts.gbr.GKO' 'drl.XLN'};

d = dir([dirname filesep '*.drl']);
if ~isempty(d),
	searchCell{end} = d(1).name;
end;

filenamesearchreplace(dirname,searchCell,replaceCell,'useOutputDir',1,...
	'OutputDir', 'OSHPark', 'noOp',0);
