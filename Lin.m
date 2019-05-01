% clear
% output = [[2,1];[1,2]]
% [S,V,D] = svd(output)
clear
I = imread('SquareCat.bmp');
% figure
% imshow(I);
% figure

output = single(I(:,:,1)./3 + I(:,:,2)./3 + I(:,:,3)./3);
% imshow(mat2gray(uint8(output)));

% figure
output(1:1,1:2);
[S,V,D] = svd(output);
A1 = S*V*D';

imshow( mat2gray(uint8(A1)));
protected_rows = 1;
M = [-1,1,-1,-1,-1,-1,-1,-1,1,1,-1,-1,1,1,1,-1,-1,-1,1,-1,-1];
M =[1,1,1];
output = S;
count = 1;
for i = 1+protected_rows :size(output,1)
    b = (zeros(i-1,1));
    A = zeros(i-1,i-1);
    for j = 1:(size(output,1)-i+1)
        output(i,j)= output(i,j).*M(count);
        count = count +1;
        if count > size(M,2)
            count = 1;
        end        
        b = b+ output(i,j) .* output(1:i-1,j:j);
    end

    A = output(1:i-1,size(output,1)-i+2:size(output,1));
    sol = -1*A\b;

    for j = (size(output,1)-i+2):size(output,1)
        output(i,j) = sol(j - (size(output,1)-i+1));
    end
    
end

figure
A2 = output*V*D'
uint8(A1)-uint8(A2)
imshow( mat2gray(uint8(A2)));





