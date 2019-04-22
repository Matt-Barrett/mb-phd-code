function vazquez2010_new = vazquez_2010_saturation(params,constants)

% adding this line so the file is modified

load vazquez2010

sat = @(PO2) 1./(1+((params.gas.hill.phi.*constants.reference.PO2_ref)./...
    (PO2)).^params.gas.hill.h);
names = {'PaO2_sma','PaO2_med','PaO2_lar','PvO2_sma','PvO2_med','PvO2_lar','PtO2','LDF'};

for i=1:length(names)
    
    vazquez2010_new{i} = eval(['Vazquez2010.' names{i} ';']);
    
    if i <= 7
        vazquez2010_new{length(names)+1}(1,i) = eval(['Vazquez2010.baseline.' names{i} ';']);
        vazquez2010_new{i}(:,2) = vazquez2010_new{length(names)+1}(1,i).*vazquez2010_new{i}(:,2);
    end
    
    if i <=6
        vazquez2010_new{i}(:,3) = sat(vazquez2010_new{i}(:,2));
        vazquez2010_new{length(names)+1}(2,i) = sat(vazquez2010_new{length(names)+1}(1,i));
    end;
    
    
    
end;

end