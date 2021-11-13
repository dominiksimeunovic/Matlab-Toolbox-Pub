function dssm = discretize(cssm, Ts)
%DISCRETIZE Summary of this function goes here
%   Detailed explanation goes here
    if (cssm.Ts<=0)
        dssm = c2d(cssm, Ts, 'foh');
    end
end

