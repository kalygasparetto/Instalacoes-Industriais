clc;
clear all;

% Dados do sistema - Sistema Internacional de Unidades
Q = 0.0252;
Di= 0.1016;
Mi = 1e-3;
ro = 1000;
Rug = 5e-4;
PvH2O = 3.169e3;
L = 3.20;
g = 9.8;
Patm = 1e5;
z1 = 1.22;
z2 = 0;

% Dados da perda de carga
K1 = 0.3;
K2 = 0.5;
K3 = 6;

% Calculo da velocidade
V = Q / (3.1416*Di*Di/4);

% Calculo do numero de Reynolds
Re = ro*V*Di/Mi;

% Calculo da rugosidade relativa
EpisODi = Rug/Di;

    % Calculo do fator de atrito
    C1s = sqrt(10)/10;
    C2s = 2.51/Re;
    C3s = (EpisODi)/3.7;
    f = @(x) C1s**x - C2s*x - C3s;
    x = fzero(f,0);
    Efe = 1/(x*x);

NPSH = (Patm-PvH2O)/(ro*g) + (z1 - z2) - ( Efe*L/Di + (3*K1+K2+K3) ) * V*V/(2*g) ;

printf("\n NPSH = %0.4f", NPSH)
