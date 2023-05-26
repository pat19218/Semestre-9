function TRx = trotx(q)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    TRx = [1,0,0,0; 0,cos(q),-sin(q),0; 0,sin(q),cos(q),0; 0,0,0,1];
end

