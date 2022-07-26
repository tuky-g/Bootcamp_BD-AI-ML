
const width = 800
const height = 500
const margin = 40

const svg = d3.select("#chart").append("svg").attr("width",width).attr("height",height)
let elementGroup = svg.append("g")

d3.csv("data.csv").then(data => {
    let elements = elementGroup.selectAll("circle").data(data) //seleccion fantasma
    // console.log(data)
    //crear datos nuevos
    elements.enter()
        .append("rect")
        .attr("x",0)
        .attr("y",(d,i) => i+12)
        .attr("width", d=> d.titles*10)
        .attr("height", 10)

        
})
