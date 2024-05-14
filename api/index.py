from fastapi import FastAPI
from strawberry.asgi import GraphQL

from gql.schema import schema

app = FastAPI()


app.mount("/api", GraphQL(schema))
