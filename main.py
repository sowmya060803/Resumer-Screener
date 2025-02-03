from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import uvicorn
from resume_processor import process_resume

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Update this with your frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ScreeningResult(BaseModel):
    entities: dict
    classification: str
    score: float

@app.post("/api/screen-resume", response_model=ScreeningResult)
async def screen_resume(file: UploadFile = File(...)):
    contents = await file.read()
    result = process_resume(contents)
    return result

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)

