
folderPath = 'D:\PDF\Semester 2\M F C   2\Eigen Faces SVD\Faces';
files = dir(fullfile(folderPath, '*.jpg')); 
numFiles = length(files);
imageSize = [64, 64]; 

allImages = zeros(imageSize(1) * imageSize(2), numFiles);
labels = cell(1, numFiles);

for i = 1:numFiles
    img = imread(fullfile(folderPath, files(i).name));
    img = rgb2gray(imresize(img, imageSize));
    allImages(:, i) = img(:); 
    labels{i} = files(i).name;
end

meanFace = mean(allImages,2);
allImagesMeanSubtracted = allImages - meanFace;

[U, S, V] = svd(allImagesMeanSubtracted, 'econ');


while true
    
    testImagePath = input('Enter the test image path (or "stop" to exit): ', 's');
    
    
    if strcmpi(testImagePath, 'stop')
        disp('Exiting the program.');
        break;
    end
    
    testImage = imread(testImagePath);
    testImage = rgb2gray(imresize(testImage, imageSize));
    testImage = double(testImage(:));

    projectedTestImage = U * (U' * testImage);

    distances = zeros(1, numFiles);
    for i = 1:numFiles
        distances(i) = norm(projectedTestImage - U * (U' * allImages(:, i)));
    end

    [~, minIndex] = min(distances);

    figure;
    subplot(1, 2, 1);
    imshow(reshape(testImage, imageSize), []);
    title('Input Image');

    subplot(1, 2, 2);
    imshow(reshape(allImages(:, minIndex), imageSize), []);
    title(['Matched Image: ', labels{minIndex}]);
end
