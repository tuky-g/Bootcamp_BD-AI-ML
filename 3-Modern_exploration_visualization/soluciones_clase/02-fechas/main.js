let data2

const dateFormat = d3.timeParse("%d%m%Y")

d3.json("fechas.json").then(data =>{
    data2 = data
    d3.values(data2).map(d => {
        d3.values(d).map(item => {
            item.date = dateFormat(item.date)
        })
    })
})