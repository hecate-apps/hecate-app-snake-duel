%%% @doc Snake Duel plugin callback module.
%%%
%%% Implements the hecate_plugin behaviour for in-VM loading.
%%% When loaded by hecate_plugin_loader, this module provides:
%%%   - Cowboy routes (mounted under /plugin/hecate-app-snake-duel/api/)
%%%   - Static dir (frontend assets at /plugin/hecate-app-snake-duel/)
%%%   - Plugin manifest
%%%
%%% Snake Duel does NOT use ReckonDB event sourcing — duels are ephemeral
%%% live games. Match results are recorded to SQLite for history/leaderboard.
%%% @end
-module(app_snake_duel).
-behaviour(hecate_plugin).

-include_lib("hecate_sdk/include/hecate_plugin.hrl").

-export([init/1, routes/0, store_config/0, static_dir/0, manifest/0]).

%% flag_maps/0 added in hecate_sdk 0.2.0
-export([flag_maps/0]).

-spec init(map()) -> {ok, map()} | {error, term()}.
init(#{plugin_name := PluginName, data_dir := DataDir} = Config) ->
    logger:info("[app-snake-duel] Initializing plugin ~s (data: ~s)",
                [PluginName, DataDir]),
    StoreId = maps:get(store_id, Config, none),
    persistent_term:put(app_snake_duel_config, #{
        plugin_name => PluginName,
        store_id => StoreId,
        data_dir => DataDir
    }),
    case app_snake_duel_sup:start_link() of
        {ok, Pid} ->
            logger:info("[app-snake-duel] Supervision tree started (~p)", [Pid]),
            {ok, #{sup_pid => Pid}};
        {error, {already_started, Pid}} ->
            logger:info("[app-snake-duel] Supervision tree already running (~p)", [Pid]),
            {ok, #{sup_pid => Pid}};
        {error, Reason} ->
            logger:error("[app-snake-duel] Failed to start supervision tree: ~p", [Reason]),
            {error, Reason}
    end.

-spec routes() -> [{string(), module(), term()}].
routes() ->
    [
        {"/matches", start_duel_api, []},
        {"/matches/:match_id/stream", stream_duel_api, []},
        {"/matches/:match_id/result", get_match_by_id_api, []},
        {"/leaderboard", get_leaderboard_api, []},
        {"/history", get_match_history_api, []}
    ].

-spec store_config() -> none.
store_config() ->
    none.  %% Duels are ephemeral — no event store needed

-spec static_dir() -> string() | none.
static_dir() ->
    "priv/static".

-spec manifest() -> map().
manifest() ->
    #{
        name => <<"hecate-app-snake-duel">>,
        display_name => <<"Snake Duel">>,
        version => <<"0.2.0">>,
        description => <<"AI vs AI Snake Duel Arena">>,
        icon => <<"snake">>,
        tag => <<"snake-duel-studio">>,
        min_sdk_version => <<"0.1.0">>
    }.

-spec flag_maps() -> #{binary() => evoq_bit_flags:flag_map()}.
flag_maps() ->
    #{}.  %% No event-sourced aggregates
