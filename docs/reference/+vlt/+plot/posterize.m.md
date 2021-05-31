# vlt.plot.posterize

  vlt.plot.posterize - Change plot characteristics appropriate for posters
 
   vlt.plot.posterize(FIGNUM, ...)
 
   Changes plot characteristics appropriate for a poster.  By default:
   '_axes_fontsize' is set to 10
   '_axes_xlabel_fontsize' is set to 13
   '_axes_ylabel_fontsize' is set to 13
   '_axes_title_fontsize' is set to 13
   'fontname' is set to arial
   '_axes_box' is set to 'off'
 
   If additional arguments are provided in name/value pairs, then
   the function will attempt to set fields with each name to the
   value specified.  If the variable name has the form '_TYPE_FIELDNAME',
   then only fields of handles of type TYPE will be changed.  This can be
   extended to '_TYPE_HANDLENAME_FIELDNAME' and
   '_TYPE_HANDLENAME_..._HANDLE_NAME_FIELDNAME'
 
   Examples:
 
   vlt.plot.posterize(FIGNUM,'linewidth',2) will set the value of
     the field 'linewidth' to 2 in all handles that possess it.
   vlt.plot.posterize(FIGNUM,'_axes_fontsize',20) sets the value of the field
     'fontsize' in all handles of type 'axes'.
   vlt.plot.posterize(FIGNUM,'_axes_xlabel_fontsize',13) sets the value of the field
     'fontsize' in all handles called 'xlabel' in objects of type 'axes'
