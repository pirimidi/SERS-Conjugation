%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 11, 2013.
%
% For: DNA sequencing by Raman spectroscopy at the Ju Lab - Chemical 
% Engineering Department, Columbia University.
%
% Purpose: This program receives a two intensity values (cnt) corresponding
% to DBCO and N3 related SERS intensity integrals, draws the two calibration
% curves associated with DBCO-PEG4-Maleimide and N3-PEG4-Maleimide dilution
% series then draws a vertical line to estimate concentration (at input 
% intensity values) based on the calibration curves.
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_calibration(I_DBCO, I_N3)

fprintf('\n'); 
disp('--> Raman calibration start');

% Define power fit constants for DBCO-PEG4-Maleimide dilution series.
a_DBCO = 1.2377e+05;
n_DBCO = 0.030687;

% Define power fit constants for N3-PEG4-Maleimide dilution series.
a_N3 = 7.7277e+05;
n_N3 = 0.032639;

% Define the dilution steps.
x = logspace(-30, 5, 25);

% Generate calibration curves for using empirical power fit data.
y_DBCO = a_DBCO * x.^n_DBCO;
y_N3 = a_N3 * x.^n_N3;

% Determine the concentration given intensity integral values for DBCO and
% N3 SERS signals respectively.
C_DBCO = ((1 / a_DBCO) * I_DBCO)^(1 / n_DBCO); 
C_N3 = ((1 / a_N3) * I_N3)^(1 / n_N3); 

% Plot the correlation on a semi-log graph. 
semilogx(x, y_DBCO, '-ro', 'LineWidth', 2.0,... 
                           'MarkerEdgeColor', 'r',...
                           'MarkerFaceColor', 'w',...
                           'MarkerSize', 10);                                            
hold on;
semilogx(x, y_N3, '-bo',  'LineWidth', 2.0, 'MarkerEdgeColor', 'b',...
                                            'MarkerFaceColor', 'w',...
                                            'MarkerSize', 10);
                       
% Mark concentration estimates based on given intensity integrals.
vline(C_DBCO, '--r');
text(C_DBCO, I_DBCO, ['\leftarrow (' num2str(C_DBCO, '%10.2e\n') ', ' num2str(I_DBCO, '%10.2e\n') ')']);

vline(C_N3, '--b');
text(C_N3, I_N3, ['\leftarrow (' num2str(C_N3, '%10.2e\n') ', ' num2str(I_N3, '%10.2e\n') ')']);
    
% Draw labels as desired.
xlabel('Concentration (pM)', 'fontsize', 20);
ylabel('Sum of Intensity (cnt)', 'fontsize', 20);

set(gca, 'FontSize', 20);
set(gca,'XLim', [x(1) x(length(x))]);

h = legend('DBCO-Cy3', 'dN6P-N_{3}', 1);
set(h,'Interpreter', 'none');

t = 'Calibration Curves for DBCO-Cy3 and dN6P-N_{3}';
title(t, 'fontsize', 20);

% Save plot in *.fig file format.
fn = strcat('calibration');
saveas(gcf, [fn, '.fig']);

% Display some statistics on hotspots.
fprintf('\n');
fprintf('--> (C_DBCO, I_DBCO) : (%10.4e pM, %10.4e au)\n', C_DBCO, I_DBCO);
fprintf('--> (C_N3, I_N3) : (%10.4e pM, %10.4e au)\n', C_N3, I_N3);
    
fprintf('\n');
disp('--> Raman calibration end');
fprintf('\n');
