function [time, U, Y, X0, Ts] = loadData(path)
%LOADDATA Load data from file
%   param path: path where the data is stored
%   param time: vector of timestamps (posix time)
%   param U: the corresponding inputs
%   param Y: the corresponding outputs
%   param X0: assumtion for inital states
%   param Ts: sample time in seconds

    data = load(path);
    time = data.time;
    U = [data.Phi.heater,data.phi.global,data.T.amb];
    Y = data.T.air;
    X0 = [data.T.air(1)]; 
    Ts = 3600;
end

