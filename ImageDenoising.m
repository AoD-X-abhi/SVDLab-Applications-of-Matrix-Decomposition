clear; clc; close all;

img = im2double(imread('cameraman.tif'));
if size(img,3) == 3
    img = rgb2gray(img);
end
[M, N] = size(img);

sigma_noise = 0.1;
img_noisy = img + sigma_noise * randn(M, N);
img_noisy = max(min(img_noisy, 1), 0);

[U, S, V] = svd(img_noisy, 'econ');
sigma = diag(S);

k_values = [5, 10, 20, 50, 100, min(M,N)];
results = struct();

for i = 1:length(k_values)
    k = k_values(i);
    img_denoised = U(:,1:k) * S(1:k,1:k) * V(:,1:k)';
    mse = mean((img(:) - img_denoised(:)).^2);
    psnr_val = 10 * log10(1 / mse);
    filename = sprintf('denoised_k%d.png', k);
    imwrite(img_denoised, filename);
    results(i).k = k;
    results(i).psnr = psnr_val;
    results(i).img = img_denoised;
    results(i).filename = filename;
end

figure('Position', [100, 100, 1000, 700]);
subplot(2,3,1); imshow(img); title('Original');
subplot(2,3,2); imshow(img_noisy); title(sprintf('Noisy (sigma=%.2f)', sigma_noise));

k_show = 20;
idx = find([results.k] == k_show);
subplot(2,3,3); imshow(results(idx).img); 
title(sprintf('Denoised (k=%d, PSNR=%.2f dB)', k_show, results(idx).psnr));

k_show = 50;
idx = find([results.k] == k_show);
subplot(2,3,4); imshow(results(idx).img); 
title(sprintf('Denoised (k=%d, PSNR=%.2f dB)', k_show, results(idx).psnr));

subplot(2,3,5); 
plot(sigma, 'b-o', 'LineWidth', 1.2, 'MarkerSize', 4); grid on;
title('Singular Value Spectrum'); xlabel('Index'); ylabel('sigma_i');
xlim([1 200]);

subplot(2,3,6);
plot([results.k], [results.psnr], 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
grid on; title('PSNR vs Rank k'); xlabel('Rank k'); ylabel('PSNR (dB)');

fprintf('\n=== SVD DENOISING RESULTS ===\n');
fprintf('%5s %10s %12s\n', 'k', 'PSNR (dB)', 'Saved');
fprintf('%5s %10s %12s\n', '---', '--------', '-----');
for i = 1:length(results)
    fprintf('%5d %10.2f %15s\n', results(i).k, results(i).psnr, results(i).filename);
end