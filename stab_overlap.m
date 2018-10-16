% Code to create plot of locations where models are stable/limit cycles

% Load data
%data = load('/import/suphys1/erya7975/simResults/limit_locations/g_100-175');

data = load('~/2018-06-25_bf');

liStab = abs(data.LiResults(:,:,1)-data.LiResults(:,:,2))<1;
sturisStab = abs(data.SturisResults(:,:,1)-data.SturisResults(:,:,2))<1;
tolicStab = abs(data.TolicResults(:,:,1)-data.TolicResults(:,:,2))<1;

[Tau,Gin]=meshgrid(data.tau, data.Gin);

stabMatrix = zeros(length(liStab(:,1)),length(liStab(1,:)));

for i=1:length(liStab(:,1))
    for j=1:length(liStab(1,:))
        % All limit
        if liStab(i,j)==0 && sturisStab(i,j)==0 && tolicStab(i,j)==0
            stabMatrix(i,j) = 0;
        % Sturis and Tolic
        elseif liStab(i,j)==1 && sturisStab(i,j)==0 && tolicStab(i,j)==0
            stabMatrix(i,j) = 1;
        % Tolic and Li
        elseif liStab(i,j)==0 && sturisStab(i,j)==1 && tolicStab(i,j)==0
            stabMatrix(i,j) = 2;
        elseif liStab(i,j)==0 && sturisStab(i,j)==0 && tolicStab(i,j)==1
            stabMatrix(i,j) = 3;
        elseif liStab(i,j)==1 && sturisStab(i,j)==1 && tolicStab(i,j)==0
            stabMatrix(i,j) = 4;
        elseif liStab(i,j)==1 && sturisStab(i,j)==0 && tolicStab(i,j)==1
            stabMatrix(i,j) = 5;
        elseif liStab(i,j)==0 && sturisStab(i,j)==1 && tolicStab(i,j)==1
            stabMatrix(i,j) = 6;
        elseif liStab(i,j)==1 && sturisStab(i,j)==1 && tolicStab(i,j)==1
            stabMatrix(i,j) = 7;
        end
    end
end

save('../simResults/stabMat', 'stabMatrix');

figure
h = surf(Tau,Gin,stabMatrix);
view(0,90)
set(h, 'EdgeColor', 'none')
xlabel('\tau_2 (min)')
ylabel('G_{in} (mg/min)')
% Colors from: 
 % http://math.loyola.edu/~loberbro/matlab/html/colorsInMatlab.html
colormap([0.4660 0.6740 0.1880; % Green
          0.4660 0.6740 0; % Green
          00 0.0 0; % Orange
          0.8500 0.3250 0.0980; % Orange
          0 0.4470 0.7410; % Blue
          0 0.4470 0; % Blue          
          0.9290 0.6940 0.1250; % Yellow
          0.6350 0.0780 0.1840; % Red
          1 1 1])

    
