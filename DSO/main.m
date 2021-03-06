%______________________________________________________________________________________________
%  DRONE SQUADRON OPTIMIZATION Algorithm (DSO) toolbox                                                            
%  Source codes demo version 1.0
%                                                                                                     
%  Developed in Octave 3.8. Compatible with MATLAB 2011
%                                                                                                     
%  Author and programmer: Vinicius Veloso de Melo
%                                                                                                     
%         e-Mail: dr.vmelo@gmail.com                                                             
%                 vinicius.melo@unifesp.br                                               
%                                                                                                     
%       Homepage: http://www.sjc.unifesp.br/docente/vmelo/                                                         
%                                                                                                     
%  Main paper:                                                                                        
%  de Melo, V.V. & Banzhaf, W. Neural Comput & Applic (2017). doi:10.1007/s00521-017-2881-3
%  link.springer.com/article/10.1007/s00521-017-2881-3
%_______________________________________________________________________________________________


clear all
close all

rehash

format long g

warning ('off'); 
     
% rand('state', 123);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OBJECTIVE FUNCTION CONFIGURATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nDim = 5                    % number of variables
UB = ones(1, nDim) .* 30;    % upper bounds
LB = ones(1, nDim) .* -30;   % lower bounds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DSO CONFIGURATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

setup.C1 = 0.9;             % constants to be used in the formulas
setup.C2 = 0.4;
setup.C3 = 0.5;

setup.N_Teams = 4;          % number of teams
setup.N = 25;                % number of drones per team
setup.checkBounds = 1;      % shall it check for violations and correct the solutions?

setup.Command_Center_Iter = 10; % the Command Center updates the firmware at every 10 iterations
setup.MaxStagnation = 10;  % The maximum iterations without improvement to consider not stagnated
setup.Pacc = 0.1;           % The probability of accepting a worse solution when search stagnates
setup.ConvThres = 1e-15;     % Threshold to restart if there is a population convergence according to the objective function values

setup.VTR = 1e-20;          % value-to-reach
setup.ReportLag = 10;       % report at every 10 iterations
setup.MaxEvaluations = 50000;  % stopping criterion
setup.MaxIterations = floor(setup.MaxEvaluations / (setup.N * setup.N_Teams)); % maximum number of iterations. This does not consider the possible restarts
  
disp(setup)

tic() 
[Solution, Value, StatsCurveOFV, Evaluations, StopMessage, HistoryRanks] = DSO(@CostFunction, nDim, LB , UB, setup);
toc()


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

semilogy(StatsCurveOFV, 'LineWidth', 2)
% Turn on the grid
grid on
legend('Global Best','Current Best','Current Average','Current Median','Current Worst');

% Add title and axis labels
title(sprintf('Value: %.3e     Evaluations: %d', Value, Evaluations))
xlabel('Iterations')
ylabel('log10 (Objective Function Value)')

summary(StatsCurveOFV)

