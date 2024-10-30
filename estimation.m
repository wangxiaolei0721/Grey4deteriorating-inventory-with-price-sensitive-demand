function pars = estimation(time0,time_train,p_vector_train,level_diff_train,level_train)
% parameter estimation
% input parameter:
% time0: the time of order arrival
% p_vector_train: the price vector
% time_train: the sample time
% level_diff_train: inventory level changes
% level_train: inventory level
% output parameter:
% pars: [theta,alpha,beta]

cell_length=length(time_train);
l=[];
L_j1=[];
L_j=[];
delta_T=[];
P=[];
for i = 1:cell_length
    time_i=[time0;time_train{i}];
    time_i_j1=time_i(1:end-1);
    time_i_j=time_i(2:end);
    time_i_diff=diff(time_i);
    delta_T=[delta_T;time_i_diff];
    level_diff_i=level_diff_train{i};
    l=[l;level_diff_i];
    level_i=level_train{i};
    L_j1=[L_j1;level_i(1:end-1)];
    L_j=[L_j;level_i(2:end)];
    % demand term
    P_i=p_vector_train(i)*ones(size(level_diff_i));
    P=[P;P_i];
end
H=[-2\(L_j1+L_j).*delta_T,-delta_T,P.*delta_T];
pars=(H'*H)\H'*l;

end

