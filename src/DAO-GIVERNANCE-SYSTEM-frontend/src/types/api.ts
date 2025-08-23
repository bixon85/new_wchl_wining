// API-related types for ICP integration
export interface ApiEndpoints {
  analyze: string;
  history: string;
  insights: string;
  health: string;
}

export interface ApiConfig {
  baseUrl: string;
  timeout: number;
  retries: number;
}

export interface ApiError {
  code: string;
  message: string;
  details?: any;
  timestamp: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  has_next: boolean;
  has_prev: boolean;
}

export interface AnalysisRequest {
  title: string;
  description: string;
  dao_name?: string;
  options?: {
    include_historical?: boolean;
    include_live_insights?: boolean;
    confidence_threshold?: number;
  };
}

export interface AnalysisResponse {
  analysis_id: string;
  result: import('./analysis').AnalysisResult;
  processing_time: number;
  data_sources_used: string[];
  created_at: string;
}

// ICP-specific types
export interface ICPCanisterResponse<T> {
  Ok?: T;
  Err?: string;
}

export interface ICPAnalysisRequest {
  title: string;
  description: string;
  timestamp: bigint;
}