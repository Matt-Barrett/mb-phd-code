function y = smoothstepdownup(t,params)

% % input params
% params.t0 = 0;
% params.t_rise = 1;
% params.t_diff = 5;
% params.y_diff = [0.1 0.3];
% params.n = [1 4];

% t = 0:0.2:100;

TOL = 50;
doLogSpacing = params.y_diff(2) > TOL;
% Calculate the array of logarithmically spaced stimulus increases
if doLogSpacing
    maxStim = params.n(2)*params.y_diff(2);
    yDiffLog = logspace(0,log10(maxStim+1),params.n(2)+1)-1;
    yDiffLog = yDiffLog(2:end) - yDiffLog(1:end-1);
end

updown.A = - params.y_diff(1);
updown.t0 = params.t0;
updown.t_rise = params.t_rise;

if doLogSpacing
    count = 0;
end
y = smoothstep(t,updown);

for i = 2 : 2*sum(params.n)
    
    updown.t0 = updown.t0 + params.t_diff;
    updown.t_rise = params.t_rise;
    
    if i<= 2*params.n(1)
        
        if i <= params.n(1)
            updown.A = -params.y_diff(1);
        else
            updown.A = params.y_diff(1);
        end
        
    else
        
        if ~doLogSpacing
            updown.A = params.y_diff(2);
        else
            if i <= 2*params.n(1) + params.n(2)
                count = count+1;
            end
            updown.A = yDiffLog(count);
        end
        
        if i <= 2*params.n(1) + params.n(2)
            updown.A = updown.A;
        else
            updown.A = -updown.A;
        end
        
    end    
    
    y = y + smoothstep(t,updown);
    
    if doLogSpacing && i > 2*params.n(1) + params.n(2)
        count = count-1;
    end
    
end;

% figure, plot(t,y)

end