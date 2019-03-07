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


function [ ] = calculateF0( subject , num_contours , num_canals)
% Calculates F0 data starting from an already traced image on an existing
% .mat file, that is the input argument.
    
    load (subject)

    F0_1_pos = zeros(num_contours * num_canals,17);
    F0_1_neg = zeros(num_contours * num_canals,17);
    F0_2_pos = zeros(num_contours * num_canals,17);
    F0_2_neg = zeros(num_contours * num_canals,17);
    F0_3_pos = zeros(num_contours * num_canals,17);
    F0_3_neg = zeros(num_contours * num_canals,17);
    
    %%% F0 of C1 contour %%%
    dist = zeros(num_contours * num_canals,17);
    currentRow = 1;
    for k = 1:num_canals
        for i = 1:num_contours % cycle contours
            phiIndex = 1;
            for phi = 45:-5.625:-45 % cycle elevations
                minDiff = 360;
                j = 1;
                while ( Cx_1(j,i) ~= 0 ) % cycle points
                    angle = radtodeg( atan( (Cy_1(j,i)-earCanal(k,2)) / (Cx_1(j,i)-earCanal(k,1)) ) );
                    if ( angle >= -45 && angle <= 45 )
                        angleDiff = abs(phi - angle);
                        if (  angleDiff < 1 )
                            if ( angleDiff < minDiff )
                                xChosen = Cx_1(j,i);
                                yChosen = Cy_1(j,i);
                                minDiff = angleDiff;
                            end
                        end
                    end
                    j = j+1;
                end
                if ( minDiff ~= 360 )
                    dist(currentRow,phiIndex) = pdist([earCanal(k,1), earCanal(k,2); xChosen, yChosen]) * pixelToMeterFactor;
                    F0_1_neg(currentRow,phiIndex) = 343.2 / (2*dist(currentRow,phiIndex));
                    F0_1_pos(currentRow,phiIndex) = 343.2 / (4*dist(currentRow,phiIndex));
                else
                    dist(currentRow,phiIndex) = 0;
                    F0_1_neg(currentRow,phiIndex) = 0;
                    F0_1_pos(currentRow,phiIndex) = 0;
                end
                phiIndex = phiIndex + 1;
            end
            currentRow = currentRow + 1;
        end
    end

    %%% F0 of C2 contour %%%
    dist = zeros(num_contours * num_canals,17);
    currentRow = 1;
    for k = 1:num_canals
        for i = 1:num_contours % cycle contours
            phiIndex = 1;
            for phi = 45:-5.625:-45 % cycle elevations
                minDiff = 360;
                j = 1;
                while ( Cx_2(j,i) ~= 0 ) % cycle points
                    angle = radtodeg( atan( (Cy_2(j,i)-earCanal(k,2)) / (Cx_2(j,i)-earCanal(k,1)) ) );
                    if ( angle >= -45 && angle <= 45 )
                        angleDiff = abs(phi - angle);
                        if (  angleDiff < 1 )
                            if ( angleDiff < minDiff )
                                xChosen = Cx_2(j,i);
                                yChosen = Cy_2(j,i);
                                minDiff = angleDiff;
                            end
                        end
                    end
                    j = j+1;
                end
                if ( minDiff ~= 360 )
                    dist(currentRow,phiIndex) = pdist([earCanal(k,1), earCanal(k,2); xChosen, yChosen]) * pixelToMeterFactor;
                    F0_2_neg(currentRow,phiIndex) = 343.2 / (2*dist(currentRow,phiIndex));
                    F0_2_pos(currentRow,phiIndex) = 343.2 / (4*dist(currentRow,phiIndex));
                else
                    dist(currentRow,phiIndex) = 0;
                    F0_2_neg(currentRow,phiIndex) = 0;
                    F0_2_pos(currentRow,phiIndex) = 0;
                end
                phiIndex = phiIndex + 1;
            end
            currentRow = currentRow + 1;
        end
    end

    %%% F0 of C3 contour %%%
    dist = zeros(num_contours * num_canals,17);
    currentRow = 1;
    for k = 1:num_canals
        for i = 1:num_contours % cycle contours
            phiIndex = 1;
            for phi = 45:-5.625:-45 % cycle elevations
                minDiff = 360;
                j = 1;
                while ( Cx_3(j,i) ~= 0 ) % cycle points
                    angle = radtodeg( atan( (Cy_3(j,i)-earCanal(k,2)) / (Cx_3(j,i)-earCanal(k,1)) ) );
                    if ( angle >= -45 && angle <= 45 )
                        angleDiff = abs(phi - angle);
                        if (  angleDiff < 1 )
                            if ( angleDiff < minDiff )
                                xChosen = Cx_3(j,i);
                                yChosen = Cy_3(j,i);
                                minDiff = angleDiff;
                            end
                        end
                    end
                    j = j+1;
                end
                if ( minDiff ~= 360 )
                    dist(currentRow,phiIndex) = pdist([earCanal(k,1), earCanal(k,2); xChosen, yChosen]) * pixelToMeterFactor;
                    F0_3_neg(currentRow,phiIndex) = 343.2 / (2*dist(currentRow,phiIndex));
                    F0_3_pos(currentRow,phiIndex) = 343.2 / (4*dist(currentRow,phiIndex));
                else
                    dist(currentRow,phiIndex) = 0;
                    F0_3_neg(currentRow,phiIndex) = 0;
                    F0_3_pos(currentRow,phiIndex) = 0;
                end
                phiIndex = phiIndex + 1;
            end
            currentRow = currentRow + 1;
        end
    end

    %%% Save F0 %%%
    save(subject,'F0_1_pos','F0_1_neg','F0_2_pos','F0_2_neg','F0_3_pos','F0_3_neg','-append');
    uiwait(msgbox('F0 saved successfully.', ...
                        'Saved','none'));

    clear;

end

