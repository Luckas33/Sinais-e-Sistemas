% ============================================================
% PROVA 3 - SINAIS E SISTEMAS
% ATIVIDADE 1: Identificação do Motor Lego - Modelos ARX
% ============================================================

clear all; close all; clc;

% Carrega pacote de controle (necessário para tf, d2c, step, etc.)
pkg load control

% 1. CARREGAR DADOS EXPERIMENTAIS
% =================================
load('C:/Users/Lucas Sobral/Documents/Sinais-e-Sistemas/3-AP3/Dados/GrupoRobo_1.mat');  % Carrega z1
y = z1(:,1);               % Saída medida
u = z1(:,2);               % Entrada degrau
N = length(y);             % Número de amostras
Ts = 0.01;                 % Tempo de amostragem (s)

% 2. MODELO DE 1ª ORDEM: y(k) = a1*y(k-1) + b1*u(k-1)
% ====================================================
fprintf('\n=== MODELO DE 1ª ORDEM ===\n');

% Construção da matriz de regressores e vetor de saída
Y1 = y(2:N);                     % y(k) para k=2..N
Phi1 = [y(1:N-1), u(1:N-1)];     % [y(k-1), u(k-1)]

% Estimação por Mínimos Quadrados
theta1 = Phi1 \ Y1;
a1_1 = theta1(1);
b1_1 = theta1(2);

% Cálculo do sinal estimado
y_est1 = zeros(N,1);
y_est1(1) = y(1);                % Condição inicial
for k = 2:N
    y_est1(k) = a1_1*y(k-1) + b1_1*u(k-1);
end

