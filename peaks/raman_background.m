%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 29, 2011.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program gathers a set of Raman measurement files containing
% two columns: [C1] Raman shift (cm^-1) and [C2] the corresponding intensity
% values (cnt) from the current working directory, then averages the values.
% Next it substracts background based on a 2 column matrix argument and 
% finally plots the correlation on a XY graph using linear Savitsky-Golay
% smoothing (2nd degree polynomial, 15 data points) - if desired.
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_background(ave, bgr, sm)

fprintf('\n'); 
disp('--> Raman background start');

% Set default number formatting.
format short;

% Get averaged Raman data and background values from data file.
raman_ave = load(ave); 
background = load(bgr);

% Substract background from averaged peak data.
raman_rem = raman_ave - background;

% Smooth curve using linear Savitsky-Golay algorithm.
if (sm == 1)
    raman_rem = sgolayfilt(raman_rem, 2, 15);
end

RS = raman_ave(:,1);   % Raman shift (cm^-1)
IN = raman_rem(:,2);   % intensity (cnt)

% Plot 1: intensity vs. Raman shift.
figure(1)
plot(RS, IN, '-r', 'LineWidth', 2.0);

xlabel('Raman shift (cm^{-1})', 'fontsize', 30);
ylabel('Intensity (cnt)', 'fontsize', 30);
set(gca, 'FontSize', 26);
set(gca,'XLim', [1900 2300]);

%h = legend('LEGEND', 2);
%set(h,'Interpreter','none');

%t = 'TTILE: ';
%title([t, file_name], 'fontsize', 16,'fontweight', 'b');

% Save averaged Raman data in a text file.
fid = fopen('bgr_removed.txt', 'w');
fprintf(fid, '%.4f %.6f\n', [RS, IN]');
fclose(fid);

disp('--> Raman background end');
fprintf('\n');
