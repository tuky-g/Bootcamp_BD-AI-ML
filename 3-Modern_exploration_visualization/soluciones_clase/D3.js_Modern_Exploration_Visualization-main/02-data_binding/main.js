const width = 800
const height = 500
const margin = 40

const svg = d3.select("#chart").append("svg").attr("width", width).attr("height", height)
let elementGroup = svg.append("g").attr("id", "elementGroup")


d3.csv("data.csv").then(data => {
    elementGroup.selectAll("rect").data(data)
        .join("rect")
            .attr("x", 0)
            .attr("width", d => d.titles * 10)
            .attr("y", (d, i) => i * 12)
            .attr("height", 10)   

// let elements = elementGroup.selectAll("rect").data(data)
    // elements.enter()
    //     .append("rect")
    //     .attr("x", 0)
    //     .attr("width", d => d.titles * 10)
    //     .attr("y", (d, i) => i * 12)
    //     .attr("height", 10)   
})

