function S_bound = find_stim_bound(F_bound,Constants,Params,Controls,...
                                    varargin)
                                
if nargin > 4
    mode = varargin{1};
else
    mode = 'end';
end    

% define error function
errfun = @(S_bound) errfun_F(S_bound,F_bound,Constants,Params,...
                                Controls,mode);

S_bound_guess = F_bound-1;

% values come from spreadsheet in /Working
if S_bound_guess <= 0
%     for wide range of kappa1, where kappa1 is larger
%     S_bound_guess = S_bound_guess*4.86/(Params.compliance.kappa(1)^2.33);
    S_bound_guess = S_bound_guess*7.86/(Params.compliance.kappa(1)^2.33);
else
%     for wide range of kappa1, where kappa1 is larger
%     S_bound_guess = S_bound_guess*2.77/(Params.compliance.kappa(1)^1.82);
    S_bound_guess = S_bound_guess*6/(Params.compliance.kappa(1)^1.82);
%     S_bound_guess = S_bound_guess*(-4*Params.compliance.kappa(2)+7);
end

% Set options.
options = optimset('TolX',1E-2,'TolFun',1E-2,'OutputFcn',@outfun);
% For debugging only
% options = optimset('TolX',1E-2,'TolFun',1E-2,...
%                         'OutputFcn',@outfun,'Display','iter');

% find S_bound value using numeric methods
% [S_bound fval exitflag]= fminsearch(errfun,S_bound_guess,options);
[S_bound dummy exitflag]= fzero(errfun,S_bound_guess,options);

if exitflag ~= 1
    count = 1;
    maxcount = 5;
    while exitflag ~= 1 && count <= maxcount
        
        new_guess = S_bound_guess*2^count;
        [S_bound fval exitflag]= fzero(errfun,new_guess,options);
        
        if exitflag ~= 1
            new_guess = S_bound_guess*2^count;
            [S_bound fval exitflag]= fzero(errfun,new_guess,options);
        end;
        
    end
    
end

end

function err = errfun_F(S_bound,F_bound,Constants,Params,Controls,mode)

warning off MATLAB:illConditionedMatrix

% solve ODEs using current stimulus value
% disp(['trying S_bound = ' num2str(S_bound)])
switch Controls.vasodilation_type
    case 1
        Params.vasodilation.A = S_bound;
    case 6
        Params.vasodilation.A_ss = S_bound;
    otherwise
        error('find_stim_bound:unknownvaso',['Unknown dilation type'...
            ' "%1.0f"'],Controls.vasodilation_type)
end

[Constants Params Data] = solve_problem(Constants,Params,Controls);

% calculate err
switch lower(mode)
    case 'end'
        err = real(Data.F(end,5)) - F_bound;
    case 'max'
        err = max(real(Data.F(:,5))) - F_bound;
    otherwise
        error('find_stim_bound:unknownmode','Unknown mode "%s"',mode)
end


end

function stop = outfun(x,optimValues,state)

stop = false;

TOL = 0.005;
 
   switch state
       case 'iter'
           
           [msgstr, msgid] = lastwarn;
           
           if strcmp(msgid,'MATLAB:illConditionedMatrix')
               stop = optimValues.fval <= TOL;
           end
           
       otherwise
   end
end