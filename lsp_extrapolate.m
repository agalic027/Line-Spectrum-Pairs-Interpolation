function extrapolated = lsp_extrapolate(y, G, p, eta, fs)
% Performs one-sided extrapolation using Line Spectral Pairs method

    N = numel(y);
    Ts = 1 / fs;

    % calculate LPC via Burg's method
    arburg_coeff = arburg(y, p);
    
    % generate palindromic and anti-palindromic polynomial 
    z = tf('z', Ts);
    Az = tf(arburg_coeff, 1, Ts, 'Variable', 'z^-1');
    Ainvz = tf(fliplr(arburg_coeff), 1, Ts, 'Variable', 'z');
    P = Az + z ^ (-p - 1) * Ainvz;
    Q = Az - z ^ (-p - 1) * Ainvz;
    
    % calculate weighted line spectral pair
    D = eta * P + (1 - eta) * Q;
    wlsp = 1/D; 
    extrap = cat(1, y, zeros(G, 1));
    
    % apply WLSP filter as moving average in order to save internal state
    A = wlsp.Denominator{1};
    [~, zf]  =  filter...
        (-[0 A(2 : end)], 1, extrap(1 : N));
    
    % apply WLSP filter as-is excited by previously determined internal
    % states
    extrap(N+1:end)  =  filter...
        ([0 0], -A, zeros(G,1), zf);
    
    % return only extrapolated part
    extrapolated = extrap(N + 1 : end);
    
end

