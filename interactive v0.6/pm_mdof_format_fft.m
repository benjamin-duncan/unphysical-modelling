% FFT and calculations for Power Spectrum
function [fftplot,hertz] = pm_mdof_format_fft(soundAmp,t,fs)

 try
    N=length(t);
    X_mags = abs(fft( soundAmp ));
    bin_vals = 0  : N-1;
    fax_Hz = bin_vals*fs/N;
    N_2 = ceil(N/2);
    fftplot = 20*log10(X_mags(1:N_2));
    hertz = fax_Hz(1:N_2);
            
 catch e
       error('pm_mdof_format_fft: %s',e.message);
 end
end