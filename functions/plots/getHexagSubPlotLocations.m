function [subplotLocs] = getHexagSubPlotLocations(s,b)

% [subplotLocs] = getHexagSubPlotLocations(s,b)
%
% Returns subplot parameters for hexagonal placement of plots. Input s
% controls the proportional size of each individual subplot within the larger
% plot, and input b controls the border size between plots.
%
% Note that these values were found by hand-tuning and they *TEND* to look
% good. This could certainly be made more flexible/intelligent.

if nargin<1 || isempty(s)
    s = 0.25;
end
if nargin<2 || isempty(b)
    b = 0.1;
end

subplotLocs = [ s/2+b s*2+2*b-.005 s s; ...
    (s/2)+s+2*b s*2+2*b-.005 s s; ...
    
    4*b/5     s+5*b/4 s s; ...
    s+8*b/5+0.002    s+5*b/4 s s; ...
    2*s+5*b/2 s+5*b/4 s s; ...
    
    s/2+b b/2 s s; ...
    (s/2)+s+2*b b/2 s s;];
