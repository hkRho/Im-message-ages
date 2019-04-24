
SquareCat;

output =int16 (SquareCat(:,:,1)./3 + SquareCat(:,:,2)./3 + SquareCat(:,:,3)./3);
output

M = [1,-1,1,-1,-1,-1,-1,-1,1,-1,-1,-1,1,1,1,-1,-1,-1,1,-1,-1];
output(1,1);
count = 1;
for i = 2:8
    for j = 1:(8-i)
        output(i,j);
        output(i,j)= output(i,j).*M(count);
        count = count +1;
        
    end

end
output
