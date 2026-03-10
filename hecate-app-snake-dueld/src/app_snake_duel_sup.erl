%%% @doc Top-level supervisor for the Snake Duel in-VM plugin.
%%%
%%% Supervises domain application supervisors:
%%%   - run_snake_duel_sup (CMD — duel lifecycle, game engine)
%%%   - query_snake_duel_sup (QRY — match history, leaderboard)
%%% @end
-module(app_snake_duel_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    SupFlags = #{strategy => one_for_one, intensity => 10, period => 60},
    Children = [
        #{id => query_snake_duel_sup,
          start => {query_snake_duel_sup, start_link, []},
          restart => permanent, type => supervisor},
        #{id => run_snake_duel_sup,
          start => {run_snake_duel_sup, start_link, []},
          restart => permanent, type => supervisor}
    ],
    {ok, {SupFlags, Children}}.
