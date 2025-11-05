# tests/unit/test_jwt.py
from jose import jwt
from auth.service import create_access_token, decode_token, SECRET_KEY, ALGORITHM

def test_create_and_decode_access_token():
    claims_in = {"sub": "42", "email": "user@example.com"}
    token = create_access_token(claims_in, expires_minutes=5)

    # decode propio
    claims_out = decode_token(token)
    assert claims_out["sub"] == "42"
    assert claims_out["email"] == "user@example.com"
    assert "exp" in claims_out

    # verificación de firma con jose directamente
    jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
