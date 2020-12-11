function interpolated = lsp_method(y,fs,unknown,p,eta,alpha)
% Performs full interpolation using Line Spectrum Pair Polynomials
%   interpolated = LSP_METHOD(y,fs,blocked,p,eta,alpha)
%
%   y - signal to be interpolated, including the unknown samples
%   fs - signal sample frequency. If unimportant, set to 1
%   unknown - two element vector containing sample number of last known
%   sample in first known part and last unkown sample in the gap
%   p - model order for linear predictive filter
%   eta - weight factor in range from 0 to 1 (Recommended value 0.95) 
%   alpha - steepness of crossfade window (Recommended value 3)
%
%   A. Galic 2020
%
%   Original paper:
%   Esquef, P. (2004). Interpolation of Long Gaps in Audio Signals Using Line
%   Spectrum Pair Polynomials. 

    % assert input data as a column vector
    y = y(:);
    
    % compute number of unknown samples
    t = (0 : length(y) - 1) / fs;
    G = sum(t > unknown(1) & t <= unknown(2));
       
    % find left-side extrapolation
    y_left = y(t <= unknown(1));
    left_extrapolation = lsp_extrapolate ...
        (y_left, G, p, eta, fs);

    % find right-side extrapolation accounting for necessary time reversal
    y_right = y(t > unknown(2));
    right_extrapolation = lsp_extrapolate ...
        (flipud(y_right), G, p, eta, fs);
    right_extrapolation = flipud(right_extrapolation);

    % compute interpolation by crossfading both sided extrapolations
    extrap = crossfade_window(left_extrapolation, ...
        right_extrapolation, alpha);
    interpolated = cat(1, y_left, extrap, y_right);
    

end

