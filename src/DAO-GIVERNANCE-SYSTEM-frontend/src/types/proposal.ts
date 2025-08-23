// Proposal-specific types for ICP
export interface ProposalCategory {
  id: string;
  name: string;
  description: string;
  typical_success_rate: number;
}

export interface ProposalMetrics {
  title_length: number;
  description_length: number;
  complexity_score: number;
  clarity_score: number;
}

export interface VotingResults {
  approved: number;
  rejected: number;
  abstained: number;
  total_votes: number;
  approval_rate: number;
  participation_rate: number;
}

export interface ProposalTimeline {
  created_at: string;
  voting_start: string;
  voting_end: string;
  execution_date?: string;
  status: 'draft' | 'active' | 'passed' | 'failed' | 'executed';
}

export interface DAOInfo {
  name: string;
  token_symbol: string;
  total_members: number;
  active_voters: number;
  treasury_size: number;
  governance_type: 'token-weighted' | 'quadratic' | 'reputation-based';
}