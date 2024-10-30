function [time_simu,level_diff_simu,level_simu] = inventory_level_simulation(alpha,beta,p,theta,time0,delta_t,Q)
% simulate inventory levels and inventory changes
% input parameter:
% alpha: basic demand
% beta: price sensitivity coefficient
% p: price
% std_dev: standard deviation of error in demand regression equation
% theta: deteriorating rate
% time0: the time of order arrival
% delta_t: the time resolution
% Q: the order quantity
% output parameter:
% time_simu: simulated sampling time
% demand_simu: simulated demand quantity
% level_diff_simu: simulated inventory changes
% level_simu: simulated inventory level


% initial inventory data
time_simu=[];
level_diff_simu = [];
level_simu = [];
% initial inventory level
level_remain=Q;
% record t_{k-1}
time_k1=time0;
% record t_k
time_k=time_k1+delta_t;
% demand quantity
demand = delta_t*(alpha-beta*p);
% deteriorating quantity
deterioration=delta_t*theta*(0.5*levelattime(alpha,beta,p,theta,time_k,time0,Q) ...
    +0.5*levelattime(alpha,beta,p,theta,time_k1,time0,Q));
% random reduction
reduction = poissrnd(demand+deterioration);
% level remain = level remain - random reduction
level_remain=level_remain-reduction;
while level_remain > 0
    % store sampling time
    time_simu=[time_simu;time_k];
    % store inventory level and changes
    level_simu=[level_simu;level_remain];
    level_diff_simu = [level_diff_simu;-reduction];
    % update t_{k-1}
    time_k1=time_k;
    % update t_{k}
    time_k=time_k+delta_t;
    % demand quantity
    demand = delta_t*(alpha-beta*p);
    % deteriorating quantity
    deterioration=delta_t*theta*(0.5*levelattime(alpha,beta,p,theta,time_k,time0,Q) ...
        +0.5*levelattime(alpha,beta,p,theta,time_k1,time0,Q));
    % random reduction
    reduction = poissrnd(demand+deterioration);
    % level remain = level remain - random reduction
    level_remain=level_remain-reduction;
end


end

