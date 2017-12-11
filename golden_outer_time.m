
close all;
clear all;
tic;
p.g0 = 9.807;				% Earth gravity, m/s^2
p.g_plan = [0; 0;-3.711];	% Other planet gravity, m/s^2
p.tv_max = 25;				% maximum TVC angle
p.Isp = 255;				% specific impulse, s
p.m_d = 1500;             	% drymass, kg
p.m_f = 500;              	% fuel mass, kg
p.Ft =  22000;        		% thrust
p.rho2 = p.Ft;              	% thrust, Newtons
p.rho1 = 0.15 * p.Ft;       	% lowest throttleability, Newtons
r_0 = [-2000; 1500; 2000];	% position vector, m
v_0 = [50; 70; -75];		% velocity vector, m/s
r_N =[0; 0; 0];				% terminal position, m
v_N =[0; 0; 0];				% terminal velocity, m
t_fmin = 0;
t_fmax = 100;
N = 125;

% here wi sill
		obj_fun = @(t_f)(lander(t_f, r_0, v_0, r_N, v_N, p, N));
		options = optimset('TolX',0.5,'Display','iter'); 
		tf_opt = fminbnd(obj_fun, t_fmin, t_fmax, options);

% plot the output of the optimizer
	[m_used, r, v, u, m] = lander(tf_opt, r_0, v_0, r_N, v_N, p, N);
	tv = linspace(0, tf_opt, N);
	plot_outer_3D(tv, r, v, u, m)
	toc;

%% lets try to do the successive algorithm under noise
	clear all;
	close all;
	load output_golden.mat

	dt = tf_opt/(N-1);
	index = 0;
	for tf_opt = tf_opt: -dt : 0
		index = index + 1;
		[m_used, r, v, u, m] = lander(tf_opt, r_0, v_0, r_N, v_N, p, N);
		r_0 = r(:,2) - rand(3,1);
	 	v_0 = v(:,2) - rand(3,1);
		p.m_f = m(2) - p.m_d;
		r_saved(:,index) = r(:,1);
		u_saved(:,index) = u(:,1);
		v_saved(:,index) = v(:,1);
		m_saved(:,index) = m(:,1);
	    'one loop done'
	end
	tv = linspace(0, tf_opt, index-1);
	plot_outer_3D(tv, r_saved, v_saved, u_saved, m_saved);





