// CHART START
const width = 800
const height = 500
const margin = {
    top: 10,
    bottom: 40,
    left: 100,
    right: 10
}

// defino svg y grupos:

const svg = d3.select("#chart").append("svg").attr("width",width).attr("height", height)
const elementGroup = svg.append("g").attr("id","elementgroup").attr("transform",`translate(${margin.left}, ${margin.top})`)
const axisGroup = svg.append("g").attr("id","axisGroup")
const xAxisGroup = axisGroup.append("g").attr("id","xAxis").attr("transform",`translate(${margin.left}, ${height - margin.bottom})`)
const yAxisGroup = axisGroup.append("g").attr("id","yAxis").attr("transform",`translate(${margin.left}, ${margin.top})`)

// definir escalas x representa year e y representa paises

x = d3.scaleLinear().range([0, width - margin.left - margin.right])
y = d3.scaleBand().range([height - margin.top - margin.bottom, 0])

// definir ejes

const xAxis = d3.axisBottom().scale(x)
const yAxis = d3.axisLeft().scale(y)

// data binding

d3.csv("data.csv").then(data =>{
    console.log(data)
    data2=data
    //cambiar formato de datos
    data.map( d => {
        d.year = formatTime(d.year)
    })

    // transformacion de los datos
    wins = filteryear(data, '2020')

    //obtengo el valor
    const max_wins = d3.max(wins.map(w=>w.values.length))

    // obtengo los años de los mundiales
    const years = data.map(d => d.year)

    //dominio
    x.domain(d3.extent(wins.map(w=>w.values.length)))
    y.domain(data.map(d => d.winner))

    // dibujo los ejes
    xAxisGroup.call(xAxis)
    yAxisGroup.call(yAxis)

    

    
    elementGroup.selectAll("rect").data(wins)
        .join("rect")
            .attr("class", w => w.values.length < max_wins ? 'no_max' : 'max') 
            .attr("x", 0)
            .attr("y", (w,i) => y(w.key))
            .attr("height", y.bandwidth())
            .attr("width", w => x(w.values.length))

})



// format time
const formatTime= d3.timeParse("%Y")

// funcion para filtrar por año

function filteryear(data, year){
    data_filtered = data.filter(d=> d.year<=formatTime(year))
    const wins = d3.nest().key(d => d.winner).entries(data_filtered)
    return wins    
}


// CHART END


// slider:
function slider() {    
    var sliderTime = d3
        .sliderBottom()
        .min(d3.min(years))  // rango años
        .max(d3.max(years))
        .step(4)  // cada cuánto aumenta el slider
        .width(580)  // ancho de nuestro slider
        .ticks(years.length)  
        .default(years[years.length -1])  // punto inicio de la marca
        .on('onchange', val => { 
            console.log(val)
            // conectar con la gráfica aquí
            
        });

        var gTime = d3
        .select('div#slider-time')  // div donde lo insertamos
        .append('svg')
        .attr('width', width * 0.8)
        .attr('height', 100)
        .append('g')
        .attr('transform', 'translate(30,30)');

        gTime.call(sliderTime);

        d3.select('p#value-time').text(sliderTime.value());
}