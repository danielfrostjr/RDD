capture log close
log using "C:\Users\Daniel\Documents\MA Econ\Causal Inference\Replications\RDD\Do\Replication 1 Experiment", smcl replace
//_1
display c(current_date)
//_2
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear
//_3
gen bac_dummy = (bac1 >= 0.08)
//_4
quietly hist bac1, width(0.001000001)
//_5
rddensity bac1, c(0.08) kernel(uniform)
quietly graph export ".\Figures\pic1.png", width(500) replace
//_6
quietly rdrobust male bac1, c(0.08) h(0.05) kernel(uniform)
eststo
quietly rdrobust white bac1, c(0.08) h(0.05) kernel(uniform)
eststo
quietly rdrobust aged bac1, c(0.08) h(0.05) kernel(uniform)
eststo
quietly rdrobust acc bac1, c(0.08) h(0.05) kernel(uniform)
eststo
esttab using ".\Tables\table1.tex", se("%g") label title("Covariate Balance") mtitles("Male" "White" "Age" "Accident") replace rename(RD_Estimate DUI)
eststo clear
//_7
quietly cmogram acc bac1, scatter cutpoint(0.08)
quietly graph export ".\Figures\pic2.png", width(500) replace
//_8
quietly cmogram acc bac1 if bac1 <= 0.2 & bac1 >= 0.04, scatter cutpoint(0.08) lfitci lineat(0.08)
quietly graph export ".\Figures\pic3.png", width(500) replace
quietly cmogram male bac1 if bac1 <= 0.2 & bac1 >= 0.04, scatter cutpoint(0.08) lfitci lineat(0.08)
quietly graph export ".\Figures\pic4.png", width(500) replace
quietly cmogram aged bac1 if bac1 <= 0.2 & bac1 >= 0.04, scatter cutpoint(0.08) lfitci lineat(0.08)
quietly graph export ".\Figures\pic5.png", width(500) replace
quietly cmogram white bac1 if bac1 <= 0.2 & bac1 >= 0.04, scatter cutpoint(0.08) lfitci lineat(0.08)
quietly graph export ".\Figures\pic6.png", width(500) replace
//_9
quietly cmogram acc bac1 if bac1 <= 0.2 & bac1 >= 0.04, scatter cutpoint(0.08) qfitci lineat(0.08)
quietly graph export ".\Figures\pic7.png", width(500) replace
quietly cmogram male bac1 if bac1 <= 0.2 & bac1 >= 0.04, scatter cutpoint(0.08) qfitci lineat(0.08)
quietly graph export ".\Figures\pic8.png", width(500) replace
quietly cmogram aged bac1 if bac1 <= 0.2 & bac1 >= 0.04, scatter cutpoint(0.08) qfitci lineat(0.08)
quietly graph export ".\Figures\pic9.png", width(500) replace
quietly cmogram white bac1 if bac1 <= 0.2 & bac1 >= 0.04, scatter cutpoint(0.08) qfitci lineat(0.08)
quietly graph export ".\Figures\pic10.png", width(500) replace
//_10
quietly gen bac_sq = bac1 * bac1
quietly gen bac_inter = bac1* bac_dummy
quietly gen bac_inter_sq = bac1 * bac1 * bac_dummy
//_11
quietly rdrobust recidivism bac1 if bac1 >= 0.03 & bac1 <= 0.13, c(0.08) h(0.05) kernel(uniform) covs(bac1) all
eststo
quietly rdrobust recidivism bac1 if bac1 >= 0.03 & bac1 <= 0.13, c(0.08) h(0.05) kernel(uniform) covs(bac1     bac_dummy bac_inter) all
eststo
quietly rdrobust recidivism bac1 if bac1 >= 0.03 & bac1 <= 0.13, c(0.08) h(0.05) kernel(uniform) covs(bac1 bac_dummy bac_inter bac_sq bac_inter_sq) all
eststo
//_12
esttab using ".\Tables\table2.tex", se("%g") label title("Panel A: Recidivism Local Linear Regression") mtitles("BAC control" "Linear interaction" "Linear, quad. interactions") replace drop(Conventional Bias*)
eststo clear
//_13
quietly rdrobust recidivism bac1 if bac1 >= 0.055 & bac1 <= 0.105, c(0.08) h(0.05) kernel(uniform) covs(bac1) all
eststo
quietly rdrobust recidivism bac1 if bac1 >= 0.055 & bac1 <= 0.105, c(0.08) h(0.05) kernel(uniform) covs(bac1     bac_dummy bac_inter) all
eststo
quietly rdrobust recidivism bac1 if bac1 >= 0.055 & bac1 <= 0.105, c(0.08) h(0.05) kernel(uniform) covs(bac1 bac_dummy bac_inter bac_sq bac_inter_sq) all
eststo
//_14
esttab using ".\Tables\table3.tex", se("%g") label title("Panel B: Recidivism Local Linear Regression") mtitles("BAC control" "Linear interaction" "Linear, quad. interactions") replace drop(Conventional Bias*)
eststo clear
//_15
quietly cmogram recidivism bac1 if bac1 <= 0.15, scatter cutpoint(0.08) lfitci lineat(0.08)
quietly graph export ".\Figures\pic11.png", width(500) replace
//_16
quietly cmogram recidivism bac1 if bac1 <= 0.15, scatter cutpoint(0.08) qfitci lineat(0.08)
quietly graph export ".\Figures\pic12.png", width(500) replace
//_^
log close
