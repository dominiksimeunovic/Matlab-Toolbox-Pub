function [Y, X] = simulate(ssm, time, U, X0)
%SIMULATE Simulate a state-space model
%   param ssm: the state-sapce model
%   param time: vector of timestamps
%   param U: the corresponding inputs
%   param X0: initial states
%   param Y: the simulated resulting outputs
%   param X: the corresponding siumulated states

    [Y, ~, X] = lsim(ssm, U, time, X0);
end

