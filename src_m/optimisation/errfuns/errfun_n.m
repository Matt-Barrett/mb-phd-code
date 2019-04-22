function residuals = errfun_n(vary,ObjData,Constants,Params,Controls)

% Reformat/rename data passed in from base function.
DataObs = ObjData.data_obs;
scaling = ObjData.scaling;

vary = vary.*scaling;
vary = 3;

hbComp = 4; % total
% hbComp = 1; % arterial
% hbComp = 3; % venous
% hbComp = 2; % capillary
% hbComp = [1,3];

% For debugging
load hbdata
DataObs = HbData;
% useSO2 = true;
useSO2 = false;
Constants.ss.cHb_assumed = 100; % uM
Constants.physical.concHb = 2.33*10^3;

% The weights for spectroscopic imaging
Constants.ss.specWeight = Params.compliance.V_ss(1:3);
% Constants.ss.specWeight = [0 0 1];

nSims = length(DataObs.cbf);

Params.metabolism.A_peak = @(A_ss) A_ss*1.6907;

% Loop through each simulation
listSims = 1:nSims;
listSims(4) = listSims(end);
listSims(end) = 4;

for iSims = listSims
    
        % Set metabolism value based on flow (and constant)
        Params.metabolism.A_ss = DataObs.cbf(iSims)./vary(1);

        % Assign the stimulation length and set timespan
        Params.vasodilation.t_stim = DataObs.duration(iSims);
        Params.metabolism.t_stim = DataObs.duration(iSims);
        Controls.tspan_dim(2) = Params.vasodilation.t_stim+1;

        % Assign the correct PO2 value
        Controls.o2concin_type = 0;
        Params.o2concin.PO2_in = DataObs.po2(iSims)./Constants.reference.PO2_ref;
        Params.o2concin.P_ss = 1;
        Params.o2concin.t0 =  Controls.tspan_dim(1);
        Params.o2concin.t_rise = -Controls.tspan_dim(1).*0.8;
        Constants.ss.pO2_raw2(1) = DataObs.po2(iSims)./...
                                    Constants.reference.PO2_ref;

        % Assign the stimulus value that will achieve flow value
        Params.vasodilation.A_ss = ObjData.stim(iSims);
    
    if iSims == 4
        
        [Constants Params Controls] = setup_problem(...
                                            'leithner2010_baseline',...
                                            default_properties);
                                        
    end
    
    % Correct for the (assumed) baseline saturation
    if useSO2
        Constants.ss.SO2_assumed = DataObs.so2(iSims)/100;
        
    else
        Constants.ss.SO2_assumed = false;
    end
          
    % Solve the simulation
    [junk junk Data(iSims)] = solve_problem(Constants,Params,...
                              Controls); clear junk
    
    % Determine which index to use for the baseline 
	[t0 idxt0] = min(abs(Data(iSims).t(Data(iSims).t<=0)));
    
    % Calculate the normalised CBF, HbO and dHb
    DataPred.F(iSims) = max(Data(iSims).F(:,5)./...
                                Data(iSims).F(idxt0,5) - 1);

% 	% 
%     if useSO2
%         correctHbO = (Controls.SO2_assumed)./Data(iSims).SO2(idxt0,4);
%         correctdHb = (1-Controls.SO2_assumed)./(1-Data(iSims).SO2(idxt0,4));
%     else
%         correctHbO = 1;
%         correctdHb = 1;
%     end


    
    % HbO
%     if DataObs.doHbO(iSims)

        DataPred.HbO(iSims) = max(Data(iSims).HbO_spec);
        
%         DataPred.HbO(iSims) = (1./correctHbO).*(sum(max(Data(iSims).HbO_spec(:,hbComp)))./ ...
%                             sum(Data(iSims).HbO_spec(idxt0,hbComp)) - 1);
        
%         if useSO2
%             correctHbO = (DataObs.so2(iSims)/100)./Data(iSims).SO2(idxt0,4);
%         end
        
%         DataPred.HbO(iSims) = (1./correctHbO).*(sum(max(Data(iSims).nHbO(:,hbComp)))./...
%                                 (sum(Data(iSims).nHbO(idxt0,hbComp))) - 1);
        
        
%     else
%         DataPred.HbO(iSims) = NaN;
%     end
    
    % dHb
