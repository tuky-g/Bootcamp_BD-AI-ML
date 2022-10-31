let val = 1
let array1 = [0, 1, 2, 3, 4, 5, 6]
let object1 = {
    name: "Pedro",
    age: 21
}


d3.select(".parrafete").attr("style", "color:blue")

// funcion1()


function funcion1() {
    console.log("Hola mundo")
}


// if else
if (val == 0) {
    funcion1()
} else {
    console.log("lo otro y tal...")
}

// mapas y arrow functions:
array1.map(d => d + 1)

console.log(`formateado: ${val}`)
