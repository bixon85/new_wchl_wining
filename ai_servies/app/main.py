from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import uvicorn
import sys
import os
import time

# Add dao_analyzer to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Import your existing analyzer (you'll copy your dao_analyzer folder here)
try:
    from dao_analyzer.core import DAOProposalAnalyzer
except ImportError:
    # Fallback for development
    print("Warning: dao_analyzer not found. Using mock analyzer.")
    class DAOProposalAnalyzer:
        def analyze_proposal(self, title, description, dao_name=None):
            # Mock response for development
            class MockResult:
                def __init__(self):
                    self.likelihood_percentage = 75.0
                    self.likelihood_level = type('obj', (object,), {'value': 'High'})()
                    self.community_sentiment = type('obj', (object,), {'value': 'Positive'})()
                    self.reasoning = "Mock analysis for development"
                    self.risks = ["Development risk 1", "Development risk 2"]
                    self.opportunities = ["Development opportunity 1", "Development opportunity 2"]
                    self.confidence_score = 85.0
            return MockResult()

app = FastAPI(
    title="DAO Proposal AI Service",
    description="AI-powered DAO proposal analysis service for ICP",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS for ICP frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",  # Local React development
        "http://localhost:8000",  # ICP local
        "https://*.ic0.app",      # ICP mainnet
        "https://*.icp0.io",      # ICP alternative
        "*"  # For development - restrict in production
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

# Request/Response Models
class ProposalRequest(BaseModel):
    title: str
    description: str
    dao_name: Optional[str] = None

class AnalysisResponse(BaseModel):
    likelihood_percentage: float
    likelihood_level: str
    community_sentiment: str
    reasoning: str
    risks: List[str]
    opportunities: List[str]
    confidence_score: float
    processing_time: float
    data_sources_used: List[str]

# Initialize analyzer
analyzer = DAOProposalAnalyzer()

@app.post("/analyze", response_model=AnalysisResponse)
async def analyze_proposal(request: ProposalRequest):
    """Analyze a DAO proposal and return predictions"""
    start_time = time.time()
    
    try:
        # Use your existing Python analyzer
        result = analyzer.analyze_proposal(
            title=request.title, 
            description=request.description,
            dao_name=request.dao_name
        )
        
        processing_time = time.time() - start_time
        
        return AnalysisResponse(
            likelihood_percentage=result.likelihood_percentage,
            likelihood_level=result.likelihood_level.value,
            community_sentiment=result.community_sentiment.value,
            reasoning=result.reasoning,
            risks=result.risks,
            opportunities=result.opportunities,
            confidence_score=result.confidence_score,
            processing_time=processing_time,
            data_sources_used=["historical_data", "live_insights", "sentiment_analysis"]
        )
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Analysis failed: {str(e)}"
        )

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "DAO Proposal AI Service",
        "version": "1.0.0",
        "analyzer_ready": True
    }

@app.get("/")
async def root():
    """Root endpoint with service info"""
    return {
        "message": "DAO Proposal AI Service for ICP",
        "docs": "/docs",
        "health": "/health",
        "analyze": "/analyze"
    }

if __name__ == "__main__":
    uvicorn.run(
        app, 
        host="0.0.0.0", 
        port=int(os.getenv("PORT", 8000)),
        reload=True
    )