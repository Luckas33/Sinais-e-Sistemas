% Laboratório 1
% PARTE 1

% Frequência angular e em Hz para o seno e cosseno (cálculo está no documento)
w_sin = 0.5*pi;
f_sin = w_sin/(2*pi);

w_cos = 2*pi;
f_cos = w_cos/(2*pi);

disp('--- Parte 1: Frequências ---');
fprintf('Seno: w = %.2f rad/s , f = %.2f Hz\n', w_sin, f_sin);
fprintf('Cosseno: w = %.2f rad/s , f = %.2f Hz\n\n', w_cos, f_cos);

% PARTE 2: Representação do sinal contínuo

t = -1:0.001:1;  % intervalo pedido na questão
z = sin(0.5*pi*t) + cos(2*pi*t) + 1;

figure;
plot(t, z, 'b', 'LineWidth', 1.5);
grid on;
xlabel('t (s)');
ylabel('z(t)');
title('Sinal Contínuo z(t)');

% PARTE 3: Discretização do sinal

Ts = 0.01;        % período de amostragem
n = -100:100;     % índices discretos
t_n = n*Ts;       % tempo discreto

z_n = sin(0.5*pi*t_n) + cos(2*pi*t_n) + 1;

% Frequências no sinal discreto
% Frequência normalizada (ciclos/amostra)
f_sin_d = f_sin*Ts;
f_cos_d = f_cos*Ts;

% Frequência angular normalizada (rad/amostra)
w_sin_d = 2*pi*f_sin_d;
w_cos_d = 2*pi*f_cos_d;

disp('--- Parte 3: Frequências discretas ---');
fprintf('Seno: w = %.2f rad/amostra , f = %.2f ciclos/amostra\n', w_sin_d, f_sin_d);
fprintf('Cosseno: w = %.2f rad/amostra , f = %.2f ciclos/amostra\n\n', w_cos_d, f_cos_d);

% PARTE 4: Representação do sinal discreto

figure;
stem(n, z_n, 'r', 'filled');
grid on;
xlabel('n');
ylabel('z[n]');
title('Sinal Discreto z[n]');

% PARTE 5 e 6: Funções para componente par e ímpar

function xp = parte_par(x)
    xp = (x + fliplr(x)) / 2;
end

function xi = parte_impar(x)
    xi = (x - fliplr(x)) / 2;
end

% PARTE 7: Visualização das componentes

z_par = parte_par(z_n);
z_impar = parte_impar(z_n);

figure('Position', [100 100 1200 600]);

stem(n, z_n, 'k', 'filled'); hold on;
stem(n, z_par, 'b');
stem(n, z_impar, 'r');
stem(n, z_par + z_impar, 'g');
legend('z[n] original', 'Componente Par', 'Componente Ímpar', 'Soma Par+Ímpar');
grid on;
title('Decomposição Par/Ímpar do Sinal z[n]');
xlabel('n');
ylabel('Amplitude');


