{smcl}
{* *! version 2.2.0 24Jan2020}
{cmd:help xtgeebcv}{right: ({browse "https://doi.org/10.1177/1536867X211025840":SJ21-2: st0599_1})}
{hline}

{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{cmd:xtgeebcv} {hline 2}}Computes bias-corrected (small-sample) standard errors for generalized estimating equations


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:xtgeebcv} {varlist}{cmd:,} {opth cluster(varname)} [{it:options}]

{phang}
{it:varlist} contains the regression specification: the dependent variable
(outcome) followed by independent variables (predictors).  The list of
independent variables can include factor variables (specified using {cmd:i.})
and interactions.

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent :* {cmd:cluster(}{varname}{cmd:)}}specify the name of the variable indicating the clusters{p_end}
{synopt :{cmd:family(}{it:string}{cmd:)}}specify the distribution family; default is
{cmd:family(binomial)}{p_end}
{synopt :{cmd:link(}{it:string}{cmd:)}}specify the link function; default
depends on the specification of {cmd:family}; default for Gaussian, binomial, and Poisson are {cmd:link(identity)},
{cmd:link(logit)}, and {cmd:link(log)}, respectively; see table below for 
combinations of {cmd:family()} and {cmd:link()} allowed{p_end}
{synopt :{cmd:stderr(}{it:string}{cmd:)}}standard error to compute; default is
{cmd:stderr(kc)} (Kauermann-Carroll); see table below for full list of bias-corrected standard errors available{p_end}
{synopt :{cmd:statistic(}{it:string}{cmd:)}}specify the test; specifying
{cmd:statistic(t)} requests the Wald t test (the default); alternatively, the
user may specify {cmd:statistic(z)} to report 
the Wald z test instead of the Wald t test{p_end}
{synopt :{cmd:corr(}{it:string}{cmd:)}}specify the type for the working correlation;
default is {cmd:corr(exch)} (exchangeable); independence ({cmd:ind}) may also be specified{p_end}
{synopt :{it:xtgee_options}}any of the options documented in {helpb xtgee}; for example, the option {cmd:eform} will 
provide exponentiated coefficients; note that invoking {helpb xtset} is not
necessary, because
{cmd:xtgeebcv} will automatically run {helpb xtset} based on the cluster variable supplied
by the user{p_end}
{synoptline}
{p2colreset}{...}
{pstd}
* {cmd:cluster()} is required.


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtgeebcv} computes bias-corrected standard errors for generalized
estimating equations (GEEs), specifically for cluster randomized trials
(CRTs).  It is well known that below approximately 40 total clusters, GEE
robust standard-error estimates (as well as standard-error estimates from
mixed models) will almost certainly be biased.  Given that CRTs are commonly
performed in resource-limited areas, it is common only for a small number of
clusters to be randomized.

{pstd}
In this case, the type I error for time-invariant covariates (such as
treatment indicator) are inflated, leading to incorrect conclusions about
"statistical significance".  Although several small-sample bias-correction
methods have been around for 15 or more years, such methods have not yet been
implemented in Stata until now.

