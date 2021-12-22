FROM elixir:latest

CMD echo "Test - we're in!"
WORKDIR elixir-app

COPY . .
# docker run -it elixir-env-1 iex

CMD ["elixir", "day-five/index.exs"]

