function calc_new_rms(SimsOpt,SimsSens,rmsName)

%% Load the data

load vazquez2008
method = 'pchip';
[DataObs{1}(1:2).time] = deal(linspace(-5,70,1000)');
DataObs{1}(1).po2 = interp1(vazquez2008.PO2.control(:,1),...
    vazquez2008.PO2.control(:,2),DataObs{1}(1).time,method);
DataObs{1}(2).po2 = interp1(vazquez2008.PO2.vasodilated(:,1),...
    vazquez2008.PO2.vasodilated(:,2),DataObs{1}(1).time,method);
[DataObs{1}(1:2).baseline] = deal(vazquez2008.baseline);

load vazquez2010
DataObs{2}.time = Vazquez2010.PtO2(:,1);
DataObs{2}.po2 = Vazquez2010.PtO2(:,2);
DataObs{2}.baseline = Vazquez2010.baseline;

%% Run the simulations and calculate the new RMS

sim_list{1} = {...
    'vazquez2008_control_cap',...
    'vazquez2008_vasodilated_cap',...
    'vazquez2008_control',...
    'vazquez2008_vasodilated',...
    'vazquez2008_control_all',...
    'vazquez2008_vasodilated_all',...
    'vazquez2008_control_leak',...
    'vazquez2008_vasodilated_leak',...
    'vazquez2008_control_p50',...
    'vazquez2008_vasodilated_p50'
    };

sim_list{2} = {...
    'vazquez2010_cap',...
    'vazquez2010',...
    'vazquez2010_all',...
    'vazquez2010_leak',...
    'vazquez2010_p50'
    };

figList = [];
figFormats = [];
figNames = [];
                                    
%% Run the sensitivity analysis simulations

nStages = length(sim_list);
Opt = repmat(struct(),1,nStages);

for iStage = 1:nStages
    
%     sims_temp = [sim_list{iStage:end}];
    
    nCombs = size(SimsSens{iStage}.Default,2);
%     nCombs = 5;
    
    for jComb = 1:nCombs
        
        doOpt = jComb == 1;
        
        if doOpt
            
            try

            fprintf('Stage %d, Optimal simulation...',iStage);
            
            DefaultIn = SimsOpt.Default;
            DefaultIn.controls.t_values = DataObs{iStage}(1).time./...
                DefaultIn.constants.scaling.ts;

            [Opt(iStage).Data(jComb,:),...
             Opt(iStage).Constants(jComb,:),...
             Opt(iStage).Params(jComb,:),...
             Opt(iStage).Controls(jComb,:)] = ...
                                default_simulations(...
                                    DefaultIn,sim_list{iStage},...
                                    figList,figFormats,figNames,...
                                    SimsOpt.Override);

            fprintf(' done.\n')
            
            catch ME1
                
                fprintf(' ERROR!\n')
                
            end

        end
        
        try

            fprintf('Stage %d, Combination %d ...',iStage,jComb);
            
            DefaultIn = SimsSens{iStage}.Default{jComb};
                       
            DefaultIn.controls.t_values = DataObs{iStage}(1).time./...
                DefaultIn.constants.scaling.ts;

            [Sens{iStage}.Data(jComb,:),...
             Sens{iStage}.Constants(jComb,:),...
             Sens{iStage}.Params(jComb,:),...
             Sens{iStage}.Controls(jComb,:)] = default_simulations(...
                                DefaultIn,sim_list{iStage},...
                                figList,figFormats,figNames,...
                                SimsSens{iStage}.Override{jComb});
                            
            fprintf(' done.\n')
                            
        catch ME2
            
            fprintf(' ERROR!\n')
            
        end
                            
    end
    
    fprintf('\n')
                                
end

FullData{1} = [Opt(1).Data; Sens{1}.Data];
FullData{2} = [Opt(2).Data; Sens{2}.Data];

po2Ref = SimsOpt.Default.constants.reference.PO2_ref;

%% Calculate the new RMS values

for iStage = 1:nStages
    
    [nCombs nSims] = size(FullData{iStage});
    
    for jComb = 1:nCombs
    
        for kSim = 1:nSims

            if iStage == 1
                
                if rem(kSim,2) == 0
                    
                    doRMS = true;
                    count = floor(kSim/2);
                    
                    dataObs = [DataObs{iStage}(1).po2./po2Ref; ...
                        DataObs{iStage}(2).po2./po2Ref];
                    
                    dataPred = [FullData{iStage}(jComb,kSim-1).PO2_ss; ...
                        FullData{iStage}(jComb,kSim).PO2_ss];
                    
                    
                
                else
                    
                    doRMS = false;
                    
                end
                
            else
                
                doRMS = true;
                count = kSim;
                
                dataObs = DataObs{iStage}.po2;
                dataPred = FullData{iStage}(jComb,kSim).PO2_ss./...
                    FullData{iStage}(jComb,kSim).PO2_ss(1,:);
                
            end
            
            if doRMS

                rms_temp{iStage}(jComb,count) = 100*sqrt(sum(...
                    (1 - dataPred./dataObs).^2)./length(dataObs));
                
            end

        end
    
    end
    
end

% Reshape to match the format from previous RMS calculation
rms = nan(size(rms_temp{2},1),3,size(rms_temp{1},2));
rms(1:size(rms_temp{1},1),2,:) = rms_temp{1};
rms(1:size(rms_temp{2},1),3,:) = rms_temp{2};

save(rmsName,'rms')

end