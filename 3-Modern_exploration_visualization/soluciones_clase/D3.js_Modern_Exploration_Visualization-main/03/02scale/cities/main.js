const width = 800
const height = 250
const margin = 20 // esto es para tener 10 a cada lado

const svg = d3.select("div#chart").append("svg").attr("width", width).attr("height", height)
const elementGroup = svg.append("g").attr("transform", `translate(${margin / 2}, 0)`)
const axisGroup = svg.append("g").attr("transform", `translate(${margin / 2}, ${height - 30})`)

// scale & axis
const x = d3.scaleLinear().range([0, width - margin])
const xAxis = d3.axisBottom().scale(x)

d3.json("cities.json").then(data => {
    // console.log(data)
    x.domain(d3.extent(data.map(d => d.distance)))
    axisGroup.call(xAxis)

    let elements = elementGroup.selectAll("g").data(data)
    elements.enter()
        .append("g")
        .call(addCity)
     
    // elementGroup.selectAll("circle").data(data)
    //     .join("circle")
    //         .attr("class", d => d.city)
    //         .attr("cx", d => x(d.distance))
    //         .attr("cy", 100)
    //         .attr("r", 10)

    // elementGroup.selectAll("text").data(data)
    //     .join("text")
    //         .attr("class", "city")
    //         .text(d => d.city)
    //         .attr("x", d => x(d.distance))
    //         .attr("y", 20)
    
})


function addCity(group) {
    group.attr("class", d => d.city)
        .attr("transform", d => `translate(${x(d.distance)}, 100)`)

    group.append("circle")
        .attr("r", 10)

    group.append("text")
        .attr("class", "city")
        .text(d => d.city)
        .attr("x", -25)
        .attr("y", 4)
        .attr("transform", `rotate(-90)`)

}