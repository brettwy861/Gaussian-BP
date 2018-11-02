function [distance, recPow, truePow] = simuRecPow(nodeNum, positions, noisePow)

for nodeIdx = 1 : nodeNum
    dist = norm(positions(:,nodeIdx));
    truePow(nodeIdx) = -(28.6+35*log10(dist));
    recPow(nodeIdx) = truePow(nodeIdx) + randn*sqrt(noisePow);
end

distance = zeros(nodeNum);
for nodeIdx1 = 1 : nodeNum
    for nodeIdx2 = 1 : nodeNum
        distance(nodeIdx1, nodeIdx2) = norm(positions(:,nodeIdx1)-positions(:,nodeIdx2));
    end
end

