function [Constants Params Controls] = setup_jones(sim,Constants,...
                                                Params,Controls,Override)

switch sim
    case 'jones2002_04_adj'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_04_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_04_cmro2_adj',...
                                    Constants, Params, Controls, Override);
                                
	case 'jones2002_04_raw'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_04_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_04_cmro2_raw',...
                                    Constants, Params, Controls, Override);
                                
	case 'jones2002_04_nomet'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_04_cbf',...
                                    Constants, Params, Controls, Override);
                                
        Controls.metabolism_type = 0;
                                
    case 'jones2002_04_cbf'
        
        [Jones2002 idx04] = load_jones2002('0.4mA');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Jones2002(idx04).stim_duration;
        
        % optVals = [2 0.25 0.06 1.4452 10];
        % optVals = [0.997278     0.206248     0.069474      1.93717 0.647095]; % New RMS 0.0160115
        % optVals = [1.86104     0.260423    0.0706068     0.774823      0.56316]; % New RMS 0.0158866
        optVals = [1.641     0.24843    0.070038      1.1384     0.57178]; % New RMS 0.015435
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
	case 'jones2002_04_cmro2_adj'
        
        [Jones2002 idx04] = load_jones2002('0.4mA');
        
        % Metabolism
%         Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx04).stim_duration;
        
        % optVals = [8    0.022    0.022      4.18459      5]; % test
        % optVals = [8.40398    0.0189802    0.0256105      7.71223      24.8269]; % New RMS 0.0149016
        % optVals = [8.43444    0.0200462    0.0220672      1.00279           40]; % New RMS 0.01357
%         optVals = [9.01044     0.021066    0.0223134            1           40]; % New RMS 0.0134946
        
        Controls.metabolism_type = 9;
        % optVals = [7.20809    0.022   35.8552];
        % optVals = [11.0424    0.0212147           40]; % RMS 0.0026649
        optVals = [8.71942    0.0216089           40]; % RMS 0.00264701
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'jones2002_04_cmro2_raw'
        
        [Jones2002 idx04] = load_jones2002('0.4mA');
        
        % Metabolism
%         Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx04).stim_duration;
        
        % optVals = [4.5 0.001 0.02 2 7.8]; % original
        % optVals = [7.20741    0.0230143    0.0046695      22.6896      34.9846]; % New RMS 0.0382053
%         optVals = [7.20809    0.0229928   0.00657381      19.6268      35.8552]; % New RMS 0.0382003
        
        Controls.metabolism_type = 9;
        % optVals = [7.20809    0.022   35.8552];
        % optVals = [6.33089    0.0183149      23.1307]; % RMS 0.00445072
        optVals = [5.89873    0.0179321      24.8241]; % RMS 0.00444994
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
    
    case 'jones2002_08_adj'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_08_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_08_cmro2_adj',...
                                    Constants, Params, Controls, Override);
                                
	case 'jones2002_08_raw'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_08_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_08_cmro2_raw',...
                                    Constants, Params, Controls, Override);
                                
	case 'jones2002_08_nomet'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_08_cbf',...
                                    Constants, Params, Controls, Override);
                                
        Controls.metabolism_type = 0;
                                
    case 'jones2002_08_cbf'
        
        [Jones2002 idx08] = load_jones2002('0.8mA');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Jones2002(idx08).stim_duration;
        
        % optVals = [2    1.2     0.3     1.4452  10]; % original
        % optVals = [1.3498       1.446     0.26126      1.2261      6.0066]; % RMS 0.010032
        % optVals = [1.6077        1.46     0.28059     0.91826      4.9426]; % New RMS 0.067736
        % optVals = [2.174844      1.520493     0.2832581     0.5000689      5.351196]; % New RMS 0.04165227
        optVals = [2.15712      1.53576     0.282648     0.516959      5.27797]; % New RMS 0.0413704
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
	case 'jones2002_08_cmro2_adj'
        
        [Jones2002 idx08] = load_jones2002('0.8mA');
        
        % Metabolism
