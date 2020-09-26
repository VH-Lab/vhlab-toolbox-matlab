function vhlab_people_html(dbtable_filename, output_filename)
% VHLAB_PEOPLE_HTML - Generate the VHLAB people page given a datebase of members
%
% vlt.html.vhlab_people_html(DBTABLE_FILENAME, OUTPUT_FILENAME)
%
% Generates the 'people' page for vhlab.org.
%
% Input: DBTABLE_FILENAME, the filename of a tab-delimited text structure
% file with first row field names and every other row comprised of values.
% The headers/fields of the table should be:
% Fieldname                | Description
% --------------------------------------------------------
% year                     | The year the person left the lab (if they are gone), empty otherwise
% lastname                 | The person's last name (used for alphabetical sorting)
% name                     | The person's name as it should appear on the page
% namelink                 | If not empty, a link that should be related to the person's name
% alumni                   | 0/1; is the person an alum? (that is, have they left the lab?)
% Group                    | Employment category; 'UG', 'STAFF', 'GS', 'PD', 'PI'
% title                    | Job title
% Years                    | String containing the years of service in the lab (e.g., '2010-2017')
% email                    | Email address string, person at brandeis dot edu
% paragraph                | HTML string containing a paragraph(s) of research interests.
% Links                    | Any links (current personnel only)
% imagefile                | Image link to the person's picture

db = vlt.file.loadStructArray(dbtable_filename);

 % postdoc/grad student/staff alum people

g_indexes = find( (strcmpi('GS',{db.Group}) | strcmpi('PD',{db.Group}) | strcmpi('STAFF',{db.Group})  ) & [db.alumni]==1 );

db_g = db(g_indexes);

db_g_order = vlt.data.sortstruct(db_g,'+year','+lastname');

str1 = vlt.html.alumni_htmltable(db_g_order,'addtitle',1);

 % now undergraduate-type alum people

ug_indexes = find( strcmpi('UG',{db.Group}) & [db.alumni]==1 );

db_ug = db(ug_indexes);

db_ug_order = vlt.data.sortstruct(db_ug,'+year','+lastname');

str2 = vlt.html.alumni_htmltable(db_ug_order);

str = cat(2,str1,str2);

vlt.file.cellstr2text(output_filename, str);
