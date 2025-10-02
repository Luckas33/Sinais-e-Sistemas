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


%{
4. Programação de uma Função para Transformações no Sinal
• Escrever uma função em Octave (ou MATLAB) com entrada (x, a, b) e saída y,
onde a saída é dada por: y(n) = x(a ⋅ n + b)
• Reproduzir a saída da função com valores de a e b diferentes e observar as
modificações no sinal de entrada.
%}

function y_out = transformacao(a, b, x)
    n = 1:length(x);
    n_modificado = round(a * n + b);
    n_modificado = n_modificado(n_modificado > 0 & n_modificado <= length(x));
    y_out = x(n_modificado);
end

%{
5. Análise das Operações
• Identificar e descrever os efeitos dos parâmetros a e b sobre a variável
independente do sinal:
  • Parâmetro a: Explicar como ele afeta a velocidade de reprodução
  (dilatação ou compressão do tempo).
  • Parâmetro b: Explicar como ele gera um deslocamento no tempo,
  produzindo atraso ou adiantamento no sinal.
%}






