function [beliefMat, beliefMu, beliefVar] = calBP(nodeNum, recPow, topoMat, distance, compFun, dStep, iterTimes, ~, noisePow, p)

% initialization
prioriMu = mean(compFun(1,:));
prioriVar= mean(compFun(2,:));
localMu  = ones(1,nodeNum);
localVar = ones(1,nodeNum);
messMu   = zeros(nodeNum,nodeNum);
messVar  = 1e10*ones(nodeNum,nodeNum);
newMessMu   = zeros(nodeNum,nodeNum);
newMessVar  = 1e10*ones(nodeNum,nodeNum);
beliefMu    = ones(1,nodeNum);
beliefVar   = ones(1,nodeNum);
beliefMat = zeros(2,nodeNum,iterTimes);
% -------------- compute local functions -------
for nodeIdx = 1 : nodeNum
    localVar(nodeIdx)  = 1/(1/prioriVar+1/noisePow);
    localMu(nodeIdx) = (prioriMu/prioriVar+recPow(nodeIdx)/noisePow) / (1/prioriVar+1/noisePow);
end
beliefMu  = localMu;
beliefVar = localVar;        


% -------------- belief propagation ------------
for iterIdx = 1 : iterTimes
    % compute message
    for nodeIdx1 = 1 : nodeNum
        for nodeIdx2 = 1 : nodeNum
            % within communication distance            
            if topoMat(nodeIdx1,nodeIdx2) && nodeIdx1 ~= nodeIdx2 
               % compute local functions and incoming messages
               a = 1/(2*localVar(nodeIdx1));
               b = localMu(nodeIdx1) / (2*localVar(nodeIdx1));
               counter = 0;%count successful transmission 
               for nodeIdx3 = 1 : nodeNum
                    if topoMat(nodeIdx1,nodeIdx3) && nodeIdx3 ~= nodeIdx2 && (binornd(1,p)==0)
                       a = a + 1/(2*messVar(nodeIdx3,nodeIdx1)); 
                       b = b + messMu(nodeIdx3,nodeIdx1)/(2*(messVar(nodeIdx3,nodeIdx1)));
                       counter = counter + 1;
                    end    
               end
               
               % consider compatibility function
               dIdx = floor(distance(nodeIdx1,nodeIdx2)/dStep)+1;
               a = a - 1 / (2*prioriVar);
               b = b - prioriMu / (2*prioriVar);
               e = 1/(2*prioriVar*(1-compFun(3,dIdx)));
               f = sqrt(compFun(3,dIdx)) / (2*prioriVar*(1-compFun(3,dIdx)));
               r = e+a;
               q = (e-f)*prioriMu;
               a0 = e-f^2/r;
               a1 = q+f*((e-f)*prioriMu+b)/r;
               newMessMu(nodeIdx1,nodeIdx2) = a1/a0;
               newMessVar(nodeIdx1,nodeIdx2) = 1/2/a0;
                              
               if counter ~= (sum(topoMat(nodeIdx1,:))-1)
                    newMessMu(nodeIdx1,nodeIdx2) = NaN;
                    newMessVar(nodeIdx1,nodeIdx2) = NaN;
               end
               
            end
        end
    end
    
    % send out the current messages
    messMu  = newMessMu;
    messVar = newMessVar;    
    
    % compute beliefs
    for nodeIdx1 = 1 : nodeNum
        a = 1/(2*localVar(nodeIdx1));
        b = localMu(nodeIdx1) / (2*localVar(nodeIdx1));
        for nodeIdx2 = 1 : nodeNum
            % within communication distance            
            if topoMat(nodeIdx1,nodeIdx2) && nodeIdx1 ~= nodeIdx2
               a = a + 1/(2*messVar(nodeIdx2,nodeIdx1)); 
               b = b + messMu(nodeIdx2,nodeIdx1)/(2*messVar(nodeIdx2,nodeIdx1));                
            end
        end
        
        beliefMu(nodeIdx1) = b / a;
        beliefVar(nodeIdx1)= 1/2/a; 
        if isnan(beliefMu(nodeIdx1))||isnan(beliefVar(nodeIdx1))
            if iterIdx == 1
                beliefMu(nodeIdx1) = localMu(nodeIdx1);
                beliefVar(nodeIdx1) = localVar(nodeIdx1);
            else
                beliefMu(nodeIdx1) = beliefMat (1,nodeIdx1,iterIdx-1);
                beliefVar(nodeIdx1) = beliefMat (2,nodeIdx1,iterIdx-1);
            end  
        end
    end
    beliefMat (1,:,iterIdx) = beliefMu(1:nodeNum);
    beliefMat (2,:,iterIdx) = beliefVar(1:nodeNum);
    
end