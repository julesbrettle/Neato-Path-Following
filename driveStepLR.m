function output = driveStepLR(pub, step_len,Lspeed, Rspeed)
    msg = rosmessage(pub);
    msg.Data = [Lspeed, Rspeed];
    send(pub, msg);
    start_step = rostime('now'); 
    while 1
        pause(0.01);
        current = rostime('now');
        elapsed = current - start_step; 
        if elapsed.seconds > step_len
            break
        end
    end
end