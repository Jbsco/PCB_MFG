%% Reset
close all;
clear all;
clc;

%% Colormap
map=jet;

%% Plot two figures with east colorbar legend
figure(1)
tiledlayout(2,5);
%meanVal(10)=zeros; not needed due to normalization-this value is ~zero
meanPlot(16,34)=zeros;
meanValRaw(10)=zeros;
meanPlotRaw(16,34)=zeros;
stdDevData(16,34,10)=zeros;
stdDevDataRaw(16,34,10)=zeros;
stdDevPlot(16,34)=zeros;

for i=1:1:10
    %% Filename selections
    map_num="PCB0"+i+".map";
    
    %% Import *.map file and get mesh parameters for parsing and plotting
    data=dlmread(map_num,';');
    xSize=data(1,3);
    ySize=data(1,4);
    xRes=data(2,1);
    yRes=data(2,2);
    xStep=xSize/(xRes-1);
    yStep=ySize/(yRes-1);
    
    %% Built plot matrix and parameters
    plotData=data;
    for j=1:3
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
    
    %% Calculate linear approximations from quadrant average and normalize
    % quadrant averages & linear approximation in x:
    P1=mean(plotData(1:yRes/2,1:xRes/2),'all');
    P2=mean(plotData(1:yRes/2,(xRes/2)+1:xRes),'all');
    P3=mean(plotData((yRes/2)+1:yRes,1:xRes/2),'all');
    P4=mean(plotData((yRes/2)+1:yRes,(xRes/2)+1:xRes),'all');
    Mx_1=(P2-P1)/(xMax/2);
    Mx_2=(P4-P3)/(xMax/2);
    Mx=(Mx_1+Mx_2)/2; % avg slope in x
    % apply normalization in x
    for j=1:xRes
        for k=1:yRes
            plotData(k,j)=plotData(k,j)-Mx*(((j-1)*xStep)-xSize/2);
        end
    end
    % quadrant averages & linear approximation in y:
    P1=mean(plotData(1:yRes/2,1:xRes/2),'all');
    P2=mean(plotData(1:yRes/2,(xRes/2)+1:xRes),'all');
    P3=mean(plotData((yRes/2)+1:yRes,1:xRes/2),'all');
    P4=mean(plotData((yRes/2)+1:yRes,(xRes/2)+1:xRes),'all');
    My_1=(P3-P1)/(yMax/2);
    My_2=(P4-P2)/(yMax/2);
    My=(My_1+My_2)/2; % avg slope in y
    % apply normalization in y
    for j=1:xRes
        for k=1:yRes
            plotData(k,j)=plotData(k,j)-My*(((k-1)*yStep)-ySize/2);
        end
    end
    % apply normalization in z
    zOffs=mean(plotData,'all');
    for j=1:xRes
        for k=1:yRes
            plotData(k,j)=plotData(k,j)-zOffs;
        end
    end

    %% Get normalized mean of whole matrix
    %meanVal(i)=mean(plotData,'all');
    for j=1:xRes
        for k=1:yRes
            meanPlot(k,j)=meanPlot(k,j)+(plotData(k,j));%-meanVal(i));
            stdDevData(k,j,i)=plotData(k,j);%-meanVal(i);
        end
    end
        
    %% Calculate z-parameters
    zMin=min(plotData,[],'all');
    zMax=max(plotData,[],'all');
    zRange=[zMin zMax];
    zSteps=(zMax-zMin)/5;
    
    % first tile
    nexttile
    s=mesh(xPlot,yPlot,plotData,'FaceAlpha','0.5');
    colormap(map);
    title('Quadrant Average Normalized 3D Contour '+map_num);
    xlabel('X-position (mm)')
    ylabel('Y-position (mm)')
    zlabel('Z-offset (mm)')
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
    %cb.Layout.Tile='east';
end