{pstd}
This command allows the user to obtain bias-corrected standard errors when
using GEE to estimate effects in the presence of clustering.  Although
{cmd:xtgeebcv} was motivated by CRTs, it can be used for GEE analyses of
any type of clustered data.  The types of corrections allowed (along with
references) can be found in the tables below.  For more information, see 
{help xtgeebcv##LR2015:Li and Redden (2015)} or
{help xtgeebcv##GLT2020:Gallis, Li, and Turner (2020)}.


{marker options}{...}
{title:Options}

{phang}
{opt cluster(varname)} specifies the name of the cluster indicator variable.
{cmd:cluster()} is required.

{phang}
{opt family(string)} specifies the distributional family.  The default is
{cmd:family(binomial)}.

{phang}
{opt link(string)} specifies the link function.  The following table gives
more information on the available {cmd:family()} and {cmd:link()}
combinations.  The default depends on the specification of {cmd:family()}.
The default for Gaussian, binomial, and Poisson are {cmd:link(identity)},
{cmd:link(logit)}, and {cmd:link(log)}, respectively.

{p2colset 11 30 32 40}{...}
{p2col:{cmd:family()}}{cmd:link()}{p_end}
{p2line}
{p2col: {cmd:binomial}}{cmd:logit}{p_end}
{p2col: {cmd:binomial}}{cmd:log}{p_end}
{p2col: {cmd:binomial}}{cmd:identity}{p_end}
{p2col: {cmd:poisson}}{cmd:log}{p_end}
{p2col: {cmd:poisson}}{cmd:identity}{p_end}
{p2col: {cmd:gaussian}}{cmd:identity}{p_end}
{p2line}
{p2colreset}{...}

{phang}
{opt stderr(string)} gives the standard error to compute; the default is
Kauermann-Carroll ({cmd:stderr(kc)}).  The table below gives a complete list
of specifications.  Note that the robust standard errors provided by
{cmd:xtgeebcv} will differ from Stata's default robust standard errors by a
factor of sqrt((K-1)/K), where K is the number of clusters.  This is because
Stata automatically applies a correction of sqrt(K/(K-1)) to the robust
standard errors produced by {cmd:xtgee} when using the {cmd:vce(robust)}
option.  We do not follow this Stata-specific convention of applying this
correction in this command, because 1) the robust sandwich variance of
{help xtgeebcv##LZ1986:Liang and Zeger (1986)} does not involve this
correction; 2) this robust variance of
{help xtgeebcv##LZ1986:Liang and Zeger (1986)} is the one upon which the
literature on bias-corrected sandwich variances is built 
({help xtgeebcv##MD2001:Mancl and DeRouen 2001}; 
{help xtgeebcv##KC2001:Kauermann and Carroll 2001};
{help xtgeebcv##FG2001:Fay and Graubard 2001}); and 3) other statistical
software programs do not apply this sqrt(K/(K-1)) correction to their robust
standard errors.  Thus, all the bias-corrected standard errors we implement in
this command are based on the robust standard error without the sqrt(K/(K-1))
correction.

{p2colset 11 25 27 10}{...}
{p2col:{it:string}}Description{p_end}
{p2line}
{p2col: {cmd:rb}}Robust (sandwich) standard errors{p_end}
{p2col: {cmd:df}}DF correction{p_end}
{p2col: {cmd:md}}{help xtgeebcv##MD2001:Mancl and DeRouen (2001)} correction{p_end}
{p2col: {cmd:fg}}{help xtgeebcv##FG2001:Fay and Graubard (2001)} correction{p_end}
{p2col: {cmd:kc}}{help xtgeebcv##KC2001:Kauermann and Carroll (2001)}
correction{p_end}
{p2col: {cmd:mbn}}{help xtgeebcv##MBN2003:Morel, Bokossa, and Neerchal (2003)}
correction{p_end}
{p2line}
{p2colreset}{...}

{phang}
{opt statistic(string)} specifies the test.  Specifying {cmd:statistic(t)}
requests the Wald t test (the default).  Alternatively, the user may specify
{cmd:statistic(z)} to report the Wald z test instead of the Wald t test.

{phang}
{opt corr(string)} specifies the type for the working correlation.  The
default is {cmd:corr(exch)} (the exchangeable correlation).  The user may
instead specify {cmd:ind} (the independent correlation matrix).

{phang}
{it:xtgee_options} are any of the options documented in {helpb xtgee}.  For
example, the option {cmd:eform} will provide exponentiated coefficients.  Note
that invoking the Stata command {cmd:xtset} (used to declare the clustering
variable) is not necessary, because the command will automatically run
{cmd:xtset} based on the variable supplied to the {cmd:cluster()} option.


{marker example}{...}
{title:Example}

{pstd}
The example uses data referred to in
{help xtgeebcv##H2009:Hayes and Moulton (2009)}.  The goal of the trial was to
evaluate the impact of a sexual health intervention on various HIV-related
outcomes.  The data available for download include male participants at
follow-up.  The main outcome is "good knowledge of HIV acquisition", a binary
variable.  In this dataset, 20 communities were randomized to receive either
intervention or "standard activities".  Below, we demonstrate the application
of the Kauermann-Carroll corrected standard errors in GEE modeling of the
binary outcome.

{pstd}
Open dataset{p_end}
{phang2}{cmd:. use mkvtrial.dta}{p_end}

{pstd}
Run {cmd:xtgeebcv}, obtaining odds-ratio estimates and Kauermann-Carroll
standard errors{p_end}
{phang2}{cmd:. quietly tabulate stratum, generate(stratum)}{p_end}
{phang2}{cmd:. xtgeebcv know i.arm i.stratum i.ethnicgp, family(binomial) link(logit) cluster(community) stderr(kc) eform nolog}

{pstd}
For illustration, subset the dataset to stratum 2 and rerun{p_end}
{phang2}{cmd:. keep if stratum == 2}{p_end}
{phang2}{cmd:. xtgeebcv know i.arm i.ethnicgp, family(binomial) link(logit) cluster(community) stderr(kc) eform nolog}

{pstd}
Also, run the model to obtain the robust standard errors for comparison{p_end}
{phang2}{cmd:. xtgeebcv know i.arm i.ethnicgp, family(binomial) link(logit) cluster(community) stderr(rb) eform nolog}


{marker acknowledgment}{...}
{title:Acknowledgment}
The authors of this program would like to thank Dr. Andrew Forbes of Monash
University for his help in discovering the issue with
the standard error calculation when specifying an offset term and help in
suggesting corrections to the program account for the offset term.


{marker reference}{...}
{title:References}

{marker FG2001}{...}
{phang}
Fay, M. P., and B. I. Graubard. 2001. Small-sample adjustments for Wald-type
tests using sandwich estimators. {it:Biometrics} 57: 1198-1206.
{browse "https://doi.org/10.1111/j.0006-341X.2001.01198.x"}.

{marker GLT2020}{...}
{phang}
Gallis, J. A., F. Li, and E. L. Turner. 2020.  xtgeebcv: A command for
bias-corrected sandwich variance estimation for GEE analyses of cluster
randomized trials. {it:Stata Journal} 20: 363-381.
{browse "https://doi.org/10.1177/1536867X20931001"}.

{marker H2009}{...}
{phang}
Hayes, R. J., and L. H. Moulton. 2009.
{it:Cluster Randomised Trials}. Boca Raton, FL: Chapman & Hall/CRC.

{marker KC2001}{...}
{phang}
Kauermann, G., and R. J. Carroll. 2001. A note on the efficiency of sandwich
covariance matrix estimation.
{it:Journal of the American Statistical Association} 96: 1387-1396.
{browse "https://doi.org/10.1198/016214501753382309"}.

{marker LR2015}{...}
{phang}
Li, P., and D. T. Redden. 2015. Small sample performance of bias-corrected
sandwich estimators for cluster-randomized trials with binary outcomes.
{it:Statistics in Medicine} 34: 281-296.
{browse "https://doi.org/10.1002/sim.6344"}.

{marker LZ1986}{...}
{phang}
Liang, K.-Y., and S. L. Zeger. 1986. Longitudinal data analysis using
generalized linear models. {it:Biometrika} 73: 13-22.
{browse "https://doi.org/10.1093/biomet/73.1.13"}.

{marker MD2001}{...}
{phang}
Mancl, L. A., and T. A. DeRouen. 2001. A covariance estimator for GEE with
improved small-sample properties. {it:Biometrics} 57: 126-134.
{browse "https://doi.org/10.1111/j.0006-341x.2001.00126.x"}.

{marker MBN2003}{...}
{phang}
Morel, J. G., M. C. Bokossa, and N. K. Neerchal. 2003. Small sample correction
for the variance of GEE estimators. {it:Biometrical Journal} 45: 395-409.
{browse "https://doi.org/10.1002/bimj.200390021"}.


{marker author}{...}
{title:Authors}

{pstd}
John A. Gallis{break}
Department of Biostatistics and Bioinformatics{break}
Duke University{break}
Duke Global Health Institute{break}
Durham, NC{break}
john.gallis@duke.edu

{pstd}
Fan Li{break}
Department of Biostatistics{break}
Yale School of Public Health{break}
New Haven, CT{break}
fan.f.li@yale.edu

{pstd}
Elizabeth L. Turner{break}
Department of Biostatistics and Bioinformatics{break}
Duke University{break}
Duke Global Health Institute{break}
Durham, NC{break}
liz.turner@duke.edu


{marker alsosee}{...}
{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 21, number 2: {browse "https://doi.org/10.1177/1536867X211025840":st0599_1},{break}
          {it:Stata Journal}, volume 20, number 2: {browse "https://doi.org/10.1177/1536867X20931001":st0599}{p_end}
