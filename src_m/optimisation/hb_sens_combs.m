function [combinations startFrom nStages] = hb_sens_combs

% DefaultCombs{iRow,:} = {...
%     isDef,...       % scalar logical for default or override
%     isRel,...       % scalar logical for relative or absolute change
%     changeBy,...    % scalar value of how much to modify
%     idxs,...        % 1 x n vector of which indices to change
%     fieldNames,...  % 1 x m cell array of strings of where to make the change
%     };

startFrom = [1 2];
nStages = length(startFrom);

%% Stage 1 - Changes to CBF

% CBF
combinations{1} = {...
    true,   true,   0.05,   1:2,    {'params','compliance','kappa'}; 
    true,   true,   0.1,    1:3,    {'params','compliance','nu'}; 
};

%% Stage 2 - Changes to O2 Default Properties and Jones 2002

% Oxygen Default Properties
combinations{2} = {...
    true,   true,   0.1,    1:5,    {'constants','ss','pO2_raw'};
    true,   true,   0.1,    1,      {'constants','ss','r1'};
    true,   true,   0.1,    1,      {'constants','ss','r2'};
    true,   false,  0.4,    1,      {'constants','ss','normk'};
    true,   true,   0.1,    1:4,      {'params','compliance','V_ss'}; 
};

% Jones 2002
combinations{2} = [combinations{2}; {...
    false,  true,   0.1,    1,      {'jones2002_o2','ss','pO2_raw2'};
}];

end