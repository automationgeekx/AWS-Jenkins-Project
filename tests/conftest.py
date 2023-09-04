import pytest
from app.app_instance import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client
