function fig = plotcompare(X, Y1, Y2, varargin)
%PLOTCOMPARE Plot two sets of y-values with the same posix time x-values
%   param X: vector of posix time x-values
%   param Y1: first corresponding vector of y-values
%   param Y2: second corresponding vector of y-values
%   opt. param: name of Y1
%   opt. param: name of Y2
%   opt. param: colormap to be used
%   param fig: resulting figure

    assert((length(X) == length(Y1)) && (length(X) == length(Y2)))

    p = inputParser;
    p.addOptional('nameY1', 'Y1', @(x) (isstring(x) || ischar(x)))    
    p.addOptional('nameY2', 'Y2', @(x) (isstring(x) || ischar(x)))
    p.addOptional('colormap', 'colormap.mat', @(x) (isstring(x) || ischar(x)))
    p.parse(varargin{:});
    
	X = posix2datetime(X);
    load(p.Results.colormap)
    set(groot, 'defaultAxesFontSize',24);
    set(groot, 'defaultLineLineWidth',2.0);
    set(groot, 'defaulttextinterpreter','latex')
    set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
    set(groot, 'defaultLegendInterpreter','latex');
    set(groot, 'DefaultLegendFontSize',6);

    fig = figure;
    fig.Position = [2 32 1060 500];
    hold on
    f(1) = plot(X, Y1, '--', 'color', cc(1,:,:), 'DisplayName', p.Results.nameY1);
    f(2) = plot(X, Y2, '-', 'color', cc(3,:,:), 'DisplayName', p.Results.nameY2);
    hold off
    ylabel('Air temperature in $^{\circ}$C')    
    box on
    legend(f(:), 'location', 'north','Orientation', 'vertical', 'Box', 'off', 'NumColumns', 2);
end

