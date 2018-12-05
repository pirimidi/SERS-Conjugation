%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 12, 2013.
%
% For: DNA sequencing by Raman spectroscopy at the Ju Lab - Chemical 
% Engineering Department, Columbia University.
%
% Purpose: This program receives a two intensity values (cnt) corresponding
% to DBCO and N3 related SERS intensity integrals and draws a vertical line
% to estimate concentration based on the (already displayed) calibration 
% curves.
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_cadd_on(I_DBCO, I_N3)

fprintf('\n'); 
disp('--> Raman calibration add on start');

% Define power fit constants for DBCO-PEG4-Maleimide dilution series.
a_DBCO = 57999;
n_DBCO = 0.065046;

% Define power fit constants for N3-PEG4-Maleimide dilution series.
a_N3 = 4.7426e+05;
n_N3 = 0.060688;

% Determine the concentration given intensity integral values for DBCO and
% N3 SERS signals respectively.
C_DBCO = ((1 / a_DBCO) * I_DBCO)^(1 / n_DBCO); 
C_N3 = ((1 / a_N3) * I_N3)^(1 / n_N3); 

% Plot new data set over currently existing one.
hold on;

% Mark concentration estimates based on given intensity integrals.
vline(C_DBCO, ':r');
text(C_DBCO, I_DBCO, ['\leftarrow (' num2str(C_DBCO, '%10.2e\n') ', ' num2str(I_DBCO, '%10.2e\n') ')']);

vline(C_N3, ':b');
text(C_N3, I_N3, ['\leftarrow (' num2str(C_N3, '%10.2e\n') ', ' num2str(I_N3, '%10.2e\n') ')']);
    
disp('--> Raman calibration add on end');
fprintf('\n');
