
library(tidyverse)

ref_data <- read_csv("cdcref_d.csv")

# STEPS ------------------------------------------------------------------------


# 1. create categorical variables

  # a) agecat

    # if agemos >= 0 and agemos less than 0.5 then agecat = 0
    # else agecat = as.integer(agemos + 0.5) - 0.5

  # b) htcat

  # length and stand_ht are used later in deciding to use
  # wt-for-stature or wt-for-len reference
  # if agemos <24  then length=height
  # if agemos >= 24 then stand_ht = height


    # for patients with length:

    # if length > 45 then htcat = as.integer(length + 0.5) -0.5
    # else if length > 45 and length < 4.5 then htcat = 45

    # for patients with height:

    # if stand_ht > 77.5 then htcat = as.integer(stand_ht + 0.5) -0.5
    # else if stand_ht >= 77 and stand_ht < 77.5 then htcat = 77


# 2. calculate bmi

  # if bmi < 0 & ( weight>0 & height >0 & agemos >=24) then bmi=weight/(height/100)**2

# 3. merge data by sex then agecat variable

  # after merge, calcuate ageint and dage:

  # ageint = _agemos2-_agemos1
  # dage = agemos- _agemos1;

  # if agemos < 24 then _mbmi=.

# 4. begin LMS calculations

  # l0 (the new variables)
_llg  _mlg  _slg  _lht  _mht  _sht  _lwt  _mwt  _swt _lhc  _mhc  _shc
_lbmi  _mbmi  _sbmi

  # l1 variables
c("llg1", "mlg1", "slg1", "lht1", "mht1", "sht1", "lwt1", "mwt1",
  "swt1", "lhc1", "mhc1", "shc1", "lbmi1", "mbmi1", "sbmi1")

  # l2 variables
c("llg2", "mlg2", "slg2", "lht2", "mht2", "sht2", "lwt2", "mwt2",
  "swt2", "lhc2", "mhc2", "shc2", "lbmi2", "mbmi2", "sbmi2")

  # function to calculate new variables
l0 = l1 + (dage * (l2 - l1)) / ageint


# 5. zscore function

# zscore function
# Z = [((value / M)**L) – 1] / (S * L)

%macro _zscore(var,l, m, s, z, p, f);
if &var >0 then do;
if abs(&L) ge 0.01 then &z=((&var / &M)**&L-1)/(&L * &S);
else if .z < abs(&L) < 0.01 then &z=log(&var / &M)/ &S;
&p=probnorm(&z)*100;

sdl=((&M - &M*(1 - 2 * &L * &S)**(1 / &L)) / 2);
sdh=((&M * (1 + 2 * &L * &S)**(1 / &L) - &M) / 2);
if &var lt &M then &f= (&var - &M) / sdl; else &f= (&var - &M) / sdh;
end;
%mend _zscore;




lms_fun <- function(l1, l2)  {
  l1 + (dage * (l2 - l1)) / ageint

}



cdc_growth <- function(data)  {

  df <- data %>%
    mutate(agecat = if_else(agemos >= 0 & agemos < 0.5,
                            0,
                            as.integer(agemos + 0.5) - 0.5),
           bmi = weight/((height/100)**2)) %>%
    left_join(ref_data, by = c("sex", "agecat")) %>%
    mutate(ageint = agemos2 - agemos1,
           dage = agemos - agemos1,
           llg = )



}


