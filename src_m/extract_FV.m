function [fit_data data] = extract_FV(constants,params,controls,data)

% Preallocate memory
nSteps = sum(params(1).vasodilation.n)+1;
fit_data.time = zeros(1,nSteps);
time_idx = zeros(1,nSteps);
fit_data.F_ss = zeros(1,nSteps);
fit_data.V_ss = zeros(5,nSteps);

% Loop through each step
for i = 1:nSteps

    fit_data.time(i) = (params(1).vasodilation.t_diff*...
        (i+params(1).vasodilation.n(1)-1));
    time_idx(i) = fit_data.time(i)./((controls(1).tspan_dim(2)...
        -controls(1).tspan_dim(1))/(controls(1).n_datapoints-1))+1;

    try
        fit_data.F_ss(i) = data(1).F(time_idx(i),5);
    catch
        time_tol = 1;
        time_idx(i) = find((data.t>=fit_data.time(i)-time_tol).*(data.t<=fit_data.time(i)+time_tol),1);
        try
            fit_data.F_ss(i) = data(1).F(time_idx(i),5);
        catch
            time_tol = 2;
            fit_data.time_idx(i) = find((data.t>=fit_data.time(i)-time_tol).*(data.t<=fit_data.time(i)+time_tol),1);
            fit_data.F_ss(i) = data(1).F(time_idx(i),5);
        end;
    end;

%             time_test(i) = data.t(time_idx(i));

    for j = 1:size(data(1).V,2)
        fit_data.V_ss(j,i) = data(1).V(time_idx(i),j);
    end;

end;

% cap + vei
fit_data.V_ss(5,:) = fit_data.V_ss(2,:) + fit_data.V_ss(3,:);
data(1).V(1,5) = data(1).V(1,2)+data(1).V(1,3);

end