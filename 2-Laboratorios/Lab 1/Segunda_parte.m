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


N_plot = 500;

% Verifica se o sinal tem 2 canais (estéreo)
if size(y, 2) == 2

    % --- Figura 1: Canal 1 (Esquerdo) ---
    figure(1); % Abre a primeira janela de gráfico
    stem(y(1:N_plot, 1));
    title('Canal 1 (Esquerdo) - y_L[k]');
    xlabel('Índice da Amostra (k)');
    ylabel('Amplitude');
    grid on;

    % --- Figura 2: Canal 2 (Direito) ---
    figure(2); % Abre a segunda janela de gráfico
    stem(y(1:N_plot, 2));
    title('Canal 2 (Direito) - y_R[k]');
    xlabel('Índice da Amostra (k)');
    ylabel('Amplitude');
    grid on;

    disp('Os dois canais foram plotados em janelas de figura separadas (Figura 1 e Figura 2).');

elseif size(y, 2) == 1

    % Se for mono, plota apenas a figura 1
    figure(1);
    stem(y(1:N_plot));
    title('Sinal Mono - y[k]');
    xlabel('Índice da Amostra (k)');
    ylabel('Amplitude');
    grid on;
    disp('O sinal é mono (1 canal). Plotado na Figura 1.');

else
    disp('O sinal tem um número de canais inesperado. Plotagem interrompida.');
    disp(['Número de canais detectados: ' num2str(size(y, 2))]);
end

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

sound(y, fs); #Invertida
sound(y, fs/2); #Lenta
sound(y, fs*2); #Rápido







