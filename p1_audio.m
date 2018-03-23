clear all
close all
%% 1) Abre el archivo y reproduce
[y,Fs] = audioread('ejemplo_audio.m4a');
y = y(:,1);
sound(y,Fs);

% Representa secuencia (canal izquierdo)
figure
subplot(2,1,1),plot(y,'.');
xlabel('n');
axis([0 length(y) -1 1]);
title('Secuencia');

t = 0:1/Fs:length(y(:,1))/Fs; %Eje de tiempos entre, cada Ts=1/Fs
t(end) = [];
t = t';

subplot(2,1,2),plot(t,y(:,1));
xlabel('t (s)');
axis([0 t(end) -1 1]);
title('Proyección a tiempo continuo');

%% 2) Calcula y representa espectro de la secuencia
Lt = length(y(:,1));
%NFFT = 2^nextpow2(Lt); % Next power of 2 from length of y
NFFT = Lt;
Y = fft(y(:,1),NFFT)/Lt;

figure
%Espectro en Omega
Omega = linspace(-pi,pi,NFFT);
subplot(2,1,1),plot(Omega,abs(fftshift(Y)));
axis([-pi pi 0 1.1*max(abs(fftshift(Y)))]);
title('Espectro de la secuencia');
xlabel('Omega');
ylabel('|Y|');

%Proyección del espectro en f
%Nota: Fs/2 = pi, es decir, Fs = 2pi
%Nota 2: Una secuencia sólo se convierte a tiempo continuo al "hacerla
%realidad" fuera del ordenador, en este caso mediante un DAC (HW de sonido
%del ordenador), amplificador y altavoces. 

f = linspace(-Fs/2,Fs/2,NFFT);
subplot(2,1,2),plot(f,abs(fftshift(Y)));
axis([-Fs/2 Fs/2 0 1.1*max(abs(fftshift(Y)))]);
title('Espectro de la señal si la reproducimos JUSTO a Nyquist');
xlabel('Frecuencia (Hz)');
ylabel('|Y|');
%% 3) Filtramos la secuencia, haciendo que sea limitada en banda 
%representa espectro y reproduce:
load('filtro');
yf = filter(Hd,y);
YF = fft(yf,NFFT)/Lt;

figure
%Espectro en Omega
Omega = linspace(-pi,pi,NFFT);
subplot(2,2,3),plot(Omega,abs(fftshift(YF)));
axis([-pi pi 0 1.1*max(abs(fftshift(YF)))]);
title('Espectro de la secuencia filtrada');
xlabel('Omega');
ylabel('|Y|');

%Proyección del espectro en f
%Nota: Fs/2 = pi, es decir, Fs = 2pi
%Nota 2: Una secuencia sólo se convierte a tiempo contínuo al "hacerla
%realidad" fuera del ordenador.
f = linspace(-Fs/2,Fs/2,NFFT);
subplot(2,2,4),plot(f,abs(fftshift(YF)));
axis([-Fs/2 Fs/2 0 1.1*max(abs(fftshift(YF)))]);
title('Espectro de la señal LIMITADA EN BANDA si la reproducimos JUSTO a Nyquist');
xlabel('Frecuencia (Hz)');
ylabel('|Y|');

%Espectro en Omega
Omega = linspace(-pi,pi,NFFT);
subplot(2,2,1),plot(Omega,abs(fftshift(Y)));
axis([-pi pi 0 1.1*max(abs(fftshift(Y)))]);
title('Espectro de la secuencia');
xlabel('Omega');
ylabel('|Y|');

%Proyección del espectro en f
%Nota: Fs/2 = pi, es decir, Fs = 2pi
%Nota 2: Una secuencia sólo se convierte a tiempo continuo al "hacerla
%realidad" fuera del ordenador, en este caso mediante un DAC (HW de sonido
%del ordenador), amplificador y altavoces.
f = linspace(-Fs/2,Fs/2,NFFT);
subplot(2,2,2),plot(f,abs(fftshift(Y)));
axis([-Fs/2 Fs/2 0 1.1*max(abs(fftshift(Y)))]);
title('Espectro de la señal si la reproducimos JUSTO a la frecuencia de Nyquist');
xlabel('Frecuencia (Hz)');
ylabel('|Y|');

sound(yf,Fs);