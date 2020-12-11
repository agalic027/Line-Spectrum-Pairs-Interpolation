function audio_spectrogram(y,fs,figure_title)
% Simple function to view spectrograms with pre-set parameters fit
% for audio signals

      N = 2 ^ 10 - 1;
      window_size = 20 * fs / 1000;
      hop_factor = 4;
      hop_size = round(window_size / hop_factor);
      noverlap = window_size - hop_size;
       
      figure();
      spectrogram(y, hann(window_size), ...
                noverlap, N, fs, 'yaxis');
      title(figure_title)

end

