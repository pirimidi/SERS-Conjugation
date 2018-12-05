%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 12, 2012.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives a set of Raman measurement maps in the 
% form of an intensity matrix, then returns the sum of intensity values 
% along with standard error for each concentration.
%
% ARGUMENTS:
%
%   - rows := number of experiment types (such as concentration series)
%   - cols := number of repeated experiments of the same kind (for error bar)
%   - p := top p% of intensity values used in the integration 
%   - q := q% of intensity values to be removed as upper and lower extremes
%   - type := 0 or 1, for hotspot or SERS intensity integration
%   
%       - 0 := assemble excludes negative values and zero from the total 
%              number of measurement, so various mapping experiments could
%              integrate a different number of intensity values 
%   
%       - 1 := essentially all SERS measurements included in the assemble,
%              so every mapping experiment integrates the same number of 
%              intensity values
%
% DEFINITIONS:
%
%   - hotspot := defined as positive signal-to-baseline intensity value only  
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_intensity_sum_power(rows, cols, p, q, type)

disp('--> Raman intensity sum power start');
fprintf('\n');

% Set default number formatting.
format short;

% Get all datasets in current working directory.
d = dir('*.txt');
file_names = {d.name};

% Determine the number of files to evaluate.
l = length(file_names);

% Initialize max/min intensity value (holder) arrays.
M_max = [];
M_min = [];

% Initialize matrix to hold sum of intensity values for all mappings.
H = zeros(rows, cols);

% Initialize concentration (holder) array. Needs to be predefined by user.
% Units are in pM.
C = [1 8 60];

% Initialize row index.
o = 1;

% Iterate through all datasets and calculate sum of intensities for each
% concentration.
for i=1:l
  
    % Get intensity values from intensity matrix data file.
    M = load(char(file_names(i))); 
    
    % Display heatmap processing status.
    disp(['--> Processing matrix: ', char(file_names(i)), ' - [hs, er]% = [', num2str(p), ', ', num2str(q), ']%']);   
    fprintf('\n');

    % Determine dimensions of intensity matrix.
    [r, c] = size(M);
    
    % Initialize arrays for holding statistical data.
    D=[];
    R=[];
    Q=[];
    T=[];

    % Collect all intensity entries from matrix into an array, I.
    I = reshape(M, 1, r*c);     

    % Sort intensity values in descending order.
    D = sort(I, 'descend');

    % Remove non-positive intensity values from intensity array. 
    if(type == 0)
        m = 1;
        for n=1:length(D)

            if(D(n) > 0)
                R(m) = D(n);
                m = m + 1;  % update internal counter.
            end
        end
        
    % Use all intensity values in the integration.    
    else 
        R = D;
    end
    
    % Calculate the extrema interval to be removed from upper and lower
    % bounds.
    if(q == 0)
        Q = R;
    else 
        extrema = floor(q*length(R)/100);
        Q = R(extrema:(length(R) - extrema));
    end
    
    % Select top p% of intensity values to display from extrema-removed
    % intensity value set, Q.
    maxima = floor(p*length(Q)/100);
    T = Q(1:maxima);
    
    % Determine maximum and minimum intensity values in the measurement
    % set.
    I_max = max(T);
    I_min = min(T);  
    
    % Add these elements into max/min holder.
    M_max = [M_max I_max];
    M_min = [M_min I_min];    

    % Calculate sum of intensities.
    s = sum(T);
    
    % Display some statistics on hotspots.
    disp(['--> Total number of measurements: ', num2str(length(D))]);
    disp(['--> Total number of hotspots: ', num2str(length(R))]);
    
    if(q == 0)
        disp(['--> Top ', num2str(p), '% of hotspots: ', num2str(length(T))]);
    else
        disp(['--> Extrema interval to be removed: ', num2str(extrema)]);
        disp(['--> Total number of extrema-removed hotspots: ', num2str(length(Q))]);
        disp(['--> Top ', num2str(p), '% of extrema-removed hotspots: ', num2str(length(T))]);
    end
    fprintf('\n');
    
    % Determine column index.
    v = mod(i, cols);

    % Update to correct column index when modulus is zero.
    if(v == 0)
        v = cols; 
    end
   
    % Update matrix to hold sum of intensity values.
    H(o,v) = s;   
    
    % If maximum column number is reached, reset row number to 1.
    if(v == cols)
        o = o + 1;
    end   
    
end

% Determine global max/min intensity values over all measurement sets.
F_max = max(M_max);
F_min = min(M_min);

% Average sum of intensities per concentartion basis.
A = mean(H, 2);	

% Determine standard deviation of mean of sum of intensities.
S = std(H, 0, 2);	

% Determine standard error of sum of intensities.
E = S;

A
E

% Plot 1: sum of intensities vs. concentration.
figure(1)
errorbar(C, A, E, '-ko', 'LineWidth', 3.0,...
                  'MarkerEdgeColor', 'k',...
                  'MarkerFaceColor', 'k',...
                  'MarkerSize', 20);
              
% Show the vertical errorbar line in log y scale plot when the data error 
% is larger than data itself (external M-file).
errorbarlogx;

% Choose right x-range depending on required data points to display.
%xlim([1E1 1E7]);    

xlabel('Concentration (pM)', 'fontsize', 30);
ylabel('Sum of Intensity (cnt)', 'fontsize', 30);
set(gca, 'FontSize', 24);

h = legend('I_SUM vs. CC', 2);
set(h,'Interpreter','none');

t = ['I_{SUM} vs. CC: ', '[hs, er]% = [', num2str(p), ', ', num2str(q), ']%'];
title(t, 'fontsize', 30, 'fontweight', 'b');

% Fit histogram with power law and display functional relationship.
f = ezfit(C, A, 'power; lin');
showfit(f);

% Save histogram in *.bmp and *.fig file formats.
[pathstr, name, ext] = fileparts(char(file_names(i)));
na = strsplit(name, '_');
fn = strcat('I_vs_cc_', char(na(2)), '_hs-', num2str(p), '%_er-', num2str(q), '%');
print('-dbmp', [fn, '.bmp']);
saveas(gcf, [fn, '.fig']);
close;

% Display some statistics on hotspots.
disp(['--> Global intensity maximum: ', num2str(F_max)]);
disp(['--> Global intensity minimum: ', num2str(F_min)]);
fprintf('\n');

disp('--> Raman intensity sum power end');
fprintf('\n');
