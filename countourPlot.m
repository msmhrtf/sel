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
individual = '060';             %   CIPIC ID individuale
bestMismatch = '058';           %   CIPIC ID best mismatch
bestRank = '065';               %   CIPIC ID best rank
bestTop3 = '163';               %   CIPIC ID best top 3

imageName = [subject '.jpg'];
data = [subject '.mat'];
individualData = ['tracks' individual '.mat'];
bestMismatch = ['tracks' bestMismatch '.mat'];
bestRank = ['tracks' bestRank '.mat'];
bestTop3 = ['tracks' bestTop3 '.mat'];

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
plot(Cx_1,Cy_1,'w','LineWidth',1.5);
plot(earCanal(:,1),earCanal(:,2),'w.','MarkerSize',5);

cd notchPlot
% savefig([individual 'A.fig']);
print(f,'-depsc',[individual 'A.eps'])
cd ..
close

% Load F0
h = figure;
F0_1_neg(F0_1_neg==0) = NaN;
F0_1_pos(F0_1_pos==0) = NaN;
F0_2_neg(F0_2_neg==0) = NaN;
F0_2_pos(F0_2_pos==0) = NaN;
F0_3_neg(F0_3_neg==0) = NaN;
F0_3_pos(F0_3_pos==0) = NaN;

notchVect = zeros(17,300);
elev = (-45:5.625:45);

% % Print F0
% for i = 1:300
%     notchVect(:,i) = F0_1_neg(i,:);
% end
% plot(elev,notchVect.*0.001,'-','Color',[0.50 0.50 0.50]);
% hold on
% 
% for i = 1:300
%     notchVect(:,i) = F0_1_pos(i,:);
% end
% plot(elev,notchVect.*0.001,'-','Color',[0.75 0.75 0.75]);
% hold on

% for i = 1:300
%     notchVect(:,i) = F0_2_neg(i,:);
% end
% plot(elev,notchVect.*0.001,'-','Color',[0 0.3 1]);
% hold on
% 
% for i = 1:300
%     notchVect(:,i) = F0_2_pos(i,:);
% end
% plot(elev,notchVect.*0.001,'-','Color',[0 0.7 1]);
% hold on

for i = 1:300
    notchVect(:,i) = F0_3_neg(i,:);
end
plot(elev,notchVect.*0.001,'-','Color',[1 0 0]);
hold on

% for i = 1:300
%     notchVect(:,i) = F0_3_pos(i,:);
% end
% plot(elev,notchVect.*0.001,'-','Color',[1 0.5 0]);
% hold on

cd cipic
load(individualData);

% Print tracks notch
notch = zeros(1,17);
NotchFreq(NotchFreq==0) = NaN;
for x = 1:17
    notch(1,x) = NotchFreq(3,x);
end
plot(elev,notch.*0.001,'k-*','LineWidth',1.5);

load(bestMismatch);
notch = zeros(1,17);
NotchFreq(NotchFreq==0) = NaN;
for x = 1:17
    notch(1,x) = NotchFreq(3,x);
end
plot(elev,notch.*0.001,'k--*','LineWidth',1.5);

% load(bestRank);
% notch = zeros(1,17);
% NotchFreq(NotchFreq==0) = NaN;
% for x = 1:17
%     notch(1,x) = NotchFreq(2,x);
% end
% plot(elev,notch.*0.001,'k--*','LineWidth',1.5);

load(bestTop3);
notch = zeros(1,17);
NotchFreq(NotchFreq==0) = NaN;
for x = 1:17
    notch(1,x) = NotchFreq(3,x);
end
plot(elev,notch.*0.001,'k:*','LineWidth',1.5);
set(gca,'fontsize',15)
axis([-45 +45 3 20])
ylabel('Frequency (kHz)','Fontsize',20);
xlabel('Elevation (Deg)','Fontsize',20);
cd ..

cd notchPlot
% savefig([individual 'B.fig']);
print(h,'-depsc',[individual 'B.eps'])
cd ..
close