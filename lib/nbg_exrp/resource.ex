defmodule NbgExrp.Resource do
  use Agent

  @me __MODULE__

  def start_link(initial_value \\ %{body: []}) do
    Agent.start_link(fn -> initial_value end, name: @me)
  end

  def data do
    Agent.get(@me, &(&1))
    #|> List.keyfind(:data, 0)
  end

  def update() do

  end
end
