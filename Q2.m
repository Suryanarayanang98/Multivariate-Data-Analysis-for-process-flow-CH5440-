T = xlsread('C:\Users\asus\Documents\SEM 5\ghg-concentrations_1984-2014.xlsx');
T = removevars(T,{'Year'});  
% T = removevars(T,{'Year','O3','CH4','N2O'});  %TRY SINGLE VAR
Z = table2array(T);

size_Z = size(Z);
num_samples = size_Z(1);
num_vars = size_Z(2) - 1;

% OLS
Y = Z(:,end);
X = Z(:,1:end-1);

% Xs = X;
% Ys = Y;

X_bar = mean(X);
Xs = X - X_bar;
std_X = std(Xs);
Xs = Xs./(ones(num_samples,1)*std_X);
Y_bar = mean(Y);
Ys = Y - Y_bar;
std_Y = std(Ys);
Ys = Ys./std_Y;

a_ols = ((Xs')*Xs)\(Xs')*Ys;
a_ols = a_ols./(std_X)'
b_ols = Y_bar - X_bar*a_ols

%TLS
Z_bar = mean(Z);
Zs = Z - Z_bar;
std_Z = std(Zs);
Zs = Zs./(ones(num_samples,1)*std_Z);

covar = cov(Zs);
[a_tls,min_eigval] = eigs(covar, 1, 'smallestabs');

a_tls = a_tls./(std_Z)';
a_tls = a_tls/a_tls(end);
a_tls = - a_tls(1:end-1,:)
b_tls = Y_bar - X_bar*a_tls


% x = linspace(-10,10,50);
% y = b_ols + a_ols * x;
% plot(x,y);
% hold on;
% 
% x = linspace(-10,10,50);
% y = b_tls + a_tls * x;
% plot(x,y);
% hold off;
% 
