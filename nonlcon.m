function [c,ceq] = nonlcon(x)
%nonlcon ������Լ������
c = [-64.868 * x(1)^2 * x(2) + 1.2 * 140^2 * pi * 12.84 / 4;
     -215 * pi / x(2) + 5 * x(1);
     -12 * x(1) + 205 * pi / x(2)];
ceq = [];
end

