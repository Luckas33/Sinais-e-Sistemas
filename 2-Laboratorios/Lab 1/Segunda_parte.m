clear;
clc;
close all

# Parte 2 - Manipulação de Áudio com MATLAB (Octave ou Scilab)

%{
Objetivo
Este experimento visa utilizar funções de manipulação de áudio em Octave, MATLAB ou
Scilab para ler, reproduzir e modificar um arquivo de áudio. Também serão implementadas
operações de transformação sobre o sinal, com análise dos efeitos das alterações.
%}

%{
Procedimentos
1. Leitura do Arquivo de Áudio
• Colocar o arquivo "Vila.wav" no diretório de trabalho.
• Utilizar a função audioread para ler os dados do arquivo e retornar:
  • Os dados amostrados.
  • A frequência de amostragem (Fs ).
  • O número de bits por amostra (bits)
%}

audio = ('Ela_partiu.wav');

[y,fs] = audioread(audio);

info = audioinfo(audio);

bits = info.BitsPerSample;

disp(['Frequência de amostragem: ', num2str(fs), ' Hz']);
disp(['Bits por amostra: ', num2str(bits)]);


%{
2. Reprodução do Áudio
• Utilizar o comando sound ou audioplayer para reproduzir o arquivo
“Vila.wav".
%}

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








