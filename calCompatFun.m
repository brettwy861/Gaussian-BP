function [mu, var] = calCompatFun(nodeNum, positions,commDistance)

testTimes = 100;

for nodeIdx = 1 : nodeNum
    relaPos = positions - positions(:,nodeIdx);
    distance = sqrt(diag(relaPos'*relaPos));
    neighbors = find(distance>0 && distance<commDistance);
    
    for neighborIdx = 1 : length(neighbors)
        if neighborIdx < nodeIdx
            continue;
        end
        
        for testIdx = 1 : testTimes
            
        end
        [mu(nodeIdx,neighborIdx), var(nodeIdx,neighborIdx)]
    end    
end