clear; clc; close all;

[audio, fs] = audioread('compressed_k50.wav');
audio = audio(:,1);
N = length(audio);

win_length = 1024;
hop_length = win_length/4;
n_fft = win_length;

[S,~,~] = stft(audio,fs,...
    'Window',hamming(win_length),...
    'OverlapLength',win_length-hop_length,...
    'FFTLength',n_fft);

S_mag   = abs(S);
S_phase = exp(1j*angle(S));
[F,T]   = size(S_mag);

[U,Sigma,V] = svd(S_mag,'econ');
sigma = diag(Sigma);

k_values = [10 30 50 100 min(F,T)-1];
results = struct();

for i = 1:numel(k_values)
    k = k_values(i);
    
    S_mag_comp = U(:,1:k)*Sigma(1:k,1:k)*V(:,1:k)';
    S_comp     = S_mag_comp .* S_phase;
    
    audio_recon = istft(S_comp,fs,...
        'Window',hamming(win_length),...
        'OverlapLength',win_length-hop_length,...
        'FFTLength',n_fft);
    
    audio_recon = real(audio_recon);
    
    % ---- SAFE NORMALISATION (no huge temporary array) ----
    peak = max(abs(audio_recon));
    if peak>0, audio_recon = audio_recon/peak; end
    
    audio_recon = max(min(audio_recon,1),-1);
    
    if numel(audio_recon)>N
        audio_recon = audio_recon(1:N);
    else
        audio_recon = [audio_recon; zeros(N-numel(audio_recon),1)];
    end
    
    filename = sprintf('compressed_k%d.wav',k);
    audiowrite(filename,audio_recon,fs);
    
    noise   = audio - audio_recon;
    snr_db  = 10*log10(sum(audio.^2)/sum(noise.^2));
    comp_ratio = (F*T)/(k*(F+T+1));
    
    results(i).k      = k;
    results(i).snr    = snr_db;
    results(i).ratio  = comp_ratio;
    results(i).audio  = audio_recon;
    results(i).filename = filename;
end

figure('Position',[100 100 900 600]);
subplot(2,2,1); semilogy(sigma,'b-o','LineWidth',1.5,'MarkerFaceColor','b');
grid on; title('Singular Value Spectrum'); xlabel('Index'); ylabel('\sigma_i'); xlim([1 200]);

k_plot = 50; idx = find([results.k]==k_plot);
S_mag_recon = abs(stft(results(idx).audio,fs,...
    'Window',hamming(win_length),...
    'OverlapLength',win_length-hop_length,...
    'FFTLength',n_fft));

subplot(2,2,2); imagesc(10*log10(S_mag+eps)); axis xy; colorbar;
title('Original Spectrogram (dB)'); xlabel('Time Frame'); ylabel('Frequency Bin');

subplot(2,2,3); imagesc(10*log10(S_mag_recon+eps)); axis xy; colorbar;
title(sprintf('Reconstructed (k=%d)',k_plot)); xlabel('Time Frame'); ylabel('Frequency Bin');

subplot(2,2,4);
plot(1:50:N,audio(1:50:end),'b','DisplayName','Original'); hold on;
plot(1:50:N,results(idx).audio(1:50:end),'r--','DisplayName','Reconstructed');
legend; grid on; title('Waveform Comparison (Downsampled)');
xlabel('Sample'); ylabel('Amplitude');