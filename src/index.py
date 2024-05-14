from fastapi import FastAPI, Request, Response
from strawberry.fastapi import GraphQLRouter

from src.schema import schema

app = FastAPI()
router = GraphQLRouter(schema)


app.include_router(router, prefix="/api")
