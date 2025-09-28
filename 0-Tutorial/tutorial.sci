clc // limpar console
clear // limpar variáveis
// help(função) abre biblioteca


/*
bloco de comentário
*/


soma = 41+86
subtração = 67-32
multiplicação = 23*54
divisão = 78/34
elevado = 2^3;
%pi // pi


disp(%pi); //printar

////////////////////////////////////////////
// Vetores e Matrizes

// Vetor linha
v = [1 2 3 4 5];

// Vetor coluna
vc = [1; 2; 3; 4; 5];

// Matriz 2x3
M = [1 2 3; 4 5 6];

// Acessando elementos
x = v(3);     // terceiro elemento do vetor v
y = M(2,3);   // elemento da linha 2, coluna 3

// Operações com vetores/matrizes
A = [1 2; 3 4];
B = [5 6; 7 8];

// Soma e subtração
C = A + B;
D = A - B;

// Multiplicação matricial
E = A * B;

// Multiplicação elemento a elemento
F = A .* B;

// Potência elemento a elemento
G = A .^ 2;

////////////////////////////////////////////
//Intervalos

t = 0:0.5:5;  // de 0 até 5 com passo 0.5
//ou
t = linspace(-2,2,1000) //1000 pontos

////////////////////////////////////////////////

// Gráficos
t = -2:0.1:2;
x = t.^2;
plot(t, x);

// Personalizado

plot(t, x, 'r');      // curva vermelha
xlabel("t");
ylabel("x(t)");
title("Gráfico de x(t) = t^2");
xgrid();


// xgrid() → mostra a grade padrão.

//xgrid(color) → muda a cor da grade (por exemplo, xgrid(5) para azul).

//xgrid(0) → desliga a grade.


///////////////////////////////
// Funções matemáticas
y1 = sin(t); //radianos
y2 = cos(t); //radianos
y3 = exp(t); //radianos
y4 = log(t);   // log natural

y5 = sind(t); // graus, coloque d no final
/////////////////////////////////
//Estruturas de controle

//Laços
for i = 1:5
    disp(i)
end
/////////////
i = 1;
while i <= 5
    disp(i)
    i = i + 1;
end

// Condicioanl
x = 10;
if x > 5 then
    disp("Maior que 5");
else
    disp("Menor ou igual a 5");
end
////////////////////////////////////
//Funções

function y = quadrado(x)
    y = x.^2;
endfunction

quadrado(5)   // retorna 25

