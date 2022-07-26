
const width = 800
const height = 500
const margin = {
    top: 10,
    left: 40,
    right: 10,
    bottom: 40
}

const svg = d3.select("#chart").append("svg").attr("width",width).attr("height",height)
const elementGroup = svg.append("g").attr("id", "elementgroup").attr("transform",`translate(${margin.left},${margin.top})`)
const axisGroup = svg.append("g").attr("id","axisGroup")
const xAxisGroup = axisGroup.append("g").attr("id","xaxisgroup").attr("transform",`translate(${margin.left}, ${height - margin.bottom})`)
const yAxisGroup = axisGroup.append("g").attr("id","yaxisgroup").attr("transform",`translate(${margin.left}, ${margin.top})`)

//escalas

const x = d3.scaleLinear().range([0, width - margin.left - margin.right])
const y = d3.scaleLinear().range([height - margin.top - margin.bottom, 0])
const z = d3.scaleLinear().range([1,50])

// ejes

xAxis = d3.axisBottom().scale(x)
yAxis = d3.axisLeft().scale(y)


d3.csv("data.csv").then(data => {
    console.log(data)
    data2=data

    data.map( d => {
        d.GDPpc = +d.GDPpc
        d.lifeExpectancy = +d.lifeExpectancy
        d.population = +d.population    
    })

    x.domain(d3.extent(data.map(d=>d.lifeExpectancy)))
    y.domain(d3.extent(data.map(d=>d.GDPpc)))
    z.domain(d3.extent(data.map(d=>d.population)))

    xAxisGroup.call(xAxis)
    yAxisGroup.call(yAxis)

    //data binding

    elementGroup.selectAll("circle").data(data)
        .enter()
        .append("circle")
            .attr("class", d=> d.continent)
            .attr("cx", d=> x(d.lifeExpectancy))
            .attr("cy", d=> y(d.GDPpc))
            .attr("r", d=> z(d.population))

})