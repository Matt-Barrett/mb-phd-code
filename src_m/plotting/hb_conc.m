function [H_axes rows columns] = hb_conc(P,sim_list,data,params)

req_sim = {'vazquez2010'};
idx = find_data_indices(sim_list,req_sim);

rows = 1;
columns = 1;


weightingBlood = data(idx).V(:,4)./(data(idx).V(:,4) + params(idx).compliance.V_ss(4));
weightingBlood0 = data(idx).V(1,4)./(data(idx).V(1,4) + params(idx).compliance.V_ss(4));


figure, 
    H_axes(1) = subplot(rows,columns,1);
    plot(data(idx).t,100*(-1+(data(idx).V(:,4)+params(idx).compliance.V_ss(4))/(sum(params(idx).compliance.V_ss(:)))));
figure, hold on
    plot(data(idx).t,weightingBlood./weightingBlood0,'b-')
    plot(data(idx).t,data(idx).V(:,4),'r-')

end