%     if DataObs.dodHb(iSims)

        DataPred.dHb(iSims) = min(Data(iSims).dHb_spec);
        
%         DataPred.dHb(iSims) = (1./correctdHb).*(sum(min(Data(iSims).dHb_spec(:,hbComp)))./ ...
%                             sum(Data(iSims).dHb_spec(idxt0,hbComp)) - 1);
        
%         if useSO2
%             correctdHb = 1/correctHbO;
%         end
        
%         if ~useSO2
%             DataPred.dHb(iSims) = (1./correctdHb).*(sum(min(Data(iSims).ndHb(:,hbComp)))./...
%                                     (sum(Data(iSims).ndHb(idxt0,hbComp))) -1);
%         else
%             DataPred.dHb(iSims) = sum(max(Data(iSims).ndHb(:,hbComp)))./...
%                                     (sum(Data(iSims).nHbT(idxt0,hbComp)).*(100-DataObs.so2(iSims))/100) - 1;
%         end
        
%     else
%         DataPred.dHb(iSims) = NaN;
%     end

        % HbT
    DataPred.HbT(iSims) = max(Data(iSims).HbT_spec);
%     DataPred.HbT(iSims) = sum(max(Data(iSims).nHbT(:,hbComp)))./...
%                                 sum(Data(iSims).nHbT(idxt0,hbComp)) -1;
                            
%     DataPred.HbT(iSims) = sum(max(Data(iSims).HbT_spec(:,hbComp)))./ ...
%                         sum(Data(iSims).HbT_spec(idxt0,hbComp))-1;
    

    
end;

% Sort these metrics to allow for better plotting
[DataPred.F sortIdx] = sort(DataPred.F);
DataPred.HbO = DataPred.HbO(sortIdx);
DataPred.dHb = DataPred.dHb(sortIdx);
DataPred.HbT = DataPred.HbT(sortIdx);

try 

    % Calculate residuals, normalising them to ensure fair comparison.
    res_dHb = (DataPred.dHb' - DataObs.dhb)./sum(DataObs.dodHb);
    res_HbO = DataPred.HbO' - DataObs.hbo./sum(DataObs.doHbO);
    residuals = [res_dHb; res_HbO];

catch

    % Give the solver another opportunity to correct for a set of
    % parameters that caused the ODE solver to fail.
    residuals = NaN;
    return

end

FontSize = 14;
FontSizeTitle = 16;

figure
hold on
title(['\Delta{CBF}/\Delta{CMRO2} = ' num2str(vary) ' , Weighting(s) ' ...
    num2str(Constants.ss.specWeight)],'FontSize',FontSizeTitle)
xlabel('Normalised \Delta{CBF} (a.u.)','FontSize',FontSizeTitle)
ylabel('Normalised \Delta{Hb} (a.u.)','FontSize',FontSizeTitle)
axis([0 0.6 -0.2 0.35])
plot(DataObs.cbf(DataObs.doHbO),DataObs.hbo(DataObs.doHbO),'r+','MarkerSize',10)
plot(DataObs.cbf,DataObs.hbt,'g+','MarkerSize',10)
plot(DataObs.cbf(DataObs.dodHb),DataObs.dhb(DataObs.dodHb),'b+','MarkerSize',10)
% plot(DataObs.cbf,((1+DataObs.cbf).^0.34)-1,'g-','MarkerSize',10)
plot(DataPred.F(DataObs.doHbO(sortIdx)),DataPred.HbO(DataObs.doHbO(sortIdx)),'rx-','MarkerSize',10)
plot(DataPred.F(~DataObs.doHbO(sortIdx)),DataPred.HbO(~DataObs.doHbO(sortIdx)),'rx','MarkerSize',10)
plot(DataPred.F,DataPred.HbT,'gx-','MarkerSize',10)
plot(DataPred.F(DataObs.dodHb(sortIdx)),DataPred.dHb(DataObs.dodHb(sortIdx)),'bx-','MarkerSize',10)
legend('HbO','HbT','dHb','Location','NorthWest')
set(gca,'FontSize',FontSize)
hold off

% Reduce the results to a scalar for fminsearch or fmincon
residuals = norm(residuals);

end