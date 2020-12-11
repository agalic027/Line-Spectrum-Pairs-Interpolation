function extrapolated = crossfade_window(left, right, alpha)
% Compute weighted average of two signals 
%
% extrapolated = CROSSFADE_WINDOW(left, right, alpha)
%
% Used to average left-hand and right-hand extrapolations
% Parameter alpha controls the steepness of crossfading window

    if numel(left) ~= numel(right)
        error('Can only crossfade signals of the same length')
    end
    
    u = 1 : numel(left);
    u = u' / numel(left);
    
    w = zeros(size(u));
    for n = 1 : length(u)
        if u(n) <= 0.5
            w(n) = 1 - 0.5 * (2 * u(n)) ^ alpha;
        else
            w(n) = 0.5 * (2 - 2 * u(n)) ^ alpha;
        end
    end

    extrapolated = left .* w + right .* (1 - w);
    
end