% Erro e MSE
erro1 = y - y_est1;
J1 = (erro1' * erro1) / N;       % MSE

% Exibição dos resultados
fprintf('Parâmetros estimados:\n');
fprintf('  a1 = %.6f\n', a1_1);
fprintf('  b1 = %.6f\n', b1_1);
fprintf('Equação a diferenças:\n');
fprintf('  y(k) = %.4f*y(k-1) + %.4f*u(k-1)\n', a1_1, b1_1);
fprintf('MSE (J1) = %.6f\n\n', J1);

% 3. MODELO DE 2ª ORDEM:
% y(k) = a1*y(k-1) + a2*y(k-2) + b1*u(k-1) + b2*u(k-2)
% ====================================================
fprintf('=== MODELO DE 2ª ORDEM ===\n');

% Construção da matriz de regressores e vetor de saída
Y2 = y(3:N);                     % y(k) para k=3..N
Phi2 = [y(2:N-1), y(1:N-2), u(2:N-1), u(1:N-2)]; % [y(k-1), y(k-2), u(k-1), u(k-2)]

% Estimação por Mínimos Quadrados
theta2 = Phi2 \ Y2;
a1_2 = theta2(1);
a2_2 = theta2(2);
b1_2 = theta2(3);
b2_2 = theta2(4);

% Cálculo do sinal estimado
y_est2 = zeros(N,1);
y_est2(1:2) = y(1:2);            % Condições iniciais
for k = 3:N
    y_est2(k) = a1_2*y(k-1) + a2_2*y(k-2) + b1_2*u(k-1) + b2_2*u(k-2);
end

% Erro e MSE
erro2 = y - y_est2;
J2 = (erro2' * erro2) / N;       % MSE

% Exibição dos resultados
fprintf('Parâmetros estimados:\n');
fprintf('  a1 = %.6f, a2 = %.6f\n', a1_2, a2_2);
fprintf('  b1 = %.6f, b2 = %.6f\n', b1_2, b2_2);
fprintf('Equação a diferenças:\n');
fprintf('  y(k) = %.4f*y(k-1) + %.4f*y(k-2) + %.4f*u(k-1) + %.4f*u(k-2)\n', ...
        a1_2, a2_2, b1_2, b2_2);
fprintf('MSE (J2) = %.6f\n\n', J2);

% 4. GRÁFICO COMPARATIVO
% ======================
t = (0:N-1)*Ts;  % Vetor de tempo

figure(1);
plot(t, y, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Medido (y)');
hold on;
plot(t, y_est1, 'r--', 'LineWidth', 1.2, 'DisplayName', '1ª Ordem Estimado');
plot(t, y_est2, 'b--', 'LineWidth', 1.2, 'DisplayName', '2ª Ordem Estimado');
hold off;
grid on;
xlabel('Tempo (s)');
ylabel('Saída y(k)');
title('Comparação entre Saída Medida e Estimada - Motor Lego');
legend('Location', 'southeast');

% 5. FUNÇÕES DE TRANSFERÊNCIA DISCRETAS
% =====================================
fprintf('=== FUNÇÕES DE TRANSFERÊNCIA DISCRETAS ===\n');

% Modelo de 1ª ordem
fprintf('\n1ª Ordem - G(z):\n');
fprintf('  G₁(z) = %.6f / (z - %.6f)\n', b1_1, a1_1);

% Modelo de 2ª ordem - CORRIGINDO A FORMATAÇÃO
fprintf('\n2ª Ordem - G(z):\n');
fprintf('  G₂(z) = (%.6f z + %.6f) / (z² - %.6f z + %.6f)\n', ...
        b1_2, b2_2, a1_2, -a2_2);  % Note: -a2_2 porque a2_2 é negativo
fprintf('  Forma em potências negativas:\n');
fprintf('  G₂(z) = (%.6f z⁻¹ + %.6f z⁻²) / (1 - %.6f z⁻¹ + %.6f z⁻²)\n', ...
        b1_2, b2_2, a1_2, -a2_2);

% 6. CONVERSÃO PARA TEMPO CONTÍNUO (apenas 2ª ordem)
% ===================================================
fprintf('\n=== CONVERSÃO PARA TEMPO CONTÍNUO (2ª ordem) ===\n');

% Cria o sistema discreto
num_d = [b1_2, b2_2];      % Coeficientes em potências negativas de z
den_d = [1, -a1_2, -a2_2]; % 1 - a1*z^{-1} - a2*z^{-2}

% Converte para contínuo usando d2c (método 'zoh' - zero-order hold)
sys_d = tf(num_d, den_d, Ts);
sys_c = d2c(sys_d, 'zoh');

% Exibe G(s)
[num_c, den_c] = tfdata(sys_c, 'v');
fprintf('G(s) = ');
for i = 1:length(num_c)
    if i == length(num_c)
        fprintf('%.6f', num_c(i));
    else
        fprintf('%.6f s^%d + ', num_c(i), length(num_c)-i);
    end
end
fprintf('\n        -----------------------------------------\n        ');
for i = 1:length(den_c)
    if i == length(den_c)
        fprintf('%.6f', den_c(i));
    else
        fprintf('%.6f s^%d + ', den_c(i), length(den_c)-i);
    end
end
fprintf('\n\n');

% 7. COMPARAÇÃO DE RESPOSTAS AO DEGRAU
% =====================================
fprintf('=== RESPOSTA AO DEGRAU ===\n');

% Degrau unitário discreto
t_disc = t';
u_disc = ones(size(t_disc));

% Resposta do modelo discreto (2ª ordem)
y_disc = lsim(sys_d, u_disc, t_disc);

% Resposta do modelo contínuo
t_cont = linspace(0, t(end), 1000)';
u_cont = ones(size(t_cont));
y_cont = step(sys_c, t_cont);

figure(2);
plot(t_disc, y_disc, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Discreto G(z)');
hold on;
plot(t_cont, y_cont, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Contínuo G(s)');
hold off;
grid on;
xlabel('Tempo (s)');
ylabel('Resposta');
title('Comparação: Resposta ao Degrau - Discreto vs Contínuo (2ª ordem)');
legend('Location', 'southeast');

% 8. VALIDAÇÃO DOS MODELOS
% ========================
fprintf('=== VALIDAÇÃO ===\n');
fprintf('MSE 1ª ordem: %.6f\n', J1);
fprintf('MSE 2ª ordem: %.6f\n', J2);

if J2 < J1
    fprintf('O modelo de 2ª ordem apresenta menor erro (melhor ajuste).\n');
else
    fprintf('O modelo de 1ª ordem apresenta menor erro (melhor ajuste).\n');
end

% 9. SALVAR RESULTADOS
% ====================
save('resultados_atividade1.mat', 'theta1', 'theta2', 'J1', 'J2', 'sys_d', 'sys_c');
fprintf('\nResultados salvos em ''resultados_atividade1.mat''\n');
