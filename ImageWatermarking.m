clear; clc; close all;

img = im2double(imread('cameraman.tif'));
if size(img,3) == 3
    img = rgb2gray(img);
end
[M, N] = size(img);

watermark = randn(32, 32) > 0.5; 
watermark = imresize(double(watermark), [M, N]);  

alpha = 0.05;  

[U, S, V] = svd(img);
S_wm = S + alpha * watermark;
img_wm = U * S_wm * V';

filename = 'watermarked.png';
imwrite(img_wm, filename);

[U_wm, S_wm, V_wm] = svd(img_wm);
S_extract = S_wm - alpha * S;
watermark_extract = S_extract > 0;

figure;
subplot(2,2,1); imshow(img); title('Original');
subplot(2,2,2); imshow(img_wm); title('Watermarked');
subplot(2,2,3); imshow(watermark); title('Original Watermark');
subplot(2,2,4); imshow(watermark_extract); title('Extracted Watermark');

fprintf('Watermarked image saved as %s\n', filename);