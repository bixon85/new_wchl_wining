import { AnalysisRequest, AnalysisResponse, ApiError, ICPCanisterResponse } from '../types/api';
import { AnalysisResult } from '../types/analysis';

class ApiService {
  private baseUrl: string;
  private timeout: number;

  constructor() {
    // For ICP, this would be your canister URL
    this.baseUrl = process.env.REACT_APP_API_URL || 'http://localhost:8000';
    this.timeout = 30000; // 30 seconds
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseUrl}${endpoint}`;
    
    const config: RequestInit = {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
    };

    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), this.timeout);

      const response = await fetch(url, {
        ...config,
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.message || `HTTP ${response.status}: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      if (error instanceof Error) {
        if (error.name === 'AbortError') {
          throw new Error('Request timeout - analysis is taking too long');
        }
        throw error;
      }
      throw new Error('Unknown error occurred');
    }
  }

  async analyzeProposal(request: AnalysisRequest): Promise<AnalysisResult> {
    // For now, this calls the external AI service
    // Later, this will call the ICP canister which then calls the AI service
    const response = await this.request<AnalysisResponse>('/analyze', {
      method: 'POST',
      body: JSON.stringify(request),
    });

    return response.result;
  }

  async getAnalysisHistory(page: number = 1, limit: number = 10) {
    return this.request(`/history?page=${page}&limit=${limit}`);
  }

  async healthCheck(): Promise<{ status: string; timestamp: string }> {
    return this.request('/health');
  }

  // ICP Canister integration methods (for future use)
  async connectToICP(canisterId: string) {
    // This will be implemented when migrating to ICP
    console.log('ICP integration not yet implemented', canisterId);
  }

  // Mock ICP canister call structure
  async callICPCanister<T>(method: string, args: any): Promise<ICPCanisterResponse<T>> {
    // This is a mock - replace with actual ICP agent calls
    try {
      const result = await this.analyzeProposal(args);
      return { Ok: result as T };
    } catch (error) {
      return { Err: error instanceof Error ? error.message : 'Unknown error' };
    }
  }
}

export const apiService = new ApiService();
export default apiService;