figure(2)
tiledlayout(2,5);
for i=1:1:10
    %% Filename selections
    map_num="PCB0"+i+".map";
    
    %% Import *.map file and get mesh parameters for parsing and plotting
    data=dlmread(map_num,';');
    xSize=data(1,3);
    ySize=data(1,4);
    xRes=data(2,1);
    yRes=data(2,2);
    xStep=xSize/(xRes-1);
    yStep=ySize/(yRes-1);

    %% Plot second map for comparison
    data=dlmread(map_num,';');
    xSize=data(1,3);
    ySize=data(1,4);
    xRes=data(2,1);
    yRes=data(2,2);
    xStep=xSize/(xRes-1);
    yStep=ySize/(yRes-1);
    
    % Build plot matrix and plot parameters
    plotData=data;
    for j=1:3
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
    zSteps=(zMax-zMin)/5;
    
    %% Get raw mean of whole matrix
    meanValRaw(i)=mean(plotData,'all');
    for j=1:xRes
        for k=1:yRes
            meanPlotRaw(k,j)=meanPlotRaw(k,j)+(plotData(k,j));%-meanValRaw(i));
            stdDevDataRaw(k,j,i)=plotData(k,j);%-meanVal(i);
        end
    end
    
    nexttile
    s=mesh(xPlot,yPlot,plotData,'FaceAlpha','0.5');
    colormap(map);
    title('Raw 3D Contour '+map_num);
    xlabel('X-position (mm)')
    ylabel('Y-position (mm)')
    zlabel('Z-offset (mm)')
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
    %cb.Layout.Tile='east';
end

%% Calculate point means
for j=1:xRes
    for k=1:yRes
        meanPlot(k,j)=meanPlot(k,j)/10;
        meanPlotRaw(k,j)=meanPlotRaw(k,j)/10;
    end
end

%% Plot normalized mean set
% calculate z-parameters
zMin=min(meanPlot,[],'all');
zMax=max(meanPlot,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/5;
figure(3)
s=mesh(xPlot,yPlot,meanPlot,'FaceAlpha','0.5');
colormap(map);
title('Normalized Mean Variance (variance from local average across set of 10 heightmaps)');
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

%% Plot raw mean set
% recalculate z-parameters
zMin=min(meanPlotRaw,[],'all');
zMax=max(meanPlotRaw,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/5;

figure(4)
s=mesh(xPlot,yPlot,meanPlotRaw,'FaceAlpha','0.5');
colormap(map);
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

%% Plot normalized 2D plot of mean in X and Y
meanNVarX=mean(meanPlot,1);
meanNVarY=mean(meanPlot,2)';
figure(5)
tiledlayout(2,1)
nexttile
plot(linspace(0,xMax,xRes),meanNVarX)
title('Mean Variance Across X');
xlim(xRange);
xticks(xMin:xSteps:xMax);
xlabel('X-position (mm)')
ylabel('Mean Z-Variance (mm)')
nexttile
plot(linspace(0,yMax,yRes),meanNVarY)
title('Mean Variance Across Y');
xlim(yRange);
xticks(yMin:ySteps:yMax);
xlabel('Y-position (mm)')
ylabel('Mean Z-Variance (mm)')

%% X-Y Std Deviation
% get per-coordinate deviations
stdDevPlot=std(stdDevData,0,3);
figure(5)
% plot std deviation result
% calculate z-parameters
zMin=min(stdDevPlot,[],'all');
zMax=max(stdDevPlot,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/5;

figure(6)
s=mesh(xPlot,yPlot,stdDevPlot,'FaceAlpha','0.5');
colormap(map);
title('Normalized Standard Deviation');
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Std-Dev (mm)')
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

%% Plot Raw Std Deviation
% get per-coordinate deviations
stdDevPlotRaw=std(stdDevDataRaw,0,3);
figure(7)
% recalculate z-parameters
zMin=min(stdDevPlotRaw,[],'all');
zMax=max(stdDevPlotRaw,[],'all');
zRange=[zMin zMax];
zSteps=(zMax-zMin)/5;

s=mesh(xPlot,yPlot,stdDevPlotRaw,'FaceAlpha','0.5');
colormap(map);
title('Raw Standard Deviation');
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Std-Dev (mm)')
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

%% Plot 2D plot of std dev in X and Y
stdDevX=mean(stdDevPlot,1);
stdDevY=mean(stdDevPlot,2)';
figure(8)
tiledlayout(2,1)
nexttile
plot(linspace(0,xMax,xRes),stdDevX)
title('Standard Deviation Across X');
xlim(xRange);
xticks(xMin:xSteps:xMax);
xlabel('X-position (mm)')
ylabel('X-Std-Dev (mm)')
nexttile
plot(linspace(0,yMax,yRes),stdDevY)
title('Standard Deviation Across Y');
xlim(yRange);
xticks(yMin:ySteps:yMax);
xlabel('Y-position (mm)')
ylabel('Y-Std-Dev (mm)')