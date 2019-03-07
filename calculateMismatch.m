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


function [ mismatch ] = calculateMismatch( subject, F0, contour, printOutput )
%   CALCULATEWEIGHTEDMISMATCH Calculates the mismatch between a given F0 and
%   all NotchFreq stored in the CIPIC database.
%   You can use the printOutput variable in order to print the calculated
%   mismatch values on the Matlab Command Windows.

    % Load data from CIPIC Database and calculate mismatch values for each
    % contour
    handles.cipicIDs = listCipicIDs();
    %disp(handles.cipicIDs);
    handles.numCipicSubjects = size(handles.cipicIDs,2);
    %disp(handles.numCipicSubjects);
    mismatch = zeros(handles.numCipicSubjects,2);
    
    for idNum = 1:handles.numCipicSubjects
        cd cipic;
        load(['tracks' handles.cipicIDs{idNum} '.mat'], 'NotchFreq');
        cd ..;
        weight = 0;
        for phi = 1:17
            if ( NotchFreq(contour,phi) ~= 0 && F0(1,phi) ~= 0 )
                mismatch(idNum, 1) = mismatch(idNum, 1) + abs(NotchFreq(contour,phi) - F0(1,phi))/NotchFreq(contour,phi);
                weight = weight + 1;
            end
        end
        mismatch(idNum, 1) = mismatch(idNum, 1) / weight;
    end
    
%     Add idNum column
    mismatch(:,2) = 1:handles.numCipicSubjects;
%     Clear contour not found in cipic
%     disp(mismatch);
    mismatch = mismatch(mismatch(:,1)>0,:);
    
    if ( printOutput )
        disp(mismatch);
    end
    
    % If required, we can also print sumMismatch.
    % Here we are printing idNum, not cipidIDs, so:
    %
    % ID num | CIPIC ID    
    % 1 -> 003
    % 2 -> 008
    % 3 -> 009
    % 4 -> 010
    % 5 -> 011
    % 6 -> 012
    % 7 -> 015
    % 8 -> 017
    % 9 -> 018
    % 10 -> 019
    % 11 -> 020
    % 12 -> 021
    % 13 -> 027
    % 14 -> 028
    % 15 -> 033
    % 16 -> 040
    % 17 -> 044
    % 18 -> 048
    % 19 -> 050
    % 20 -> 051
    % 21 -> 058
    % 22 -> 059
    % 23 -> 060
    % 24 -> 061
    % 25 -> 065
    % 26 -> 119
    % 27 -> 124
    % 28 -> 126
    % 29 -> 127
    % 30 -> 131
    % 31 -> 133
    % 32 -> 134
    % 33 -> 135
    % 34 -> 137
    % 35 -> 147
    % 36 -> 148
    % 37 -> 152
    % 38 -> 153
    % 39 -> 154
    % 40 -> 155
    % 41 -> 156
    % 42 -> 158
    % 43 -> 162
    % 44 -> 163
    % 45 -> 165
    
    sortedMismatch = sortrows(mismatch);

    if ( printOutput ) 
        disp(sortedMismatch);
    end
    
%     % Plot figure with mismatches
%     plotsHandle = figure;
%     set(gcf,'PaperPositionMode','auto')
%     set(plotsHandle, 'Position', [200 200 1200 300])
%     bar(sortedSumMismatch(:,1));
%     title(['Subject ' num2str(subject) ' mismatch values ' num2str(weightOne) ' ' num2str(weightTwo) ' ' num2str(weightThree)]);
%     set(gca,'XTick',1:45)
%     handles.cipicIDs = handles.cipicIDs(sortedSumMismatch(:,2));
%     set(gca,'XTickLabel',handles.cipicIDs)
%     ylim([min(sortedSumMismatch(:,1))-min(sortedSumMismatch(:,1))/100*5, max(sortedSumMismatch(:,1))+max(sortedSumMismatch(:,1))/100*5]);
%     set(gca,'FontSize',8);
%     h=plotsHandle;
%     set(h,'PaperOrientation','landscape');
%     set(h,'PaperUnits','normalized');
%     set(h,'PaperPosition', [0 0 1 1]);
%     print(plotsHandle,'-dpdf', ['.\results\' int2str(subject) '_mismatch_' num2str(weightOne) '_' num2str(weightTwo) '_' num2str(weightThree) '.pdf']);
%     close;

end
