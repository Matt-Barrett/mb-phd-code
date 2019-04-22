function k = ODEs_15i(t,X,Xp,params,controls)

% Call Equations
k(1:7,1) = ODEs_15i_flow(t,X(1:7,1),Xp(1:7,1),params,controls);

if controls.O2
    k(8:11,1) = ODEs_15i_gasexchange(t,X,Xp,params,controls);
end

return;