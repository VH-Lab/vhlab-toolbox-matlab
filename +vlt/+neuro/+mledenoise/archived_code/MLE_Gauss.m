function [ x, fval ] = MLE_Gauss(t,dt,spiketimes,stimulitimes,SPs,fixP,fixparam,x0,smoothness)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
        
        lb = 0*x0;
        ub = lb + Inf;
        options = optimset('fmincon');
        options.Algorithm = 'sqp';
        if fixparam == 1
        
        %[x,fval] = fminunc(@nestedfun,x0);
        [x,fval] = fmincon(@nestedfun,x0,[],[],[],[],lb,ub,@mycon,options);
        else
        %lb = lb - Inf;
        %[x,fval] = fminunc(@nestedfun,x0);
        [x,fval] = fmincon(@nestedfun2,x0,[],[],[],[],lb,ub,[],options);
        end
        
        
        % Nested function that computes the objective function     
            function y = nestedfun(x0)
                
                time = (2*pi)*(t/max(t));
                
                g = fixP(1)*(sin(SPs(2)*time + SPs(3))) + fixP(2)*(sin(SPs(5)*time + SPs(6))) + fixP(3)*(sin(SPs(8)*time + SPs(9))) + fixP(4)*(sin(SPs(11)*time + SPs(12)));
                
                sigma = 3;
                
                f = x0;
                
                fs = f(stimulitimes+1);
                
                r = g.*fs + eps;
                      
                logP = -(spiketimes - r.*dt).^2/(2*sigma^2);
                     
                y = -sum(logP);
            end
        
        % Nested function that computes the objective function     
            function y = nestedfun2(x0)
                
                time = (2*pi)*(t/max(t));
       
                g = x0(1)*(sin(SPs(2)*time + SPs(3))) + x0(2)*(sin(SPs(5)*time + SPs(6))) + x0(3)*(sin(SPs(8)*time + SPs(9))) + x0(4)*(sin(SPs(11)*time + SPs(12)));

                sigma = 3;
                
                f = fixP;
                
                fs = f(stimulitimes+1);
                
                r = g.*fs + eps;
                     
                logP = -(spiketimes - r.*dt).^2/(2*sigma^2);

                y = -sum(logP);
            end
                
            function [c, ceq] = mycon(x)
                    x = x./max(x);
                    j = diff(x);
                    d = abs(j) - 0.25;
                    d(end+1) = -1;
%                     
                    dd = abs(diff(j)) - smoothness;
                    dd(end+1) = -1;
                    dd(end+1) = -1;
                    
%                     c = sign(d) + sign(dd) + 0.5;
                    c = dd;
                    %c = 0*x - 1;
                    ceq = 0*x;
            end
        
end

