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


    % Enable PureData (debug purpose)
    experimentConfigHandler = getappdata(0,'experimentConfigHandler');
    handles.pureData = getappdata(experimentConfigHandler,'enablePureData');
    
    % Import shared data (current subject ID)
    subjectsHandler = getappdata(0,'subjectsHandler');
    id = getappdata(subjectsHandler,'sharedID');
    
    % Load subject list and extract data
    subjectsStruct = load('subjects');
    subjects = subjectsStruct.subjects;
    handles.subjects = subjects;
    
    if ( isempty(subjects(:,1)) )
        disp('Database empty. Abort.');
        close();
    end
    
    numOfRecords = length(subjects(:,1));
    for i = 1:numOfRecords
        if ( subjects{i,6} == id )
            lastName = subjects{i,1};
            firstName = subjects{i,2};
            gender = subjects{i,3};
            age = subjects{i,4};
            [~, earDataFile, ~] = fileparts(subjects{i,5});
            earDataFile = [earDataFile '.mat'];
            cd img;
            earDataFile = load(earDataFile);
            cd ..;
%             disp(earDataFile);
            break;
        end
    end

    % Extract stored values from ear trace.
    if (isfield(earDataFile,'F0_1_pos'))
        F0_1_pos = earDataFile.F0_1_pos;
        F0_1_neg = earDataFile.F0_1_neg;
        F0_2_pos = earDataFile.F0_2_pos;
        F0_2_neg = earDataFile.F0_2_neg;
        F0_3_pos = earDataFile.F0_3_pos;
        F0_3_neg = earDataFile.F0_3_neg;
    else
        F0_1_pos = 0;
        F0_1_neg = 0;
        F0_2_pos = 0;
        F0_2_neg = 0;
        F0_3_pos = 0;
        F0_3_neg = 0;
    end
    
    if (isfield(earDataFile,'D_ext'))
        D_ext = earDataFile.D_ext;
        D_int = earDataFile.D_int;
    else
        D_ext = 0;
        D_int = 0;
    end
    
    % Missing data control
    if (getappdata(0,'C1Checkbox')==1 && any(F0_1_neg(:))==0)
        msgbox('Please uncheck the C1 contour or track it!','Missing value','warn');
        return
    end
    
    if (getappdata(0,'C2Checkbox')==1 && any(F0_2_neg(:))==0)
        msgbox('Please uncheck the C2 contour or track it!','Missing value','warn');
        return
    end
    
    if (getappdata(0,'C3Checkbox')==1 && any(F0_3_neg(:))==0)
        msgbox('Please uncheck the C3 contour or track it!','Missing value','warn');
        return
    end
    
    if (getappdata(0,'ExtCheckbox')==1 && D_ext==0)
        msgbox('Please uncheck the External ear length or track it!','Missing value','warn');
        return
    end
    
    if (getappdata(0,'IntCheckbox')==1 && D_int==0)
        msgbox('Please uncheck the Internal ear length or track it!','Missing value','warn');
        return
    end    
    
    
    % Load data from CIPIC Database and calculate mismatch values
    handles.cipicIDs = listCipicIDs();
    handles.numCipicSubjects = size(handles.cipicIDs,2);

    waitb = waitbar(0,'HRTF Selection: in progress');
    
    cd results
    if ( ~exist ((int2str(id)), 'dir'))
        mkdir(int2str(id))
    end
    cd ..
    created = true;
    save(['./results/' int2str(id) '/data.mat'],'created');
    
%     C1 POSITIVE REFLECTION
if (getappdata(0,'C1Checkbox')==1)
%     Create mismatchMatrix: rows are the experiment, columns are CIPIC ids
%     Cells are mismatch values for each CIPIC
    numOfTests = size(F0_1_pos,1);
    mismatchMatrix_C1_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        mismatch = calculateMismatch(id, F0_1_pos(i,:), 1, 0);
        mismatchMatrix_C1_pos(i,:) = mismatch(:,1);
    end
    waitbar(1/12);
    cd results
    if ( ~exist ((int2str(id)), 'dir'))
        mkdir(int2str(id))
    end
    cd ..
    save(['./results/' int2str(id) '/data.mat'],'mismatchMatrix_C1_pos','-append');
    