%         Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx08).stim_duration;
        
        % optVals = [4.5 0.001 0.08 2 7.8]; % original
        % optVals = [9.70778    0.0833846    0.0719039      21.8484      14.2075]; % New RMS 0.0640899
%         optVals = [9.73293    0.0912432    0.0777431     0.523994      14.6201]; % New RMS 0.0621618
        
        Controls.metabolism_type = 9;
        % optVals = [9.73293    0.083   14.6201];
        % optVals = [9.24374    0.0808483      13.6554]; % RMS 0.00576785
        optVals = [9.61957    0.0814612      13.4122]; % RMS 0.00576503
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'jones2002_08_cmro2_raw'
        
        [Jones2002 idx08] = load_jones2002('0.8mA');
        
        % Metabolism
%         Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx08).stim_duration;
        
        % optVals = [4.5 0.001 0.08 2 7.8]; % original
        % optVals = [7.1473      0.1004    0.067682       1.818      9.0628]; % New RMS 0.22986
%         optVals = [6.9943    0.099255    0.067975      1.8949      9.0539]; % New RMS 0.22983
        
        Controls.metabolism_type = 9;
        % optVals = [6.9943    0.09   9.0539];
        % optVals = [5.363    0.074821      7.9604]; % RMS 0.011002
        optVals = [5.54    0.075145      7.8791]; % RMS 0.011001
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'jones2002_12_adj'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_12_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_12_cmro2_adj',...
                                    Constants, Params, Controls, Override);
                                
	case 'jones2002_12_raw'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_12_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_12_cmro2_raw',...
                                    Constants, Params, Controls, Override);
                                
	case 'jones2002_12_nomet'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_12_cbf',...
                                    Constants, Params, Controls, Override);
                                
        Controls.metabolism_type = 0;
                                
    case 'jones2002_12_cbf'
        
        [Jones2002 idx12] = load_jones2002('1.2mA');
        
        % Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Jones2002(idx12).stim_duration;
        
        % optVals = [2     1.8     0.75     1.4452     10]; % original
        % optVals = [1.695       1.584     0.61537      3.0406      8.2001]; % RMS 0.011016
        % optVals = [1.8094      1.8592     0.69328      1.4333      6.5252]; % test
        % optVals = [1.5913      1.4539     0.62092      3.5293 8.2562]; % New RMS 0.151277
        % optVals = [1.5913      1.4539     0.62092      3.5293      8.2562]; % New RMS 0.14216
        optVals = [1.88993      1.72886     0.636068      2.18947    7.88837]; % New RMS 0.119446
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
	case 'jones2002_12_cmro2_adj'
        
        [Jones2002 idx12] = load_jones2002('1.2mA');
        
        % Metabolism
%         Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx12).stim_duration;
        
        % optVals = [4.5 0.001 0.1 2 7.8]; % original
        % optVals = [9.96907    0.0682132    0.0817588      10.3471      10.6812]; % RMS 0.0078553
        % optVals = [16.6705    0.0605798     0.187289      11.4459      9.78781]; % New RMS 0.125173
        % optVals = [12.0704    0.0620449     0.116906      15.3773      10.5834]; % New RMS 0.115165
%         optVals = [11.6246    0.0796049    0.0790906      20.6883      11.1698]; % New RMS 0.114748
        
        Controls.metabolism_type = 9;
        % optVals = [11.6246    0.0794   11.1698];
        % optVals = [11.5594    0.0748226      11.6383]; % RMS 0.00758687
        optVals = [11.5702    0.0748867      11.7389]; % RMS 0.0075867
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'jones2002_12_cmro2_raw'
        
        [Jones2002 idx12] = load_jones2002('1.2mA');
        
        % Metabolism
%         Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx12).stim_duration;
        
        % optVals = [4.5 0.001 0.1 2 7.8]; % original
        % optVals = [6.62956     0.204389    0.0689868      3.78837      19.2321]; % New RMS 1.70828
