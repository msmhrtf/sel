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


function [] = imageEdit(imageName, editMode )
%IMAGEEDIT Perform image edit on input image
%   There are three edit avaiable: scale, crop and rotate (straight) 


%%% SCALE %%%

if ( strcmpi(editMode, 'scale') )
    prompt = {'Enter image scale:'};
    dlg_title = 'Scale image';
    num_lines = 1;
    def = {'1'};
    scaleFactor = inputdlg(prompt,dlg_title,num_lines,def);
    if ( length(scaleFactor) > 0)
        scaleFactor = str2num(scaleFactor{1});
    end
    if ( isempty(scaleFactor) || ~isnumeric(scaleFactor) || scaleFactor <= 0 )
        uiwait(msgbox('Invalid scale factor. Scaling aborted', ...
                'Abort','none'));
        return;
    end
    sourceImage = imread(imageName);
    scaledImage = imresize(sourceImage, scaleFactor);
    [path, name, ext] = fileparts(imageName);
    sep = filesep;
    imwrite(scaledImage, [path sep name ext])
    uiwait(msgbox('Image scaled successfully.', ...
                    'Saved','none'));
    return;
end

%%% CROP %%%

if ( strcmpi(editMode, 'crop') )
    f = figure;
    set(f,'name','Crop image','numbertitle','off');
    sourceImage = imread(imageName);
    croppedImage = imcrop(sourceImage);
    if ( isempty(croppedImage) )
        uiwait(msgbox('Cropping aborted.', ...
        'Abort','none'));
        return;
    else
        [path, name, ext] = fileparts(imageName);
        sep = filesep;
        imwrite(croppedImage, [path sep name ext])
        uiwait(msgbox('Image cropped successfully.', ...
                        'Saved','none'));
        close;
    end
    return;
    
end



%%% ROTATE %%%

if ( strcmpi(editMode, 'rotate') )
    f = figure;
    set(f,'name','Straight','numbertitle','off');
    
    sourceImage = imread(imageName);
    image(flipdim(sourceImage,1));
    set(gca,'YDir','normal');
    truesize(f);
    
    hold on;
    
    while (true)
        line = imline();
        if ( isempty(line) )
         uiwait(msgbox('Rotating aborted.', ...
                  'Abort','none'));
            return;
        end
        
        pos = line.getPosition();

        choice = questdlg('Confirm the line?', ...
            'Confirm tracing', ...
            'Yes', 'No', 'Cancel', 'Cancel');
        switch choice
            case 'Yes'
                angle=atan2(pos(2,2)-pos(1,2),pos(2,1)-pos(1,1))*180/pi;
                if (angle < 0 )
                    angle = 180 + angle;
                end
                if ( angle < 90 )
                    % CW of angle degrees
                    rotatedImage = imrotate(sourceImage,-angle, 'bilinear');
                end
                if ( angle > 90 )
                    % CCW of 180-angle degrees
                    rotatedImage = imrotate(sourceImage,180-angle, 'bilinear');
                end
                %disp(pos);
                %disp(angle);
                [path, name, ext] = fileparts(imageName);
                sep = filesep;
                imwrite(rotatedImage, [path sep name ext])
                uiwait(msgbox('Image rotated successfully.', ...
                        'Saved','none'));
                close;
                return;
            case 'No'
                close;
                return;
            case 'Cancel'
                delete(line);
        end
    end 
    
end


%%% PIXELTOMETER %%%

if ( strcmpi(editMode, 'pixelToMeter') )
    f = figure;
    set(f,'name','Pixel to meter tool','numbertitle','off');
    
    sourceImage = imread(imageName);
    image(flipdim(sourceImage,1));
    set(gca,'YDir','normal');
    truesize(f);
    
    uiwait(msgbox('Draw a line in the picture and set its length (related to reality) in cm. Default value: 1 cm', ...
                'How to','none'));
    
    hold on;

    line = imline();
    if ( isempty(line) )
        return;
    end
    def = {'1'};
    prompt = {'Enter the length of the line (in cm):'};
    dlg_title = 'Line length';
    num_lines = 1;
    lineLength = inputdlg(prompt,dlg_title,num_lines,def);
    if ( length(lineLength) > 0)
    lineLength = str2num(lineLength{1});
    end
    if ( isempty(lineLength) || ~isnumeric(lineLength) || lineLength <= 0 )
        uiwait(msgbox('Invalid length factor. Tracing aborted', ...
            'Abort','none'));
        close();
        return;
    end
    
    
    pos = line.getPosition();

    distance = sqrt( (pos(1,1) - pos(2,1))^2 + (pos(1,2) - pos(2,2))^2 );
    %disp(distance);
    
    pixelToMeters = lineLength * 0.01 / distance; % Line length / distance gives the conversion factor from pixel to meters
    %disp(pixelToMeters);
    pixelToMetersString = sprintf('%.15f', pixelToMeters);
    uiwait(msgbox(['Pixel to meters factor set: ' pixelToMetersString],'Scale factor','none'));

%                AUTOSAVE PIXELTOMETER (WARNING RECALCULATE F0)
    cd img
    mat = strtok(imageName,'.'); %%% Warning path with '.'
    mat = strcat(mat,'.mat');
    if (exist(mat,'file'))
        pixelToMeterFactor = pixelToMeters;
        save (mat,'pixelToMeterFactor','-append')
    else
        pixelToMeterFactor = pixelToMeters;
        save (mat,'pixelToMeterFactor')
    end
    cd ..
    
    close;
    return;
    
end


%%% DISTANCES %%%
if ( strcmpi(editMode, 'distance') )
    cd img
    mat = strtok(imageName,'.');
    mat = strcat(mat,'.mat');
if (~exist(mat,'file'))
    msgbox('Please set the pixelToMeterFactor before','Missing value','warn');
    cd ..
    return
end
    load (mat)
    cd ..
    f = figure;
    set(f,'name','Distance tool','numbertitle','off');
    
    sourceImage = imread(imageName);
    image(flipdim(sourceImage,1));
    set(gca,'YDir','normal');
    truesize(f);
    
        uiwait(msgbox('Draw a line ', ...
                'How to','none'));
    
    hold on;

    line = imline();
    if ( isempty(line) )
        return;
    end
    
    pos = line.getPosition();

    distance = sqrt( (pos(1,1) - pos(2,1))^2 + (pos(1,2) - pos(2,2))^2 );
    distance = distance * pixelToMeterFactor * 100;
    disp(distance);
    
    pixelToMetersString = sprintf('%.15f', distance);
    uiwait(msgbox(['Distance of line tracked: ' pixelToMetersString ], ...
                    'Scale factor','none'));     
    close;
    return;
end


end
