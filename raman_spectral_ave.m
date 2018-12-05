%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 30, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program receives a set of N Raman measurement maps in the 
% form normalized/unnormalized signal and plasmon-phonon intensity matrices,
% then:
%
%   (1) builds a data structure array containing measurement information for 
%       each mapping point in the experiment (matrix entry);
%
%   (2) sorts this array according to any field of a structure, such as:
%
%           - S.index_i := x-coordinate in the intensity matrix
%           - S.index_j := y-coordinate in the intensity matrix
%           - S.coordinate := 2D coordinate of the matrix entry
%           - S.signal_max := maximum SERS signal determined by a previous
%             processing algorithm
%           - S.signal_max_norm := same as above, but nomalized by
%             plasmon-phonon signal
%           - S.plasmon_p_signal := plasmon-phonon (internal standard)
%             signal of measurement
%
%   (3) collects these spectral files according to 2D indeces and averages
%       them then plots the correlation on a XY graph.
%
% ARGUMENTS:
%
%   - N := number of measurement files
%   - so := sort strucure array by (1) SERS signal intensity [SM], (2) 
%           normalized SERS signal intensity [NM] or by (3) plasmon-phonon
%           signal intensity [PP].
%
%   - p := top p% of intensity values used in the spectral averaging
%   - q := q% of intensity values to be removed as upper and lower extremes
%   - type := 0 or 1, for hotspot or SERS intensity spectral averaging
%   
%       - 0 := assemble excludes negative values and zero from the total 
%              number of measurement, so various mapping experiments could
%              average a different number of spectral files
%   
%       - 1 := essentially all SERS measurements included in the assemble,
%              so every mapping experiment averages the same number of 
%              spectral files
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function raman_spectral_ave(N, so, p, q, type)

fprintf('\n');
disp('--> Raman spectral averager start');
fprintf('\n');

% Start timer.
tic;

% Set data containing directory.
DAT = 'C:\Users\Wyss User\Desktop\sers_conjugation\data';

% Get current working directory.
CWD = pwd;

% Add script folder to search path.
addpath([CWD, '/peaks']);

% Initialize structure array holder array.
SA = {};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                         UNNORMALIZED PROCESSING                         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change to unnormalized signal direcory.
cd([DAT, '\matrix\azido\unnormalized\histogram']);

% Get all datasets in this directory.
d = dir('*.txt');
file_names = {d.name};

% Iterate through all datasets and build data structure array for each 
% mapping experiment.
for i = 1:N
  
    % Get intensity values from intensity matrix data file.
    M = load(char(file_names(i))); 
    
    % Get dimensions of this matrix.
    [y, x] = size(M);
    
    % Display heatmap processing status.
    disp(['--> Processing matrix: ', char(file_names(i))]);   
    
    % Initialize spectral file counter.
    o = 1;
    
    % Create an empty (0-by-0) structure with no fields.
    S = struct([]);
    
    % Build structure for the x*y (961) mapping entries.
    for j = 1:x
        for k = 1:y    
            
            S(o).index_x = j;
            S(o).index_y = k;
            S(o).coordinate = [num2str(j), '-', num2str(k)];
            S(o).signal_max = M(k, j);
            
            o = o + 1;  % update file counter
            
        end
    end
    
    % Add these structure into the structure array holder array.
    SA(i) = {S};
    
end

fprintf('\n');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                                                                         %
% %                         NORMALIZED PROCESSING                           %
% %                                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Change to normalized signal direcory.
% cd([DAT, '\matrix\alkyne\normalized\histogram']);
% 
% % Get all datasets in this directory.
% d = dir('*.txt');
% file_names = {d.name};
% 
% % Iterate through all datasets and build data structure array for each 
% % mapping experiment.
% for i = 1:N
%   
%     % Get intensity values from intensity matrix data file.
%     B = load(char(file_names(i))); 
%     
%     % Get dimensions of this matrix.
%     [y, x] = size(B);
%     
%     % Display heatmap processing status.
%     disp(['--> Processing matrix: ', char(file_names(i))]);   
%     
%     % Initialize spectral file counter.
%     o = 1;
%     
%     % Recall the structure array holder array previously used.
%     S = cell2mat(SA(i));
%     
%     % Build structure for the x*y (961) mapping entries.
%     for j=1:x
%         for k=1:y    
%             
%             S(o).signal_max_norm = B(j, k);
%             o = o + 1;  % update file counter
%             
%         end
%     end
%     
%     % Update these structure into the structure array holder array.
%     SA(i) = {S};
%     
% end
% 
% fprintf('\n');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                                                                         %
% %                        PLASMON-PHONON PROCESSING                        %
% %                                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Change to plasmon-phonon signal direcory.
% cd([DAT, '\matrix\plasmon-phonon']);
% 
% % Get all datasets in this directory.
% d = dir('*.txt');
% file_names = {d.name};
% 
% % Iterate through all datasets and build data structure array for each 
% % mapping experiment.
% for i = 1:N
%   
%     % Get intensity values from intensity matrix data file.
%     V = load(char(file_names(i))); 
%     
%     % Get dimensions of this matrix.
%     [y, x] = size(V);
%     
%     % Display heatmap processing status.
%     disp(['--> Processing matrix: ', char(file_names(i))]);   
%     
%     % Initialize spectral file counter.
%     o = 1;
%       
%     % Recall the structure array holder array previously used.
%     S = cell2mat(SA(i));
%     
%     % Build structure for the x*y (961) mapping entries.
%     for j=1:x
%         for k=1:y    
%             
%             S(o).plasmon_signal = V(j, k);
%             o = o + 1;  % update file counter
%             
%         end
%     end
%     
%     % Update these structure into the structure array holder array.
%     SA(i) = {S};
%     
% end
% 
% fprintf('\n');
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                          SORTING BY ANY FIELD                           %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize sorted structure array holder array.
SS = {};

