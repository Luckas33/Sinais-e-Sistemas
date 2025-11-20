clear; clc; close all;
pkg load control

% --- CONFIGURAÇÃO ---
% Mude o nome do arquivo aqui para rodar para outros grupos
nome_arquivo = 'GrupoRobo_1.mat';

% Definindo variáveis globais para a função de custo MSE enxergar
global tempo_global u_degrau_global ym_global

%% 1. CARREGAMENTO E PREPARAÇÃO DOS DADOS
fprintf('Processando arquivo: %s\n', nome_arquivo);
dados_carregados = load(nome_arquivo);

% O arquivo contém uma variável (geralmente 'z', 'z1' ou similar).
% O código abaixo detecta o nome da variável automaticamente.
nomes_vars = fieldnames(dados_carregados);
data = dados_carregados.(nomes_vars{1});

% A coluna 1 é a Saída (Rotação) e a coluna 2 é a Entrada (Potência) [cite: 233]
ym = data(:,1);      % Saída medida y_m(t)
u_sinal = data(:,2); % Entrada u(t)

% Criação do vetor de tempo (T = 0.01s) [cite: 234]
T = 0.01;
tempo = (0:length(ym)-1)' * T;

% Determinar a amplitude do degrau de entrada (média dos valores > 0)
u_degrau = mean(u_sinal(u_sinal > 5)); % Filtra ruído de zero

% Atualiza globais
tempo_global = tempo;
u_degrau_global = u_degrau;
ym_global = ym;

%% 2. TÉCNICA 1: ESTIMAÇÃO ANALÍTICA (GRÁFICA)
% Baseado nos picos e regime estacionário [cite: 185]

% A. Ganho estático (K)
% K = valor final da saída / valor do degrau de entrada
y_final = mean(ym(end-50:end)); % Média dos últimos pontos para estabilidade
K_analitico = y_final / u_degrau;

% B. Identificação do Pico (Máximo)
[y_max, idx_max] = max(ym);
tp = tempo(idx_max); % Tempo de pico

% C. Sobressinal (Mp) e Fator de Amortecimento (zeta)
% Mp = (ymax - yfinal) / yfinal [cite: 181]
Mp_decimal = (y_max - y_final) / y_final;

% Cálculo de zeta isolado da equação do sobressinal [cite: 105]
zeta_analitico = -log(Mp_decimal) / sqrt(pi^2 + (log(Mp_decimal))^2);

% D. Frequência Natural (wn)
% tp = pi / (wn * sqrt(1 - zeta^2)) -> isolando wn
wn_analitico = pi / (tp * sqrt(1 - zeta_analitico^2));

fprintf('\n--- Resultados Técnica 1 (Analítica) ---\n');
fprintf('K (Ganho): %.4f\n', K_analitico);
fprintf('Zeta (Amortecimento): %.4f\n', zeta_analitico);
fprintf('Wn (Freq. Natural): %.4f rad/s\n', wn_analitico);

% Gera a curva da técnica 1 para comparação
y_tec1 = subamortecido(tempo, u_degrau, K_analitico, zeta_analitico, wn_analitico);

%% 3. TÉCNICA 2: OTIMIZAÇÃO NUMÉRICA (fminsearch)
% Minimiza o erro quadrático médio [cite: 219, 227]

% Chute inicial (p0) vem da Técnica 1 para garantir convergência [cite: 230]
p0 = [K_analitico, zeta_analitico, wn_analitico];

% Configura opções para mostrar iterações (opcional)
options = optimset('Display', 'iter', 'TolX', 1e-6);

fprintf('\n--- Iniciando Otimização Numérica (fminsearch) ---\n');
p_otimo = fminsearch('MSE', p0, options);

K_otimo = p_otimo(1);
zeta_otimo = p_otimo(2);
wn_otimo = p_otimo(3);

fprintf('\n--- Resultados Técnica 2 (Numérica) ---\n');
fprintf('K (Ganho): %.4f\n', K_otimo);
fprintf('Zeta (Amortecimento): %.4f\n', zeta_otimo);
fprintf('Wn (Freq. Natural): %.4f rad/s\n', wn_otimo);

% Gera a curva da técnica 2
y_tec2 = subamortecido(tempo, u_degrau, K_otimo, zeta_otimo, wn_otimo);

%% 4. FUNÇÕES DE TRANSFERÊNCIA [cite: 238]
% Modelo: G(s) = (K * wn^2) / (s^2 + 2*zeta*wn*s + wn^2) [cite: 154]

s = tf('s');

G_analitico = (K_analitico * wn_analitico^2) / (s^2 + 2*zeta_analitico*wn_analitico*s + wn_analitico^2);
G_otimo = (K_otimo * wn_otimo^2) / (s^2 + 2*zeta_otimo*wn_otimo*s + wn_otimo^2);

fprintf('\nFunção de Transferência (Técnica 1):\n');
disp(G_analitico);
fprintf('Função de Transferência (Técnica 2):\n');
disp(G_otimo);

%% 5. PLOTAGEM E VALIDAÇÃO [cite: 236]

figure('Position', [100 100 1000 600]);
plot(tempo, ym, 'k', 'LineWidth', 1.5, 'DisplayName', 'Dados Medidos (Real)');
hold on;
plot(tempo, y_tec1, 'b--', 'LineWidth', 2, 'DisplayName', 'Técnica 1 (Analítica)');
plot(tempo, y_tec2, 'r-.', 'LineWidth', 2, 'DisplayName', 'Técnica 2 (Otimizada)');
grid on;
xlabel('Tempo (s)');
ylabel('Rotação (Graus)');
title(['Identificação do Sistema Motor LEGO - ' nome_arquivo]);
legend('Location', 'Best');

% Validação de Critério (Erro Final) [cite: 237]
mse_tec1 = mean((ym - y_tec1).^2);
mse_tec2 = mean((ym - y_tec2).^2);

dim = [.55 .1 .3 .3];
str = {['MSE Tec 1: ' num2str(mse_tec1, '%.2f')], ...
       ['MSE Tec 2: ' num2str(mse_tec2, '%.2f')]};
annotation('textbox',dim,'String',str,'FitBoxToText','on', 'BackgroundColor', 'white');

fprintf('MSE Técnica 1: %.4f\n', mse_tec1);
fprintf('MSE Técnica 2: %.4f\n', mse_tec2);
