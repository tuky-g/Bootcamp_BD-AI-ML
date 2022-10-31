const width = 800
const height = 500
const margin = {
    top: 10,
    bottom: 40,
    left: 40, 
    right: 10
}

const svg = d3.select("#chart").append("svg").attr("width", width).attr("height", height)
const elementGroup = svg.append("g")

// aqui hago las escalas:
let x = d3.scaleLinear().range([0, width])
let y = d3.scaleBand().range([height, 0]).padding(0.1)

let data2

d3.csv("data.csv").then(data => {
    data.map(d => {
        d.titles = +d.titles
    })
    data2 = data
    
    x.domain([0, d3.max(data2.map(datum => datum.titles))])
    y.domain(data2.map(d => d.country))

    elementGroup.selectAll("rect").data(data)
        .join("rect")
            .attr("class", d => d.country)
            .attr("x", 0)
            .attr("y", (d, i, a) => y(d.country))
            .attr("width", d => x(d.titles))
            .attr("height", y.bandwidth())
})