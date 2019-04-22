function y = vazquez_stim(t,params)

y = smoothstep(t,params.step);

doLevy = ~isscalar(t) || (t >= params.levy.t0);
if doLevy
    y_levy = levystim(t,params.levy);
    y = y + y_levy;
end

end