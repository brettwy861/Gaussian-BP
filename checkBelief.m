function  [mDNum, fANum, inNum, outNum] = checkBelief(nodeNum, positions, beliefMu, beliefVar, primRange, maxMDRate, topoMat)

vagueRange = 50;

maxPow = -28.6-35*log10(primRange);
cutPnt = norminv(maxMDRate);
inNum(1:2) = 0;  outNum(1:2) = 0; mDNum(1:2) = 0; fANum(1:2) = 0;

for nodeIdx = 1 : nodeNum
    realDis = norm(positions(:,nodeIdx));
    if abs(realDis - primRange) < vagueRange
        continue;
    end
    
    coop = sign(sum(topoMat(nodeIdx,:)));
    if realDis > primRange
        outNum(coop+1) = outNum(coop+1) + 1;
    else
        inNum(coop+1)  = inNum(coop+1) + 1;
    end        
    
    % belief that the actual power is smaller than threshold
    stadPowDiff = (beliefMu(nodeIdx)-maxPow)/sqrt(beliefVar(nodeIdx));
    if stadPowDiff < cutPnt
        quitComm = 0;
    else
        quitComm = 1;
    end
    
    if quitComm && realDis>primRange
        fANum(coop+1) = fANum(coop+1) + 1;
    elseif (~quitComm) && realDis<primRange
        mDNum(coop+1) = mDNum(coop+1) + 1;
        if coop
            coop = 1;
        end
    end
end