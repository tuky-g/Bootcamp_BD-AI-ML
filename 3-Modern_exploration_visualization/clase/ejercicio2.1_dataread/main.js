d3.json("data.json").then(data => {
    console.log(data)
}) //devuelve una promesa: hace un procesado y lo devuelve para que lo trabajes 
// se puede poner un link a una url que devuelva un json

d3.csv("data.csv").then(data => {
    console.log(data)
})

d3.tsv("data.tsv").then(data => {
    console.log(data)
})

d3.xml("data.xml").then(data => {
    console.log(data)
})

d3.json("dates.json").then(data => {
    console.log(data)
})