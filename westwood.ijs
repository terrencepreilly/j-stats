#! /usr/bin/ijconsole
load 'linear_regression.ijs'

NB. ----------METADATA--------------------
all =: 'c3_p73_example' ; 'c3_p74_example'
description =: 'Examples taken from Applied Linear Models'

NB. ----------STATS-----------------------
xs =: 30 20 60 80 40 50 60 30 70 60
ys =: 73 50 128 170 87 108 135 69 148 132

n =: # xs
df =: n - 2
'b0 b1' =: xs coefficients ys
mse =: xs MSE ys
xbar =: E xs
ybar =: E ys
SSx =: +/ *: xs - xbar
SSy =: +/ *: ys - ybar

NB. ----------EXAMPLES--------------------

c3_p73_example =: 3 : 0
    NB. Calculating the CI for a production run of size 55 with
    NB. 90% prediction interval, unknown parameters for a single
    NB. observation

    NB. First we estimate the value with the regression line
    yhat_55 =. (b0, b1) F 55

    NB. Then we calculate the variance of the Y_55 value
    s2_yhat_55_new =. mse * (>: (% n) + (55 - xbar) % SSx)

    NB. We find the t score for a 90% interval
    t =. df students_t 0.95

    NB. And we calculate the confidence interval
    yhat_55 (-,+) t * %: s2_yhat_55_new
)

c3_p74_example =: 3 : 0
    NB. y: the number of observations

    NB. Calculating the CI for a production run of size 55 with
    NB. 90% prediction interval, unknown parameters, y observations

    NB. we calculate the y value at the given X
    yhat_55 =.  (b0, b1) F 55

    s2_ybar_55_new =. mse * ((%y) + (%n) + (55 - xbar) % SSx)

    NB. We find the t score for a 90% interval
    t =. df students_t 0.95

    NB. and we calculate the confidence interval
    yhat_55 (-,+) t * %: s2_ybar_55_new
)

w =: c3_p74_example 3
