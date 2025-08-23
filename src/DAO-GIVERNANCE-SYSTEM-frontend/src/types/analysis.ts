// TypeScript types for DAO Analysis on ICP
export interface ProposalInput {
  title: string;
  description: string;
  dao_name?: string;
  timestamp?: string;
}

export interface HistoricalProposal {
  title: string;
  description: string;
  date: string;
  dao_name: string;
  voting_results: {
    approved: number;
    rejected: number;
    abstained: number;
  };
  outcome: 'passed' | 'failed';
  community_sentiment: string;
  similarity_score: number;
}

export interface LiveInsight {
  source: string;
  content: string;
  sentiment: 'Positive' | 'Neutral' | 'Negative';
  relevance_score: number;
  timestamp: string;
  url?: string;
}

export interface MarketContext {
  market_trend: 'bullish' | 'bearish' | 'neutral';
  dao_activity_level: number;
  governance_participation: number;
  recent_proposals_success_rate: number;
  community_engagement: number;
}

export interface AnalysisResult {
  proposal: ProposalInput;
  likelihood_percentage: number;
  likelihood_level: 'High' | 'Medium' | 'Low';
  community_sentiment: 'Positive' | 'Neutral' | 'Negative';
  reasoning: string;
  risks: string[];
  opportunities: string[];
  historical_matches: HistoricalProposal[];
  live_insights: LiveInsight[];
  market_context: MarketContext;
  confidence_score: number;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}