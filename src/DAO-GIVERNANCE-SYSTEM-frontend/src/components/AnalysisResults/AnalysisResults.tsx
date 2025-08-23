import React from 'react';
import { AnalysisResult } from '../../types/analysis';

interface AnalysisResultsProps {
  result: AnalysisResult;
  onNewAnalysis?: () => void;
}

export const AnalysisResults: React.FC<AnalysisResultsProps> = ({ result, onNewAnalysis }) => {
  const getLikelihoodColor = (level: string) => {
    switch (level) {
      case 'High': return 'text-green-700 bg-green-50 border-green-200';
      case 'Medium': return 'text-yellow-700 bg-yellow-50 border-yellow-200';
      case 'Low': return 'text-red-700 bg-red-50 border-red-200';
      default: return 'text-gray-700 bg-gray-50 border-gray-200';
    }
  };

  const getSentimentIcon = (sentiment: string) => {
    switch (sentiment) {
      case 'Positive': return '📈';
      case 'Negative': return '📉';
      default: return '➖';
    }
  };

  const getSentimentColor = (sentiment: string) => {
    switch (sentiment) {
      case 'Positive': return 'text-green-700 bg-green-50 border-green-200';
      case 'Negative': return 'text-red-700 bg-red-50 border-red-200';
      default: return 'text-gray-700 bg-gray-50 border-gray-200';
    }
  };

  return (
    <div className="bg-white rounded-lg shadow-lg overflow-hidden">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white p-6">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-2xl font-bold mb-2">📌 Analysis Results</h2>
            <p className="text-blue-100 text-lg">{result.proposal.title}</p>
          </div>
          {onNewAnalysis && (
            <button
              onClick={onNewAnalysis}
              className="bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-md transition-colors"
            >
              New Analysis
            </button>
          )}
        </div>
      </div>

      <div className="p-6 space-y-6">
        {/* Key Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className={`p-4 rounded-lg border-2 ${getLikelihoodColor(result.likelihood_level)}`}>
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-medium">Likelihood of Passing</span>
              <span>📊</span>
            </div>
            <div className="text-2xl font-bold">
              ✅ {result.likelihood_level} ({result.likelihood_percentage.toFixed(1)}%)
            </div>
          </div>

          <div className={`p-4 rounded-lg border-2 ${getSentimentColor(result.community_sentiment)}`}>
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-medium">Community Sentiment</span>
              <span>{getSentimentIcon(result.community_sentiment)}</span>
            </div>
            <div className="text-2xl font-bold">
              🎯 {result.community_sentiment}
            </div>
          </div>

          <div className="p-4 rounded-lg border-2 text-purple-700 bg-purple-50 border-purple-200">
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-medium">Confidence Score</span>
              <span>👥</span>
            </div>
            <div className="text-2xl font-bold">
              📈 {result.confidence_score.toFixed(1)}%
            </div>
          </div>
        </div>

        {/* Reasoning */}
        <div className="bg-gray-50 rounded-lg p-4">
          <h3 className="font-semibold text-gray-900 mb-3 flex items-center">
            <span className="mr-2">🕐</span>
            🔍 Reasoning
          </h3>
          <p className="text-gray-700 leading-relaxed">{result.reasoning}</p>
        </div>

        {/* Risks and Opportunities */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-red-50 rounded-lg p-4 border border-red-200">
            <h3 className="font-semibold text-red-800 mb-3 flex items-center">
              <span className="mr-2">⚠️</span>
              Risks
            </h3>
            <ul className="space-y-2">
              {result.risks.map((risk, index) => (
                <li key={index} className="text-red-700 flex items-start">
                  <span className="text-red-500 mr-2 mt-1">•</span>
                  <span>{risk}</span>
                </li>
              ))}
            </ul>
          </div>

          <div className="bg-green-50 rounded-lg p-4 border border-green-200">
            <h3 className="font-semibold text-green-800 mb-3 flex items-center">
              <span className="mr-2">💡</span>
              🚀 Opportunities
            </h3>
            <ul className="space-y-2">
              {result.opportunities.map((opportunity, index) => (
                <li key={index} className="text-green-700 flex items-start">
                  <span className="text-green-500 mr-2 mt-1">•</span>
                  <span>{opportunity}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* Additional Insights */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-blue-50 rounded-lg p-4 border border-blue-200">
            <h4 className="font-semibold text-blue-800 mb-2">📊 Historical Matches</h4>
            <p className="text-blue-700 text-sm">
              Found {result.historical_matches.length} similar proposals with relevant patterns
            </p>
          </div>

          <div className="bg-purple-50 rounded-lg p-4 border border-purple-200">
            <h4 className="font-semibold text-purple-800 mb-2">🌐 Live Insights</h4>
            <p className="text-purple-700 text-sm">
              Analyzed {result.live_insights.length} current market and community insights
            </p>
          </div>
        </div>

        {/* Market Context */}
        <div className="bg-gray-50 rounded-lg p-4 border border-gray-200">
          <h4 className="font-semibold text-gray-800 mb-3">📈 Market Context</h4>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
            <div>
              <span className="text-gray-600">Market Trend:</span>
              <p className="font-medium capitalize">{result.market_context.market_trend}</p>
            </div>
            <div>
              <span className="text-gray-600">DAO Activity:</span>
              <p className="font-medium">{(result.market_context.dao_activity_level * 100).toFixed(0)}%</p>
            </div>
            <div>
              <span className="text-gray-600">Participation:</span>
              <p className="font-medium">{(result.market_context.governance_participation * 100).toFixed(0)}%</p>
            </div>
            <div>
              <span className="text-gray-600">Recent Success:</span>
              <p className="font-medium">{(result.market_context.recent_proposals_success_rate * 100).toFixed(0)}%</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};