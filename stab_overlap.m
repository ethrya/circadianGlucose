% Code to create plot of locations where models are stable/limit cycles

% Load data
data = load('~/scratch/bf_res_02');

liStab = abs(data.LiResults(:,:,1)-data.LiResults(:,:,2))<1;
sturisStab = abs(data.SturisResults(:,:,1)-data.SturisResults(:,:,2))<1;
tolicStab = abs(data.TolicResults(:,:,1)-data.TolicResults(:,:,2))<1;

[Tau,Gin]=meshgrid(data.tau, data.Gin);

stabMatrix = zeros(length(liStab(:,1)),length(liStab(1,:)));

for i=1:length(liStab(:,1))
    for j=1:length(liStab(1,:))

        if liStab(i,j)==0 && sturisStab(i,j)==0 && tolicStab(i,j)==0
            stabMatrix(i,j) = 0;
        elseif liStab(i,j)==1 && sturisStab(i,j)==0 && tolicStab(i,j)==0
            stabMatrix(i,j) = 1;
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
mesh(Tau,Gin,stabMatrix);





