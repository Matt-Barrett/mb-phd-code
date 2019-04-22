function warn_debug(ST,funcName,doDebug)

doWarnDebug = strcmp(ST(end).name,funcName) && doDebug;
if doWarnDebug
    warning('Optimisation:DebugOn','Debug Mode is enabled');
end

end