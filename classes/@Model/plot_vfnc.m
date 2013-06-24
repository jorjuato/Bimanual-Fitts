function plot_vfnc(mdl)
	if mdl.stype >=2
		mdl.plot_cart_vf()
		mdl.plot_torus_vf()
	end
end
