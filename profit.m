function profit = profit(alpha,beta,p,theta,c,h,K,T)
% profit function:
% input parameter:
% d: basic demand
% theta: quantity deteriorating rate
% lambda: quality decay rate
% p: sales price
% c: production cost
% h: holding cost per unit per unit of time
% A: ordering cost per cycle
% T: order cycles
% output parameter:
% profit: total profits at T


par1=(p-c)*(alpha-beta*p);
par2=(theta^2)\(c*theta+h)*(alpha-beta*p)*(exp(theta*T)-1)./T;
par3=theta\(c*theta+h)*(alpha-beta*p);
profit=par1-par2+par3-K./T;


end
