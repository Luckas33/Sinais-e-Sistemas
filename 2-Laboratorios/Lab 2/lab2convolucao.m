close all; clear; clc;

% ----------------------------------------------------------
% PARTE 1 - Convolucão de dois sinais contínuos
% ----------------------------------------------------------
% x(t) = e^(-a*t)u(t)
% h(t) = sin(a*t)u(t)
% a = número da equipe
% ----------------------------------------------------------

a = 9; % Coloquei o número 9 , para ser sincero professor eu
       % não entendi como eu sabia qual era o número da minha equipe.
       % A gente escolheu a ordem de envio, até o momento fomos a nona equipe

t = -1:0.01:5;
u = (t >= 0);

x = exp(-a*t) .* u;
h = sin(a*t) .* u;

figure(1);
plot(t,x,'LineWidth',2);
title('Sinal x(t) = e^{-a t}u(t)');
xlabel('Tempo (s)'); ylabel('Amplitude'); grid on;

figure(2);
plot(t,h,'r','LineWidth',2);
title('Sinal h(t) = sin(a t)u(t)');
xlabel('Tempo (s)'); ylabel('Amplitude'); grid on;

% Convolução y(t) = x(t) * h(t)
y = conv(x,h)*0.01;
t_conv = 2*min(t):0.01:2*max(t);

figure(3);
plot(t_conv, y, 'k', 'LineWidth', 2);
title('Convolução y(t) = x(t) * h(t)');
xlabel('Tempo (s)'); ylabel('Amplitude'); grid on;

% ----------------------------------------------------------
% PARTE 2 - Verificação das propriedades
% ----------------------------------------------------------

% ===== COMUTATIVIDADE =====
y1 = conv(x,h)*0.01;
y2 = conv(h,x)*0.01;

figure(4);
plot(t_conv, y1, 'b', 'LineWidth', 2); hold on;
plot(t_conv, y2, '--r', 'LineWidth', 2);
title('Propriedade da Comutatividade: x*h = h*x');
xlabel('Tempo (s)'); ylabel('Amplitude'); grid on;
legend('x*h','h*x');


% ----------------------------------------------------------
% DISTRIBUTIVIDADE
% x(t) = p(t) (pulso)
% h(t) = u(t) - u(t-5)
% g(t) = r(t) (rampa)
% ----------------------------------------------------------

t = -1:0.01:6;
u = (t >= 0);
p = (t >= 0) - (t >= 1);
r = t .* (t >= 0);

x = p;
h = (t >= 0) - (t >= 5);
g = r;

% Convoluções
y1 = conv(x, h + g) * 0.01;
y2 = conv(x,h)*0.01 + conv(x,g)*0.01;

t_conv = 2*min(t):0.01:2*max(t);

figure(5);
plot(t_conv, y1, 'b', 'LineWidth', 2); hold on;
plot(t_conv, y2, '--r', 'LineWidth', 2);
title('Propriedade da Distributividade: x*(h+g) = x*h + x*g');
xlabel('Tempo (s)'); ylabel('Amplitude'); grid on;
legend('x*(h+g)','x*h + x*g');

disp('Propriedades verificadas com sucesso!');
disp('Os gráficos mostram que:');
disp('- x*h e h*x resultam no mesmo sinal (comutatividade)');
disp('- x*(h+g) e x*h + x*g resultam no mesmo sinal (distributividade)');