%         optVals = [9.45726     0.150341    0.0197462      15.8654      11.0212]; % New RMS 1.65045
        
        Controls.metabolism_type = 9;
        % optVals = [9.45726    0.13   11.0212];
        % optVals = [6.4222     0.110508      7.00849]; % RMS 0.0287891
        optVals = [5.80859      0.11464      7.26531]; % RMS 0.0287431
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'jones2002_16_adj'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_16_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_16_cmro2_adj',...
                                    Constants, Params, Controls, Override);
                                
	case 'jones2002_16_raw'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_16_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_16_cmro2_raw',...
                                    Constants, Params, Controls, Override);
                                
	case 'jones2002_16_nomet'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_16_cbf',...
                                    Constants, Params, Controls, Override);
                                
        Controls.metabolism_type = 0;
        

    case 'jones2002_16_met_x2'
        
        Controls.tspan_dim = [-10 50];
        
        [Constants Params Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_16_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_16_cmro2_adj',...
                                    Constants, Params, Controls, Override);
                                
        Params.metabolism.A_ss = 2*Params.metabolism.A_ss;
                                
    case 'jones2002_16_cbf'
        
        [Jones2002 idx16] = load_jones2002('1.6mA');
        
        % Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Jones2002(idx16).stim_duration;
        
        % optVals = [2     2.8     1.2     1.4452     10]; % original
        % optVals = [2.270     2.712     1.133     0.734     9.596]; % RMS 
        % optVals = [2.01776      2.37679       1.1287      1.22225       9.3574]; % New RMS 0.164763
        optVals = [2.00327       2.4175      1.12698      1.24053      9.60818]; % New RMS 0.161934
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
	case 'jones2002_16_cmro2_adj'
        
        [Jones2002 idx16] = load_jones2002('1.6mA');
        
        % Metabolism
%         Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx16).stim_duration;
        
        % optVals = [4.5 0.001 0.1 2 7.8]; % original
        % optVals = [4.5 0.1 0.1 2 7.8]; % test
        % optVals = [11.946    0.0554243    0.0442048      14.0951      4.34932]; % New RMS 0.671756
        % optVals = [17.9249    0.0104413    0.0332386      20.2146      16.4064]; % New RMS 0.684317
%         optVals = [12.9969    0.0138942    0.0835335       24.524      7.68754]; % New RMS 0.659858
        
        Controls.metabolism_type = 9;
        % optVals = [12.9969    0.015   7.68754];
        % optVals = [19.9496    0.0334324      6.15685]; % RMS 0.0182343
        optVals = [16.61    0.0349768       5.9771]; % RMS 0.018191
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'jones2002_16_cmro2_raw'
        
        [Jones2002 idx16] = load_jones2002('1.6mA');
        
        % Metabolism
%         Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx16).stim_duration;
        
        % optVals = [4.5 0.001 0.1 2 7.8]; % original
        % optVals = [18.0035     0.166849    0.0522473      8.05402      6.11951]; % New RMS 3.13711
%         optVals = [4.99235    0.0248855     0.135694     0.722408      6.38264]; % New RMS 2.97278
        
        Controls.metabolism_type = 9;
        % optVals = [4.99235    0.08   6.38264];
        % optVals = [10.2171      0.13571      6.30181]; % RMS 0.0386779
        optVals = [10.2473      0.13577      6.30524]; % RMS 0.0386768
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'jones2002_co2_5'
        
        Controls.tspan_dim = [-20 180];
        
        [Constants Params Controls] = setup_problem('jones2002_co2_5_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_co2_5_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_co2_5_cmro2',...
                                    Constants, Params, Controls, Override);
                                
    case 'jones2002_co2_5_cbf'
        
        [Jones2002 idx5] = load_jones2002('co2_5');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Jones2002(idx5).stim_duration;
        
        % optVals = [10     0.3     0.5     15     20]; % original
        optVals = [12.1958     0.308094     0.507116      29.2087      23.9158]; % RMS 0.010875
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'jones2002_co2_5_cmro2'
        
        [Jones2002 idx5] = load_jones2002('co2_5');
                
        % Metabolism
        Controls.metabolism_type = 0;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx5).stim_duration;
        
    case 'jones2002_co2_5_o2'
        
        [Jones2002 idx5] = load_jones2002('co2_5');
        
        % O2 Params
        Controls.o2concin_type = 2;
        Params.o2concin.PO2_in = Jones2002(idx5).baseline_PO2./...
            Constants.reference.PO2_ref;
