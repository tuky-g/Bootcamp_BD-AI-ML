const url = 'https://dummyjson.com/products';

d3.json(url).then(data => {
    console.log(data.products)
})
