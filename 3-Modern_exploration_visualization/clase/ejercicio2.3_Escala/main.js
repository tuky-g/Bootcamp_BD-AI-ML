const width = 800
const height = 500
const margin = {
    top: 10,
    bottom: 40,
    left: 10,
    right: 10
}

const svg = d3.select("#chart").append("svg").attr("width",width).attr("height",height)
const elementgroup = svg.append("g")

// aqui hago las escalas

let x = d3.scaleLinear().range([0,width])
let y = d3.scaleBand().range([height,0]).padding(0.1)

d3.csv("data.csv").then(data => {
    data2=data
    data.map(d=> {
        d.titles = +d.titles

    })
    console.log(data)
    x.domain([0 , d3.max(data2.map(datum=>datum.titles))])
    y.domain(data.map(d=>d.country))

    elementgroup.selectAll("rect").data(data)
    .join("rect")
    .attr("class", d=> d.country)
    .attr("x", 0)
    .attr("y", (d,i) => y(d.country))
    .attr("width", d => x(d.titles))
    .attr("height", y.bandwidth())
    
})