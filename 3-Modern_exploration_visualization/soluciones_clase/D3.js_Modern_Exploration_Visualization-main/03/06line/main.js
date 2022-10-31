const width = 800
const height = 500
const margin = {
    top: 10, 
    bottom: 40,
    left: 40,
    right: 10
}

const svg = d3.select("#chart").append("svg").attr("width", width).attr("height", height)
const elementGroup = svg.append("g").attr("id", "elementGroup").attr("transform", `translate(${margin.left}, ${margin.top})`)
const axisGroup = svg.append("g").attr("id", "axisGroup")
const xAxisGroup = axisGroup.append("g").attr("transform", `translate(${margin.left}, ${height - margin.bottom})`)
const yAxisGroup = axisGroup.append("g").attr("transform", `translate(${margin.left}, ${margin.top})`)

const x = d3.scaleTime().range([0, width - margin.left - margin.right])
const y = d3.scaleLinear().range([height - margin.top - margin.bottom, 0])

const xAxis = d3.axisBottom().scale(x)
const yAxis = d3.axisLeft().scale(y)

d3.csv("data.csv").then(data => {
    console.log(data)
    data.map(d => {
        d.close = +d.close
        d.date = formatTime(d.date)
    })

    x.domain(d3.extent(data.map(d => d.date)))
    y.domain(d3.extent(data.map(d => d.close)))

    xAxisGroup.call(xAxis)
    yAxisGroup.call(yAxis)

    elementGroup.datum(data)
        .attr("id", "ibex")
        .append("path")
        .attr("d", d3.line()
            .x(d => x(d.date))
            .y(d => y(d.close)))
})

const formatTime = d3.timeParse("%Y-%m-%d")