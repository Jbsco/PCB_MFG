%% Reset
close all;
clear all;
clc;

%% Filename selections
map1="PCB07.map";
map2="PCB07b.map";

%% Colormap
map='jet';

%% Import *.map file and get mesh parameters for parsing and plotting
data=dlmread(map1,';');
xSize=data(1,3);
ySize=data(1,4);
xRes=data(2,1);
yRes=data(2,2);
xStep=xSize/(xRes-1);
yStep=ySize/(yRes-1);

%% Build plot matrix and plot parameters
plotData1=data;
for i=1:3
    plotData1(1,:)=[];
end
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
zMin=min(plotData1,[],'all');
zMax=max(plotData1,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/10;

%% Plot two figures with east colorbar legend
tiledlayout(2,2);
% first figure
nexttile
s=mesh(xPlot,yPlot,plotData1,'FaceAlpha','0.5');
colormap(map);
title('3D Contour '+map1);
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
cb.Layout.Tile='east';
% second figure
nexttile
s=mesh(xPlot,yPlot,plotData1,'FaceAlpha','0.5');
title('2D Contour '+map1);
xlim(xRange);
xticks(xMin:xSteps:xMax);
ylim(yRange);
yticks(yMin:ySteps:yMax);
zlim(zRange);
s.FaceColor = 'flat';
rotate(s, [0 0 1], 180)
view(2);
clim(zRange);

%% Plot second map for comparison
data=dlmread(map2,';');
xSize=data(1,3);
ySize=data(1,4);
xRes=data(2,1);
yRes=data(2,2);
xStep=xSize/(xRes-1);
yStep=ySize/(yRes-1);

% Build plot matrix and plot parameters
plotData2=data;
for i=1:3
    plotData2(1,:)=[];
end
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
zMin=min(plotData2,[],'all');
zMax=max(plotData2,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/10;

% first figure
nexttile
s=mesh(xPlot,yPlot,plotData2,'FaceAlpha','0.5');
colormap(map);
title('3D Contour '+map2);
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
cb.Layout.Tile='east';
% second figure
nexttile
s=mesh(xPlot,yPlot,plotData2,'FaceAlpha','0.5');
title('2D Contour '+map2);
xlim(xRange);
xticks(xMin:xSteps:xMax);
ylim(yRange);
yticks(yMin:ySteps:yMax);
zlim(zRange);
s.FaceColor = 'flat';
rotate(s, [0 0 1], 180)
view(2);
clim(zRange);

%% compare board differences
figure(2)
tiledlayout(1,2)
nexttile
diffData(yRes,xRes,2)=zeros;
% calculate difference
%for j=1:xRes
 %   for k=1:yRes
  %      diffData(k,j)=plotData1(k,j)-plotData2(k,j);
 %   end
%end
diffData(:,:,1)=plotData1;
diffData(:,:,2)=plotData2;
diffData=std(diffData,0,3);
zMin=min(diffData,[],'all');
zMax=max(diffData,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/10;
s=mesh(xPlot,yPlot,diffData,'FaceAlpha','0.5');
colormap(map);
title('3D Difference Contour - Remove and Reclamp');
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
cb.Layout.Tile='east';
nexttile
s=mesh(xPlot,yPlot,diffData,'FaceAlpha','0.5');
title('2D Difference Contour - Remove and Reclamp');
xlim(xRange);
xticks(xMin:xSteps:xMax);
ylim(yRange);
yticks(yMin:ySteps:yMax);
zlim(zRange);
s.FaceColor = 'flat';
rotate(s, [0 0 1], 180)
view(2);
clim(zRange);