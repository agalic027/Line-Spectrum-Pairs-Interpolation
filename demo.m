close all

[data, fs] = audioread('samples/audio_original.wav');
data = data(1 : round(length(data) / 3));
audio_spectrogram(data, fs, 'Original Signal')

t = (0 : length(data) - 1) /fs;
damaged = [0.4; 0.45];
damaged_data = data;
damaged_data(t > damaged(1) & t < damaged(2)) = 1e-18;
audio_spectrogram(damaged_data, fs, 'Damaged Signal')

audiowrite('samples/audio_damaged.wav', damaged_data, fs);

model_order = 1000;
eta = 0.95;
alpha = 3;
interpolated_data = lsp_method ...
    (damaged_data, fs, damaged, model_order, eta, alpha);
audio_spectrogram(interpolated_data, fs,['LSP \eta= ' num2str(eta) ', p= ' num2str(model_order)])

audiowrite('samples/audio_interpolated.wav', interpolated_data, fs);
