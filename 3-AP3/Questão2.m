% ============================================================
% PROVA 3 - SINAIS E SISTEMAS
% ATIVIDADE 2: Efeito do Tempo de Amostragem (T)
% ============================================================

clear all; close all; clc;
pkg load control; % Carrega pacote de controle

fprintf('=== ATIVIDADE 2: ANÁLISE DE FREQUÊNCIA E AMOSTRAGEM ===\n\n');

% ------------------------------------------------------------
% 1. DEFINIÇÃO DO SISTEMA DISCRETO G(z)
% Equação: y(k) - 1.238y(k-1) + 0.3016y(k-2) = 0.03175u(k-1) + 0.03175u(k-2)
% ------------------------------------------------------------

% Coeficientes
num_d = [0, 0.03175, 0.03175];   % Numerador (z)
den_d = [1, -1.238, 0.3016];     % Denominador (z)

fprintf('a) Função de Transferência Discreta G(z) [Genérica]:\n');
Gz_generic = tf(num_d, den_d, -1);
disp(Gz_generic);

% ------------------------------------------------------------
% 2. CONVERSÃO PARA TEMPO CONTÍNUO (Tustin)
% ------------------------------------------------------------
fprintf('\nc) Obtendo G(s) via Tustin para diferentes T:\n');

% --- CASO 1: T = 0.1 s ---
T1 = 0.1;
Gz_1 = tf(num_d, den_d, T1);
Gs_1 = d2c(Gz_1, 'tustin');
fprintf('\n--- Para T = 0.1 s ---\n');
fprintf('G1(s) = \n');
disp(Gs_1);

% --- CASO 2: T = 1.0 s ---
T2 = 1.0;
Gz_2 = tf(num_d, den_d, T2);
Gs_2 = d2c(Gz_2, 'tustin');
fprintf('\n--- Para T = 1.0 s ---\n');
fprintf('G2(s) = \n');
disp(Gs_2);

% ------------------------------------------------------------
% 3. SIMULAÇÃO E COMPARAÇÃO
% ------------------------------------------------------------
fprintf('\nd) Gerando gráficos e comparando dados...\n');

N_amostras = 60;
k = 0:N_amostras-1;
u = ones(size(k)); % Degrau unitário

% CÁLCULO DA RESPOSTA DISCRETA
% Note que usamos os MESMOS coeficientes para calcular y_disc1 e y_disc2
y_disc1 = filter(num_d, den_d, u);
y_disc2 = filter(num_d, den_d, u);

% Verificação de igualdade numérica
diferenca = norm(y_disc1 - y_disc2);
fprintf('\n--- VERIFICAÇÃO DE IGUALDADE ---\n');
if diferenca < 1e-10
    fprintf('RESULTADO: Os valores discretos de saída y(k) são IDÊNTICOS para T=0.1 e T=1.0.\n');
    fprintf('Isso confirma que a diferença nos gráficos é apenas a escala do eixo TEMPO.\n');
else
    fprintf('ALERTA: Os valores são diferentes (Erro).\n');
end

% Eixos de tempo (Aqui está a diferença visual!)
t1_disc = k * T1;
t2_disc = k * T2;

% Simulação Contínua (para plotagem suave)
t1_cont = linspace(0, t1_disc(end), 1000);
t2_cont = linspace(0, t2_disc(end), 1000);
y1_cont = step(Gs_1, t1_cont);
y2_cont = step(Gs_2, t2_cont);

% --- PLOTAGEM ---
figure(1);

% Subplot 1
subplot(2,1,1);
plot(t1_disc, y_disc1, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'G(z) Discreto');
hold on;
plot(t1_cont, y1_cont, 'b-', 'LineWidth', 2, 'DisplayName', 'G1(s) Contínuo');
hold off;
grid on;
title(['Caso 1 (T=' num2str(T1) 's): Estabiliza em aprox. ' num2str(t1_disc(end)) 's']);
xlabel('Tempo (s)'); ylabel('Amplitude');
legend('Location', 'southeast');

% Subplot 2
subplot(2,1,2);
plot(t2_disc, y_disc2, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'G(z) Discreto');
hold on;
plot(t2_cont, y2_cont, 'r-', 'LineWidth', 2, 'DisplayName', 'G2(s) Contínuo');
hold off;
grid on;
title(['Caso 2 (T=' num2str(T2) 's): Estabiliza em aprox. ' num2str(t2_disc(end)) 's']);
xlabel('Tempo (s)'); ylabel('Amplitude');
legend('Location', 'southeast');

% ------------------------------------------------------------
% 4. SALVAR RESULTADOS (IGUAL À QUESTÃO 1)
% ------------------------------------------------------------
% Salva as variáveis principais para você comparar no Workspace
save('resultados_atividade2.mat', 'Gs_1', 'Gs_2', 'y_disc1', 'y_disc2', 't1_disc', 't2_disc');
fprintf('\nResultados salvos em ''resultados_atividade2.mat''\n');
