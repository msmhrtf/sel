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


function [ ] = distance_trace( imageName )

%%% Check if pixel to meter factor is set %%%
[path, name, ~] = fileparts(imageName);
sep = filesep;
subject = [path sep name '.mat'];
if (~exist(subject,'file'))
    msgbox('Please set the pixelToMeterFactor before tracing','Missing value','warn');
    return
end
load(subject);
%%%%%%%%%%%

f = figure;
set(f,'name','Distance tool','numbertitle','off');

sourceImage = imread(imageName);
image(flipdim(sourceImage,1));
set(gca,'YDir','normal');
truesize(f);

D_ext = 0;
D_int = 0;

%%% Tracking external ear height %%%
if (getappdata(0,'ExtCheckbox')==1)
    uiwait(msgbox('Draw the lenght of the external ear height','How to','none'));

    hold on;

    line = imline();
    if ( isempty(line) )
        return;
    end

    pos = line.getPosition();

    distance = sqrt( (pos(1,1) - pos(2,1))^2 + (pos(1,2) - pos(2,2))^2 );
    distance = distance * pixelToMeterFactor * 100;
    D_ext = distance;
    delete(line);
end

%%% Tracking internal ear height %%%
if (getappdata(0,'IntCheckbox')==1)
    uiwait(msgbox('Draw the lenght of the internal ear height','How to','none'));
    line = imline();
    if ( isempty(line) )
        return;
    end

    pos = line.getPosition();

    distance = sqrt( (pos(1,1) - pos(2,1))^2 + (pos(1,2) - pos(2,2))^2 );
    distance = distance * pixelToMeterFactor * 100;
    D_int = distance;
end

save(subject,'D_ext','D_int','-append');
uiwait(msgbox('Distances saved successfully.','Saved','none'));
close();

end