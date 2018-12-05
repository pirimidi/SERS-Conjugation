%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: October 22, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives a spectral file containing XY values in
% in two separate columns, which also has some arbitrary header of N lines.
% It removes these lines of text, such that the data file can be machine
% read by any script, i.e., only numeric in tab delimited column format.
% 
% INPUT ARGUMENTS:
%
%   - 'N' = number of lines to be removed (from beginning of file)
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_header_remover(N)

fprintf('\n');
disp('--> Header remover start');
fprintf('\n');

% Set default number formatting.
format short;

% Get current working directory.
cwd = pwd;
    
% Get all spectral files in directory.
d = dir('*.txt');
file_names = {d.name};

% Determine the number of files to evaluate.
l = length(file_names);

% Iterate through all spectral files.
for i=1:l

    % Display heatmap processing status.
    disp(['--> Header removal: ', char(file_names(i))]);   

    % Open source file.
    fid = fopen(char(file_names(i)), 'r');       
     
    % Remove desired number of lines (header) from the beginning of file.
    for j=1:N
        fgetl(fid);                               
    end
     
    % Read in the rest of the text file.
    buffer = fread(fid, Inf) ;                    
    fclose(fid);
     
    % Print intensity data respresented into text file.
    [pathstr, name, ext] = fileparts(char(file_names(i)));
    fi = strcat(name, '-R.txt');
    fid = fopen(fi, 'w');  % Open destination file.
    fwrite(fid, buffer);  % Save to file.
    fclose(fid);

end

% Define output directory.
a = [cwd, '/no_header'];

% Move files to appropiate directories.
if exist(a, 'dir') == 0
    mkdir(a);
end

movefile('*-R.txt', a);

% Change back to initial working direcory.
cd(cwd); 

fprintf('\n');
disp('--> Header remover end');
fprintf('\n');
