-module(cbtutorial_greeting_controller, [Req]).
-compile(export_all).

index('GET', []) ->
    Greetings = boss_db:find(greeting, []),
    {ok, [{greetings, Greetings}]}.

create('GET', []) ->
    NewGreeting = greeting:new(id, ""),
    {ok, [{new_greeting, NewGreeting}]};
create('POST', []) ->
    GreetingText = Req:post_param("greeting_text"),
    NewGreeting = greeting:new(id, GreetingText),
    case NewGreeting:save() of
        {ok, SavedGreeting} ->
            {redirect, [{action, "index"}]};
        {error, ErrorList} ->
            {ok, [{errors, ErrorList}, {new_greeting, NewGreeting}]}
    end.

destroy('POST', []) ->
    boss_db:delete(Req:post_param("greeting_id")),
    {redirect, [{action, "index"}]}.
