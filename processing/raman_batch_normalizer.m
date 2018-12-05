%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 16, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives two SERS intensity matrixes: (1) for the
% Raman probe signal [I_S] and (2) its corresponding plasmon-phonon [I_P] 
% peak respectively; then generates the normalized matrix according to 
% formula:
%                           I_N = I_S / I_P          (1)
%
% and finally prints this matrix to file (to be used in the general 
% quantification method). 
%
% INPUT ARGUMENTS:
%
%       - 's_matrix' := intensity matrix for the signal (such as N3, DBCO)
%       - 'p_matrix' := intensity matrix of the plasnom-phonon signal
%                       corresponding to 's_matrix'
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_batch_normalizer()

fprintf('\n');
disp('--> Raman batch nomalizer start');
fprintf('\n');

% Set default number formatting.
format short;

% Determine the number of 'aa' and 'pp' matrix files.
AD = dir('S*');     PD = dir('P*');
AZ = {AD.name};     PZ = {PD.name};
AL = length(AZ);

% Iterate through all matrix files.
for k=1:AL

    % Current matrices to normalize.
    fa = char(AZ(k));
    fp = char(PZ(k));

    % Display heatmap processing status.
    disp(['--> Normalizing matrices: ', fa, ' & ', fp, ' #', num2str(k)]);  

    % Read in (signal, plasmon-phonon) intensity matrixes from data files.
    I_S = load(fa);
    I_P = load(fp);

    % Normalize the signal intensity matrix according to equation (1).
    I_N = I_S ./ I_P;

    % Determine dimensions of intensity matrix.
    [r, c] = size(I_N);

    % Replace all 0-divisions (Inf) with zero to ignore those entries.
    i = 0;
    for n=1:r
        for m =1:c  

            if(I_N(n, m) == Inf || isnan(I_N(n, m)))
                I_N(n, m) = 0;    
                i = i + 1;  % update internal counter.
            end    

        end    
    end

    % Count non-negative values after entry adjustment.
    j = 0;
    for n=1:r
        for m =1:c  

            if(I_N(n, m) > 0)
                j = j + 1;  % update internal counter.
            end    

        end    
    end

    % Save normalized intensity matrix in a text file.
    dlmwrite(['normalized_', num2str(k), '.txt'], I_N, 'delimiter', '\t');

end

fprintf('\n');
disp('--> Raman batch normalizer end');
fprintf('\n');
