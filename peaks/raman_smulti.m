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
% a user-defined intensity multiplier.
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_smulti(file_name, multi, sm)

fprintf('\n'); 
disp('--> Raman smulti start');

% Set default number formatting.
format short;

% Get Raman shift and intensity values from data file.
raman = load(file_name);

% Smooth curve using linear Savitsky-Golay algorithm.
if (sm == 1)
    raman = sgolayfilt(raman, 2, 15);
end

RS = raman(:,1);   % Raman shift (cm^-1)
IN = raman(:,2) * multi;   % multiply intensity (cnt)

% Plot 1: intensity vs. Raman shift.
figure(1)
plot(RS, IN, '-r', 'LineWidth', 3.0);

xlabel('Raman shift (cm^{-1})', 'fontsize', 30);
ylabel('Intensity (cnt)', 'fontsize', 30);
set(gca, 'FontSize', 26);
set(gca,'XLim', [1900 2300]);

%h = legend('LEGEND', 2);
%set(h,'Interpreter','none');

%t = 'TTILE: ';
%title([t, file_name], 'fontsize', 16,'fontweight', 'b');

disp('--> Raman smulti end');
fprintf('\n');

