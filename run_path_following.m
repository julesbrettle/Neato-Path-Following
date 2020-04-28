%clc, clear all

load vlvr.mat % loads u_num, VL_num, and VR_num 1x200 vectors
load commandsdata_delay.mat % loads non-adjusted command timestamps

delay = (commandsdata_delay(length(u_num),1) - u_num(length(u_num)))/length(u_num)
    % = (non-adjusted time - ideal time)/200 steps. Gives a delay of about 0.0141s

step_len = u_num(2) - u_num(1); 
    % how long each motor command should run before sending the next set of commands
num_steps = length(u_num);

% Neato interface set-up
starterCodeForBridgeOfDoomQEA2020() 
clear commandsdata;
pub = rospublisher('/raw_vel'); 
currTime = rostime('now');
start = double(currTime.Sec)+double(currTime.Nsec)*10^-9;

for i = 1:num_steps
    driveStepLR(pub, step_len-delay,VL_num(i),VR_num(i)); 
        % custom fuction that sends motor values for given period of time
    
    % records timestamp and motor values sent for later plotting
    currTime = rostime('now');
    currTime = double(currTime.Sec)+double(currTime.Nsec)*10^-9;
    elapsedTime = double(currTime - start);
    commandsdata(i,:) = [elapsedTime VL_num(i) VR_num(i)];
    commandsdata(i,:)
end
save('commandsdata.mat', 'commandsdata') % saves for later plotting
driveStepLR(pub, step_len,0,0); % stops robot