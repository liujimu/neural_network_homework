%����RBF������������PID����
clear;
close all;

mode=1;%ģʽ�л���M=1Ϊ��ͨPID��M=2ΪRBF-PID

xite=0.1;%ѧϰ����
alpha=0.05;%��������
beta=0.01;
x=[0 0 0]';

m=5;%����ڵ���
ci=30*ones(3,m);%����ʸ��
bi=40*ones(m,1);%�ڵ����
w=10*ones(m,1);

h=zeros(m,1);

ci_1=ci;
ci_2=ci_1;
ci_3=ci_1;

bi_1=bi;
bi_2=bi_1;
bi_3=bi_2;

w_1=w;
w_2=w_1;
w_3=w_1;

u_1=0;
y_1=0;
xc=[0 0 0]';
error_1=0;
error_2=0;

kp0=0.03;
ki0=0.01;
kd0=0.03;

kp_1=kp0;
kd_1=kd0;
ki_1=ki0;

xitekp=0.20;
xiteki=0.20;
xitekd=0.20;

ts=0.001;
time=ts:ts:2;%ʱ������
rin=sign(sin(1.5*pi*time));%�����ź�
yout=zeros(size(time));
ymout=zeros(size(time));
dyout=zeros(size(time));
error=zeros(size(time));
kp=zeros(size(time));
ki=zeros(size(time));
kd=zeros(size(time));
for k=1:2000
    yout(k) = (-0.2 * y_1 + u_1) / (5 + y_1^2);%������ģ��
    
    for j=1:m
        h(j) = exp(-norm(x-ci(:,j))^2/(2*bi(j)*bi(j)));
    end
    ymout(k) = w'*h;%�����ʶ���
    
    d_w=0*w;
    d_bi=0*bi;
    d_ci=0*ci;
    for j=1:m
        d_w(j)=xite*(yout(k)-ymout(k))*h(j);
        d_bi(j)=xite*(yout(k)-ymout(k))*w(j)*h(j)*(bi(j)^-3)*norm(x-ci(:,j))^2;
        for i=1:3
            d_ci(i,j)=xite*(yout(k)-ymout(k))*h(j)*w(j)*(x(i)-ci(i,j))*(bi(j)^-2);
        end
    end
    w=w_1+d_w+alpha*(w_1-w_2)+beta*(w_2-w_3);
    bi=bi_1+d_bi+alpha*(bi_1-bi_2)+beta*(bi_2-bi_3);
    ci=ci_1+d_ci+alpha*(ci_1+ci_2)+beta*(ci_2-ci_3);
    
    %Jacobian��Ϣ
    yu=0;
    for j=1:m
        yu=yu+w(j)*h(j)*(-x(1)+ci(1,j))/bi(j)^2;%���ж�
    end
    dyout(k)=yu;
    error(k)=rin(k)-yout(k);

    %����PID����
    switch mode
        case 1  %RBF_PID
            kp(k)=kp_1+xitekp*error(k)*dyout(k)*xc(1);
            kd(k)=kd_1+xitekd*error(k)*dyout(k)*xc(2);
            ki(k)=ki_1+xiteki*error(k)*dyout(k)*xc(3);
            if kp(k)<0
                kp(k)=0;
            end
            if kd(k)<0
                kd(k)=0;
            end
            if ki(k)<0
                ki(k)=0;
            end
        case 2  %��ͨPID
            kp(k)=kp0;
            ki(k)=ki0;
            kd(k)=kd0+1;
    end
    
    du(k)=kp(k)*xc(1)+kd(k)*xc(2)+ki(k)*xc(3);
    u(k)=u_1+du(k);
    
    %��������
    x(1)=du(k);
    x(2)=yout(k);
    x(3)=y_1;
    
    u_1=u(k);
    y_1=yout(k);

    ci_3=ci_2;
    ci_2=ci_1;
    ci_1=ci;
    bi_3=bi_2;
    bi_2=bi_1;
    bi_1=bi;
    w_3=w_2;
    w_2=w_1;
    w_1=w;
    
    xc(1)=error(k)-error_1;
    xc(2)=error(k)-2*error_1+error_1+error_2;
    xc(3)=error(k);
    
    error_2=error_1;
    error_1=error(k);
    kp_1=kp(k);
    kd_1=kd(k);
    ki_1=ki(k);
end
figure(1)%��������Ա�
plot(time ,rin,'b',time,yout,'r');
xlabel('time(s)');
ylabel('�������');
legend('�����ź�','����ź�')
% figure(2)%
% plot(time,yout,'r',time,ymout,'b');
% xlabel('time(s)');
% ylabel('yout,ymout');
% figure(3);
% plot(time,dyout)
% xlabel('time(s)');
% ylabel('Jacobian value');
figure(4)
subplot(311)
plot(time(1:20),kp(1:20),'r');
xlabel('time(s)');
ylabel('Kp');
subplot(312)
plot(time(1:20),ki(1:20),'r');
xlabel('time(s)');
ylabel('Ki');
subplot(313)
plot(time(1:20),kd(1:20),'r');
xlabel('time(s)');
ylabel('Kd');