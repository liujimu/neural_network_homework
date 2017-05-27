close all
clear
k = 2;
p = -1:0.02:1;
y = 2*sin(k*pi*p);
n = 12;
net = newff(p,y,n);
[net,tr] = train(net,p,y);
outputs = net(p);
errors = outputs - y;
perf = perform(net,outputs,y);
figure(1)
plot(p,y,p,outputs,'*');
xlabel('p');
ylabel('y');
% legend('逼近对象','BP网络输出','Location','northwest');
legend('逼近对象','BP网络输出');
% grid on
figure(2)
plot(p,errors)
xlabel('p');
ylabel('error');
% grid on
