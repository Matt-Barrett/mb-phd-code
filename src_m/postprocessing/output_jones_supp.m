function output_jones_supp(StatsFull, rms)

filename = './csv/jones_supp.csv';
columnNames = {'id', 'CBF', 'CMRO2', 'HbO', 'dHb', 'PO2', 'Error', ...
    'type', 'stim'};
namesFormatted = sprintf('%s\t',columnNames{:});

nStims = size(StatsFull{1},2);
stimNames = {'0.4 mA', '0.8 mA', '1.2 mA', '1.6 mA'};

typeNames = {'adj', 'raw'};
nTypes = length(typeNames);

fprintf('\nWriting "%s" ... ', filename)
fID = fopen(filename,'w');
fprintf(fID,'%s\n',namesFormatted(1:end-1));

for iStim = 1:nStims
    
    isAdj = true;
    
    for jType = 1:nTypes
        
        isOldRMS = size(rms, 2) == 3;
        rmsCol = jType;
        if isOldRMS, rmsCol = rmsCol+1; end
        rmsInd = rms(:, rmsCol,iStim);
        
        id = 1:length(rmsInd);
        
        cbf = 100*StatsFull{jType}(iStim).F.meanActive(:,5);
        cmro2 = 100*StatsFull{jType}(iStim).S.meanActive(:,4);
        if isAdj
            hbo = 100*StatsFull{jType}(iStim).HbO_spec.meanActive;
            dhb = 100*StatsFull{jType}(iStim).dHb_spec.meanActive;
            isAdj = false;
        else
            hbo = 100*StatsFull{jType}(iStim).nHbO.meanActive(:,4);
            dhb = 100*StatsFull{jType}(iStim).ndHb.meanActive(:,4);
        end
        po2 = 100*StatsFull{jType}(iStim).PO2_ss.meanActive(:,1);
        
        type = typeNames{jType};
        stim = stimNames{iStim};
        
        matFPrintF = [id', cbf, cmro2, hbo, dhb, po2, rmsInd]';
        
        strFormatTmp = repmat('\t%6.4f', 1, 6);
        strFormat = ['%d' strFormatTmp '\t' type '\t' stim '\n'];
        fprintf(fID,strFormat,matFPrintF);
        
    end
end


fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end