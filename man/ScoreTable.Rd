% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ScoreTable.R
\name{ScoreTable}
\alias{ScoreTable}
\title{Score Table generator}
\usage{
ScoreTable(confounders, scores, aliases = NULL, custom_cases)
}
\arguments{
\item{confounders}{For simple generation.
A character vector that declares derived components in the score table (1) or
a named list (2) whose names define the derived components in the score table and
whose values define their respective possible levels}

\item{scores}{For simple generation.
A numeric vector that declares score for derived components using method (1) or
a named list whose names follow the derived component names defined in method (2) and
whose values define their respective possible scores}

\item{aliases}{A named list that define a pretty representatives for defined confounders
following the structure of list(confounder = aliases).
Unmentioned confounders will be left intact.}

\item{custom_cases}{A named list that define a sophisticated way to define confounders and scoring algorithm,
following the structure of list(name = list(formulas))
Each name is the name for derived confounders.
Each formula in each sub-list folllows the form of condition ~ score in a "specific to general" order.
This is based on \link[dplyr]{case_when}.}
}
\value{
An object of class ScoreTable.
When called with no data, this will print out the structure of the ScoreTable.
When called with data passed, this will return a data frame of class score_tbl.
}
\description{
A function to formally create an object of class Score Table.
}
\examples{
charlson =  ScoreTable(
confounders = c('myocardial_infarct', 'congestive_heart_failure', 'peripheral_vascular_disease',
               'cerebrovascular_disease', 'dementia', 'chronic_pulmonary_disease',
               'connective_tissue_disease', 'ulcer_disease', 'mild_liver_disease', 'diabetes',
               'hemiplegia', 'moderate_or_severe_renal_disease', 'diabetes_with_end_organ_damage', 'any_tumor',
               'moderate_or_severe_liver_disease', 'metastatic_solid_tumor', 'AIDS'),
scores = c(rep(1, 10), rep(2, 4), 3, 6, 6),
aliases = c('Myocardial infarction', 'Congestive heart failure', 'Peripheral vascular disease',
           'Cerebrovascular disease', 'Dementia', 'Chronic pulmonary disease',
           'Connective tissue disease', 'Ulcer disease', 'Mild liver disease', 'Diabetes',
           'Hemiplegia', 'Moderate or severe renal disease', 'Diabetes with end organ damage', 'any tumor',
           'Moderate or severe liver disease', 'Metastatic solid tumor', 'AIDS')
)

apache.ii <- ScoreTable(
aliases = list(temp ='Temperature', map ='Maximum Aterial Pressure',
              hr = 'Heart Rate', rr = 'Respiratory Rate', aapo2 = 'AaPO2',
              pao2 = 'PaO2', ph = 'PH', hco3 = 'HCO3-', sodium = 'Sodium', potassium = 'Potassium',
              creatinine = 'Creatinine', hct = 'HCT', wbc = 'White-blood cell',
              gcs = 'Glasgow Comma Score', age = 'Age', chronic = 'Chronic'),
custom_cases =
 list(
   temp = list(
     temp >= 41 | temp < 30 ~ 4,
     temp >= 39 | temp < 32 ~ 3,
     temp < 34 ~ 2,
     temp >= 38.5 | temp < 36 ~ 1,
     !is.na(temp) ~ 0
   ),
   map = list(
     map >= 160 | map < 50 ~ 4,
     map >= 130 ~ 3,
     map >= 110 | map < 70 ~ 2,
     !is.na(map) ~ 0
   ),
   hr = list(
     hr >= 180 | hr < 40 ~ 4,
     hr >= 140 | hr < 55 ~ 3,
     hr >= 110 | hr < 70 ~ 2,
     !is.na(hr) ~ 0
   ),
   rr = list(
     rr >= 50 | rr < 6 ~ 4,
     rr >= 35 ~ 3,
     rr < 10 ~ 2,
     rr >= 25 | rr < 12 ~ 1,
     !is.na(rr) ~ 0
   ),
   aapo2 = list(
     fio2 < .5 | is.na(fio2) ~ 0,
     aapo2 >= 500 ~ 5,
     aapo2 >= 350 ~ 3,
     aapo2 >= 200 ~ 2,
     !is.na(aapo2) ~ 0
   ),
   pao2 = list(
     fio2 >= .5 ~ 0,
     pao2 < 55 ~ 4,
     pao2 <= 60 ~ 3,
     pao2 <= 70 ~ 1,
     !is.na(pao2) ~ 0
   ),
   ph = list(
     ph >= 7.7 | ph < 7.15 ~ 4,
     ph >= 7.6 | ph < 7.25 ~ 3,
     ph < 7.33 ~ 2,
   ph >= 7.5 ~ 1,
   TRUE ~ 0
  ),
 hco3 = list(
   !is.na(ph) ~ 0,
   hco3 >= 52 | hco3 < 15 ~ 4,
   hco3 >= 41 | hco3 < 18 ~ 3,
   hco3 < 22 ~ 2,
   hco3 >= 32 ~ 1,
   !is.na(hco3) ~ 0
 ),
 sodium = list(
   sodium >= 180 | sodium <= 110 ~ 4,
   sodium >= 160 | sodium < 120 ~ 3,
     sodium >= 155 | sodium < 130 ~ 2,
     sodium >= 150 ~ 1,
   !is.na(sodium) ~ 0
 ),
 potassium = list(
   potassium >= 7 | potassium < 2.5 ~ 4,
   potassium >= 6 ~ 3,
   potassium < 3 ~ 2,
   potassium >= 5.5 | potassium < 3.5 ~ 1,
   !is.na(potassium) ~ 0
 ),
 creatinine = list(
   creatinine >= 3.5 ~ 4,
   creatinine >= 2 ~ 3,
   creatinine >= 1.5 | creatinine < .6 ~ 2,
   !is.na(creatinine) ~ 0
 ),
 hct = list(
   hct >= 60 | hct < 20 ~ 4,
   hct >= 50 | hct < 30 ~ 2,
   hct >= 46 ~ 1,
   !is.na(hct) ~ 0
 ),
 wbc = list(
   wbc >= 40 | wbc < 1 ~ 4,
   wbc >= 20 | wbc < 3 ~ 2,
   wbc >= 15 ~ 1,
   !is.na(wbc) ~ 0
 ),
  gcs = list(
   !is.na(gcs) ~ 15 - gcs
 ),
 age = list(
   age >= 75 ~ 6,
   age >= 65 ~ 5,
   age >= 55 ~ 3,
   age >= 45 ~ 2,
   TRUE ~ 0
 ),
 chronic = list(
   rowSums(liver, heart, lung, kidney) == 0 ~ 0,
   as.logical(emergency) ~ 5,
   as.logical(elective) ~ 2,
   sum(elective, emergency, na.rm = TRUE) == 0 ~ 5
 )
)
)
}
\seealso{
\link[dplyr]{case_when}, \link{as.data.frame.ScoreTable}, \link{apache.ii}, \link{summary.score_tbl}
}