% Iterate through all individual spectral folders.
for k = 1:N

    % Retrieve unsorted structure array from holder.
    S = cell2mat(SA(k));

    % Sort specra by (unnormalized) maximum SERS intensity. 
    if so  == 'SM'
        [t z] = sort([S.signal_max], 'descend');
    end

    % Sort specra by normalized maximum SERS intensity. 
    if so  == 'NM'
        [t z] = sort([S.signal_max_norm], 'descend');
    end
    
    % Sort specra by plasmon-phonon peak intensity. 
    if so  == 'PP'
        [t z] = sort([S.plasmon_signal], 'descend');
    end    
       
    % Update these structure into the structure array holder array.
    SS(k) = {S(z)};
     
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                 PRINT STRUCTURE INTO FILE (BEFORE)                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Navigate to default directory.
cd(CWD);

for ff = 1:N    
    
    % Retrieve sorted structure array from holder and print to file.
    O = cell2mat(SS(ff));
    struct2csv(O, ['sort_raw_', num2str(ff), '.txt']);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                    ADJUST NUMBER OF TOTAL SPECTRA                       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
% Use SERS intensity based analysis by default, i.e., type 1. 
TT = SS;

% Iterate through all individual spectral folders using hotspot based 
% analysis, i.e., type 0.
if(type == 0)
    for kk = 1:N
    
        % Retrieve sorted structure array from holder.
        T = cell2mat(SS(kk));

        % Sort specra by (unnormalized) maximum SERS intensity. 
        if(strcmp(so, 'SM'))        
            nz = sum([T.signal_max] == 0);  % determine the number of zero entries              
        end
 
        % Sort specra by normalized maximum SERS intensity. 
        if(strcmp(so, 'NM'))            
            nz = sum([T.signal_max_norm]== 0);  % determine the number of zero entries              
        end

        % Sort specra by plasmon-phonon peak intensity. 
        if(strcmp(so, 'PP'))
             nz = sum([T.plasmon_signal] == 0);  % determine the number of zero entries             
        end
    
        % Adjust the length of structure array by removing zero containing elements.
        U = T(1:length(T)-nz);

        % Update these structure into the structure array holder array.
        TT(kk) = {U};
    end
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                      RETRIEVE LIST OF FILE INDICES                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ee = 1:N    
    
    % Navigate to default directory.
    cd(CWD);

    % Retrieve sorted structure array from holder and print to file.
    E = cell2mat(TT(ee));
    
    if(type == 0)
        struct2csv(E, ['sort_adj_', num2str(ee), '.txt']);
        data = load(['sort_adj_', num2str(ee), '.txt']);
    else
        data = load(['sort_raw_', num2str(ee), '.txt']);
    end
        
    % Initialize arrays for holding index pointing to spectral file.
    I={};
    Q=[];
    F=[];
        
    % Retrieve indices pointing to spectral files.
    ix = data(:, 2) ;
    iy = data(:, 3);
    
    for uu = 1:length(ix)
        I(uu) = {[num2str(ix(uu)), '-', num2str(iy(uu))]};
    end
    
    % Calculate the extrema interval to be removed from upper and lower
    % bounds.
    if(q == 0)
        Q = I;
    else 
        extrema = floor(q*length(I)/100);
        Q = I(extrema:(length(I) - extrema));
    end
    
    % Select top p% of intensity values to display from extrema-removed
    % intensity value set, Q.
    maxima = floor(p*length(Q)/100);
    F = Q(1:maxima);  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                       AVERAGE SELECTED SPECTRA                      %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    % Display folder processing status.
    disp(['--> Processing: /blc_', num2str(ee), ' folder']);
    
    % Average these files using a pre-defined function.
    if(strcmp(so, 'SM') || strcmp(so, 'NM'))
        
        % Define the directory, where the individual spectral folders reside.
        SDI = [DAT, '\individual_files\azido'];
        
    else        
        % Define the directory, where the individual spectral folders reside.
        SDI = [DAT, '\individual_files\plasmon-phonon'];
    end        

    % Change to directory where the raw spectral files reside.
    cd([SDI, ['/blc_', num2str(ee)]]);        
    
    % Copy all marked files into averaging directory.
    a = [SDI, ['/ave_', num2str(ee)]];
    
    % Move files to appropiate directories.
    if exist(a, 'dir') == 0
        mkdir(a);
    end
    
    for P = 1:length(F)       
        fn = [char(F(P)) '_spectra-B.txt'];
        copyfile(fn, a);
    end
    
    % Change to averaging direcory.
    cd(a);
    
    % Average these files using a pre-defined function.
    if(strcmp(so, 'SM') || strcmp(so, 'NM'))
        raman_averager([1570 2550]);
    else 
        raman_averager([150 1370]);
    end
    
end
    
% Navigate to default directory.
cd(CWD);

% Stop timer.
toc;

fprintf('\n');
disp('--> Raman spectral averager end');
fprintf('\n');
