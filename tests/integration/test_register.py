import pytest
import httpx
from httpx import ASGITransport
from asgi_lifespan import LifespanManager
from main import app

@pytest.mark.asyncio
async def test_register_and_duplicate_email():
    async with LifespanManager(app):
        transport = ASGITransport(app=app)
        async with httpx.AsyncClient(transport=transport, base_url="http://test") as client:
            payload = {"email": "user@example.com", "password": "SuperSecret123"}

            r1 = await client.post("/auth/register", json=payload)
            assert r1.status_code == 201

            r2 = await client.post("/auth/register", json=payload)
            assert r2.status_code == 409
