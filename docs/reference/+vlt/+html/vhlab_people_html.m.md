# vlt.html.vhlab_people_html

```
  VHLAB_PEOPLE_HTML - Generate the VHLAB people page given a datebase of members
 
  vlt.html.vhlab_people_html(DBTABLE_FILENAME, OUTPUT_FILENAME)
 
  Generates the 'people' page for vhlab.org.
 
  Input: DBTABLE_FILENAME, the filename of a tab-delimited text structure
  file with first row field names and every other row comprised of values.
  The headers/fields of the table should be:
  Fieldname                | Description
  --------------------------------------------------------
  year                     | The year the person left the lab (if they are gone), empty otherwise
  lastname                 | The person's last name (used for alphabetical sorting)
  name                     | The person's name as it should appear on the page
  namelink                 | If not empty, a link that should be related to the person's name
  alumni                   | 0/1; is the person an alum? (that is, have they left the lab?)
  Group                    | Employment category; 'UG', 'STAFF', 'GS', 'PD', 'PI'
  title                    | Job title
  Years                    | String containing the years of service in the lab (e.g., '2010-2017')
  email                    | Email address string, person at brandeis dot edu
  paragraph                | HTML string containing a paragraph(s) of research interests.
  Links                    | Any links (current personnel only)
  imagefile                | Image link to the person's picture

```
