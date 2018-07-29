function B = reduce_size(A,hstep,interval)


[m,n]=size(A);
B=zeros((m-1)/(interval/hstep)+1,n);
B(1,:)=A(1,:);
for i=2:((m-1)/(interval/hstep)+1)
    B(i,:)=A(interval*(i-1)/hstep+1,:);
end


end