function  topoMat = getToplology(distance, commRange, nodeNum)

topoMat = zeros(nodeNum, nodeNum);

for nodeIdx1 = 1 : nodeNum
    for nodeIdx2 = 1 : nodeNum
        if distance(nodeIdx1, nodeIdx2) < commRange && nodeIdx1 ~= nodeIdx2
            topoMat(nodeIdx1, nodeIdx2) = 1;
        end
    end
end