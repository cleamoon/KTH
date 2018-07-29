sets
  k    node            /node1, node2, node3, node4/
  i    generator       /gen1, gen2, gen3, gen4, gen5, gen6/;

alias(k,m);

table   g(k,m)  parameters known for each link
         node1   node2   node3   node4
node1      0     2.65    3.04      0
node2    2.65      0       0      1.46
node3    3.04      0       0      3.25
node4      0     1.46    3.25      0;

table   b(k,m)  parameters known for each link
         node1   node2   node3   node4
node1      0    -20.67  -23.53      0
node2   -20.67      0       0   -11.37
node3   -23.53      0       0   -25.29
node4      0    -11.37  -25.29      0;

parameter  location(i,k)   location of the generator

   /gen1.node1         1
    gen2.node1         1
    gen3.node2         1
    gen4.node2         1
    gen5.node2         1
    gen6.node2         1/;

parameter  cost(i)   variable cost  [SEK per pu per h]

   /gen1         100
    gen2         200
    gen3         100
    gen4         200
    gen5         300
    gen6         400/;

parameter  capacity(i)   maximum capacity  [pu]

   /gen1         0.4
    gen2         0.4
    gen3         0.5
    gen4         0.6
    gen5         0.7
    gen6         0.8/;

parameter  demand(k)   demand active power  [pu]

   /node1        0.78
    node2        0.50
    node3        0.14
    node4        0.89/;

variables  pg(i)         active power generated
           qg(i)         reactive power generated or absorbed
           u(k)          voltage amplitude
           theta(k)      voltage phase angles
           p(k,m)        active power transmission
           q(k,m)        reactive power transmission
           z             total;

positive variable pg;

equations
    capact(i)            generator active capacity
    capreactmin(i)       generator reactive capacity
    capreactmax(i)       generator reactive capacity
    transact(k,m)        transmission active power
    transreact(k,m)      transmission reactive power
    flowact(k)           flow balance active power
    flowreact(k)         flow balance reactive power
    totalcost            totalcost;

capact(i)        .. pg(i) =l= capacity(i);
capreactmin(i)   .. qg(i) =g= -capacity(i);
capreactmax(i)   .. qg(i) =l= capacity(i);
transact(k,m)    .. p(k,m) =e= +power(u(k),2)*g(k,m)
                           -u(k)*u(m)*g(k,m)*cos(theta(k)-theta(m))
                           -u(k)*u(m)*b(k,m)*sin(theta(k)-theta(m));
transreact(k,m)  .. q(k,m) =e= -power(u(k),2)*b(k,m)
                           +u(k)*u(m)*b(k,m)*cos(theta(k)-theta(m))
                           -u(k)*u(m)*g(k,m)*sin(theta(k)-theta(m));
flowact(k)       .. sum(i,pg(i)*location(i,k))
                    + sum(m, - p(k,m) + p(m,k)) =e= demand(k);
flowreact(k)     .. sum(i,qg(i)*location(i,k))
                    + sum(m, - q(k,m) + q(m,k)) =e= 0.0;

u.lo(k)          = 0.9;
u.up(k)          = 1.1;
theta.lo(k)      = -pi;
theta.up(k)      = pi;


totalcost     .. z =e= sum(i,pg(i)*cost(i));


model p1_basic /all/;

theta.l('node1') = uniform(-pi,pi);
theta.l('node2') = uniform(-pi,pi);
theta.l('node3') = uniform(-pi,pi);
theta.l('node4') = uniform(-pi,pi);


solve p1_basic minimizing z using NLP;

display pg.l, qg.l, u.l, theta.l , z.l;
