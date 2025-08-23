import React from 'react';
import { ProposalInput } from './components/ProposalInput';
import { AnalysisResults } from './components/AnalysisResults';
import { useAnalysis } from './hooks/useAnalysis';

function App() {
  const { analysis, loading, error, analyzeProposal, clearAnalysis } = useAnalysis();

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 text-blue-600">🧠</div>
              <div>
                <h1 className="text-2xl font-bold text-gray-900">
                  🏛️ DAO Governance Analyzer
                </h1>
                <p className="text-sm text-gray-600">
                  AI-powered proposal analysis with historical insights
                </p>
              </div>
            </div>

            <div className="flex items-center space-x-4">
              <a
                href="https://github.com/your-repo/dao-analyzer"
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center space-x-2 text-gray-600 hover:text-gray-900 transition-colors"
              >
                <span>📁</span>
                <span>GitHub</span>
              </a>
              <a
                href="/docs"
                className="flex items-center space-x-2 text-gray-600 hover:text-gray-900 transition-colors"
              >
                <span>📖</span>
                <span>Docs</span>
              </a>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="space-y-8">
          {/* Introduction */}
          {!analysis && !loading && (
            <div className="text-center">
              <h2 className="text-3xl font-bold text-gray-900 mb-4">
                Analyze Your DAO Proposal
              </h2>
              <p className="text-lg text-gray-600 max-w-3xl mx-auto">
                Get AI-powered insights by combining historical DAO proposal data with
                real-time market sentiment and community discussions.
              </p>
            </div>
          )}

          {/* Error Display */}
          {error && (
            <div className="bg-red-50 border border-red-200 rounded-lg p-4">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <span className="text-red-400">⚠️</span>
                </div>
                <div className="ml-3">
                  <h3 className="text-sm font-medium text-red-800">Analysis Error</h3>
                  <p className="text-sm text-red-700 mt-1">{error}</p>
                </div>
              </div>
            </div>
          )}

          {/* Input Form */}
          {!analysis && (
            <ProposalInput onSubmit={analyzeProposal} loading={loading} />
          )}

          {/* Loading State */}
          {loading && (
            <div className="bg-white rounded-lg shadow-lg p-8 text-center">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">
                🔍 Analyzing Your Proposal
              </h3>
              <p className="text-gray-600">
                Gathering historical data and live insights...
              </p>
            </div>
          )}

          {/* Results */}
          {analysis && (
            <AnalysisResults result={analysis} onNewAnalysis={clearAnalysis} />
          )}
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t mt-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div className="text-center text-gray-600">
            <p>
              Built with ❤️ for the DAO community •
              <a href="/privacy" className="ml-2 hover:text-gray-900">Privacy</a> •
              <a href="/terms" className="ml-2 hover:text-gray-900">Terms</a>
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default App;
