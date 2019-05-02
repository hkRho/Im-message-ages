clear;
image = imread('SquareCat4.bmp');
figure
imshow(image);

BLOCKSIZE = 256;
PROTECTED_COLS = 50;
BPB = ((BLOCKSIZE-PROTECTED_COLS-1)*(BLOCKSIZE-PROTECTED_COLS))/2; 
NUM_BLOCKS = size(image,1)*size(image,2)/BLOCKSIZE^2;
redun = 1000;

% output = [[1,5,8,10];[2,6,9,11];[3,7,12,13];[4,-9.5,15,16]];
% imshow( mat2gray(uint8(output)));

Message = [0,1,0,0,1,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,1,1,1,1];

redun_msg = Message;
for t=2:redun
    redun_msg=[redun_msg,Message];
end 
output = single(image(:,:,1)./3 + image(:,:,2)./3 + image(:,:,3)./3);
index = 1;

[U,S,V] = svd(output);
A1 = U*S*V';
output = U;
msg_chunk = redun_msg;

for j = 1+ PROTECTED_COLS: BLOCKSIZE
   for i = 2:BLOCKSIZE-(j-1)
      if msg_chunk(index) == 0
          output(i,j) = -1 * abs(output(i,j));
      else
          output(i,j) = abs(output(i,j));
      end
      index= index+1;
   end
   
    b = output(1:BLOCKSIZE - (j-1),1:(j-1))'*output(1:BLOCKSIZE-(j-1), j:j);
    A = -1*output(BLOCKSIZE-(j-2):BLOCKSIZE,1:j-1)'; 
    output(BLOCKSIZE-(j-1)+1:BLOCKSIZE,j:j) = A\b;
    v = output(1:BLOCKSIZE,j:j);
    output(1:BLOCKSIZE,j:j) = v/sqrt(v'*v);
    
end

figure;

A2 = output*S*V';
imshow( mat2gray(uint8(A2)));






