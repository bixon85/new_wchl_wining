import { useState, useCallback } from 'react';
import { AnalysisResult } from '../types/analysis';
import { apiService } from '../services/api';

interface UseAnalysisReturn {
  analysis: AnalysisResult | null;
  loading: boolean;
  error: string | null;
  analyzeProposal: (title: string, description: string) => Promise<void>;
  clearAnalysis: () => void;
  clearError: () => void;
}

export const useAnalysis = (): UseAnalysisReturn => {
  const [analysis, setAnalysis] = useState<AnalysisResult | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const analyzeProposal = useCallback(async (title: string, description: string) => {
    setLoading(true);
    setError(null);
    
    try {
      const result = await apiService.analyzeProposal({
        title,
        description,
        options: {
          include_historical: true,
          include_live_insights: true,
          confidence_threshold: 0.7
        }
      });
      
      setAnalysis(result);
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Analysis failed';
      setError(errorMessage);
      console.error('Analysis error:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  const clearAnalysis = useCallback(() => {
    setAnalysis(null);
    setError(null);
  }, []);

  const clearError = useCallback(() => {
    setError(null);
  }, []);

  return {
    analysis,
    loading,
    error,
    analyzeProposal,
    clearAnalysis,
    clearError
  };
};