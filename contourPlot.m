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


subject = '0060_left';          %   nome immagine
% individual = '051';             %   CIPIC ID individuale
% bestMismatch = '152';           %   CIPIC ID best mismatch
% bestRank = '152';               %   CIPIC ID best rank
% bestTop3 = '152';               %   CIPIC ID best top 3

imageName = [subject '.jpg'];
data = [subject '.mat'];
% individualData = ['tracks' individual '.mat'];
% bestMismatch = ['tracks' bestMismatch '.mat'];
% bestRank = ['tracks' bestRank '.mat'];
% bestTop3 = ['tracks' bestTop3 '.mat'];

cd img;
load(data);
f = figure;
set(f,'name','Ear tracing','numbertitle','off');
img = imread(imageName);
image(flipdim(img,1));
set(gca,'YDir','normal');
truesize(f);
hold on
cd ..

Cx_1(Cx_1==0) = NaN;
Cy_1(Cy_1==0) = NaN;
Cx_2(Cx_2==0) = NaN;
Cy_2(Cy_2==0) = NaN;
Cx_3(Cx_3==0) = NaN;
Cy_3(Cy_3==0) = NaN;
plot(Cx_1,Cy_1,'w','LineWidth',1.5);
plot(Cx_2,Cy_2,'c','LineWidth',1.5);
plot(Cx_3,Cy_3,'r','LineWidth',1.5);
plot(earCanal(:,1),earCanal(:,2),'w.','MarkerSize',5);

cd notchPlot
% savefig([individual 'A.fig']);
print(f,'-depsc',[subject 'A.eps'])
cd ..
close