%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 4, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives a Raman measurement file containing two 
% columns: [C1] Raman shift (cm^-1) and [C2] the corresponding intensity
% values (cnt), then plots the correlation on a XY graph using linear 
% Savitsky-Golay smoothing (2nd degree polynomial, 15 data points) using 
% a user-defined vertical shift - if desired.
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_sadd_on(file_name, shift, sm)

fprintf('\n'); 
disp('--> Raman vertical shift add on start');

% Set default number formatting.
format short;

% Get Raman shift and intensity values from data file.
raman = load(file_name);

% Smooth curve using linear Savitsky-Golay algorithm.
if (sm == 1)
    raman = sgolayfilt(raman, 2, 15);
end

RS = raman(:,1);   % Raman shift (cm^-1)
IN = raman(:,2) + shift;   % vertical shift intensity (cnt)

% Plot new data set over currently existing one.
hold on;
plot(RS, IN, 'LineWidth', 3.0)

disp('--> Raman vertical shift add on end');
fprintf('\n');

