function output_phase_corr(StatsFull)

filename = './csv/phase_corr.csv';
columnNames = {'idPoint','cbf','cmro2_calc','cmro2_model','extraction',...
    'idSim','phase','stim'};
namesFormatted = sprintf('%s\t',columnNames{:});

nStims = size(StatsFull,2);
stimNames = {'0.4 mA','0.8 mA','1.2 mA','1.6 mA'};

phaseNames = {'Onset','Plateau','Offset'};
phaseVars = strcat('corr_',lower(phaseNames));
nPhases = length(phaseNames);

permuteOrder = [1 3 2];

fprintf('\nWriting "%s" ... ',filename)

fID = fopen(filename,'w');
fprintf(fID,'%s\n',namesFormatted(1:end-1));

for iStim = 1:nStims
    for jPhase = 1:nPhases

        cbf = permute(StatsFull(iStim).F.(...
            phaseVars{jPhase})(:,end,:),permuteOrder)';
        cmro2_calc = permute(StatsFull(iStim).cmro2_pred.(...
            phaseVars{jPhase})(:,end,:),permuteOrder)';
        cmro2_model = permute(StatsFull(iStim).S.(...
            phaseVars{jPhase})(:,end,:),permuteOrder)';
        extraction = permute(StatsFull(iStim).JO2.(...
            phaseVars{jPhase})(:,4,:),permuteOrder)';

        [nPoints nSims] = size(cbf);
        idSim = repmat(1:nSims,nPoints,1);
        idPoints = repmat((1:nPoints)',1,nSims);
        
        phase = phaseNames{jPhase};
        stim = stimNames{iStim};

        matFPrintF = [idPoints(:)'; cbf(:)'; cmro2_calc(:)'; 
            cmro2_model(:)'; extraction(:)'; idSim(:)'];

        strFormat = ['%d\t%6.4f\t%6.4f\t%6.4f\t%6.4f\t%d\t' ...
            phase '\t' stim '\n'];
        fprintf(fID,strFormat,matFPrintF);

    end
end

fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end