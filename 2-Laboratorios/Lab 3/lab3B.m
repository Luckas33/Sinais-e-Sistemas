close all; clear; clc;
pkg load symbolic;
syms t;

% sinal original
x = heaviside(t) - heaviside(t-1) + (-t+2)*(heaviside(t-1)-heaviside(t-2));

% transformação: -(1/2)*x(-(1/3)*t + 2) - 1
y = -(1/2) * subs(x, t, -(1/3)*t + 2) - 1;

% exibir
OperaSinal(x,[-4 4],y,[-4 4]);
