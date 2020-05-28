function [MCC] = project_main(A)
% Name: project_main 
% Purpose: This function calculates a threshold for MRI abnormalities
% Author: Tyler Hardy
% Input: MRI dataset
% Output: Highlighted MRI and MCC/F1 values

% Global Variable Declaration********
    w_Clean = strel('disk',4); % Disk for "rolling" binary image ops
    MCC = 0; % Initialize at zero
    best_answer = 0; % Initialize at zero
    MCC_sum = 0;
    set(gcf,'color','white'); % Set background color
    F1new = 0;
    F1 = 0;
% End Variable Declaration***********

% Boot sequence *********************
%   This will load a specified dataset in the current directory
    load(['data', num2str(A)]) 
    u_best = A1; % Prevents error if A1 algorithm is best    
% Main ******************************
    for i=1:4 
        switch (i) % loads current image from dataset
            case 1
                u=A1; 
            case 2
                u=A2; 
            case 3
                u=A3; 
            case 4
                u=A4; 
        end
    u_unfiltered = u; % Used in final display

% Threshold  ************************
        D = (u>545 & u<875);

% Clean up output *******************
        D = bwareaopen(D,22);
        D = imfill(D,'holes');
        D = imdilate(D,w_Clean);
        D = imerode(D,w_Clean);

% Perform statistical analysis ******
        TP = sum(sum([D==1 & G==1]));
        TN = sum(sum([D==0 & G==0]));
        FP = sum(sum([D==1 & G==0]));
        FN = sum(sum([D==0 & G==1]));
        F1new = 2*TP/(2*TP+FP+FN);
        MCC_new = (TP*TN-FP*FN)/(sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN)));
        MCC_sum = MCC_new + MCC_sum;
        
        if MCC_new > MCC
            best_answer = D;
            MCC = MCC_new;
            u_best = u_unfiltered;
        end
         if F1new > F1
            best_F1 = D;
            F1 = F1new;
        end       
% Draw image

    end
    MCC_avg = MCC_sum/4
    imagesc(u_best); 
    colormap gray; 
    hold on;
    contour(G,[0,0],'black');
    contour(best_answer,[0,0],'w'); 
    hold off;
    MCC
    F1
end


