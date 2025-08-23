// Utility functions for formatting data in ICP React app

export const formatPercentage = (value: number, decimals: number = 1): string => {
  return `${value.toFixed(decimals)}%`;
};

export const formatDate = (dateString: string): string => {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });
};

export const formatNumber = (value: number, decimals: number = 0): string => {
  return value.toLocaleString('en-US', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals
  });
};

export const truncateText = (text: string, maxLength: number): string => {
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
};

export const capitalizeFirst = (str: string): string => {
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
};

export const getLikelihoodEmoji = (level: string): string => {
  switch (level) {
    case 'High': return '🟢';
    case 'Medium': return '🟡';
    case 'Low': return '🔴';
    default: return '⚪';
  }
};

export const getSentimentEmoji = (sentiment: string): string => {
  switch (sentiment) {
    case 'Positive': return '😊';
    case 'Negative': return '😟';
    default: return '😐';
  }
};