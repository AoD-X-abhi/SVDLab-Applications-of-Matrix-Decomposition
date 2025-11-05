
clc;
clear;
close all;

fprintf('========================================\n');
fprintf('   IMAGE STEGANOGRAPHY SYSTEM\n');
fprintf('========================================\n\n');
fprintf('1. Hide Text in Image\n');
fprintf('2. Hide Image in Image\n');
fprintf('3. Extract Hidden Text\n');
fprintf('4. Extract Hidden Image\n');
fprintf('5. Exit\n\n');

choice = input('Enter your choice (1-5): ');

switch choice
    case 1
        hideTextInImage();
    case 2
        hideImageInImage();
    case 3
        extractTextFromImage();
    case 4
        extractImageFromImage();
    case 5
        fprintf('Exiting...\n');
    otherwise
        fprintf('Invalid choice!\n');
end


function hideTextInImage()
    fprintf('\n--- HIDE TEXT IN IMAGE ---\n');
    

    [filename, pathname] = uigetfile({'*.png;*.jpg;*.bmp;*.tif','Image Files'}, 'Select Cover Image');
    if filename == 0
        fprintf('No file selected!\n');
        return;
    end
    coverImg = imread(fullfile(pathname, filename));
    

    secretText = input('Enter text to hide: ', 's');

    textBinary = textToBinary(secretText);

    [rows, cols, channels] = size(coverImg);
    maxBits = rows * cols * channels;
    
    if length(textBinary) > maxBits - 32
        fprintf('Error: Text is too large for this image!\n');
        return;
    end

    textLength = length(secretText);
    lengthBinary = dec2bin(textLength, 32);
    fullBinary = [lengthBinary, textBinary];

    stegoImg = coverImg;
    bitIndex = 1;
    
    for ch = 1:channels
        for i = 1:rows
            for j = 1:cols
                if bitIndex <= length(fullBinary)
                    pixel = stegoImg(i, j, ch);
                    pixel = bitset(pixel, 1, str2double(fullBinary(bitIndex)));
                    stegoImg(i, j, ch) = pixel;
                    bitIndex = bitIndex + 1;
                else
                    break;
                end
            end
            if bitIndex > length(fullBinary)
                break;
            end
        end
        if bitIndex > length(fullBinary)
            break;
        end
    end
    
    imwrite(stegoImg, 'stego_text_image.png');
    fprintf('\nText hidden successfully!\n');
    fprintf('Stego image saved as: stego_text_image.png\n');

    figure;
    subplot(1,2,1); imshow(coverImg); title('Original Cover Image');
    subplot(1,2,2); imshow(stegoImg); title('Stego Image (with hidden text)');
    
    psnrValue = psnr(stegoImg, coverImg);
    fprintf('PSNR: %.2f dB\n', psnrValue);
end

