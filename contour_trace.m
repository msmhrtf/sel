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


% c(i,:) punto i-esimo del contorno k-esimo
% Cx contiene vettori colonna corrispondenti alle coordinate x di ogni contorno
% Cy contiene vettori colonna corrispondenti alle coordinate y di ogni contorno
% earCanal contiene vettori di punti corrispondenti alle coordinate (x,y)
% del canale uditivo
function [ ] = contour_trace(imageName, num_contours, num_canals)

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
set(f,'name','Ear tracing','numbertitle','off');

if ( num_contours > 1 )
    plural = 's';
else
    plural = '';
end

img = imread(imageName);
image(flipdim(img,1));
set(gca,'YDir','normal');
truesize(f);
hold on

% Contour tracing

Cx_1 = zeros(2000,num_contours);
Cy_1 = zeros(2000,num_contours);
Cx_2 = zeros(2000,num_contours);
Cy_2 = zeros(2000,num_contours);
Cx_3 = zeros(2000,num_contours);
Cy_3 = zeros(2000,num_contours);

%%% Contour C1 %%%
if (getappdata(0,'C1Checkbox')==1)
    trace = cell(num_contours,1);
    for k = 1:num_contours
        if(k<num_contours)
            title(['You need to draw ' int2str(num_contours-k+1) ' more ' 'line' plural ' of C1 contour']);
        else
            title('You need to draw the last line of C1 contour');
        end
        try
            trace{k} = imfreehand('Closed', false);
            if ( ~isempty(trace{k}) )
                c = trace{k}.getPosition;
                [rows,cols] = size(c);
                Cx_1(1:rows,k) = c(:,1);
                Cy_1(1:rows,k) = c(:,2);
            else
                return;
            end
        catch ME
            uiwait(msgbox('Tracing aborted.','Abort','none'));
            return;
        end
        if (getappdata(0,'showDynamic')==0) 
             delete(trace{k});
        end
    end
    for k = 1:num_contours
        delete(trace{k});
    end
    save(subject,'Cx_1','Cy_1','-append');
end

%%% C2 Contour %%%
if (getappdata(0,'C2Checkbox')==1)
    for k = 1:num_contours
        if(k<num_contours)
            title(['You need to draw ' int2str(num_contours-k+1) ' more ' 'line' plural ' of C2 contour']);
        else
            title('You need to draw the last line of C2 contour');
        end
        try
            trace{k} = imfreehand('Closed', false);
            if ( ~isempty(trace{k}) )
                c = trace{k}.getPosition;
                [rows,cols] = size(c);
                Cx_2(1:rows,k) = c(:,1);
                Cy_2(1:rows,k) = c(:,2);
            else
                return;
            end
        catch ME
            uiwait(msgbox('Tracing aborted.', ...
                        'Abort','none'));
            return;
        end
         if (getappdata(0,'showDynamic')==0) 
             delete(trace{k});
        end
    end
    for k = 1:num_contours
        delete(trace{k});
    end
    save(subject,'Cx_2','Cy_2','-append');
end


%%% C3 Contour %%%
if (getappdata(0,'C3Checkbox')==1)
    for k = 1:num_contours
        if(k<num_contours)
            title(['You need to draw ' int2str(num_contours-k+1) ' more ' 'line' plural ' of C3 contour']);
        else
            title('You need to draw the last line of C3 contour');
        end
        try
            trace{k} = imfreehand('Closed', false);
            if ( ~isempty(trace{k}) )
                c = trace{k}.getPosition;
                [rows,cols] = size(c);
                Cx_3(1:rows,k) = c(:,1);
                Cy_3(1:rows,k) = c(:,2);
            else
                return;
            end
        catch ME
            uiwait(msgbox('Tracing aborted.', ...
                        'Abort','none'));
            return;
        end
         if (getappdata(0,'showDynamic')==0) 
             delete(trace{k});
        end
    end
    for k = 1:num_contours
        delete(trace{k});
    end
    save(subject,'Cx_3','Cy_3','-append');
end

%%% Ear canal %%%
earCanal = zeros(num_canals,2);
for k = 1:num_canals
    if (k<num_canals)
        title(['You need to place ' int2str(num_canals-k+1) ' more ear canal positions']);
    else
        title(['You need to place the last ear canal position']);
    end
    try
        [xChosen,yChosen] = ginput(1);
        earCanal(k,:) = [xChosen,yChosen];
    catch ME
        uiwait(msgbox('Tracing aborted.', ...
                'Abort','none')); 
        return;
    end
end
save(subject,'earCanal','-append');

%%% Save data %%%   

uiwait(msgbox('Traces saved successfully.', ...
                    'Saved','none'));
close();

calculateF0(subject, num_contours, num_canals);

end