%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 18, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program computes the estimation of the baseline in a Raman 
% spectroscopic signal Y with wavenumbers N. The baseline is estimated by a
% polynomial using a non-quadratic cost-function with predefined parameters.
% 
% INPUT ARGUMENTS:
%
%   - 'N' = wavenumbers (cm^-1) 
%   - 'Y' = Raman spectroscopic signal (a.u.)
%
% PREDEFINED PARAMATERS (obtained from GUI of DEMO):
%
%   - 'order' = 4
%   - 'threshold' = 0.01 
%   - 'function' = 'atq'
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_baseline()

fprintf('\n');
disp('--> Baseline correction start');
fprintf('\n');

% Set default number formatting.
format short;

% Determine the number of folders containing individual spectral files.
D = dir('*.txt');
F = {D.name};
L = length(F);

% Get current working directory.
cwd = pwd;

% Iterate through all individual spectral folders.
for k=1:L
    
    % Display folder processing status.
    disp(['--> Processing: ', char(F(k))]);

    % Change to directory where the raw spectral files reside.
    cd([cwd, ['/raw_', num2str(k)]]);
    
    % Get all spectral files in directory.
    d = dir('*.txt');
    file_names = {d.name};

    % Determine the number of files to evaluate.
    l = length(file_names);

    % Predefined parameters (obtained from GUI of DEMO).
    ord = 4;
    s = 0.01; 
    fct = 'atq';

    % Iterate through all spectral files.
    for i=1:l

        % Display heatmap processing status.
        disp(['--> Baseline correcting: ', char(file_names(i))]);   

        % Get intensity values from snake map data file.
        data = load(char(file_names(i)));

        % Retrieve wavenumbers and corresponding intensity values.
        W = data(:, 1);   % wavenumber (cm^-1)
        I = data(:, 2);   % relative intensity value (cnt)    

        % Estimate background by minimizing a non-quadratic cost function.
        [B, A, IT, ord, s, fct] = backcor(W, I, ord, s, fct);

        % Print intensity data respresented into text file.
        [pathstr, name, ext] = fileparts(char(file_names(i)));
        fi = strcat(name, '-B.txt');
        dlmwrite(fi, [W I-B], 'delimiter', '\t', 'precision', 6); 

    end

    % Define output directory.
    a = [cwd, ['/blc_', num2str(k)]];
    
    % Move files to appropiate directories.
    if exist(a, 'dir') == 0
        mkdir(a);
    end

    movefile('*-B.txt', a);
    
    % Change back to initial working direcory.
    cd(cwd);
    
end    

fprintf('\n');
disp('--> Baseline correction end');
fprintf('\n');