%     Create rankMatrix: rows are the experiments, columns are CIPIC ids
%     Cells are the rank values based on crescent mismatch
%     (e.g. rank 1 is the lower mismatch)
    rankMatrix_C1_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = mismatchMatrix_C1_pos(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            rankMatrix_C1_pos(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'rankMatrix_C1_pos','-append');
    
%     Create occurrenceMatrix: rows are the experiments, columns are CIPIC ids
%     A cell is 1 if it is in the k-top rank, 0 otherwise
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    occurrenceMatrix_C1_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (rankMatrix_C1_pos(i,k) <= maxRank)
              occurrenceMatrix_C1_pos(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'occurrenceMatrix_C1_pos','-append');

%     Average and stddev mismatch values for each CIPIC
    avgMismatch_C1_pos = zeros(handles.numCipicSubjects,4);
    avgMismatch_C1_pos(:,1) = mean(mismatchMatrix_C1_pos);
    avgMismatch_C1_pos(:,2) = std(mismatchMatrix_C1_pos);
    avgMismatch_C1_pos(:,3) = (1:1:handles.numCipicSubjects); 
    avgMismatch_C1_pos = sortrows(avgMismatch_C1_pos);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        avgMismatch_C1_pos(i,4) = str2double(cipicID{avgMismatch_C1_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgMismatch_C1_pos','-append');
    
%     Average and stddev rank values for each CIPIC
    avgRank_C1_pos = zeros(handles.numCipicSubjects,4);
    avgRank_C1_pos(:,1) = mean(rankMatrix_C1_pos);
    avgRank_C1_pos(:,2) = std(rankMatrix_C1_pos);
    avgRank_C1_pos(:,3) = (1:1:handles.numCipicSubjects);
    avgRank_C1_pos = sortrows(avgRank_C1_pos);
    for i = 1:handles.numCipicSubjects
        avgRank_C1_pos(i,4) = str2double(cipicID{avgRank_C1_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgRank_C1_pos','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    numOccurrence_C1_pos = zeros(handles.numCipicSubjects,3);
    numOccurrence_C1_pos(:,1) = sum(occurrenceMatrix_C1_pos);
    numOccurrence_C1_pos(:,2) = (1:1:handles.numCipicSubjects);
    numOccurrence_C1_pos = sortrows(numOccurrence_C1_pos,-1);
    for i = 1:handles.numCipicSubjects
        numOccurrence_C1_pos(i,3) = str2double(cipicID{numOccurrence_C1_pos(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'numOccurrence_C1_pos','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgMismatch_C1_pos(:,1),'c');
        hold on
        errorbar(avgMismatch_C1_pos(:,1),avgMismatch_C1_pos(:,2),'.r');
        title('Average mismatch for CIPIC ID for C1 track positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgMismatch_C1_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgMismatch_C1_pos.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgRank_C1_pos(:,1),'c');
        hold on
        errorbar(avgRank_C1_pos(:,1),avgRank_C1_pos(:,2),'.r');
        title('Average Rank for CIPIC ID for C1 track positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgRank_C1_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgRank_C1_pos.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(numOccurrence_C1_pos(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for C1 track positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',numOccurrence_C1_pos(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/MRankAppearance_C1_pos.pdf']);
        close
    end
   
%     C1 NEGATIVE REFLECTION
%     Create mismatchMatrix: rows are the experiment, columns are CIPIC ids
%     Cells are mismatch values for each CIPIC
    numOfTests = size(F0_1_neg,1);
    mismatchMatrix_C1_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        mismatch = calculateMismatch(id, F0_1_neg(i,:), 1, 0);
        mismatchMatrix_C1_neg(i,:) = mismatch(:,1);
    end
    waitbar(2/12);
    save(['./results/' int2str(id) '/data.mat'],'mismatchMatrix_C1_neg','-append');
    
%     Create rankMatrix: rows are the experiments, columns are CIPIC ids
%     Cells are the rank values based on crescent mismatch
%     (e.g. rank 1 is the lower mismatch)
    rankMatrix_C1_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = mismatchMatrix_C1_neg(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            rankMatrix_C1_neg(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'rankMatrix_C1_neg','-append');
    
%     Create occurrenceMatrix: rows are the experiments, columns are CIPIC ids
%     A cell is 1 if it is in the k-top rank, 0 otherwise
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    occurrenceMatrix_C1_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (rankMatrix_C1_neg(i,k) <= maxRank)
              occurrenceMatrix_C1_neg(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'occurrenceMatrix_C1_neg','-append');

%     Average and stddev mismatch values for each CIPIC
    avgMismatch_C1_neg = zeros(handles.numCipicSubjects,4);
    avgMismatch_C1_neg(:,1) = mean(mismatchMatrix_C1_neg);
    avgMismatch_C1_neg(:,2) = std(mismatchMatrix_C1_neg);
    avgMismatch_C1_neg(:,3) = (1:1:handles.numCipicSubjects); 
    avgMismatch_C1_neg = sortrows(avgMismatch_C1_neg);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        avgMismatch_C1_neg(i,4) = str2double(cipicID{avgMismatch_C1_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgMismatch_C1_neg','-append');
    
%     Average and stddev rank values for each CIPIC
    avgRank_C1_neg = zeros(handles.numCipicSubjects,4);
    avgRank_C1_neg(:,1) = mean(rankMatrix_C1_neg);
    avgRank_C1_neg(:,2) = std(rankMatrix_C1_neg);
    avgRank_C1_neg(:,3) = (1:1:handles.numCipicSubjects);
    avgRank_C1_neg = sortrows(avgRank_C1_neg);
    for i = 1:handles.numCipicSubjects
        avgRank_C1_neg(i,4) = str2double(cipicID{avgRank_C1_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgRank_C1_neg','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    numOccurrence_C1_neg = zeros(handles.numCipicSubjects,3);
    numOccurrence_C1_neg(:,1) = sum(occurrenceMatrix_C1_neg);
    numOccurrence_C1_neg(:,2) = (1:1:handles.numCipicSubjects);
    numOccurrence_C1_neg = sortrows(numOccurrence_C1_neg,-1);
    for i = 1:handles.numCipicSubjects
        numOccurrence_C1_neg(i,3) = str2double(cipicID{numOccurrence_C1_neg(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'numOccurrence_C1_neg','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
    delete(h);
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgMismatch_C1_neg(:,1),'c');
        hold on
        errorbar(avgMismatch_C1_neg(:,1),avgMismatch_C1_neg(:,2),'.r');
        title('Average mismatch for CIPIC ID for C1 track negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgMismatch_C1_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgMismatch_C1_neg.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgRank_C1_neg(:,1),'c');
        hold on
        errorbar(avgRank_C1_neg(:,1),avgRank_C1_neg(:,2),'.r');
        title('Average Rank for CIPIC ID for C1 track negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgRank_C1_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgRank_C1_neg.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(numOccurrence_C1_neg(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for C1 track negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',numOccurrence_C1_neg(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/MRankAppearance_C1_neg.pdf']);
        close
    end
 end
%     C2 POSITIVE REFLECTION
if (getappdata(0,'C2Checkbox')==1)
%     Create mismatchMatrix: rows are the experiment, columns are CIPIC ids
%     Cells are mismatch values for each CIPIC
    numOfTests = size(F0_2_pos,1);
    mismatchMatrix_C2_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        mismatch = calculateMismatch(id, F0_2_pos(i,:), 2, 0);
        mismatchMatrix_C2_pos(i,:) = mismatch(:,1);
    end
    waitbar(3/12);
    cd results
    if ( ~exist ((int2str(id)), 'dir'))
        mkdir(int2str(id))
    end
    cd ..
    save(['./results/' int2str(id) '/data.mat'],'mismatchMatrix_C2_pos','-append');
    
%     Create rankMatrix: rows are the experiments, columns are CIPIC ids
%     Cells are the rank values based on crescent mismatch
%     (e.g. rank 1 is the lower mismatch)
    rankMatrix_C2_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = mismatchMatrix_C2_pos(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            rankMatrix_C2_pos(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'rankMatrix_C2_pos','-append');
    
%     Create occurrenceMatrix: rows are the experiments, columns are CIPIC ids
%     A cell is 1 if it is in the k-top rank, 0 otherwise
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    occurrenceMatrix_C2_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (rankMatrix_C2_pos(i,k) <= maxRank)
              occurrenceMatrix_C2_pos(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'occurrenceMatrix_C2_pos','-append');

%     Average and stddev mismatch values for each CIPIC
    avgMismatch_C2_pos = zeros(handles.numCipicSubjects,4);
    avgMismatch_C2_pos(:,1) = mean(mismatchMatrix_C2_pos);
    avgMismatch_C2_pos(:,2) = std(mismatchMatrix_C2_pos);
    avgMismatch_C2_pos(:,3) = (1:1:handles.numCipicSubjects); 
    avgMismatch_C2_pos = sortrows(avgMismatch_C2_pos);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        avgMismatch_C2_pos(i,4) = str2double(cipicID{avgMismatch_C2_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgMismatch_C2_pos','-append');
    
%     Average and stddev rank values for each CIPIC
    avgRank_C2_pos = zeros(handles.numCipicSubjects,4);
    avgRank_C2_pos(:,1) = mean(rankMatrix_C2_pos);
    avgRank_C2_pos(:,2) = std(rankMatrix_C2_pos);
    avgRank_C2_pos(:,3) = (1:1:handles.numCipicSubjects);
    avgRank_C2_pos = sortrows(avgRank_C2_pos);
    for i = 1:handles.numCipicSubjects
        avgRank_C2_pos(i,4) = str2double(cipicID{avgRank_C2_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgRank_C2_pos','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    numOccurrence_C2_pos = zeros(handles.numCipicSubjects,3);
    numOccurrence_C2_pos(:,1) = sum(occurrenceMatrix_C2_pos);
    numOccurrence_C2_pos(:,2) = (1:1:handles.numCipicSubjects);
    numOccurrence_C2_pos = sortrows(numOccurrence_C2_pos,-1);
    for i = 1:handles.numCipicSubjects
        numOccurrence_C2_pos(i,3) = str2double(cipicID{numOccurrence_C2_pos(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'numOccurrence_C2_pos','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgMismatch_C2_pos(:,1),'c');
        hold on
        errorbar(avgMismatch_C2_pos(:,1),avgMismatch_C2_pos(:,2),'.r');
        title('Average mismatch for CIPIC ID for C2 track positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgMismatch_C2_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgMismatch_C2_pos.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgRank_C2_pos(:,1),'c');
        hold on
        errorbar(avgRank_C2_pos(:,1),avgRank_C2_pos(:,2),'.r');
        title('Average Rank for CIPIC ID for C2 track positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgRank_C2_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgRank_C2_pos.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(numOccurrence_C2_pos(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for C2 track positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',numOccurrence_C2_pos(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/MRankAppearance_C2_pos.pdf']);
        close
    end
    
%     C2 NEGATIVE REFLECTION
%     Create mismatchMatrix: rows are the experiment, columns are CIPIC ids
%     Cells are mismatch values for each CIPIC
    numOfTests = size(F0_2_neg,1);
    mismatchMatrix_C2_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        mismatch = calculateMismatch(id, F0_2_neg(i,:), 2, 0);
        mismatchMatrix_C2_neg(i,:) = mismatch(:,1);
    end
    waitbar(4/12);
    save(['./results/' int2str(id) '/data.mat'],'mismatchMatrix_C2_neg','-append');
    
%     Create rankMatrix: rows are the experiments, columns are CIPIC ids
%     Cells are the rank values based on crescent mismatch
%     (e.g. rank 1 is the lower mismatch)
    rankMatrix_C2_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = mismatchMatrix_C2_neg(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            rankMatrix_C2_neg(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'rankMatrix_C2_neg','-append');
    
%     Create occurrenceMatrix: rows are the experiments, columns are CIPIC ids
%     A cell is 1 if it is in the k-top rank, 0 otherwise
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    occurrenceMatrix_C2_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (rankMatrix_C2_neg(i,k) <= maxRank)
              occurrenceMatrix_C2_neg(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'occurrenceMatrix_C2_neg','-append');

%     Average and stddev mismatch values for each CIPIC
    avgMismatch_C2_neg = zeros(handles.numCipicSubjects,4);
    avgMismatch_C2_neg(:,1) = mean(mismatchMatrix_C2_neg);
    avgMismatch_C2_neg(:,2) = std(mismatchMatrix_C2_neg);
    avgMismatch_C2_neg(:,3) = (1:1:handles.numCipicSubjects); 
    avgMismatch_C2_neg = sortrows(avgMismatch_C2_neg);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        avgMismatch_C2_neg(i,4) = str2double(cipicID{avgMismatch_C2_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgMismatch_C2_neg','-append');
    
%     Average and stddev rank values for each CIPIC
    avgRank_C2_neg = zeros(handles.numCipicSubjects,4);
    avgRank_C2_neg(:,1) = mean(rankMatrix_C2_neg);
    avgRank_C2_neg(:,2) = std(rankMatrix_C2_neg);
    avgRank_C2_neg(:,3) = (1:1:handles.numCipicSubjects);
    avgRank_C2_neg = sortrows(avgRank_C2_neg);
    for i = 1:handles.numCipicSubjects
        avgRank_C2_neg(i,4) = str2double(cipicID{avgRank_C2_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgRank_C2_neg','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    numOccurrence_C2_neg = zeros(handles.numCipicSubjects,3);
    numOccurrence_C2_neg(:,1) = sum(occurrenceMatrix_C2_neg);
    numOccurrence_C2_neg(:,2) = (1:1:handles.numCipicSubjects);
    numOccurrence_C2_neg = sortrows(numOccurrence_C2_neg,-1);
    for i = 1:handles.numCipicSubjects
        numOccurrence_C2_neg(i,3) = str2double(cipicID{numOccurrence_C2_neg(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'numOccurrence_C2_neg','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
    delete(h);
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgMismatch_C2_neg(:,1),'c');
        hold on
        errorbar(avgMismatch_C2_neg(:,1),avgMismatch_C2_neg(:,2),'.r');
        title('Average mismatch for CIPIC ID for C2 track negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgMismatch_C2_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgMismatch_C2_neg.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgRank_C2_neg(:,1),'c');
        hold on
        errorbar(avgRank_C2_neg(:,1),avgRank_C2_neg(:,2),'.r');
        title('Average Rank for CIPIC ID for C2 track negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgRank_C2_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgRank_C2_neg.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(numOccurrence_C2_neg(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for C2 track negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',numOccurrence_C2_neg(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/MRankAppearance_C2_neg.pdf']);
        close
    end
end

%     C3 POSITIVE REFLECTION
if (getappdata(0,'C3Checkbox')==1)
%     Create mismatchMatrix: rows are the experiment, columns are CIPIC ids
%     Cells are mismatch values for each CIPIC
    numOfTests = size(F0_3_pos,1);
    mismatchMatrix_C3_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        mismatch = calculateMismatch(id, F0_3_pos(i,:), 3, 0);
        mismatchMatrix_C3_pos(i,:) = mismatch(:,1);
    end
    waitbar(5/12);
    cd results
    if ( ~exist ((int2str(id)), 'dir'))
        mkdir(int2str(id))
    end
    cd ..
    save(['./results/' int2str(id) '/data.mat'],'mismatchMatrix_C3_pos','-append');
    
%     Create rankMatrix: rows are the experiments, columns are CIPIC ids
%     Cells are the rank values based on crescent mismatch
%     (e.g. rank 1 is the lower mismatch)
    rankMatrix_C3_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = mismatchMatrix_C3_pos(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            rankMatrix_C3_pos(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'rankMatrix_C3_pos','-append');
    
%     Create occurrenceMatrix: rows are the experiments, columns are CIPIC ids
%     A cell is 1 if it is in the k-top rank, 0 otherwise
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    occurrenceMatrix_C3_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (rankMatrix_C3_pos(i,k) <= maxRank)
              occurrenceMatrix_C3_pos(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'occurrenceMatrix_C3_pos','-append');

%     Average and stddev mismatch values for each CIPIC
    avgMismatch_C3_pos = zeros(handles.numCipicSubjects,4);
    avgMismatch_C3_pos(:,1) = mean(mismatchMatrix_C3_pos);
    avgMismatch_C3_pos(:,2) = std(mismatchMatrix_C3_pos);
    avgMismatch_C3_pos(:,3) = (1:1:handles.numCipicSubjects); 
    avgMismatch_C3_pos = sortrows(avgMismatch_C3_pos);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        avgMismatch_C3_pos(i,4) = str2double(cipicID{avgMismatch_C3_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgMismatch_C3_pos','-append');
    
%     Average and stddev rank values for each CIPIC
    avgRank_C3_pos = zeros(handles.numCipicSubjects,4);
    avgRank_C3_pos(:,1) = mean(rankMatrix_C3_pos);
    avgRank_C3_pos(:,2) = std(rankMatrix_C3_pos);
    avgRank_C3_pos(:,3) = (1:1:handles.numCipicSubjects);
    avgRank_C3_pos = sortrows(avgRank_C3_pos);
    for i = 1:handles.numCipicSubjects
        avgRank_C3_pos(i,4) = str2double(cipicID{avgRank_C3_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgRank_C3_pos','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    numOccurrence_C3_pos = zeros(handles.numCipicSubjects,3);
    numOccurrence_C3_pos(:,1) = sum(occurrenceMatrix_C3_pos);
    numOccurrence_C3_pos(:,2) = (1:1:handles.numCipicSubjects);
    numOccurrence_C3_pos = sortrows(numOccurrence_C3_pos,-1);
    for i = 1:handles.numCipicSubjects
        numOccurrence_C3_pos(i,3) = str2double(cipicID{numOccurrence_C3_pos(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'numOccurrence_C3_pos','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgMismatch_C3_pos(:,1),'c');
        hold on
        errorbar(avgMismatch_C3_pos(:,1),avgMismatch_C3_pos(:,2),'.r');
        title('Average mismatch for CIPIC ID for C3 track positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgMismatch_C3_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgMismatch_C3_pos.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgRank_C3_pos(:,1),'c');
        hold on
        errorbar(avgRank_C3_pos(:,1),avgRank_C3_pos(:,2),'.r');
        title('Average Rank for CIPIC ID for C3 track positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgRank_C3_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgRank_C3_pos.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(numOccurrence_C3_pos(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for C3 track positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',numOccurrence_C3_pos(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/MRankAppearance_C3_pos.pdf']);
        close
    end

%     C3 NEGATIVE REFLECTION

%     Create mismatchMatrix: rows are the experiment, columns are CIPIC ids
%     Cells are mismatch values for each CIPIC
    numOfTests = size(F0_3_neg,1);
    mismatchMatrix_C3_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        mismatch = calculateMismatch(id, F0_3_neg(i,:), 3, 0);
        mismatchMatrix_C3_neg(i,:) = mismatch(:,1);
    end
    waitbar(6/12);
    save(['./results/' int2str(id) '/data.mat'],'mismatchMatrix_C3_neg','-append');
    
%     Create rankMatrix: rows are the experiments, columns are CIPIC ids
%     Cells are the rank values based on crescent mismatch
%     (e.g. rank 1 is the lower mismatch)
    rankMatrix_C3_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = mismatchMatrix_C3_neg(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            rankMatrix_C3_neg(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'rankMatrix_C3_neg','-append');
    
%     Create occurrenceMatrix: rows are the experiments, columns are CIPIC ids
%     A cell is 1 if it is in the k-top rank, 0 otherwise
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    occurrenceMatrix_C3_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (rankMatrix_C3_neg(i,k) <= maxRank)
              occurrenceMatrix_C3_neg(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'occurrenceMatrix_C3_neg','-append');

%     Average and stddev mismatch values for each CIPIC
    avgMismatch_C3_neg = zeros(handles.numCipicSubjects,4);
    avgMismatch_C3_neg(:,1) = mean(mismatchMatrix_C3_neg);
    avgMismatch_C3_neg(:,2) = std(mismatchMatrix_C3_neg);
    avgMismatch_C3_neg(:,3) = (1:1:handles.numCipicSubjects); 
    avgMismatch_C3_neg = sortrows(avgMismatch_C3_neg);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        avgMismatch_C3_neg(i,4) = str2double(cipicID{avgMismatch_C3_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgMismatch_C3_neg','-append');
    
%     Average and stddev rank values for each CIPIC
    avgRank_C3_neg = zeros(handles.numCipicSubjects,4);
    avgRank_C3_neg(:,1) = mean(rankMatrix_C3_neg);
    avgRank_C3_neg(:,2) = std(rankMatrix_C3_neg);
    avgRank_C3_neg(:,3) = (1:1:handles.numCipicSubjects);
    avgRank_C3_neg = sortrows(avgRank_C3_neg);
    for i = 1:handles.numCipicSubjects
        avgRank_C3_neg(i,4) = str2double(cipicID{avgRank_C3_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'avgRank_C3_neg','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    numOccurrence_C3_neg = zeros(handles.numCipicSubjects,3);
    numOccurrence_C3_neg(:,1) = sum(occurrenceMatrix_C3_neg);
    numOccurrence_C3_neg(:,2) = (1:1:handles.numCipicSubjects);
    numOccurrence_C3_neg = sortrows(numOccurrence_C3_neg,-1);
    for i = 1:handles.numCipicSubjects
        numOccurrence_C3_neg(i,3) = str2double(cipicID{numOccurrence_C3_neg(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'numOccurrence_C3_neg','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
    delete(h);
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgMismatch_C3_neg(:,1),'c');
        hold on
        errorbar(avgMismatch_C3_neg(:,1),avgMismatch_C3_neg(:,2),'.r');
        title('Average mismatch for CIPIC ID for C3 track negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgMismatch_C3_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgMismatch_C3_neg.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(avgRank_C3_neg(:,1),'c');
        hold on
        errorbar(avgRank_C3_neg(:,1),avgRank_C3_neg(:,2),'.r');
        title('Average Rank for CIPIC ID for C3 track negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',avgRank_C3_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/AvgRank_C3_neg.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(numOccurrence_C3_neg(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for C3 track negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',numOccurrence_C3_neg(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/MRankAppearance_C3_neg.pdf']);
        close
    end
end    

if (getappdata(0,'C1Checkbox')==1 && getappdata(0,'C2Checkbox')==1 && getappdata(0,'C3Checkbox')==1)
%     Weight (1/3,1/3,1/3)

    weightedMismatchMatrix_icassp_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for j = 1:handles.numCipicSubjects
          weightedMismatchMatrix_icassp_neg(i,j) = ...
          1/3 * mismatchMatrix_C1_neg(i,j) + ...
          1/3 * mismatchMatrix_C2_neg(i,j) + ...
          1/3 * mismatchMatrix_C3_neg(i,j) ; 
       end
    end
    waitbar(7/12);
    save(['./results/' int2str(id) '/data.mat'],'weightedMismatchMatrix_icassp_neg','-append');
    
    weightedRankMatrix_icassp_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = weightedMismatchMatrix_icassp_neg(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            weightedRankMatrix_icassp_neg(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedRankMatrix_icassp_neg','-append');
    
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    weightedOccurenceMatrix_icassp_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (weightedRankMatrix_icassp_neg(i,k) <= maxRank)
              weightedOccurenceMatrix_icassp_neg(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedOccurenceMatrix_icassp_neg','-append');
    
    %     Average and stddev mismatch values for each CIPIC
    weightedAvgMismatch_icassp_neg = zeros(handles.numCipicSubjects,4);
    weightedAvgMismatch_icassp_neg(:,1) = mean(weightedMismatchMatrix_icassp_neg);
    weightedAvgMismatch_icassp_neg(:,2) = std(weightedMismatchMatrix_icassp_neg);
    weightedAvgMismatch_icassp_neg(:,3) = (1:1:handles.numCipicSubjects); 
    weightedAvgMismatch_icassp_neg = sortrows(weightedAvgMismatch_icassp_neg);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        weightedAvgMismatch_icassp_neg(i,4) = str2double(cipicID{weightedAvgMismatch_icassp_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedAvgMismatch_icassp_neg','-append');
    
%     Average and stddev rank values for each CIPIC
    weightedAvgRank_icassp_neg = zeros(handles.numCipicSubjects,4);
    weightedAvgRank_icassp_neg(:,1) = mean(weightedRankMatrix_icassp_neg);
    weightedAvgRank_icassp_neg(:,2) = std(weightedRankMatrix_icassp_neg);
    weightedAvgRank_icassp_neg(:,3) = (1:1:handles.numCipicSubjects);
    weightedAvgRank_icassp_neg = sortrows(weightedAvgRank_icassp_neg);
    for i = 1:handles.numCipicSubjects
        weightedAvgRank_icassp_neg(i,4) = str2double(cipicID{weightedAvgRank_icassp_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedAvgRank_icassp_neg','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    weightedNumOccurrence_icassp_neg = zeros(handles.numCipicSubjects,3);
    weightedNumOccurrence_icassp_neg(:,1) = sum(weightedOccurenceMatrix_icassp_neg);
    weightedNumOccurrence_icassp_neg(:,2) = (1:1:handles.numCipicSubjects);
    weightedNumOccurrence_icassp_neg = sortrows(weightedNumOccurrence_icassp_neg,-1);
    for i = 1:handles.numCipicSubjects
        weightedNumOccurrence_icassp_neg(i,3) = str2double(cipicID{weightedNumOccurrence_icassp_neg(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedNumOccurrence_icassp_neg','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
    delete(h);
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedAvgMismatch_icassp_neg(:,1),'c');
        hold on
        errorbar(weightedAvgMismatch_icassp_neg(:,1),weightedAvgMismatch_icassp_neg(:,2),'.r');
        title('Average mismatch for CIPIC ID for weighted (0.33,0.33,0.33) tracks negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedAvgMismatch_icassp_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedAvgMismatch_icassp_neg.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedAvgRank_icassp_neg(:,1),'c');
        hold on
        errorbar(weightedAvgRank_icassp_neg(:,1),weightedAvgRank_icassp_neg(:,2),'.r');
        title('Average Rank for CIPIC ID for weighted (0.33,0.33,0.33) tracks negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedAvgRank_icassp_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedAvgRank_icassp_neg.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedNumOccurrence_icassp_neg(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for weighted (0.33,0.33,0.33) tracks negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedNumOccurrence_icassp_neg(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedMRankAppearance_icassp_neg.pdf']);
        close
    end
    
    %     Weight (0.66,0.24,0.1)

    weightedMismatchMatrix_opt_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for j = 1:handles.numCipicSubjects
          weightedMismatchMatrix_opt_neg(i,j) = ...
          0.66 * mismatchMatrix_C1_neg(i,j) + ...
          0.24 * mismatchMatrix_C2_neg(i,j) + ...
          0.10 * mismatchMatrix_C3_neg(i,j) ; 
       end
    end
    waitbar(8/12);
    save(['./results/' int2str(id) '/data.mat'],'weightedMismatchMatrix_opt_neg','-append');
    
    weightedRankMatrix_opt_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = weightedMismatchMatrix_opt_neg(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            weightedRankMatrix_opt_neg(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedRankMatrix_opt_neg','-append');
    
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    weightedOccurenceMatrix_opt_neg = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (weightedRankMatrix_opt_neg(i,k) <= maxRank)
              weightedOccurenceMatrix_opt_neg(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedOccurenceMatrix_opt_neg','-append');
    
    %     Average and stddev mismatch values for each CIPIC
    weightedAvgMismatch_opt_neg = zeros(handles.numCipicSubjects,4);
    weightedAvgMismatch_opt_neg(:,1) = mean(weightedMismatchMatrix_opt_neg);
    weightedAvgMismatch_opt_neg(:,2) = std(weightedMismatchMatrix_opt_neg);
    weightedAvgMismatch_opt_neg(:,3) = (1:1:handles.numCipicSubjects); 
    weightedAvgMismatch_opt_neg = sortrows(weightedAvgMismatch_opt_neg);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        weightedAvgMismatch_opt_neg(i,4) = str2double(cipicID{weightedAvgMismatch_opt_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedAvgMismatch_opt_neg','-append');
    
%     Average and stddev rank values for each CIPIC
    weightedAvgRank_opt_neg = zeros(handles.numCipicSubjects,4);
    weightedAvgRank_opt_neg(:,1) = mean(weightedRankMatrix_opt_neg);
    weightedAvgRank_opt_neg(:,2) = std(weightedRankMatrix_opt_neg);
    weightedAvgRank_opt_neg(:,3) = (1:1:handles.numCipicSubjects);
    weightedAvgRank_opt_neg = sortrows(weightedAvgRank_opt_neg);
    for i = 1:handles.numCipicSubjects
        weightedAvgRank_opt_neg(i,4) = str2double(cipicID{weightedAvgRank_opt_neg(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedAvgRank_opt_neg','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    weightedNumOccurrence_opt_neg = zeros(handles.numCipicSubjects,3);
    weightedNumOccurrence_opt_neg(:,1) = sum(weightedOccurenceMatrix_opt_neg);
    weightedNumOccurrence_opt_neg(:,2) = (1:1:handles.numCipicSubjects);
    weightedNumOccurrence_opt_neg = sortrows(weightedNumOccurrence_opt_neg,-1);
    for i = 1:handles.numCipicSubjects
        weightedNumOccurrence_opt_neg(i,3) = str2double(cipicID{weightedNumOccurrence_opt_neg(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedNumOccurrence_opt_neg','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
    delete(h);
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedAvgMismatch_opt_neg(:,1),'c');
        hold on
        errorbar(weightedAvgMismatch_opt_neg(:,1),weightedAvgMismatch_opt_neg(:,2),'.r');
        title('Average mismatch for CIPIC ID for weighted (0.66,0.24,0.1) tracks negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedAvgMismatch_opt_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedAvgMismatch_opt_neg.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedAvgRank_opt_neg(:,1),'c');
        hold on
        errorbar(weightedAvgRank_opt_neg(:,1),weightedAvgRank_opt_neg(:,2),'.r');
        title('Average Rank for CIPIC ID for weighted (0.66,0.24,0.1) tracks negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedAvgRank_opt_neg(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedAvgRank_opt_neg.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedNumOccurrence_opt_neg(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for weighted (0.66,0.24,0.1) tracks negative reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedNumOccurrence_opt_neg(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedMRankAppearance_opt_neg.pdf']);
        close
    end
end  
    
if (getappdata(0,'C1Checkbox')==1 && getappdata(0,'C2Checkbox')==1 && getappdata(0,'C3Checkbox')==1)
%     Weight (1/3,1/3,1/3)

    weightedMismatchMatrix_icassp_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for j = 1:handles.numCipicSubjects
          weightedMismatchMatrix_icassp_pos(i,j) = ...
          1/3 * mismatchMatrix_C1_pos(i,j) + ...
          1/3 * mismatchMatrix_C2_pos(i,j) + ...
          1/3 * mismatchMatrix_C3_pos(i,j) ; 
       end
    end
    waitbar(9/12);
    save(['./results/' int2str(id) '/data.mat'],'weightedMismatchMatrix_icassp_pos','-append');
    
    weightedRankMatrix_icassp_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = weightedMismatchMatrix_icassp_pos(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            weightedRankMatrix_icassp_pos(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedRankMatrix_icassp_pos','-append');
    
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    weightedOccurenceMatrix_icassp_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (weightedRankMatrix_icassp_pos(i,k) <= maxRank)
              weightedOccurenceMatrix_icassp_pos(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedOccurenceMatrix_icassp_pos','-append');
    
    %     Average and stddev mismatch values for each CIPIC
    weightedAvgMismatch_icassp_pos = zeros(handles.numCipicSubjects,4);
    weightedAvgMismatch_icassp_pos(:,1) = mean(weightedMismatchMatrix_icassp_pos);
    weightedAvgMismatch_icassp_pos(:,2) = std(weightedMismatchMatrix_icassp_pos);
    weightedAvgMismatch_icassp_pos(:,3) = (1:1:handles.numCipicSubjects); 
    weightedAvgMismatch_icassp_pos = sortrows(weightedAvgMismatch_icassp_pos);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        weightedAvgMismatch_icassp_pos(i,4) = str2double(cipicID{weightedAvgMismatch_icassp_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedAvgMismatch_icassp_pos','-append');
    
%     Average and stddev rank values for each CIPIC
    weightedAvgRank_icassp_pos = zeros(handles.numCipicSubjects,4);
    weightedAvgRank_icassp_pos(:,1) = mean(weightedRankMatrix_icassp_pos);
    weightedAvgRank_icassp_pos(:,2) = std(weightedRankMatrix_icassp_pos);
    weightedAvgRank_icassp_pos(:,3) = (1:1:handles.numCipicSubjects);
    weightedAvgRank_icassp_pos = sortrows(weightedAvgRank_icassp_pos);
    for i = 1:handles.numCipicSubjects
        weightedAvgRank_icassp_pos(i,4) = str2double(cipicID{weightedAvgRank_icassp_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedAvgRank_icassp_pos','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    weightedNumOccurrence_icassp_pos = zeros(handles.numCipicSubjects,3);
    weightedNumOccurrence_icassp_pos(:,1) = sum(weightedOccurenceMatrix_icassp_pos);
    weightedNumOccurrence_icassp_pos(:,2) = (1:1:handles.numCipicSubjects);
    weightedNumOccurrence_icassp_pos = sortrows(weightedNumOccurrence_icassp_pos,-1);
    for i = 1:handles.numCipicSubjects
        weightedNumOccurrence_icassp_pos(i,3) = str2double(cipicID{weightedNumOccurrence_icassp_pos(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedNumOccurrence_icassp_pos','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
    delete(h);
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedAvgMismatch_icassp_pos(:,1),'c');
        hold on
        errorbar(weightedAvgMismatch_icassp_pos(:,1),weightedAvgMismatch_icassp_pos(:,2),'.r');
        title('Average mismatch for CIPIC ID for weighted (0.33,0.33,0.33) tracks positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedAvgMismatch_icassp_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedAvgMismatch_icassp_pos.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedAvgRank_icassp_pos(:,1),'c');
        hold on
        errorbar(weightedAvgRank_icassp_pos(:,1),weightedAvgRank_icassp_pos(:,2),'.r');
        title('Average Rank for CIPIC ID for weighted (0.33,0.33,0.33) tracks positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedAvgRank_icassp_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedAvgRank_icassp_pos.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedNumOccurrence_icassp_pos(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for weighted (0.33,0.33,0.33) tracks positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedNumOccurrence_icassp_pos(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedMRankAppearance_icassp_pos.pdf']);
        close
    end
    
    %     Weight (0.66,0.24,0.1)

    weightedMismatchMatrix_opt_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for j = 1:handles.numCipicSubjects
          weightedMismatchMatrix_opt_pos(i,j) = ...
          0.66 * mismatchMatrix_C1_pos(i,j) + ...
          0.24 * mismatchMatrix_C2_pos(i,j) + ...
          0.10 * mismatchMatrix_C3_pos(i,j) ; 
       end
    end
    waitbar(10/12);
    save(['./results/' int2str(id) '/data.mat'],'weightedMismatchMatrix_opt_pos','-append');
    
    weightedRankMatrix_opt_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
        currentTest = zeros(handles.numCipicSubjects,2);
        currentTest(:,1) = weightedMismatchMatrix_opt_pos(i,:);
        currentTest(:,2) = (1:1:handles.numCipicSubjects);
        currentTest = sortrows(currentTest);
        for k = 1:handles.numCipicSubjects
            weightedRankMatrix_opt_pos(i,currentTest(k,2)) = k;
        end
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedRankMatrix_opt_pos','-append');
    
    maxRank=str2num(getappdata(0,'M')); %Getting M parameter
    weightedOccurenceMatrix_opt_pos = zeros(numOfTests,handles.numCipicSubjects);
    for i = 1:numOfTests
       for k = 1:handles.numCipicSubjects
          if (weightedRankMatrix_opt_pos(i,k) <= maxRank)
              weightedOccurenceMatrix_opt_pos(i,k) = 1;
          end
       end
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedOccurenceMatrix_opt_pos','-append');
    
    %     Average and stddev mismatch values for each CIPIC
    weightedAvgMismatch_opt_pos = zeros(handles.numCipicSubjects,4);
    weightedAvgMismatch_opt_pos(:,1) = mean(weightedMismatchMatrix_opt_pos);
    weightedAvgMismatch_opt_pos(:,2) = std(weightedMismatchMatrix_opt_pos);
    weightedAvgMismatch_opt_pos(:,3) = (1:1:handles.numCipicSubjects); 
    weightedAvgMismatch_opt_pos = sortrows(weightedAvgMismatch_opt_pos);
    cipicID=listCipicIDs();
    for i = 1:handles.numCipicSubjects
        weightedAvgMismatch_opt_pos(i,4) = str2double(cipicID{weightedAvgMismatch_opt_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedAvgMismatch_opt_pos','-append');
    
%     Average and stddev rank values for each CIPIC
    weightedAvgRank_opt_pos = zeros(handles.numCipicSubjects,4);
    weightedAvgRank_opt_pos(:,1) = mean(weightedRankMatrix_opt_pos);
    weightedAvgRank_opt_pos(:,2) = std(weightedRankMatrix_opt_pos);
    weightedAvgRank_opt_pos(:,3) = (1:1:handles.numCipicSubjects);
    weightedAvgRank_opt_pos = sortrows(weightedAvgRank_opt_pos);
    for i = 1:handles.numCipicSubjects
        weightedAvgRank_opt_pos(i,4) = str2double(cipicID{weightedAvgRank_opt_pos(i,3)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedAvgRank_opt_pos','-append');
    
%     Number of occurrence of k-top ranked CIPIC
    weightedNumOccurrence_opt_pos = zeros(handles.numCipicSubjects,3);
    weightedNumOccurrence_opt_pos(:,1) = sum(weightedOccurenceMatrix_opt_pos);
    weightedNumOccurrence_opt_pos(:,2) = (1:1:handles.numCipicSubjects);
    weightedNumOccurrence_opt_pos = sortrows(weightedNumOccurrence_opt_pos,-1);
    for i = 1:handles.numCipicSubjects
        weightedNumOccurrence_opt_pos(i,3) = str2double(cipicID{weightedNumOccurrence_opt_pos(i,2)});
    end
    save(['./results/' int2str(id) '/data.mat'],'weightedNumOccurrence_opt_pos','-append');
    
    % Import checkboxes
    mediumMismatch = getappdata(0,'mediumMismatch');
    mediumRanked= getappdata(0,'mediumRanked');
    rankedPresence=getappdata(0,'rankedPresence');
    
    delete(h);
    
%     Create a plot for average mismatch values
    if(mediumMismatch==1)
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedAvgMismatch_opt_pos(:,1),'c');
        hold on
        errorbar(weightedAvgMismatch_opt_pos(:,1),weightedAvgMismatch_opt_pos(:,2),'.r');
        title('Average mismatch for CIPIC ID for weighted (0.66,0.24,0.1) tracks positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedAvgMismatch_opt_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedAvgMismatch_opt_pos.pdf']);
        close
    end
   
%     Create a plot for average rank    
    if(mediumRanked==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedAvgRank_opt_pos(:,1),'c');
        hold on
        errorbar(weightedAvgRank_opt_pos(:,1),weightedAvgRank_opt_pos(:,2),'.r');
        title('Average Rank for CIPIC ID for weighted (0.66,0.24,0.1) tracks positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedAvgRank_opt_pos(:,4))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedAvgRank_opt_pos.pdf']);
        close
    end
    
%     Create a plot for appearence in M-Rank
    if(rankedPresence==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(weightedNumOccurrence_opt_pos(:,1),'c');
        title('Appearance in M-Rank for CIPIC ID for weighted (0.66,0.24,0.1) tracks positive reflection')
        set(gca,'XTick',1:handles.numCipicSubjects)
        set(gca,'XTickLabel',weightedNumOccurrence_opt_pos(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/weightedMRankAppearance_opt_pos.pdf']);
        close
    end
end  


%     External & internal ear height

    anthro = load ('./cipic_anthro/anthro.mat');
    D = anthro.D;
    cipic_id = anthro.id;
    if (getappdata(0,'ExtCheckbox')==1)
        ext_D = zeros(37,3);
        index = 1;
        for i = 1:45
            if(isnan(D(i,1)))
                continue;
            end
            ext_D(index,1) = abs(D_ext - D(i,5));
            ext_D(index,2) = i;
            ext_D(index,3) = cipic_id(i,1);
            index = index + 1;
        end
        ext_D = sortrows(ext_D);
        waitbar(11/12);
        save(['./results/' int2str(id) '/data.mat'],'ext_D','-append');
    end
    
    if (getappdata(0,'IntCheckbox')==1)
        int_D = zeros(37,3);
        index = 1;
        for i = 1:45
            if(isnan(D(i,1)))
                continue;
            end
            int_D(index,1) = abs(D_int - (D(i,1) + D(i,2) + D(i,4)));
            int_D(index,2) = i;
            int_D(index,3) = cipic_id(i,1);
            index = index + 1;
        end
        int_D = sortrows(int_D);
        waitbar(12/12);
        save(['./results/' int2str(id) '/data.mat'],'int_D','-append');
    end
    

    if(getappdata(0,'ExtCheckbox')==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(ext_D(:,1),'c');
        title('External ear height mismatch')
        set(gca,'XTick',1:37)
        set(gca,'XTickLabel',ext_D(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/earExternalHeight.pdf']);
        close
    end
    
    if(getappdata(0,'IntCheckbox')==1)    
        plotsHandle = figure('Visible','off');
        set(gcf,'PaperPositionMode','auto')
        set(plotsHandle, 'Position', [200 200 1200 300])
        bar(int_D(:,1),'c');
        title('Internal ear height mismatch')
        set(gca,'XTick',1:37)
        set(gca,'XTickLabel',int_D(:,3))
        set(gca,'FontSize',8)
        h=plotsHandle;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        print(plotsHandle,'-dpdf',['./results/' int2str(id) '/earInternalHeight.pdf']);
        close
    end
    
    if(getappdata(0,'C1Checkbox')==1 && getappdata(0,'C2Checkbox')==1 && getappdata(0,'C3Checkbox')==1 &&...
            getappdata(0,'IntCheckbox')==1 && getappdata(0,'ExtCheckbox')==1)
        printOverview
    end
    
    delete(waitb);
    
    
    
    h = msgbox('Operation Completed','HRTF Selection');