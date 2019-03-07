%  ==============================================================================
%  This file is part of the MSM-HRTF Selection application.
%                    
%               Copyright (c) 2019 by Michele Geronazzo, 
%  Department of Information Engineering, University of Padova - Italy
%                         https://dei.unipd.it
% 
%  The MSM-HRTF Selection application is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
% 
%  The MSM-HRTF Selection application is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License
%  along with this software.  If not, see <https://www.gnu.org/licenses/>.
% 
%  If you use MSM-HRTF Selection:
%  - Provide credits:
%    "MSM-HRTF Selection, M. Geronazzo, DEI, UNIPD (https://github.com/msmhrtf/sel)"
%  - In your publication, do not forget to cite this article:
%    M. Geronazzo, E. Peruch, F. Prandoni, and F. Avanzini, 
%    “Applying a single-notch metric to image-guided head-related transfer function selection 
%    for improved vertical localization,” Journal of the Audio Engineering Society, 2019.
% 
%  Authors: Alberto Bedin, Enrico Peruch, Fabio Prandoni and Michele Geronazzo
% ==============================================================================



results = zeros(0,22);

load('summaryID.mat');

for i = 1:18
    
    load(['./results/' num2str(summaryID(i,2)) '/data.mat']);
    currentID = summaryID(i,1);
    
    temp = zeros(300,22);
    temp(:,1) = ones(300,1).*summaryID(i,1);
    temp(:,2) = ones(300,1).*currentID;
    
    % C1 neg
    indexRank = avgMismatch_C1_neg(:,4) == currentID;
    indexMatrix = avgMismatch_C1_neg(indexRank,3);
    temp(:,3) = mismatchMatrix_C1_neg(:,indexMatrix);
    temp(:,4) = rankMatrix_C1_neg(:,indexMatrix);

    % C1 pos
    indexRank = avgMismatch_C1_pos(:,4) == currentID;
    indexMatrix = avgMismatch_C1_pos(indexRank,3);
    temp(:,5) = mismatchMatrix_C1_pos(:,indexMatrix);
    temp(:,6) = rankMatrix_C1_pos(:,indexMatrix);

    % C2 neg
    indexRank = avgMismatch_C2_neg(:,4) == currentID;
    indexMatrix = avgMismatch_C2_neg(indexRank,3);
    temp(:,7) = mismatchMatrix_C2_neg(:,indexMatrix);
    temp(:,8) = rankMatrix_C2_neg(:,indexMatrix);

    % C2 pos
    indexRank = avgMismatch_C2_pos(:,4) == currentID;
    indexMatrix = avgMismatch_C2_pos(indexRank,3);
    temp(:,9) = mismatchMatrix_C2_pos(:,indexMatrix);
    temp(:,10) = rankMatrix_C2_pos(:,indexMatrix);

    % C3 neg
    indexRank = avgMismatch_C3_neg(:,4) == currentID;
    indexMatrix = avgMismatch_C3_neg(indexRank,3);
    temp(:,11) = mismatchMatrix_C3_neg(:,indexMatrix);
    temp(:,12) = rankMatrix_C3_neg(:,indexMatrix);

    % C3 pos
    indexRank = avgMismatch_C3_pos(:,4) == currentID;
    indexMatrix = avgMismatch_C3_pos(indexRank,3);
    temp(:,13) = mismatchMatrix_C3_pos(:,indexMatrix);
    temp(:,14) = rankMatrix_C3_pos(:,indexMatrix);

    % Equal W neg
    indexRank = weightedAvgMismatch_icassp_neg(:,4) == currentID;
    indexMatrix = weightedAvgMismatch_icassp_neg(indexRank,3);
    temp(:,15) = weightedMismatchMatrix_icassp_neg(:,indexMatrix);
    temp(:,16) = weightedRankMatrix_icassp_neg(:,indexMatrix);

    % Equal W pos
    indexRank = weightedAvgMismatch_icassp_pos(:,4) == currentID;
    indexMatrix = weightedAvgMismatch_icassp_pos(indexRank,3);
    temp(:,17) = weightedMismatchMatrix_icassp_pos(:,indexMatrix);
    temp(:,18) = weightedRankMatrix_icassp_pos(:,indexMatrix);

    % Optimum W neg
    indexRank = weightedAvgMismatch_opt_neg(:,4) == currentID;
    indexMatrix = weightedAvgMismatch_opt_neg(indexRank,3);
    temp(:,19) = weightedMismatchMatrix_opt_neg(:,indexMatrix);
    temp(:,20) = weightedRankMatrix_opt_neg(:,indexMatrix);

    % Optimum W pos
    indexRank = weightedAvgMismatch_opt_pos(:,4) == currentID;
    indexMatrix = weightedAvgMismatch_opt_pos(indexRank,3);
    temp(:,21) = weightedMismatchMatrix_opt_pos(:,indexMatrix);
    temp(:,22) = weightedRankMatrix_opt_pos(:,indexMatrix);
    
    results = vertcat(results,temp);
end