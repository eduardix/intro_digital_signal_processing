clear all
close all
%% Abre el archivo 
load('dato_acel.mat');

y = data.acel_z;
t = data.tq;

%tomamos un fragmento
y = y(19500:22000);
t = t(19500:22000);

%frecuencia de muestreo
Fs = 50;

% Representa secuencia (canal izquierdo)
figure
subplot(2,1,1),plot(y,'.');
xlabel('n');
%axis([0 length(y) -1 1]);
title('Secuencia');

subplot(2,1,2),plot(t,y);
xlabel('t (s)');
%axis([0 t(end) -1 1]);
title('Proyección a tiempo continuo');

%% Calcula y representa espectro de la secuencia
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

f = linspace(-Fs/2,Fs/2,NFFT);
subplot(2,1,2),plot(f,abs(fftshift(Y)));
axis([-Fs/2 Fs/2 0 1.1*max(abs(fftshift(Y)))]);
title('Espectro de la señal si la reproducimos JUSTO a Nyquist');
xlabel('Frecuencia (Hz)');
ylabel('|Y|');