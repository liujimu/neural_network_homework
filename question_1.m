close all
clear
k = 2;
p = -1:0.02:1;
y = 2*sin(k*pi*p);
n = 10;
net = newff(p,y,n);
net = train(net,p,y);
outputs = net(p);
errors = outputs - y;
perf = perform(net,outputs,y);
figure
plot(p,y,p,outputs,'*');
figure
plot(p,errors)