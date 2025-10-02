clear;
clc;
close all

audio = ('Ela_partiu.wav');

[y,fs] = audioread(audio);

info = audioinfo(audio);

bits = info.BitsPerSample;

disp(['Frequência de amostragem: ', num2str(fs), ' Hz']);
disp(['Bits por amostra: ', num2str(bits)]);

sound(y,fs);

w = flip(y)

sound(w, fs);

sound(y, fs/2);

sound(y, fs*2);

function y_out = transformacao(a, b, x)
    n = 1:length(x);
    n_modificado = round(a * n + b);p
    n_modificado = n_mod(n_mod p> 0 & n_mod <= length(x));
    y_out = x(n_mod);
end








