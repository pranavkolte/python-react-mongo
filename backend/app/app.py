from fastapi import FastAPI
from fastapi.responses import Response
from fastapi import status
from routes.metrics import router as metrics_router
app = FastAPI()


@app.get("/", tags=["Health Check"])
def index():
    return Response(
        data={"message": f"Python backend is running"},
        status_code=status.HTTP_200_OK
    )


app.include_router(prefix="/api/v1/metrics", router=metrics_router, tags=["Blogs"])