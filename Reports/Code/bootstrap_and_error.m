%% Reset
close all;
clear all;
clc;

%% Colormap
colormap(jet);

%% Init data and parameters
% Import *.map file and get mesh parameters for parsing and plotting
data(:,:)=dlmread("PCB01.map",';');
xSize=data(1,3);
ySize=data(1,4);
xRes=data(2,1);
yRes=data(2,2);
xStep=xSize/(xRes-1);
yStep=ySize/(yRes-1);
xPlot=0:xStep:xSize;
xMin=min(xPlot,[],'all');
xMax=max(xPlot,[],'all');
xRange=[xMin xMax];
xSteps=(xMax-xMin)/10;
yPlot=0:yStep:ySize;
yMin=min(yPlot,[],'all');
yMax=max(yPlot,[],'all');
yRange=[yMin yMax];
ySteps=(yMax-yMin)/10;
data(19,34)=zeros;
for i=1:1:10
    % Filename selections
    map_num="PCB0"+i+".map";
    % Import *.map file and get mesh parameters for parsing and plotting
    data(:,:,i)=dlmread(map_num,';');
end
% Correct matrix
for j=1:1:3
    data(1,:,:)=[];
end

%% Per-coordinate means
meanData=mean(data,3);
figure(1)
% recalculate z-parameters
zMin=min(meanData,[],'all');
zMax=max(meanData,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/5;
s=mesh(xPlot,yPlot,meanData,'FaceAlpha','0.5');
title('Raw Mean Variance (variance from local average across set of 10 heightmaps)');
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Z-variance (mm)')
xlim(xRange);
xticks(xMin:xSteps:xMax);
ylim(yRange);
yticks(yMin:ySteps:yMax);
zlim(zRange);
zticks(zMin:zSteps:zMax);
s.FaceColor = 'flat';
rotate(s, [0 0 1], 180)
view(325,60);
cb=colorbar('Ticks',zMin:zSteps:zMax);

%% Per-board %-error from mean
figure(2)
errorBoard(16,34,10)=zeros;
colormap(jet);
tiledlayout(2,5)
for i=1:1:10
    nexttile
    errorBoard(:,:,i)=(abs(data(:,:,i)-meanData)./mean(meanData,'all')).*100;
    % recalculate z-parameters
    zMin=min(errorBoard(:,:,i),[],'all');
    zMax=max(errorBoard(:,:,i),[],'all');
    zRange=[zMin zMax];
    zSteps=(zMax-zMin)/5;
    s=mesh(xPlot,yPlot,errorBoard(:,:,i),'FaceAlpha','0.5');
    title("Percentage Error From Mean - PCB #"+i);
    xlabel('X-position (mm)')
    ylabel('Y-position (mm)')
    zlabel('Error (%)')
    xlim(xRange);
    xticks(xMin:xSteps:xMax);
    ylim(yRange);
    yticks(yMin:ySteps:yMax);
    zlim(zRange);
    zticks(zMin:zSteps:zMax);
    s.FaceColor = 'flat';
    rotate(s, [0 0 1], 180)
    view(325,60);
    cb=colorbar('Ticks',zMin:zSteps:zMax);
end

%% Mean percent error, note: this is the same as standard deviation
figure(3)
meanError=mean(errorBoard,3);
colormap(jet);
% recalculate z-parameters
zMin=min(meanError,[],'all');
zMax=max(meanError,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/5;
s=mesh(xPlot,yPlot,meanError,'FaceAlpha','0.5');
title('Mean Percent Error (variance from local average across set of 10 heightmaps)');
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Error (%)')
xlim(xRange);
xticks(xMin:xSteps:xMax);
ylim(yRange);
yticks(yMin:ySteps:yMax);
zlim(zRange);
zticks(zMin:zSteps:zMax);
s.FaceColor = 'flat';
rotate(s, [0 0 1], 180)
view(325,60);
cb=colorbar('Ticks',zMin:zSteps:zMax);

%% Create additional samples using bootstrap method
bootData(16,34,1000)=zeros;
for i=1:1:1000
    for j=1:1:10
        % sample randomly from real dataset, sum
        bootData(:,:,i)=bootData(:,:,i)+data(:,:,randi([1 10]));
    end
    bootData(:,:,i)=bootData(:,:,i)/10;
end

%% Plot the mean of the bootstrap data
figure(4)
meanBoot=mean(bootData,3);
colormap(jet);
% recalculate z-parameters
zMin=min(meanBoot,[],'all');
zMax=max(meanBoot,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/5;
s=mesh(xPlot,yPlot,meanBoot,'FaceAlpha','0.5');
title('Bootstrap Mean Variance (from bootstrap data with 1000 generated size=N samples)');
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Z-variance (mm)')
xlim(xRange);
xticks(xMin:xSteps:xMax);
ylim(yRange);
yticks(yMin:ySteps:yMax);
zlim(zRange);
zticks(zMin:zSteps:zMax);
s.FaceColor = 'flat';
rotate(s, [0 0 1], 180)
view(325,60);
cb=colorbar('Ticks',zMin:zSteps:zMax);

%% Plot the std dev of the bootstrap data
figure(5)
stdDevBoot=std(bootData,0,3);
colormap(jet);
% recalculate z-parameters
zMin=min(stdDevBoot,[],'all');
zMax=max(stdDevBoot,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/5;
s=mesh(xPlot,yPlot,stdDevBoot,'FaceAlpha','0.5');
title('Bootstrap Standard Deviation (from bootstrap data with 1000 generated size=N samples)');
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Z-variance (mm)')
xlim(xRange);
xticks(xMin:xSteps:xMax);
ylim(yRange);
yticks(yMin:ySteps:yMax);
zlim(zRange);
zticks(zMin:zSteps:zMax);
s.FaceColor = 'flat';
rotate(s, [0 0 1], 180)
view(325,60);
cb=colorbar('Ticks',zMin:zSteps:zMax);

%% Different between meanData and meanBoot
figure(6)
diffBoot=meanBoot-meanData;
colormap(jet);
% recalculate z-parameters
zMin=min(diffBoot,[],'all');
zMax=max(diffBoot,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/5;
s=mesh(xPlot,yPlot,diffBoot,'FaceAlpha','0.5');
title("Difference between meanData and meanBoot");
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Z-variance (mm)')
xlim(xRange);
xticks(xMin:xSteps:xMax);
ylim(yRange);
yticks(yMin:ySteps:yMax);
zlim(zRange);
zticks(zMin:zSteps:zMax);
s.FaceColor = 'flat';
rotate(s, [0 0 1], 180)
view(325,60);
cb=colorbar('Ticks',zMin:zSteps:zMax);

%% Write out bootstrap model
% get map parameters from another map
bootModel=dlmread("PCB01.map",';');
for i=1:1:16
    for j=1:1:34
        bootModel(i+3,j)=bootData(i,j);
    end
end
% write to file using ';' delimiter
% header:
fid=fopen('bootModel.map','w'); % filename, write mode
fprintf(fid,"%d;%d;%d;%d\n",bootModel(1,1),bootModel(1,2),bootModel(1,3),bootModel(1,4));
fprintf(fid,"%d;%d;%.2f;%.2f\n",bootModel(2,1),bootModel(2,2),bootModel(2,3),bootModel(2,4));
fprintf(fid,"%d;%d;%d\n",bootModel(3,1),bootModel(3,2),bootModel(3,3));
% data:
for i=4:1:19
    for j=1:1:33
        fprintf(fid,"%.16f;",bootModel(i,j));
    end
    fprintf(fid,"%.16f\n",bootModel(i,34));
end
fclose(fid);