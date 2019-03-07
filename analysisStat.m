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
%  Authors: Alberto Bedin, Michele Geronazzo, Fabio Prandoni and Enrico Peruch
% ==============================================================================



load('summaryID.mat');
load('modelID.mat');
load('./analysis/exp_result_all_u2.mat');
pes = exp_result.pes;

kemar = 37;

stat = zeros(0,18);

for i = 1:18
    
    load(['./results/' num2str(summaryID(i,2)) '/data.mat']);
    temp = zeros(1,8);
    temp(1) = summaryID(i,1);
    ind = summaryID(i,3);
    indExp = summaryID(i,4);
    
    % C1 neg
    temp(2) = 1;
    
    best = avgMismatch_C1_neg(1,3);
    temp(5) = avgMismatch_C1_neg(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(mismatchMatrix_C1_neg(:,ind),mismatchMatrix_C1_neg(:,best));
    temp(7) = p;
    [~,p] = ttest(mismatchMatrix_C1_neg(:,ind),mismatchMatrix_C1_neg(:,kemar));
    temp(8) = p;
    
    best = avgRank_C1_neg(1,3);
    temp(9) = avgRank_C1_neg(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(rankMatrix_C1_neg(:,ind),rankMatrix_C1_neg(:,best));
    temp(11) = p;
    [~,p] = ttest(rankMatrix_C1_neg(:,ind),rankMatrix_C1_neg(:,kemar));
    temp(12) = p;
    
    best = numOccurrence_C1_neg(1,2);
    temp(13) = numOccurrence_C1_neg(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    numOccurrence_C1_neg = sortrows(numOccurrence_C1_neg,2);
    temp(15) = numOccurrence_C1_neg(ind,1);
    temp(16) = numOccurrence_C1_neg(kemar,1);
    
    avgRank_C1_neg = sortrows(avgRank_C1_neg,3);
    temp(3) = avgRank_C1_neg(ind,1);
    temp(4) = avgRank_C1_neg(ind,2);
   
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);

    % C1 pos
    temp(2) = 2;
    
    best = avgMismatch_C1_pos(1,3);
    temp(5) = avgMismatch_C1_pos(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(mismatchMatrix_C1_pos(:,ind),mismatchMatrix_C1_pos(:,best));
    temp(7) = p;
    [~,p] = ttest(mismatchMatrix_C1_pos(:,ind),mismatchMatrix_C1_pos(:,kemar));
    temp(8) = p;
    
    best = avgRank_C1_pos(1,3);
    temp(9) = avgRank_C1_pos(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(rankMatrix_C1_pos(:,ind),rankMatrix_C1_pos(:,best));
    temp(11) = p;
    [~,p] = ttest(rankMatrix_C1_pos(:,ind),rankMatrix_C1_pos(:,kemar));
    temp(12) = p;
    
    best = numOccurrence_C1_pos(1,2);
    temp(13) = numOccurrence_C1_pos(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    numOccurrence_C1_pos = sortrows(numOccurrence_C1_pos,2);
    temp(15) = numOccurrence_C1_pos(ind,1);
    temp(16) = numOccurrence_C1_pos(kemar,1);
    
    avgRank_C1_pos = sortrows(avgRank_C1_pos,3);
    temp(3) = avgRank_C1_pos(ind,1);
    temp(4) = avgRank_C1_pos(ind,2);
   
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);
    
    % C2 neg
    temp(2) = 3;
    
    best = avgMismatch_C2_neg(1,3);
    temp(5) = avgMismatch_C2_neg(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(mismatchMatrix_C2_neg(:,ind),mismatchMatrix_C2_neg(:,best));
    temp(7) = p;
    [~,p] = ttest(mismatchMatrix_C2_neg(:,ind),mismatchMatrix_C2_neg(:,kemar));
    temp(8) = p;
    
    best = avgRank_C2_neg(1,3);
    temp(9) = avgRank_C2_neg(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(rankMatrix_C2_neg(:,ind),rankMatrix_C2_neg(:,best));
    temp(11) = p;
    [~,p] = ttest(rankMatrix_C2_neg(:,ind),rankMatrix_C2_neg(:,kemar));
    temp(12) = p;
    
    best = numOccurrence_C2_neg(1,2);
    temp(13) = numOccurrence_C2_neg(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    numOccurrence_C2_neg = sortrows(numOccurrence_C2_neg,2);
    temp(15) = numOccurrence_C2_neg(ind,1);
    temp(16) = numOccurrence_C2_neg(kemar,1);
    
    avgRank_C2_neg = sortrows(avgRank_C2_neg,3);
    temp(3) = avgRank_C2_neg(ind,1);
    temp(4) = avgRank_C2_neg(ind,2);
   
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);

    % C2 pos
    temp(2) = 4;
    
    best = avgMismatch_C2_pos(1,3);
    temp(5) = avgMismatch_C2_pos(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(mismatchMatrix_C2_pos(:,ind),mismatchMatrix_C2_pos(:,best));
    temp(7) = p;
    [~,p] = ttest(mismatchMatrix_C2_pos(:,ind),mismatchMatrix_C2_pos(:,kemar));
    temp(8) = p;
    
    best = avgRank_C2_pos(1,3);
    temp(9) = avgRank_C2_pos(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(rankMatrix_C2_pos(:,ind),rankMatrix_C2_pos(:,best));
    temp(11) = p;
    [~,p] = ttest(rankMatrix_C2_pos(:,ind),rankMatrix_C2_pos(:,kemar));
    temp(12) = p;
    
    best = numOccurrence_C2_pos(1,2);
    temp(13) = numOccurrence_C2_pos(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    numOccurrence_C2_pos = sortrows(numOccurrence_C2_pos,2);
    temp(15) = numOccurrence_C2_pos(ind,1);
    temp(16) = numOccurrence_C2_pos(kemar,1);
    
    avgRank_C2_pos = sortrows(avgRank_C2_pos,3);
    temp(3) = avgRank_C2_pos(ind,1);
    temp(4) = avgRank_C2_pos(ind,2);
   
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);

    % C3 neg
    temp(2) = 5;
    
    best = avgMismatch_C3_neg(1,3);
    temp(5) = avgMismatch_C3_neg(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(mismatchMatrix_C3_neg(:,ind),mismatchMatrix_C3_neg(:,best));
    temp(7) = p;
    [~,p] = ttest(mismatchMatrix_C3_neg(:,ind),mismatchMatrix_C3_neg(:,kemar));
    temp(8) = p;
    
    best = avgRank_C3_neg(1,3);
    temp(9) = avgRank_C3_neg(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(rankMatrix_C3_neg(:,ind),rankMatrix_C3_neg(:,best));
    temp(11) = p;
    [~,p] = ttest(rankMatrix_C3_neg(:,ind),rankMatrix_C3_neg(:,kemar));
    temp(12) = p;
    
    best = numOccurrence_C3_neg(1,2);
    temp(13) = numOccurrence_C3_neg(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    numOccurrence_C3_neg = sortrows(numOccurrence_C3_neg,2);
    temp(15) = numOccurrence_C3_neg(ind,1);
    temp(16) = numOccurrence_C3_neg(kemar,1);
    
    avgRank_C3_neg = sortrows(avgRank_C3_neg,3);
    temp(3) = avgRank_C3_neg(ind,1);
    temp(4) = avgRank_C3_neg(ind,2);
   
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);

    % C3 pos
    temp(2) = 6;
    
    best = avgMismatch_C3_pos(1,3);
    temp(5) = avgMismatch_C3_pos(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(mismatchMatrix_C3_pos(:,ind),mismatchMatrix_C3_pos(:,best));
    temp(7) = p;
    [~,p] = ttest(mismatchMatrix_C3_pos(:,ind),mismatchMatrix_C3_pos(:,kemar));
    temp(8) = p;
    
    best = avgRank_C3_pos(1,3);
    temp(9) = avgRank_C3_pos(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(rankMatrix_C3_pos(:,ind),rankMatrix_C3_pos(:,best));
    temp(11) = p;
    [~,p] = ttest(rankMatrix_C3_pos(:,ind),rankMatrix_C3_pos(:,kemar));
    temp(12) = p;
    
    best = numOccurrence_C3_pos(1,2);
    temp(13) = numOccurrence_C3_pos(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    numOccurrence_C3_pos = sortrows(numOccurrence_C3_pos,2);
    temp(15) = numOccurrence_C3_pos(ind,1);
    temp(16) = numOccurrence_C3_pos(kemar,1);
    
    avgRank_C3_pos = sortrows(avgRank_C3_pos,3);
    temp(3) = avgRank_C3_pos(ind,1);
    temp(4) = avgRank_C3_pos(ind,2);
   
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);
    
    % Equal weight neg
    temp(2) = 7;
    
    best = weightedAvgMismatch_icassp_neg(1,3);
    temp(5) = weightedAvgMismatch_icassp_neg(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(weightedMismatchMatrix_icassp_neg(:,ind),weightedMismatchMatrix_icassp_neg(:,best));
    temp(7) = p;
    [~,p] = ttest(weightedMismatchMatrix_icassp_neg(:,ind),weightedMismatchMatrix_icassp_neg(:,kemar));
    temp(8) = p;
    
    best = weightedAvgRank_icassp_neg(1,3);
    temp(9) = weightedAvgRank_icassp_neg(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(weightedRankMatrix_icassp_neg(:,ind),weightedRankMatrix_icassp_neg(:,best));
    temp(11) = p;
    [~,p] = ttest(weightedRankMatrix_icassp_neg(:,ind),weightedRankMatrix_icassp_neg(:,kemar));
    temp(12) = p;
    
    best = weightedNumOccurrence_icassp_neg(1,2);
    temp(13) = weightedNumOccurrence_icassp_neg(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    weightedNumOccurrence_icassp_neg = sortrows(weightedNumOccurrence_icassp_neg,2);
    temp(15) = weightedNumOccurrence_icassp_neg(ind,1);
    temp(16) = weightedNumOccurrence_icassp_neg(kemar,1);
    
    weightedAvgRank_icassp_neg = sortrows(weightedAvgRank_icassp_neg,3);
    temp(3) = weightedAvgRank_icassp_neg(ind,1);
    temp(4) = weightedAvgRank_icassp_neg(ind,2);
    
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);
    
    % Equal weight pos
    temp(2) = 8;
    
    best = weightedAvgMismatch_icassp_pos(1,3);
    temp(5) = weightedAvgMismatch_icassp_pos(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(weightedMismatchMatrix_icassp_pos(:,ind),weightedMismatchMatrix_icassp_pos(:,best));
    temp(7) = p;
    [~,p] = ttest(weightedMismatchMatrix_icassp_pos(:,ind),weightedMismatchMatrix_icassp_pos(:,kemar));
    temp(8) = p;
    
    best = weightedAvgRank_icassp_pos(1,3);
    temp(9) = weightedAvgRank_icassp_pos(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(weightedRankMatrix_icassp_pos(:,ind),weightedRankMatrix_icassp_pos(:,best));
    temp(11) = p;
    [~,p] = ttest(weightedRankMatrix_icassp_pos(:,ind),weightedRankMatrix_icassp_pos(:,kemar));
    temp(12) = p;
    
    best = weightedNumOccurrence_icassp_pos(1,2);
    temp(13) = weightedNumOccurrence_icassp_pos(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    weightedNumOccurrence_icassp_pos = sortrows(weightedNumOccurrence_icassp_pos,2);
    temp(15) = weightedNumOccurrence_icassp_pos(ind,1);
    temp(16) = weightedNumOccurrence_icassp_pos(kemar,1);
    
    weightedAvgRank_icassp_pos = sortrows(weightedAvgRank_icassp_pos,3);
    temp(3) = weightedAvgRank_icassp_pos(ind,1);
    temp(4) = weightedAvgRank_icassp_pos(ind,2);
    
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);
    
    % Optimum weight neg
    temp(2) = 9;
    
    best = weightedAvgMismatch_opt_neg(1,3);
    temp(5) = weightedAvgMismatch_opt_neg(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(weightedMismatchMatrix_opt_neg(:,ind),weightedMismatchMatrix_opt_neg(:,best));
    temp(7) = p;
    [~,p] = ttest(weightedMismatchMatrix_opt_neg(:,ind),weightedMismatchMatrix_opt_neg(:,kemar));
    temp(8) = p;
    
    best = weightedAvgRank_opt_neg(1,3);
    temp(9) = weightedAvgRank_opt_neg(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(weightedRankMatrix_opt_neg(:,ind),weightedRankMatrix_opt_neg(:,best));
    temp(11) = p;
    [~,p] = ttest(weightedRankMatrix_opt_neg(:,ind),weightedRankMatrix_opt_neg(:,kemar));
    temp(12) = p;
    
    best = weightedNumOccurrence_opt_neg(1,2);
    temp(13) = weightedNumOccurrence_opt_neg(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    weightedNumOccurrence_opt_neg = sortrows(weightedNumOccurrence_opt_neg,2);
    temp(15) = weightedNumOccurrence_opt_neg(ind,1);
    temp(16) = weightedNumOccurrence_opt_neg(kemar,1);
    
    weightedAvgRank_opt_neg = sortrows(weightedAvgRank_opt_neg,3);
    temp(3) = weightedAvgRank_opt_neg(ind,1);
    temp(4) = weightedAvgRank_opt_neg(ind,2);
    
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);
    
    % Optimum weight pos
    temp(2) = 10;
    
    best = weightedAvgMismatch_opt_pos(1,3);
    temp(5) = weightedAvgMismatch_opt_pos(1,4);
    temp(6) = pes(modelID(best,3),indExp);
    [~,p] = ttest(weightedMismatchMatrix_opt_pos(:,ind),weightedMismatchMatrix_opt_pos(:,best));
    temp(7) = p;
    [~,p] = ttest(weightedMismatchMatrix_opt_pos(:,ind),weightedMismatchMatrix_opt_pos(:,kemar));
    temp(8) = p;
    
    best = weightedAvgRank_opt_pos(1,3);
    temp(9) = weightedAvgRank_opt_pos(1,4);
    temp(10) = pes(modelID(best,3),indExp);
    [~,p] = ttest(weightedRankMatrix_opt_pos(:,ind),weightedRankMatrix_opt_pos(:,best));
    temp(11) = p;
    [~,p] = ttest(weightedRankMatrix_opt_pos(:,ind),weightedRankMatrix_opt_pos(:,kemar));
    temp(12) = p;
    
    best = weightedNumOccurrence_opt_pos(1,2);
    temp(13) = weightedNumOccurrence_opt_pos(1,3);
    temp(14) = pes(modelID(best,3),indExp);
    weightedNumOccurrence_opt_pos = sortrows(weightedNumOccurrence_opt_pos,2);
    temp(15) = weightedNumOccurrence_opt_pos(ind,1);
    temp(16) = weightedNumOccurrence_opt_pos(kemar,1);
    
    weightedAvgRank_opt_pos = sortrows(weightedAvgRank_opt_pos,3);
    temp(3) = weightedAvgRank_opt_pos(ind,1);
    temp(4) = weightedAvgRank_opt_pos(ind,2);
    
    temp(17) = pes(indExp,indExp);
    temp(18) = pes(modelID(kemar,3),indExp);
    
    stat = vertcat(stat,temp);
    
end

save('./analysis/stats.mat','stat');