function J = Jacobian4(X1, Xmin, Xmax)
% returns the Jacobian
J = [];
for i = 1:size(X1,2)
    dx = (Xmax(i)-Xmin(i))/1.e6;
    if X1(i)+dx > Xmax(i)
        dx = -dx;
    end
    X2 = X1;
    X2(i) = X2(i) + dx;
    j = (ObjFunction(X2)-ObjFunction(X1))/dx;
    J = [J j];
end

% ANSWER:

% strike = 240.01;    % °
% length = 14.479;    % km
% obj = 4.0659