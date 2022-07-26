const height = 500
const width = 800
const margin = 50
const svg = d3.select("#chart").append("svg").attr("width", width).attr("height",height)

const colors = ["#440154", "#482475", "#414487", "#355f8d", "#2a788e", "#21908d", "#22a884", "#42be71", "#7ad151", "#bddf26", "#bddf26"]

// svg.append("circle")

function addcircle(){
    svg.append("circle")
    .attr("cx", Math.random() * width - ( 2 * margin))
    .attr("cy", Math.random() * height - (2 * margin))
    .attr("r", (10+(Math.random()*30)))
    .attr("fill",colors[Math.floor(Math.random()*colors.length)])
    .on("click", function(){
        this.remove()
    })
}


d3.select("#circlebtn").on("click",addcircle)
