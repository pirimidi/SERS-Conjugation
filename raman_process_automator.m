%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 25, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives a set of N Raman measurement maps in the 
% form WiRE text data (output of 'Batch File Converter'), then:
%
%   (1) generates N folders containing individual spectral files indexed 
%       according to their location in the rectangular grid ('raw');
%
%   (2) computes the estimation of the baseline in each individual spectral
%       file signal using a non-quadratic cost-function and generates N 
%       folders containing these baseline-removed spectra ('blc');
%
%   (3) finds the maximum intensity value in all baseline-removed spectra 
%       in a range of signal interest and finally creates N matrix files of 
%       these intensity values (according to the mapping ideces)
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_process_automator(x_steps, y_steps, resolution,...
                                 UL_s, WS_s, UL_p, WS_p,...
                                 sn, bl, pf, no)
fprintf('\n');
disp('--> Raman process automator start');

% Start timer.
tic;

% Get current working directory.
CWD = pwd;

% Add script folder to search path.
addpath([CWD, '/processing']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                   AZIDO-ALKYNE SIGNAL PROCESSING                        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change to signal direcory.
cd([CWD, '/processing/azido-alkyne']);

% Execute 'snake' file processing.
if sn == 1
    raman_snake(x_steps, y_steps, resolution);
end

% Execute baseline correction algorithm.
if bl == 1
    raman_baseline();
end

% Execute peak finding algorithm.
if pf == 1
    raman_peak_finder(UL_s, WS_s, 'S')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                   PLASMON-PHONON SIGNAL PROCESSING                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change to signal direcory.
cd([CWD, '/processing/plasmon-phonon']);

% Execute 'snake' file processing.
if sn == 1
    raman_snake(x_steps, y_steps, resolution);
end

% Execute baseline correction algorithm.
if bl == 1
    raman_baseline();
end

% Execute peak finding algorithm.
if pf == 1
    raman_peak_finder(UL_p, WS_p, 'P')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                               NORMALIZATION                             %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if no == 1

    % Define output directory.
    D = [CWD, '/processing/normalization'];

    % Move files to appropiate directories.
    if exist(D, 'dir') == 0
        mkdir(D);
    end

    % Copy intensity matrix files from source directories for both azido-
    % alkyne ('aa') and plasmon-phonon ('pp') data.
    cd(D);
    copyfile([CWD, '/processing/azido-alkyne', '/S*'], D);
    copyfile([CWD, '/processing/plasmon-phonon', '/P*'], D);
    
    % Perform batch nomalization on 'aa' and 'pp' matrices.
    raman_batch_normalizer();
    
    % Delete intermediate matrix files.
    delete('*matrix*');
    
end

% Navigate to default directory.
cd(CWD);

% Stop timer.
toc;

fprintf('\n');
disp('--> Raman process automator end');
fprintf('\n');
