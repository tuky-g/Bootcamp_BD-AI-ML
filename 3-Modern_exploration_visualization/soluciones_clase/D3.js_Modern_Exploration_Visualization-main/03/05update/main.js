const url = "http://0.0.0.0:8000/random"

const width = 800
const height = 500
const margin = {
    top:10, 
    bottom: 40,
    left:40, 
    right: 10
}

const svg = d3.select("#chart").append("svg").attr("width", width).attr("height", height)
const elementGroup = svg.append("g").attr("transform", `translate(${margin.left}, ${margin.top})`)
const axisGroup = svg.append("g")
const xAxisGroup = axisGroup.append("g").attr("transform", `translate(${margin.left}, ${height - margin.bottom})`)
const yAxisGroup = axisGroup.append("g").attr("transform", `translate(${margin.left}, ${margin.top})`)

const y = d3.scaleBand().range([height - margin.top - margin.bottom, 0]).padding(0.1)
const x = d3.scaleLinear().range([0, width - margin.left - margin.right])

const xAxis = d3.axisBottom().scale(x)
const yAxis = d3.axisLeft().scale(y)

d3.interval(getData, 2500)

function getData() {
    d3.json(url).then(data => {

    x.domain([0, d3.max(data)])
    y.domain([...Array(data.length).keys()].map(d => `${d}`))

    xAxisGroup
        .transition()
        .duration(300)
        .call(xAxis)
    yAxisGroup
        .transition()
        .duration(300)
        .call(yAxis)

    let elements = elementGroup.selectAll("rect").data(data)
    
    elements.enter()
        .append("rect")
        .attr("class", "enter")
        .attr("x", 0)
        .attr("y", (d, i) => y(i))
        .attr("height", y.bandwidth())
        .transition()
        .duration(300)
        .attr("width", d => x(d))

    elements
        .attr("class", "update")
        .attr("x", 0)
        .attr("y", (d, i) => y(i))
        .attr("height", y.bandwidth())
        .transition()
        .duration(300)
        .attr("width", d => x(d))

    elements.exit()
        .attr("class", "exit")
        .transition()
        .duration(100)
        .attr("width", 0)
        .remove()
})}