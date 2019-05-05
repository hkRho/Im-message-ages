clear;
image = imread('SquareCat4.bmp');
figure
imshow(image);

BLOCKSIZE = 256;
PROTECTED_COLS = 50;
BPB = ((BLOCKSIZE-PROTECTED_COLS-1)*(BLOCKSIZE-PROTECTED_COLS))/2; % calculates the bits that can be hidden per block
NUM_BLOCKS = size(image,1)*size(image,2)/BLOCKSIZE^2; % calculates the number of blocks that can fit in an image
redun = 1000; % purpose is to loop over the message multiple times in case it gets cut

% output = [[1,5,8,10];[2,6,9,11];[3,7,12,13];[4,-9.5,15,16]];
% imshow( mat2gray(uint8(output)));

Message = [0,1,0,0,1,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,1,1,1,1];

redun_msg = Message;
% adds the Message redun times to the Message itself
% so it is easy to find the Message by looking at the repeating pattern
for t=1:redun 
    redun_msg=[redun_msg,Message];
end 
output = single(image(:,:,1)./3 + image(:,:,2)./3 + image(:,:,3)./3); % calculates the average value of the R,G,B
index = 1;

[U,S,V] = svd(output);
A1 = U*S*V'; % check whether svd works
output = U;
msg_chunk = redun_msg;

for j = 1+ PROTECTED_COLS: BLOCKSIZE
   for i = 2:BLOCKSIZE-(j-1)
      % if the bit in the message = 0, then value of U matrix is negated
      if msg_chunk(index) == 0
          output(i,j) = -1 * abs(output(i,j));
      % if the bit in the message=1, then value of U matrix is kept 
      else
          output(i,j) = abs(output(i,j));
      end
      index= index+1;
   end
    
    b = output(1:BLOCKSIZE - (j-1),1:(j-1))'*output(1:BLOCKSIZE-(j-1), j:j); %look at FINDING B
    A = -1*output(BLOCKSIZE-(j-2):BLOCKSIZE,1:j-1)'; % look at CALCULATE MATRIX A
    output(BLOCKSIZE-(j-1)+1:BLOCKSIZE,j:j) = A\b; % multiplying the inverse of A to find the vector of y and z
    v = output(1:BLOCKSIZE,j:j);
    output(1:BLOCKSIZE,j:j) = v/sqrt(v'*v); % normalizing each vector(column)
    
end

figure;

A2 = output*S*V'; % conduct SVD with output which is matrix U with altered values
imshow( mat2gray(uint8(A2)));


% CALCULATING BPB
% y direction = ((BLOCKSIZE-PROTECTED_COLS-1)
% x direction = (BLOCKSIZE-PROTECTED_COLS))

% FINDING B
% if there is matrix 1,2,3,4;5,6,7,x;8,9,10,y,z;10,a,b,c;
% and v1 and v3 has to be orthogonal:
%    1*8 + 2*9 = -3y - 4z
%    5*8 + 6*9 = -7y - xz
%    then becomes:
%    [1,2;5,6]*[8,9]
% the first matrix is the transpose of the first two elements of v1, v2
% the second matrix is the first two elements of v3

% CALCULATING MATRIX A
% if there is matrix 1,2,3,4;5,6,7,x;8,9,10,y,z;10,a,b,c;
% and v1 and v3 has to be orthogonal:
%    1*8 + 2*9 = -3y - 4z
%    5*8 + 6*9 = -7y - xz
%    b = A*output
%    output = inverse(A)*b
