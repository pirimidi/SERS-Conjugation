%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 18, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives a continous, raw data file containing four
% columns: (C1) Y, (C2) X coordinates, (C3) wavenumbers and corresponding 
% (C4) intensity values of a Raman mapping experiment based on a N-by-M 
% sized rectangular SERS area, it iterates through the snake data and 
% separates it into individual spectral files labeled with an index, which
% corresponds to the mapping location (of the rectangular grid).
%
% INPUT ARGUMENTS:
%
%   - 'x_steps' = number of aquasition steps along the X-direction (um)
%   - 'y_steps' = number of aquasition steps along the Y-direction (um)
%   - 'resolution' = number of data points in the individual spectra
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_snake(x_steps, y_steps, resolution)

fprintf('\n');
disp('--> Snake file processing start');
fprintf('\n');

% Set default number formatting.
format short;

% Get datasets in directory (expect many).
d = dir('*.txt');
file_names = {d.name};

% Determine the number of files to evaluate.
l = length(file_names);

% Get current working directory.
cwd = pwd;

% Create XY coordinates indeces of 2D mapping experiment.
index = raman_index(x_steps, y_steps);

% Iterate through all spectral (snake) data files.
for k=1:l
    
    % Display heatmap processing status.
    disp(['--> Processing: ', char(file_names(k))]);  

    % Load snake map data into the workspace.
    map = load(char(file_names(k)));
    
    % Define output directory.
    d = [cwd, ['/raw_', num2str(k)]];
    
    % Change to output direcory to generate individual files.
    if exist(d, 'dir') == 0
        mkdir(d);
    end

    cd(d);

    % Determine the number of files to evaluate from raw, snake data.
    [r, c] = size(map);
    num_spectra = r/resolution;    

    % Iterate through continuous snake data and break it into individual 
    % spectral files in the mapping experiment.
    for i=1:num_spectra     

        % Display spectrum processing status.
        disp(['--> Processing spectra: ', index{i}]); 

        % Determine section to retreieve.
        s = 1 + (i-1) * (resolution + 1);
        e = s + resolution; 

        % Retrieve XY coordinates, wavenumbers and corresponding intensity values.
        W = map(s:e, 3);   % wavenumber (cm^-1)
        I = map(s:e, 4);   % relative intensity value (cnt)

        % Print intensity data respresented into text file.
        fi = strcat(index{i}, '_spectra.txt');
        dlmwrite(fi, [W I], 'delimiter', '\t', 'precision', 6); 

    end

    % Change back to initial working direcory.
    cd(cwd);
    
end

disp('--> Snake file prosessing end');
fprintf('\n');
