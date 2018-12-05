%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 28, 2011.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives a set of Raman measurement file containing
% two columns: [C1] Raman shift (cm^-1) and [C2] the corresponding intensity
% values (cnt), averages the values then plots the correlation on a XY graph.
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_averager(x_range)

fprintf('\n'); 
disp('--> Raman averager start');

% Set default number formatting.
format short;

% Collect al file names ending with .txt containing Raman data.
files = dir('*.txt');

% Get the number of data points in Raman data.
s = size(load(files(2).name));

% Create initial zero array.
raman = zeros(s(1), 2);

for i=1:length(files)
    raman = raman + load(files(i).name);
end

% Calculate average Raman shift and intensity values from data files.
raman_ave = raman / length(files);

RS = raman_ave(:,1);   % Raman shift (cm^-1)
IN = raman_ave(:,2);   % intensity (cnt)

% Plot 1: intensity vs. Raman shift.
figure(1)
plot(RS, IN, '-r', 'LineWidth', 2.0);

xlabel('Raman shift (cm^{-1})', 'fontsize', 30);
ylabel('Intensity (cnt)', 'fontsize', 30);
set(gca, 'FontSize', 26);
set(gca,'XLim', x_range);

%h = legend('Averaged Intensity vs. Raman shift', 2);
%set(h,'Interpreter', 'none');

%t = 'Averaged Raman Shift of Azido Tag Compound on Al Reference Substrate';
%title(t, 'fontsize', 16, 'fontweight', 'b');

% Save averaged Raman data in a text file.
fid = fopen('average.txt', 'w');
fprintf(fid, '%.4f %.6f\n', raman_ave');
fclose(fid);

% Save histogram in *.tif and *.fig file formats.
print('-dtiff', 'average.tiff');
saveas(gcf, 'average.fig');
close;

disp('--> Raman averager end');
fprintf('\n');

