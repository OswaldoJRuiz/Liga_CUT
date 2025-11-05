# tests/unit/test_service.py
import pytest
from auth.service import normalize_email, validate_password, hash_password, verify_password

def test_normalize_email():
    assert normalize_email("  TEST@MAIL.COM  ") == "test@mail.com"

def test_password_hash_and_verify():
    pwd = "SuperSecret123"
    h = hash_password(pwd)
    assert h != pwd
    assert verify_password(pwd, h)
    assert not verify_password("wrong", h)

def test_password_policy_rejects_short_or_numeric():
    with pytest.raises(ValueError):
        validate_password("1234567")  # < 8
    with pytest.raises(ValueError):
        validate_password("12345678")  # solo números
