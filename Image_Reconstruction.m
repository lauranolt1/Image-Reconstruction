% 
% Image Reconstruction
%

close all
%read the photo into MatLab
pic = imread('Venice.jpg');

% convert to grey scale - take average over all 3 rgb
new = mean(pic,3);

% display photo
figure();
imshow(uint8(new))

% shrink dimensions
% new = new(1:3:end,1:3:end,:);
new = imresize(new,[128,128]);

% show the new image
figure();
imshow(uint8(new));

% apply DFT to picture/matrix - this is xhat
FF = fft2(new);

% make a "frame" (i) to distinguish which ones to eliminate
i = 50;
FF(i:end-i,i:end-i) = 0;

% reverse to transform back
IFF = ifft2(FF);

% convert back to uint8 for photo
% display photo
final = uint8(real(IFF));
whos
figure();
imshow(final)

% Construct matrix to transform images into Haar wavelet basis
H = ConstructHaarWaveletTransformationMatrix(128^2);

% Reshape to a vector to apply wavelet transform
new = reshape(new,[128^2,1]);
new_wavelet = H*new;

% zero out the coefficients
new_wavelet(8193:128^2,1) = zeros(8192,1);

% create the new image
final_wavelet = H'*new_wavelet;

% reshape the new image
final_wavelet = reshape(final_wavelet,[128,128]);

% show the new image
figure();
imagesc(final_wavelet)
colormap(gray)

    