%% Function 2: Hide Image in Image using LSB
function hideImageInImage()
    fprintf('\n--- HIDE IMAGE IN IMAGE ---\n');
    
   
    [filename, pathname] = uigetfile({'*.png;*.jpg;*.bmp;*.tif','Image Files'}, 'Select Cover Image');
    if filename == 0
        fprintf('No file selected!\n');
        return;
    end
    coverImg = imread(fullfile(pathname, filename));
    
    [filename2, pathname2] = uigetfile({'*.png;*.jpg;*.bmp;*.tif','Image Files'}, 'Select Secret Image');
    if filename2 == 0
        fprintf('No file selected!\n');
        return;
    end
    secretImg = imread(fullfile(pathname2, filename2));
    
    if size(secretImg, 3) == 3
        secretImg = rgb2gray(secretImg);
    end
    
    [coverRows, coverCols, coverChannels] = size(coverImg);
    [secretRows, secretCols] = size(secretImg);
    
    maxPixels = floor((coverRows * coverCols * coverChannels) / 8);
    secretPixels = secretRows * secretCols;
    
    if secretPixels > maxPixels - 64
        fprintf('Error: Secret image is too large!\n');
        fprintf('Maximum secret image pixels: %d\n', maxPixels - 64);
        return;
    end
    
    dimBinary = [dec2bin(secretRows, 32), dec2bin(secretCols, 32)];
    
    secretBinary = reshape(dec2bin(secretImg(:), 8)', 1, []);
    fullBinary = [dimBinary, secretBinary];
    
    stegoImg = coverImg;
    bitIndex = 1;
    
    for ch = 1:coverChannels
        for i = 1:coverRows
            for j = 1:coverCols
                if bitIndex <= length(fullBinary)
                    pixel = stegoImg(i, j, ch);
                    pixel = bitset(pixel, 1, str2double(fullBinary(bitIndex)));
                    stegoImg(i, j, ch) = pixel;
                    bitIndex = bitIndex + 1;
                else
                    break;
                end
            end
            if bitIndex > length(fullBinary)
                break;
            end
        end
        if bitIndex > length(fullBinary)
            break;
        end
    end
    
    imwrite(stegoImg, 'stego_image_image.png');
    fprintf('\nImage hidden successfully!\n');
    fprintf('Stego image saved as: stego_image_image.png\n');
    
    figure;
    subplot(2,2,1); imshow(coverImg); title('Cover Image');
    subplot(2,2,2); imshow(secretImg); title('Secret Image');
    subplot(2,2,3); imshow(stegoImg); title('Stego Image');
    subplot(2,2,4); imshow(abs(double(coverImg) - double(stegoImg)), []); 
    title('Difference (Enhanced)');
    
    psnrValue = psnr(stegoImg, coverImg);
    fprintf('PSNR: %.2f dB\n', psnrValue);
end

%% Function 3: Extract Text from Stego Image
function extractTextFromImage()
    fprintf('\n--- EXTRACT TEXT FROM IMAGE ---\n');
    
    [filename, pathname] = uigetfile({'*.png;*.jpg;*.bmp;*.tif','Image Files'}, 'Select Stego Image');
    if filename == 0
        fprintf('No file selected!\n');
        return;
    end
    stegoImg = imread(fullfile(pathname, filename));
    
    [rows, cols, channels] = size(stegoImg);
    
    binaryStr = '';
    bitCount = 0;
    
    for ch = 1:channels
        for i = 1:rows
            for j = 1:cols
                if bitCount < 32
                    pixel = stegoImg(i, j, ch);
                    binaryStr = [binaryStr, num2str(bitget(pixel, 1))];
                    bitCount = bitCount + 1;
                else
                    break;
                end
            end
            if bitCount >= 32
                break;
            end
        end
        if bitCount >= 32
            break;
        end
    end
    
    textLength = bin2dec(binaryStr);
    
    if textLength <= 0 || textLength > 10000
        fprintf('Error: Invalid or no hidden text found!\n');
        return;
    end
    
    bitsNeeded = textLength * 8;
    binaryStr = '';
    bitCount = 0;
    
    for ch = 1:channels
        for i = 1:rows
            for j = 1:cols
                if bitCount < (32 + bitsNeeded)
                    pixel = stegoImg(i, j, ch);
                    if bitCount >= 32
                        binaryStr = [binaryStr, num2str(bitget(pixel, 1))];
                    end
                    bitCount = bitCount + 1;
                else
                    break;
                end
            end
            if bitCount >= (32 + bitsNeeded)
                break;
            end
        end
        if bitCount >= (32 + bitsNeeded)
            break;
        end
    end
    
    extractedText = binaryToText(binaryStr);
    
    fprintf('\n--- EXTRACTED TEXT ---\n');
    fprintf('%s\n', extractedText);
    fprintf('----------------------\n');
end

%% Function 4: Extract Image from Stego Image
function extractImageFromImage()
    fprintf('\n--- EXTRACT IMAGE FROM IMAGE ---\n');
    
    [filename, pathname] = uigetfile({'*.png;*.jpg;*.bmp;*.tif','Image Files'}, 'Select Stego Image');
    if filename == 0
        fprintf('No file selected!\n');
        return;
    end
    stegoImg = imread(fullfile(pathname, filename));
    
    [rows, cols, channels] = size(stegoImg);
    
    binaryStr = '';
    bitCount = 0;
    
    for ch = 1:channels
        for i = 1:rows
            for j = 1:cols
                if bitCount < 64
                    pixel = stegoImg(i, j, ch);
                    binaryStr = [binaryStr, num2str(bitget(pixel, 1))];
                    bitCount = bitCount + 1;
                else
                    break;
                end
            end
            if bitCount >= 64
                break;
            end
        end
        if bitCount >= 64
            break;
        end
    end
    
    secretRows = bin2dec(binaryStr(1:32));
    secretCols = bin2dec(binaryStr(33:64));
    
    if secretRows <= 0 || secretCols <= 0 || secretRows > 5000 || secretCols > 5000
        fprintf('Error: Invalid or no hidden image found!\n');
        return;
    end
    
    bitsNeeded = secretRows * secretCols * 8;
    binaryStr = '';
    bitCount = 0;
    
    for ch = 1:channels
        for i = 1:rows
            for j = 1:cols
                if bitCount < (64 + bitsNeeded)
                    pixel = stegoImg(i, j, ch);
                    if bitCount >= 64
                        binaryStr = [binaryStr, num2str(bitget(pixel, 1))];
                    end
                    bitCount = bitCount + 1;
                else
                    break;
                end
            end
            if bitCount >= (64 + bitsNeeded)
                break;
            end
        end
        if bitCount >= (64 + bitsNeeded)
            break;
        end
    end
    
    pixels = zeros(secretRows * secretCols, 1);
    for i = 1:length(pixels)
        startIdx = (i-1)*8 + 1;
        endIdx = i*8;
        if endIdx <= length(binaryStr)
            pixels(i) = bin2dec(binaryStr(startIdx:endIdx));
        end
    end
    
    extractedImg = uint8(reshape(pixels, secretRows, secretCols));
    
    imwrite(extractedImg, 'extracted_secret_image.png');
    fprintf('\nImage extracted successfully!\n');
    fprintf('Extracted image saved as: extracted_secret_image.png\n');
    
    figure;
    imshow(extractedImg);
    title('Extracted Secret Image');
end

%% Helper Functions
function binary = textToBinary(text)
    binary = '';
    for i = 1:length(text)
        binary = [binary, dec2bin(double(text(i)), 8)];
    end
end

function text = binaryToText(binary)
    text = '';
    numChars = floor(length(binary) / 8);
    for i = 1:numChars
        startIdx = (i-1)*8 + 1;
        endIdx = i*8;
        charCode = bin2dec(binary(startIdx:endIdx));
        text = [text, char(charCode)];
    end
end