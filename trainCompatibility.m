function [mu, var, rho] = trainCompatibility(dStep, rangeInMeter, commRange)

testNum  = 100;
distance = [];
dNum     = ceil(commRange / dStep);
powMean = zeros(1,dNum);
powVar = zeros(1,dNum);
powProd  = zeros(1,dNum);
counter  = zeros(1,dNum);

while min(counter) <= testNum    
    position = (rand(2, 2)*2-1) * rangeInMeter;
    distance = norm(position(:,1)-position(:,2));
    if distance > commRange
        continue;
    end
    
    dIdx     = ceil(distance / dStep);    
    dis1     = norm(position(:,1));
    dis2     = norm(position(:,2));
    Pow1     = -(28.6+35*log10(dis1));
    Pow2     = -(28.6+35*log10(dis2));        
    counter(dIdx) = counter(dIdx) + 1;
    powMean(dIdx) = powMean(dIdx) + Pow1 + Pow2;
    powVar(dIdx)  = powVar(dIdx) + Pow1^2 + Pow2^2;    
    powProd(dIdx) = powProd(dIdx) + Pow1*Pow2;
end

for dIdx = 1 : dNum
    mu(dIdx)  = powMean(dIdx) / counter(dIdx) / 2;
    var(dIdx) = powVar(dIdx) / counter(dIdx) / 2;    
    var(dIdx) = var(dIdx) -  mu(dIdx)^2;
    rho(dIdx) = powProd(dIdx) / counter(dIdx) - mu(dIdx)^2;
    rho(dIdx) = rho(dIdx) / var(dIdx);
end