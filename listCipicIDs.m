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


function output = listCipicIDs()

%LISTCIPICIDS Extract file names from cipic directory
    cd cipic;
    cipicFilenames = dir('*.mat');
    output = cell(1, size(cipicFilenames,1));
    for i = 1:size(cipicFilenames,1)
        [~, name, ~] = fileparts(cipicFilenames(i).name);
        output{1,i} = name(7:end);
    end
    cd ..;
    % Manual enumeration
    %     handles.cipicIDs = {'003', '008', '009', '010', '011', '012', '015', '017', '018', '019', ...
    %                         '020', '021', '027', '028', '033', '040', '044', '048', '050', '051', ...
    %                         '058', '059', '060', '061', '065', '119', '124', '126', '127', '131', ...
    %                         '133', '134', '135', '137', '147', '148', '152', '153', '154', '155', ...
    %                         '156', '158', '162', '163', '165', '134',
    %                         '165'};

end

