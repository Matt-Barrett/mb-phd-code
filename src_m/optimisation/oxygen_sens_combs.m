function [combinations startFrom nStages] = oxygen_sens_combs

% DefaultCombs{iRow,:} = {...
%     isDef,...       % scalar logical for default or override
%     isRel,...       % scalar logical for relative or absolute change
%     changeBy,...    % scalar value of how much to modify
%     idxs,...        % 1 x n vector of which indices to change
%     fieldNames,...  % 1 x m cell array of strings of where to make the change
%     };

startFrom = [1 3];
nStages = length(startFrom);

%% Stage 1 - Changes to default_properties, CBF, and Vazquez 2008

% Default Properties
combinations{1} = {...
    true,   true,   0.1,    1:5,    {'constants','ss','pO2_raw'};
    true,   true,   0.1,    1,      {'constants','ss','r1'};
    true,   true,   0.1,    1,      {'constants','ss','r2'};
    true,   false,  0.4,    1,      {'constants','ss','normk'};
    true,   true,   0.1,    1:4,      {'params','compliance','V_ss'}; 
};

% Vazquez 2008
combinations{1} = [combinations{1}; {...
    false,  true,   0.1,    1,      {'vazquez2008_dil_1','pressure','A'};
    false,  true,   0.1,    1,      {'vazquez2008_o2','ss','pO2_raw2'};
}];

%% Stage 2 - Changes to Vazquez 2010

combinations{2} = {...
    false,  true,   0.1,    1,      {'vazquez2010_o2','ss','pO2_raw2'};
    false,  true,   0.05,   5,      {'vazquez2010_o2','ss','pO2_raw2'};
    false,  true,   0.05,   3,      {'vazquez2010_o2','ss','pO2_mean2'};
};

end