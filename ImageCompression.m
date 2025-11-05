clear; clc; close all;

img = im2double(imread('cameraman.tif'));
if size(img,3) == 3
    img = rgb2gray(img);
end
[M, N] = size(img);

k_values = [5, 10, 20, 50, 100, min(M,N)];
results = struct();

[U, S, V] = svd(img, 'econ');
sigma = diag(S);

for i = 1:length(k_values)
    k = k_values(i);
    img_comp = U(:,1:k) * S(1:k,1:k) * V(:,1:k)';
    img_comp = max(min(img_comp, 1), 0);
    
    mse = mean((img(:) - img_comp(:)).^2);
    psnr_val = 10 * log10(1 / mse);
    
    original_bytes = M * N * 8;
    compressed_bytes = k * (M + N + 1) * 8;
    comp_ratio = original_bytes / compressed_bytes;
    
    filename = sprintf('compressed_k%d.png', k);
    imwrite(img_comp, filename);
    
    results(i).k = k;
    results(i).psnr = psnr_val;
    results(i).ratio = comp_ratio;
    results(i).img = img_comp;
    results(i).filename = filename;
end

figure('Position', [100, 100, 1000, 700]);
subplot(2,3,1); imshow(img); title('Original');
subplot(2,3,2); imshow(results(1).img); title(sprintf('k=5, PSNR=%.1f dB', results(1).psnr));
subplot(2,3,3); imshow(results(3).img); title(sprintf('k=20, PSNR=%.1f dB', results(3).psnr));
subplot(2,3,4); imshow(results(5).img); title(sprintf('k=100, PSNR=%.1f dB', results(5).psnr));

subplot(2,3,5);
semilogy(sigma, 'b-o', 'LineWidth', 1.2); grid on;
title('Singular Values'); xlabel('Index'); ylabel('sigma_i'); xlim([1 200]);

subplot(2,3,6);
plot([results.k], [results.ratio], 'go-', 'LineWidth', 1.5, 'MarkerFaceColor', 'g');
hold on; plot([results.k], [results.psnr], 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
grid on; legend('Comp Ratio', 'PSNR (dB)'); title('Performance vs Rank');
xlabel('Rank k'); 

fprintf('\n=== SVD IMAGE COMPRESSION ===\n');
fprintf('%5s %10s %12s %12s\n', 'k', 'PSNR', 'Ratio', 'File');
fprintf('%5s %10s %12s %12s\n', '---', '----', '-----', '----');
for i = 1:length(results)
    fprintf('%5d %10.1f %10.1fx %15s\n', results(i).k, results(i).psnr, results(i).ratio, results(i).filename);
end