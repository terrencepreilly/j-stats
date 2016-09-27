load 'stats/r/rdcmd'
require 'csv'
require 'plot'
require 'strings'

NB.===============FORMULAS============================

NB. Expected value
E =: +/ % #

NB. Sum of squares
SS =: +/ @: *: @: (] - E)

NB. Sample Variance
s2 =: SS % (<: @: #)


NB. Estimated β1
b1 =: 4 : 0
    (+/ y * x - E x) % (SS x)
)

NB. Estimated β0
b0 =: 4 : 0
    my_b1 =. x b1 y
    (E y) - my_b1 * E x
)

NB. Gives coefficients for the estimated
NB. coefficient regression equation
coefficients =: b0, b1

NB. Given coefficients for x, and x-value for y, returns
NB. response.
f =: +/ @: ([ * ((1&,) @: ]) )

NB. Gives the y hat values given actual xs and ys
yhat =: b0 + b1 * [

NB. Returns the residuals of the regression line
NB. formed by observed values y at x.
residuals =: ] - yhat

NB. Error sum of squares (or, residual sum of squares)
SSE =: SS @: residuals

NB. Error mean square (or, residual mean square)
MSE =: SSE % ((<: ^: 2) @: # @: ])

NB.===============GRAPHING============================

plot_dots =: 4 : 0
    pd 'type dot'
    pd 'pensize 3'
    pd 'color 10 130 10'
    pd x ; y
)

plot_line =: 4 : 0
    pd 'type line'
    pd 'pensize 2'
    pd 'color 230 10 10'
    pd x ; y
)

plot_least_squares =: 4 : 0
    pd 'reset'
    xs plot_dots ys
    xs plot_line (xs yhat ys)
    pd 'show'
)

NB.===============CSV=================================
header =: 3 : 0
    h =. {. y
    indices =: <"0 i. # h
    |: indices ,: h
)

NB. Get the data in the given column, convert to numbers
NB. x is the column, y is the data
get_column =: 4 : 0
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

students_t_string =: 4 : 0
    '' conew 'prdcmd'           NB. create a connection
    t =. Rcmdr 'qt(' , (": y), ', df=', (": x) , ')'
    t
)

inverse_students_t_string =: 4 : 0
    '' conew 'prdcmd'           NB. create a connection
    t =. Rcmdr 'pt(' , (": y), ', df=', (": x) , ')'
    t
)

parse_students_t_string =: 3 : 0
    f =. ". @: }: @: {. @: }. @: > @: (' '&splitstring)
    new_y =. (LF; '') stringreplace y NB. remove newlines
    f new_y
)

students_t =: 4 : 0
    NB. x : degrees of freedom
    NB. y : 1 - α
    parse_students_t_string x students_t_string y
)

inverse_students_t =: 4 : 0
    NB. x: degrees of freedom
    NB. y: t statistic
    parse_students_t_string x inverse_students_t_string y
)
