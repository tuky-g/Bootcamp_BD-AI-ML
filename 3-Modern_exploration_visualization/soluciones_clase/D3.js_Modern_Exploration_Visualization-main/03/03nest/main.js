d3.csv("data.csv").then(data => {
    console.log(data)
    data = d3.nest()
        .key(d => d.name)
        .entries(data)

    console.log(data)
})