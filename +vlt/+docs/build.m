function build()
% vlt.docs.build - build the vlt markdown documentation from Matlab source
%
% Builds the vlt documentation locally in vlt-matlab-toolbox/docs and updates the mkdocs-yml file
% in the $NDR-matlab directory.
%
% **Example**:
%   vlt.docs.build();
%

vlt.globals;

disp(['Now writing function reference...']);

vlt_path = vlt_globals.path.path;
vlt_docs = [vlt_path filesep 'docs' filesep 'reference']; % code reference path
ymlpath = 'reference';

disp(['Writing documents pass 1']);

out1 = vlt.docs.matlab2markdown(vlt_path,vlt_docs,ymlpath);
os = vlt.docs.markdownoutput2objectstruct(out1); % get object structures

disp(['Writing documents pass 2, with all links']);
out2 = vlt.docs.matlab2markdown(vlt_path,vlt_docs,ymlpath, os);

T = vlt.docs.mkdocsnavtext(out2,4);

ymlfile.references = [vlt_path filesep 'docs' filesep 'mkdocs-references.yml'];
ymlfile.start = [vlt_path filesep 'docs' filesep 'mkdocs-start.yml'];
ymlfile.end = [vlt_path filesep 'docs' filesep 'mkdocs-end.yml'];
ymlfile.main = [vlt_path filesep 'mkdocs.yml'];

vlt.file.str2text(ymlfile.references,T);

T0 = vlt.file.text2cellstr(ymlfile.start);
T1 = vlt.file.text2cellstr(ymlfile.references);
T2 = vlt.file.text2cellstr(ymlfile.end);

Tnew = cat(2,T0,T1,T2);

vlt.file.cellstr2text(ymlfile.main,Tnew);

