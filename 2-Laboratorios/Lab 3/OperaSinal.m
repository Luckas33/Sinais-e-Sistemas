function OperaSinal(x,Ix,y,Iy)
  syms t;
  F = figure(1);
  set(F,'name','OPERAÇÕES BÁSICAS COM SINAIS CONTÍNUOS');
  subplot(211)
  ezplot(x,Ix);
  title('x(t)');
  axis equal; grid on;

  subplot(212)
  ezplot(y,Iy);
  title('y(t)');
  axis equal; grid on;
end

