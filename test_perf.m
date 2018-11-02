clear;
clc;
rng('default'); 
nodeNum      = 400;
rangeInMeter = 2000;
testTime     = 10;
noisePow     = [1, 3, 10];
primRange    = 1000;
commRange    = 200;
dStep        = 20;
BPIterTimes  = [0, 3, 10];
prob = 0.01; %transmission error rate 1%

fp = fopen('compFun.txt','r');
if fp == -1 
   [mu, var, rho] = trainCompatibility(dStep, rangeInMeter, commRange);
   fp = fopen('compFun.txt','w');       
   fprintf(fp,'%f ',mu);
   fprintf(fp,'\n');
   fprintf(fp,'%f ',var);   
   fprintf(fp,'\n');   
   fprintf(fp,'%f ',rho);      
   fprintf(fp,'\n');   
   fclose(fp);
else
   fclose(fp); 
   load compFun.txt;
end

for noiseIdx = 1 : 3
    for iterIdx = 1 : 3
        for maxMDRate = 0.1:0.1:0.9 
            [noiseIdx, iterIdx, maxMDRate]
            totInNum(1:2)  = 0;
            totOutNum(1:2) = 0;
            totMDNum(1:2)  = 0;
            totFANum(1:2)  = 0;

            for testIdx = 1 : testTime % runTime
                positions = dropNodes(nodeNum, rangeInMeter, primRange);
                [distance, recPow, truePow] = simuRecPow(nodeNum, positions, noisePow(noiseIdx));
                topoMat = getToplology(distance, commRange, nodeNum);
                linkdegree = sum(topoMat,1);
                [beliefMat ,beliefMu, beliefVar] = calBP(nodeNum, recPow, topoMat, distance, compFun, dStep, BPIterTimes(iterIdx), commRange, noisePow(noiseIdx), prob);
                [mDNum, fANum, inNum, outNum] = checkBelief(nodeNum, positions, beliefMu, beliefVar, primRange, maxMDRate, topoMat);    
                totInNum  = totInNum + inNum;
                totOutNum = totOutNum + outNum;
                totMDNum  = totMDNum + mDNum;
                totFANum  = totFANum + fANum;
            end

            mDRateS = totMDNum ./ totInNum;
            fARateS = totFANum ./ totOutNum;
            mDRateT = sum(totMDNum) / sum(totInNum);
            fARateT = sum(totFANum) / sum(totOutNum);
            coopInR = totInNum(2) / sum(totInNum);
            coopOuR = totOutNum(2) / sum(totOutNum);
            totCooR = (totInNum(2) + totOutNum(2)) / (sum(totInNum) + sum(totOutNum));            
            
            fp = fopen('result.txt','a');
            fprintf(fp, '%f ', [noiseIdx, iterIdx, maxMDRate, mDRateS,fARateS,mDRateT,fARateT,coopInR,coopOuR,totCooR]);
            fprintf(fp, '\n');
            fclose(fp);
        end
    end
end