%%% @doc OTP application supervisor (minimal).
%%%
%%% Kept for OTP application compliance. The real supervision tree
%%% is app_snake_duel_sup, started by the plugin callback's init/1.
%%% @end
-module(hecate_app_snake_dueld_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {#{strategy => one_for_one, intensity => 10, period => 60}, []}}.
