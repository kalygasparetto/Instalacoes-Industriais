clc;
clear;

%Valores do escoamento
    %Gravidade
    g=9.8;
    %Densidade do fluido
    ro=1000;
    %Pressao absoluta no ponto de saida
    P1=1e5;
    %Velocidade no ponto de saida
    V1=0;
    %Altura no ponto de saida
    z1=0;
    %Pressao absoluta no ponto de chegada
    P2=1e5;
    %Velocidade no ponto de chegada
    V2=0;
    %Altura no ponto de chegada
    z2=10*(0.3048);
    %Fator de atrito
    f=0.02;
    %Somatorios dos k's de perda de carga dos acessorios de tubulação
    K=3;
    %Comprimento da tubulação
    L=200*(0.3048);
    %Diametro interno da tubulação
    Id=6*(0.0254);

%Valores do Rotor
    %Velocidade angular rad/s
    w=261.8;
    %Raio menor do rotor
    r1=3e-2;
    %Raio maior do rotor
    r2=10.8e-2;
    %Espessura do rotor em r1
    b1=11e-3;
    %Espessura do rotor em r2
    b2=5e-3;
    %Angulo da pá em r1;
    beta1=44;
    %Angulo da pá em r2;
    beta2=30;
    %Eficiencia da bomba
    efic=0.75;

%Passo de avanço da vazão
pQ=0.001;

%Valor limite da vazão volumetrica para plotagem dos gráficos
Qmax=0.1;

vazao = [];
escoamento = [];

%Curva do escoamento
for Q=0:pQ:Qmax
  He=(P2-P1)./(ro.*g) + ((V2.*V2)-(V1.*V1))./(2.*g) + (z2-z1) + ( ( (f.*L./Id + K)./(2.*g) ) .* ( 1./power(pi.*power(Id./2,2),2)  ) ).* power(Q,2);

  vazao = [vazao, Q];
  escoamento = [escoamento, He];
endfor

subplot(4, 1, 1);
plot(vazao, escoamento);
hold on;
title('Vazão X Diferentes Raios 2');
xlabel('Vazão volumetrica');
ylabel('Head');

subplot(4, 1, 2);
hold on;
title('Vazão X Diametro');
xlabel('Vazão');
ylabel('Diametro');

subplot(4, 1, 3);
plot(vazao, escoamento);
hold on;
title('Vazão para diferentes velocidades angulares');
xlabel('Vazão volumetrica');
ylabel('Head');

subplot(4, 1, 4);
hold on;
title('Vazão X Velocidade angular (RPM)');
xlabel('Vazão');
ylabel('Velocidade angular (RPM)');

i = 0;
#Vazao x diferentes raios 2 e vazao x diametro
while i < 5
  i = i + 1;

  vazao = [];
  rotor = [];
  diametro = [];

  %Raio maior do rotor
  r2 = input("Digite o raio 2 em metros: ");

  %Curva do Rotor da bomba
  for Q=0:pQ:Qmax
    Hr=(1./g) .* ((r2.*w.*(r2.*w-Q./(2.*pi.*r2.*b2.*tan(beta2.*pi./180)))) - (r1.*w.*(r1.*w-Q./(2.*pi.*r1.*b1.*tan(beta1.*pi./180)))));

    vazao = [vazao, Q];
    rotor = [rotor, Hr];
  endfor

  subplot(4, 1, 1);
  plot(vazao, rotor);
  hold on;

  %Calculando ponto de encontro das curvas
  QEnc=0;
  Q=0;
  while (Q<=Qmax)
    He=(P2-P1)/(ro*g) + (V2*V2-V1*V1)/(2*g) + (z2-z1) + ( (f*L/Id + K)/(2*g) ) * ( 1/power(pi*power(Id/2,2),2) ) * power(Q,2);
    Hr=(1/g) * ((r2*w*(r2*w-Q/(2*pi*r2*b2*tan(beta2*pi/180)))) - (r1*w*(r1*w-Q/(2*pi*r1*b1*tan(beta1*pi/180)))));
    dist=He-Hr;
    if abs (dist) <  1e-1
      hEnc=Hr;
      QEnc=Q;
      break
    endif
    Q=Q+pQ/10;
  endwhile

  %Calculo da potencia consumida pela bomba
  Pot=ro*g*QEnc*hEnc/efic;

  printf("Vazão do rotor, a esta velocidade angular, no sistema:");disp(QEnc);
  printf("Potencia consumida pela bomba, a esta velocidade angular, no sistema:");disp(Pot);
  diametro = r2 * 2;

  subplot(4, 1, 2);
  plot(QEnc, diametro, '*b');
  hold on;
endwhile;


i = 0;
r2 = 10.8e-2;
#Vazão para diferentes velocidades angulares
while i < 5
  i = i + 1;

  vazao = [];
  rotor = [];

  %Raio maior do rotor
  w = input("Digite a velocidade angular em rad/s: ");
  rpm = 9.549296585514 * w;

  %Curva do Rotor da bomba
  for Q=0:pQ:Qmax
    Hr=(1./g) .* (  (r2.*w.*(r2.*w-Q./(2.*pi.*r2.*b2.*tan(beta2.*pi./180)))) - (r1.*w.*(r1.*w-Q./(2.*pi.*r1.*b1.*tan(beta1.*pi./180))))    );

    vazao = [vazao, Q];
    rotor = [rotor, Hr];
  endfor

  subplot(4, 1, 3);
  plot(vazao, rotor);
  hold on;

  %Calculando ponto de encontro das curvas
  QEnc=0;
  Q=0;
  while (Q<=Qmax)
    He=(P2-P1)/(ro*g) + (V2*V2-V1*V1)/(2*g) + (z2-z1) + ( (f*L/Id + K)/(2*g) ) * ( 1/power(pi*power(Id/2,2),2) ) * power(Q,2);
    Hr=(1/g) * (  (r2*w*(r2*w-Q/(2*pi*r2*b2*tan(beta2*pi/180))))  -   (r1*w*(r1*w-Q/(2*pi*r1*b1*tan(beta1*pi/180))))    );
    dist=He-Hr;
    if abs (dist) <  1e-1
      hEnc=Hr;
      QEnc=Q;
      break
    endif
    Q=Q+pQ/10;
  endwhile

  %Calculo da potencia consumida pela bomba
  Pot=ro*g*QEnc*hEnc/efic;

  printf("Vazão do rotor, a esta velocidade angular, no sistema:");disp(QEnc);
  printf("Potencia consumida pela bomba, a esta velocidade angular, no sistema:");disp(Pot);

  subplot(4, 1, 4);
  plot(QEnc, rpm, '*b');
  hold on;
endwhile
