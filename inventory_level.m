function [time,level_diff,level] = inventory_level(alpha,beta,p,theta,time0,delta_t,Q)
% generate inventory levels and inventory changes 
% input parameter:
% alpha: basic demand
% beta: price sensitivity coefficient
% p: price
% theta: deteriorating rate
% time0: the time of order arrival
% delta_t: the time resolution
% Q: the order quantity
% output parameter
% time: sampling time
% demand: demand quantity
% level: inventory level
% level_diff: inventory changes


% calculate order cycle based on order quantity
T=theta\log(Q*theta/(alpha-beta*p)+1);
% the moment when the inventory drops to 0
tT=time0+T;
% generate sampling time with time resolution as the step size
time=[(time0+delta_t):delta_t:tT]';
% inventory levels
level=theta\(alpha-beta*p)*(exp(theta*(tT-time))-1);
% inventory changes
level_diff=diff([Q;level]);


end

