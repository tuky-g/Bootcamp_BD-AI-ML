d3.json("data.json").then(data => {
    console.log(data)
})

d3.csv("data.csv").then(data => {
    console.log(data)
})

d3.tsv("data.tsv").then(data => {
    console.log(data)
})

d3.xml("data.xml").then(data => {
    console.log(data)
})

d3.json("fechas.json").then(fechas =>{
    console.log(fechas)
})