# tests/integration/test_login.py
import pytest
import httpx
from httpx import ASGITransport
from asgi_lifespan import LifespanManager
from main import app
from auth.service import decode_token

@pytest.mark.asyncio
async def test_login_success_returns_bearer_token():
    async with LifespanManager(app):
        transport = ASGITransport(app=app)
        async with httpx.AsyncClient(transport=transport, base_url="http://test") as client:
            payload = {"email": "login_ok@example.com", "password": "SuperSecret123"}
            # register
            r1 = await client.post("/auth/register", json=payload)
            assert r1.status_code == 201

            # login
            r2 = await client.post("/auth/login", json=payload)
            assert r2.status_code == 200
            data = r2.json()
            assert "access_token" in data
            assert data["token_type"] == "bearer"

            claims = decode_token(data["access_token"])
            assert claims["email"] == payload["email"]
            assert "sub" in claims
            assert "exp" in claims

@pytest.mark.asyncio
async def test_login_wrong_password_401():
    async with LifespanManager(app):
        transport = ASGITransport(app=app)
        async with httpx.AsyncClient(transport=transport, base_url="http://test") as client:
            # register
            payload = {"email": "login_fail@example.com", "password": "SuperSecret123"}
            r1 = await client.post("/auth/register", json=payload)
            assert r1.status_code == 201

            # wrong password
            r2 = await client.post("/auth/login", json={"email": payload["email"], "password": "wrongpass"})
            assert r2.status_code == 401
            assert r2.json()["detail"] == "Invalid email or password"

@pytest.mark.asyncio
async def test_login_unregistered_email_401():
    async with LifespanManager(app):
        transport = ASGITransport(app=app)
        async with httpx.AsyncClient(transport=transport, base_url="http://test") as client:
            r = await client.post("/auth/login", json={"email": "noexists@example.com", "password": "whatever123"})
            assert r.status_code == 401
