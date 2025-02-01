# backend/main.py
from fastapi import FastAPI, Request
from prometheus_client import make_asgi_app, Counter, generate_latest
from fastapi.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
import os
from bson.json_util import dumps, loads
from bson import ObjectId
from fastapi.responses import JSONResponse

app = FastAPI()
mongodb_url = os.getenv("MONGODB_URL", "mongodb://localhost:27017")
client = AsyncIOMotorClient(mongodb_url)
db = client.sample_db

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Allow requests from this origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

metrics_app = make_asgi_app()
app.mount("/metrics", metrics_app)


REQUEST_COUNT = Counter("http_requests_total", "Total HTTP Requests")

@app.middleware("http")
async def count_requests(request: Request, call_next):
    REQUEST_COUNT.inc()
    response = await call_next(request)
    return response

@app.get("/health")
def health():
    return {"status": "healthy"}

@app.get("/metrics-json")
async def metrics_json():
    metrics = generate_latest()
    metrics_dict = {}
    for line in metrics.decode("utf-8").splitlines():
        if line.startswith("#"):
            continue
        key, value = line.split(" ")
        metrics_dict[key] = value
    return metrics_dict

def serialize_doc(doc):
    """Convert MongoDB document to JSON serializable format"""
    if doc:
        doc['_id'] = str(doc['_id'])  # Convert ObjectId to string
    return doc

@app.get("/users")
async def get_users():
    cursor = db.users.find()
    users = await cursor.to_list(length=100)
    # Serialize MongoDB documents
    serialized_users = [serialize_doc(user) for user in users]
    return serialized_users


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
