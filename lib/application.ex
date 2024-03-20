defmodule Spex.Application do
  use Application

  def start(_type, _args) do
    Supervisor.start_link(
      [Spex.Registry],
      strategy: :one_for_one,
      name: __MODULE__
    )
  end
end
