export const idlFactory = ({ IDL }) => {
  const Vote = IDL.Record({ 'legitimate' : IDL.Bool, 'fraudulent' : IDL.Bool });
  return IDL.Service({
    'addVote' : IDL.Func([IDL.Text, IDL.Bool, IDL.Bool], [IDL.Text], []),
    'checkVoteResult' : IDL.Func([IDL.Text], [IDL.Text], []),
    'clearAllVotes' : IDL.Func([], [IDL.Text], []),
    'clearCallVotes' : IDL.Func([IDL.Text], [IDL.Text], []),
    'getAllCallIds' : IDL.Func([], [IDL.Vec(IDL.Text)], ['query']),
    'getVotes' : IDL.Func([IDL.Text], [IDL.Opt(IDL.Vec(Vote))], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
