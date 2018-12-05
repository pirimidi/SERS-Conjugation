%--------------------------------------------------------------------------
% Author: Mirko Palla.
% Date: September 18, 2013.
%
% For: Click reaction quantification by Raman spectroscopy for nanopore 
% conjugation at the Ju Lab - Chemical Engineering Department, Columbia 
% University.
%
% Purpose: This program generates the matrix indeces based on raw, snake
% data.
%
% This software may be used, modified, and distributed freely, but this
% header may not be modified and must appear at the top of this file.
%--------------------------------------------------------------------------

function [index] = raman_index(x_steps, y_steps)

% Pre-define index holder matrix with certain size.
index = cell(x_steps * y_steps, 1);

u = 1;  % initialize main counter
for j=1:y_steps

    if mod(j,2)==1
        for k=1:x_steps   
            index{u} = [num2str(k) '-', num2str(j)];
            u = u + 1;  % update counter 
        end
    end

    if mod(j,2)==0
        for k=1:x_steps            
            index{u} = [num2str(x_steps-k+1) '-', num2str(j)];  
            u = u + 1;  % update counter 
        end        
    end
end
