% hint: create another box for time windows
% make an input that needs a start time and duration 
%store these variables in the box 
%loop through the same as previous code (instead of 3 times, then do it n
%times) 

%SYSTEMATICALLY VARY TIME WINDOW - load the data + time data -> start time
%and duration + step (like 2sec step would be 1-30, 2-32, 3-33, etc) ->
%while loop 

tStim = stim.tTraj;
tEye = eyeData.t;
spStim = stim.spTraj;
spEyeX = eyeData.dx;
modgain = stim.modGain;
mgUnique = unique(modgain);
nCond = length(mgUnique);
resp = psychData.resp;

%% input for time window - IF YOU WANT A DIALOGUE BOX TO MANUALLY ADD IN
% THE TIME WINDOWS 
% 
% prompt = {'Enter a starting time:','Enter the duration:'}; %labels for input 
% dlgTitle = 'Input desired time window'; %title for this dialogue box
% numlines = 1; %number of lines for each input field 
% 
% userInput = inputdlg(prompt, dlgTitle,numlines); %the actual dialogue box
% 
% muEspeeds_twin = zeros(length(mgUnique), 3); %defining the size of the box for storing mean eye speeds, assuming there are 3 time windows - defining the number of rows and columns 
% 
% time_windows = {tWin1, tWin, tWin3}; %storing the time windows in a cell array 


%% DEFINING THE TIME WINDOW - START + DURATION + STEP

tstart = min(tStim); %starting time 
tduration = 100; %duration 
tstep = 10; %step (i want time windows every 10 mseconds) 
numWindows = length(time_windows); %number of time windows 

% numrows = ceil(sqrt(numWindows)); %number of rows in the subplot grid - ceil rounds it up to the nearest integer
% numcolumns = ceil(numWindows/numrows); %number of columns in the subplot grid

%loop through each start time until the max time is reached

while tstart + tduration < length(tStim)
    tWin = [tstart, (tstart + tduration)]; %defining the time window

    muEspeeds_twin = zeros(length(mgUnique), numWindows); %defining the size of the box for storing mean eye speeds - defining the number of rows and columns

     time_windows = {tWin}; %storing the current time window in a cell array


    for a = 1:length(mgUnique) %loop over each modgain
        ind = mgUnique(a) == modgain; %indexing all the trials where the modgain is equal to mgUnique(1) for eg.

        for w = 1:14  %now we need to determine which time window we want - replaced numWindows with 14
            if w <= length(time_windows)
                tWin = time_windows{w}; %indexing each time window (1-3) -- squiggly brackets cuz theres a start and end point (2 values)
                %select the eyespeed that fall in the time window
                indWin = tEye > tWin(1) & tEye <= tWin(2);
                muEspeeds_twin(a, w) = mean(mean(spEyeX(ind, indWin)), 2); %mean of eye speeds in each modgain (a) and time window (w) and across the second dimension
            end
        end
    end

  figure
    for w = 1:numWindows %not working cuz numWindows = 1 - so each subplot is 5,3,1 - there's your problem
        subplot(5,3,w)
        hold on

        plot(mgUnique, muEspeeds_twin(:, w),'-','color','r','LineWidth',1)

        hold off
        %labelling 
        xlabel('modgain (deg/s)')
        ylabel('Eye speed (deg/s)')
        title('Figure: trial averaged eye speed in different time windows vs modgain')

        tstart = tstart + tstep; %the next time window

    end
end