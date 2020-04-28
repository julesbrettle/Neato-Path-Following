%clc, clear all
load vlvr.mat
starterCodeForBridgeOfDoomQEA2020()

step_len = u_num(2) - u_num(1);
num_steps = length(u_num);

clear commandsdata_delay;
pub = rospublisher('/raw_vel');

currTime = rostime('now');
start = double(currTime.Sec)+double(currTime.Nsec)*10^-9;

for i = 1:num_steps
    driveStepLR(pub, step_len,VL_num(i),VR_num(i));
    tic()
    currTime = rostime('now');
    currTime = double(currTime.Sec)+double(currTime.Nsec)*10^-9;
    elapsedTime = double(currTime - start);
    elapsedTime/i
    commandsdata_delay(i,:) = [elapsedTime VL_num_adj(i) VR_num_adj(i)];
    commandsdata_delay(i,:)
    toc()
end
save('commandsdata_delay.mat','commandsdata_delay')
driveStepLR(pub, step_len,0,0);