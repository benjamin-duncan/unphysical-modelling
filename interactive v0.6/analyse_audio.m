%Generates FFT and Spectrogram for any audio file for report

[location,path] = uigetfile('*.wav');
audpth =    strcat( path,location);
[xaud,fs] = audioread(audpth);
xaud = xaud';
t=1:length(xaud);
%fs=44100;
subplot(2,1,1) % First plot is FFT of centre mass
            [fft, hz]= pm_mdof_format_fft(xaud(1,:),t,fs);
            semilogx(  hz, fft);
            title('FFT');
            xlabel('Frequency (Hz)');
            ylabel('Amplitude (db)');
    
            subplot(2,1,2) % Second Plot is Spectrogram of centre mass
             %spectral analysis
              spectrogram( xaud(1,:)',128,120,128, fs); %spectral analysis
            title('Spectrogram');