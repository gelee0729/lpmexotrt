*! Myoung-jae Lee, Goeun Lee, and Jin-young Choi, "Linear Probability Model Revisited: Why It Works and How It Should Be Specified", Sociological Methods & Research, 2023, Advance online publication.
*! version 0.0.1 16apr2023

set more off
clear all
cd ""  // change directory in which lt2005sub.dta exists

use lt2005sub.dta, clear

global y "work1"
global d "work0"

global xc "age"  // time-invariant X
global xv0 "married0 edu0 kids0 linc0"  // time-varying X0 at t=0
global xv1 "married1 edu1 kids1 linc1"  // time-varying X1 at t=1

global x0 "$xc $xv0"  // X0 at t=0
global x1 "$xc $xv1"  // X1 at t=1
global xx "$xc $xv0 $xv1"  // (X0,X1)

// Syntax: lpmexotrt Y D X
// Output: R2_D, R2_Y|D=0, LPM, PSR(2), PSR(3)
program define lpmexotrt
	version 17.0
	syntax anything
	tempname r2d r2y lpm_est lpm_var lpm lpmtv psr_est2 psr2 psr_var2 psrtv2 ///
		psr_est3 psr3 psr_var3 psrtv3
	tempvar pix dres xa dxa ow0 si0 pix2 pix3 yres2 yres3 v2 v3
	
	local yv = "`1'"
	local dv = "`2'"
	local xv = subinword("`anything'","`yv' `dv'","",.)
	
	// R-squared for D
	qui reg `dv' `xv'
	scalar `r2d' = e(r2_a)
	
	// R-squared for Y|D=0
	qui reg `yv' `xv' if `dv'==0
	scalar `r2y' = e(r2_a)
	
	// LPM
	qui reg `yv' `dv' `xv', vce(r)
	mat `lpm_est' = e(b)
	mat `lpm_var' = e(V)
	scalar `lpm' = `lpm_est'[1,1]
	scalar `lpmtv' = `lpm'/sqrt(`lpm_var'[1,1])
	
	// Propensity Score
	qui probit `dv' `xv'
	qui predict `pix', pr
	qui gen `dres' = `dv'-`pix'
	qui predict `xa', xb
	qui gen `dxa' = normalden(`xa')
	qui gen `ow0' = `pix'*(1-`pix')
	qui gen `si0' = (`dres'*`dxa')/`ow0'
	qui replace `si0' = 0 if `ow0'==0
	local nn = e(N)
	
	local END "end"
	mata:
	mata clear
	dresv = st_data(.,"`dres'"); ome0 = mean(dresv:^2):^(-2);
	dxav = st_data(.,"`dxa'"); xv = (st_data(.,"`xv'"),J(`nn',1,1))
	si = st_data(.,"`si0'"):*xv; eta = invsym((si'si):/`nn')*si'
	`END'
	
	// PSR
	local pixx = "`' `pix'"
	forv j = 2/3 {
		qui gen `pix`j'' = `pix'^`j'
		local pixx = "`pixx' `pix`j''"
		
		qui reg `yv' `pixx'
		qui predict `yres`j'', r
		qui reg `yres`j'' `dres', nocons
		mat `psr_est`j'' = e(b)
		scalar `psr`j'' = `psr_est`j''[1,1]
		qui predict `v`j'', r
		
		mata:
		vv_`j' = st_data(.,"`v`j''"); la_`j' = mean(vv_`j':*dxav:*xv)
		ome1_`j' = mean((vv_`j':*dresv - (la_`j'*eta)'):^2)
		st_matrix("`psr_var`j''",ome0:*ome1_`j':/`nn')
		`END'
		scalar `psrtv`j'' = `psr`j''/sqrt(`psr_var`j''[1,1])
	}
	
	di ""
	di "    R2 for D: " `r2d'
	di "R2 for Y|D=0: " `r2y'
	di "LPM     (tv): " `lpm'  " ( " `lpmtv'  " )"
	di "PSR(2)  (tv): " `psr2' " ( " `psrtv2' " )"
	di "PSR(3)  (tv): " `psr3' " ( " `psrtv3' " )"
end

// Summary Statistics (Table 1)
su $y $d married1 age edu1 kids1 inc1
tab $d $y

// Estimation Results (Table 2)
lpmexotrt $y $d $x0  // Regressor X0 at t=0
lpmexotrt $y $d $x1  // Regressor X1 at t=1
lpmexotrt $y $d $xx  // Regressor (X0,X1)

set more on
