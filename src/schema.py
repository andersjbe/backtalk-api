from typing import TypedDict

import edgedb
import strawberry

client = edgedb.create_async_client()


@strawberry.type
class User:
    public_id: str | None
    username: str | None
    github_id: int | None


@strawberry.type
class HelloResponse:
    message: str


@strawberry.type
class Query:
    @strawberry.field
    async def hello_world(self, name: str | None = "World") -> HelloResponse:
        return HelloResponse(message=f"Hello {name}!")


schema = strawberry.Schema(query=Query)
