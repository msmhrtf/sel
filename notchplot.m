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


handles.cipicIDs = listCipicIDs();
handles.numCipicSubjects = size(handles.cipicIDs,2);

for idNum = 1:handles.numCipicSubjects
    cd cipic
    load(['tracks' handles.cipicIDs{idNum} '.mat'], 'NotchFreq')
    cd ..
    notch = zeros(1,17);
    NotchFreq(NotchFreq==0) = NaN;
    for x = 1:17
        notch(1,x) = NotchFreq(2,x);
    end
    fig = figure('Visible','off');
    plot(notch,'-*');
    axis([0 18 0 15000])
    cd notchgraph
    print(fig,'-dpdf',[handles.cipicIDs{idNum} '.pdf'])
    cd ..
end
clear