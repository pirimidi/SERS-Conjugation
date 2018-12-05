%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 4, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives a set of Raman measurement file containing
% two columns: [C1] Raman shift (cm^-1) and [C2] the corresponding intensity
% values (cnt) and displays their plots in stacked configuration on a XY graph.
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_stacker(offset, sm)

fprintf('\n'); 
disp('--> Raman stacker start');

% Set default number formatting.
format short;

% Collect al file names ending with .txt containing Raman data.
files = dir('*.txt');

% Get the number of data points in Raman data.
s = size(load(files(2).name));

% Create initial zero array.
raman = zeros(s(1), 2);

% Define color palette for plot display.
CP = linspecer(length(files));

% Plot 1: intensity vs. Raman shift.
figure(1)

for i=1:length(files)

    % Get Raman shift and intensity values from data file.
    raman = load(files(i).name);

    % Smooth curve using linear Savitsky-Golay algorithm.
    if (sm == 1)
        raman = sgolayfilt(raman, 2, 15);
    end

    RS = raman(:,1);   % Raman shift (cm^-1)
    IN = raman(:,2) + (i-1) * offset;   % vertical shift intensity (cnt)
    
    % Plot new data set over currently existing one.
    hold on;
    plot(RS, IN, 'Color', CP(i, :), 'LineWidth', 3.0);
    
end

% Draw labels as desired.
xlabel('Raman shift (cm^{-1})', 'fontsize', 30);
ylabel('Intensity (cnt)', 'fontsize', 30);
set(gca, 'FontSize', 26);
set(gca,'XLim', [1580 2560]);
box on;

disp('--> Raman stacker end');
fprintf('\n');

