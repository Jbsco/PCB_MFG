%% Reset
close all;
clear all;
clc;

%% Filename selections
map1="PCB05.map";

%% Colormap
map=[0.0 0.0 1.0
     0.0 0.1 1.0
     0.0 0.2 1.0
     0.0 0.3 1.0
     0.0 0.4 1.0
     0.0 0.5 1.0
     0.0 0.6 1.0
     0.0 0.7 1.0
     0.0 0.8 1.0
     0.0 0.9 1.0
     0.0 1.0 1.0
     0.0 1.0 0.9
     0.0 1.0 0.8
     0.0 1.0 0.7
     0.0 1.0 0.6
     0.0 1.0 0.5
     0.0 1.0 0.4
     0.0 1.0 0.3
     0.0 1.0 0.2
     0.0 1.0 0.1
     0.0 1.0 0.0
     0.1 1.0 0.0
     0.2 1.0 0.0
     0.3 1.0 0.0
     0.4 1.0 0.0
     0.5 1.0 0.0
     0.6 1.0 0.0
     0.7 1.0 0.0
     0.8 1.0 0.0
     0.9 1.0 0.0
     1.0 1.0 0.0
     1.0 0.9 0.0
     1.0 0.8 0.0
     1.0 0.7 0.0
     1.0 0.6 0.0
     1.0 0.5 0.0
     1.0 0.4 0.0
     1.0 0.3 0.0
     1.0 0.2 0.0
     1.0 0.1 0.0
     1.0 0.0 0.0];

%% Import *.map file and get mesh parameters for parsing and plotting
data=dlmread(map1,';');
xSize=data(1,3);
ySize=data(1,4);
xRes=data(2,1);
yRes=data(2,2);
xStep=xSize/(xRes-1);
yStep=ySize/(yRes-1);

%% Built plot matrix and parameters
plotData=data;
for i=1:3
    plotData(1,:)=[];
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

%% Calculate linear approximations from corners and normalize
% corners & linear approximation in x:
P1=plotData(1,1);
P2=plotData(1,xRes);
P3=plotData(yRes,1);
P4=plotData(yRes,xRes);
Mx_1=(P2-P1)/xMax;
Mx_2=(P4-P3)/xMax;
Mx=(Mx_1+Mx_2)/2; % avg slope in x
% apply normalization in x
for i=1:xRes
    for j=1:yRes
        plotData(j,i)=plotData(j,i)-Mx*(((i-1)*xStep)-xSize/2);
    end
end
% corners & linear approximation in y:
P1=plotData(1,1);
P2=plotData(1,xRes);
P3=plotData(yRes,1);
P4=plotData(yRes,xRes);
My_1=(P3-P1)/yMax;
My_2=(P4-P2)/yMax;
My=(My_1+My_2)/2; % avg slope in y
% apply normalization in y
for i=1:xRes
    for j=1:yRes
        plotData(j,i)=plotData(j,i)-My*(((j-1)*yStep)-ySize/2);
    end
end
% apply normalization in z
zOffs=mean(plotData,'all');
for i=1:xRes
    for j=1:yRes
        plotData(j,i)=plotData(j,i)-zOffs;
    end
end

%% Calculate z-parameters
zMin=min(plotData,[],'all');
zMax=max(plotData,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/10;

%% Plot two figures with east colorbar legend
tiledlayout(2,2);
% first figure
nexttile
s=mesh(xPlot,yPlot,plotData,'FaceAlpha','0.5');
colormap(map);
title('Corner Normalized 3D Contour '+map1);
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
s=mesh(xPlot,yPlot,plotData,'FaceAlpha','0.5');
title('Corner Normalized 2D Contour '+map1);
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
data=dlmread(map1,';');
xSize=data(1,3);
ySize=data(1,4);
xRes=data(2,1);
yRes=data(2,2);
xStep=xSize/(xRes-1);
yStep=ySize/(yRes-1);

% Build plot matrix and plot parameters
plotData=data;
for i=1:3
    plotData(1,:)=[];
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
zMin=min(plotData,[],'all');
zMax=max(plotData,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/10;

% first figure
nexttile
s=mesh(xPlot,yPlot,plotData,'FaceAlpha','0.5');
colormap(map);
title('Raw 3D Contour '+map1);
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
s=mesh(xPlot,yPlot,plotData,'FaceAlpha','0.5');
title('Raw 2D Contour '+map1);
xlim(xRange);
xticks(xMin:xSteps:xMax);
ylim(yRange);
yticks(yMin:ySteps:yMax);
zlim(zRange);
s.FaceColor = 'flat';
rotate(s, [0 0 1], 180)
view(2);
clim(zRange);