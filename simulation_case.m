%% clear data and figure
clc;
clear;
close all;
%% model setting
% equation parameter
alpha=120;
beta=10;
theta=0.05;
%% simulation settings
% random seed
rng(0)
% the order quantity
Q_vector=300+randi([0,100],10,1);
% the sales price
p_vector=5 + randi([0,3],10,1);
% the time of order arrival
time0=0;
% the time resolution
delta_t=1;
% order cycles
m=length(Q_vector);
%% initialization of data storage
time_true = {};
time_true_t0 = {};
level_diff_true = {};
level_true = {};
time_simu = {};
time_simu_t0 = {};
level_diff_simu = {};
level_simu = {};
% generate the inventory levels
for i = 1:m
    % true level
    [time_true_i,level_diff_true_i,level_true_i] = inventory_level(alpha,beta,p_vector(i),theta,time0,delta_t,Q_vector(i));
    time_true{i}=time_true_i;
    level_diff_true{i}=level_diff_true_i;
    time_true_t0{i}=[time0;time_true_i];
    level_true{i}=[Q_vector(i);level_true_i];
    % simulated level
    [time_simu_i,level_diff_simu_i,~] = inventory_level_simulation(alpha,beta,p_vector(i),theta,time0,delta_t,Q_vector(i));
    time_simu{i} = time_simu_i;
    level_diff_simu{i}=level_diff_simu_i;
    time_simu_t0{i}=[time0;time_simu_i];
    % level_simu{i}=[Q_vector(i);level_simu_i];
end
%% cumulative generation
for i = 1:m
    time_i=[time0;time_simu{i}];
    time_i_diff=diff(time_i);
    level_diff_i=level_diff_simu{i};
    level_simu_i = [Q_vector(i);Q_vector(i) + cumsum(level_diff_i.*time_i_diff)];
    time_simu_t0{i} = time_i;
    level_simu{i}=level_simu_i;
end
%% estimation
train_length = 0.8 * m;
% simulated time for parameter estimation
time_train=time_simu(1:train_length);
level_diff_train=level_diff_simu(1:train_length);
level_train=level_simu(1:train_length);
p_vector_train = p_vector(1:train_length);
Q_vector_train = Q_vector(1:train_length);
pars = estimation(time0,time_train,p_vector_train,level_diff_train,level_train);
theta_estimate=pars(1);
alpha_estimate=pars(2);
beta_estimate=pars(3);
save(".\data\parameter.mat","alpha_estimate","beta_estimate","theta_estimate")
%% fit level
time_fit = {};
level_diff_fit = {};
time_fit_t0 = {};
level_fit = {};
for i = 1:m
    [time_fit_i,level_diff_fit_i,level_fit_i] = inventory_level(alpha_estimate,beta_estimate,p_vector(i),theta,time0,delta_t,Q_vector(i));
    time_fit{i}=time_fit_i;
    level_diff_fit{i}=level_diff_fit_i;
    time_fit_t0{i}=[time0;time_fit_i];
    level_fit{i}=[Q_vector(i);level_fit_i];
end
%% plot
% plot time vs level
finvertorydiff=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
tiledlayout(2,m/2,'Padding','Compact');
%
finvertory=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
tiledlayout(2,m/2,'Padding','Compact');
for i = 1:m
    figure(finvertorydiff)
    nexttile
    plot(time_true{i},level_diff_true{i},'LineWidth',1.5,'Marker','o','MarkerSize',6)
    hold on
    plot(time_simu{i},level_diff_simu{i},'LineWidth',1.5,'Marker','^','MarkerSize',6)
    plot(time_fit{i},level_diff_fit{i},'LineWidth',1.5,'Marker','square','MarkerSize',6)
    xlabel({'Day'},'FontSize',12)
    ylabel(['Inventory change'],'FontSize',12)
    title(strcat("(",char(96 + i),") The ", num2str(i),"th ordering cycle"),'FontSize',14)
    set(gca,'FontName','Book Antiqua','FontSize',10)
    if i==10
        legend(["Standard inventory change","Simulated inventory change","Fitted inventory change"],'location','northeast','FontSize',8,'NumColumns',1)
    end
    figure(finvertory)
    nexttile
    plot(time_true_t0{i},level_true{i},'LineWidth',1.5,'Marker','o','MarkerSize',6)
    hold on
    plot(time_simu_t0{i},level_simu{i},'LineWidth',1.5,'Marker','^','MarkerSize',6)
    % plot(time_fit_t0{i},level_fit{i},'LineWidth',1)
    xlabel({'Day'},'FontSize',12)
    ylabel(['Inventory level'],'FontSize',12)
    title(strcat("(",char(96 + i),") The ", num2str(i),"th ordering cycle"),'FontSize',14)
    set(gca,'FontName','Book Antiqua','FontSize',10)
    if i==10
        legend(["Standard inventory level","Simulated inventory level"],'location','northeast','FontSize',8,'NumColumns',1) % ,"Fitted inventory level"
    end
end

% save figure
savefig(finvertorydiff,'.\figure\simulation_diff_level.fig')
exportgraphics(finvertorydiff,'.\figure\simulation_diff_level.pdf')
savefig(finvertory,'.\figure\simulation_level.fig')
exportgraphics(finvertory,'.\figure\simulation_level.pdf')


