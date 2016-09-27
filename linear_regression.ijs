load 'stats/r/rdcmd'
require 'csv'
require 'plot'
require 'strings'

NB.===============FORMULAS============================

expected_value =: +/ % #
E =: 3 : 0
    NB. Returns the expected value (as mean)
    NB. y: a list of numbers
    expected_value y
)

sum_of_squares =: +/ @: *: @: (] - E)
SS =: 3 : 0
    NB. Sum of squares
    NB. y: a list of numbers
    sum_of_squares y
)

sample_variance =: SS % (<: @: #)
S2 =: 3 : 0
    NB. Sample variance
    NB. y: a list of numbers (a sample)
    sample_variance y
)


B1 =: 4 : 0
    NB. Estimated β1
    NB. x: the independent data set (X)
    NB. y: the dependent data set (Y)
    (+/ y * x - E x) % (SS x)
)

B0 =: 4 : 0
    NB. Estimated β0
    NB. x: the independent data set, X
    NB. y: the dependent data set (Y)
    my_b1 =. x B1 y
    (E y) - my_b1 * E x
)

coefficients =: B0, B1
C =: 4 : 0
    NB. Gives coefficients for the estimated regression equation
    NB. x: the independent data set (X)
    NB. y: the dependent data set (Y)
    x coefficients y
)

NB. Given coefficients for x, and x-value for y, returns
NB. response.
yhat_coefficients =: +/ @: ([ * ((1&,) @: ]) )
F =: 4 : 0
    NB. x: The coefficients for the regression equation
    NB.    in the form (β0 β1)
    NB. y: a number (a particular value of X)
    x yhat_coefficients y
)

yhat =: B0 + B1 * [
YHAT =: 4 : 0
    NB. Gives the y hat values given actual xs and ys
    NB. x: The independent data set (X)
    NB. y: The dependent data set (Y)
    x yhat y
)

residuals =: ] - yhat
RES =: 4 : 0
    NB. Returns the residuals of the regression line
    NB.    formed by observed values y at x.
    NB. x: The independent data set (X)
    NB. y: The dependent data set (Y)
    x residuals y
)

sum_of_squares_error =: SS @: residuals
SSE =: 4 : 0
    NB. Gives the unexplained variation (or, residual sum of squares)
    NB. x: The independent data set (X)
    NB. y: The dependent data set (Y)
    x sum_of_squares_error y
)

mean_square_error =: SSE % ((<: ^: 2) @: # @: ])
MSE =: 4 : 0
    NB. Gives the mean square error (or, residual mean square)
    NB. x: The independent data set (X)
    NB. y: The dependent data set (Y)
    x mean_square_error y
)

NB.===============GRAPHING============================

plot_dots =: 4 : 0
    NB. Plots the given data points as dots. (Does not reset or show
    NB.    the chart.)
    NB. x: The independent data set (X)
    NB. y: The dependent data set (Y)
    pd 'type dot'
    pd 'pensize 3'
    pd 'color 10 130 10'
    pd x ; y
)

plot_line =: 4 : 0
    NB. Plot the least squares line calculated from the given points.
    NB.    (Does not reset or show the chart.)
    NB. x: The independent data set (X)
    NB. y: The dependent data set (Y)
    pd 'type line'
    pd 'pensize 2'
    pd 'color 230 10 10'
    pd x ; y
)

plot_least_squares =: 4 : 0
    NB. Plot the least squares line with dotplot of data points.
    NB. x: The independent data set (X)
    NB. y: The dependent data set (Y)
    pd 'reset'
    xs plot_dots ys
    xs plot_line (xs YHAT ys)
    pd 'show'
)

NB.===============CSV=================================
headers =: 3 : 0
    NB. Give the headers of the given CSV file. (Note: assumes that
    NB.    the first row contains headers.)
    NB. y: A the raw readout from a CSV file.
    h =. {. y
    indices =: <"0 i. # h
    |: indices ,: h
)

get_column =: 4 : 0
    NB. Get the data in the given column, convert to numbers
    NB.    x is the column, y is the data
    NB. x: The index of the column of the data to get.
    NB. y: The raw readout from a CSV file.

    NB. Assumes first value is the header
    l =. }. x { |: y
    NB. Get the index of the last value
    last =. {. I. (< '') = l
    if. last = 0 do.
        last =. # l
    end.
    , ". > (i. last) { l
)

NB. ==============STUDENT'S T=========================

inverse_students_t_string =: 4 : 0
    NB. Gets the string from R for qt(y, df=x)
    NB. x: The degrees of freedom.
    NB. y: The given probability.
    '' conew 'prdcmd'           NB. create a connection
    t =. Rcmdr 'qt(' , (": y), ', df=', (": x) , ')'
    t
)

students_t_string =: 4 : 0
    NB. Gets the inverse student's t from R for pt(y, df=x)
    NB. x: The degrees of freedom.
    NB. y: The given student's t score.
    '' conew 'prdcmd'           NB. create a connection
    t =. Rcmdr 'pt(' , (": y), ', df=', (": x) , ')'
    t
)

parse_students_t_string =: 3 : 0
    NB. Parses a string from R for the functions qt or pt.
    NB. y: The string readout from R.
    f =. ". @: }: @: {. @: }. @: > @: (' '&splitstring)
    new_y =. (LF; '') stringreplace y NB. remove newlines
    f new_y
)

students_t =: 4 : 0
    NB. Calculates the probability of a given t-statistic.
    NB. x: degrees of freedom
    NB. y: A given t-statistic.
    parse_students_t_string x students_t_string y
)

inverse_students_t =: 4 : 0
    NB. Calculates the t-value necessary for the given probability.
    NB. x: degrees of freedom
    NB. y: The probability, generally 1 - α
    parse_students_t_string x inverse_students_t_string y
)
