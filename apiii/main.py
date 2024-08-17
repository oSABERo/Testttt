# Run
# uvicorn main:app --reload --port 8080


from fastapi import FastAPI


app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}




