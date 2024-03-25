defmodule Specx.Application do
  use Application

  def start(_type, _args) do
    Supervisor.start_link(
      [{Specx.Registry, initial_specs: Specx.SpecProvider.initial_specs()}],
      strategy: :one_for_one,
      name: __MODULE__
    )
  end
end
