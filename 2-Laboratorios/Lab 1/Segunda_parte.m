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

%{
3. Manipulação do Áudio com audioplayer
• Reproduzir o áudio nas seguintes variações:
• Execução invertida: Reproduza o sinal ao contrário.
• Duração lenta: Reproduza o áudio em metade da velocidade
original.
• Duração rápida: Reproduza o áudio em dobro da velocidade.
%}

w = flip(y);

sound(w, fs); #Invertida
sound(y, fs/2); #Lenta
sound(y, fs*2); #Rápido

%{
4. Programação de uma Função para Transformações no Sinal
• Escrever uma função em Octave (ou MATLAB) com entrada (x, a, b) e saída y,
onde a saída é dada por: y(n) = x(a * n + b)
• Reproduzir a saída da função com valores de a e b diferentes e observar as
modificações no sinal de entrada.
%}

function y = transformacao(a, b, x)
    n = 1:length(x);
    n_modificado = round(a * n + b);
    n_modificado = n_modificado(n_modificado > 0 & n_modificado <= length(x));
    y = x(n_modificado);
end

y_a = transformacao(-1,600000,y);
y_b = transformacao(0.75,-100000,y);
sound(y,fs);
sound(y_a,fs); # Reverso
sound(y_b,fs); # Lento com atraso

%{
5. Análise das Operações
• Identificar e descrever os efeitos dos parâmetros a e b sobre a variável
independente do sinal:
  • Parâmetro a: Explicar como ele afeta a velocidade de reprodução
  (dilatação ou compressão do tempo).
  • Parâmetro b: Explicar como ele gera um deslocamento no tempo,
  produzindo atraso ou adiantamento no sinal.
%}

%{
Parâmetros (a, b)	Efeito na Saída y	Explicação de Sinais e Sistemas
(2, 0)	Comprimir o sinal pela metade.	A música tocará duas vezes mais rápido (dobro da frequência).
(0.5, 0)	Expandir o sinal pelo dobro.	A música tocará duas vezes mais lento (metade da frequência).
(-1, 0)	Inverter o sinal no tempo.	A música tocará de trás para frente (como você fez com flipud).
(1, -10000)	Atrasar o sinal.	A música começará com 10.000 amostras de atraso (silêncio).

%}




