objMatrix = zeros(40,100);

for i = 1:100
    for j = 1:40
        objMatrix(j,i) = ObjFunction([239 + i/50, 13.5 + j /40 * 1.5 ]);
    end
    disp(num2str(i));
end

minMatrix = min(objMatrix(:));
[row,col] = find(objMatrix==minMatrix);

disp([row col]);
