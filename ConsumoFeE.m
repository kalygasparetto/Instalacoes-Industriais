clc;
clear all;

% Dados do sistema - Sistema Internacional de Unidades
P8 = 532000+1e5;
ro = 1000;
g = 9.8;
Ds = 24.13e-2;
Efic = 0.7;
Mi = 1e-3;
Dr = 20.3e-2;
k = 0.15e-3;
Patm = 1e5;
deltaZ = 7.5;
Ls = 8;
Lr = 40;
PKWH = 0.27;
TempoOpr = 3600;

% Dados da perda de carga antes da Bomba (sucção)
K1s = 15;
K2s = 0;
K3s = 10;

% Dados da perda de carga depois da Bomba (recalque)
K1r = 0.5;
K2r = 10;
K3r = 0;
K4r = 1;

Q = 20e-3;

vazao = [];
consumoFinanceiro = [];
consumoEnergetico = [];

while Q <= 60e-3
    % Para a Região da Sucção (antes da bomba)
    VelSuc = Q/(3.1416*Ds*Ds/4);
    ReSuc = VelSuc*ro*Ds/Mi;
    DsOK = Ds/k;

    % Calculo do fator de atrito
    C1s = sqrt(10)/10;
    C2s = 2.51/ReSuc;
    C3s = (1/DsOK)/3.7;
    f = @(x) C1s**x - C2s*x - C3s;
    x = fzero(f,0);
    EfeSuc = 1/(x*x);

    % Calculo das perdas de carga antes da bomba
    PcsTr = EfeSuc* (Ls/Ds) * VelSuc*VelSuc/(2*g);
    PcsAc = (K1s+K2s+K3s)*(VelSuc**2)/(2*g);
    PcsTotal = PcsTr + PcsAc;

    % Para a Região do Recalque (depois da bomba)
    VelReq = Q/(3.1416*Dr*Dr/4);
    ReReq = VelReq*ro*Dr/Mi;
    DrOK = Dr/k;

    % Calculo do fator de atrito
    C1r = sqrt(10)/10;
    C2r = 2.51/ReReq;
    C3r = (1/DrOK)/3.7;
    f = @(x) C1r**x - C2r*x - C3r;
    x = fzero(f,0);
    EfeReq = 1/(x*x);

    % Calculo das perdas de carga depois da bomba
    PcrTr = EfeReq* (Lr/Dr) * VelReq*VelReq/(2*g);
    PcrAc = (K1r+K2r+K3r+K4r)*(VelReq**2)/(2*g);
    PcrTotal = PcrTr + PcrAc;

    % Calculo do Head da Bomba (EBomba)
    EBomba = (P8 - Patm)/(ro*g) + deltaZ + (PcsTotal + PcrTotal);
    Pot = ro*g*Q*EBomba/Efic;
    printf("Consumo energético em W foi: %.2f\n", Pot);

    consumoEnergetico = [consumoEnergetico, Pot];

    % Calculo do consumo financeiro da Bomba
    ConFin = ( PKWH * Pot / 3.6e6 ) * TempoOpr;
    printf("Consumo financeiro foi: R$%.2f\n", ConFin);

    vazao = [vazao, Q];
    consumoFinanceiro = [consumoFinanceiro, ConFin];
    Q = Q + 1e-3;
endwhile

subplot(2, 1, 1);
title('Consumo energético x Vazao');
plot(vazao, consumoEnergetico);
xlabel('Vazao volumetrica');
ylabel('Consumo energético');

subplot(2, 1, 2);
title('Consumo financeiro x Vazao');
plot(vazao, consumoFinanceiro);
xlabel('Vazao volumetrica');
ylabel('Consumo financeiro');


