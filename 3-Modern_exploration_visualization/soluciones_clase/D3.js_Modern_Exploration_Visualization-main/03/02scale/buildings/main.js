// defino constantes:
const width = 800
const height = 500
const margin = {
    top: 10,
    bottom: 40,
    left: 40, 
    right: 10
}

// defino svg y grupos:
const svg = d3.select("#chart").append("svg").attr("width", width).attr("height", height)
const elementGroup = svg.append("g").attr("id", "elementGroup").attr("transform", `translate(${margin.left}, ${margin.top})`)
const axisGroup = svg.append("g").attr("id", "axisGroup")
const xAxisGroup = axisGroup.append("g").attr("id", "xAxisGroup").attr("transform", `translate(${margin.left}, ${height - margin.bottom})`)
const yAxisGroup = axisGroup.append("g").attr("id", "yAxisGroup").attr("transform", `translate(${margin.left}, ${margin.top})`)

// definir escala:
const x = d3.scaleBand().range([0, width - margin.left - margin.right]).padding(0.1)
const y = d3.scaleLinear().range([height - margin.top - margin.bottom, 0])

// definir ejes:
const xAxis = d3.axisBottom().scale(x)
const yAxis = d3.axisLeft().scale(y)

d3.json("buildings.json").then(data => {
    console.log(data)

    // transformar datos (no hace falta en este dataset)
    // dominio:
    x.domain(data.map(d => d.name))
    // y.domain(d3.extent(data.map(d => d.height)))
    y.domain([0, d3.max(data.map(d=>d.height))])

    // dibujo los ejes: 
    xAxisGroup.call(xAxis)
    yAxisGroup.call(yAxis)

    // data binding:
    elementGroup.selectAll("rect").data(data)
        .join("rect")
            .attr("x", d => x(d.name))
            .attr("y", d => y(d.height))
            .attr("height", d => height - margin.bottom - margin.top - y(d.height) )
            .attr("width", x.bandwidth())
})