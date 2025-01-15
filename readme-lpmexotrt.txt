Replication data and code for "Linear Probability Model Revisited: Why It Works and How It Should Be Specified" by Myoung-jae Lee, Goeun Lee, and Jin-young Choi (Sociological Methods & Research, 54(1), 2025, 173--186, DOI: https://doi.org/10.1177/00491241231176850)


*********! Data
The data called "lt2005sub.dta" (for Stata) was extracted from the Korean Labor and Income Panel Study data used in Lee and Tae (2005). It consists of 3,395 Korean women aged 20 to 60 in the year 2000. Variable names and descriptions are provided below.

      Obs: 3,395
# of Vars:    14
id       : Individual identifier
age      : Age in 2000 (t=1)
work1    : Labor participation dummy in 2000 (t=1), =1 if worked
work0    : Labor participation dummy in 1999 (t=0), =1 if worked
married1 : Marriage dummy in 2000 (t=1), =1 if married
married0 : Marriage dummy in 1999 (t=0), =1 if married
edu1     : Education completion categories (0 to 6) in 2000 (t=1)
edu0     : Education completion categories (0 to 6) in 1999 (t=0)
kids1    : Number of children aged 1 to 13 in 2000 (t=1)
kids0    : Number of children aged 1 to 13 in 1999 (t=0)
inc1     : Family income (except for one's own) in 1000 Korean Won in 2000 (t=1)
inc0     : Family income (except for one's own) in 1000 Korean Won in 1999 (t=0)
linc1    : Log of family income+1 in 2000 (t=1), log(inc1+1)
linc0    : Log of family income+1 in 1999 (t=0), log(inc0+1)


*********! Code
The code file called "lpmexotrt-16apr2023.do" (for Stata) can replicate Table 1 (Summary Statistics) and Table 2 (Estimation Results). It includes a program called "lpmexotrt" to present the results of Table 2. Syntax, output, and example of the program are provided below.

Syntax : lpmexotrt Y D X
Output : R-squared for D, R-squared for Y|D=0, LPM, PSR with q=2, PSR with q=3
Example:
. lpmexotrt work1 work0 age married0 edu0 kids0 linc0

    R2 for D: .54598266
R2 for Y|D=0: .0749402
LPM     (tv): .61643837 ( 29.315654 )
PSR(2)  (tv): .62659586 ( 29.373258 )
PSR(3)  (tv): .61619899 ( 28.740882 )


*********! References
1. Lee, M.J. and Y.H. Tae, 2005, Analysis of labour participation behaviour of Korean women with dynamic probit and conditional logit, Oxford Bulletin of Economics and Statistics 67, 71--91. (DOI: https://doi.org/10.1111/j.1468-0084.2005.00110.x)
2. Korean Labor and Income Panel Study: https://www.kli.re.kr/klips_eng/index.do
