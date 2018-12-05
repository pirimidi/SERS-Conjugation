%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: July 8, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives an N-dimensional array (Y) containing N 
% set of data points, here intensity values (cnt) - and draws the corres-
% ponding barplot.
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function barplot(Y)

fprintf('\n'); 
disp('--> Raman barplot start');

% Set default number formatting.
format short;

% Generate barplot for N-dimensional matrix, Y.
bar(Y);  % Y = [4.65e+06 3.96e+06; 3.75e+06 3.71e+06; 4.99e+06 2.94e+06; 7.58e+05 8.99e+05];

% Color edges according to alkyne (red) and azido (blue) standards. 
hArray = bar(Y);
set(hArray(1), 'LineWidth', 2, 'EdgeColor', 'red');
set(hArray(2), 'LineWidth', 2, 'EdgeColor', 'blue');

% Set visual display.
colormap summer;
grid on;

%xlabel('Concentration (pM)', 'fontsize', 30);
ylabel('Intensity Integral (cnt)', 'fontsize', 30);

set(gca, 'FontSize', 20);
%set(gca,'XTickLabel',[1e0 1e2 1e4 1e6])
h = legend('alkyne', 'azido', 1);
set(h,'Interpreter','none');

% Display the element-wise ratio between the two (if N=2) data sets.
%R = Y(:,1)./Y(:,2)

disp('--> Raman barplot end');
fprintf('\n');

