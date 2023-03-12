# Rack middleware tutorial
## Lesson 1
Create a simple rack app with rspec-tests and github actions

## Lesson 2
Add to rack application middlewares:
1. that will log the request 
2. handle a unexpected exception
3. handle responses 404, 500
4. handle requset to public assets
Assets must be in the public folder "lib/public/assets"
Example request:
```
http://localhost:9292/public/xml_file.xml
```

## Lesson 3
Add to rack application cache-control(only for assets) and etag middleware

## Lesson 4
Create simple dsl for routing, methods get, post and mount to another rack app

## Run
1. Ensure docker and docker compose is alredy installed in a computer.
2. Run in termianl command
```
docker-compose up
```
3. Open in browser http://localhost:9292
