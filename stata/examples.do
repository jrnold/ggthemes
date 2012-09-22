sysuse auto
local schemelist s2color s2mono s2manual s2gmanual s1rcolor s1mono s1manual economist sj

foreach scheme of local schemelist {
    scatter mpg headroom turn weight, ///
        title("Plot title") legend(title("Legend title")) scheme(`scheme')
    graph export "graph_twoway_scatter_`scheme'.png"

    scatter mpg headroom turn weight, ///
        by(foreign, title("Plot title")) ///
        legend(title("Legend title")) scheme(`scheme')
    graph export "graph_twoway_scatter_by_`scheme'.png"
}
