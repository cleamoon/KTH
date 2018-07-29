import numpy as np

print(np.__version__)
H = np.array([[1, 0], [0, 1]])
c = np.array([[1], [1]])
A = np.array([[1, 0], [0, 1]])
b = np.array([[1], [1]])
mu = 1
x = np.array([[1], [1]])
lbd = np.array([[1], [1]])
e = np.array([[1], [1]])
S = np.eye(2)
alpha = np.array([[0], [0]])

while True:
    LBD = np.linalg.inv(np.diag((lbd.T)[0]))
    delta = np.linalg.inv(np.block([[H, A.T], [A, -S.dot(np.linalg.inv(LBD))]])).dot((-np.block([[H.dot(x) + c - A.T.dot(lbd)], [A.dot(x) - b - mu*LBD.dot(e)]])))
    #print(delta)
    for i in range(2,4):
        if abs(delta[i]) < 0.001: 
            alpha[i-2] = 0.999;
        else:
            alpha[i-2] = min(lbd[i-2]/delta[i], 0.999)
    x = delta[0:2]*alpha
    lbd = delta[2:4]*alpha
    #print(lbd)
    if lbd.all() > 0:
        break;
    
print("The optimal feasible point is ", x.T)
print("The optimal solution is ", (0.5*x.T.dot(H.dot(x)) + c.T.dot(x)))