function positions = dropNodes(nodeNum, rangeInMeter, primeRange)

 rho = primeRange + (rand(1,nodeNum)*2-1)*primeRange/3;
 phi = rand(1,nodeNum)*2*pi;
 positions = [rho .* cos(phi); rho .* sin(phi)];

 %positions = (rand(2, nodeNum)*2-1) * rangeInMeter;
scatter(positions(1,:),positions(2,:),'.');
