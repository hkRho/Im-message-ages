
% SquareCat;
% 
% output =int16 (SquareCat(:,:,1)./3 + SquareCat(:,:,2)./3 + SquareCat(:,:,3)./3);
% output
% 
% output(1:1,1:2);
% 
M = [-1,1,-1,-1,-1,-1,-1,-1,1,1,-1,-1,1,1,1,-1,-1,-1,1,-1,-1];

output =( [[1,2,1];[3,6,3];[1,8,9]])
count = 1;
for i = 2:size(output,1)
    b = (zeros(i-1,1));
    A = zeros(i-1,i-1);
    for j = 1:(size(output,1)-i+1)
        output(i,j)= output(i,j).*M(count);
        count = count +1;
        
        b = b+ output(i,j) .* output(1:i-1,j:j);
    end

    A = output(1:i-1,size(output,1)-i+2:size(output,1));
    sol = -1*A\b;

    for j = (size(output,1)-i+2):size(output,1)
        output(i,j) = sol(j - (size(output,1)-i+1));
    end
    
end
output





