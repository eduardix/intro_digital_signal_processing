clear all
close all
%% 1) Crea la señal y la muestrea a Fs
Fs = 10000;            % Frecuencia de Muestreo                   
T = 1/Fs;              % Periodo de muestreo      
L = 10000;             % Longitud de señal en muestras
t = (0:L-1)*T;         % Vector de tiempo

% Señal formada por una combinación lineal de sinusoides
y = 0.7*sin(2*pi*50*t) + sin(2*pi*100*t) - 0.5*sin(2*pi*200*t);

% dibuja las señales
figure
plot(1000*t(1:1000),y(1:1000))
title('Señal')
xlabel('t (milisegundos)')
ylabel('y(t)')

figure
stem(y(1:1000))
title('Secuencia')
xlabel('n')
ylabel('y[n]')

%% 2) Calcula y representa espectro de la secuencia

Lt = length(y);
NFFT = 2^nextpow2(Lt); % Next power of 2 from length of y
%NFFT = 10^7;
Y = fft(y,NFFT)/Lt;

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

%% 3) Reproduce con T más baja o Fs más alta
fact = 0.5; %Factor de escalado de la variable independiente (tiempo).
Fs1 = fact*Fs;
sound(y,Fs1);

t1 = 0:1/Fs1:length(y)/Fs1; %Eje de tiempos entre, cada Ts=1/Fs
t1(end) = [];
t1 = t1';

figure
subplot(2,1,1),plot(t,y);
xlabel('t (s)');
axis([0 t(end) -1 1]);
subplot(2,1,2),plot(t1,y);
xlabel('t (s)');
axis([0 t1(end) -1 1]);

%% 4) Muestreo de secuencias 

N = 10;                                      %la N de diezmar en las transparencias
ym = zeros(size(y));
ym(1:N:end) = y(1:N:end);

%Al reproducirla, siempre habrá distorsión si no la filtramos primero.
%sound(ym,Fs);

%Haga zoom y compruebe las diferencias
figure
subplot(2,1,1), plot(y,'.');
xlabel('n');
title('Secuencia original');

subplot(2,1,2), plot(ym,'.');
xlabel('n');
title('Secuencia muestreada, amplie y vea las muestras iguales a 0');

%Veamos el espectro de la secuencia muestreada:
figure
YM = fft(ym,NFFT)/Lt;

plot(Omega,abs(fftshift(YM))); 
title(['Espectro de la secuencia muestreada N=' num2str(N)]);
xlabel('Omega')
ylabel('|YM|')

%% 5) Diezmado orden N
yN = ym;
yN(yN == 0) = []; %¿Qué estoy haciendo aquí? 

%y el espectro?
YN = fft(yN,NFFT)/Lt;
figure
subplot(3,1,3), plot(Omega,abs(fftshift(YN))); 
title('Espectro de la secuencia DIEZMADA');
xlabel('Omega');
ylabel('|YN|');

subplot(3,1,2), plot(Omega,abs(fftshift(YM))); 
title('Espectro de la secuencia MUESTREADA');
xlabel('Omega');
ylabel('|YM|');

subplot(3,1,1), plot(Omega,abs(fftshift(Y))); 
title('Espectro de la secuencia ORIGINAL');
xlabel('Omega');
ylabel('|YF|');

%Lo reproduzco a Fs
sound(yN,Fs);
%Lo reproduzco a Fs/N
%sound(yN,Fs/N);
%% 6) Interpolación orden L = N
%Inserta 0 y filtra con FPB. Esta función ya hace eso, es una
%interpolación sinc que MATLAB nos ofrece.
L = N;              %Para volver a la original
yL = interp(yN,L);          

YL = fft(yL,NFFT)/Lt;

subplot(3,1,1), plot(Omega,abs(fftshift(Y))); 
title('Espectro de la secuencia ORIGINAL');
xlabel('Omega');
ylabel('|YF|');

subplot(3,1,3), plot(Omega,abs(fftshift(YL))); 
title('Espectro de la secuencia INTERPOLADA');
xlabel('Omega');
ylabel('|YL|');

subplot(3,1,2), plot(Omega,abs(fftshift(YN))); 
title('Espectro de la secuencia DIEZMADA');
xlabel('Omega');
ylabel('|YN|');
sound(yL,Fs);