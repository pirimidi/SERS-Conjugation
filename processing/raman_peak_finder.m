%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 18, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives a set of spectral files of a Raman mapping
% measurements, determines the spectral window of interest, where signal is
% expected, finds the maximum intensity value in this range and finally 
% creates a matrix file of these intensity values according to the mapping
% ideces. 
% 
% INPUT ARGUMENTS:
%
%   - 'UL' = upper limit of intenesity window of interest (cm^-1) 
%   - 'window_size' = length of intensity range
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_peak_finder(UL, window_size, ID)

fprintf('\n');
disp('--> Largest peak finder start');
fprintf('\n');

% Set default number formatting.
format short;

% Determine the number of folders containing individual spectral files.
D = dir('*.txt');
Z = {D.name};
L = length(Z);

% Get current working directory.
cwd = pwd;

% Iterate through all individual spectral folders.
for k=1:L
    
    % Display folder processing status.
    disp(['--> Processing: ', char(Z(k))]);

    % Change to directory where the raw spectral files reside.
    cd([cwd, ['/blc_', num2str(k)]]);    
    
    % Get all spectral files in directory.
    d = dir('*.txt');
    file_names = {d.name};

    % Determine the number of files to evaluate.
    l = length(file_names);

    % Iterate through all spectral files.
    for i=1:l

        % Current file name.
        fn = char(file_names(i));

        % Display heatmap processing status.
        disp(['--> Largest peak in: ', fn]);   

        % Get intensity values from snake map data file.
        data = load(fn);

        % Retrieve wavenumbers and corresponding intensity values.
        W = data(:, 1);   % wavenumber (cm^-1)
        I = data(:, 2);   % relative intensity value (cnt)  

        % Find the index corresponding to the upper limit (UL).
        s = 0;
        for j=1:length(W)

            if ceil(W(j)) == UL
                s = j;
            end

        end

        % Determine the spectral window of interest, where signal is expected.
        X = W(s:s + window_size);
        Y = I(s:s + window_size);

        % Find the maximum intensity value in this range and also match this up
        % with the corresponding wavenumber.
        [P_I, Q] = max(Y);
        P_W = X(Q);

        % Determine indices based on file name.
        C = strsplit(fn, '_');
        F = strsplit(C{1}, '-');
        n = str2double(F{1});   % columns (X)
        m = str2double(F{2});   % rows (Y)

        % Place largest intensity value into matrix of peak intensities.
        S(m, n) = P_I;

    end

    % Change back to initial working direcory.
    cd(cwd);
    
    % Print intensity data respresented into text file.
    fi = strcat([ID, '_matrix_', num2str(k), '.txt']);
    dlmwrite(fi, S, 'delimiter', '\t', 'precision', 6); 

end

fprintf('\n');
disp('--> Largest peak finder end');
fprintf('\n');
