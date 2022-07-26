
const dateFormat = d3.timeParse("%d%m%Y")

let data2
d3.json("dates.json").then(data => {
    data2=data
    d3.values(data).map(d => {
        d3.values(d).map(item =>{
            item.date = dateFormat(item.date)
        })
    })
})


// d3.csv("data.csv").then(data=>{
//     data.map(d=>
//         d.titles= +d.titles //convierte en numero entero o float
//             )
// })

// d3.csv("data.csv").then(data=>{
//     data.map(d=>
//         d.country = d.country == "Brasil" ? "Russia"//operador ternario: if comprimido la condicion es d.country==Brasil, si se cumple cambiar por Rusia
//             )
// })

