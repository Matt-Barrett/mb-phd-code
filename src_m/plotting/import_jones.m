function [Jones2002 idxJones] = import_jones(simNames)

load('jones2002','Jones2002')
nameList = {Jones2002(:).name};

idxJones = zeros(length(simNames));

nNames = length(idxJones);
for iName = 1:nNames
    idxJones(iName) = find(strcmp(nameList, simNames{iName})); 
end

end