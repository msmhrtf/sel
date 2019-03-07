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


k = 3;
titoli = {'C1 neg','C2 neg','C3 neg','C1 pos','C2 pos','C3 pos',...
    'Equal W neg','Equal W pos','Opt W neg','Opt W pos',...
    'External Ear','Internal Ear'};
plotsHandle = figure('Visible','off');

arrayMismatch = {avgMismatch_C1_neg,avgMismatch_C2_neg,avgMismatch_C3_neg,...
    avgMismatch_C1_pos,avgMismatch_C2_pos,avgMismatch_C3_pos,...
    weightedAvgMismatch_icassp_neg,weightedAvgMismatch_icassp_pos,...
    weightedAvgMismatch_opt_neg,weightedAvgMismatch_opt_pos};
maxMismatch = findMax(arrayMismatch,k);
pos = 1;
for i = 1:10
    if (i==1)
        etichetta = 'Avg Mismatch';
    else
        etichetta = '';
    end
    stampaBar(arrayMismatch{1,i},pos,k,maxMismatch+0.05,titoli{i},etichetta)
    pos = pos + 1;
end

arrayRank = {avgRank_C1_neg,avgRank_C2_neg,avgRank_C3_neg,...
    avgRank_C1_pos,avgRank_C2_pos,avgRank_C3_pos,...
    weightedAvgRank_icassp_neg,weightedAvgRank_icassp_pos,...
    weightedAvgRank_opt_neg,weightedAvgRank_opt_pos};
maxRank = findMax(arrayRank,k);
for i = 1:10
    if (i==1)
        etichetta = 'Avg Rank';
    else
        etichetta = '';
    end
   stampaBar(arrayRank{1,i},pos,k,maxRank+1,titoli{i},etichetta)
   pos = pos + 1;
end

arrayNumOccurrence = {numOccurrence_C1_neg,numOccurrence_C2_neg,numOccurrence_C3_neg,...
    numOccurrence_C1_pos,numOccurrence_C2_pos,numOccurrence_C3_pos,...
    weightedNumOccurrence_icassp_neg,weightedNumOccurrence_icassp_pos,...
    weightedNumOccurrence_opt_neg,weightedNumOccurrence_opt_pos};
maxOccurrence = findMax(arrayNumOccurrence,1);
for i = 1:10
    if (i==1)
        etichetta = 'M-Rank Appearance';
    else
        etichetta = '';
    end
   stampaNoBar(arrayNumOccurrence{1,i},pos,k,maxOccurrence+1,titoli{i},etichetta)
   pos = pos + 1;
end

arrayEarAnthro = {ext_D, int_D};
maxDim = findMax(arrayEarAnthro,k);
for i = 1:2
    if (i==1)
        etichetta = 'Mismatch (cm)';
    else
        etichetta = '';
    end
   stampaNoBar(arrayEarAnthro{1,i},pos,k,maxDim+0.1,titoli{i+10},etichetta)
   pos = pos + 1;
end

set(plotsHandle,'PaperOrientation','landscape');
set(plotsHandle,'PaperUnits','normalized');
set(plotsHandle,'PaperPosition', [0 0 1 1]);
print(plotsHandle,'-dpdf',['./results/' int2str(id) '/Overview.pdf']);
close

function [max] = findMax(array,k)
    max = 0;
    l = size(array);
    l = l(1,2);
    for i = 1:l
        x = array{1,i}(k,1);
        if max < x
            max = x;
        end
    end
end

function [ ] = stampaBar(var,pos,k,max,titolo,yLabel)
    subplot(4,10,pos)
    bar(var(1:k,1),'c');
    hold on
    errorbar(var(1:k,1),var(1:k,2),'.r');
    set(gca,'XTick',1:k)
    set(gca,'XTickLabel',var(1:k,4))
    set(gca,'FontSize',8)
    ylim([0 max])
    title(titolo)
    ylabel(yLabel,'FontWeight','Bold')
end

function [ ] = stampaNoBar(var,pos,k,max,titolo,yLabel)
    subplot(4,10,pos)
    bar(var(1:k,1),'c');
    hold on
    set(gca,'XTick',1:k)
    set(gca,'XTickLabel',var(1:k,3))
    set(gca,'FontSize',8)
    ylim([0 max])
    title(titolo)
    ylabel(yLabel,'FontWeight','Bold')
end