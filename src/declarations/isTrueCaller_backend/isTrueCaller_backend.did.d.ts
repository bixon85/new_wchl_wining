import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Vote { 'legitimate' : boolean, 'fraudulent' : boolean }
export interface _SERVICE {
  'addVote' : ActorMethod<[string, boolean, boolean], string>,
  'checkVoteResult' : ActorMethod<[string], string>,
  'clearAllVotes' : ActorMethod<[], string>,
  'clearCallVotes' : ActorMethod<[string], string>,
  'getAllCallIds' : ActorMethod<[], Array<string>>,
  'getVotes' : ActorMethod<[string], [] | [Array<Vote>]>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
