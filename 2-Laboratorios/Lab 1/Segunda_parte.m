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

%{
3. Manipulação do Áudio com audioplayer
• Reproduzir o áudio nas seguintes variações:pp
• Execução invertida: Reproduza o sinal ao contrário.
• Duração lenta: Reproduza o áudio em metade da velocidade
original.
• Duração rápida: Reproduza o áudio em dobro da velocidade.
%}

sound(y, fs); #Invertida
sound(y, fs/2); #Lenta
sound(y, fs*2); #Rápido







