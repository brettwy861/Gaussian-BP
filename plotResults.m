clear;
clc;
load result.txt;
figure(1)
k=0;hold;
plot(result(1+k:9+k,9),result(1+k:9+k,8),'b-.x');
plot(result(10+k:18+k,9),result(10+k:18+k,8),'b-.o');
plot(result(19+k:27+k,9),result(19+k:27+k,8),'b-.d');
k=27;
plot(result(1+k:9+k,9),result(1+k:9+k,8),'r-x');
plot(result(10+k:18+k,9),result(10+k:18+k,8),'r-o');
plot(result(19+k:27+k,9),result(19+k:27+k,8),'r-d');
k=27*2;
plot(result(1+k:9+k,9),result(1+k:9+k,8),'k--x');
plot(result(10+k:18+k,9),result(10+k:18+k,8),'k--o');
plot(result(19+k:27+k,9),result(19+k:27+k,8),'k--d');
legend('\sigma^2 = 1, IterNo = 0','\sigma^2 = 1, IterNo = 3', '\sigma^2 = 1, IterNo = 10',...
    '\sigma^2 = 3, IterNo = 0','\sigma^2 = 3, IterNo = 3','\sigma^2 = 3, IterNo = 10',...
    '\sigma^2 = 10, IterNo = 0','\sigma^2 = 10, IterNo = 3', '\sigma^2 = 10, IterNo = 10')
title('Gaussian Belief Propagation Convergence')
xlabel('False Alarm Rate')
ylabel('Miss Detection Rate')
grid on
