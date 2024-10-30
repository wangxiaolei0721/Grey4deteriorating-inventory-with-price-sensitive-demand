% clear data and figure
clc;
clear;
close all;
%% model setting
% equation parameters
alpha=120;
beta=10;
theta=0.05;
% load estimated parameters
load(".\data\parameter.mat")
%% economic order quantity
% economic parameter
c=4.0;
h=0.02;
K=50;
% price interval
p_simu_interval=[c alpha/beta];
% price interval based on estimates
p_fit_interval=[c alpha_estimate/beta_estimate];
% cycle interval
T_interval=[1 7];
%% plot profit function
% order cycle to be evaluated
profit_simu_fd = @(p,T) profit(alpha,beta,p,theta,c,h,K,T);
profit_appro_simu_fd = @(p,T) profit_appro(alpha,beta,p,theta,c,h,K,T);
% [xmin xmax ymin ymax]
fprofit_opt=figure;
fsurf(profit_simu_fd,[p_simu_interval,T_interval])
hold on
fsurf(profit_appro_simu_fd,[p_fit_interval,T_interval])
%% solve
% true profit
syms p T;
profit_simu_syms = profit(alpha,beta,p,theta,c,h,K,T);
profit_der_p=diff(profit_simu_syms,p);
profit_der_T=diff(profit_simu_syms,T);
eq1 = profit_der_p == 0;
eq2 = profit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_simu_interval;T_interval]);
p_simu_opt  = double(sol.p);
T_simu_opt  = double(sol.T);
% The profit corresponding to the optimal point
profit_simu_opt = profit(alpha,beta,p_simu_opt,theta,c,h,K,T_simu_opt);
plot3(p_simu_opt,T_simu_opt,profit_simu_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[0 1 0],'MarkerSize',20)
% fit profit
profit_fit_syms = profit(alpha_estimate,beta_estimate,p,theta_estimate,c,h,K,T);
profit_fit_der_p=diff(profit_fit_syms,p);
profit_fit_der_T=diff(profit_fit_syms,T);
eq1 = profit_fit_der_p == 0;
eq2 = profit_fit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_fit_interval;T_interval]);
p_fit_opt  = double(sol.p);
T_fit_opt  = double(sol.T);
% The profit corresponding to the optimal point
profit_fit_opt = profit(alpha_estimate,beta_estimate,p_fit_opt,theta_estimate,c,h,K,T_fit_opt);
plot3(p_fit_opt,T_fit_opt,profit_fit_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[1 0.200000002980232 0.200000002980232],'MarkerSize',15)
xlabel({'Price'},'FontSize',12)
ylabel(['Ordering cycle'],'FontSize',12)
zlabel(['Profit'],'FontSize',12)
legend(["Simulated profit surface","Estimated profit surface","Simulated optimal point","Estimated optimal point"],'location','northeast','FontSize',8,'NumColumns',1)
%% plot approximated profit function
% order cycle to be evaluated
profit_appro_simu_fd = @(p,T) profit_appro(alpha,beta,p,theta,c,h,K,T);
profit_appro_fit_fd = @(p,T) profit_appro(alpha_estimate,beta_estimate,p,theta_estimate,c,h,K,T);
% [xmin xmax ymin ymax]
fprofit_appro_opt=figure;
fsurf(profit_appro_simu_fd,[p_simu_interval,T_interval])
hold on
fsurf(profit_appro_fit_fd,[p_fit_interval,T_interval])
%% solve
% approximated profit for true pars
syms p T;
profit_appro_simu_syms = profit_appro(alpha,beta,p,theta,c,h,K,T);
profit_appro_der_p=diff(profit_appro_simu_syms,p);
profit_appro_der_T=diff(profit_appro_simu_syms,T);
eq1 = profit_appro_der_p == 0;
eq2 = profit_appro_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_simu_interval;T_interval]);
p_appro_simu_opt  = double(sol.p);
T_appro_simu_opt  = double(sol.T);
% The profit corresponding to the optimal point
profit_appro_simu_opt = profit_appro(alpha,beta,p_appro_simu_opt,theta,c,h,K,T_appro_simu_opt);
plot3(p_appro_simu_opt,T_appro_simu_opt,profit_appro_simu_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[0 1 0],'MarkerSize',20)
% plot
fprofit_appro_p=figure;
profit_appro_simu_p = @(p) profit_appro(alpha,beta,p,theta,c,h,K,T_appro_simu_opt);
fplot(profit_appro_simu_p,p_simu_interval,'Marker','o','MarkerSize',6)
hold on
% approximated profit for fit pars
profit_appro_fit_syms = profit_appro(alpha_estimate,beta_estimate,p,theta_estimate,c,h,K,T);
profit_appro_fit_der_p=diff(profit_appro_fit_syms,p);
profit_appro_fit_der_T=diff(profit_appro_fit_syms,T);
eq1 = profit_appro_fit_der_p == 0;
eq2 = profit_appro_fit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_fit_interval;T_interval]);
p_appro_fit_opt  = double(sol.p);
T_appro_fit_opt  = double(sol.T);
% The profit corresponding to the optimal point
profit_appro_fit_opt = profit_appro(alpha_estimate,beta_estimate,p_appro_fit_opt,theta_estimate,c,h,K,T_appro_fit_opt);
figure(fprofit_appro_opt)
plot3(p_appro_fit_opt,T_appro_fit_opt,profit_appro_fit_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[1 0.200000002980232 0.200000002980232],'MarkerSize',15)
xlabel({'Price'},'FontSize',12)
ylabel(['Ordering cycle'],'FontSize',12)
zlabel(['Profit'],'FontSize',12)
legend(["Simulated profit surface","Estimated profit surface","Simulated optimal point","Estimated optimal point"],'location','northeast','FontSize',8,'NumColumns',1)
% plot
figure(fprofit_appro_p)
profit_p = @(p) profit(alpha,beta,p,theta,c,h,K,T_appro_fit_opt);
fplot(profit_p,p_fit_interval,'Marker','^','MarkerSize',6)
xlabel({'Price'},'FontSize',12)
ylabel(['Profit'],'FontSize',12)
legend(["True profit surface","Estimated profit surface"],'location','northeast','FontSize',8,'NumColumns',1)
%% save figure
savefig(fprofit_opt,'.\figure\profit_opt.fig')
exportgraphics(fprofit_opt,'.\figure\profit_opt.pdf')
savefig(fprofit_appro_opt,'.\figure\profit_appro_opt.fig')
exportgraphics(fprofit_appro_opt,'.\figure\profit_appro_opt.pdf')




