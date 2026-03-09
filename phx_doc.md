# Phoenix

## 1. Создание проекта

```bash
 mix phx.new - -binary-id name_project
```

Флаг --binary-id используется для того, чтобы во всем проекте в качестве первичных ключей (Primary Keys) в базе данных использовались UUID (уникальные идентификаторы), а не стандартные автоинкрементные целые числа (integers).

## 2. Создание файла с секретами

Создать файл с именем ".env"  (не забудь отправить файл ".env" в .gitignore) в корневой папке и установить туда пароли от БД. Чтобы это все подтягивалось нужно написать скрипт ".env.exs":

```elixir
defmodule EnvLoader do
    @moduledoc """
    Loads config variables from .env file
    """

    @env_file_path ".env"

    def load_env_vars do
        if File.exists?(@env_file_path) do
            File.read!(@env_file_path)
            |> String.split("\n", trim: true)
            |> Enum.filter(&(&1 != "" && !String.starts_with?(&1, "#")))
            |> Enum.map(fn line ->
                [key, value] = String.split(line, "=", parts: 2)
                {String.to_atom(String.trim(key)), String.trim(value)}
            end)
        else
            []
        end
    end
end

# Load the environment variables into a keyword list
env_vars = EnvLoader.load_env_vars()

# Set each variable if not already defined in the system
Enum.each(env_vars, fn {key, value} ->
    unless System.get_env(Atom.to_string(key)) do
        key |> Atom.to_string() |> System.put_env(value)
    end
end)
```

Скрипт будет подставлять пароль по ключу "=", для этого в файле config.exs написать следующее:

```elixir
#...
# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Указание для сборки :dev или :test использовать пароль из файла
if config_env() in [:dev, :test] do
  import_config ".env.exs"
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

```

И теперь нужно обновить конфигурации, для которых был вынесен пароль:

```elixir
#../config/dev.exs
#...
config :budgie, Budgie.Repo,
  username: "postgres",
  password: System.get_env("PG_PASS"),
  hostname: "localhost",
#...
```

## 3. Установка зависимостей

В файл mix.exs добавить:

```elixir
defp deps do
    [
      ...
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false}
    ]
  end
```

Credo следит за стилем и чистотой кода ($ mix credo), а Dialyxir — за логическими ошибками и типами данных($ mix dialyxir) .

```bash
mix setup
```

Команда подготовила проект, а имеено:

- Скачала зависимости (mix deps.get).
- Создала базу данных и запустила миграции (mix ecto.setup).
- Скомпилировала активы (Tailwind, JS).

## 4. Запуск сервера

```bash
mix phx.server
```

Если перейти на localhost4000/dev/dashboard/home - можно увидеть производительность. Работатет только в среде разработки.


We are almost there! The following steps are missing:

    $ cd budgie

Then configure your database in config/dev.exs and run:

    $ mix ecto.create


You can also run your app inside IEx (Interactive Elixir) as:

    $ iex -S mix phx.server