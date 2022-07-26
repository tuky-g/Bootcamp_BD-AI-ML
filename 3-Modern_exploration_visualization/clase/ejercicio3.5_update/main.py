from aiohttp import web
import asyncio
import aiohttp_cors
import json
import sys
import random


# HANDLERS:
async def handle(request):
    text = {'status': 'ok'}
    print('received request for "{}".'.format(text))
    return web.Response(text=json.dumps(text), headers={"X-Custom-Server-Header": "Custom data"}, status=200)

async def random_call(request):
    print("Received request")
    response = [random.randint(0,20) for i in range(random.randint(1,10))]
    return web.Response(text=json.dumps(response), headers={"X-Custom-Server-Header": "Custom data"}, status=200)


app = web.Application()
cors = aiohttp_cors.setup(app)

app.router.add_route("GET", "/", handle)
app.router.add_route("GET", "/random", random_call)


cors = aiohttp_cors.setup(app, defaults={
    "*": aiohttp_cors.ResourceOptions(
        allow_credentials=True,
        expose_headers="*",
        allow_headers="*",
    )
})

for route in list(app.router.routes()):
    cors.add(route)


if __name__ == "__main__":
    web.run_app(app, port=8000)

