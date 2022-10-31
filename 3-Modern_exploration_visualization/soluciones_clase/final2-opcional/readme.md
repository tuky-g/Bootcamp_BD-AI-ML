# Ejercicio final

Esta gráfica muestra el la edad de Leo DiCaprio en relación a la edad de su pareja a lo largo del tiempo. La edad de las chicas tenía que estar en una gráfica de barras, mientras que la de DiCaprio tenía que estar en una línea.
La solución implementada es una de muchas. La principal dificultad del ejercicio residía en combinar dos tipos de gráficas que utilizaban escalas distintas. Se puede resolver usando dos escalas distintas, pero las gráƒicas de líneas se pueden representar en la escala de las de barras sin mucho problema, además de que también se pueden pasar puntos y que los represente. Eso da lugar a *tres soluciones* para la gráfica de líneas. Lo que no era fácil era representar barras en líneas temporales o continuas, aunque la posibilidad existe usando herramientas más propias de un histograma, y que no considero conveniente para este caso. 

El ejercicio incluía algunas funciones para facilitar el camino y para dar pistas. 

    const  diCaprioBirthYear = 1974;
    const  age = function(year) { return  year - diCaprioBirthYear}
    const  today = new  Date().getFullYear()
    const  ageToday = age(today)

la función age permite calcular la edad de Leonardo pasando el año, por lo que nos iba a servir para la línea (no era imprescindible, pero debería ser intuitivo de que para algo de la línea era). 
