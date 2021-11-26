%% Prepare workspace and change to correct folder
filePath = fileparts(matlab.desktop.editor.getActiveFilename);
cd(filePath)
clc;
clear;

%% Create grey-box  model
model = ExampleGreyBoxModel();

%% Estimate grey-box model
[t, U, Y, X0, Ts] = loadData('./data/training.mat');
ssm = model.estimate(U, Y, Ts, X0);
Y_sim = simulate(ssm, t, U, X0);
fig_id = plotcompare(t, Y, Y_sim, 'measurement', 'simulation'); 
exportgraphics(fig_id,'./figures/identification.pdf');

%% Validate grey-box model
[t, U, Y, X0] = loadData('./data/validation.mat');
Y_sim = simulate(ssm, t, U, X0);
fig_val = plotcompare(t, Y, Y_sim, 'measurement', 'simulation'); 
exportgraphics(fig_val,'./figures/validation.pdf')