%         Params.o2concin.A = Jones2002(idx5).baseline_PO2./...
%             Jones2002(1).baseline_PO2 - 1;
        Params.o2concin.t0 = 0;
        Params.o2concin.t_rise = 60*ones(1,2);
        Params.o2concin.t_stim = Jones2002(idx5).stim_duration;
        Constants.ss.pO2_raw2(1) = Jones2002(1).baseline_PO2./...
            Constants.reference.PO2_ref;
        Params.metabolism.testK(5) = NaN;
        % Params.metabolism.testK(5) = 10;
        
        % Hemoglobin Params
        baseline_HbT = Jones2002(idx5).baseline_dHb + ...
            Jones2002(idx5).baseline_HbO;
        Constants.ss.SO2_assumed = Jones2002(idx5).baseline_HbO./...
            baseline_HbT;
        
    case 'jones2002_co2_10'
        
        Controls.tspan_dim = [-20 180];
        
        [Constants Params Controls] = setup_problem('jones2002_co2_10_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_co2_10_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('jones2002_co2_10_cmro2',...
                                    Constants, Params, Controls, Override);
                                
    case 'jones2002_co2_10_cbf'
        
        [Jones2002 idx10] = load_jones2002('co2_10');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Jones2002(idx10).stim_duration;
        
        % optVals = [10     0.6     2.3     30     20]; % original
        optVals = [9.51097     0.456977      2.43107      34.2588      18.2078]; % RMS 0.018653
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'jones2002_co2_10_cmro2'
        
        [Jones2002 idx10] = load_jones2002('co2_10');
        
        % Metabolism
        Controls.metabolism_type = 0;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Jones2002(idx10).stim_duration;
        
    case 'jones2002_co2_10_o2'
        
        [Jones2002 idx10] = load_jones2002('co2_10');
        
        % O2 Params
        Controls.o2concin_type = 2;
        Params.o2concin.PO2_in = Jones2002(idx10).baseline_PO2./...
            Constants.reference.PO2_ref;
        Params.o2concin.t0 = 0;
        Params.o2concin.t_rise = 60*ones(1,2);
        Params.o2concin.t_stim = Jones2002(idx10).stim_duration;
        Constants.ss.pO2_raw2(1) = Jones2002(1).baseline_PO2./...
            Constants.reference.PO2_ref;
        
        % Hemoglobin Params
        baseline_HbT = Jones2002(idx10).baseline_dHb + ...
            Jones2002(idx10).baseline_HbO;
        Constants.ss.SO2_assumed = Jones2002(idx10).baseline_HbO./...
            baseline_HbT;
        
    case 'jones2002_o2'
        
        % Using just this one as they're all the same
        [Jones2002 idxFirst] = load_jones2002('0.4mA');
        
        % O2 Params
        Constants.ss.pO2_raw2(1) = Jones2002(idxFirst).baseline_PO2./...
            Constants.reference.PO2_ref;
        
        % Hemoglobin Params
        baseline_HbT = Jones2002(idxFirst).baseline_dHb + ...
            Jones2002(idxFirst).baseline_HbO;
        Constants.ss.SO2_assumed = Jones2002(idxFirst).baseline_HbO./...
            baseline_HbT;
        
        % Assumed baseline PO2
        Controls.PO2_ss = [35./Constants.reference.PO2_ref 0];
        
end

end

function [Jones2002 idx] = load_jones2002(name)

load jones2002
idx = find(strcmp({Jones2002(:).name}, name)); %#ok<NODEF>

end