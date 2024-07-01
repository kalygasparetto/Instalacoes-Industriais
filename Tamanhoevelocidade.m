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

%Curva do escoamento
for Q=0:pQ:Qmax
  He=(P2-P1)./(ro.*g) + ((V2.*V2)-(V1.*V1))./(2.*g) + (z2-z1) + ( ( (f.*L./Id + K)./(2.*g) ) .* ( 1./power(pi.*power(Id./2,2),2)  ) ).* power(Q,2);
  plot(Q,He); hold on;
endfor

%Curva do Rotor da bomba
for Q=0:pQ:Qmax
  Hr=(1./g) .* (  (r2.*w.*(r2.*w-Q./(2.*pi.*r2.*b2.*tan(beta2.*pi./180))))  -   (r1.*w.*(r1.*w-Q./(2.*pi.*r1.*b1.*tan(beta1.*pi./180))))    );
  plot(Q,Hr);
endfor

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
xlabel('Vazao volumetrica');ylabel('Head');
