# vlt.neuro.vision.oridir.dsi2dirparams

  DSI2DIRPARAMS - Given a DSI, generate double gaussian parameters that has that dsi index
 
    [RSP,RP,OP,SIGMA,RN] = vlt.neuro.vision.oridir.dsi2dirparams(DSI, ...)
 
    Given a requested DSI index value, where DSI is defined as 
      (RESPONSE(PREFERRED) - RESPONSE(OPPOSITE))/RESPONSE(PREFERRED)
    this function generates a set of double gaussian parameters that satisfies
    the DSI.
 
    By default, OP is 0, SIGMA is 20, RSP is 0, RP = 10. 
 
    One can add extra arguments as name/value pairs to modify the SIGMA, OP, and
    RSP parameters of the double gaussian, for example:
    [RSP,RP,OP,SIGMA,RN] = vlt.neuro.vision.oridir.dsi2dirparams(DSI, 'SIGMA',40)
 
    One can use the following code to validate this function:
       desired_index = [];
       actual_index = [];
       for i=0:0.1:1,
           desired_index(end+1) = i;
           [rsp,rp,op,sigma,rn] = vlt.neuro.vision.oridir.dsi2dirparams(i);
           [dummy,shape] = vlt.fit.otfit_carandini_err([rsp rp op sigma rn],[0:22.5:360-22.5]);
           actual_index(end+1) = vlt.neurovision.oridir.index.compute_directionindex(0:22.5:360-22.5,shape);
        end;
        [desired_index' actual_index']
 
    See also: vlt.fit.otfit_carandini
