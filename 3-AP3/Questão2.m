% =========================================================================
% PROVA 3 - SINAIS E SISTEMAS
% ATIVIDADE 2:
% =========================================================================

clear all; close all; clc;

% Carrega o pacote de controle (Essencial no Octave para tf, step, d2c)
pkg load control;

% =========================================================================
% PASSO 1: DEFINIÇÃO DO SISTEMA DISCRETO G(z)
% =========================================================================
% A equação a diferenças original foi reorganizada algebraicamente.
% O termo y(k) que estava na direita (-0.3016) passou para a esquerda
% somando com o 1*y(k), resultando no coeficiente 1.3016.

% Coeficientes do Numerador (z^2, z^1, z^0)
num_d = [-0.03175, 0, 0.03175];

% Coeficientes do Denominador (z^2, z^1, z^0)
den_d = [1.3016, -1.238, 0];

% Criação do objeto de Função de Transferência (Ts = -1 indica indefinido)
Gz = tf(num_d, den_d, -1);

% --- PRINT SOLICITADO: EXIBIR G(z) ANTES DO TUSTIN ---
fprintf('------------------------------------------------------------\n');
fprintf('1. FUNÇÃO DE TRANSFERÊNCIA DISCRETA G(z)\n');
fprintf('   (Obtida da Equação a Diferenças)\n');
fprintf('------------------------------------------------------------\n');

% Método 1: Exibição padrão do objeto
disp('Formato Simbólico:');
Gz

% Método 2: Exibição Manual (Garante que os números apareçam se o disp falhar)
[nz, dz] = tfdata(Gz, 'v');
fprintf('Formato Numérico Explícito:\n');
fprintf('          %.5f z^2 + %.5f\n', nz(1), nz(3));
fprintf('   G(z) = --------------------------\n');
fprintf('          %.5f z^2 - %.5f z\n\n', dz(1), abs(dz(2)));


% =========================================================================
% PASSO 2: CONVERSÃO PARA TEMPO CONTÍNUO (TUSTIN INVERSO)
% =========================================================================
fprintf('------------------------------------------------------------\n');
fprintf('2. CONVERSÃO PARA G(s) VIA TUSTIN (d2c)\n');
fprintf('------------------------------------------------------------\n');

% --- CASO A: Tempo de Amostragem T = 0.1 s ---
T1 = 0.1;
Gz_1 = tf(num_d, den_d, T1);    % Define o T no objeto discreto
Gs_1 = d2c(Gz_1, 'tustin');     % Converte para Contínuo (z -> s)

fprintf('\n>>> Para T = 0.1 s (Sistema Rápido):\n');
[n1, d1] = tfdata(Gs_1, 'v');
fprintf('          %.5f s\n', n1(2));
fprintf('   G1(s) = ----------------------------------\n');
fprintf('          %.5f s^2 + %.5f s + %.5f\n', d1(1), d1(2), d1(3));

% --- CASO B: Tempo de Amostragem T = 1.0 s ---
T2 = 1.0;
Gz_2 = tf(num_d, den_d, T2);    % Define o T no objeto discreto
Gs_2 = d2c(Gz_2, 'tustin');     % Converte para Contínuo (z -> s)

fprintf('\n>>> Para T = 1.0 s (Sistema Lento):\n');
[n2, d2] = tfdata(Gs_2, 'v');
fprintf('          %.5f s\n', n2(2));
fprintf('   G2(s) = ----------------------------------\n');
fprintf('          %.5f s^2 + %.5f s + %.5f\n', d2(1), d2(2), d2(3));


% =========================================================================
% PASSO 3: SIMULAÇÃO DA RESPOSTA AO DEGRAU
% =========================================================================
fprintf('\n------------------------------------------------------------\n');
fprintf('3. GERANDO DADOS E GRÁFICOS...\n');
fprintf('------------------------------------------------------------\n');

% Configuração do vetor de amostras (k)
N = 60;             % Número de amostras
k = 0:N-1;          % Vetor de índices [0, 1, 2 ... 59]
u = ones(size(k));  % Entrada Degrau Unitário (tudo 1)

% CÁLCULO DA RESPOSTA DISCRETA (Filtro Digital)
% O comando filter implementa a equação a diferenças recursiva
y_disc = filter(num_d, den_d, u);

% CÁLCULO DA RESPOSTA CONTÍNUA (Para comparação visual)
% Criamos vetores de tempo com alta resolução para o plot ficar "liso"
t1_axis = k * T1;   % Eixo de tempo para T=0.1
t2_axis = k * T2;   % Eixo de tempo para T=1.0

t1_smooth = linspace(0, t1_axis(end), 1000);
t2_smooth = linspace(0, t2_axis(end), 1000);

% Simula o sistema contínuo recuperado
y1_cont = step(Gs_1, t1_smooth);
y2_cont = step(Gs_2, t2_smooth);


% =========================================================================
% PASSO 4: PLOTAGEM DOS RESULTADOS (3 SUBPLOTS)
% =========================================================================
figure(1);

% --- Subplot 1: A Sequência Digital Pura (Amostras) ---
subplot(3,1,1);
stem(k, y_disc, 'k', 'filled', 'LineWidth', 1); % stem = gráfico de hastes
grid on;
title('1. Sequência Discreta y(k) (Independente do Tempo)');
xlabel('Número da Amostra (k)');
ylabel('Amplitude');
xlim([0 N]);

% --- Subplot 2: Comparação no Tempo Real (T = 0.1s) ---
subplot(3,1,2);
plot(t1_axis, y_disc, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Amostras Digitais');
hold on;
plot(t1_smooth, y1_cont, 'b-', 'LineWidth', 2, 'DisplayName', 'Reconstrução Contínua G1(s)');
hold off;
grid on;
title(['2. Dinâmica Rápida (T = 0.1s)']);
xlabel('Tempo (s)');
ylabel('Amplitude');
legend('Location', 'southeast');
xlim([0 t1_axis(end)]);

% --- Subplot 3: Comparação no Tempo Real (T = 1.0s) ---
subplot(3,1,3);
plot(t2_axis, y_disc, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Amostras Digitais');
hold on;
plot(t2_smooth, y2_cont, 'r-', 'LineWidth', 2, 'DisplayName', 'Reconstrução Contínua G2(s)');
hold off;
grid on;
title(['3. Dinâmica Lenta (T = 1.0s)']);
xlabel('Tempo (s)');
ylabel('Amplitude');
legend('Location', 'southeast');
xlim([0 t2_axis(end)]);

% Salva os resultados para uso posterior
save('resultados_atividade2.mat', 'Gs_1', 'Gs_2', 'y_disc');
fprintf('Concluído! Verifique a Figura 1.\n');
