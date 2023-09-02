from app import view

def test_index():
    client = view.test_client()
    response = client.get('/')
    assert response.status_code == 200